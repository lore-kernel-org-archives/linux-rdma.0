From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 1/4] ibverbs: Make struct verbs_device and related private
Date: Tue, 28 Feb 2017 14:31:34 -0700
Message-ID: <1488317497-538-2-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1488317497-538-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1488317497-538-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Nothing can be using this publicly, no sense in publishing it.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libibverbs/driver.h | 19 +++++++++++++++++++
 libibverbs/verbs.h  | 18 ------------------
 2 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/libibverbs/driver.h b/libibverbs/driver.h
index 5d29b14036635b..96f4903d19670a 100644
--- a/libibverbs/driver.h
+++ b/libibverbs/driver.h
@@ -96,6 +96,25 @@ struct verbs_qp {
 	uint32_t		comp_mask;
 	struct verbs_xrcd       *xrcd;
 };
+
+/* Must change the PRIVATE IBVERBS_PRIVATE_ symbol if this is changed */
+struct verbs_device {
+	struct ibv_device device; /* Must be first */
+	size_t	sz;
+	size_t	size_of_context;
+	int	(*init_context)(struct verbs_device *device,
+				struct ibv_context *ctx, int cmd_fd);
+	void	(*uninit_context)(struct verbs_device *device,
+				struct ibv_context *ctx);
+};
+
+static inline struct verbs_device *verbs_get_device(
+					const struct ibv_device *dev)
+{
+	return (dev->ops.alloc_context) ?
+		NULL : container_of(dev, struct verbs_device, device);
+}
+
 typedef struct ibv_device *(*ibv_driver_init_func)(const char *uverbs_sys_path,
 						   int abi_version);
 typedef struct verbs_device *(*verbs_driver_init_func)(const char *uverbs_sys_path,
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 7b8377bbd7bf62..a6c541b8020685 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -1328,17 +1328,6 @@ struct ibv_device {
 	char			ibdev_path[IBV_SYSFS_PATH_MAX];
 };
 
-struct verbs_device {
-	struct ibv_device device; /* Must be first */
-	size_t	sz;
-	size_t	size_of_context;
-	int	(*init_context)(struct verbs_device *device,
-				struct ibv_context *ctx, int cmd_fd);
-	void	(*uninit_context)(struct verbs_device *device,
-				struct ibv_context *ctx);
-	/* future fields added here */
-};
-
 struct ibv_context_ops {
 	int			(*query_device)(struct ibv_context *context,
 					      struct ibv_device_attr *device_attr);
@@ -1515,13 +1504,6 @@ static inline struct verbs_context *verbs_get_ctx(struct ibv_context *ctx)
 	if (vctx && (vctx->sz >= sizeof(*vctx) - offsetof(struct verbs_context, op))) \
 		vctx->op = ptr; })
 
-static inline struct verbs_device *verbs_get_device(
-					const struct ibv_device *dev)
-{
-	return (dev->ops.alloc_context) ?
-		NULL : container_of(dev, struct verbs_device, device);
-}
-
 /**
  * ibv_get_device_list - Get list of IB devices currently available
  * @num_devices: optional.  if non-NULL, set to the number of devices
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
