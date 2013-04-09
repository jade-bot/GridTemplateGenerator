exports.routes = (map)->

    # Default route.
    map.get '', 'static#index'