open System

let bisectionMethod (f: float -> float) (a: float) (b: float) (tolerance: float) : string =
    let rec loop a b =
        let c = (a + b) / 2.0
        if (b - a) / 2.0 < tolerance then sprintf "%f" c
        elif f a * f c < 0.0 then loop a c
        else loop c b
    loop a b

let iterationMethod (g: float -> float) (x0: float) (tolerance: float) (maxIterations: int) : string =
    let rec loop x iter =
        if iter > maxIterations then "Не сходится"
        else
            let x1 = g x
            if abs (x1 - x) < tolerance then sprintf "%f" x1
            else loop x1 (iter + 1)
    loop x0 0

let newtonMethod (f: float -> float) (df: float -> float) (x0: float) (tolerance: float) (maxIterations: int) : string =
    let rec loop x iter =
        if iter > maxIterations then "Не сходится"
        else
            let df_x = df x
            if df_x = 0.0 then "NaN" 
            else
                let x1 = x - f x / df_x
                if abs (x1 - x) < tolerance then sprintf "%f" x1
                else loop x1 (iter + 1)
    loop x0 0

let equation1 x = 0.4 + atan (sqrt x - x)
let equation2 x = 3.0 * sin (sqrt x) + 0.35 * x - 3.8
let equation3 x = 0.25 * x ** 3.0 + x - 1.2502

let tolerance = 1e-6
let maxIterations = 1000 

let root1Bisection = bisectionMethod equation1 1.0 2.0 tolerance
printfn "Bisection Method: Root1 = %s" root1Bisection

let root2Bisection = bisectionMethod equation2 2.0 3.0 tolerance
printfn "Bisection Method: Root2 = %s" root2Bisection

let root3Bisection = bisectionMethod equation3 0.0 2.0 tolerance
printfn "Bisection Method: Root3 = %s" root3Bisection

let g1 x = 0.4 + atan (sqrt x - x)
let g2 x = (3.8 - 3.0 * sin (sqrt x)) / 0.35
let g3 x = (1.2502 - x) / (0.25 * x ** 2.0 + 1.0)

let root1Iteration = iterationMethod g1 1.5 tolerance maxIterations
printfn "Iteration Method: Root1 = %s" root1Iteration

let root2Iteration = iterationMethod g2 2.5 tolerance maxIterations
printfn "Iteration Method: Root2 = %s" root2Iteration

let root3Iteration = iterationMethod g3 1.0 tolerance maxIterations
printfn "Iteration Method: Root3 = %s" root3Iteration

let df1 x = 1.0 / (2.0 * sqrt x * (1.0 + (sqrt x - x) ** 2.0))
let df2 x = (1.5 * cos (sqrt x)) / sqrt x + 0.35
let df3 x = 0.75 * x ** 2.0 + 1.0

let root1Newton = newtonMethod equation1 df1 1.5 tolerance maxIterations
printfn "Newton Method: Root1 = %s" root1Newton

let root2Newton = newtonMethod equation2 df2 2.5 tolerance maxIterations
printfn "Newton Method: Root2 = %s" root2Newton

let root3Newton = newtonMethod equation3 df3 1.0 tolerance maxIterations
printfn "Newton Method: Root3 = %s" root3Newton
