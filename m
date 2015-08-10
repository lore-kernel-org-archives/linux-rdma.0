From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] IB/srp: Fix possible use-after-free
Date: Mon, 10 Aug 2015 17:22:54 +0300
Message-ID: <1439216574-25936-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

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
RIP: 0010:[<ffffffff8151121b>]  [<ffffffff8151121b>] _raw_spin_lock_irqsave+0x1b/0x50
Call Trace:
 [<ffffffffa055d88a>] ib_fmr_pool_unmap+0x1a/0xb0 [ib_core]
 [<ffffffffa06c00ed>] srp_unmap_data+0x17d/0x250 [ib_srp]
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
 drivers/infiniband/ulp/srp/ib_srp.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 3a1514c..93eadfb 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -620,6 +620,10 @@ static void srp_free_ch_ib(struct srp_target_port *target,
 	if (!ch->qp)
 		return;
 
+	srp_destroy_qp(ch);
+	ib_destroy_cq(ch->send_cq);
+	ib_destroy_cq(ch->recv_cq);
+
 	if (dev->use_fast_reg) {
 		if (ch->fr_pool)
 			srp_destroy_fr_pool(ch->fr_pool);
@@ -627,9 +631,6 @@ static void srp_free_ch_ib(struct srp_target_port *target,
 		if (ch->fmr_pool)
 			ib_destroy_fmr_pool(ch->fmr_pool);
 	}
-	srp_destroy_qp(ch);
-	ib_destroy_cq(ch->send_cq);
-	ib_destroy_cq(ch->recv_cq);
 
 	/*
 	 * Avoid that the SCSI error handler tries to use this channel after
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
