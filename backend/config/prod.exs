use Mix.Config

config :logger, :console, level: :info

config :libcluster,
  topologies: [
    budgetsh: [
      strategy: Cluster.Strategy.Kubernetes,
      config: [
        mode: :ip,
        kubernetes_node_basename: "budgetsh",
        kubernetes_selector: "app=budgetsh",
        kubernetes_namespace: "budgetsh",
        kubernetes_ip_lookup_mode: :pods,
        polling_interval: 10_000
      ]
    ]
  ]
