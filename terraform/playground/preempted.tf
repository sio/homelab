//
// Automatically restart preempted workstation instance
//
// Warning: terraform plan will also trigger the restart because HTTP POST
// request is done via datasource instead of a resource.
//

data "yandex_client_config" "client" {}

data "http" "restart_preempted" {
  method = "POST"
  url    = "https://compute.api.cloud.yandex.net/compute/v1/instances/${yandex_compute_instance.workstation.id}:start"
  request_headers = {
    Authorization = "Bearer ${data.yandex_client_config.client.iam_token}"
  }
  lifecycle {
    postcondition {
      condition = (
        yandex_compute_instance.workstation.status == "running" ||
        contains([200, 201, 204], self.status_code)
      )
      error_message = "HTTP request failed:\n${self.response_body}"
    }
  }
  depends_on = [
    yandex_compute_instance.workstation,
  ]
}

output "status" {
  value = (
    data.http.restart_preempted.status_code >= 200 &&
    data.http.restart_preempted.status_code < 300
    ? "restarting"
    : yandex_compute_instance.workstation.status
  )
}
