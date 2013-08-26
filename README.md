# mesa-find

pagination, multi-column-searching and sorting for mesa tables.

### install

```
npm install mesa-find
```

**or**

put this line in the dependencies section of your `package.json`:

```
"mesa-find": "0.3.0"
```

then run:

```
npm install
```

### use

```javascript
var mesa = require('mesa');
var mesaFind = require('mesa-find');
var pg = require('pg');

// mixin

mesa.search = mesaFind.search;
mesa.sort = mesaFind.sort;
mesa.paginate = mesaFind.paginate;
mesa.getRecordCountAndPageCount = mesaFind.getRecordCountAndPageCount;

// set connection

var mesaWithConnection = mesa.connection(function(cb) {
    pg.connect('tcp://username@localhost/database', cb);
});

var userTable = mesaWithConnection.table('user');

var searchableColumns = ['name'];
var recordsPerPage = 50;
var sortAscending = false

var query = userTable
    .search(searchableColumns, 'ann')
    .paginate(recordsPerPage, 3)
    .sort('age', sortAscending);

query.find(function(err, records) {
    // ...
});

query.getRecordCountAndPageCount(function(err, results) {
    console.log(results.pageCount);
    console.log(results.recordCount);
});

```

### license: MIT
