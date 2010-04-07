From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 21/37] librdmacm: specify qp_type when creating id
Date: Wed, 7 Apr 2010 10:12:44 -0700
Message-ID: <494B286C092841BEB7EACAB31F26F613@amr.corp.intel.com>
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

To support AF_IB / PS_IB, we need to specify the qp type when
creating the rdma_cm_id.  The kernel requires this in order
to select the correct type of operation to perform (e.g. SIDR
versus REQ).

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 include/rdma/rdma_cma_abi.h |    3 ++-
 src/cma.c                   |   18 +++++++++++++++---
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/include/rdma/rdma_cma_abi.h b/include/rdma/rdma_cma_abi.h
index c3981e6..bd4ca0f 100644
--- a/include/rdma/rdma_cma_abi.h
+++ b/include/rdma/rdma_cma_abi.h
@@ -82,7 +82,8 @@ struct ucma_abi_create_id {
 	__u64 uid;
 	__u64 response;
 	__u16 ps;
-	__u8  reserved[6];
+	__u8  qp_type;
+	__u8  reserved[5];
 };
 
 struct ucma_abi_create_id_resp {
diff --git a/src/cma.c b/src/cma.c
index 9de33d4..e31fb8a 100644
--- a/src/cma.c
+++ b/src/cma.c
@@ -390,9 +390,9 @@ err:	ucma_free_id(id_priv);
 	return NULL;
 }
 
-int rdma_create_id(struct rdma_event_channel *channel,
-		   struct rdma_cm_id **id, void *context,
-		   enum rdma_port_space ps)
+static int rdma_create_id2(struct rdma_event_channel *channel,
+			   struct rdma_cm_id **id, void *context,
+			   enum rdma_port_space ps, enum ibv_qp_type qp_type)
 {
 	struct ucma_abi_create_id_resp *resp;
 	struct ucma_abi_create_id *cmd;
@@ -411,6 +411,7 @@ int rdma_create_id(struct rdma_event_channel *channel,
 	CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_CREATE_ID, size);
 	cmd->uid = (uintptr_t) id_priv;
 	cmd->ps = ps;
+	cmd->qp_type = qp_type;
 
 	ret = write(id_priv->id.channel->fd, msg, size);
 	if (ret != size)
@@ -426,6 +427,17 @@ err:	ucma_free_id(id_priv);
 	return ret;
 }
 
+int rdma_create_id(struct rdma_event_channel *channel,
+		   struct rdma_cm_id **id, void *context,
+		   enum rdma_port_space ps)
+{
+	enum ibv_qp_type qp_type;
+
+	qp_type = (ps == RDMA_PS_IPOIB || ps == RDMA_PS_UDP) ?
+		  IBV_QPT_UD : IBV_QPT_RC;
+	return rdma_create_id2(channel, id, context, ps, qp_type);
+}
+
 static int ucma_destroy_kern_id(int fd, uint32_t handle)
 {
 	struct ucma_abi_destroy_id_resp *resp;



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
