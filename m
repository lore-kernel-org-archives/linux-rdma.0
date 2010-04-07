From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 19/37] librdmacm: add rdma_get_request
Date: Wed, 7 Apr 2010 10:12:44 -0700
Message-ID: <F269798811654E3583CB3286EAE7A6B4@amr.corp.intel.com>
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

To simplify passive side operation and better support synchronous
operations, add rdma_get_request().  This function is called on the
listening side to retrieve a connection request event.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Ideally, this call would have been rdma_accept, to match with the socket
accept call, but it was already taken.

 include/rdma/rdma_cma.h |    5 +++++
 src/cma.c               |   38 ++++++++++++++++++++++++++++++++++++++
 src/librdmacm.map       |    1 +
 3 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/include/rdma/rdma_cma.h b/include/rdma/rdma_cma.h
index 1db559e..89013a0 100644
--- a/include/rdma/rdma_cma.h
+++ b/include/rdma/rdma_cma.h
@@ -381,6 +381,11 @@ int rdma_connect(struct rdma_cm_id *id, struct rdma_conn_param *conn_param);
 int rdma_listen(struct rdma_cm_id *id, int backlog);
 
 /**
+ * rdma_get_request
+ */
+int rdma_get_request(struct rdma_cm_id *listen, struct rdma_cm_id **id);
+
+/**
  * rdma_accept - Called to accept a connection request.
  * @id: Connection identifier associated with the request.
  * @conn_param: Optional information needed to establish the connection.
diff --git a/src/cma.c b/src/cma.c
index 8aa7b05..9de33d4 100644
--- a/src/cma.c
+++ b/src/cma.c
@@ -1242,6 +1242,44 @@ int rdma_listen(struct rdma_cm_id *id, int backlog)
 		return ucma_query_route(id);
 }
 
+int rdma_get_request(struct rdma_cm_id *listen, struct rdma_cm_id **id)
+{
+	struct cma_id_private *id_priv;
+	struct rdma_cm_event *event;
+	int ret;
+
+	id_priv = container_of(listen, struct cma_id_private, id);
+	if (!id_priv->sync)
+		return ERR(EINVAL);
+
+	if (listen->event) {
+		rdma_ack_cm_event(listen->event);
+		listen->event = NULL;
+	}
+
+	ret = rdma_get_cm_event(listen->channel, &event);
+	if (ret)
+		return ret;
+
+	if (event->status) {
+		ret = event->status;
+		goto err;
+	}
+	
+	if (event->event != RDMA_CM_EVENT_CONNECT_REQUEST) {
+		ret = ERR(EINVAL);
+		goto err;
+	}
+
+	*id = event->id;
+	(*id)->event = event;
+	return 0;
+
+err:
+	listen->event = event;
+	return ret;
+}
+
 int rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 {
 	struct ucma_abi_accept *cmd;
diff --git a/src/librdmacm.map b/src/librdmacm.map
index 1f07102..f6af452 100644
--- a/src/librdmacm.map
+++ b/src/librdmacm.map
@@ -30,5 +30,6 @@ RDMACM_1.0 {
 		rdma_migrate_id;
 		rdma_getaddrinfo;
 		rdma_freeaddrinfo;
+		rdma_get_request;
 	local: *;
 };



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
