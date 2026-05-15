import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

public class CleanProlog {
    public static void main(String[] args) throws Exception {
        String path = "c:\\Users\\Windows\\Desktop\\Final Project\\ai\\mealCraft.pl";
        String content = new String(Files.readAllBytes(Paths.get(path)));
        
        // Use a regular expression to match and remove all food(...) facts.
        String cleanContent = content.replaceAll("(?s)food\\([a-zA-Z0-9_]+,\\s*.*?\\)\\.", "");
        
        Files.write(Paths.get(path), cleanContent.getBytes(), StandardOpenOption.TRUNCATE_EXISTING);
        System.out.println("Cleaned mealCraft.pl");
    }
}
