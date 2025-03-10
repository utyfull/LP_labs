open System

let eps = 1e-3

let factorial n =
    let rec fact n acc =
        match n with
        | 0 -> acc
        | _ -> fact (n - 1) (acc * n)
    fact n 1

let cosTaylorNaive (x: float) =
    let rec sumTerms n currentSum =
        let term = (pown x (2 * n)) / (float (factorial (2 * n))) * (pown -1.0 n)
        if abs term < eps then
            currentSum
        else
            sumTerms (n + 1) (currentSum + term)
    sumTerms 0 0.0


let cosTaylorSmart (x: float) =
    let rec sumTerms n currentSum currentTerm =
        if abs currentTerm < eps then
            currentSum
        else
            let nextTerm = -currentTerm * (pown x 2) / (float ((2 * n + 1) * (2 * n + 2)))
            sumTerms (n + 1) (currentSum + currentTerm) nextTerm
    sumTerms 0 0.0 1.0

let calculateValues a b step =
    let values = seq { for x in a .. step .. b -> x }
    values
    |> Seq.map (fun x ->
        let builtin = cos x
        let naiveTaylor = cosTaylorNaive (float x)
        let smartTaylor, smartTerms =
            let rec countTerms n currentSum currentTerm terms =
                if abs currentTerm < eps then
                    currentSum, terms
                else
                    let nextTerm = -currentTerm * (pown (float x) 2) / (float ((2 * n + 1) * (2 * n + 2)))
                    countTerms (n + 1) (currentSum + currentTerm) nextTerm (terms + 1)
            countTerms 0 0.0 1.0 0
        let dumbTaylor, dumbTerms =
            let rec countTerms n currentSum terms =
                let term = (pown (float x) (2 * n)) / (float (factorial (2 * n))) * (pown -1.0 n)
                if abs term < eps then
                    currentSum, terms
                else
                    countTerms (n + 1) (currentSum + term) (terms + 1)
            countTerms 0 0.0 0
        x, builtin, smartTaylor, smartTerms, dumbTaylor, dumbTerms)

let printTable values =
    printf "x\tBuiltin\tSmart Taylor\t# terms\tDumb Taylor\t# terms\n"
    values |> Seq.iter (fun (x, builtin, smartTaylor, smartTerms, dumbTaylor, dumbTerms) ->
        printf "%f\t%f\t%f\t%d\t%f\t%d\n" x builtin smartTaylor smartTerms dumbTaylor dumbTerms)

let a = 0.0
let b = 1.0
let step = 0.05

let values = calculateValues a b step
printTable values
