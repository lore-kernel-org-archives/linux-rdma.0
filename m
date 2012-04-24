From: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] libibverbs-xrc: Rename the attribute private -> private_data
Date: Tue, 24 Apr 2012 09:13:59 +0300
Message-ID: <201204240913.59380.dotanb@sw.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Since "private" is a reserved word in C++, it shouldn't be used as a name of a
structure attribute.

Signed-off-by: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Reviewed-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 include/infiniband/ofverbs.h |    2 +-
 include/infiniband/verbs.h   |    4 ++--
 src/ofverbs.c                |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/infiniband/ofverbs.h b/include/infiniband/ofverbs.h
index b03d7ae..841e689 100644
--- a/include/infiniband/ofverbs.h
+++ b/include/infiniband/ofverbs.h
@@ -102,7 +102,7 @@ struct ofv_async_event {
 		uint32_t	xrc_qp_num;
 	} element;
 	enum ibv_event_type	event_type;
-	void                   *private;
+	void                   *private_data;
 };
 
 int ofv_get_async_event(struct ibv_context *context,
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 1dcd17f..ddc8722 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -706,7 +706,7 @@ struct ibv_device {
 	char			ibdev_path[IBV_SYSFS_PATH_MAX];
 
 	/* Following fields only available if device supports extensions */
-	void		       *private;
+	void		       *private_data;
 	int			(*have_ext_ops)(struct ibv_device *device,
 						const char *ext_name);
 	void *			(*get_device_ext_ops)(struct ibv_device *device,
@@ -791,7 +791,7 @@ struct ibv_context {
 	void		       *abi_compat;
 
 	/* Following fields only available if device supports extensions */
-	void		       *private;
+	void		       *private_data;
 	void *			(*get_ext_ops)(struct ibv_context *context,
 					       const char *ext_name);
 };
diff --git a/src/ofverbs.c b/src/ofverbs.c
index 0486552..2ee5e81 100644
--- a/src/ofverbs.c
+++ b/src/ofverbs.c
@@ -61,7 +61,7 @@ int __ofv_get_async_event(struct ibv_context *context,
 		case IBV_EVENT_PATH_MIG_ERR:
 		case IBV_EVENT_QP_LAST_WQE_REACHED:
 			if (event->element.qp->qp_type == IBV_QPT_XRC_RECV) {
-				event->private = event->element.qp;
+				event->private_data = event->element.qp;
 				event->event_type |= OFV_XRC_QP_EVENT_FLAG;
 				event->element.xrc_qp_num = event->element.qp->qp_num;
 			}
@@ -76,7 +76,7 @@ default_symver(__ofv_get_async_event, ofv_get_async_event);
 void ofv_ack_async_event(struct ofv_async_event *event)
 {
 	if (event->event_type & OFV_XRC_QP_EVENT_FLAG) {
-		event->element.qp = event->private;
+		event->element.qp = event->private_data;
 		event->event_type &= ~OFV_XRC_QP_EVENT_FLAG;
 	}
 	ibv_ack_async_event((struct ibv_async_event *) event);
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
