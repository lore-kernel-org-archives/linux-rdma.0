From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH RFC 1/2] RDMA/CM: move rdma_id_private into
 include/rdma/rdma_cm.h
Date: Tue, 30 Jan 2018 08:59:04 -0800
Message-ID: <a85bb48eb9fc8846c81118a6777ab9ccbd27e9d7.1517418595.git.swise@opengridcomputing.com>
References: <cover.1517418595.git.swise@opengridcomputing.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1517418595.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

So the resource tracking services in core/nldev.c can see useful
information about cm_ids.

There are other approaches.  I just moved rdma_id_private to develop
this prototype quickly, and it was simple.  Other approaches include:

1) move the nldev cm_id dumpit functions into cma.c, and have nldev.c
call it.  This, however puts a ib_core->rdma_cm module dependency which
makes the two modules interdependent in both directions.  Thus, rdma_cm
would have to be merged into ib_core.  This might not be a bad idea with
all the kernel rdma ULPs now using the rdma_cm.

2) move the specific attributes that are being dumped from the
rdma_id_private struct to the rdma_cm_id struct, so nldev.c has access
to them.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 40 ----------------------------------------
 include/rdma/rdma_cm.h        | 41 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+), 40 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index e66963c..72ad52b 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -327,46 +327,6 @@ struct ib_device *cma_get_ib_dev(struct cma_device *cma_dev)
  * We do this by disabling removal notification while a callback is in process,
  * and reporting it after the callback completes.
  */
-struct rdma_id_private {
-	struct rdma_cm_id	id;
-
-	struct rdma_bind_list	*bind_list;
-	struct hlist_node	node;
-	struct list_head	list; /* listen_any_list or cma_device.list */
-	struct list_head	listen_list; /* per device listens */
-	struct cma_device	*cma_dev;
-	struct list_head	mc_list;
-
-	int			internal_id;
-	enum rdma_cm_state	state;
-	spinlock_t		lock;
-	struct mutex		qp_mutex;
-
-	struct completion	comp;
-	atomic_t		refcount;
-	struct mutex		handler_mutex;
-
-	int			backlog;
-	int			timeout_ms;
-	struct ib_sa_query	*query;
-	int			query_id;
-	union {
-		struct ib_cm_id	*ib;
-		struct iw_cm_id	*iw;
-	} cm_id;
-
-	u32			seq_num;
-	u32			qkey;
-	u32			qp_num;
-	pid_t			owner;
-	u32			options;
-	u8			srq;
-	u8			tos;
-	bool			tos_set;
-	u8			reuseaddr;
-	u8			afonly;
-	enum ib_gid_type	gid_type;
-};
 
 struct cma_multicast {
 	struct rdma_id_private *id_priv;
diff --git a/include/rdma/rdma_cm.h b/include/rdma/rdma_cm.h
index 6538a5c..5984225 100644
--- a/include/rdma/rdma_cm.h
+++ b/include/rdma/rdma_cm.h
@@ -157,6 +157,47 @@ struct rdma_cm_id {
 	u8			 port_num;
 };
 
+struct rdma_id_private {
+	struct rdma_cm_id	id;
+
+	struct rdma_bind_list	*bind_list;
+	struct hlist_node	node;
+	struct list_head	list; /* listen_any_list or cma_device.list */
+	struct list_head	listen_list; /* per device listens */
+	struct cma_device	*cma_dev;
+	struct list_head	mc_list;
+
+	int			internal_id;
+	enum rdma_cm_state	state;
+	spinlock_t		lock;
+	struct mutex		qp_mutex;
+
+	struct completion	comp;
+	atomic_t		refcount;
+	struct mutex		handler_mutex;
+
+	int			backlog;
+	int			timeout_ms;
+	struct ib_sa_query	*query;
+	int			query_id;
+	union {
+		struct ib_cm_id	*ib;
+		struct iw_cm_id	*iw;
+	} cm_id;
+
+	u32			seq_num;
+	u32			qkey;
+	u32			qp_num;
+	pid_t			owner;
+	u32			options;
+	u8			srq;
+	u8			tos;
+	bool			tos_set;
+	u8			reuseaddr;
+	u8			afonly;
+	enum ib_gid_type	gid_type;
+};
+
 /**
  * rdma_create_id - Create an RDMA identifier.
  *
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
