$redis = REDIS = Redis.new(:url => 'redis://localhost:6379')
Resque.redis = REDIS


