module TouchTouch
  class Redis
    def initialize
      @redis = ::Redis.new
    end

    def get(toucher_class, toucher_id, touch_alias, touchee_class)
      toucher_class = toucher_class.to_s
      toucher_id = toucher_id.to_s
      touch_alias = touch_alias.to_s
      touchee_class = touchee_class.to_s
      touchee_id = touchee_id.to_s

      h = JSON.parse(@redis.get(toucher_class.to_s) || "{}")
      touchee_ids = h.
        try(:[], toucher_id).
        try(:[], touch_alias).
        try(:[], touchee_class)

      (touchee_ids || []).map(&:to_i)
    end

    def set(toucher_class, toucher_id, touch_alias, touchee_class, touchee_id, limit)
      toucher_class = toucher_class.to_s
      toucher_id = toucher_id.to_s
      touch_alias = touch_alias.to_s
      touchee_class = touchee_class.to_s
      touchee_id = touchee_id.to_s

      h = JSON.parse(@redis.get(toucher_class) || "{}")
      @redis.set(toucher_class, {}) if h.blank?

      h[toucher_id] = h[toucher_id] || {}
      h[toucher_id][touch_alias] = h[toucher_id][touch_alias] || {}
      h[toucher_id][touch_alias][touchee_class] = h[toucher_id][touch_alias][touchee_class] || []
      h[toucher_id][touch_alias][touchee_class] << touchee_id
      if h[toucher_id][touch_alias][touchee_class].length > limit
        h[toucher_id][touch_alias][touchee_class].shift
      end

      @redis.set(toucher_class, h.to_json)
    end
  end
end
