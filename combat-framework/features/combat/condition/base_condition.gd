extends Resource
class_name BaseCondition

enum Operator {
	LessThan,
	LessThanOrEqual,
	GreaterThan,
	GreaterThanOrEqual,
	EqualTo
}

func is_met(_context: CombatContext) -> bool:
	push_error("BaseCondition.is_met() should be overridden in subclasses:", get_script().resource_path)
	return false

func compare_float_by_operator(value_a: float, value_b: float, operator: Operator) -> bool:
	match operator:
		Operator.LessThan:
			return value_a < value_b
		Operator.LessThanOrEqual:
			return value_a <= value_b
		Operator.GreaterThan:
			return value_a > value_b
		Operator.GreaterThanOrEqual:
			return value_a >= value_b
		Operator.EqualTo:
			return is_equal_approx(value_a, value_b)
		_:
			push_error("Unknown operator:", operator)
			return false

func compare_int_by_operator(value_a: int, value_b: int, operator: Operator) -> bool:
	match operator:
		Operator.LessThan:
			return value_a < value_b
		Operator.LessThanOrEqual:
			return value_a <= value_b
		Operator.GreaterThan:
			return value_a > value_b
		Operator.GreaterThanOrEqual:
			return value_a >= value_b
		Operator.EqualTo:
			return value_a == value_b
		_:
			push_error("Unknown operator:", operator)
			return false
