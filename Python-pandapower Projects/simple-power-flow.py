"""
Project 1: Power Flow Analysis — Simple 3-Bus System
"""

import pandapower as pp

# Create empty network
net = pp.create_empty_network()

# Create 3 buses (110 kV)
b1 = pp.create_bus(net, vn_kv=110, name="Bus 1 - Slack")
b2 = pp.create_bus(net, vn_kv=110, name="Bus 2 - Load")
b3 = pp.create_bus(net, vn_kv=110, name="Bus 3 - Load")

# External grid at Bus 1 (slack bus)
pp.create_ext_grid(net, bus=b1, vm_pu=1.0)

# Two transmission lines
pp.create_line(net, from_bus=b1, to_bus=b2, length_km=30,
               std_type="149-AL1/24-ST1A 110.0", name="Line 1-2")
pp.create_line(net, from_bus=b2, to_bus=b3, length_km=20,
               std_type="149-AL1/24-ST1A 110.0", name="Line 2-3")

# Loads at Bus 2 and Bus 3
pp.create_load(net, bus=b2, p_mw=50, q_mvar=15, name="Load at Bus 2")
pp.create_load(net, bus=b3, p_mw=30, q_mvar=10, name="Load at Bus 3")

# Run power flow
pp.runpp(net)

# ── RESULTS ──────────────────────────────────────────────────────────────────

print("=" * 45)
print("  BUS VOLTAGES")
print("=" * 45)
for i, name in enumerate(net.bus["name"]):
    vm = net.res_bus["vm_pu"].iloc[i]
    va = net.res_bus["va_degree"].iloc[i]
    print(f"  {name:<22} {vm:.4f} pu   {va:.2f} deg")

print("\n" + "=" * 45)
print("  LINE RESULTS")
print("=" * 45)
for i, name in enumerate(net.line["name"]):
    p    = net.res_line["p_from_mw"].iloc[i]
    loss = net.res_line["pl_mw"].iloc[i]
    load = net.res_line["loading_percent"].iloc[i]
    print(f"  {name}: {p:.2f} MW flow | {loss:.3f} MW loss | {load:.1f}% loaded")

print("\n" + "=" * 45)
print("  SLACK BUS SUPPLY")
print("=" * 45)
p_slack = net.res_ext_grid["p_mw"].iloc[0]
q_slack = net.res_ext_grid["q_mvar"].iloc[0]
print(f"  Active power supplied  : {p_slack:.2f} MW")
print(f"  Reactive power supplied: {q_slack:.2f} Mvar")

total_loss = net.res_line["pl_mw"].sum()
print(f"\n  Total line losses      : {total_loss:.4f} MW")

# Voltage check
print("\n" + "=" * 45)
print("  VOLTAGE CHECK (limits: 0.95 – 1.05 pu)")
print("=" * 45)
for i, name in enumerate(net.bus["name"]):
    vm = net.res_bus["vm_pu"].iloc[i]
    status = "OK" if 0.95 <= vm <= 1.05 else "VIOLATION"
    print(f"  {name:<22} {vm:.4f} pu  →  {status}")

# Bus 3 has the lowest voltage because it is furthest from the source
# Line 1-2 carries more power since it feeds both loads
# Total losses are small relative to total load (efficient transmission at 110 kV)
