From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: IPoIB oops
Date: Tue, 24 Jul 2012 18:14:56 +0300
Message-ID: <500EBBF0.3020407@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

Just encountered a kernel oops in IPoIB on upstream kernel 3.5.

GIT:  git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
Branch :  Master



The scenario is reproducible - running in a loop unload/load of ipoib 
module.
Oops happened in ipoib_mcast_join_task.

 From initial analysis it seems that problem is in below line as 
priv->broadcast is NULL. (saw it in printk)
priv->mcast_mtu = 
IPOIB_UD_MTU(ib_mtu_enum_to_int(priv->broadcast->mcmember.mtu));

It seems that a work queue task is still active while module goes down.
Any idea about a potential problem here ? may it relate to your 
assumption in commita77a57a1a22afc31891d95879fe3cf2ab03838b0 that flush 
of work queue is not mandatory in some cases ?


Details to reproduce and dump are below
Thanks,
Yishai


Reproduction:

echo "alias ib0 ib_ipoib" > /etc/modprobe.d/ib_ipoib.conf
Run below script:

#!/bin/sh
# Loop forever
while :
do
modprobe -r ib_ipoib
ifconfig ib0 1.1.1.104 netmask 255.255.255.0 up
done # Start over

Dump:
BUG: unable to handle kernel NULL pointer dereference at 0000000000000027
IP: [<ffffffffa0750147>] ipoib_mcast_join_task+0x217/0x350 [ib_ipoib]
PGD 0
Oops: 0000 [#1] SMP
Modules linked in: ib_ipoib(-) netconsole configfs rdma_ucm ib_ucm 
rdma_cm iw_cm ib_addr ib_cm ib_sa ib_uverbs ib_umad mlx4_ib ib_mad 
ib_core mlx4_en mlx4_core ip6table_filter ip6_tables ebtable_nat 
ebtables ipt_REJECT xt_CHECKSUM nfsd exportfs autofs4 nfs lockd fscache 
auth_rpcgss nfs_acl sunrpc bridge stp llc ipv6 dm_mirror dm_region_hash 
dm_log dm_mod vhost_net macvtap macvlan tun iTCO_wdt iTCO_vendor_support 
dcdbas coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel 
aesni_intel cryptd aes_x86_64 aes_generic microcode ses enclosure sg 
serio_raw pcspkr lpc_ich mfd_core i7core_edac edac_core bnx2 ext3 jbd 
mbcache sr_mod cdrom sd_mod crc_t10dif pata_acpi ata_generic ata_piix 
megaraid_sas [last unloaded: ib_ipoib]
CPU 4
Pid: 8788, comm: kworker/u:1 Not tainted 3.5.0+ #1 Dell Inc. PowerEdge 
R710/0MD99X
RIP: 0010:[<ffffffffa0750147>]  [<ffffffffa0750147>] 
ipoib_mcast_join_task+0x217/0x350 [ib_ipoib]
RSP: 0018:ffff88085412fda0  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88045c59e900 RCX: ffff88045c59e878
RDX: ffff88045c59e878 RSI: ffff88045c59e810 RDI: ffff88045c59e7c0
RBP: ffff88085412fdf0 R08: ffff88085412fb98 R09: 0140000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: ffff88045c59e7c0
R13: ffff88045c59e000 R14: ffff88045c59eac0 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88087fc40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000027 CR3: 0000000001a0b000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kworker/u:1 (pid: 8788, threadinfo ffff88085412e000, task 
ffff88086995e140)
Stack:
  0000000500000004 0000008000000004 400000000251486a 0000000000000000
  0400000200020080 0000051002001200 ffff880868e59940 ffffffff81d538c0
  ffff88045b33bc00 ffffffffa074ff30 ffff88085412fe50 ffffffff8106e872
Call Trace:
  [<ffffffffa074ff30>] ? ipoib_mcast_join+0x200/0x200 [ib_ipoib]
  [<ffffffff8106e872>] process_one_work+0x132/0x450
  [<ffffffff8107067b>] worker_thread+0x17b/0x3c0
  [<ffffffff81070500>] ? manage_workers+0x120/0x120
  [<ffffffff810757be>] kthread+0x9e/0xb0
  [<ffffffff81522664>] kernel_thread_helper+0x4/0x10
  [<ffffffff81075720>] ? kthread_freezable_should_stop+0x70/0x70
  [<ffffffff81522660>] ? gs_change+0x13/0x13
Code: 66 83 83 c0 fe ff ff 01 fb 66 66 90 66 66 90 48 8b b3 70 ff ff ff 
e9 d3 fe ff ff 66 0f 1f 84 00 00 00 00 00 48 8b 83 70 ff ff ff <0f> b6 
50 27 b8 fb ff ff ff 83 ea 01 83 fa 04 77 0c 89 d2 8b 04
RIP  [<ffffffffa0750147>] ipoib_mcast_join_task+0x217/0x350 [ib_ipoib]
  RSP <ffff88085412fda0>
CR2: 0000000000000027
---[ end trace a8af87e7ad29e6a9 ]---



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
