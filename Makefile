.PHONY: run-debezium
run-debezium:
	@docker rm cdc-connect || true
	@docker run -it --name cdc-connect --net=host -p 8083:8083 \
		-e CONNECT_BOOTSTRAP_SERVERS=localhost:19092 \
		-e CONNECT_REST_PORT=18082 \
		-e CONNECT_GROUP_ID="1" \
		-e CONNECT_CONFIG_STORAGE_TOPIC="acceleration-config" \
		-e CONNECT_OFFSET_STORAGE_TOPIC="acceleration-offsets" \
		-e CONNECT_STATUS_STORAGE_TOPIC="acceleration-status" \
		-e CONNECT_KEY_CONVERTER="org.apache.kafka.connect.json.JsonConverter" \
		-e CONNECT_VALUE_CONVERTER="org.apache.kafka.connect.json.JsonConverter" \
		-e CONNECT_INTERNAL_KEY_CONVERTER="org.apache.kafka.connect.json.JsonConverter" \
		-e CONNECT_INTERNAL_VALUE_CONVERTER="org.apache.kafka.connect.json.JsonConverter" \
		-e CONNECT_REST_ADVERTISED_HOST_NAME="cdc-connect" \
		kafka-connect-debezium:1.0.0

.PHONY: register-connector
register-connector:
	@curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" http://localhost:8083/connectors/ -d @register-connector.json

.PHONY: check-connectors
check-connectors:
	@curl -H "Accept:application/json" localhost:8083/connectors/