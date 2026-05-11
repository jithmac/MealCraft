import { motion } from "framer-motion"
import { SleepyBroccoli, EnergizedCarrot } from "./food-characters"
import { Heart, TrendingUp, TrendingDown, Minus } from "lucide-react"

interface MoodTrackerProps {
  healthScore: number
}

export function MoodTracker({ healthScore }: MoodTrackerProps) {
  const isEnergized = healthScore > 60
  const isTired = healthScore < 40
  
  const getMoodText = () => {
    if (healthScore >= 80) return "Feeling amazing!"
    if (healthScore >= 60) return "Great energy!"
    if (healthScore >= 40) return "Doing okay"
    if (healthScore >= 20) return "Need more veggies"
    return "Time to recharge"
  }
  
  const getTrend = () => {
    if (healthScore >= 60) return <TrendingUp className="w-4 h-4 text-primary" />
    if (healthScore <= 40) return <TrendingDown className="w-4 h-4 text-destructive" />
    return <Minus className="w-4 h-4 text-muted-foreground" />
  }

  return (
    <div className="h-full flex flex-col">
      {/* Header */}
      <div className="flex items-center justify-between mb-3">
        <h3 className="font-fredoka text-lg font-semibold text-foreground flex items-center gap-2">
          <Heart className="w-5 h-5 text-accent" />
          Mood Tracker
        </h3>
        {getTrend()}
      </div>

      {/* Character display */}
      <div className="flex-1 flex items-center justify-center relative">
        <motion.div
          key={healthScore}
          initial={{ scale: 0.8, opacity: 0 }}
          animate={{ scale: 1, opacity: 1 }}
          transition={{ type: "spring", stiffness: 300 }}
          className="relative"
        >
          {isEnergized ? (
            <EnergizedCarrot className="scale-150" />
          ) : isTired ? (
            <SleepyBroccoli className="scale-150" />
          ) : (
            <motion.div
              animate={{ y: [0, -5, 0] }}
              transition={{ duration: 2, repeat: Infinity }}
            >
              <span className="text-5xl">🥬</span>
            </motion.div>
          )}
        </motion.div>
      </div>

      {/* Health Score */}
      <div className="space-y-2">
        <div className="flex justify-between items-center">
          <span className="text-xs text-muted-foreground">Health Score</span>
          <span className="text-lg font-bold font-fredoka text-foreground">{healthScore}</span>
        </div>
        
        {/* Progress bar */}
        <div className="h-3 bg-muted rounded-full overflow-hidden">
          <motion.div
            className={`h-full rounded-full ${
              healthScore >= 60 
                ? "bg-primary" 
                : healthScore >= 40 
                ? "bg-accent" 
                : "bg-destructive"
            }`}
            initial={{ width: 0 }}
            animate={{ width: `${healthScore}%` }}
            transition={{ duration: 0.8, ease: "easeOut" }}
          />
        </div>
        
        <p className="text-sm text-center text-muted-foreground font-medium">
          {getMoodText()}
        </p>
      </div>
    </div>
  )
}
