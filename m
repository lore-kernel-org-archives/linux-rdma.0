From: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH 3/3] mlx4_en: use MLX4_LEAST_ATTACHED_VECTOR for TX cqs
Date: Thu, 13 May 2010 12:25:23 +0300
Message-ID: <4BEBC583.4050308@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Instead always setting all the TX cqs to use comletion vector 0,
let the mlx4_core to distribute them to avoid situation where some eqs
are very loaded while other do nothing.

Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/net/mlx4/en_cq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/mlx4/en_cq.c b/drivers/net/mlx4/en_cq.c
index 21786ad..f3dc8b7 100644
--- a/drivers/net/mlx4/en_cq.c
+++ b/drivers/net/mlx4/en_cq.c
@@ -56,7 +56,7 @@ int mlx4_en_create_cq(struct mlx4_en_priv *priv,
 		cq->vector   = ring % mdev->dev->caps.num_comp_vectors;
 	} else {
 		cq->buf_size = sizeof(struct mlx4_cqe);
-		cq->vector   = 0;
+		cq->vector   = MLX4_LEAST_ATTACHED_VECTOR;
 	}
 
 	cq->ring = ring;
-- 
1.6.1.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
