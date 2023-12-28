#########  STAGING ###############
resource "aws_msk_configuration" "cluster_config" {
  kafka_versions    = ["2.8.1"]
  name              = "staging"
  server_properties = <<PROPERTIES
auto.create.topics.enable=true
default.replication.factor=3
min.insync.replicas=2
num.io.threads=8
num.network.threads=5
num.partitions=1
num.replica.fetchers=2
replica.lag.time.max.ms=30000
socket.receive.buffer.bytes=102400
socket.request.max.bytes=104857600
socket.send.buffer.bytes=102400
unclean.leader.election.enable=true
zookeeper.session.timeout.ms=18000
PROPERTIES
}

resource "aws_kms_key" "kafka_key" {
  description = "kafka key"
}

resource "aws_cloudwatch_log_group" "kafka_log_group" {
  name = "${var.env}-${var.service}-kafka-log-group"

  tags = {
    Environment = "production"
    Application = "serviceA"
  }
}

resource "aws_msk_cluster" "staging_kafka_cluster" {
  cluster_name           = "${var.env}-${var.service}-cluster"
  kafka_version          = "2.8.1"
  number_of_broker_nodes = 3
  configuration_info {
    arn      = aws_msk_configuration.cluster_config.arn
    revision = aws_msk_configuration.cluster_config.latest_revision
  }

  broker_node_group_info {
    instance_type  = var.kafka_instance_type
    client_subnets = var.subnet_ids
    storage_info {
      ebs_storage_info {
        volume_size = var.volume_size
      }
    }
    security_groups = [var.security_group_id]
  }
  client_authentication {
    unauthenticated = true
    sasl {
      iam   = false
      scram = false
    }
    tls {}
  }

  encryption_info {
    encryption_at_rest_kms_key_arn = aws_kms_key.kafka_key.arn
    encryption_in_transit {
      client_broker = "TLS_PLAINTEXT"
    }
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = true
        log_group = aws_cloudwatch_log_group.kafka_log_group.name
      }
    }
  }

  tags = {
    Environment = "${var.env}"
  }
}



################## QA #############################

resource "aws_msk_configuration" "qa_cluster_config" {
  kafka_versions    = ["2.8.1"]
  name              = "qa"
  server_properties = <<PROPERTIES
auto.create.topics.enable=true
default.replication.factor=3
min.insync.replicas=2
num.io.threads=8
num.network.threads=5
num.partitions=1
num.replica.fetchers=2
replica.lag.time.max.ms=30000
socket.receive.buffer.bytes=102400
socket.request.max.bytes=104857600
socket.send.buffer.bytes=102400
unclean.leader.election.enable=true
zookeeper.session.timeout.ms=18000
PROPERTIES
}

resource "aws_kms_key" "kafka_key_qa" {
  description = "kafka key qa"
}

resource "aws_cloudwatch_log_group" "kafka_log_group_qa" {
  name = "qa-${var.service}-kafka-log-group-qa"

  tags = {
    Environment = "QA"
    Application = "QA-serviceA"
  }

}

resource "aws_msk_cluster" "qa_kafka_cluster" {
  cluster_name           = "qa-${var.service}-cluster"
  kafka_version          = "2.8.1"
  number_of_broker_nodes = 3
  configuration_info {
    arn      = aws_msk_configuration.qa_cluster_config.arn
    revision = aws_msk_configuration.qa_cluster_config.latest_revision
  }

  broker_node_group_info {
    instance_type  = var.kafka_instance_type
    client_subnets = var.subnet_ids
    storage_info {
      ebs_storage_info {
        volume_size = var.volume_size
      }
    }
    security_groups = [var.security_group_id]
  }
  client_authentication {
    unauthenticated = true
    sasl {
      iam   = false
      scram = false
    }

  }

  encryption_info {
    encryption_at_rest_kms_key_arn = aws_kms_key.kafka_key_qa.arn
    encryption_in_transit {
      client_broker = "TLS_PLAINTEXT"
    }
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = true
        log_group = aws_cloudwatch_log_group.kafka_log_group_qa.name
      }
    }
  }

  tags = {
    Environment = "qa"
  }
  depends_on = [
    aws_msk_configuration.qa_cluster_config
  ]
}