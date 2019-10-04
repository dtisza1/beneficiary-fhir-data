# Cloudwatch Metric Filters
# 
# Creates the BFD Server CloudWatch log metric filters and log group. 
#

resource "aws_cloudwatch_log_metric_filter" "mct_query_time" {
  count          = var.env == null ? 0 : 1
  name           = "bfd-${var.env}/bfd-server/http-requests/latency/mct"
  pattern        = "[remote_host_name, remote_logical_username, remote_authenticated_user=*mct*, timestamp, request, query_string, status_code, bytes, duration_milliseconds, original_query_id, original_query_counter, original_query_timestamp, developer, developer_name, application_id, application, user_id, user, beneficiary_id]"
  log_group_name = "/bfd/${var.env}/bfd-server/access.txt"

  metric_transformation {
    name          = "mct-query-duration"
    namespace     = "bfd-${var.env}/bfd-server"
    value         = "$duration_milliseconds"
    default_value = null
  }
}

resource "aws_cloudwatch_log_metric_filter" "http-requests-count" {
  count          = var.env == null ? 0 : 1

  name           = "bfd-${var.env}/bfd-server/http-requests/count"
  pattern        = "[remote_host_name, remote_logical_username, remote_authenticated_user, timestamp, request, query_string, status_code, bytes, duration_milliseconds, original_query_id, original_query_counter, original_query_timestamp, developer, developer_name, application_id, application, user_id, user, beneficiary_id]"
  log_group_name = "/bfd/${var.env}/bfd-server/access.txt"

  metric_transformation {
    name          = "http-requests/count"
    namespace     = "bfd-${var.env}/bfd-server"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "http-requests-count-coverage" {
  count          = var.env == null ? 0 : 1

  name           = "bfd-${var.env}/bfd-server/http-requests/count/coverage"
  pattern        = "[remote_host_name, remote_logical_username, remote_authenticated_user, timestamp, request = \"*/Coverage*\", query_string, status_code, bytes, duration_milliseconds, original_query_id, original_query_counter, original_query_timestamp, developer, developer_name, application_id, application, user_id, user, beneficiary_id]"
  log_group_name = "/bfd/${var.env}/bfd-server/access.txt"

  metric_transformation {
    name          = "http-requests/count/coverage"
    namespace     = "bfd-${var.env}/bfd-server"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "http-requests-count-eob" {
  count          = var.env == null ? 0 : 1

  name           = "bfd-${var.env}/bfd-server/http-requests/count/eob"
  pattern        = "[remote_host_name, remote_logical_username, remote_authenticated_user, timestamp, request = \"*/ExplanationOfBenefit*\", query_string, status_code, bytes, duration_milliseconds, original_query_id, original_query_counter, original_query_timestamp, developer, developer_name, application_id, application, user_id, user, beneficiary_id]"
  log_group_name = "/bfd/${var.env}/bfd-server/access"

  metric_transformation {
    name          = "http-requests/count/eob"
    namespace     = "bfd-${var.env}/bfd-server"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "http-requests-count-500" {
  count          = var.env == null ? 0 : 1

  name           = "bfd-${var.env}/bfd-server/http-requests/count/http-500"
  pattern        = "[remote_host_name, remote_logical_username, remote_authenticated_user, timestamp, request, query_string, status_code = 500, bytes, duration_milliseconds, original_query_id, original_query_counter, original_query_timestamp, developer, developer_name, application_id, application, user_id, user, beneficiary_id]"
  log_group_name = "/bfd/${var.env}/bfd-server/access"

  metric_transformation {
    name          = "http-requests/count/http-500"
    namespace     = "bfd-${var.env}/bfd-server"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "http-requests-count-metadata" {
  count          = var.env == null ? 0 : 1

  name           = "bfd-${var.env}/bfd-server/http-requests/count/meta-data"
  pattern        = "[remote_host_name, remote_logical_username, remote_authenticated_user, timestamp, request = \"*/metadata*\", query_string, status_code, bytes, duration_milliseconds, original_query_id, original_query_counter, original_query_timestamp, developer, developer_name, application_id, application, user_id, user, beneficiary_id]"
  log_group_name = "/bfd/${var.env}/bfd-server/access"

  metric_transformation {
    name          = "http-requests/count/metadata"
    namespace     = "bfd-${var.env}/bfd-server"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "http-requests-count-not-2xx" {
  count          = var.env == null ? 0 : 1

  name           = "bfd-${var.env}/bfd-server/http-requests/count/not-2xx"
  pattern        = "[remote_host_name, remote_logical_username, remote_authenticated_user, timestamp, request, query_string, status_code != 2*, bytes, duration_milliseconds, original_query_id, original_query_counter, original_query_timestamp, developer, developer_name, application_id, application, user_id, user, beneficiary_id]"
  log_group_name = "/bfd/${var.env}/bfd-server/access"

  metric_transformation {
    name          = "http-requests/count/not-2xx"
    namespace     = "bfd-${var.env}/bfd-server"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "http-requests-count-patient" {
  count          = var.env == null ? 0 : 1

  name           = "bfd-${var.env}/bfd-server/http-requests/count/patient"
  pattern        = "[remote_host_name, remote_logical_username, remote_authenticated_user, timestamp, request = \"*/Patient*\", query_string, status_code, bytes, duration_milliseconds, original_query_id, original_query_counter, original_query_timestamp, developer, developer_name, application_id, application, user_id, user, beneficiary_id]"
  log_group_name = "/bfd/${var.env}/bfd-server/access"

  metric_transformation {
    name          = "http-requests/count/patient"
    namespace     = "bfd-${var.env}/bfd-server"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "http-requests-count-patient-patientSearchById" {
  count          = var.env == null ? 0 : 1

  name           = "bfd-${var.env}/bfd-server/http-requests/count/patient/patientSearchById"
  pattern        = "[remote_host_name, remote_logical_username, remote_authenticated_user, timestamp, request = \"*/Patient*_id=*\", query_string, status_code, bytes, duration_milliseconds, original_query_id, original_query_counter, original_query_timestamp, developer, developer_name, application_id, application, user_id, user, beneficiary_id]"
  log_group_name = "/bfd/${var.env}/bfd-server/access"

  metric_transformation {
    name          = "http-requests/count/patient/patientSearchById"
    namespace     = "bfd-${var.env}/bfd-server"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "http-requests-count-patient-patientSearchByIdentifier" {
  count          = var.env == null ? 0 : 1

  name           = "bfd-${var.env}/bfd-server/http-requests/count/patient/patientSearchByIdentifier"
  pattern        = "[remote_host_name, remote_logical_username, remote_authenticated_user, timestamp, request = \"*/Patient*identifier=*hicnHash*\", query_string, status_code, bytes, duration_milliseconds, original_query_id, original_query_counter, original_query_timestamp, developer, developer_name, application_id, application, user_id, user, beneficiary_id]"
  log_group_name = "/bfd/${var.env}/bfd-server/access"

  metric_transformation {
    name          = "http-requests/count/patient/patientSearchByIdentifier"
    namespace     = "bfd-${var.env}/bfd-server"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "http-requests-latency" {
  count          = var.env == null ? 0 : 1

  name           = "bfd-${var.env}/bfd-server/http-requests/latency"
  pattern        = "[remote_host_name, remote_logical_username, remote_authenticated_user, timestamp, request, query_string, status_code, bytes, duration_milliseconds, original_query_id, original_query_counter, original_query_timestamp, developer, developer_name, application_id, application, user_id, user, beneficiary_id]"
  log_group_name = "/bfd/${var.env}/bfd-server/access"

  metric_transformation {
    name          = "http-requests/latency"
    namespace     = "bfd-${var.env}/bfd-server"
    value         = "$duration_milliseconds"
    default_value = null
  }
}

resource "aws_cloudwatch_log_metric_filter" "http-requests-latency-fhir-coverage" {
  count          = var.env == null ? 0 : 1

  name           = "bfd-${var.env}/bfd-server/http-requests/latency/fhir/coverage"
  pattern        = "[remote_host_name, remote_logical_username, remote_authenticated_user, timestamp, request = \"*/Coverage*\", query_string, status_code, bytes, duration_milliseconds, original_query_id, original_query_counter, original_query_timestamp, developer, developer_name, application_id, application, user_id, user, beneficiary_id]"
  log_group_name = "/bfd/${var.env}/bfd-server/access"

  metric_transformation {
    name          = "http-requests/latency/fhir/coverage"
    namespace     = "bfd-${var.env}/bfd-server"
    value         = "$duration_milliseconds"
    default_value = null
  }
}

resource "aws_cloudwatch_log_metric_filter" "http-requests-latency-fhir-eob" {
  count          = var.env == null ? 0 : 1

  name           = "bfd-${var.env}/bfd-server/http-requests/latency/fhir/eob"
  pattern        = "[remote_host_name, remote_logical_username, remote_authenticated_user, timestamp, request = \"*/ExplanationOfBenefit*\", query_string, status_code, bytes, duration_milliseconds, original_query_id, original_query_counter, original_query_timestamp, developer, developer_name, application_id, application, user_id, user, beneficiary_id]"
  log_group_name = "/bfd/${var.env}/bfd-server/access"

  metric_transformation {
    name          = "http-requests/latency/fhir/eob"
    namespace     = "bfd-${var.env}/bfd-server"
    value         = "$duration_milliseconds"
    default_value = null
  }
}

resource "aws_cloudwatch_log_metric_filter" "http-requests-latency-fhir-patient" {
  count          = var.env == null ? 0 : 1

  name           = "bfd-${var.env}/bfd-server/http-requests/latency/fhir/patient"
  pattern        = "[remote_host_name, remote_logical_username, remote_authenticated_user, timestamp, request = \"*/Patient*\", query_string, status_code, bytes, duration_milliseconds, original_query_id, original_query_counter, original_query_timestamp, developer, developer_name, application_id, application, user_id, user, beneficiary_id]"
  log_group_name = "/bfd/${var.env}/bfd-server/access"

  metric_transformation {
    name          = "http-requests/latency/fhir/patient"
    namespace     = "bfd-${var.env}/bfd-server"
    value         = "$duration_milliseconds"
    default_value = null
  }
}

resource "aws_cloudwatch_log_metric_filter" "http-requests-latency-over-600" {
  count          = var.env == null ? 0 : 1

  name           = "bfd-${var.env}/bfd-server/http-requests/latency/over-6000"
  pattern        = "[remote_host_name, remote_logical_username, remote_authenticated_user, timestamp, request, query_string, status_code, bytes, duration_milliseconds > 6000, original_query_id, original_query_counter, original_query_timestamp, developer, developer_name, application_id, application, user_id, user, beneficiary_id]"
  log_group_name = "/bfd/${var.env}/bfd-server/access"

  metric_transformation {
    name          = "http-requests/latency/over-6000"
    namespace     = "bfd-${var.env}/bfd-server"
    value         = "1"
    default_value = "0"
  }
}

