LOG("-- Initializing UTILS")

function CLAMP(a, MIN, MAX)
    if a < MIN then return MIN end
    if a > MAX then return MAX end
    return a
  end

function CYCLE_CLAMP(a, MIN, MAX)
  if a < MIN then return MAX end
  if a > MAX then return MIN end
  return a
end
