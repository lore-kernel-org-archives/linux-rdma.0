From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx4 3/4] add link layer field to mlx4 QPs
Date: Sun, 11 Dec 2011 16:44:13 +0200
Message-ID: <alpine.LRH.2.00.1112111643510.3850@ogerlitz.voltaire.com>
References: <alpine.LRH.2.00.1112111638020.32736@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1112111638020.32736-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The link layer field is to be used in few flows
among them fast path operations such as CQ polling.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/mlx4.h  |    2 ++
 src/verbs.c |    8 ++++++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/src/mlx4.h b/src/mlx4.h
index 0ad838d..f92611f 100644
--- a/src/mlx4.h
+++ b/src/mlx4.h
@@ -223,6 +223,8 @@ struct mlx4_qp {

 	uint32_t		       *db;
 	struct mlx4_wq			rq;
+
+	uint8_t			link_layer;
 };

 struct mlx4_av {
diff --git a/src/verbs.c b/src/verbs.c
index 199d107..3c8dbaf 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -522,6 +522,14 @@ int mlx4_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 {
 	struct ibv_modify_qp cmd;
 	int ret;
+	struct ibv_port_attr port_attr;
+	struct mlx4_qp *mqp = to_mqp(qp);
+
+	if (attr_mask & IBV_QP_PORT) {
+		if (ibv_query_port(qp->pd->context, attr->port_num, &port_attr))
+			return -1;
+		mqp->link_layer = port_attr.link_layer;
+	}

 	if (qp->state == IBV_QPS_RESET &&
 	    attr_mask & IBV_QP_STATE   &&
-- 
1.7.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
