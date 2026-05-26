# Docker Readiness Checklist – Lab 04

## Dockerfile

- [x] Có base image hợp lý (`python:3.11-slim`, multi-stage build).
- [x] Có `WORKDIR` (`/app`).
- [x] Có copy dependency trước source để tận dụng layer cache.
- [x] Có `EXPOSE 8000`.
- [x] Có `CMD` chạy `uvicorn`.
- [x] Có `HEALTHCHECK` gọi `GET /health`.
- [x] Có user non-root (`appuser`).
- [x] Không chứa secret thật (token đặt trong `.env.example`, không commit `.env`).

## Runtime

- [x] Container chạy được (`docker run --env-file .env.example ...`).
- [x] Port map đúng (`-p 8000:8000`).
- [x] `/health` trả `200 OK` với body `{"status":"ok","service":"iot-ingestion","version":"0.4.0"}`.
- [x] Log khởi động rõ ràng (uvicorn in startup log ra stdout).
- [x] Cấu hình qua ENV (`AUTH_TOKEN`, `SERVICE_NAME`, `SERVICE_VERSION`, `APP_PORT`).

## Testing

- [x] Chạy lại Postman Collection (Lab 04 style, căn chỉnh với Lab 03 contract).
- [x] Newman report sinh ra trong `reports/` (`newman-lab04-local.xml`, `.html`).
- [x] Functional test pass (`GET /health`, `POST /readings`, `GET /readings/latest`, `GET /readings/:id`).
- [x] Auth test pass – thiếu token → 401, token sai → 401, ProblemDetails đúng schema.
- [x] Negative test pass – thiếu `device_id` → 422, value không hợp lệ → 422.
- [x] Boundary test pass – value=80 → 201 + `X-Warning: high-temperature`; value=81 → 422.

## Evidence

- [x] Log `docker build -t fit4110/iot-ingestion:lab04 .` thành công.
- [x] Log `docker run` và container chạy ở port 8000.
- [x] `curl http://localhost:8000/health` trả `200 OK`.
- [x] Newman HTML/XML report trong `reports/`.
- [x] Image tag theo quy ước: `fit4110/iot-ingestion:lab04`.
