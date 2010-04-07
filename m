From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 14/37] librdmacm: make CQs optional for rdma_create_qp
Date: Wed, 7 Apr 2010 10:12:44 -0700
Message-ID: <7F0BFAF4F69245DEAF7456EF7B660754@amr.corp.intel.com>
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

Allow the user to specify NULL for the send and receive CQs when
creating a QP through rdma_create_qp.  The librdmacm will automatically
create CQs for the user, along with completion channel.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 include/rdma/rdma_cma.h |    4 +++
 src/cma.c               |   74 ++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 74 insertions(+), 4 deletions(-)

diff --git a/include/rdma/rdma_cma.h b/include/rdma/rdma_cma.h
index ccf6cd4..d8cbb91 100644
--- a/include/rdma/rdma_cma.h
+++ b/include/rdma/rdma_cma.h
@@ -115,6 +115,10 @@ struct rdma_cm_id {
 	enum rdma_port_space	 ps;
 	uint8_t			 port_num;
 	struct rdma_cm_event	*event;
+	struct ibv_comp_channel *send_cq_channel;
+	struct ibv_cq		*send_cq;
+	struct ibv_comp_channel *recv_cq_channel;
+	struct ibv_cq		*recv_cq;
 };
 
 struct rdma_conn_param {
diff --git a/src/cma.c b/src/cma.c
index 0587ab3..805aca3 100644
--- a/src/cma.c
+++ b/src/cma.c
@@ -1025,6 +1025,63 @@ static int ucma_init_ud_qp(struct cma_id_private *id_priv, struct ibv_qp *qp)
 	return ibv_modify_qp(qp, &qp_attr, IBV_QP_STATE | IBV_QP_SQ_PSN);
 }
 
+static void ucma_destroy_cqs(struct rdma_cm_id *id)
+{
+	if (id->recv_cq)
+		ibv_destroy_cq(id->recv_cq);
+
+	if (id->recv_cq_channel)
+		ibv_destroy_comp_channel(id->recv_cq_channel);
+
+	if (id->send_cq)
+		ibv_destroy_cq(id->send_cq);
+
+	if (id->send_cq_channel)
+		ibv_destroy_comp_channel(id->send_cq_channel);
+}
+
+static int ucma_create_cqs(struct rdma_cm_id *id, struct ibv_qp_init_attr *attr)
+{
+	int ret;
+
+	if (!attr->recv_cq) {
+		id->recv_cq_channel = ibv_create_comp_channel(id->verbs);
+		if (!id->recv_cq_channel) {
+			ret = ERR(ENOMEM);
+			goto err;
+		}
+
+		id->recv_cq = ibv_create_cq(id->verbs, attr->cap.max_recv_wr,
+					    id, id->recv_cq_channel, 0);
+		if (!id->recv_cq) {
+			ret = ERR(ENOMEM);
+			goto err;
+		}
+		attr->recv_cq = id->recv_cq;
+	}
+
+	if (!attr->send_cq) {
+		id->send_cq_channel = ibv_create_comp_channel(id->verbs);
+		if (!id->send_cq_channel) {
+			ret = ERR(ENOMEM);
+			goto err;
+		}
+
+		id->send_cq = ibv_create_cq(id->verbs, attr->cap.max_send_wr,
+					    id, id->send_cq_channel, 0);
+		if (!id->send_cq) {
+			ret = ERR(ENOMEM);
+			goto err;
+		}
+		attr->send_cq = id->send_cq;
+	}
+
+	return 0;
+err:
+	ucma_destroy_cqs(id);
+	return ret;
+}
+
 int rdma_create_qp(struct rdma_cm_id *id, struct ibv_pd *pd,
 		   struct ibv_qp_init_attr *qp_init_attr)
 {
@@ -1038,27 +1095,36 @@ int rdma_create_qp(struct rdma_cm_id *id, struct ibv_pd *pd,
 	else if (id->verbs != pd->context)
 		return ERR(EINVAL);
 
+	ret = ucma_create_cqs(id, qp_init_attr);
+	if (ret)
+		return ret;
+
 	qp = ibv_create_qp(pd, qp_init_attr);
-	if (!qp)
-		return ERR(ENOMEM);
+	if (!qp) {
+		ret = ERR(ENOMEM);
+		goto err1;
+	}
 
 	if (ucma_is_ud_ps(id->ps))
 		ret = ucma_init_ud_qp(id_priv, qp);
 	else
 		ret = ucma_init_conn_qp(id_priv, qp);
 	if (ret)
-		goto err;
+		goto err2;
 
 	id->qp = qp;
 	return 0;
-err:
+err2:
 	ibv_destroy_qp(qp);
+err1:
+	ucma_destroy_cqs(id);
 	return ret;
 }
 
 void rdma_destroy_qp(struct rdma_cm_id *id)
 {
 	ibv_destroy_qp(id->qp);
+	ucma_destroy_cqs(id);
 }
 
 static int ucma_valid_param(struct cma_id_private *id_priv,



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
