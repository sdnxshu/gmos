package router

import (
	"time"

	"github.com/gin-gonic/gin"
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"

	"gmos/internal/handlers"
)

var (
	httpRequests = prometheus.NewCounterVec(
		prometheus.CounterOpts{
			Name: "http_requests_total",
			Help: "Total HTTP requests",
		},
		[]string{"path", "method"},
	)
)

func New() *gin.Engine {
	prometheus.MustRegister(httpRequests)

	r := gin.New()
	r.Use(gin.Recovery())

	// Metrics middleware
	r.Use(func(c *gin.Context) {
		start := time.Now()
		c.Next()
		httpRequests.WithLabelValues(c.FullPath(), c.Request.Method).Inc()
		_ = start
	})

	r.GET("/", handlers.Root)
	r.GET("/health", handlers.Health)

	// Prometheus metrics endpoint
	r.GET("/metrics", gin.WrapH(promhttp.Handler()))

	return r
}
