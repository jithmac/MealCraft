import { motion } from "framer-motion"
import { Slider } from "@/components/ui/slider"
import { Switch } from "@/components/ui/switch"
import { Label } from "@/components/ui/label"
import { Input } from "@/components/ui/input"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { 
  Calculator, 
  Banknote, 
  Leaf, 
  Flame, 
  User, 
  Ruler,
  Activity
} from "lucide-react"

interface UserPreferences {
  age: number
  weight: number
  height: number
  gender: 'male' | 'female'
  activityLevel: 'sedentary' | 'light' | 'moderate' | 'active' | 'very-active'
  budget: number
  dietaryRestrictions: string[]
}

interface ControlCenterProps {
  preferences: UserPreferences
  onPreferencesChange: (prefs: UserPreferences) => void
  recommendedCalories: number
  onGenerate: () => void
  isGenerating: boolean
}

const activityLevels = [
  { value: "sedentary", label: "Sedentary" },
  { value: "light", label: "Light Active" },
  { value: "moderate", label: "Moderate" },
  { value: "active", label: "Very Active" },
  { value: "very-active", label: "Extra Active" },
]

export function ControlCenter({ 
  preferences, 
  onPreferencesChange, 
  recommendedCalories,
  onGenerate,
  isGenerating
}: ControlCenterProps) {
  const updatePreferences = (updates: Partial<UserPreferences>) => {
    onPreferencesChange({ ...preferences, ...updates })
  }

  const toggleDietaryRestriction = (restriction: string) => {
    const current = preferences.dietaryRestrictions
    if (current.includes(restriction)) {
      updatePreferences({ dietaryRestrictions: current.filter(r => r !== restriction) })
    } else {
      updatePreferences({ dietaryRestrictions: [...current, restriction] })
    }
  }

  return (
    <div className="flex flex-col h-full">
      {/* Header */}
      <div className="mb-4">
        <h2 className="font-fredoka text-xl font-bold text-foreground flex items-center gap-2">
          <Calculator className="w-5 h-5 text-primary" />
          Control Center
        </h2>
        <p className="text-xs text-muted-foreground mt-1">
          Customize your meal plan
        </p>
      </div>

      <div className="flex-1 space-y-4 overflow-y-auto pr-2 custom-scrollbar">
        {/* Personal Info Section */}
        <div className="space-y-3">
          <h3 className="text-xs font-semibold text-muted-foreground uppercase tracking-wider flex items-center gap-2">
            <User className="w-3 h-3" />
            Personal Info
          </h3>
          
          <div className="grid grid-cols-2 gap-2">
            <div className="space-y-1">
              <Label htmlFor="age" className="text-xs">Age</Label>
              <Input
                id="age"
                type="number"
                value={preferences.age}
                onChange={(e) => updatePreferences({ age: parseInt(e.target.value) || 0 })}
                className="h-8 bg-card/50 border-border/50 rounded-xl text-sm"
              />
            </div>
            <div className="space-y-1">
              <Label htmlFor="gender" className="text-xs">Gender</Label>
              <Select value={preferences.gender} onValueChange={(v) => updatePreferences({ gender: v as "male" | "female" })}>
                <SelectTrigger className="h-8 bg-card/50 border-border/50 rounded-xl text-sm">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="male">Male</SelectItem>
                  <SelectItem value="female">Female</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>

          <div className="grid grid-cols-2 gap-2">
            <div className="space-y-1">
              <Label htmlFor="weight" className="text-xs flex items-center gap-1">
                Weight <span className="text-muted-foreground">(kg)</span>
              </Label>
              <Input
                id="weight"
                type="number"
                value={preferences.weight}
                onChange={(e) => updatePreferences({ weight: parseInt(e.target.value) || 0 })}
                className="h-8 bg-card/50 border-border/50 rounded-xl text-sm"
              />
            </div>
            <div className="space-y-1">
              <Label htmlFor="height" className="text-xs flex items-center gap-1">
                <Ruler className="w-3 h-3" />
                Height <span className="text-muted-foreground">(cm)</span>
              </Label>
              <Input
                id="height"
                type="number"
                value={preferences.height}
                onChange={(e) => updatePreferences({ height: parseInt(e.target.value) || 0 })}
                className="h-8 bg-card/50 border-border/50 rounded-xl text-sm"
              />
            </div>
          </div>

          <div className="space-y-1">
            <Label className="text-xs flex items-center gap-1">
              <Activity className="w-3 h-3" />
              Activity Level
            </Label>
            <Select 
              value={preferences.activityLevel} 
              onValueChange={(v) => updatePreferences({ activityLevel: v as UserPreferences['activityLevel'] })}
            >
              <SelectTrigger className="h-8 bg-card/50 border-border/50 rounded-xl text-sm">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                {activityLevels.map((level) => (
                  <SelectItem key={level.value} value={level.value}>
                    {level.label}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          {/* Recommended calories display */}
          <motion.div 
            className="p-2 rounded-xl bg-primary/10 border border-primary/20"
            animate={{ scale: [1, 1.01, 1] }}
            transition={{ duration: 2, repeat: Infinity }}
          >
            <p className="text-xs text-muted-foreground">Recommended Daily Intake</p>
            <p className="text-xl font-bold text-primary font-fredoka">{recommendedCalories} kcal</p>
          </motion.div>
        </div>

        {/* Budget */}
        <div className="space-y-2">
          <h3 className="text-xs font-semibold text-muted-foreground uppercase tracking-wider flex items-center gap-2">
            <Banknote className="w-3 h-3 text-chart-2" />
            Weekly Budget
          </h3>
          <div className="space-y-2">
            <div className="flex justify-between items-center">
              <span className="text-xs text-muted-foreground">Amount</span>
              <span className="text-base font-bold text-foreground font-fredoka">Rs. {preferences.budget}</span>
            </div>
            <Slider
              value={[preferences.budget]}
              onValueChange={([v]) => updatePreferences({ budget: v })}
              min={2000}
              max={20000}
              step={500}
              className="py-1"
            />
            <div className="flex justify-between text-xs text-muted-foreground">
              <span>Rs. 2000</span>
              <span>Rs. 20000</span>
            </div>
          </div>
        </div>

        {/* Dietary Preferences */}
        <div className="space-y-2">
          <h3 className="text-xs font-semibold text-muted-foreground uppercase tracking-wider flex items-center gap-2">
            <Leaf className="w-3 h-3 text-primary" />
            Dietary Preferences
          </h3>
          <div className="space-y-2">
            {[
              { key: "vegetarian", label: "Vegetarian" },
              { key: "vegan", label: "Vegan" },
              { key: "gluten-free", label: "Gluten-Free" },
              { key: "dairy-free", label: "Dairy-Free" },
            ].map((pref) => (
              <div key={pref.key} className="flex items-center justify-between p-2 rounded-xl bg-card/30 hover:bg-card/50 transition-colors">
                <Label htmlFor={pref.key} className="text-xs cursor-pointer">
                  {pref.label}
                </Label>
                <Switch
                  id={pref.key}
                  checked={preferences.dietaryRestrictions.includes(pref.key)}
                  onCheckedChange={() => toggleDietaryRestriction(pref.key)}
                />
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Footer */}
      <div className="pt-3 mt-3 border-t border-border/30">
        <motion.button
          whileHover={{ scale: 1.02 }}
          whileTap={{ scale: 0.98 }}
          onClick={onGenerate}
          disabled={isGenerating}
          className="w-full py-2.5 rounded-2xl bg-primary text-primary-foreground font-semibold shadow-lg hover:shadow-xl transition-shadow disabled:opacity-50 text-sm"
        >
          {isGenerating ? 'Generating...' : 'Generate Meal Plan'}
        </motion.button>
      </div>
    </div>
  )
}
