# token
struct Failed end
failed = Failed()

# core
cache(f) = (target, body) ->
    gensym("cache_$target") |> TARGET ->
    Expr(
      :block,
      :($TARGET = $target),
      :($(f(TARGET, body)))
    )

wildcard(target, body) = body

capture(sym::Symbol) = (target, body) ->
  Expr(:let, Expr(:block, :($sym = $target)), body)

literal(v) = (target, body) ->
  :($v == $target ? $body : $failed)

and(p1, p2) = (target, body) ->
	p1(target, p2(target, body))

or(p1, p2) = (target, body) ->
  let e1 = p1(target, body),
      e2 = p2(target, body),
      RET = gensym("or_$target")
      Expr(
        :block,
        :($RET = $e1),
        :($RET === $failed ? $e2 : $RET)
      )
  end

# C(p1, p2, .., pn)
# pattern = (target: code, remainder: code) -> code
recog(recogniser, get_field) = elts -> recogniser(
  function (target, body)
    n = elts |> length
    foldr(1:n, init=body) do i, last
      sub_target = get_field(target, i)
      elts[i](sub_target, last)
    end
  end)




typed_as(T) = f -> (target, body) ->
   let FN = gensym("f_$target"),
       TARGET = gensym("$target"),
       f1 = Expr(:function, :($FN($TARGET::$T)), :($(f(TARGET, body)))),
       f2 = Expr(:function, :($FN($TARGET)), failed)
       Expr(:block, f1, f2, :($FN($target)))
   end

match(target) = pairs ->
  let RET = gensym("or_$target"),
      TAG = gensym("var_$target")
      foldr(pairs, init=:(error("non-exhaustive"))) do (case, body), last
          expr = case(TAG, body)
          Expr(
            :block,
            :($RET = $expr),
            :($RET === $failed ? $last : $RET)
        )
      end |> x -> Expr(:block, :($TAG = $target), x)
  end

# pervasives

tuple_pat(elts) =
  let recogniser = typed_as(NTuple{elts |> length, Any}),
      get_field(tag, i) = :($tag[$i])
      recog(recogniser, get_field)(elts)
  end

pred_pat(pred) = (target, body) ->
  let cond = :($pred($target))
    :($cond ? $body : $failed)
  end


guard(cond) = (target, body) -> :($cond ? $body : $failed)

array_pat(elts) =
  let recogniser = typed_as(Vector),
      get_field(tag, i) = :($tag[$i])
      recog(recogniser, get_field)(elts)
  end

array_pat2(elts1, star, elts2) = # with ...
  let (n1, n2) = map(length, [elts1, elts2]),
      recogniser = f -> typed_as(Vector)(
          let n = n1 + n2
              check = n > 0 ?
                pred_pat(Expr(:(->), :x, :(x >= $(n1 + n2)))) :
                wildcard
              and(f, check)
          end
      ),
      get_field(tag, i) =
          i <= n1 ?
            :($tag[$i]) :
          i > n1 + 1 ?
            :($tag[end - $(n2 + n1 + 1 - i)]) :
          :($tag[$(n1 + 1):end - $n2])
      recog(recogniser, get_field)([elts1..., star, elts2...])
  end


match(target) = pairs ->
  let RET = gensym("or_$target"),
      TAG = gensym("var_$target")
      foldr(pairs, init=:(error("non-exhaustive"))) do (case, body), last
          expr = case(TAG, body)
          Expr(
            :block,
            :($RET = $expr),
            :($RET === $failed ? $last : $RET)
        )
      end |> x -> Expr(:block, :($TAG = $target), x)
  end

p1 = tuple_pat([
   capture(:a),
   wildcard,
   literal(3)
])
p1(:var, :expr1) |> println


match(:x)([
    p1 => :(a + 1),
    wildcard => 5
]) |> println


macro test_ast(x)
  match(x)([
    p1 => :(a + 1),
    wildcard => 5
  ]) |> esc
end

function f1(x)
  @test_ast x
end

function f2(x)
  if x isa Tuple && length(x) == 3 && x[3] == 3
    x[1] + 1
  else
    5
  end

end

using InteractiveUtils, BenchmarkTools
@code_warntype f1((1, 2, 3))
println()
@code_warntype f2((1, 2, 3))
@btime f1((1, 2, 3))
@btime f2((1, 2, 3))
