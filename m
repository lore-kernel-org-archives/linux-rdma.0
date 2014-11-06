From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH v1 for-next 1/5] IB/mlx5: Fix sparse warnings
Date: Thu,  6 Nov 2014 16:21:48 +0200
Message-ID: <1415283712-13931-2-git-send-email-eli@mellanox.com>
References: <1415283712-13931-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415283712-13931-1-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

1. Add required __acquire/__release statements to balance spinlock usage.
2. Change the index parameter of begin_wqe() to be unsigned to match supplied
argument type.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index e261a53f9a02..9ca39ad68cb8 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1011,9 +1011,14 @@ static void mlx5_ib_lock_cqs(struct mlx5_ib_cq *send_cq, struct mlx5_ib_cq *recv
 			}
 		} else {
 			spin_lock_irq(&send_cq->lock);
+			__acquire(&recv_cq->lock);
 		}
 	} else if (recv_cq) {
 		spin_lock_irq(&recv_cq->lock);
+		__acquire(&send_cq->lock);
+	} else {
+		__acquire(&send_cq->lock);
+		__acquire(&recv_cq->lock);
 	}
 }
 
@@ -1033,10 +1038,15 @@ static void mlx5_ib_unlock_cqs(struct mlx5_ib_cq *send_cq, struct mlx5_ib_cq *re
 				spin_unlock_irq(&recv_cq->lock);
 			}
 		} else {
+			__release(&recv_cq->lock);
 			spin_unlock_irq(&send_cq->lock);
 		}
 	} else if (recv_cq) {
+		__release(&send_cq->lock);
 		spin_unlock_irq(&recv_cq->lock);
+	} else {
+		__release(&recv_cq->lock);
+		__release(&send_cq->lock);
 	}
 }
 
@@ -2411,7 +2421,7 @@ static u8 get_fence(u8 fence, struct ib_send_wr *wr)
 
 static int begin_wqe(struct mlx5_ib_qp *qp, void **seg,
 		     struct mlx5_wqe_ctrl_seg **ctrl,
-		     struct ib_send_wr *wr, int *idx,
+		     struct ib_send_wr *wr, unsigned *idx,
 		     int *size, int nreq)
 {
 	int err = 0;
@@ -2737,6 +2747,8 @@ out:
 
 		if (bf->need_lock)
 			spin_lock(&bf->lock);
+		else
+			__acquire(&bf->lock);
 
 		/* TBD enable WC */
 		if (0 && nreq == 1 && bf->uuarn && inl && size > 1 && size <= bf->buf_size / 16) {
@@ -2753,6 +2765,8 @@ out:
 		bf->offset ^= bf->buf_size;
 		if (bf->need_lock)
 			spin_unlock(&bf->lock);
+		else
+			__release(&bf->lock);
 	}
 
 	spin_unlock_irqrestore(&qp->sq.lock, flags);
-- 
2.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
