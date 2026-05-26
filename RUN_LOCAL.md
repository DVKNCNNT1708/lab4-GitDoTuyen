# RUN_LOCAL.md – Hướng dẫn chạy Lab 04

Tài liệu này giúp người khác clone repo sạch và chạy lại service trong Docker, kiểm thử bằng Newman.

**Yêu cầu trước:** Git, Docker Desktop (đang chạy), Node.js 20.x

---

## 1. Clone repo

```bash
git clone https://github.com/GitDoTuyen/lab4-GitDoTuyen.git
cd lab4-GitDoTuyen
```

---

## 2. Cài dependencies (Newman / Prism / Spectral)

```bash
npm install
```

---

## 3. Build Docker image

```bash
docker build -t fit4110/iot-ingestion:lab04 .
```

Kiểm tra image vừa build:

```bash
docker images fit4110/iot-ingestion
```

---

## 4. Chạy container

```bash
docker run --rm \
  --name fit4110-iot-lab04 \
  -p 8000:8000 \
  --env-file .env.example \
  fit4110/iot-ingestion:lab04
```

> **Windows PowerShell** (dùng backtick thay backslash):
> ```powershell
> docker run --rm `
>   --name fit4110-iot-lab04 `
>   -p 8000:8000 `
>   --env-file .env.example `
>   fit4110/iot-ingestion:lab04
> ```

Mở terminal khác, kiểm tra health:

```bash
curl http://localhost:8000/health
```

Kết quả mong đợi:

```json
{
  "status": "ok",
  "service": "iot-ingestion",
  "version": "0.4.0"
}
```

---

## 5. Chạy Newman test trên container

> Container phải đang chạy (bước 4) trước khi chạy bước này.

```bash
npm run test:local
```

Report sinh tại:

```
reports/newman-lab04-local.xml
reports/newman-lab04-local.html
```

Mở file `.html` trong trình duyệt để xem báo cáo đầy đủ.

---

## 6. Dừng container

```bash
docker stop fit4110-iot-lab04
```

---

## 7. Lệnh nhanh (Makefile)

```bash
make install       # npm install
make lint          # spectral lint OpenAPI
make build         # docker build
make run           # docker run (foreground)
make run-detached  # docker run -d (background)
make test-docker   # newman test:local
make stop          # docker stop
```
