"""
Project 5: Solar PV Integration — Effect on Voltage and Losses
Compares a distribution feeder with and without a rooftop solar PV unit.
"""

import pandapower as pp

# ── NETWORK: simple 20 kV radial feeder with 3 load buses ────────────────────

def build_feeder():
    net = pp.create_empty_network()

    b0 = pp.create_bus(net, vn_kv=20, name="Substation")
    b1 = pp.create_bus(net, vn_kv=20, name="Bus 1")
    b2 = pp.create_bus(net, vn_kv=20, name="Bus 2")
    b3 = pp.create_bus(net, vn_kv=20, name="Bus 3 (PV location)")

    pp.create_ext_grid(net, bus=b0, vm_pu=1.02)

    pp.create_line(net, from_bus=b0, to_bus=b1, length_km=2,
                   std_type="NA2XS2Y 1x150 RM/25 12/20 kV", name="Line 0-1")
    pp.create_line(net, from_bus=b1, to_bus=b2, length_km=2,
                   std_type="NA2XS2Y 1x150 RM/25 12/20 kV", name="Line 1-2")
    pp.create_line(net, from_bus=b2, to_bus=b3, length_km=2,
                   std_type="NA2XS2Y 1x150 RM/25 12/20 kV", name="Line 2-3")

    pp.create_load(net, bus=b1, p_mw=2.0, q_mvar=0.5, name="Load 1")
    pp.create_load(net, bus=b2, p_mw=2.5, q_mvar=0.7, name="Load 2")
    pp.create_load(net, bus=b3, p_mw=3.0, q_mvar=0.8, name="Load 3")

    return net, b3

# ── CASE 1: No PV ─────────────────────────────────────────────────────────────

net_no_pv, b3 = build_feeder()
pp.runpp(net_no_pv)

# ── CASE 2: 4 MW Solar PV at Bus 3 ───────────────────────────────────────────

net_pv, b3 = build_feeder()
pp.create_sgen(net_pv, bus=b3, p_mw=4.0, q_mvar=0.0, name="Solar PV")
pp.runpp(net_pv)

# ── RESULTS ──────────────────────────────────────────────────────────────────

print("=" * 58)
print("  BUS VOLTAGES — No PV  vs.  With 4 MW Solar PV")
print("=" * 58)
print(f"  {'Bus':<25} {'No PV (pu)':>11} {'With PV (pu)':>13} {'Δ (pu)':>8}")
print("-" * 58)
for i, name in enumerate(net_no_pv.bus["name"]):
    v0 = net_no_pv.res_bus["vm_pu"].iloc[i]
    v1 = net_pv.res_bus["vm_pu"].iloc[i]
    print(f"  {name:<25} {v0:>11.4f} {v1:>13.4f} {v1-v0:>+8.4f}")

print("\n" + "=" * 58)
print("  LINE POWER FLOW — No PV  vs.  With 4 MW Solar PV")
print("=" * 58)
print(f"  {'Line':<12} {'No PV (MW)':>11} {'With PV (MW)':>13} {'Loading% PV':>12}")
print("-" * 52)
for i, name in enumerate(net_no_pv.line["name"]):
    p0 = net_no_pv.res_line["p_from_mw"].iloc[i]
    p1 = net_pv.res_line["p_from_mw"].iloc[i]
    ld = net_pv.res_line["loading_percent"].iloc[i]
    print(f"  {name:<12} {p0:>11.2f} {p1:>13.2f} {ld:>11.1f}%")

print("\n" + "=" * 58)
print("  LOSSES & GRID SUPPLY COMPARISON")
print("=" * 58)
loss_no_pv = net_no_pv.res_line["pl_mw"].sum()
loss_pv    = net_pv.res_line["pl_mw"].sum()
grid_no_pv = net_no_pv.res_ext_grid["p_mw"].iloc[0]
grid_pv    = net_pv.res_ext_grid["p_mw"].iloc[0]

print(f"  Total feeder losses  (no PV)  : {loss_no_pv*1000:.2f} kW")
print(f"  Total feeder losses  (PV)     : {loss_pv*1000:.2f} kW")
print(f"  Loss reduction                : {(loss_no_pv - loss_pv)*1000:.2f} kW")
print()
print(f"  Grid supply (no PV)           : {grid_no_pv:.3f} MW")
print(f"  Grid supply (with PV)         : {grid_pv:.3f} MW")
print(f"  Grid import reduction         : {grid_no_pv - grid_pv:.3f} MW")

print("\n" + "=" * 58)
print("  OBSERVATIONS")
print("=" * 58)
v_end_no_pv = net_no_pv.res_bus["vm_pu"].iloc[3]
v_end_pv    = net_pv.res_bus["vm_pu"].iloc[3]
print(f"  Bus 3 voltage rises from {v_end_no_pv:.4f} to {v_end_pv:.4f} pu with PV")
print(f"  PV reduces power drawn from the grid by {grid_no_pv - grid_pv:.2f} MW")
print(f"  Line flows decrease — less current → lower losses")
if v_end_pv > 1.05:
    print(f"  WARNING: Bus 3 voltage {v_end_pv:.4f} pu exceeds 1.05 pu limit!")
    print(f"  Consider reducing PV output or enabling reactive power absorption")
else:
    print(f"  Voltage is within 0.95–1.05 pu limits — PV size is acceptable")
# PV at end of feeder raises voltage due to reversed power flow
# Larger PV would eventually push voltage above the 1.05 pu limit (hosting capacity)
