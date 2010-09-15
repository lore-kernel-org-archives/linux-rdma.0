From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: BUG_ON fired in rds
Date: Wed, 15 Sep 2010 14:24:45 +0200
Message-ID: <20100915122445.GA6340@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg@mtldesk30
List-Id: linux-rdma@vger.kernel.org

Hi Andy,


I see BUG_ON(irqs_disabled()) fired in rds where rds_rdma_free_op() is
called from interrupt handler. Below is the call stack that shows
this.

[ 8785.787801] kernel BUG at /var/tmp/OFED_topdir/BUILD/ofa_kernel-1.5.2/net/rds/rdma.c:453!
[ 8785.796852] invalid opcode: 0000 [#1] SMP
[ 8785.801101] last sysfs file: /sys/devices/system/cpu/cpu15/cache/index2/shared_cpu_map
[ 8785.809864] Modules linked in: netconsole configfs autofs4 iptable_filter ip_tables x_tables nfs lockd fscache nfs_acl auth_rpcgss sunrpc af_packet cpufreq_conservative cpufreq_userspace cpufreq_powersave pcc_cpufreq rdma_ucm rds_tcp(N) rds_rdma(N) rds(N) rdma_cm iw_cm ib_addr ib_ipoib ib_cm ib_sa ipv6 ib_uverbs ib_umad mlx4_ib mlx4_en mlx4_core ib_mthca ib_mad ib_core microcode fuse loop dm_mod igb rtc_cmos hpilo rtc_core tpm_tis iTCO_wdt hpwdt tpm joydev rtc_lib iTCO_vendor_support dca tpm_bios power_meter pcspkr serio_raw container sg button usbhid hid uhci_hcd ehci_hcd sd_mod crc_t10dif usbcore edd ext3 mbcache jbd fan ide_pci_generic piix ide_core ata_generic ata_piix libata mptsas mptscsih mptbase scsi_transport_sas scsi_mod thermal processor thermal_sys hwmon [last unloaded: conf
 igfs]
[ 8785.893110] Supported: Yes
[ 8785.896199]
[ 8785.897852] Pid: 10550, comm: rds-stress Tainted: G          N (2.6.32.12-0.7-default #1) ProLiant BL2x220c G7
[ 8785.918095] EIP: 0060:[<f9cc18a7>] EFLAGS: 00010046 CPU: 8
[ 8785.924183] EIP is at rds_rdma_free_op+0x57/0x60 [rds]
[ 8785.930143] EAX: 00000046 EBX: c2d189c0 ECX: c2d57a60 EDX: 00000000
[ 8785.936628] ESI: 00000000 EDI: f5932780 EBP: f5932780 ESP: ecebfe20
[ 8785.943672]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[ 8785.950218] Process rds-stress (pid: 10550, ti=ecebe000 task=f4d0ce60 task.ti=ecebe000)
[ 8785.958421] Stack:
[ 8785.960838]  00000001 ed1e80d4 ed1e80c0 00000000 f9cbe5e4 ed1e80c0 ed1e80c0 f645905c
[ 8785.968931] <0> f9cbe63f 00000000 f9fd50ad 00000001 f55ba1d4 f7f36568 f5d8e000 f7f36568
[ 8785.978082] <0> 00000000 00000076 f5d8e000 f9fd52ef 00000000 00004e20 ed231800 ed231800
[ 8785.987239] Call Trace:
[ 8785.989822]  [<f9cbe5e4>] rds_message_purge+0x54/0x80 [rds]
[ 8785.995826]  [<f9cbe63f>] rds_message_put+0x2f/0x50 [rds]
[ 8786.001765]  [<f9fd50ad>] rds_ib_send_unmap_rm+0xad/0x130 [rds_rdma]
[ 8786.008877]  [<f9fd52ef>] rds_ib_send_cq_comp_handler+0x1bf/0x2d0 [rds_rdma]
[ 8786.016089]  [<f933943b>] mlx4_ib_cq_comp+0xb/0x10 [mlx4_ib]
[ 8786.024345]  [<f8d4bfd1>] mlx4_cq_completion+0x31/0x70 [mlx4_core]
[ 8786.034976]  [<f8d4ca84>] mlx4_eq_int+0x264/0x2b0 [mlx4_core]
[ 8786.046026]  [<f8d4cb39>] mlx4_msi_x_interrupt+0x9/0x10 [mlx4_core]
[ 8786.057913]  [<c028451d>] handle_IRQ_event+0x2d/0xc0
[ 8786.066747]  [<c02862e1>] handle_edge_irq+0xa1/0x110
[ 8786.075470]  [<c0205617>] handle_irq+0x17/0x20
[ 8786.079980]  [<c0204c27>] do_IRQ+0x47/0xc0
[ 8786.084605]  [<c0203829>] common_interrupt+0x29/0x30
[ 8786.090381]  [<ffffe430>] 0xffffe430
[ 8786.093966] Code: d8 e8 4e c8 5d c6 89 d8 83 c6 01 e8 54 e9 5d c6
83 c7 14 39 75 18 77 d4 8b 45 10 e8 04 26 60 c6 89 e8 5b 5e 5f 5d e9
f9 25 60 c6 <0f> 0b eb fe 90 8d 74 26 00 83 ec 10 89 1c 24 89 c3 89 74
24 04
[ 8786.114354] EIP: [<f9cc18a7>] rds_rdma_free_op+0x57/0x60 [rds] SS:ESP 0068:ecebfe20


My setup is (uname -a): Linux sw441 2.6.32.12-0.7-default #1 SMP 2010-05-20 11:14:20 +0200 i686 i686 i386 GNU/Linux

server: rds-stress -r 11.4.12.241 -p 19003 -c -t 10
client: ds-stress -r 11.4.12.243 -s 11.4.12.241 -p 19003 -c -T 100 -D 20000 -t 10

link layer is Ethernet (RoCE)
OFED-1.5.2 build from Sep 14th
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
