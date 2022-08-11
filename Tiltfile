SOURCE_IMAGE = os.getenv("SOURCE_IMAGE", default='tapbuild.azurecr.io/tap/tanzu-supply-chain/spring-sensors')
LOCAL_PATH = os.getenv("LOCAL_PATH", default='.')
NAMESPACE = os.getenv("NAMESPACE", default='tap-dev')

k8s_custom_deploy(
    'spring-sensors',
    apply_cmd="tanzu apps workload apply -f config/workload.yaml --live-update" +
               " --local-path " + LOCAL_PATH +
               " --source-image " + SOURCE_IMAGE +
               " --namespace " + NAMESPACE +
               " --yes >/dev/null" +
               " && kubectl get workload spring-sensors --namespace " + NAMESPACE + " -o yaml",
    delete_cmd="tanzu apps workload delete -f config/workload.yaml --namespace " + NAMESPACE + " --yes",
    deps=['pom.xml', './target/classes'],
    container_selector='workload',
    image_selector= 'tapbuild.azurecr.io/tap/tanzu-supply-chain/spring-sensors-' + NAMESPACE,
    live_update=[
      sync('./target/classes', '/workspace/BOOT-INF/classes')
    ]
)

k8s_resource('spring-sensors', port_forwards=["8080:8080"],
            extra_pod_selectors=[{'serving.knative.dev/service': 'spring-sensors'}])

allow_k8s_contexts('tap-full')

update_settings ( max_parallel_updates = 3 , k8s_upsert_timeout_secs = 500 , suppress_unused_image_warnings = None)