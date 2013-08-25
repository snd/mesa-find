# mesa-find

pagination, multi-column-searching and sorting for mesa tables.

### install

```
npm install mesa-find
```

**or**

put this line in the dependencies section of your `package.json`:

```
"mesa-find": "0.2.0"
```

then run:

```
npm install
```

### use

```javascript
var mesa = require('mesa');
var find = require('mesa-find');
var pg = require('pg');

var mesaWithConnection = mesa.connection(function(cb) {
    pg.connect('tcp://username@localhost/database', cb);
});

var userTable = mesaWithConnection.table('user');

find(userTable, {
    page: 3,                        // optional (pages start at 1)
    recordsPerPage: 50,             // required when page is set

    search: 'ann',                  // optional, has no effect when it is the empty string
    searchableColumns: ['name'],    // defaults to [] which has no effect

    sortBy: 'age',                  // optional
    sortAscending: false            // defaults to true
}, function(err, results) {
    console.log(results.pageCount);
    console.log(results.recordCount);
    console.log(results.records);
});
```

### license: MIT
