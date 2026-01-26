import os
import uvicorn

if __name__ == "__main__":
    import app
    port = int(os.getenv("PORT", "8080"))
    uvicorn.run(app.app, host="0.0.0.0", port=port, proxy_headers=True, forwarded_allow_ips="*")