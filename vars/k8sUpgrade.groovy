def call(artifact, version ) {
    sh 'helm upgrade \
        ${artifact} \
        charts/${artifact} -i \
        --namespace ${artifact} \
        --set image.tag=${version} \
        --set ingress.host=${artifact} \
        --reuse-values'
}