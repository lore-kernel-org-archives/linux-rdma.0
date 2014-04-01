From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/5] IB/iser: Drain the tx cq once before looping on the rx cq
Date: Tue,  1 Apr 2014 16:19:00 +0300
Message-ID: <1396358344-15191-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The iser disconnection flow isn't done before all the inflight recv/send buffers
posted to the QP are either flushed or normally completed to the CQ that
serves this connection. The condition check is done in iser_handle_comp_error().

Currently, its possible for the send buffer completion which makes the posted
send buffers counter to reach zero to be polled in the drain tx call which is
after the rx cq was fully drained. Since this completion might be not an error
one (e.g. of the logout request iSCSI PDU) we will skip iser_handle_comp_error()
so the connection will never terminate from the iscsi stack point of view,
and we hang.

To resolve this race, do the draining of the tx cq before the loop on the rx cq.

Issue: 375623

Change-Id: I38952f738ac0e3373f6651987136bcc0fed18b7c
Signed-off-by: Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_verbs.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index abbb6ec..a29f37e 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -1112,8 +1112,12 @@ static void iser_cq_tasklet_fn(unsigned long data)
 	 struct iser_rx_desc *desc;
 	 unsigned long	     xfer_len;
 	struct iser_conn *ib_conn;
-	int completed_tx, completed_rx;
-	completed_tx = completed_rx = 0;
+	int completed_tx, completed_rx = 0;
+
+	/* First do tx drain, so in a case where we have rx flushes and a successful
+	 * tx completion we will still go through completion error handling.
+	 */
+	completed_tx = iser_drain_tx_cq(device, cq_index);
 
 	while (ib_poll_cq(cq, 1, &wc) == 1) {
 		desc	 = (struct iser_rx_desc *) (unsigned long) wc.wr_id;
@@ -1141,7 +1145,6 @@ static void iser_cq_tasklet_fn(unsigned long data)
 	 * " would not cause interrupts to be missed"                       */
 	ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
 
-	completed_tx += iser_drain_tx_cq(device, cq_index);
 	iser_dbg("got %d rx %d tx completions\n", completed_rx, completed_tx);
 }
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
