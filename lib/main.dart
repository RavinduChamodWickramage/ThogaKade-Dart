import 'cli/command_handler.dart';
import 'managers/thoga_kade_manager.dart';

void main() async {
  var manager = ThogaKadeManager();

  var commandHandler = CommandHandler(manager, manager.inventoryRepository);

  await commandHandler.handleUserInput();
}