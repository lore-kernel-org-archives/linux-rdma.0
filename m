From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 libibverbs 1/2] Add ibv_query_gid_type to support RoCE v2 UD traffic
Date: Thu, 15 Sep 2016 15:51:16 +0300
Message-ID: <1473943877-6049-2-git-send-email-yishaih@mellanox.com>
References: <1473943877-6049-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473943877-6049-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Currently, libibverbs does not support UD traffic for RoCE v2 since
it can't differ between v1 and v2 GIDs (both have the same GID, only
the version is different). This means that GID index can't be
selected correctly.

This patch introduces ibv_query_gid_type helper function to be used
by libibverbs and its vendors to return GID type based on its GID
index by using the relevant sysfs.

Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/infiniband/driver.h |  7 +++++
 src/libibverbs.map          |  5 ++++
 src/verbs.c                 | 65 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 77 insertions(+)

diff --git a/include/infiniband/driver.h b/include/infiniband/driver.h
index 65fa44f..d4b6f58 100644
--- a/include/infiniband/driver.h
+++ b/include/infiniband/driver.h
@@ -86,6 +86,11 @@ enum verbs_qp_mask {
 	VERBS_QP_RESERVED	= 1 << 1
 };
 
+enum ibv_gid_type {
+	IBV_GID_TYPE_IB_ROCE_V1,
+	IBV_GID_TYPE_ROCE_V2,
+};
+
 struct verbs_qp {
 	struct ibv_qp		qp;
 	uint32_t		comp_mask;
@@ -258,4 +263,6 @@ static inline int verbs_get_srq_num(struct ibv_srq *srq, uint32_t *srq_num)
 	return ENOSYS;
 }
 
+int ibv_query_gid_type(struct ibv_context *context, uint8_t port_num,
+		       unsigned int index, enum ibv_gid_type *type);
 #endif /* INFINIBAND_DRIVER_H */
diff --git a/src/libibverbs.map b/src/libibverbs.map
index 5134bd9..f0403e4 100644
--- a/src/libibverbs.map
+++ b/src/libibverbs.map
@@ -120,3 +120,8 @@ IBVERBS_1.1 {
 		ibv_cmd_rereg_mr;
 
 } IBVERBS_1.0;
+
+IBVERBS_1.3 {
+	global:
+		ibv_query_gid_type;
+} IBVERBS_1.1;
diff --git a/src/verbs.c b/src/verbs.c
index 68888c3..08f03e3 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -41,6 +41,7 @@
 #include <stdlib.h>
 #include <errno.h>
 #include <string.h>
+#include <dirent.h>
 
 #include "ibverbs.h"
 #ifndef NRESOLVE_NEIGH
@@ -585,6 +586,70 @@ struct ibv_ah *__ibv_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr)
 }
 default_symver(__ibv_create_ah, ibv_create_ah);
 
+/* GID types as appear in sysfs, no change is expected as of ABI
+ * compatibility.
+ */
+#define V1_TYPE "IB/RoCE v1"
+#define V2_TYPE "RoCE v2"
+int ibv_query_gid_type(struct ibv_context *context, uint8_t port_num,
+		       unsigned int index, enum ibv_gid_type *type)
+{
+	char name[32];
+	char buff[11];
+
+	snprintf(name, sizeof(name), "ports/%d/gid_attrs/types/%d", port_num,
+		 index);
+
+	/* Reset errno so that we can rely on its value upon any error flow in
+	 * ibv_read_sysfs_file.
+	 */
+	errno = 0;
+	if (ibv_read_sysfs_file(context->device->ibdev_path, name, buff,
+				sizeof(buff)) <= 0) {
+		char *dir_path;
+		DIR *dir;
+
+		if (errno == EINVAL) {
+			/* In IB, this file doesn't exist and the kernel sets
+			 * errno to -EINVAL.
+			 */
+			*type = IBV_GID_TYPE_IB_ROCE_V1;
+			return 0;
+		}
+		if (asprintf(&dir_path, "%s/%s/%d/%s/",
+			     context->device->ibdev_path, "ports", port_num,
+			     "gid_attrs") < 0)
+			return -1;
+		dir = opendir(dir_path);
+		free(dir_path);
+		if (!dir) {
+			if (errno == ENOENT)
+				/* Assuming that if gid_attrs doesn't exist,
+				 * we have an old kernel and all GIDs are
+				 * IB/RoCE v1
+				 */
+				*type = IBV_GID_TYPE_IB_ROCE_V1;
+			else
+				return -1;
+		} else {
+			closedir(dir);
+			errno = EFAULT;
+			return -1;
+		}
+	} else {
+		if (!strcmp(buff, V1_TYPE)) {
+			*type = IBV_GID_TYPE_IB_ROCE_V1;
+		} else if (!strcmp(buff, V2_TYPE)) {
+			*type = IBV_GID_TYPE_ROCE_V2;
+		} else {
+			errno = ENOTSUP;
+			return -1;
+		}
+	}
+
+	return 0;
+}
+
 static int ibv_find_gid_index(struct ibv_context *context, uint8_t port_num,
 			      union ibv_gid *gid)
 {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
