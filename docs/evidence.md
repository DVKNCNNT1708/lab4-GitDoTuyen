# Lab 04 Evidence – Docker Build · Run · Test

**Repo:** https://github.com/DVKNCNNT1708/lab4-GitDoTuyen  
**Image:** `fit4110/iot-ingestion:lab04`  
**Tag nộp:** `ghcr.io/gitdotuyen/iot-ingestion:v0.1.0-team-iot`

---

## 1. `docker build` – thành công

```
#0 building with "desktop-linux" instance using docker driver
...
#9 [builder 1/5] FROM docker.io/library/python:3.11-slim  DONE 138.9s
#12 [runtime 3/6] RUN addgroup --system appgroup && adduser ...  DONE 0.5s
#13 [builder 3/5] RUN python -m venv /opt/venv  DONE 7.2s
#15 [builder 5/5] RUN pip install ...
    Successfully installed fastapi-0.115.6 uvicorn-0.34.0 pydantic-2.10.4 ...  DONE 161.4s
#17 [runtime 5/6] COPY src/ ./src/  DONE 0.0s
#18 [runtime 6/6] RUN chown -R appuser:appgroup /app  DONE 0.3s
#19 exporting to image ... naming to docker.io/fit4110/iot-ingestion:lab04  DONE
Exit code: 0
```

**Highlights:**
- Multi-stage build: `builder` → `runtime`
- Non-root user: `appuser:appgroup`
- `HEALTHCHECK` tích hợp sẵn

---

## 2. `docker run` – container chạy healthy

```bash
docker run -d --rm \
  --name fit4110-iot-lab04 \
  -p 8000:8000 \
  --env-file .env.example \
  fit4110/iot-ingestion:lab04
```

**Output `docker ps`:**
```
CONTAINER ID   IMAGE                         COMMAND                  CREATED        STATUS                 PORTS
2fdaf80813f6   fit4110/iot-ingestion:lab04   "sh -c 'uvicorn iot_…"   2 minutes ago  Up 2 minutes (healthy) 0.0.0.0:8000->8000/tcp
```

Status: `(healthy)` ✅

---

## 3. `GET /health` – trả 200 OK

```bash
Invoke-RestMethod -Uri http://localhost:8000/health
```

**Response:**
```json
{
  "status":  "ok",
  "service": "iot-ingestion",
  "version": "0.4.0"
}
```

---

## 4. Newman Test – 19/19 assertions PASS

```
newman

FIT4110 Lab04 IoT Docker Verification

□ 01_Functional
└ GET health returns 200                          [200 OK, 184B, 48ms]
  √  Status code is 200
  √  Response has status ok
  √  Response has service name and version

└ POST valid temperature reading returns 201       [201 Created, 271B, 10ms]
  √  Status code is 201
  √  Response follows created-reading schema
  √  Response device_id matches request

└ GET latest readings returns items array          [200 OK, 332B, 10ms]
  √  Status code is 200
  √  Response has items array

└ GET reading by saved reading_id returns 200      [200 OK, 320B, 5ms]
  √  Status code is 200
  √  Response reading_id matches saved variable

□ 02_Auth
└ POST reading without token returns 401           [401 Unauthorized, 302B, 6ms]
  √  Missing token returns 401

└ POST reading with wrong token returns 401        [401 Unauthorized, 294B, 7ms]
  √  Wrong token returns 401

□ 03_Negative
└ POST reading missing device_id                   [422 Unprocessable Entity, 320B, 5ms]
  √  Missing required field returns 422

└ POST reading with value as string                [422 Unprocessable Entity, 368B, 6ms]
  √  Wrong data type returns 422

□ 04_Boundary_Reliability
└ POST boundary temperature 80 (accepted+warning)  [201 Created, 300B, 7ms]
  √  Boundary value 80 returns 201
  √  High temperature response includes warning header

└ POST boundary temperature 81 (rejected)          [422 Unprocessable Entity, 342B, 6ms]
  √  Boundary value 81 returns 422

└ GET health responds under 1000ms                 [200 OK, 184B, 6ms]
  √  Response time is below 1000ms
  √  Health endpoint is reachable

┌─────────────────────────┬──────────────────┬──────────────────┐
│                         │         executed │           failed │
├─────────────────────────┼──────────────────┼──────────────────┤
│              iterations │                1 │                0 │
│                requests │               11 │                0 │
│            test-scripts │               11 │                0 │
│      prerequest-scripts │                0 │                0 │
│              assertions │               19 │                0 │
├─────────────────────────┴──────────────────┴──────────────────┤
│ total run duration: 1011ms                                    │
│ average response time: 10ms [min: 5ms, max: 48ms, s.d.: 11ms]│
└───────────────────────────────────────────────────────────────┘

Exit code: 0  ✅
```

---

## 5. Image Tag

```bash
docker tag fit4110/iot-ingestion:lab04 ghcr.io/gitdotuyen/iot-ingestion:v0.1.0-team-iot
```

**Images:**
```
fit4110/iot-ingestion:lab04                      f67a4ea68fda   268MB
ghcr.io/gitdotuyen/iot-ingestion:v0.1.0-team-iot f67a4ea68fda   268MB  (same digest)
```

**Push to GHCR:** tự động qua GitHub Actions CI (`.github/workflows/docker-newman.yml`) khi merge vào `main`.

---

## 6. GitHub Actions CI

Workflow: `.github/workflows/docker-newman.yml`  
Steps: `npm install` → `spectral lint` → `docker build` → `docker run` → `wait-on /health` → `newman` → `docker push ghcr.io`

Report artifact: `lab04-newman-reports` (XML + HTML) được upload tự động.
