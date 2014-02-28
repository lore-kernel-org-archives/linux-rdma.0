From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: Re: Need help with strange mlx4_core error
Date: Fri, 28 Feb 2014 22:35:23 +0400
Message-ID: <CACaajQuQ+mbwhp4jxUt+9r4Rq=14oBUqC-=xx6J3EGpAfecG-Q@mail.gmail.com>
References: <CACaajQtQGZSepA8VLK1K20OspNa_WTv1DQ8SWYV7O9y6QV-Tgg@mail.gmail.com>
 <CAJZOPZJmdGutUQZ4icBrKRq-YPwD8TqtoLH9SgqNVx_CDjL0TQ@mail.gmail.com>
 <CACaajQtHzF9g2kp9MrAaQsvKUQdr10YVa+Np1danmAcR_rvLqg@mail.gmail.com>
 <CAJZOPZKydkaoru0XyT1nHQ5t9BGJQxbq1r4RcGZ0Gq9E9VGs=A@mail.gmail.com>
 <CACaajQs9ANqLX7m=TcR2wT6wkiS-M5uVvAnQrvGWPmukZnLqcg@mail.gmail.com>
 <CACaajQuRzBy3oV+-3+NjyE9muGKPN3YQUd5wnkkcoak0GSP=uw@mail.gmail.com> <CACaajQtKvihFu6X-+9N3VvVKK4Jw3eADBOENhuM+-4s8s=PsUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACaajQtKvihFu6X-+9N3VvVKK4Jw3eADBOENhuM+-4s8s=PsUQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

2014-02-28 22:24 GMT+04:00 Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>:
>>>> This is pretty much very old firmware, could you update it please with
>>>> the latest GA from the mellanox site and see if things smile back?
>>>> also send the "lspci | grep -i Mellanox"
>>


And after looking dmesg i see sometime early:
[271701.934646] device ib0 left promiscuous mode
[292670.940271] ------------[ cut here ]------------
[292670.940309] WARNING: at
/tmp/buildd/linux-3.10.11/net/sched/sch_generic.c:255
dev_watchdog+0xe3/0x153()
[292670.940359] NETDEV WATCHDOG: ib0 (mlx4_core): transmit queue 0 timed out
[292670.940388] Modules linked in: tcp_diag inet_diag ip_set_hash_net
xt_set ip_set nfnetlink xt_tcpudp xt_pkttype ip6table_mangle
ip6table_raw iptable_mangle iptable_raw
 ip6table_filter ip6_tables iptable_filter ip_tables 8021q garp stp
mrp llc bonding ib_ucm ib_uverbs ib_addr ib_umad ib_ipoib ib_srp
scsi_transport_srp ib_cm scsi_tgt mlx
4_ib ib_sa ib_mad ib_core mlx4_en ipmi_si ipmi_devintf ipmi_msghandler
ipt_NETFLOW(O) x_tables dm_mod md_mod iTCO_wdt coretemp acpi_cpufreq
i7core_edac snd_pcm mperf iTCO
_vendor_support snd_page_alloc snd_timer edac_core snd soundcore
psmouse kvm_intel i2c_i801 ioatdma pcspkr serio_raw kvm lpc_ich evdev
joydev mfd_core crc32c_intel proces
sor button thermal_sys squashfs loop aufs(C) hid_generic usbhid hid
ata_generic ata_piix microcode uhci_hcd ehci_pci mpt2sas libata
ehci_hcd raid_class scsi_transport_sas
 usbcore usb_common scsi_mod mlx4_core igb i2c_algo_bit i2c_core dca
ptp pps_core [last unloaded: nf_conntrack]
[292670.940991] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G         CIO
3.10-3-amd64 #1 Debian
3.10.11-3+0~20131204153435.21+wheezy~1.gbpa177bd
[292670.941045] Hardware name: Supermicro B8DT6/B8DT6, BIOS 080015  03/03/2010
[292670.941075]  ffffffff8138d323 0000000000000000 ffffffff8103be31
ffff8801bfc0dc00
[292670.941130]  ffff8801bfc03e08 0000000000000000 ffff8801b8688000
0000000000000100
[292670.941185]  ffffffff812e5e78 ffff8801b8688348 ffffffff8103bee1
ffffffff8153628f
[292670.941240] Call Trace:
[292670.941262]  <IRQ>  [<ffffffff8138d323>] ? dump_stack+0xd/0x17
[292670.941303]  [<ffffffff8103be31>] ? warn_slowpath_common+0x5f/0x77
[292670.941334]  [<ffffffff812e5e78>] ? netif_tx_lock+0x7a/0x7a
[292670.941364]  [<ffffffff8103bee1>] ? warn_slowpath_fmt+0x45/0x4a
[292670.941394]  [<ffffffff812e5e65>] ? netif_tx_lock+0x67/0x7a
[292670.941426]  [<ffffffff812e5f5b>] ? dev_watchdog+0xe3/0x153
[292670.941458]  [<ffffffff810471ee>] ? call_timer_fn+0x4b/0xf6
[292670.941488]  [<ffffffff812e5e78>] ? netif_tx_lock+0x7a/0x7a
[292670.941518]  [<ffffffff810482fe>] ? run_timer_softirq+0x18d/0x1d6
[292670.941548]  [<ffffffff81042576>] ? __do_softirq+0xec/0x209
[292670.941578]  [<ffffffff8104275e>] ? irq_exit+0x3f/0x83
[292670.941608]  [<ffffffff8100e6f3>] ? do_IRQ+0x81/0x97
[292670.941639]  [<ffffffff81390a6d>] ? common_interrupt+0x6d/0x6d
[292670.941666]  <EOI>  [<ffffffff812a70ec>] ? arch_local_irq_enable+0x4/0x8
[292670.941708]  [<ffffffff812a74af>] ? cpuidle_enter_state+0x46/0xb1
[292670.941739]  [<ffffffff812a75f0>] ? cpuidle_idle_call+0xd6/0x147
[292670.941770]  [<ffffffff81013add>] ? arch_cpu_idle+0x6/0x1a
[292670.941802]  [<ffffffff810734d3>] ? cpu_startup_entry+0x114/0x191
[292670.941835]  [<ffffffff816b3d51>] ? start_kernel+0x3e8/0x3f3
[292670.941864]  [<ffffffff816b377f>] ? repair_env_string+0x57/0x57
[292670.941895]  [<ffffffff816b359a>] ? x86_64_start_kernel+0xf2/0xfd
[292670.941924] ---[ end trace 119aa908393ed9b3 ]---
[292670.941950] ib0: transmit timeout: latency 1356 msecs
[292670.941977] ib0: queue stopped 1, tx_head 595756, tx_tail 595756


-- 
Vasiliy Tolstov,
e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
jabber: vase-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
