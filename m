From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 22/37] librdmacm: add new call to create id
Date: Wed, 7 Apr 2010 10:12:44 -0700
Message-ID: <F818D641D3E64DA197E789362F5F0222@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
References: 
In-Reply-To: 
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Provide a simple call to create an rdma_id, with optional QP.  The
id is created using synchronous operation, using the output of
rdma_getaddrinfo.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 include/rdma/rdma_cma.h |   26 ++++++++++++++++++++++++++
 src/cma.c               |   43 +++++++++++++++++++++++++++++++++++++++++++
 src/librdmacm.map       |    1 +
 3 files changed, 70 insertions(+), 0 deletions(-)

diff --git a/include/rdma/rdma_cma.h b/include/rdma/rdma_cma.h
index 391c35c..74762a2 100644
--- a/include/rdma/rdma_cma.h
+++ b/include/rdma/rdma_cma.h
@@ -232,6 +232,32 @@ int rdma_create_id(struct rdma_event_channel *channel,
 		   enum rdma_port_space ps);
 
 /**
+ * rdma_create_ep - Allocate a communication identifier and qp.
+ * @id: A reference where the allocated communication identifier will be
+ *   returned.
+ * @res: Result from rdma_getaddrinfo, which specifies the source and
+ *   destination addresses, plus optional routing and connection information.
+ * @pd: Optional protection domain.  This parameter is ignored if qp_init_attr
+ *   is NULL.
+ * @qp_init_attr: Optional attributes for a QP created on the rdma_cm_id.
+ * Description:
+ *   Create an identifier and option QP used for communication.
+ * Notes:
+ *   If qp_init_attr is provided, then a queue pair will be allocated and
+ *   associated with the rdma_cm_id.  If a pd is provided, the QP will be
+ *   created on that PD.  Otherwise, the QP will be allocated on a default
+ *   PD.
+ *   The rdma_cm_id will be set to use synchronous operations (connect,
+ *   listen, and get_request).  To convert to synchronous operation, the
+ *   rdma_cm_id should be migrated to a user allocated event channel.
+ * See also:
+ *   rdma_create_id, rdma_create_qp, rdma_migrate_id, rdma_connect,
+ *   rdma_listen
+ */
+int rdma_create_ep(struct rdma_cm_id **id, struct rdma_addrinfo *res,
+		   struct ibv_pd *pd, struct ibv_qp_init_attr *qp_init_attr);
+
+/**
  * rdma_destroy_id - Release a communication identifier.
  * @id: The communication identifier to destroy.
  * Description:
diff --git a/src/cma.c b/src/cma.c
index e31fb8a..b911b3f 100644
--- a/src/cma.c
+++ b/src/cma.c
@@ -49,6 +49,7 @@
 #include <endian.h>
 #include <byteswap.h>
 #include <stddef.h>
+#include <netdb.h>
 
 #include "cma.h"
 #include <infiniband/driver.h>
@@ -1990,3 +1991,45 @@ int rdma_migrate_id(struct rdma_cm_id *id, struct rdma_event_channel *channel)
 
 	return 0;
 }
+
+int rdma_create_ep(struct rdma_cm_id **id, struct rdma_addrinfo *res,
+		   struct ibv_pd *pd, struct ibv_qp_init_attr *qp_init_attr)
+{
+	struct rdma_cm_id *cm_id;
+	int ret;
+
+	ret = rdma_create_id2(NULL, &cm_id, NULL, res->ai_port_space, res->ai_qp_type);
+	if (ret)
+		return ret;
+
+	if (af_ib_support)
+		ret = rdma_resolve_addr2(cm_id, res->ai_src_addr, res->ai_src_len,
+					 res->ai_dst_addr, res->ai_dst_len, 2000);
+	else
+		ret = rdma_resolve_addr(cm_id, res->ai_src_addr, res->ai_dst_addr, 2000);
+	if (ret)
+		goto err;
+
+	if (res->ai_route_len) {
+		ret = rdma_set_option(cm_id, RDMA_OPTION_IB, RDMA_OPTION_IB_PATH,
+				      res->ai_route, res->ai_route_len);
+		if (!ret)
+			ret = ucma_complete(container_of(cm_id, struct cma_id_private, id));
+	} else {
+		ret = rdma_resolve_route(cm_id, 2000);
+	}
+	if (ret)
+		goto err;
+
+	qp_init_attr->qp_type = res->ai_qp_type;
+	ret = rdma_create_qp(cm_id, pd, qp_init_attr);
+	if (ret)
+		goto err;
+
+	*id = cm_id;
+	return 0;
+
+err:
+	rdma_destroy_id(cm_id);
+	return ret;
+}
diff --git a/src/librdmacm.map b/src/librdmacm.map
index f6af452..85d5b3c 100644
--- a/src/librdmacm.map
+++ b/src/librdmacm.map
@@ -31,5 +31,6 @@ RDMACM_1.0 {
 		rdma_getaddrinfo;
 		rdma_freeaddrinfo;
 		rdma_get_request;
+		rdma_create_ep;
 	local: *;
 };



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
