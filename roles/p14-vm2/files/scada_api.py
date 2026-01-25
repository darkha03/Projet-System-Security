from flask import Flask, jsonify
from flask_cors import CORS
from pymodbus.client import ModbusTcpClient
import logging
from datetime import datetime

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
log = logging.getLogger(__name__)

app = Flask(__name__)
CORS(app)

PLC_CONFIG = {
    1: {
        "name": "INCUBATEUR-2024",
        "ip": "10.0.0.80",
        "port": 502,
        "type": "temperature",
        "unit": "°C",
        "normal_min": 35.0,
        "normal_max": 39.0,
        "critical_max": 50.0
    },
    2: {
        "name": "CENTRIFUGEUSE-A",
        "ip": "10.0.0.59",
        "port": 502,
        "type": "speed",
        "unit": "RPM",
        "normal_min": 1000,
        "normal_max": 4000,
        "critical_max": 6000
    }
}

def get_status(value, config):
    if config["type"] == "temperature":
        actual = value / 10.0
    else:
        actual = value

    if actual > config["critical_max"]:
        return "CRITICAL"
    elif actual > config["normal_max"] or actual < config["normal_min"]:
        return "WARNING"
    else:
        return "NORMAL"

def read_plc(plc_id):
    if plc_id not in PLC_CONFIG:
        return None
    
    config = PLC_CONFIG[plc_id]
    client = None

    try:
        client = ModbusTcpClient(config["ip"], port=config["port"])

        if not client.connect():
            log.error(f"Cannot connect to PLC {plc_id}")
            return None

        result = client.read_holding_registers(address=0, count=6)

        if result.isError():
            log.error(f"Modbus error: {result}")
            return None

        r = result.registers
        log.info(f"PLC{plc_id} raw: {r}")

        status = get_status(r[0], config)

        if config["type"] == "temperature":
            # PLC1 INCUBATEUR - ACTUAL REGISTER MAPPING:
            # [0]=370   Temperature (37.0°C)
            # [1]=100   Humidity (100%)
            # [2]=1     Status (1=Running)
            # [3]=72    Time remaining (72h)
            # [4]=0     Unused
            # [5]=0     Alarm
            return {
                "id": plc_id,
                "name": config["name"],
                "type": config["type"],
                "status": status,
                "data": {
                    "setpoint": r[0] / 10.0,
                    "current": r[0] / 10.0,
                    "humidity": r[1],
                    "running": r[2] == 1,
                    "time_remaining": r[3],
                    "alarm": r[5] == 1
                },
                "unit": config["unit"],
                "timestamp": datetime.now().isoformat()
            }
        else:
            # PLC2 CENTRIFUGEUSE - ACTUAL REGISTER MAPPING:
            # [0]=3000  Speed (3000 RPM)
            # [1]=1     Status (1=Running)
            # [2]=30    Time remaining (30 min)
            # [3]=220   Temperature (22.0°C)
            # [4]=0     Vibration
            # [5]=0     Alarm
            return {
                "id": plc_id,
                "name": config["name"],
                "type": config["type"],
                "status": status,
                "data": {
                    "setpoint": r[0],
                    "current": r[0],
                    "running": r[1] == 1,
                    "time_remaining": r[2],
                    "temperature": r[3] / 10.0,
                    "vibration": r[4],
                    "alarm": r[5] == 1
                },
                "unit": config["unit"],
                "timestamp": datetime.now().isoformat()
            }

    except Exception as e:
        log.error(f"Error: {e}")
        return None
    finally:
        if client:
            client.close()

@app.route('/')
def home():
    return jsonify({"service": "SCADA HMI API", "version": "1.5"})

@app.route('/api/plc/<int:plc_id>')
def get_plc(plc_id):
    data = read_plc(plc_id)
    return jsonify(data) if data else (jsonify({"error": f"PLC {plc_id} offline"}), 500)

@app.route('/api/plc/all')
def get_all_plcs():
    result = {"timestamp": datetime.now().isoformat(), "plcs": []}

    for plc_id in PLC_CONFIG:
        data = read_plc(plc_id)
        if data:
            result["plcs"].append(data)
        else:
            result["plcs"].append({
                "id": plc_id,
                "name": PLC_CONFIG[plc_id]["name"],
                "status": "OFFLINE"
            })

    statuses = [p.get("status", "OFFLINE") for p in result["plcs"]]
    if "CRITICAL" in statuses:
        result["overall_status"] = "CRITICAL"
    elif "WARNING" in statuses or "OFFLINE" in statuses:
        result["overall_status"] = "WARNING"
    else:
        result["overall_status"] = "NORMAL"

    return jsonify(result)

if __name__ == '__main__':
    log.info("=" * 50)
    log.info("SCADA HMI API v1.5 - Correct Mapping")
    log.info("=" * 50)
    app.run(host='0.0.0.0', port=5000)