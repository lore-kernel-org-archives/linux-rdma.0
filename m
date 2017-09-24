From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 1/7] IB/core: Fix typo in the name of the tag-matching cap struct
Date: Sun, 24 Sep 2017 21:46:29 +0300
Message-ID: <20170924184635.31948-2-leon@kernel.org>
References: <20170924184635.31948-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170924184635.31948-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The tag matching functionality is implemented by mlx5 driver
by extending XRQ, however this internal kernel information was
exposed to user space applications with *xrq* name instead of *tm*.

This patch renames *xrq* to *tm* to handle that.

Fixes: 8d50505ada72 ("IB/uverbs: Expose XRQ capabilities")
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 14 +++++++-------
 drivers/infiniband/hw/mlx5/main.c    | 10 +++++-----
 include/rdma/ib_verbs.h              |  4 ++--
 include/uapi/rdma/ib_user_verbs.h    |  2 +-
 4 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 4ab30d832ac5..52a2cf2d83aa 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3869,15 +3869,15 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
 	resp.raw_packet_caps = attr.raw_packet_caps;
 	resp.response_length += sizeof(resp.raw_packet_caps);
 
-	if (ucore->outlen < resp.response_length + sizeof(resp.xrq_caps))
+	if (ucore->outlen < resp.response_length + sizeof(resp.tm_caps))
 		goto end;
 
-	resp.xrq_caps.max_rndv_hdr_size = attr.xrq_caps.max_rndv_hdr_size;
-	resp.xrq_caps.max_num_tags      = attr.xrq_caps.max_num_tags;
-	resp.xrq_caps.max_ops		= attr.xrq_caps.max_ops;
-	resp.xrq_caps.max_sge		= attr.xrq_caps.max_sge;
-	resp.xrq_caps.flags		= attr.xrq_caps.flags;
-	resp.response_length += sizeof(resp.xrq_caps);
+	resp.tm_caps.max_rndv_hdr_size	= attr.tm_caps.max_rndv_hdr_size;
+	resp.tm_caps.max_num_tags	= attr.tm_caps.max_num_tags;
+	resp.tm_caps.max_ops		= attr.tm_caps.max_ops;
+	resp.tm_caps.max_sge		= attr.tm_caps.max_sge;
+	resp.tm_caps.flags		= attr.tm_caps.flags;
+	resp.response_length += sizeof(resp.tm_caps);
 end:
 	err = ib_copy_to_udata(ucore, &resp, resp.response_length);
 	return err;
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 05fb4bdff6a0..d6fbad8f34aa 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -778,13 +778,13 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	}
 
 	if (MLX5_CAP_GEN(mdev, tag_matching)) {
-		props->xrq_caps.max_rndv_hdr_size = MLX5_TM_MAX_RNDV_MSG_SIZE;
-		props->xrq_caps.max_num_tags =
+		props->tm_caps.max_rndv_hdr_size = MLX5_TM_MAX_RNDV_MSG_SIZE;
+		props->tm_caps.max_num_tags =
 			(1 << MLX5_CAP_GEN(mdev, log_tag_matching_list_sz)) - 1;
-		props->xrq_caps.flags = IB_TM_CAP_RC;
-		props->xrq_caps.max_ops =
+		props->tm_caps.flags = IB_TM_CAP_RC;
+		props->tm_caps.max_ops =
 			1 << MLX5_CAP_GEN(mdev, log_max_qp_sz);
-		props->xrq_caps.max_sge = MLX5_TM_MAX_SGE;
+		props->tm_caps.max_sge = MLX5_TM_MAX_SGE;
 	}
 
 	if (field_avail(typeof(resp), cqe_comp_caps, uhw->outlen)) {
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index bdb1279a415b..bbb5f54db882 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -285,7 +285,7 @@ enum ib_tm_cap_flags {
 	IB_TM_CAP_RC		    = 1 << 0,
 };
 
-struct ib_xrq_caps {
+struct ib_tm_caps {
 	/* Max size of RNDV header */
 	u32 max_rndv_hdr_size;
 	/* Max number of entries in tag matching list */
@@ -358,7 +358,7 @@ struct ib_device_attr {
 	struct ib_rss_caps	rss_caps;
 	u32			max_wq_type_rq;
 	u32			raw_packet_caps; /* Use ib_raw_packet_caps enum */
-	struct ib_xrq_caps	xrq_caps;
+	struct ib_tm_caps	tm_caps;
 };
 
 enum ib_mtu {
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 9a0b6479fe0c..d4e0b53bfc75 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -261,7 +261,7 @@ struct ib_uverbs_ex_query_device_resp {
 	struct ib_uverbs_rss_caps rss_caps;
 	__u32  max_wq_type_rq;
 	__u32 raw_packet_caps;
-	struct ib_uverbs_tm_caps xrq_caps;
+	struct ib_uverbs_tm_caps tm_caps;
 };
 
 struct ib_uverbs_query_port {
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
