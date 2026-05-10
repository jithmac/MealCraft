import { motion, AnimatePresence } from "framer-motion"
import { HappyToast, SaladBowl, HappySteak } from "./food-characters"
import { Coffee, Sun, Moon, Flame } from "lucide-react"

interface MealPlan {
  breakfast: { name: string; calories: number; cost: number }
  lunch: { name: string; calories: number; cost: number }
  dinner: { name: string; calories: number; cost: number }
}

interface MealStageProps {
  mealPlan: MealPlan
  isGenerating: boolean
  recommendedCalories: number
}

export function MealStage({ mealPlan, isGenerating, recommendedCalories }: MealStageProps) {
  const totalCalories = mealPlan.breakfast.calories + mealPlan.lunch.calories + mealPlan.dinner.calories
  const totalCost = mealPlan.breakfast.cost + mealPlan.lunch.cost + mealPlan.dinner.cost
  
  return (
    <div className="flex-1 flex flex-col">
      {/* Stats Bar */}
      <div className="flex items-center justify-between mb-4 p-3 rounded-2xl bg-card/40 backdrop-blur-sm">
        <div className="flex items-center gap-2">
          <Flame className="w-4 h-4 text-accent" />
          <span className="text-sm font-medium">{totalCalories} kcal</span>
          <span className="text-xs text-muted-foreground">/ {recommendedCalories}</span>
        </div>
        <div className="text-sm font-medium text-primary">Rs. {totalCost.toFixed(2)}</div>
      </div>

      {/* Meal Cards Grid */}
      <div className="flex-1 grid grid-cols-1 md:grid-cols-3 gap-4">
        {/* Breakfast */}
        <motion.div
          whileHover={{ scale: 1.02, y: -4 }}
          className="p-4 rounded-2xl bg-card/50 backdrop-blur-sm border border-border/30 shadow-lg flex flex-col"
        >
          <div className="flex items-center gap-2 mb-3">
            <div className="p-1.5 rounded-lg bg-amber-100">
              <Coffee className="w-4 h-4 text-amber-600" />
            </div>
            <span className="font-semibold text-sm">Breakfast</span>
          </div>
          
          <div className="flex-1 flex justify-center items-center py-4">
            <AnimatePresence mode="wait">
              {isGenerating ? (
                <motion.div
                  key="loading"
                  initial={{ opacity: 0, rotate: 0 }}
                  animate={{ opacity: 1, rotate: 360 }}
                  exit={{ opacity: 0, transition: { duration: 0.2 } }}
                  transition={{ duration: 1, repeat: Infinity, ease: "linear" }}
                  className="text-3xl"
                >
                  🍳
                </motion.div>
              ) : (
                <motion.div
                  key="toast"
                  initial={{ opacity: 0, scale: 0.8 }}
                  animate={{ opacity: 1, scale: 1 }}
                  exit={{ opacity: 0, scale: 0.8 }}
                >
                  <HappyToast />
                </motion.div>
              )}
            </AnimatePresence>
          </div>
          
          <div className="mt-auto">
            <p className="text-sm font-medium text-foreground truncate">{mealPlan.breakfast.name}</p>
            <div className="flex justify-between mt-2 text-xs text-muted-foreground">
              <span>{mealPlan.breakfast.calories} kcal</span>
              <span className="text-primary font-medium">Rs. {mealPlan.breakfast.cost}</span>
            </div>
          </div>
        </motion.div>

        {/* Lunch */}
        <motion.div
          whileHover={{ scale: 1.02, y: -4 }}
          className="p-4 rounded-2xl bg-card/50 backdrop-blur-sm border border-border/30 shadow-lg flex flex-col"
        >
          <div className="flex items-center gap-2 mb-3">
            <div className="p-1.5 rounded-lg bg-orange-100">
              <Sun className="w-4 h-4 text-orange-600" />
            </div>
            <span className="font-semibold text-sm">Lunch</span>
          </div>
          
          <div className="flex-1 flex justify-center items-center py-4">
            <AnimatePresence mode="wait">
              {isGenerating ? (
                <motion.div
                  key="loading"
                  initial={{ opacity: 0, rotate: 0 }}
                  animate={{ opacity: 1, rotate: 360 }}
                  exit={{ opacity: 0, transition: { duration: 0.2 } }}
                  transition={{ duration: 1, repeat: Infinity, ease: "linear" }}
                  className="text-3xl"
                >
                  🥗
                </motion.div>
              ) : (
                <motion.div
                  key="salad"
                  initial={{ opacity: 0, scale: 0.8 }}
                  animate={{ opacity: 1, scale: 1 }}
                  exit={{ opacity: 0, scale: 0.8 }}
                >
                  <SaladBowl />
                </motion.div>
              )}
            </AnimatePresence>
          </div>
          
          <div className="mt-auto">
            <p className="text-sm font-medium text-foreground truncate">{mealPlan.lunch.name}</p>
            <div className="flex justify-between mt-2 text-xs text-muted-foreground">
              <span>{mealPlan.lunch.calories} kcal</span>
              <span className="text-primary font-medium">Rs. {mealPlan.lunch.cost}</span>
            </div>
          </div>
        </motion.div>

        {/* Dinner */}
        <motion.div
          whileHover={{ scale: 1.02, y: -4 }}
          className="p-4 rounded-2xl bg-card/50 backdrop-blur-sm border border-border/30 shadow-lg flex flex-col"
        >
          <div className="flex items-center gap-2 mb-3">
            <div className="p-1.5 rounded-lg bg-indigo-100">
              <Moon className="w-4 h-4 text-indigo-600" />
            </div>
            <span className="font-semibold text-sm">Dinner</span>
          </div>
          
          <div className="flex-1 flex justify-center items-center py-4">
            <AnimatePresence mode="wait">
              {isGenerating ? (
                <motion.div
                  key="loading"
                  initial={{ opacity: 0, rotate: 0 }}
                  animate={{ opacity: 1, rotate: 360 }}
                  exit={{ opacity: 0, transition: { duration: 0.2 } }}
                  transition={{ duration: 1, repeat: Infinity, ease: "linear" }}
                  className="text-3xl"
                >
                  🍖
                </motion.div>
              ) : (
                <motion.div
                  key="steak"
                  initial={{ opacity: 0, scale: 0.8 }}
                  animate={{ opacity: 1, scale: 1 }}
                  exit={{ opacity: 0, scale: 0.8 }}
                >
                  <HappySteak />
                </motion.div>
              )}
            </AnimatePresence>
          </div>
          
          <div className="mt-auto">
            <p className="text-sm font-medium text-foreground truncate">{mealPlan.dinner.name}</p>
            <div className="flex justify-between mt-2 text-xs text-muted-foreground">
              <span>{mealPlan.dinner.calories} kcal</span>
              <span className="text-primary font-medium">Rs. {mealPlan.dinner.cost}</span>
            </div>
          </div>
        </motion.div>
      </div>
    </div>
  )
}
