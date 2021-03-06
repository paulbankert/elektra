((app) ->
  ########################### EVENTS ##############################
  initialEventState =
    error: null
    total: 0
    offset: 0
    currentPage: 1
    limit: 30
    items: []
    isFetching: false
    filterStartTime: ''
    filterEndTime: ''
    filterType: ''
    filterTerm: ''
    attributeValues: ''
    isFetchingAttributeValues: false

  updateFilterStartTime = (state,{filterStartTime}) ->
    ReactHelpers.mergeObjects({},state,{
      filterStartTime: filterStartTime
    })

  updateFilterEndTime = (state,{filterEndTime}) ->
    ReactHelpers.mergeObjects({},state,{
      filterEndTime: filterEndTime
    })

  updateFilterType = (state,{filterType}) ->
    ReactHelpers.mergeObjects({},state,{
      filterType: filterType
    })

  updateFilterTerm = (state,{filterTerm}) ->
    ReactHelpers.mergeObjects({},state,{
      filterTerm: filterTerm
    })

  updateOffset = (state,{offset}) ->
    ReactHelpers.mergeObjects({},state,{
      offset: offset
    })

  updateCurrentPage = (state,{page}) ->
    ReactHelpers.mergeObjects({},state,{
      currentPage: page
    })

  requestEvents = (state,{}) ->
    ReactHelpers.mergeObjects({},state,{
      isFetching: true
    })

  requestEventsFailure = (state,{error})->
    ReactHelpers.mergeObjects({},state,{
      isFetching: false
      error: error
    })

  receiveEvents = (state,{events,total})->
    ReactHelpers.mergeObjects({},state,{
      isFetching: false
      items: events
      total: total
      error: null
    })

  requestAttributeValues = (state,{}) ->
    ReactHelpers.mergeObjects({},state,{
      isFetchingAttributeValues: true
    })

  requestAttributeValuesFailure = (state,{error})->
    ReactHelpers.mergeObjects({},state,{
      isFetchingAttributeValues: false
      error: error
    })

  requestAttributeValuesNotFound = (state,{attribute})->
    ReactHelpers.mergeObjects({},state,{
      isFetchingAttributeValues: false
      attributeValues: ReactHelpers.mergeObjects({}, state.attributeValues, {"#{attribute}": []}) # set attribute value to empty array in attributeValues hash
      error: null
    })

  receiveAttributeValues = (state,{attribute,values})->
    ReactHelpers.mergeObjects({},state,{
      isFetchingAttributeValues: false
      attributeValues: ReactHelpers.mergeObjects({}, state.attributeValues, {"#{attribute}": values}) # merge attribute: values into attributeValues hash
      error: null
    })

  # Event Details

  toggleEventDetailsVisible = (state,{eventId, detailsVisible}) ->
    newState = ReactHelpers.updateItemInList(state, eventId, 'event_id', {
      detailsVisible: detailsVisible
    })

  requestEventDetails = (state,{eventId}) ->
    newState = ReactHelpers.updateItemInList(state, eventId, 'event_id', {
      isFetchingDetails: true
    })

  requestEventDetailsFailure = (state,{eventId, error}) ->
    newState = ReactHelpers.updateItemInList(state, eventId, 'event_id', {
      isFetchingDetails: false
      error: error
    })

  receiveEventDetails = (state,{eventId, eventDetails}) ->
    newState = ReactHelpers.updateItemInList(state, eventId, 'event_id', {
      details: eventDetails
      isFetchingDetails: false
      error: null
    })


  # events reducer
  app.events = (state = initialEventState, action) ->
    switch action.type
      when app.REQUEST_EVENTS                     then requestEvents(state,action)
      when app.RECEIVE_EVENTS                     then receiveEvents(state,action)
      when app.REQUEST_EVENTS_FAILURE             then requestEventsFailure(state,action)
      when app.REQUEST_ATTRIBUTE_VALUES           then requestAttributeValues(state,action)
      when app.RECEIVE_ATTRIBUTE_VALUES           then receiveAttributeValues(state,action)
      when app.REQUEST_ATTRIBUTE_VALUES_FAILURE   then requestAttributeValuesFailure(state,action)
      when app.REQUEST_ATTRIBUTE_VALUES_NOT_FOUND then requestAttributeValuesNotFound(state,action)
      when app.UPDATE_FILTER_START_TIME           then updateFilterStartTime(state,action)
      when app.UPDATE_FILTER_END_TIME             then updateFilterEndTime(state,action)
      when app.UPDATE_FILTER_TYPE                 then updateFilterType(state,action)
      when app.UPDATE_FILTER_TERM                 then updateFilterTerm(state,action)
      when app.UPDATE_OFFSET                      then updateOffset(state,action)
      when app.UPDATE_CURRENT_PAGE                then updateCurrentPage(state,action)
      when app.TOGGLE_EVENT_DETAILS_VISIBLE       then toggleEventDetailsVisible(state,action)
      when app.REQUEST_EVENT_DETAILS              then requestEventDetails(state,action)
      when app.REQUEST_EVENT_DETAILS_FAILURE      then requestEventDetailsFailure(state,action)
      when app.RECEIVE_EVENT_DETAILS              then receiveEventDetails(state,action)
      else state

)(audit)
