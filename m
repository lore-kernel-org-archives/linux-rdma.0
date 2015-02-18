From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 3/3] IB/mlx5: Enable the ODP capability query verb
Date: Wed, 18 Feb 2015 09:26:04 +0200
Message-ID: <1424244364-6242-4-git-send-email-haggaie@mellanox.com>
References: <1424244364-6242-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424244364-6242-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Re-enable the on-demand paging capability query through the extended query
device verb. This was initially part of commit 8cdd312cfed7 ("IB/mlx5:
Implement the ODP capability query verb").

Reviewed-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index b1eda4a602a8..cc4ac1e583b2 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1331,6 +1331,8 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 		(1ull << IB_USER_VERBS_CMD_DESTROY_SRQ)		|
 		(1ull << IB_USER_VERBS_CMD_CREATE_XSRQ)		|
 		(1ull << IB_USER_VERBS_CMD_OPEN_QP);
+	dev->ib_dev.uverbs_ex_cmd_mask =
+		(1ull << IB_USER_VERBS_EX_CMD_QUERY_DEVICE);
 
 	dev->ib_dev.query_device	= mlx5_ib_query_device;
 	dev->ib_dev.query_port		= mlx5_ib_query_port;
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
