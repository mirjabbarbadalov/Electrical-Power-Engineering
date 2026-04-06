"""
Project 3: Short-Circuit Analysis — Simple Radial Network
Calculates fault current at each bus using IEC 60909 method.
"""

import pandapower as pp
import pandapower.shortcircuit as sc

net = pp.create_empty_network()

# Three buses: source → transformer → load end
b_source = pp.create_bus(net, vn_kv=110, name="Source Bus (110 kV)")
b_mv     = pp.create_bus(net, vn_kv=20,  name="MV Busbar (20 kV)")
b_end    = pp.create_bus(net, vn_kv=20,  name="End of Feeder (20 kV)")

# Strong grid connection
pp.create_ext_grid(net, bus=b_source, s_sc_max_mva=500, s_sc_min_mva=400,
                   rx_max=0.1, rx_min=0.1)

# 110/20 kV transformer, 16 MVA
pp.create_transformer_from_parameters(
    net,
    hv_bus=b_source, lv_bus=b_mv,
    sn_mva=16, vn_hv_kv=110, vn_lv_kv=20,
    vkr_percent=0.5, vk_percent=10,
    pfe_kw=20, i0_percent=0.1,
    vector_group="YNyn", tap_neutral=0
)

# 5 km feeder cable (20 kV)
pp.create_line(net, from_bus=b_mv, to_bus=b_end, length_km=5,
               std_type="NA2XS2Y 1x150 RM/25 12/20 kV", name="Feeder Cable")

# Run 3-phase fault calculation (maximum case)
sc.calc_sc(net, fault="3ph", case="max", ip=True, ith=True)

# ── RESULTS ──────────────────────────────────────────────────────────────────

print("=" * 55)
print("  3-PHASE SHORT CIRCUIT RESULTS (Maximum Case)")
print("=" * 55)
print(f"  {'Bus':<25} {'Ikss (kA)':>10} {'Ip peak (kA)':>13}")
print("-" * 52)
for i, name in enumerate(net.bus["name"]):
    ikss = net.res_bus_sc["ikss_ka"].iloc[i]
    ip   = net.res_bus_sc["ip_ka"].iloc[i]
    print(f"  {name:<25} {ikss:>10.3f} {ip:>13.3f}")

# Also run minimum case for protection settings
sc.calc_sc(net, fault="3ph", case="min")

print("\n" + "=" * 55)
print("  MINIMUM FAULT CURRENT (for relay settings)")
print("=" * 55)
print(f"  {'Bus':<25} {'Ikss_min (kA)':>13}")
print("-" * 42)
for i, name in enumerate(net.bus["name"]):
    ikss_min = net.res_bus_sc["ikss_ka"].iloc[i]
    print(f"  {name:<25} {ikss_min:>13.3f}")

print("\n" + "=" * 55)
print("  INTERPRETATION")
print("=" * 55)
sc.calc_sc(net, fault="3ph", case="max", ip=True)
ikss_mv  = net.res_bus_sc["ikss_ka"].iloc[1]
ikss_end = net.res_bus_sc["ikss_ka"].iloc[2]
drop_pct = (ikss_mv - ikss_end) / ikss_mv * 100
print(f"  Fault current at MV Busbar  : {ikss_mv:.3f} kA")
print(f"  Fault current at feeder end : {ikss_end:.3f} kA")
print(f"  Current drop over 5 km      : {drop_pct:.1f}%")
print()
print("  - Fault current is highest closest to the source (MV Busbar)")
print("  - Current drops along the feeder due to cable impedance")
print("  - Protection relays must detect Ikss_min at the feeder end")
print("  - Ip (peak) is used for mechanical stress calculations on busbars")
# Circuit breakers must be rated above the peak fault current (Ip)
# at their installation point — use MV busbar value for busbar protection
