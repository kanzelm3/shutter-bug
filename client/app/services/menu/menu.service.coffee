'use strict'

angular.module 'shutterBugApp'
.service 'Menu', ($rootScope, $state, Auth) ->

  self = this

  defaultAccessLevels = [
    '*'
  ]

  # Accepts and accessLevel object from accessDefinition and returns rendering decision
  shouldRender = () ->
    accessLevel = Auth.getCurrentAccess().accessLevel
    if accessLevel and accessLevel.access
      if !!~this.hasAccess.indexOf '*'
        return true
      else
        for access in this.hasAccess
          if accessLevel.access[access]
            return true
    else
      return this.isPublic

  Menu = (isPublic, accessLevels) ->
    isPublic: isPublic || false
    hasAccess: accessLevels || defaultAccessLevels
    items: []
    shouldRender: shouldRender

  MenuItem = (item, parent) ->
    item = _.extend(item, {
      shouldRender: shouldRender
    })
    item.hasAccess = item.hasAccess or parent.hasAccess
    item.isPublic = item.isPublic or parent.isPublic
    return item

  this.menus = {}

  this.validateMenuExistence = (menuId) ->
    if menuId and menuId.length
      if this.menus[menuId]
        return true
      else
        throw new Error 'Menu does not exist'
    else
      throw new Error 'Menu ID was not provided'

  this.getMenu = (menuId) ->
    this.validateMenuExistence(menuId)
    return this.menus[menuId]

  this.addMenu = (menuId, isPublic, accessLevels) ->
    this.menus[menuId] = new Menu isPublic, accessLevels
    return this.menus[menuId]

  this.addMenuItem = (menuId, menuItem) ->
    this.validateMenuExistence(menuId)
    this.menus[menuId].items.push new MenuItem menuItem, this.menus[menuId]
    return this.menus[menuId]

  this.addSubMenuItem = (menuId, rootItemUrl, menuItem) ->
    this.validateMenuExistence(menuId)
    for item in this.menus[menuId].items
      if item.link == rootItemUrl
        item.items.push new MenuItem menuItem, item

  this.findMenuItem = (url, list) ->
    foundItem = null
    list.forEach (item) ->
      if item.link == url
        foundItem = item
      else
        if item.items
          return self.findMenuItem url, item.items
    return foundItem

  # Adding the topbar menu
  this.addMenu('default', true);
  this.addMenu('admin', false);

  getFullUrl = (state, str) ->
    str = str || state.url
    if state.parent
      parent = $state.get state.parent
      str = parent.url + str
      return getFullUrl parent, str
    else
      return str

  this.shouldRenderState = (state) ->
    menuItem = null
    _.forEach self.menus, (menu) ->
      menuItem = self.findMenuItem getFullUrl(state), menu.items
    if menuItem
      return menuItem.shouldRender()
    return true

  return
