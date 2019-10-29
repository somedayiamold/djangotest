
### repoducing steps of ticket https://code.djangoproject.com/ticket/30887

### create mysql container
`docker run --name mysql-demo -e MYSQL_ROOT_PASSWORD=mysqlRoot -e MYSQL_DATABASE=testdb -e MYSQL_USER=test -e MYSQL_PASSWORD="demotest" -d mysql --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci`
### change msyql8.0 password encryption by following commands
```
>> docker exec -it mysql-demo bash
>> mysql -uroot -pmysqlRoot
>> ALTER USER 'test'@'%' IDENTIFIED WITH mysql_native_password BY 'demotest';
```

### create test image under project djangodemo
`docker build -t djangotest .`

### run django test image
`docker run --name djangotest --link mysql-demo:mysql -d djangotest`

### enter container by execute
`docker exec -it djangotest bash`
### create table
```
python3 manage.py makemigrations
python3 manage.py migrate
```

### test
```
python3 manage.py shell
from demo.models import JobContext
JobContext.objects.create(data=b'\x80\x03X\x04\x00\x00\x00xxxxq\x00.')
```

you might be able to see the following errors:

--- Logging error ---
Traceback (most recent call last):
  File "/usr/local/lib/python3.7/logging/__init__.py", line 1037, in emit
    stream.write(msg + self.terminator)
UnicodeEncodeError: 'utf-8' codec can't encode character '\udc80' in position 136: surrogates not allowed
Call stack:
  File "manage.py", line 21, in <module>
    main()
  File "manage.py", line 17, in main
    execute_from_command_line(sys.argv)
  File "/usr/local/lib/python3.7/site-packages/django/core/management/__init__.py", line 381, in execute_from_command_line
    utility.execute()
  File "/usr/local/lib/python3.7/site-packages/django/core/management/__init__.py", line 375, in execute
    self.fetch_command(subcommand).run_from_argv(self.argv)
  File "/usr/local/lib/python3.7/site-packages/django/core/management/base.py", line 316, in run_from_argv
    self.execute(*args, **cmd_options)
  File "/usr/local/lib/python3.7/site-packages/django/core/management/base.py", line 353, in execute
    output = self.handle(*args, **options)
  File "/usr/local/lib/python3.7/site-packages/django/core/management/commands/shell.py", line 99, in handle
    return getattr(self, shell)(options)
  File "/usr/local/lib/python3.7/site-packages/django/core/management/commands/shell.py", line 81, in python
    code.interact(local=imported_objects)
  File "/usr/local/lib/python3.7/code.py", line 301, in interact
    console.interact(banner, exitmsg)
  File "/usr/local/lib/python3.7/code.py", line 232, in interact
    more = self.push(line)
  File "/usr/local/lib/python3.7/code.py", line 258, in push
    more = self.runsource(source, self.filename)
  File "/usr/local/lib/python3.7/code.py", line 74, in runsource
    self.runcode(code)
  File "/usr/local/lib/python3.7/code.py", line 90, in runcode
    exec(code, self.locals)
  File "<console>", line 1, in <module>
  File "/usr/local/lib/python3.7/site-packages/django/db/models/manager.py", line 82, in manager_method
    return getattr(self.get_queryset(), name)(*args, **kwargs)
  File "/usr/local/lib/python3.7/site-packages/django/db/models/query.py", line 413, in create
    obj.save(force_insert=True, using=self.db)
  File "/usr/local/lib/python3.7/site-packages/django/db/models/base.py", line 718, in save
    force_update=force_update, update_fields=update_fields)
  File "/usr/local/lib/python3.7/site-packages/django/db/models/base.py", line 748, in save_base
    updated = self._save_table(raw, cls, force_insert, force_update, using, update_fields)
  File "/usr/local/lib/python3.7/site-packages/django/db/models/base.py", line 831, in _save_table
    result = self._do_insert(cls._base_manager, using, fields, update_pk, raw)
  File "/usr/local/lib/python3.7/site-packages/django/db/models/base.py", line 869, in _do_insert
    using=using, raw=raw)
  File "/usr/local/lib/python3.7/site-packages/django/db/models/manager.py", line 82, in manager_method
    return getattr(self.get_queryset(), name)(*args, **kwargs)
  File "/usr/local/lib/python3.7/site-packages/django/db/models/query.py", line 1136, in _insert
    return query.get_compiler(using=using).execute_sql(return_id)
  File "/usr/local/lib/python3.7/site-packages/django/db/models/sql/compiler.py", line 1289, in execute_sql
    cursor.execute(sql, params)
  File "/usr/local/lib/python3.7/site-packages/django/db/backends/utils.py", line 111, in execute
    extra={'duration': duration, 'sql': sql, 'params': params}
Message: '(%.3f) %s; args=%s'
Arguments: (0.0007569789886474609, "INSERT INTO `demo_jobcontext` (`data`) VALUES (_binary '\udc80\x03X\x04\\0\\0\\0xxxxq\\0.')", [b'\x80\x03X\x04\x00\x00\x00xxxxq\x00.'])
<JobContext: JobContext object (2)>
