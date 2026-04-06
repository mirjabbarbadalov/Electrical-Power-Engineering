"""
Project 2: Transformer Power Flow — HV to LV Network
A generator feeds a load through a step-down transformer.
"""

import pandapower as pp

net = pp.create_empty_network()

# Buses: 110 kV high voltage side, 20 kV low voltage side
hv_bus = pp.create_bus(net, vn_kv=110, name="HV Bus (110 kV)")
lv_bus = pp.create_bus(net, vn_kv=20,  name="LV Bus (20 kV)")
load_bus = pp.create_bus(net, vn_kv=20, name="Load Bus (20 kV)")

# Grid connection at HV side
pp.create_ext_grid(net, bus=hv_bus, vm_pu=1.02, name="Grid")

# 110/20 kV step-down transformer, 25 MVA
pp.create_transformer_from_parameters(
    net,
    hv_bus=hv_bus, lv_bus=lv_bus,
    sn_mva=25,
    vn_hv_kv=110, vn_lv_kv=20,
    vkr_percent=0.5,   # resistive part of short-circuit voltage
    vk_percent=6.0,    # total short-circuit voltage
    pfe_kw=20,         # iron (core) losses
    i0_percent=0.1,    # no-load current
    name="Main Transformer"
)

# Short cable from transformer LV side to load bus
pp.create_line(net, from_bus=lv_bus, to_bus=load_bus,
               length_km=1.0, std_type="NA2XS2Y 1x150 RM/25 12/20 kV",
               name="LV Cable")

# Load at 20 kV bus
pp.create_load(net, bus=load_bus, p_mw=15, q_mvar=5, name="Factory Load")

# Run power flow
pp.runpp(net)

# ── RESULTS ──────────────────────────────────────────────────────────────────

print("=" * 50)
print("  BUS VOLTAGES")
print("=" * 50)
for i, name in enumerate(net.bus["name"]):
    vm = net.res_bus["vm_pu"].iloc[i]
    va = net.res_bus["va_degree"].iloc[i]
    vkv = net.bus["vn_kv"].iloc[i]
    print(f"  {name:<22} {vm:.4f} pu  ({vm * vkv:.2f} kV)")

print("\n" + "=" * 50)
print("  TRANSFORMER RESULTS")
print("=" * 50)
p_hv = net.res_trafo["p_hv_mw"].iloc[0]
p_lv = net.res_trafo["p_lv_mw"].iloc[0]
q_hv = net.res_trafo["q_hv_mvar"].iloc[0]
loss = net.res_trafo["pl_mw"].iloc[0]
load_pct = net.res_trafo["loading_percent"].iloc[0]

print(f"  Power in  (HV side) : {p_hv:.3f} MW  |  {q_hv:.3f} Mvar")
print(f"  Power out (LV side) : {abs(p_lv):.3f} MW")
print(f"  Transformer losses  : {loss*1000:.2f} kW")
print(f"  Loading             : {load_pct:.1f}%  (rated: 25 MVA)")

print("\n" + "=" * 50)
print("  CABLE RESULTS")
print("=" * 50)
p_cable = net.res_line["p_from_mw"].iloc[0]
loss_cable = net.res_line["pl_mw"].iloc[0]
load_cable = net.res_line["loading_percent"].iloc[0]
print(f"  Power flow : {p_cable:.3f} MW")
print(f"  Cable loss : {loss_cable*1000:.2f} kW")
print(f"  Loading    : {load_cable:.1f}%")

print("\n" + "=" * 50)
print("  POWER BALANCE")
print("=" * 50)
supplied = net.res_ext_grid["p_mw"].iloc[0]
demand   = 15.0
t_loss   = loss * 1000
c_loss   = loss_cable * 1000
print(f"  Total power supplied   : {supplied:.3f} MW")
print(f"  Load demand            : {demand:.3f} MW")
print(f"  Transformer losses     : {t_loss:.2f} kW")
print(f"  Cable losses           : {c_loss:.2f} kW")

# Voltage drops from HV to load bus showing transformer and cable effect
# Transformer loading is well below 100% — no overload concern
# Cable losses are negligible at 1 km length
# LV bus voltage is slightly below HV due to transformer impedance
