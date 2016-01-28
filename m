From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-4.5-rc2 V1 1/5] IB/mlx5: Add CREATE_CQ and CREATE_QP to uverbs_ex_cmd_mask
Date: Thu, 28 Jan 2016 17:51:46 +0200
Message-ID: <1453996310-3360-2-git-send-email-matanb@mellanox.com>
References: <1453996310-3360-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1453996310-3360-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The mlx5_ib driver supports the extended create_cq and create_qp user
verbs. In the current mechanism, a vendor supporting an extended uverb
should set the appropriate bit in the uverbs_ex_cmd_mask field.
Adding the actual support by setting the required bits in order to
support features like completion time-stamping and cross-channel.

Fixes: 972ecb821379 ('IB/mlx5: Add create_cq extended command')
Fixes: ddf9529be19c ('IB/core: Allow setting create flags in QP init
                      attribute')
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
There was a proposal [1] that lifts this requirement, however, this
proposal hasn't been accepted yet, and we want to make things to work
for 4.5. Hopefully, this proposal will be reviewed for 4.6.

[1] http://www.spinics.net/lists/linux-rdma/msg30019.html

 drivers/infiniband/hw/mlx5/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index ec737e2..6f67412 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2214,7 +2214,9 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 		(1ull << IB_USER_VERBS_CMD_CREATE_XSRQ)		|
 		(1ull << IB_USER_VERBS_CMD_OPEN_QP);
 	dev->ib_dev.uverbs_ex_cmd_mask =
-		(1ull << IB_USER_VERBS_EX_CMD_QUERY_DEVICE);
+		(1ull << IB_USER_VERBS_EX_CMD_QUERY_DEVICE)	|
+		(1ull << IB_USER_VERBS_EX_CMD_CREATE_CQ)	|
+		(1ull << IB_USER_VERBS_EX_CMD_CREATE_QP);
 
 	dev->ib_dev.query_device	= mlx5_ib_query_device;
 	dev->ib_dev.query_port		= mlx5_ib_query_port;
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
