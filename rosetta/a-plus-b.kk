import std/os/readline

// A prompt effect which retries getting input until a valid result is returned.
effect prompt
  ctl delimit(): () // Captures the retry resumption
  final ctl fail(): e // A failed input

// Prompt for input, with retry until successful result 
// - `message` is the original prompt 
// - `err-message` is the error shown on failure
fun prompt(message: string, err-message: string, action: (string) -> <io,prompt|e> a): <io-noexn|e> a
  var reattempt := fn() impossible() // We ensure all paths include a delimiter
  with handler
    raw ctl delimit()
      reattempt := (fn() rcontext.resume(())) // set reattempt resumption
      reattempt() // Initial try 
    final ctl fail() 
      reattempt() // Handle failure by reattempting
  // Print the initial request message
  println(message)
  delimit() // Mark retry point
  try {
    action(readline()) // Read the input and apply the action
  } fn(err)
      // On an exception, print the error message and retry 
      println(err-message)
      fail() // reset

fun main()
  with line <- prompt("Enter two numbers separated by space: ", "Invalid input, please enter two integers.")
  val [a, b] = line.split(" ")
  a.parse-int.unjust + b.parse-int.unjust
