import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

T useBloc<T extends Bloc>({
  List<Object> keys = const <dynamic>[],
}) {
  final context = useContext();
  final bloc = useMemoized(() => BlocProvider.of<T>(context), keys);
  return bloc;
}

STATE useBlocListener<BLOC extends Bloc, STATE>({Bloc<Object, STATE> bloc}) {
  final context = useContext();
  final blocObj = BlocProvider.of<BLOC>(context);

  final state = useMemoized(() => blocObj.skip(1), [blocObj.state]);
  return useStream(state, initialData: blocObj.state).data;
}
