From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] IB/mlx4: Fix possible incorrect cq completions flushing in internal error state
Date: Sun,  9 Aug 2015 11:16:27 +0300
Message-ID: <1439108187-12785-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When handling a device internal error, the driver is responsible to
drain the completion queue with flush errors.

In case a completion queue was assigned to multiple send queues, the
driver iterates over the send queues and generates flush errors of
inflight wqes. The driver must correctly pass the wc array with an
offset as a result of the previous send queue iteration. Not doing so
will overwrite previously set completions and return a wrong number
of polled completions which includes ones which were not correctly set.

Fixes: 35f05dabf95a (IB/mlx4: Reset flow support for IB kernel ULPs)
Signed-off-by: Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/cq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index 36eb3d0..2f42595 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -638,7 +638,7 @@ static void mlx4_ib_poll_sw_comp(struct mlx4_ib_cq *cq, int num_entries,
 	 * simulated FLUSH_ERR completions
 	 */
 	list_for_each_entry(qp, &cq->send_qp_list, cq_send_list) {
-		mlx4_ib_qp_sw_comp(qp, num_entries, wc, npolled, 1);
+		mlx4_ib_qp_sw_comp(qp, num_entries, wc + *npolled, npolled, 1);
 		if (*npolled >= num_entries)
 			goto out;
 	}
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
