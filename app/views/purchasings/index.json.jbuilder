json.array!(@purchasings) do |purchasing|
  json.extract! purchasing, :id, :item_type, :item_name, :item_desc, :url, :arrival_time_start, :arrival_time_end, :item_price_desc, :remuneration
  json.url purchasing_url(purchasing, format: :json)
end
