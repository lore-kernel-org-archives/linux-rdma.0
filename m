From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 1/3] IB/core: Avoid accessing non-allocated memory when inferring port type
Date: Wed, 23 Aug 2017 08:35:40 +0300
Message-ID: <20170823053542.17754-2-leon@kernel.org>
References: <20170823053542.17754-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170823053542.17754-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Commit 44c58487d51a ("IB/core: Define 'ib' and 'roce' rdma_ah_attr types")
introduced the concept of type in ah_attr:
 * During ib_register_device, each port is checked for its type which
   is stored in ib_device's port_immutable array.
 * During uverbs' modify_qp, the type is inferred using the port number
   in ib_uverbs_qp_dest struct (address vector) by accessing the
   relevant port_immutable array and the type is passed on to
   providers.

IB spec (version 1.3) enforces a valid port value only in Reset to
Init. During Init to RTR, the address vector must be valid but port
number is not mentioned as a field in the address vector, so its
value is not validated, which leads to accesses to a non-allocated
memory when inferring the port type.

Save the real port number in ib_qp during modify to Init (when the
comp_mask indicates that the port number is valid) and use this value
to infer the port type.

Avoid copying the address vector fields if the matching bit is not set
in the attr_mask. Address vector can't be modified before the port, so
no valid flow is affected.

Fixes: 44c58487d51a ('IB/core: Define 'ib' and 'roce' rdma_ah_attr types')
Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 11 +++++++----
 drivers/infiniband/core/verbs.c      |  7 ++++++-
 include/rdma/ib_verbs.h              |  1 +
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index c551d2b275fd..15833fc6b769 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1522,6 +1522,7 @@ static int create_qp(struct ib_uverbs_file *file,
 		qp->qp_type	  = attr.qp_type;
 		atomic_set(&qp->usecnt, 0);
 		atomic_inc(&pd->usecnt);
+		qp->port = 0;
 		if (attr.send_cq)
 			atomic_inc(&attr.send_cq->usecnt);
 		if (attr.recv_cq)
@@ -1962,8 +1963,9 @@ static int modify_qp(struct ib_uverbs_file *file,
 	attr->alt_timeout	  = cmd->base.alt_timeout;
 	attr->rate_limit	  = cmd->rate_limit;

-	attr->ah_attr.type = rdma_ah_find_type(qp->device,
-					       cmd->base.dest.port_num);
+	if (cmd->base.attr_mask & IB_QP_AV)
+		attr->ah_attr.type = rdma_ah_find_type(qp->device,
+						       cmd->base.dest.port_num);
 	if (cmd->base.dest.is_global) {
 		rdma_ah_set_grh(&attr->ah_attr, NULL,
 				cmd->base.dest.flow_label,
@@ -1981,8 +1983,9 @@ static int modify_qp(struct ib_uverbs_file *file,
 	rdma_ah_set_port_num(&attr->ah_attr,
 			     cmd->base.dest.port_num);

-	attr->alt_ah_attr.type = rdma_ah_find_type(qp->device,
-						   cmd->base.dest.port_num);
+	if (cmd->base.attr_mask & IB_QP_ALT_PATH)
+		attr->alt_ah_attr.type =
+			rdma_ah_find_type(qp->device, cmd->base.dest.port_num);
 	if (cmd->base.alt_dest.is_global) {
 		rdma_ah_set_grh(&attr->alt_ah_attr, NULL,
 				cmd->base.alt_dest.flow_label,
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 7f8fe443df46..b456e3ca1876 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -838,6 +838,7 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 	spin_lock_init(&qp->mr_lock);
 	INIT_LIST_HEAD(&qp->rdma_mrs);
 	INIT_LIST_HEAD(&qp->sig_mrs);
+	qp->port = 0;

 	if (qp_init_attr->qp_type == IB_QPT_XRC_TGT)
 		return ib_create_xrc_qp(qp, qp_init_attr);
@@ -1297,7 +1298,11 @@ int ib_modify_qp_with_udata(struct ib_qp *qp, struct ib_qp_attr *attr,
 		if (ret)
 			return ret;
 	}
-	return ib_security_modify_qp(qp, attr, attr_mask, udata);
+	ret = ib_security_modify_qp(qp, attr, attr_mask, udata);
+	if (!ret && (attr_mask & IB_QP_PORT))
+		qp->port = attr->port_num;
+
+	return ret;
 }
 EXPORT_SYMBOL(ib_modify_qp_with_udata);

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index b5732432bb29..88c32aba32f7 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1683,6 +1683,7 @@ struct ib_qp {
 	enum ib_qp_type		qp_type;
 	struct ib_rwq_ind_table *rwq_ind_tbl;
 	struct ib_qp_security  *qp_sec;
+	u8			port;
 };

 struct ib_mr {
--
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
