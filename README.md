# mesa-find

mesa-find enables pagination, multi-column-searching and sorting on mesa tables

### install

    npm install mesa-find

### use

```coffeescript
mesa = require 'mesa'
find = require 'mesa-find'
pg = require 'pg'

userTable = mesa
    .table('user')
    .connection((cb) -> pg.create 'tcp://foo@localhost/bar', cb)

find userTable, {
    page: 3                         # optional (pages start at 1)
    recordsPerPage: 50              # required when page is set

    search: 'ann'                   # optional, has no effect when it is the empty string
    searchableColumns: ['name']     # defaults to [] which makes search have no effect

    sortBy: 'age'                   # optional
    sortAscending: false            # defaults to true
}, (err, results) ->
    console.log results.pageCount
    console.log results.recordCount
    console.log results.records
```

### license: MIT
