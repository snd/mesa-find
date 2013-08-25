module.exports = (table, options, cb) ->
    chain = table

    options.searchableColumns ?= []
    options.sortAscending ?= true

    if options.page?
        page = parseInt options.page, 10

        if isNaN page
            return process.nextTick -> cb new Error "page must be convertible to a number but is #{options.page}"

        if page < 1
            return process.nextTick -> cb new Error "options.page must be > 0 but is #{options.page}"

        unless options.recordsPerPage?
            return process.nextTick -> cb new Error "options.recordsPerPage required when options.page is set"

    search = options.search

    if search? and search isnt '' and options.searchableColumns.length isnt 0
        parts = []
        params = []
        conditions = options.searchableColumns.forEach (col) ->
            parts.push "#{col}::text ILIKE ?"
            params.push "%#{options.search}%"
        chain = chain.where parts.join(' OR '), params...

    chain
        .select('count(*)')
        .first (err, results) ->
            return cb err if err?

            recordCount = results.count
            pageCount = Math.ceil(recordCount / options.recordsPerPage)

            if options.sortBy? and options.sortBy isnt ''
                direction = if options.sortAscending then 'ASC' else 'DESC'
                chain = chain.order "\"#{options.sortBy}\" #{direction}"

            if options.page?
                chain = chain
                    .limit(options.recordsPerPage)
                    .offset((options.page - 1) * options.recordsPerPage)

            chain.find (err, records) =>
                return cb err if err?

                cb null,
                    records: records
                    pageCount: pageCount
                    recordCount: recordCount
