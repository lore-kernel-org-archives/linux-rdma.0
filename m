From: Josh England <jjengla-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: NULL pointer dereference in rdma_ucm
Date: Mon, 19 Jul 2010 16:20:58 -0700
Message-ID: <AANLkTikwDEJY_F1ziGNPhYMBJEBC5UqD2XOLM7wSByj1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,
I'm experimenting with an rdma_cm application to push data around
between nodes on an ~1000 node cluster (CentOS-5.3 with 2.6.18-128.el5
and OFED-1.4.2).  Under heavy load, I'm seeing several nodes per day
kernel panic due to a NULL pointer dereference.  It may be that the
in-kernel field cm_id_priv has a NULL ->alt_av.port , causing the
Oops, but I don't know for sure.  Any ideas on how to debug this?

Unable to handle kernel NULL pointer dereference at 0000000000000078
RIP:
 [<ffffffff88047be5>] :ib_cm:ib_cm_init_qp_attr+0x23b/0x27a
PGD 3e420e067 PUD 342b3b067 PMD 0
Oops: 0000 [1] SMP
last sysfs file: /devices/pci0000:00/0000:00:00.0/irq
CPU 5
Modules linked in: panfs(PFU) rdma_ucm(FU) rdma_cm(FU) iw_cm(FU)
ib_addr(FU) ib_uverbs(FU) ib_umad(FU) dm_mirror dm_log dm_multipath
scsi_dh dm_mod video hwmon backlight sbs i2c_ec button battery asus_acpi
acpi_memhotplug ac parport_pc lp parport joydev shpchp e1000e i2c_i801
i2c_core pcspkr ehci_hcd ata_piix libata scsi_mod uhci_hcd nfs(FU)
nfs_acl(FU) lockd(FU) sunrpc(FU) mlx4_ib(FU) mlx4_core(FU) ib_ipoib(FU)
ipv6 xfrm_nalgo crypto_api ib_cm(FU) ib_sa(FU) ib_mad(FU) ib_core(FU)
ipoib_helper(FU)
Pid: 28666, comm: pprod Tainted: PF     2.6.18-128.el5 #1
RIP: 0010:[<ffffffff88047be5>]
[<ffffffff88047be5>] :ib_cm:ib_cm_init_qp_attr+0x23b/0x27a
RSP: 0018:ffff8104a9af3d28  EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff81031f80d400 RCX: 0000000000000008
RDX: 0000000000000246 RSI: ffff81031f80d508 RDI: ffff8104a9af3e70
RBP: ffff8104a9af3e18 R08: 000000030000003a R09: 0000000000000000
R10: ffff8104a9af3e18 R11: 0000000000000088 R12: ffff8104a9af3d88
R13: 0000000000000000 R14: ffff81031f80d470 R15: 00007fff79f62940
FS:  00002ab130b6bca0(0000) GS:ffff81069524dd40(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000078 CR3: 000000049626c000 CR4: 00000000000006e0
Process pprod (pid: 28666, threadinfo ffff8104a9af2000, task
ffff81051fe737a0)
Stack:  ffff810666cad000 ffff8104a9af3d88 ffff8104a9af3e18
ffff8106952a1800
 0000000013a210c0 ffffffff88407850 000000000000003a ffff810466e06540
 ffff810c3dadeb40 ffff810466e06540 ffff8104a9af3e18 ffffffff8841725e
Call Trace:
 [<ffffffff88407850>] :rdma_cm:rdma_init_qp_attr+0xed/0x13f
 [<ffffffff8841725e>] :rdma_ucm:ucma_init_qp_attr+0x97/0xe4
 [<ffffffff8008a461>] default_wake_function+0x0/0xe
 [<ffffffff8008a461>] default_wake_function+0x0/0xe
 [<ffffffff800d66d2>] shmem_file_write+0x23f/0x251
 [<ffffffff88416326>] :rdma_ucm:ucma_write+0x73/0x91
 [<ffffffff8001659e>] vfs_write+0xce/0x174
 [<ffffffff80016e6b>] sys_write+0x45/0x6e
 [<ffffffff8005d116>] system_call+0x7e/0x83


Code: 8a 40 78 88 85 85 00 00 00 8b 83 28 01 00 00 66 89 45 7a 8a
RIP  [<ffffffff88047be5>] :ib_cm:ib_cm_init_qp_attr+0x23b/0x27a
 RSP <ffff8104a9af3d28>
CR2: 0000000000000078
 <0>Kernel panic - not syncing: Fatal exception

-JE
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
