From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] ib/mlx4: add IB_CQ_REPORT_MISSED_EVENTS support
Date: Tue, 27 Jul 2010 11:21:13 +0300
Message-ID: <4C4E96F9.4040503@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

enhance the cq arming code to support IB_CQ_REPORT_MISSED_EVENTS

Signed-off-by: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>

----

I noted that the IB_CQ_REPORT_MISSED_EVENTS flag was added in the same cycle with mlx4
and maybe as of this, mlx4 didn't implement the flag, which is used by IPoIB

The patch is compile tested only, if the patch seems okay, I can conduct further testing.

diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index 5a219a2..4366811 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -755,6 +755,13 @@ int mlx4_ib_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags)
 		    to_mdev(ibcq->device)->uar_map,
 		    MLX4_GET_DOORBELL_LOCK(&to_mdev(ibcq->device)->uar_lock));
 
+	if (flags & IB_CQ_REPORT_MISSED_EVENTS) {
+		struct mlx4_cqe *cqe;
+		cqe = next_cqe_sw(to_mcq(ibcq));
+		if (cqe)
+			return 1;
+	}
+
 	return 0;
 }
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
