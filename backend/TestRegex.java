import java.util.regex.*;

public class TestRegex {
    public static void main(String[] args) {
        String planStr = "plan([item(egg_boiled,3),item(cucumber_raw,1),item(plain_ceylon_tea,1)],[item(brown_rice_cooked,1),item(chicken_breast,2),item(broccoli_steamed,2),item(gotu_kola_mallung,1)],[item(sweet_potato_baked,1),item(salmon,1),item(spinach_cooked,1),item(tomato_raw,1)])";
        Matcher m = Pattern.compile("plan\\(\\[(.*?)\\],\\s*\\[(.*?)\\],\\s*\\[(.*?)\\]\\)").matcher(planStr);
        if (m.find()) {
            System.out.println("Match! 1: " + m.group(1));
        } else {
            System.out.println("No match!");
        }
    }
}
