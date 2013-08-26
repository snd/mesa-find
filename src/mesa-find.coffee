module.exports =

    search: (searchableColumns, searchString) ->
        unless searchString? and searchString isnt '' and searchableColumns.length isnt 0
            return this

        parts = []
        params = []
        conditions = searchableColumns.forEach (col) ->
            parts.push "#{col}::text ILIKE ?"
            params.push "%#{searchString}%"

        this.where parts.join(' OR '), params...

    sort: (sortBy, sortAscending = true) ->
        unless sortBy? and sortBy isnt ''
            return this

        direction = if sortAscending then 'ASC' else 'DESC'
        this.order "\"#{sortBy}\" #{direction}"

    paginate: (recordsPerPage, page) ->
        page = parseInt page, 10

        if isNaN page or page < 1
            page = 1

        this.limit(recordsPerPage)
            .offset((page - 1) * recordsPerPage)

    getRecordCountAndPageCount: (recordsPerPage, cb) ->
        this.select('count(*)')
            .first (err, results) ->
                return cb err if err?

                recordCount = results.count
                pageCount = Math.ceil(recordCount / recordsPerPage)

                cb null,
                    pageCount: pageCount
                    recordCount: recordCount
