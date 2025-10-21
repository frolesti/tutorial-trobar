part of 'get_pizza_bloc.dart';

abstract class GetPizzaEvent extends Equatable {
  const GetPizzaEvent();

  @override
  List<Object> get props => [];
}

class GetPizza extends GetPizzaEvent {
  const GetPizza();
}