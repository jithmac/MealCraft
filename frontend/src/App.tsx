import { useState } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { Sparkles, Utensils } from 'lucide-react'
import { ControlCenter } from '@/components/mealcraft/control-center'
import { MealStage } from '@/components/mealcraft/meal-stage'
import { MoodTracker } from '@/components/mealcraft/mood-tracker'
import { QuickOrder } from '@/components/mealcraft/quick-order'
import { StrongAvocado, ChefHat } from '@/components/mealcraft/food-characters'
import { AdminPanel } from '@/components/admin/AdminPanel'
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription } from '@/components/ui/dialog'

export interface UserPreferences {
  age: number
  weight: number
  height: number
  gender: 'male' | 'female'
  activityLevel: 'sedentary' | 'light' | 'moderate' | 'active' | 'very-active'
  diet: string
  healthConditions: string[]
  goal: 'normal' | 'diet' | 'bulk'
}

export interface FoodItem {
  name: string
  quantity: number
  amount: number
  calories: number
  costLkr?: number
}

export interface Meal {
  name: string
  calories: number
  carbs: number
  protein: number
  fat: number
  items: FoodItem[]
}

export interface MealPlan {
  breakfast: Meal
  lunch: Meal
  dinner: Meal
  totalCals: number
  totalCarbs: number
  totalProtein: number
  totalFat: number
}

const defaultPreferences: UserPreferences = {
  age: 25,
  weight: 70,
  height: 170,
  gender: 'male',
  activityLevel: 'moderate',
  diet: 'omnivore',
  healthConditions: [],
  goal: 'normal',
}

const sampleMealPlan: MealPlan = {
  breakfast: { name: 'Breakfast', calories: 450, carbs: 45, protein: 20, fat: 22, items: [] },
  lunch: { name: 'Lunch', calories: 620, carbs: 70, protein: 25, fat: 28, items: [] },
  dinner: { name: 'Dinner', calories: 580, carbs: 30, protein: 42, fat: 34, items: [] },
  totalCals: 1650,
  totalCarbs: 145,
  totalProtein: 87,
  totalFat: 84
}

function calculateBMR(prefs: UserPreferences): number {
  // Harris-Benedict Equation
  if (prefs.gender === 'male') {
    return 88.362 + (13.397 * prefs.weight) + (4.799 * prefs.height) - (5.677 * prefs.age)
  }
  return 447.593 + (9.247 * prefs.weight) + (3.098 * prefs.height) - (4.330 * prefs.age)
}

function calculateTDEE(prefs: UserPreferences): number {
  const bmr = calculateBMR(prefs)
  const multipliers = {
    'sedentary': 1.2,
    'light': 1.375,
    'moderate': 1.55,
    'active': 1.725,
    'very-active': 1.9,
  }
  return Math.round(bmr * multipliers[prefs.activityLevel])
}

export default function Root() {
  const [view, setView] = useState<'main' | 'admin'>('main')

  if (view === 'admin') {
    return <AdminPanel onBack={() => setView('main')} />
  }

  return <MainApp onAdminClick={() => setView('admin')} />
}

export function MainApp({ onAdminClick }: { onAdminClick: () => void }) {
  const [preferences, setPreferences] = useState<UserPreferences>(defaultPreferences)
  const [mealPlan, setMealPlan] = useState<MealPlan>(sampleMealPlan)
  const [isGenerating, setIsGenerating] = useState(false)
  const [hasGenerated, setHasGenerated] = useState(false)
  const [showMealPopup, setShowMealPopup] = useState(false)
  const [healthScore, setHealthScore] = useState(78)
  const [error, setError] = useState<string | null>(null)
  const [selectedMealForOrder, setSelectedMealForOrder] = useState<{meal: Meal, type: string} | null>(null)

  const recommendedCalories = calculateTDEE(preferences)

  const handleGenerate = async () => {
    setIsGenerating(true)
    setError(null)

    try {
      const response = await fetch('http://localhost:8080/api/mealplan/generate', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          age: preferences.age,
          weight: preferences.weight,
          height: preferences.height,
          gender: preferences.gender,
          activityLevel: preferences.activityLevel,
          budget: 0, // Ignored by backend
          diet: preferences.diet,
          healthConditions: preferences.healthConditions,
          goal: preferences.goal,
        }),
      })

      if (!response.ok) {
        const errData = await response.json().catch(() => null)
        throw new Error(errData?.message || `Server error: ${response.status}`)
      }

      const data = await response.json()

      // Map the backend response to the frontend MealPlan shape
      setMealPlan({
        breakfast: data.breakfast || { name: 'No breakfast', calories: 0, carbs: 0, protein: 0, fat: 0, items: [] },
        lunch: data.lunch || { name: 'No lunch', calories: 0, carbs: 0, protein: 0, fat: 0, items: [] },
        dinner: data.dinner || { name: 'No dinner', calories: 0, carbs: 0, protein: 0, fat: 0, items: [] },
        totalCals: data.totalCals || 0,
        totalCarbs: data.totalCarbs || 0,
        totalProtein: data.totalProtein || 0,
        totalFat: data.totalFat || 0,
      })

      setHasGenerated(true)
      setShowMealPopup(true)
      setHealthScore(Math.min(100, healthScore + Math.floor(Math.random() * 10)))
    } catch (err: any) {
      console.error('Meal plan generation failed:', err)
      setError(err.message || 'Failed to generate meal plan. Is the backend running?')
      setShowMealPopup(false)
    } finally {
      setIsGenerating(false)
    }
  }

  const handleSelectMeal = (meal: Meal, type: string) => {
    setSelectedMealForOrder({ meal, type })
    setShowMealPopup(false)
  }

  return (
    <div className="h-screen w-screen p-4 md:p-6">
      {/* Error Banner */}
      <AnimatePresence>
        {error && (
          <motion.div
            initial={{ opacity: 0, y: -20 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -20 }}
            className="fixed top-4 left-1/2 -translate-x-1/2 z-50 px-6 py-3 bg-destructive/90 text-destructive-foreground rounded-2xl shadow-lg backdrop-blur-sm max-w-lg text-sm font-medium"
          >
            {error}
            <button onClick={() => setError(null)} className="ml-3 underline opacity-80 hover:opacity-100">Dismiss</button>
          </motion.div>
        )}
      </AnimatePresence>
      {/* Floating Characters Layer */}
      <div className="fixed inset-0 pointer-events-none z-10">
        <AnimatePresence>
          {isGenerating && (
            <motion.div
              initial={{ x: -100, opacity: 0 }}
              animate={{ x: '100vw', opacity: 1 }}
              exit={{ opacity: 0 }}
              transition={{ duration: 3, ease: 'easeInOut' }}
              className="absolute top-1/2 -translate-y-1/2"
            >
              <ChefHat isActive />
            </motion.div>
          )}
        </AnimatePresence>
      </div>

      {/* Main Bento Grid */}
      <div className="h-full grid grid-cols-1 lg:grid-cols-12 grid-rows-[auto_1fr_auto] lg:grid-rows-1 gap-4 md:gap-6 max-w-[1800px] mx-auto">
        {/* Left Column - Control Center */}
        <motion.div
          layout
          className={`${hasGenerated ? 'lg:col-span-3' : 'lg:col-span-5'} lg:row-span-1`}
          initial={{ x: -50, opacity: 0 }}
          animate={{ x: 0, opacity: 1 }}
          transition={{ type: 'spring', stiffness: 300, damping: 30 }}
        >
          <div className="h-full flex flex-col bg-card/70 backdrop-blur-xl rounded-[2rem] border border-border/50 shadow-xl p-6 overflow-hidden">
            <div className="flex items-center gap-3 mb-6 shrink-0">
              <div className="w-10 h-10 rounded-2xl bg-primary/20 flex items-center justify-center">
                <Utensils className="w-5 h-5 text-primary" />
              </div>
              <div>
                <h1 className="font-fredoka text-xl font-semibold text-foreground">MealCraft</h1>
                <p className="text-xs text-muted-foreground">AI Smart Planner</p>
              </div>
            </div>

            <div className="flex-1 min-h-0">
              <ControlCenter
                preferences={preferences}
                onPreferencesChange={setPreferences}
                recommendedCalories={recommendedCalories}
                onGenerate={handleGenerate}
                isGenerating={isGenerating}
                isShrunk={hasGenerated}
                onEdit={() => setHasGenerated(false)}
              />
            </div>
          </div>
        </motion.div>

        {/* Center Column - Meal Stage */}
        <motion.div
          layout
          className={`${hasGenerated ? 'lg:col-span-6' : 'lg:col-span-4'} lg:row-span-1`}
          initial={{ y: 50, opacity: 0 }}
          animate={{ y: 0, opacity: 1 }}
          transition={{ type: 'spring', stiffness: 300, damping: 30 }}
        >
          <div className="h-full bg-card/60 backdrop-blur-xl rounded-[2rem] border border-border/50 shadow-xl p-6 relative overflow-hidden">
            {/* Decorative gradient */}
            <div className="absolute inset-0 bg-gradient-to-br from-primary/5 via-transparent to-accent/5 pointer-events-none" />

            <div className="relative z-10 h-full flex flex-col">
              <div className="flex items-center justify-between mb-4">
                <div>
                  <h2 className="font-fredoka text-2xl font-semibold text-foreground">{"Today's Menu"}</h2>
                  <p className="text-sm text-muted-foreground">Personalized for your goals</p>
                </div>
                <button onClick={onAdminClick} className="text-xs font-medium text-muted-foreground hover:text-primary transition-colors border border-border/50 bg-background rounded-lg px-3 py-1.5 shadow-sm">
                  Admin Panel
                </button>
              </div>

              {!hasGenerated && !isGenerating ? (
                <MealStage
                  mealPlan={mealPlan}
                  isGenerating={isGenerating}
                  recommendedCalories={recommendedCalories}
                  isShrunk={true}
                  onSelectMeal={handleSelectMeal}
                />
              ) : (
                <div className="flex-1 flex flex-col items-center justify-center h-full p-4">
                  <motion.div
                    initial={{ opacity: 0, scale: 0.9 }}
                    animate={{ opacity: 1, scale: 1 }}
                    className="text-center p-8 bg-card/40 backdrop-blur-sm border border-border/20 rounded-[2rem] max-w-sm shadow-sm"
                  >
                    <div className="w-16 h-16 rounded-3xl bg-accent/10 flex items-center justify-center mx-auto mb-5">
                      <Sparkles className="w-8 h-8 text-accent" />
                    </div>
                    <h3 className="font-fredoka text-xl font-semibold mb-3">
                      {isGenerating ? "Crafting your menu..." : "Menu Generated!"}
                    </h3>
                    <p className="text-sm text-muted-foreground leading-relaxed mb-6">
                      {isGenerating ? "Please wait while we craft your perfect day of eating." : "Your personalized meal plan is ready."}
                    </p>
                    {!isGenerating && (
                      <button
                        onClick={() => setShowMealPopup(true)}
                        className="px-6 py-2.5 rounded-xl bg-primary text-primary-foreground font-semibold shadow-lg hover:shadow-xl transition-shadow text-sm w-full"
                      >
                        View Full Meal Plan
                      </button>
                    )}
                  </motion.div>
                </div>
              )}
            </div>
          </div>
        </motion.div>

        {/* Right Column - Mood + Quick Order */}
        <motion.div
          layout
          className="lg:col-span-3 lg:row-span-1 flex flex-col gap-4 md:gap-6"
          initial={{ x: 50, opacity: 0 }}
          animate={{ x: 0, opacity: 1 }}
          transition={{ type: 'spring', stiffness: 300, damping: 30 }}
        >
          {/* Mood Tracker */}
          <div className="flex-1 bg-card/70 backdrop-blur-xl rounded-[2rem] border border-border/50 shadow-xl p-6 overflow-hidden">
            <MoodTracker healthScore={healthScore} />
          </div>

          {/* Quick Order */}
          <div className="flex-1 bg-card/70 backdrop-blur-xl rounded-[2rem] border border-border/50 shadow-xl p-6 overflow-hidden relative">
            <QuickOrder selectedMeal={selectedMealForOrder} budget={20000} onOrderSuccess={() => setSelectedMealForOrder(null)} />
          </div>
        </motion.div>
      </div>

      {/* Meal Plan Popup */}
      <Dialog open={showMealPopup} onOpenChange={setShowMealPopup}>
        <DialogContent className="w-[95vw] !max-w-7xl h-[90vh] sm:h-[85vh] p-0 border-border/50 bg-card/95 backdrop-blur-xl rounded-[2rem] overflow-hidden flex flex-col shadow-2xl">
          <DialogHeader className="p-6 pb-4 border-b border-border/30 bg-background/50 flex flex-row items-center justify-between">
            <div>
              <DialogTitle className="font-fredoka text-2xl font-semibold text-foreground">{"Today's Menu"}</DialogTitle>
              <DialogDescription className="text-sm text-muted-foreground">Personalized for your goals</DialogDescription>
            </div>
            <motion.button
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
              onClick={handleGenerate}
              disabled={isGenerating}
              className="px-4 py-2 bg-secondary text-secondary-foreground rounded-xl text-sm font-medium hover:bg-secondary/80 transition-colors shadow-sm disabled:opacity-50 flex items-center gap-2"
            >
              <Sparkles className="w-4 h-4" />
              {isGenerating ? 'Regenerating...' : 'Regenerate'}
            </motion.button>
          </DialogHeader>
          <div className="flex-1 overflow-hidden p-6 bg-background/20">
            <MealStage
              mealPlan={mealPlan}
              isGenerating={isGenerating}
              recommendedCalories={recommendedCalories}
              isShrunk={false}
              onSelectMeal={handleSelectMeal}
            />
          </div>
        </DialogContent>
      </Dialog>
    </div>
  )
}
