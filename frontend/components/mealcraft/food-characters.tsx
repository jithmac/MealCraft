import { motion } from "framer-motion"

interface CharacterProps {
  className?: string
}

// Strong Avocado - grows with higher calorie goals
export function StrongAvocado({ calorieGoal, className = "" }: { calorieGoal: number; className?: string }) {
  // Scale based on calorie goal (1500-3500 range)
  const scale = 0.8 + ((calorieGoal - 1500) / 2000) * 0.6
  const isWorkingOut = calorieGoal > 2500
  
  return (
    <motion.div
      className={`relative ${className}`}
      animate={{ 
        scale: [scale, scale * 1.05, scale],
      }}
      transition={{ 
        duration: 2, 
        repeat: Infinity, 
        ease: "easeInOut" 
      }}
    >
      <svg width="100" height="120" viewBox="0 0 120 140" className="drop-shadow-lg">
        {/* Avocado body */}
        <ellipse cx="60" cy="80" rx="45" ry="55" fill="#6b8e23" />
        <ellipse cx="60" cy="85" rx="35" ry="42" fill="#98bf64" />
        <ellipse cx="60" cy="95" rx="18" ry="22" fill="#654321" />
        
        {/* Face */}
        <circle cx="45" cy="65" r="5" fill="#2d2d2d" />
        <circle cx="75" cy="65" r="5" fill="#2d2d2d" />
        <circle cx="47" cy="63" r="2" fill="white" />
        <circle cx="77" cy="63" r="2" fill="white" />
        
        {/* Happy mouth */}
        <path d="M 50 80 Q 60 90 70 80" stroke="#2d2d2d" strokeWidth="3" fill="none" strokeLinecap="round" />
        
        {/* Muscular arms */}
        <motion.g
          animate={{ rotate: isWorkingOut ? [-5, 5, -5] : 0 }}
          transition={{ duration: 0.5, repeat: Infinity }}
        >
          <ellipse cx="18" cy="75" rx="12" ry="20" fill="#6b8e23" />
          <ellipse cx="15" cy="60" rx="8" ry="12" fill="#6b8e23" />
        </motion.g>
        <motion.g
          animate={{ rotate: isWorkingOut ? [5, -5, 5] : 0 }}
          transition={{ duration: 0.5, repeat: Infinity }}
        >
          <ellipse cx="102" cy="75" rx="12" ry="20" fill="#6b8e23" />
          <ellipse cx="105" cy="60" rx="8" ry="12" fill="#6b8e23" />
        </motion.g>
        
        {/* Dumbbells when scale is high */}
        {isWorkingOut && (
          <>
            <motion.g
              animate={{ y: [-5, 0, -5] }}
              transition={{ duration: 0.5, repeat: Infinity }}
            >
              <rect x="2" y="45" width="25" height="8" rx="2" fill="#666" />
              <rect x="0" y="42" width="8" height="14" rx="2" fill="#888" />
              <rect x="22" y="42" width="8" height="14" rx="2" fill="#888" />
            </motion.g>
            <motion.g
              animate={{ y: [-5, 0, -5] }}
              transition={{ duration: 0.5, repeat: Infinity, delay: 0.25 }}
            >
              <rect x="93" y="45" width="25" height="8" rx="2" fill="#666" />
              <rect x="90" y="42" width="8" height="14" rx="2" fill="#888" />
              <rect x="112" y="42" width="8" height="14" rx="2" fill="#888" />
            </motion.g>
          </>
        )}
        
        {/* Sweat drops when working out */}
        {calorieGoal > 3000 && (
          <motion.g
            animate={{ opacity: [0, 1, 0], y: [0, 10, 20] }}
            transition={{ duration: 1, repeat: Infinity }}
          >
            <ellipse cx="30" cy="55" rx="3" ry="5" fill="#87ceeb" />
            <ellipse cx="90" cy="55" rx="3" ry="5" fill="#87ceeb" />
          </motion.g>
        )}
      </svg>
    </motion.div>
  )
}

// Budget Coin - appears for low budget, gives thumbs up
export function BudgetCoin({ isLowBudget, className = "" }: { isLowBudget: boolean; className?: string }) {
  return (
    <motion.div
      className={className}
      initial={{ scale: 0, rotate: -180 }}
      animate={{ scale: 1, rotate: 0 }}
      transition={{ type: "spring", stiffness: 200, damping: 15 }}
    >
      <svg width="60" height="60" viewBox="0 0 80 80" className="drop-shadow-lg">
        {/* Coin body */}
        <circle cx="40" cy="40" r="38" fill="#ffd700" />
        <circle cx="40" cy="40" r="32" fill="#ffec8b" stroke="#daa520" strokeWidth="2" />
        
        {/* Dollar sign */}
        <text x="40" y="35" textAnchor="middle" fontSize="16" fontWeight="bold" fill="#b8860b">Rs</text>
        
        {/* Face */}
        <circle cx="30" cy="38" r="3" fill="#2d2d2d" />
        <circle cx="50" cy="38" r="3" fill="#2d2d2d" />
        <path d="M 32 50 Q 40 58 48 50" stroke="#2d2d2d" strokeWidth="2" fill="none" strokeLinecap="round" />
        
        {/* Winking */}
        {isLowBudget && (
          <motion.path
            d="M 27 38 L 33 38"
            stroke="#2d2d2d"
            strokeWidth="2"
            strokeLinecap="round"
            animate={{ scaleY: [1, 0, 1] }}
            transition={{ duration: 2, repeat: Infinity, repeatDelay: 3 }}
          />
        )}
        
        {/* Thumbs up arm */}
        <motion.g
          animate={{ rotate: [-10, 10, -10] }}
          transition={{ duration: 1, repeat: Infinity }}
          style={{ originX: "60px", originY: "60px" }}
        >
          <ellipse cx="70" cy="55" rx="8" ry="12" fill="#ffd700" />
          <ellipse cx="75" cy="45" rx="5" ry="8" fill="#ffd700" />
          <ellipse cx="78" cy="38" rx="4" ry="6" fill="#ffec8b" />
        </motion.g>
      </svg>
    </motion.div>
  )
}

// Lentil Bowl - happy budget meal
export function LentilBowl({ className = "" }: CharacterProps) {
  return (
    <motion.div
      className={className}
      animate={{ y: [0, -3, 0] }}
      transition={{ duration: 2, repeat: Infinity, ease: "easeInOut" }}
    >
      <svg width="90" height="70" viewBox="0 0 90 70" className="drop-shadow-lg">
        {/* Bowl */}
        <ellipse cx="45" cy="55" rx="42" ry="12" fill="#c4a484" />
        <path d="M 5 45 Q 5 65 45 65 Q 85 65 85 45 L 85 45 Q 85 55 45 55 Q 5 55 5 45" fill="#d4b896" />
        <ellipse cx="45" cy="45" rx="40" ry="10" fill="#8b4513" />
        
        {/* Lentils */}
        <ellipse cx="30" cy="42" rx="8" ry="5" fill="#cd853f" />
        <ellipse cx="50" cy="40" rx="9" ry="6" fill="#d2691e" />
        <ellipse cx="65" cy="43" rx="7" ry="4" fill="#cd853f" />
        <ellipse cx="40" cy="38" rx="6" ry="4" fill="#deb887" />
        
        {/* Steam */}
        <motion.g
          animate={{ y: [0, -8], opacity: [0.8, 0] }}
          transition={{ duration: 1.5, repeat: Infinity }}
        >
          <path d="M 35 30 Q 32 20 38 15" stroke="#fff" strokeWidth="2" fill="none" opacity="0.6" />
          <path d="M 50 30 Q 53 18 48 12" stroke="#fff" strokeWidth="2" fill="none" opacity="0.6" />
        </motion.g>
        
        {/* Face on bowl */}
        <circle cx="35" cy="52" r="2" fill="#2d2d2d" />
        <circle cx="55" cy="52" r="2" fill="#2d2d2d" />
        <path d="M 40 58 Q 45 62 50 58" stroke="#2d2d2d" strokeWidth="2" fill="none" strokeLinecap="round" />
      </svg>
    </motion.div>
  )
}

// Chef Hat - bounces during "thinking" state
export function ChefHat({ isActive = false, className = "" }: { isActive?: boolean; className?: string }) {
  return (
    <motion.div
      className={className}
      animate={isActive ? {
        rotate: [0, 10, -10, 10, -10, 0],
      } : {}}
      transition={{ 
        duration: 2, 
        repeat: Infinity,
        ease: "easeInOut"
      }}
    >
      <svg width="70" height="80" viewBox="0 0 70 80" className="drop-shadow-lg">
        {/* Hat puff */}
        <circle cx="35" cy="25" r="20" fill="white" />
        <circle cx="20" cy="30" r="15" fill="white" />
        <circle cx="50" cy="30" r="15" fill="white" />
        <circle cx="25" cy="20" r="12" fill="white" />
        <circle cx="45" cy="20" r="12" fill="white" />
        
        {/* Hat band */}
        <rect x="12" y="40" width="46" height="30" fill="white" />
        <rect x="12" y="40" width="46" height="8" fill="#f0f0f0" />
        
        {/* Face */}
        <circle cx="25" cy="55" r="3" fill="#2d2d2d" />
        <circle cx="45" cy="55" r="3" fill="#2d2d2d" />
        
        {/* Thinking expression or smile */}
        {isActive ? (
          <motion.g
            animate={{ scaleX: [1, 1.2, 1] }}
            transition={{ duration: 0.5, repeat: Infinity }}
          >
            <ellipse cx="35" cy="65" rx="8" ry="5" fill="#2d2d2d" />
            <ellipse cx="35" cy="64" rx="6" ry="3" fill="#ff6b6b" />
          </motion.g>
        ) : (
          <path d="M 28 65 Q 35 72 42 65" stroke="#2d2d2d" strokeWidth="2" fill="none" strokeLinecap="round" />
        )}
        
        {/* Sparkles when thinking */}
        {isActive && (
          <motion.g
            animate={{ opacity: [0, 1, 0], scale: [0.5, 1, 0.5] }}
            transition={{ duration: 0.8, repeat: Infinity }}
          >
            <polygon points="60,15 62,20 67,20 63,24 65,30 60,26 55,30 57,24 53,20 58,20" fill="#ffd700" />
            <polygon points="8,20 10,24 14,24 11,27 12,32 8,29 4,32 5,27 2,24 6,24" fill="#ffd700" />
          </motion.g>
        )}
      </svg>
    </motion.div>
  )
}

// Breakfast character - Happy Toast
export function HappyToast({ className = "" }: CharacterProps) {
  return (
    <motion.div
      className={className}
      whileHover={{ scale: 1.1, rotate: 5 }}
      animate={{ y: [0, -3, 0] }}
      transition={{ duration: 1.5, repeat: Infinity }}
    >
      <svg width="60" height="70" viewBox="0 0 60 70" className="drop-shadow-md">
        {/* Toast body */}
        <rect x="5" y="10" width="50" height="55" rx="8" fill="#deb887" />
        <rect x="8" y="13" width="44" height="49" rx="6" fill="#f5deb3" />
        
        {/* Crust details */}
        <rect x="5" y="10" width="50" height="8" rx="4" fill="#cd853f" />
        
        {/* Butter pat */}
        <rect x="18" y="25" width="24" height="8" rx="2" fill="#fff8dc" />
        <rect x="20" y="27" width="20" height="4" rx="1" fill="#fffacd" />
        
        {/* Face */}
        <circle cx="20" cy="48" r="4" fill="#2d2d2d" />
        <circle cx="40" cy="48" r="4" fill="#2d2d2d" />
        <circle cx="22" cy="46" r="1.5" fill="white" />
        <circle cx="42" cy="46" r="1.5" fill="white" />
        <path d="M 24 56 Q 30 62 36 56" stroke="#2d2d2d" strokeWidth="2" fill="none" strokeLinecap="round" />
        
        {/* Rosy cheeks */}
        <circle cx="14" cy="52" r="4" fill="#ffb6c1" opacity="0.5" />
        <circle cx="46" cy="52" r="4" fill="#ffb6c1" opacity="0.5" />
      </svg>
    </motion.div>
  )
}

// Lunch character - Salad Bowl
export function SaladBowl({ className = "" }: CharacterProps) {
  return (
    <motion.div
      className={className}
      whileHover={{ scale: 1.1 }}
      animate={{ rotate: [-2, 2, -2] }}
      transition={{ duration: 2, repeat: Infinity }}
    >
      <svg width="80" height="60" viewBox="0 0 80 60" className="drop-shadow-md">
        {/* Bowl */}
        <ellipse cx="40" cy="48" rx="38" ry="10" fill="#87ceeb" />
        <path d="M 4 40 Q 4 55 40 55 Q 76 55 76 40" fill="#add8e6" />
        <ellipse cx="40" cy="40" rx="36" ry="8" fill="#90ee90" />
        
        {/* Lettuce leaves */}
        <ellipse cx="25" cy="38" rx="12" ry="6" fill="#32cd32" />
        <ellipse cx="55" cy="36" rx="14" ry="7" fill="#228b22" />
        <ellipse cx="40" cy="34" rx="10" ry="5" fill="#3cb371" />
        
        {/* Tomato */}
        <circle cx="50" cy="32" r="6" fill="#ff6347" />
        <path d="M 48 27 L 52 27" stroke="#228b22" strokeWidth="2" />
        
        {/* Cucumber */}
        <ellipse cx="28" cy="33" rx="5" ry="8" fill="#2e8b57" transform="rotate(-20 28 33)" />
        
        {/* Face */}
        <circle cx="30" cy="46" r="2" fill="#2d2d2d" />
        <circle cx="50" cy="46" r="2" fill="#2d2d2d" />
        <path d="M 35 51 Q 40 54 45 51" stroke="#2d2d2d" strokeWidth="2" fill="none" strokeLinecap="round" />
      </svg>
    </motion.div>
  )
}

// Dinner character - Steak
export function HappySteak({ className = "" }: CharacterProps) {
  return (
    <motion.div
      className={className}
      whileHover={{ scale: 1.1 }}
      animate={{ scale: [1, 1.02, 1] }}
      transition={{ duration: 1.5, repeat: Infinity }}
    >
      <svg width="80" height="50" viewBox="0 0 80 50" className="drop-shadow-md">
        {/* Steak body */}
        <ellipse cx="40" cy="28" rx="38" ry="20" fill="#8b4513" />
        <ellipse cx="40" cy="26" rx="35" ry="17" fill="#a0522d" />
        
        {/* Grill marks */}
        <line x1="20" y1="20" x2="60" y2="20" stroke="#5d3a1a" strokeWidth="3" opacity="0.6" />
        <line x1="18" y1="28" x2="62" y2="28" stroke="#5d3a1a" strokeWidth="3" opacity="0.6" />
        <line x1="22" y1="36" x2="58" y2="36" stroke="#5d3a1a" strokeWidth="3" opacity="0.6" />
        
        {/* Shine */}
        <ellipse cx="30" cy="22" rx="8" ry="4" fill="#cd853f" opacity="0.4" />
        
        {/* Face */}
        <circle cx="28" cy="26" r="3" fill="#2d2d2d" />
        <circle cx="52" cy="26" r="3" fill="#2d2d2d" />
        <path d="M 35 34 Q 40 38 45 34" stroke="#2d2d2d" strokeWidth="2" fill="none" strokeLinecap="round" />
        
        {/* Steam */}
        <motion.g
          animate={{ y: [0, -5], opacity: [0.6, 0] }}
          transition={{ duration: 1.2, repeat: Infinity }}
        >
          <path d="M 30 8 Q 27 2 32 -2" stroke="#fff" strokeWidth="2" fill="none" />
          <path d="M 50 8 Q 53 0 48 -4" stroke="#fff" strokeWidth="2" fill="none" />
        </motion.g>
      </svg>
    </motion.div>
  )
}

// Mood reaction characters
export function SleepyBroccoli({ className = "" }: CharacterProps) {
  return (
    <motion.div
      className={className}
      animate={{ rotate: [-5, 5, -5] }}
      transition={{ duration: 3, repeat: Infinity }}
    >
      <svg width="50" height="60" viewBox="0 0 50 60" className="drop-shadow-sm">
        {/* Stem */}
        <rect x="20" y="35" width="10" height="20" rx="3" fill="#228b22" />
        
        {/* Florets */}
        <circle cx="15" cy="25" r="12" fill="#2e8b57" />
        <circle cx="35" cy="25" r="12" fill="#2e8b57" />
        <circle cx="25" cy="18" r="14" fill="#3cb371" />
        <circle cx="20" cy="28" r="8" fill="#2e8b57" />
        <circle cx="30" cy="28" r="8" fill="#2e8b57" />
        
        {/* Sleepy face */}
        <line x1="18" y1="22" x2="24" y2="22" stroke="#2d2d2d" strokeWidth="2" strokeLinecap="round" />
        <line x1="28" y1="22" x2="34" y2="22" stroke="#2d2d2d" strokeWidth="2" strokeLinecap="round" />
        <ellipse cx="26" cy="30" rx="4" ry="3" fill="#2d2d2d" />
        
        {/* Z's */}
        <motion.text
          x="40"
          y="10"
          fontSize="10"
          fill="#666"
          animate={{ opacity: [0, 1, 0], y: [10, 0, -10] }}
          transition={{ duration: 2, repeat: Infinity }}
        >
          z
        </motion.text>
      </svg>
    </motion.div>
  )
}

export function EnergizedCarrot({ className = "" }: CharacterProps) {
  return (
    <motion.div
      className={className}
      animate={{ 
        y: [0, -10, 0],
        rotate: [0, 5, -5, 0]
      }}
      transition={{ duration: 0.8, repeat: Infinity }}
    >
      <svg width="40" height="70" viewBox="0 0 40 70" className="drop-shadow-sm">
        {/* Carrot body */}
        <path d="M 20 15 L 8 60 Q 20 70 32 60 L 20 15" fill="#ff7f50" />
        <path d="M 20 15 L 12 55 Q 20 62 28 55 L 20 15" fill="#ffa07a" />
        
        {/* Leaves */}
        <ellipse cx="15" cy="12" rx="4" ry="12" fill="#228b22" transform="rotate(-20 15 12)" />
        <ellipse cx="20" cy="8" rx="3" ry="10" fill="#2e8b57" />
        <ellipse cx="25" cy="12" rx="4" ry="12" fill="#228b22" transform="rotate(20 25 12)" />
        
        {/* Face */}
        <circle cx="15" cy="35" r="2" fill="#2d2d2d" />
        <circle cx="25" cy="35" r="2" fill="#2d2d2d" />
        <path d="M 15 42 Q 20 48 25 42" stroke="#2d2d2d" strokeWidth="2" fill="none" strokeLinecap="round" />
        
        {/* Energy lines */}
        <motion.g
          animate={{ scale: [1, 1.2, 1], opacity: [1, 0.5, 1] }}
          transition={{ duration: 0.3, repeat: Infinity }}
        >
          <line x1="0" y1="30" x2="5" y2="35" stroke="#ffd700" strokeWidth="2" />
          <line x1="35" y1="30" x2="40" y2="25" stroke="#ffd700" strokeWidth="2" />
          <line x1="2" y1="45" x2="6" y2="48" stroke="#ffd700" strokeWidth="2" />
        </motion.g>
      </svg>
    </motion.div>
  )
}
