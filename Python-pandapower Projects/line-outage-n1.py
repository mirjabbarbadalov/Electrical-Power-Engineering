"""
Project 4: N-1 Contingency Check — What happens when a line trips?
Compares normal operation vs. single line outage on a 4-bus network.
"""

import pandapower as pp

def build_network():
    net = pp.create_empty_network()

    b1 = pp.create_bus(net, vn_kv=110, name="Bus 1")
    b2 = pp.create_bus(net, vn_kv=110, name="Bus 2")
    b3 = pp.create_bus(net, vn_kv=110, name="Bus 3")
    b4 = pp.create_bus(net, vn_kv=110, name="Bus 4")

    pp.create_ext_grid(net, bus=b1, vm_pu=1.0)

    # Three lines forming a simple loop
    pp.create_line(net, from_bus=b1, to_bus=b2, length_km=40,
                   std_type="149-AL1/24-ST1A 110.0", name="Line 1-2")
    pp.create_line(net, from_bus=b2, to_bus=b3, length_km=30,
                   std_type="149-AL1/24-ST1A 110.0", name="Line 2-3")
    pp.create_line(net, from_bus=b1, to_bus=b3, length_km=50,
                   std_type="149-AL1/24-ST1A 110.0", name="Line 1-3")
    pp.create_line(net, from_bus=b3, to_bus=b4, length_km=20,
                   std_type="149-AL1/24-ST1A 110.0", name="Line 3-4")

    pp.create_load(net, bus=b2, p_mw=40, q_mvar=10, name="Load B2")
    pp.create_load(net, bus=b3, p_mw=60, q_mvar=15, name="Load B3")
    pp.create_load(net, bus=b4, p_mw=30, q_mvar=8,  name="Load B4")

    return net

# ── BASE CASE ─────────────────────────────────────────────────────────────────

net = build_network()
pp.runpp(net)

print("=" * 55)
print("  BASE CASE — All Lines In Service")
print("=" * 55)
print(f"  {'Bus':<10} {'Voltage (pu)':>14}")
print("-" * 28)
for i, name in enumerate(net.bus["name"]):
    print(f"  {name:<10} {net.res_bus['vm_pu'].iloc[i]:>14.4f}")

print(f"\n  {'Line':<12} {'Flow (MW)':>10} {'Loading (%)':>12}")
print("-" * 38)
for i, name in enumerate(net.line["name"]):
    p    = net.res_line["p_from_mw"].iloc[i]
    load = net.res_line["loading_percent"].iloc[i]
    print(f"  {name:<12} {p:>10.2f} {load:>12.1f}")

# ── N-1: TRIP LINE 1-2 ────────────────────────────────────────────────────────

net2 = build_network()
net2.line.at[0, "in_service"] = False   # take Line 1-2 out of service
pp.runpp(net2)

print("\n" + "=" * 55)
print("  N-1 CASE — Line 1-2 Tripped (out of service)")
print("=" * 55)
print(f"  {'Bus':<10} {'Voltage (pu)':>14}")
print("-" * 28)
for i, name in enumerate(net2.bus["name"]):
    vm = net2.res_bus["vm_pu"].iloc[i]
    flag = "  ← LOW VOLTAGE" if vm < 0.95 else ""
    print(f"  {name:<10} {vm:>14.4f}{flag}")

print(f"\n  {'Line':<12} {'Flow (MW)':>10} {'Loading (%)':>12}")
print("-" * 38)
for i, name in enumerate(net2.line["name"]):
    if not net2.line["in_service"].iloc[i]:
        print(f"  {name:<12} {'--- TRIPPED ---':>23}")
        continue
    p    = net2.res_line["p_from_mw"].iloc[i]
    load = net2.res_line["loading_percent"].iloc[i]
    flag = "  ← OVERLOAD" if load > 100 else ""
    print(f"  {name:<12} {p:>10.2f} {load:>12.1f}{flag}")

# ── COMPARISON ───────────────────────────────────────────────────────────────

print("\n" + "=" * 55)
print("  VOLTAGE COMPARISON — Base vs N-1")
print("=" * 55)
print(f"  {'Bus':<10} {'Base (pu)':>10} {'N-1 (pu)':>10} {'Change':>10}")
print("-" * 45)
for i, name in enumerate(net.bus["name"]):
    v_base = net.res_bus["vm_pu"].iloc[i]
    v_n1   = net2.res_bus["vm_pu"].iloc[i]
    delta  = v_n1 - v_base
    print(f"  {name:<10} {v_base:>10.4f} {v_n1:>10.4f} {delta:>+10.4f}")

print()
# When Line 1-2 trips, remaining lines must carry the extra power
# Bus 2 voltage drops since it now receives power via longer path through Bus 3
# If any line exceeds 100% loading, the system is NOT N-1 secure
