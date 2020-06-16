import 'package:sqfentity_gen/sqfentity_gen.dart';

const tableTodo = SqfEntityTable(
  tableName: 'todo',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: false,
  modelName: 'Todo',
  fields: [
    SqfEntityField('title', DbType.text),
    SqfEntityField('note', DbType.text),
    SqfEntityField('isCompleted', DbType.bool, defaultValue: false),
  ],
);
