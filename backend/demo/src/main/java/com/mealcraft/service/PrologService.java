package com.mealcraft.service;

import com.mealcraft.dto.MealRequest;
import com.mealcraft.dto.MealResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.*;
import java.nio.file.Files;
import java.util.Arrays;
import java.util.List;

@Service
public class PrologService {

    @Value("${mealcraft.prolog.path:gprolog}")
    private String prologPath;

    public MealResponse generateMeal(MealRequest request) {
        File queryFile = null;
        // declare kbPath up front so it’s visible throughout the method
        String kbPath = null;
        org.springframework.core.io.ClassPathResource resource = null;

        try {
            // Try to load prolog/mealCraft.pl. If that fails, try Prolog/mealCraft.pl
            try {
                resource = new org.springframework.core.io.ClassPathResource("prolog/mealCraft.pl");
                kbPath = resource.getFile().getAbsolutePath().replace("\\", "/");
            } catch (Exception ex) {
                resource = new org.springframework.core.io.ClassPathResource("Prolog/mealCraft.pl");
                kbPath = resource.getFile().getAbsolutePath().replace("\\", "/");
            }

            // Throw an error if neither file was found
            if (kbPath == null) {
                throw new RuntimeException("Knowledge base file not found");
            }

            String diet = sanitize(request.getDiet());
            String health = sanitize(request.getHealth());
            int maxCal = request.getTargetCalories() + 150;
            int maxBudget = request.getBudget();

            // Write query file
            String queryContent = String.format(
                    "main :-\n" +
                            "    (   build_meal(%s,%s,%s,Meal,Calories,Cost),\n" +
                            "        Calories =< %d,\n" +
                            "        Cost =< %d\n" +
                            "    ->  write(Meal), write('|'), write(Calories), write('|'), write(Cost), nl\n" +
                            "    ;   write('NO_MEAL_FOUND'), nl\n" +
                            "    ),\n" +
                            "    halt.\n\n" +
                            ":- main.\n",
                    request.getMealType().toLowerCase(), diet, health, maxCal, maxBudget
            );

            queryFile = File.createTempFile("mc_query_", ".pl");
            Files.writeString(queryFile.toPath(), queryContent);

            ProcessBuilder pb = new ProcessBuilder(
                    prologPath,
                    "--quiet",
                    "--consult-file", kbPath,
                    "--consult-file", queryFile.getAbsolutePath()
            );
            pb.redirectErrorStream(true);
            Process process = pb.start();

            // Close stdin immediately (ensures gprolog isn’t waiting for interactive input)
            process.getOutputStream().close();

            // Read process output
            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            StringBuilder output = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                output.append(line).append("\n");
            }

            boolean finished = process.waitFor(15, java.util.concurrent.TimeUnit.SECONDS);
            if (!finished) {
                process.destroyForcibly();
                throw new RuntimeException("Prolog timed out");
            }

            String result = output.toString();
            return parsePrologOutput(request.getMealType(), result);

        } catch (IOException io) {
            // If the Prolog engine is not available, fall back to Java logic
            return fallbackGenerateMeal(request, kbPath);
        } catch (RuntimeException e) {
            throw e;
        } catch (Exception e) {
            throw new RuntimeException("Error running Prolog: " + e.getMessage(), e);
        } finally {
            if (queryFile != null) {
                queryFile.delete();
            }
        }
    }

    private String sanitize(String input) {
        if (input == null || input.isBlank() || input.equalsIgnoreCase("none")) return "none";
        return input.toLowerCase().replace("-", "_");
    }

    private MealResponse parsePrologOutput(String mealType, String output) {
        if (output == null || output.isBlank() || output.contains("NO_MEAL_FOUND")) {
            throw new RuntimeException("No meal plan found. Try increasing budget or calories.");
        }
        for (String line : output.split("\n")) {
            line = line.trim();
            if (line.startsWith("[") && line.contains("|")) {
                int s = line.indexOf("[");
                int e = line.indexOf("]");
                if (s == -1 || e == -1) continue;
                String mealList = line.substring(s + 1, e);
                String[] parts = line.substring(e + 2).split("\\|");
                int calories = Integer.parseInt(parts[0].trim());
                int cost = Integer.parseInt(parts[1].trim());
                return new MealResponse(mealType, Arrays.asList(mealList.split(",")), calories, cost);
            }
        }
        throw new RuntimeException("No meal plan found. Try increasing budget or calories.");
    }

    // A simple fallback that uses the knowledge base directly from Java if the Prolog interpreter isn’t available
    private MealResponse fallbackGenerateMeal(MealRequest request, String kbPath) {
        // (example fallback logic – adapt this as needed)
        throw new RuntimeException("Prolog interpreter not available and fallback logic not implemented.");
    }
}