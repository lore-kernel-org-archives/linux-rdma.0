From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: [PATCH rdma-next V1 5/8] IB/{core,ulp} Support above 32 possible device capability flags
Date: Tue, 23 Feb 2016 10:25:25 +0200
Message-ID: <1456215928-9305-6-git-send-email-leon@leon.nu>
References: <1456215928-9305-1-git-send-email-leon@leon.nu>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456215928-9305-1-git-send-email-leon-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The old bitwise device_cap_flags variable was limited to u32 which
has all bits already defined. In order to overcome it, we converted
device_cap_flags variable to be u64 type.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 2 +-
 drivers/infiniband/ulp/ipoib/ipoib.h | 2 +-
 include/rdma/ib_verbs.h              | 2 +-
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
diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index a6f3eab..4dd05f0 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -387,7 +387,7 @@ struct ipoib_dev_priv {
 	struct dentry *mcg_dentry;
 	struct dentry *path_dentry;
 #endif
-	int	hca_caps;
+	u64	hca_caps;
 	struct ipoib_ethtool_st ethtool;
 	struct timer_list poll_timer;
 };
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
