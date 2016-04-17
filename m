From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 3/5] IB/core: Add Scatter FCS create flag
Date: Sun, 17 Apr 2016 17:19:36 +0300
Message-ID: <1460902778-5977-4-git-send-email-matanb@mellanox.com>
References: <1460902778-5977-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460902778-5977-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Raw Packet QPs that were created with Scatter FCS flag, will scatter
the FCS into the receive buffers.

Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 3 ++-
 include/rdma/ib_verbs.h              | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 9acb849..03e39c2 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1833,7 +1833,8 @@ static int create_qp(struct ib_uverbs_file *file,
 	if (attr.create_flags & ~(IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK |
 				IB_QP_CREATE_CROSS_CHANNEL |
 				IB_QP_CREATE_MANAGED_SEND |
-				IB_QP_CREATE_MANAGED_RECV)) {
+				IB_QP_CREATE_MANAGED_RECV |
+				IB_QP_CREATE_SCATTER_FCS)) {
 		ret = -EINVAL;
 		goto err_put;
 	}
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 6d6172d..195b233 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -982,6 +982,7 @@ enum ib_qp_create_flags {
 	IB_QP_CREATE_NETIF_QP			= 1 << 5,
 	IB_QP_CREATE_SIGNATURE_EN		= 1 << 6,
 	IB_QP_CREATE_USE_GFP_NOIO		= 1 << 7,
+	IB_QP_CREATE_SCATTER_FCS		= 1 << 8,
 	/* reserve bits 26-31 for low level drivers' internal use */
 	IB_QP_CREATE_RESERVED_START		= 1 << 26,
 	IB_QP_CREATE_RESERVED_END		= 1 << 31,
-- 
2.5.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
