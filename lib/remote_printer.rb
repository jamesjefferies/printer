require "data_store"
require "print_processor"

class RemotePrinter
  def self.key(id)
    "printers:#{id}"
  end

  def self.update(params)
    DataStore.redis.hset(key(params[:id]), "type", params[:type])
    now = Time.now.to_i
    ip_key = "ip:#{params[:ip]}"
    DataStore.redis.zadd(ip_key, now, params[:id])
  end

  def self.find(id)
    new(id)
  end

  def self.find_by_ip(ip)
    ip_key = "ip:#{ip}"
    now = Time.now.to_i
    DataStore.redis.zremrangebyscore(ip_key, 0, now-60)
    ids = DataStore.redis.zrangebyscore(ip_key, now-60, now)
    ids.map { |id| find(id) }
  end

  attr_reader :id

  def initialize(id)
    @id = id
  end

  def type
    DataStore.redis.hget(self.class.key(@id), "type")
  end

  def width
    PrintProcessor.for(type).width
  end
end