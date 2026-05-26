# Submission Checklist – Lab 04

Nộp các minh chứng sau:

- [x] `Dockerfile` – multi-stage, non-root, HEALTHCHECK
- [x] `.dockerignore` – loại `.git`, `.venv`, `node_modules`, `reports`, secrets
- [x] `.env.example` – `AUTH_TOKEN`, `SERVICE_NAME`, `APP_PORT`, `ENV`
- [x] `RUN_LOCAL.md` – hướng dẫn 5 bước rõ ràng
- [x] `contracts/iot-ingestion.openapi.yaml` – contract IoT Lab 04 (đồng bộ Lab 03)
- [x] `postman/collections/FIT4110_lab04_iot_docker.postman_collection.json`
- [x] `postman/environments/FIT4110_lab04_local.postman_environment.json`
- [x] `reports/newman-lab04-local.xml` – JUnit XML report
- [x] `reports/newman-lab04-local.html` – HTML report (htmlextra)
- [x] Log / ảnh `docker build` (xem CI artifact hoặc chạy local)
- [x] Log / ảnh `docker run` + `curl /health` trả `200`
- [x] Image tag: `fit4110/iot-ingestion:lab04`
- [x] GitHub Actions CI: `.github/workflows/docker-newman.yml` build + test pass
