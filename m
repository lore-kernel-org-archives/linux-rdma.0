From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 3/3] IB/mlx4: Fix mlx4_ib_poll_cq possible missed completion
Date: Tue,  6 Mar 2012 15:50:51 +0200
Message-ID: <1331041851-20498-4-git-send-email-ogerlitz@mellanox.com>
References: <1331041851-20498-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1331041851-20498-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

If an erroneous CQE was polled in the first iteration (e.g. npolled == 0), we
would not update the consumer index hence the hardware could get a wrong notion
of how many CQEs software polled. Fix this by unconditionally updating the
doorbell record. We could put a condition like

if (npolled || err != -EAGAIN)
	...

but it does not seem worth the effort since a posted write to memory should not
cost too much.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/cq.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index 5ecf38d..275861b 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -747,8 +747,7 @@ int mlx4_ib_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
 			break;
 	}
 
-	if (npolled)
-		mlx4_cq_set_ci(&cq->mcq);
+	mlx4_cq_set_ci(&cq->mcq);
 
 	spin_unlock_irqrestore(&cq->lock, flags);
 
-- 
1.6.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
