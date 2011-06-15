From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/8] librdmacm: Fix crash in rdma_connect
Date: Wed, 15 Jun 2011 17:42:01 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823730212EF@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When using rdma_connect for UD QP lookup, there may not be any
QP associated with the rdma_cm_id.  Plus there may not be any use
for the conn_param parameter.  Allow conn_param to be optional
in this situation.  This fixes a crash exposed by rdma_xclient
sample using XRC QPs.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/cma.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/src/cma.c b/src/cma.c
index e5ea7db..e068125 100755
--- a/src/cma.c
+++ b/src/cma.c
@@ -1353,14 +1353,18 @@ int rdma_connect(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 
 	CMA_CREATE_MSG_CMD(msg, cmd, UCMA_CMD_CONNECT, size);
 	cmd->id = id_priv->handle;
-	if (id->qp)
+	if (id->qp) {
 		ucma_copy_conn_param_to_kern(id_priv, &cmd->conn_param,
 					     conn_param, id->qp->qp_num,
 					     (id->qp->srq != NULL));
-	else
+	} else if (conn_param) {
 		ucma_copy_conn_param_to_kern(id_priv, &cmd->conn_param,
 					     conn_param, conn_param->qp_num,
 					     conn_param->srq);
+	} else {
+		ucma_copy_conn_param_to_kern(id_priv, &cmd->conn_param,
+					     conn_param, 0, 0);
+	}
 
 	ret = write(id->channel->fd, msg, size);
 	if (ret != size)


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
