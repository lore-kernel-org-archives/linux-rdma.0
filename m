From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] IB/srp: Fix possible use-after-free
Date: Tue, 11 Aug 2015 17:42:45 +0300
Message-ID: <55CA09E5.2070208@dev.mellanox.co.il>
References: <1439216574-25936-1-git-send-email-sagig@mellanox.com>
 <55C8BB38.1060808@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55C8BB38.1060808-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> With which kernel version has this been observed ? scsi_remove_host()
> waits until all outstanding requests have finished. srp_free_ch_ib() is
> called either before a SCSI host is registered with the SCSI core or
> after scsi_remove_host() has finished. So I don't see how the above call
> trace could be triggered with a recent kernel ?

Bart,

I think I confused in the patch I sent out.
The patch I sent was designed to address a theoretical race when
deleting a target during live IO.

This specific use-after-free occurred in a reconnect flow where
scsi_remove_host() is not invoked (assuming that dev_loss_tmo was
not invoked).

The below patch should address the same race in the reconnect flow:

[PATCH] IB/srp: Fix possible protection fault

srp_destroy_qp is designed to indicate we are safe to continue with
freeing the channel resources by modifying the qp error state,
posting a dummy wr on the queue-pair and waiting for it to flush.
This also holds for the channel registration pool as we are unmapping
the memory region when handling a scsi response. Destroying the
channel registration pool before we make sure we processed all the
inflight IO might introduce a use-after-free of the registration pool.

This use-after-free is demonstrated in the stack trace below where
srp is trying to unmap a used FMR after the fmr_pool was already destroyed.

general protection fault: 0000 [#1] SMP
RIP: 0010:[<ffffffff8151121b>]  [<ffffffff8151121b>] 
_raw_spin_lock_irqsave+0x1b/0x50
Call Trace:
  [<ffffffffa055d88a>] ib_fmr_pool_unmap+0x1a/0xb0 [ib_core]
  [<ffffffffa06c00ed>] srp_unmap_data.isra.28+0x17d/0x250 [ib_srp]
  [<ffffffffa06c01eb>] srp_free_req+0x2b/0x60 [ib_srp]
  [<ffffffffa06c0c94>] srp_recv_completion+0x174/0x580 [ib_srp]
  [<ffffffffa04580fe>] mlx4_eq_int+0x4de/0xe50 [mlx4_core]
  [<ffffffffa0458b00>] mlx4_msi_x_interrupt+0x10/0x20 [mlx4_core]
  [<ffffffff810abc45>] handle_irq_event_percpu+0x35/0x1b0
  [<ffffffff810abdf2>] handle_irq_event+0x32/0x50
  [<ffffffff810ae5cf>] handle_edge_irq+0x6f/0x120
  [<ffffffff8100455a>] handle_irq+0x1a/0x30
  [<ffffffff8151b475>] do_IRQ+0x45/0xb0
  [<ffffffff8151162d>] common_interrupt+0x6d/0x6d
  [<ffffffff813e4d2f>] cpuidle_enter_state+0x4f/0xc0
  [<ffffffff813e4e6c>] cpuidle_idle_call+0xcc/0x210
  [<ffffffff8100b9ea>] arch_cpu_idle+0xa/0x30
  [<ffffffff810ab1e1>] cpu_startup_entry+0xe1/0x270
  [<ffffffff81030b3a>] start_secondary+0x21a/0x2c0

Reported-by: Eliott Kespi <eliottk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
  drivers/infiniband/ulp/srp/ib_srp.c |   22 +++++++++++-----------
  1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c 
b/drivers/infiniband/ulp/srp/ib_srp.c
index 3a1514c..b220856 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -546,6 +546,17 @@ static int srp_create_ch_ib(struct srp_rdma_ch *ch)
         if (ret)
                 goto err_qp;

+       if (ch->qp)
+               srp_destroy_qp(ch);
+       if (ch->recv_cq)
+               ib_destroy_cq(ch->recv_cq);
+       if (ch->send_cq)
+               ib_destroy_cq(ch->send_cq);
+
+       ch->qp = qp;
+       ch->recv_cq = recv_cq;
+       ch->send_cq = send_cq;
+
         if (dev->use_fast_reg && dev->has_fr) {
                 fr_pool = srp_alloc_fr_pool(target);
                 if (IS_ERR(fr_pool)) {
@@ -570,17 +581,6 @@ static int srp_create_ch_ib(struct srp_rdma_ch *ch)
                 ch->fmr_pool = fmr_pool;
         }

-       if (ch->qp)
-               srp_destroy_qp(ch);
-       if (ch->recv_cq)
-               ib_destroy_cq(ch->recv_cq);
-
-       ch->qp = qp;
-       ch->recv_cq = recv_cq;
-       ch->send_cq = send_cq;
-
         kfree(init_attr);
         return 0;

--

Sorry for the mixup. Does this patch make more sense?

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
