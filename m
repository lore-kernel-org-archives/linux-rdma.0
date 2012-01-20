From: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Subject: cq-event kernel panic
Date: Fri, 20 Jan 2012 12:06:38 +0100
Message-ID: <4F194ABE.5080108@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We are still seeing kernel panics with linux-3.2, this time initiated 
from mthca_cq_event(). I'm unsure if this is somehow related to the 
yesterdays cq_completion patch. In any case, I'm CCing Sean therefore.

kernel logs sometimes show something like

ib_mthca 0000:01:00.0: CQ access violation on CQN 2c0089

and at the same time either our FhGFS daemons, which are using ibverbs 
crash with a segmentation fault or the entire kernel crashes with panic 
as given below. My next step is to debug our FhGFS crashes to see if 
this is from ib libs or a real issue of the daemon.

Below is the kernel panic. The kernel already includes the patch to 
initialized qp->usecnt.

> [53904.589342] ib_mthca 0000:01:00.0: CQ access violation on CQN 00008b
> [53964.464518] ib_mthca 0000:01:00.0: CQ access violation on CQN d2009f
> [53964.468302] BUG: unable to handle kernel NULL pointer dereference at 0000000000000058
> [53964.468302] IP: [<ffffffffa03a71a8>] ib_uverbs_async_handler+0x28/0x150 [ib_uverbs]
> [53964.468302] PGD 1f8d18067 PUD 1f3904067 PMD 0
> [53964.468302] Oops: 0000 [#1] SMP
> [53964.468302] CPU 1
> [53964.468302] Modules linked in: nfsd ext4 mbcache jbd2 crc16 mlx4_ib mlx4_core ib_umad rdma_ucm rdma_cm iw_cm ib_addr ib_uverbs ib_ipoib ib_cm ib_sa sg ipv6 sd_mod crc_t10dif loop arcmsr md_mod pcspkr 8250_pnp ib_mthca ib_mad ib_core fuse af_packet nfs lockd fscache auth_rpcgss nfs_acl sunrpc btrfs lzo_decompress lzo_compress zlib_deflate crc32c libcrc32c crypto_hash crypto_algapi ata_generic pata_acpi pata_amd e1000 sata_nv libata scsi_mod unix [last unloaded: scsi_wait_scan]
> [53964.468302]
> [53964.468302] Pid: 10644, comm: fhgfs-storage-u Not tainted 3.2.0+ #10 Supermicro H8DCE/H8DCE
> [53964.468302] RIP: 0010:[<ffffffffa03a71a8>]  [<ffffffffa03a71a8>] ib_uverbs_async_handler+0x28/0x150 [ib_uverbs]
> [53964.468302] RSP: 0018:ffff8801ffc039b0  EFLAGS: 00010082
> [53964.468302] RAX: ffff8801f948e300 RBX: 0000000000000000 RCX: ffff8801f948e370
> [53964.468302] RDX: 0000000000000000 RSI: ffff8801f948ee40 RDI: 0000000000000000
> [53964.468302] RBP: ffff8801ffc039f0 R08: ffff8801f948e384 R09: ffffffff8142c5e0
> [53964.468302] R10: 0000000000000006 R11: 000000000000000d R12: 0000000000d2009f
> [53964.468302] R13: ffff8800bf5aba20 R14: 0000000000000000 R15: ffff8801f3a82400
> [53964.468302] FS:  00007ffff4ca7700(0000) GS:ffff8801ffc00000(0000) knlGS:0000000000000000
> [53964.468302] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [53964.468302] CR2: 0000000000000058 CR3: 00000001f96d4000 CR4: 00000000000006e0
> [53964.468302] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [53964.468302] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [53964.468302] Process fhgfs-storage-u (pid: 10644, threadinfo ffff880000090000, task ffff8800c8139650)
> [53964.468302] Stack:
> [53964.468302]  ffff8801ffc03a00 ffff8801f948e384 ffffffffa0318208 ffff8800bf5ab000
> [53964.468302]  0000000000d2009f ffff8800bf5aba20 0000000000000000 ffff8801f3a82400
> [53964.468302]  ffff8801ffc03a00 ffffffffa03a737b ffff8801ffc03a60 ffffffffa0306f77
> [53964.468302] Call Trace:
> [53964.468302]  <IRQ>
> [53964.468302]  [<ffffffffa03a737b>] ib_uverbs_cq_event_handler+0x2b/0x30 [ib_uverbs]
> [53964.468302]  [<ffffffffa0306f77>] mthca_cq_event+0x87/0x110 [ib_mthca]
> [53964.468302]  [<ffffffffa03062a4>] mthca_eq_int+0x2d4/0x410 [ib_mthca]
> [53964.468302]  [<ffffffffa0306544>] mthca_arbel_msi_x_interrupt+0x24/0x60 [ib_mthca]
> [53964.468302]  [<ffffffff810b54fd>] handle_irq_event_percpu+0x5d/0x210
> [53964.468302]  [<ffffffff810b56f0>] handle_irq_event+0x40/0x70
> [53964.468302]  [<ffffffff810b8d0d>] handle_edge_irq+0x6d/0x120
> [53964.468302]  [<ffffffff810166a2>] handle_irq+0x22/0x30
> [53964.468302]  [<ffffffff81390aad>] do_IRQ+0x5d/0xe0
> [53964.468302]  [<ffffffff81385eb3>] common_interrupt+0x73/0x73
> [53964.468302]  [<ffffffff812e3f9b>] ? __alloc_skb+0x4b/0x170
> [53964.468302]  [<ffffffff8113e0fb>] ? kmem_cache_alloc_node+0x3b/0x130
> [53964.468302]  [<ffffffff8131af61>] ? ip_rcv+0x201/0x2e0
> [53964.468302]  [<ffffffff812e3f9b>] __alloc_skb+0x4b/0x170
> [53964.468302]  [<ffffffff812e457d>] dev_alloc_skb+0x1d/0x40
> [53964.468302]  [<ffffffffa0395fca>] ipoib_alloc_rx_skb+0x4a/0x380 [ib_ipoib]


ib_uverbs_async_handler+0x28 translates to

> Reading symbols from /home/schubert/src/linux/linux-stable/debian/tmp/lib/modules/3.2.0+/kernel/drivers/infiniband/core/ib_uverbs.ko...done.
> (gdb) l *(ib_uverbs_async_handler+0x28)
> 0x11a8 is in ib_uverbs_async_handler (drivers/infiniband/core/uverbs_main.c:440).
> 435                                         u32 *counter)
> 436     {
> 437             struct ib_uverbs_event *entry;
> 438             unsigned long flags;
> 439
> 440             spin_lock_irqsave(&file->async_file->lock, flags);
> 441             if (file->async_file->is_closed) {
> 442                     spin_unlock_irqrestore(&file->async_file->lock, flags);
> 443                     return;
> 444             }


Any ideas?


Thanks,
Bernd
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
