From: Saurabh Sengar <saurabh.truth@gmail.com>
Subject: [PATCH] IB/mlx5: fix null dereference
Date: Sun, 22 Nov 2015 18:18:37 +0530
Message-ID: <1448196517-13341-1-git-send-email-saurabh.truth@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: eli@mellanox.com, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Saurabh Sengar <saurabh.truth@gmail.com>
List-Id: linux-rdma@vger.kernel.org

removing null dereference

Signed-off-by: Saurabh Sengar <saurabh.truth@gmail.com>
---
is there any better way to fix it ?
as if there is no 'x' there is no way we can access 'x->lock'

 drivers/infiniband/hw/mlx5/qp.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 307bdbc..613a853 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1064,13 +1064,10 @@ static void mlx5_ib_lock_cqs(struct mlx5_ib_cq *send_cq, struct mlx5_ib_cq *recv
 			}
 		} else {
 			spin_lock_irq(&send_cq->lock);
-			__acquire(&recv_cq->lock);
 		}
 	} else if (recv_cq) {
 		spin_lock_irq(&recv_cq->lock);
-		__acquire(&send_cq->lock);
 	} else {
-		__acquire(&send_cq->lock);
 		__acquire(&recv_cq->lock);
 	}
 }
@@ -1091,15 +1088,12 @@ static void mlx5_ib_unlock_cqs(struct mlx5_ib_cq *send_cq, struct mlx5_ib_cq *re
 				spin_unlock_irq(&recv_cq->lock);
 			}
 		} else {
-			__release(&recv_cq->lock);
 			spin_unlock_irq(&send_cq->lock);
 		}
 	} else if (recv_cq) {
-		__release(&send_cq->lock);
 		spin_unlock_irq(&recv_cq->lock);
 	} else {
 		__release(&recv_cq->lock);
-		__release(&send_cq->lock);
 	}
 }
 
-- 
1.9.1
