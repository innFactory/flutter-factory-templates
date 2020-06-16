import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

import 'database_tables/table_todo.dart';

part 'db.g.dart';

@SqfEntityBuilder(_db)
const _db = SqfEntityModel(
  modelName: 'db',
  databaseName: 'database.db',
  databaseTables: [
    tableTodo,
  ],
);
