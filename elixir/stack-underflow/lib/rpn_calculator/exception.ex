defmodule RPNCalculator.Exception do
  defmodule DivisionByZeroError do
    defexception message: "division by zero occurred"
  end

  defmodule StackUnderflowError do
    defexception message: "stack underflow occurred"

    @impl true
    def exception(value) do
      case value do
        [] -> %StackUnderflowError{}
        _ -> %StackUnderflowError{message: "stack underflow occurred, context: #{value}"}
      end
    end
  end

  def divide(stack) do
    case stack do
      [] -> raise StackUnderflowError, "when dividing"
      [_] -> raise StackUnderflowError, "when dividing"
      [0 | _] -> raise DivisionByZeroError
      _ ->
        [denom | [num | _]] = stack
        num / denom
    end
  end
end
