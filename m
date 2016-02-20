From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: [PATCH rdma-next 5/8] IB/{core,ulp} Support above 32 possible device capability flags
Date: Sat, 20 Feb 2016 09:47:42 +0200
Message-ID: <1455954465-15141-6-git-send-email-leon@leon.nu>
References: <1455954465-15141-1-git-send-email-leon@leon.nu>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455954465-15141-1-git-send-email-leon-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The old bitwise device_cap_flags variable was limited to u32 which
has all bits already defined. In order to overcome it, we converted
device_cap_flags variable to be u64 type.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c      | 2 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 2 +-
 include/rdma/ib_verbs.h                   | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index c647d67..6887252 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -402,7 +402,7 @@ static void copy_query_dev_fields(struct ib_uverbs_file *file,
 	resp->hw_ver		= attr->hw_ver;
 	resp->max_qp		= attr->max_qp;
 	resp->max_qp_wr		= attr->max_qp_wr;
-	resp->device_cap_flags	= attr->device_cap_flags;
+	resp->device_cap_flags	= lower_32_bits(attr->device_cap_flags);
 	resp->max_sge		= attr->max_sge;
 	resp->max_sge_rd	= attr->max_sge_rd;
 	resp->max_cq		= attr->max_cq;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 25509bb..6d53330 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1762,7 +1762,7 @@ int ipoib_add_pkey_attr(struct net_device *dev)
 
 int ipoib_set_dev_features(struct ipoib_dev_priv *priv, struct ib_device *hca)
 {
-	priv->hca_caps = hca->attrs.device_cap_flags;
+	priv->hca_caps = (int)hca->attrs.device_cap_flags;
 
 	if (priv->hca_caps & IB_DEVICE_UD_IP_CSUM) {
 		priv->dev->hw_features = NETIF_F_SG |
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 284b00c..2ff1fd1 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -273,7 +273,7 @@ struct ib_device_attr {
 	u32			hw_ver;
 	int			max_qp;
 	int			max_qp_wr;
-	int			device_cap_flags;
+	u64			device_cap_flags;
 	int			max_sge;
 	int			max_sge_rd;
 	int			max_cq;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
