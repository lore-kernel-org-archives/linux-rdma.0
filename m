From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: IB softirq race
Date: Fri, 10 Aug 2012 15:03:52 +0200
Message-ID: <502506B8.7080203@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "ri-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <ri-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

we've got a gateway machine which is connected to the internet via
ethernet and is connected with our KVM VMs-providing cloud
infrastructure via IB.
There must have been a race with softirqs. We've got a custom kernel
module ("xt_ETHOIP6_gw") which handles the Ethernet<>IB.

The trace looks like that it caused the kernel trace together with the
tun driver. What does the "(O)" mean?

Should we look at our kernel module for better locking? What are the
common data structures with which races can occur? Something with the
connection manager?

Cheers,
Sebastian


WARNING: at net/sched/sch_generic.c:255 dev_watchdog+0x22c/0x240()
Hardware name: H8DGU
NETDEV WATCHDOG: ib0 (mlx4_core): transmit queue 0 timed out
Modules linked in: ipt_LOG xt_ETHOIP6_gw(O) ip6table_mangle
iptable_mangle ip6table_filter ip6_tables tun(O) bridge stp llc rdma_uc=
m
rdma_cm iw_cm ib_addr ib_ipoib ib_cm ib_sa ib_uverbs ib_umad ib_qib
mlx4_ib xt_multiport iptable_filter ip_tables x_tables ib_mthca ib_mad
ib_core kvm_amd kvm psmouse tpm_tis tpm tpm_bios amd64_edac_mod
i2c_piix4 edac_core serio_raw evdev edac_mce_amd button processor
thermal_sys mlx4_en sg usb_storage mlx4_core ixgbe dca mdio [last
unloaded: scsi_wait_scan]
Pid: 3, comm: ksoftirqd/0 Tainted: G O 3.2.8-gw #1
Call Trace:
[<ffffffff81047dbb>] ? warn_slowpath_common+0x7b/0xc0
[<ffffffff81047eb5>] ? warn_slowpath_fmt+0x45/0x50
[<ffffffff81058333>] ? mod_timer+0x153/0x2a0
[<ffffffff81584bec>] ? dev_watchdog+0x22c/0x240
[<ffffffff810572a8>] ? run_timer_softirq+0x158/0x360
[<ffffffff815849c0>] ? __netdev_watchdog_up+0x70/0x70
[<ffffffff8168dc8a>] ? __schedule+0x2ea/0x7e0
[<ffffffff8104e481>] ? __do_softirq+0xb1/0x1e0
[<ffffffff8104e661>] ? run_ksoftirqd+0xb1/0x160
[<ffffffff8104e5b0>] ? __do_softirq+0x1e0/0x1e0
[<ffffffff8104e5b0>] ? __do_softirq+0x1e0/0x1e0
[<ffffffff81069176>] ? kthread+0x96/0xa0
[<ffffffff816997b4>] ? kernel_thread_helper+0x4/0x10
[<ffffffff810690e0>] ? kthread_worker_fn+0x180/0x180
[<ffffffff816997b0>] ? gs_change+0x13/0x13
---[ end trace a4ac921bb1a9d647 ]---
ib0: transmit timeout: latency 1770 msecs
ib0: queue stopped 1, tx_head 39614, tx_tail 39614


--=20
Sebastian Riemer
Linux Kernel Developer

ProfitBricks GmbH =95 Greifswalder Str. 207 =95 10405 Berlin, Germany
www.profitbricks.com =95 sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
Tel.: +49 - 30 - 60 98 56 991 - 915

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=E4ftsf=FChrer: Andreas Gauger, Achim Weiss

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
