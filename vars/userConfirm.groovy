def call(String message) {
   timeout(time: 5, unit: 'MINUTES') {
             input message: "${message}"
            }
}
