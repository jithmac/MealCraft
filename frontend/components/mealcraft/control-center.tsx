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
  diet: string
  healthConditions: string[]
  goal: 'normal' | 'diet' | 'bulk'
  knowsCalories: boolean
  exactCalories?: number
  budget: number
}

interface ControlCenterProps {
  preferences: UserPreferences
  onPreferencesChange: (prefs: UserPreferences) => void
  recommendedCalories: number
  onGenerate: () => void
  isGenerating: boolean
  isShrunk?: boolean
  onEdit?: () => void
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
  isGenerating,
  isShrunk,
  onEdit
}: ControlCenterProps) {
  const updatePreferences = (updates: Partial<UserPreferences>) => {
    onPreferencesChange({ ...preferences, ...updates })
  }

  const toggleHealthCondition = (condition: string) => {
    const current = preferences.healthConditions || []
    if (current.includes(condition)) {
      updatePreferences({ healthConditions: current.filter(c => c !== condition) })
    } else {
      updatePreferences({ healthConditions: [...current, condition] })
    }
  }

  if (isShrunk) {
    return (
      <motion.div 
        initial={{ opacity: 0, scale: 0.9 }}
        animate={{ opacity: 1, scale: 1 }}
        exit={{ opacity: 0, scale: 0.9 }}
        className="flex flex-col h-full items-center justify-center text-center p-4"
      >
        <div className="w-16 h-16 rounded-full bg-primary/10 flex items-center justify-center mb-4">
          <Calculator className="w-8 h-8 text-primary" />
        </div>
        <h3 className="font-fredoka text-xl font-semibold mb-2">Preferences Set</h3>
        <p className="text-base text-muted-foreground mb-6 leading-relaxed">
          Daily Goal: <span className="font-bold text-foreground">{recommendedCalories} kcal</span><br/>
          Diet: <span className="font-bold text-foreground">{preferences.diet.replace('_', ' ')}</span>
        </p>
        <motion.button
          whileHover={{ scale: 1.05 }}
          whileTap={{ scale: 0.95 }}
          onClick={onEdit}
          className="px-6 py-2 rounded-xl bg-secondary text-secondary-foreground font-semibold text-sm hover:bg-secondary/80 transition-colors shadow-sm"
        >
          Edit Preferences
        </motion.button>
      </motion.div>
    )
  }

  return (
    <div className="flex flex-col h-full">
      {/* Header */}
      <div className="mb-4">
        <h2 className="font-fredoka text-xl font-bold text-foreground flex items-center gap-2">
          <Calculator className="w-5 h-5 text-primary" />
          Control Center
        </h2>
        <p className="text-base text-muted-foreground mt-1 font-medium">
          Enter your details below to generate a personalized meal plan.
        </p>
      </div>

      <div className="flex-1 space-y-4 overflow-y-auto pr-2 custom-scrollbar">
        <div className="flex items-center justify-between p-3 rounded-xl bg-primary/10 border border-primary/20">
          <Label htmlFor="knowsCalories" className="text-sm font-semibold cursor-pointer text-primary">
            I know my exact calorie target
          </Label>
          <Switch
            id="knowsCalories"
            checked={preferences.knowsCalories}
            onCheckedChange={(c) => updatePreferences({ knowsCalories: c })}
          />
        </div>

        {preferences.knowsCalories ? (
          <div className="space-y-3">
            <h3 className="text-sm font-semibold text-muted-foreground uppercase tracking-wider flex items-center gap-2">
              <Flame className="w-4 h-4 text-primary" />
              Target Calories
            </h3>
            <div className="space-y-1">
              <Label htmlFor="exactCalories" className="text-sm flex items-center gap-1">
                Daily Goal <span className="text-muted-foreground">(kcal)</span>
              </Label>
              <Input
                id="exactCalories"
                type="number"
                value={preferences.exactCalories || 0}
                onChange={(e) => updatePreferences({ exactCalories: parseInt(e.target.value) || 0 })}
                className="h-10 bg-card/50 border-border/50 rounded-xl text-base font-bold text-primary"
              />
            </div>
          </div>
        ) : (
          <div className="space-y-3">
          <h3 className="text-sm font-semibold text-muted-foreground uppercase tracking-wider flex items-center gap-2">
            <User className="w-4 h-4" />
            Personal Info
          </h3>
          
          <div className="grid grid-cols-2 gap-2">
            <div className="space-y-1">
              <Label htmlFor="age" className="text-sm">Age</Label>
              <Input
                id="age"
                type="number"
                value={preferences.age}
                onChange={(e) => updatePreferences({ age: parseInt(e.target.value) || 0 })}
                className="h-10 bg-card/50 border-border/50 rounded-xl text-base"
              />
            </div>
            <div className="space-y-1">
              <Label htmlFor="gender" className="text-sm">Gender</Label>
              <Select value={preferences.gender} onValueChange={(v) => updatePreferences({ gender: v as "male" | "female" })}>
                <SelectTrigger className="h-10 bg-card/50 border-border/50 rounded-xl text-base">
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
              <Label htmlFor="weight" className="text-sm flex items-center gap-1">
                Weight <span className="text-muted-foreground">(kg)</span>
              </Label>
              <Input
                id="weight"
                type="number"
                value={preferences.weight}
                onChange={(e) => updatePreferences({ weight: parseInt(e.target.value) || 0 })}
                className="h-10 bg-card/50 border-border/50 rounded-xl text-base"
              />
            </div>
            <div className="space-y-1">
              <Label htmlFor="height" className="text-sm flex items-center gap-1">
                <Ruler className="w-4 h-4" />
                Height <span className="text-muted-foreground">(cm)</span>
              </Label>
              <Input
                id="height"
                type="number"
                value={preferences.height}
                onChange={(e) => updatePreferences({ height: parseInt(e.target.value) || 0 })}
                className="h-10 bg-card/50 border-border/50 rounded-xl text-base"
              />
            </div>
          </div>

          <div className="space-y-1">
            <Label className="text-sm flex items-center gap-1">
              <Activity className="w-4 h-4" />
              Activity Level
            </Label>
            <Select 
              value={preferences.activityLevel} 
              onValueChange={(v) => updatePreferences({ activityLevel: v as UserPreferences['activityLevel'] })}
            >
              <SelectTrigger className="h-10 bg-card/50 border-border/50 rounded-xl text-base">
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
        )}

        {/* Diet */}
        <div className="space-y-2 pt-2">
          <h3 className="text-sm font-semibold text-muted-foreground uppercase tracking-wider flex items-center gap-2">
            <Leaf className="w-4 h-4 text-primary" />
            Diet Type
          </h3>
          <Select 
            value={preferences.diet} 
            onValueChange={(v) => updatePreferences({ diet: v })}
          >
            <SelectTrigger className="h-10 bg-card/50 border-border/50 rounded-xl text-base">
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              {[
                { value: "omnivore", label: "Omnivore (Any)" },
                { value: "vegetarian", label: "Vegetarian" },
                { value: "vegan", label: "Vegan" },
                { value: "pescatarian", label: "Pescatarian" },
                { value: "halal", label: "Halal" },
                { value: "gluten_free", label: "Gluten-Free" },
                { value: "low_carb", label: "Low Carb" },
                { value: "diabetic_friendly", label: "Diabetic Friendly" },
                { value: "high_protein", label: "High Protein" },
              ].map((d) => (
                <SelectItem key={d.value} value={d.value}>{d.label}</SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>

        {/* Budget */}
        <div className="space-y-2 pt-2">
          <h3 className="text-sm font-semibold text-muted-foreground uppercase tracking-wider flex items-center gap-2">
            <Banknote className="w-4 h-4 text-primary" />
            Daily Budget (LKR)
          </h3>
          <div className="flex items-center gap-4 bg-card/30 p-3 rounded-xl border border-border/20">
            <Slider
              value={[preferences.budget || 2000]}
              min={500}
              max={15000}
              step={500}
              onValueChange={([v]) => updatePreferences({ budget: v })}
              className="flex-1 cursor-pointer"
            />
            <span className="font-bold text-primary w-16 text-right font-fredoka">{preferences.budget || 2000}</span>
          </div>
        </div>

        {/* Goal */}
        {!preferences.knowsCalories && (
        <div className="space-y-2 pt-2">
          <h3 className="text-sm font-semibold text-muted-foreground uppercase tracking-wider flex items-center gap-2">
            <Flame className="w-4 h-4 text-primary" />
            Your Goal
          </h3>
          <Select 
            value={preferences.goal || 'normal'} 
            onValueChange={(v) => updatePreferences({ goal: v as UserPreferences['goal'] })}
          >
            <SelectTrigger className="h-10 bg-card/50 border-border/50 rounded-xl text-base">
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="normal">Normal (Maintain Weight)</SelectItem>
              <SelectItem value="diet">Diet (Cut / Lose Weight)</SelectItem>
              <SelectItem value="bulk">Bulk (Build Muscle / Gain Weight)</SelectItem>
            </SelectContent>
          </Select>
        </div>
        )}

        {/* Health Conditions */}
        <div className="space-y-2 pt-2">
          <h3 className="text-sm font-semibold text-muted-foreground uppercase tracking-wider flex items-center gap-2">
            <Activity className="w-4 h-4 text-destructive" />
            Health Conditions
          </h3>
          <div className="space-y-2">
            {[
              { key: "overweight", label: "Overweight / Obesity" },
              { key: "diabetes", label: "Diabetes" },
              { key: "hypertension", label: "Hypertension" },
              { key: "heart_disease", label: "Heart Disease" },
              { key: "kidney_disease", label: "Kidney Disease" },
              { key: "gout", label: "Gout" },
              { key: "celiac", label: "Celiac Disease" },
              { key: "lactose_intolerance", label: "Lactose Intolerance" },
              { key: "ibs", label: "IBS" },
              { key: "pregnancy", label: "Pregnancy" }
            ].map((cond) => (
              <div key={cond.key} className="flex items-center justify-between p-3 rounded-xl bg-card/30 hover:bg-card/50 transition-colors">
                <Label htmlFor={cond.key} className="text-sm cursor-pointer">
                  {cond.label}
                </Label>
                <Switch
                  id={cond.key}
                  checked={(preferences.healthConditions || []).includes(cond.key)}
                  onCheckedChange={() => toggleHealthCondition(cond.key)}
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
