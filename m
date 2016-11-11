From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH] IB/usnic: simplify IS_ERR_OR_NULL to IS_ERR
Date: Fri, 11 Nov 2016 20:04:26 +0100
Message-ID: <1478891066-16093-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Benvenuti <benve@cisco.com>
Cc: kernel-janitors@vger.kernel.org, Dave Goodell <dgoodell@cisco.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Christophe JAILLET <christophe.jaillet@wanadoo.fr>
List-Id: linux-rdma@vger.kernel.org

The function usnic_ib_qp_grp_get_chunk only returns an ERR_PTR value or a
valid pointer, never NULL.  The same is true of get_qp_res_chunk, which
just returns the result of calling usnic_ib_qp_grp_get_chunk.  Simplify
IS_ERR_OR_NULL to IS_ERR in both cases.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression t,e;
@@

t = \(usnic_ib_qp_grp_get_chunk(...)\|get_qp_res_chunk(...)\)
... when != t=e
- IS_ERR_OR_NULL(t)
+ IS_ERR(t)

@@
expression t,e,e1;
@@

t = \(usnic_ib_qp_grp_get_chunk(...)\|get_qp_res_chunk(...)\)
... when != t=e
?- t ? PTR_ERR(t) : e1
+ PTR_ERR(t)
... when any
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c |   12 ++++++------
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c  |   12 ++++++------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
index 0e813ec..092d4e1 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
@@ -117,10 +117,10 @@ static int enable_qp_grp(struct usnic_ib_qp_grp *qp_grp)
 	vnic_idx = usnic_vnic_get_index(qp_grp->vf->vnic);
 
 	res_chunk = get_qp_res_chunk(qp_grp);
-	if (IS_ERR_OR_NULL(res_chunk)) {
+	if (IS_ERR(res_chunk)) {
 		usnic_err("Unable to get qp res with err %ld\n",
 				PTR_ERR(res_chunk));
-		return res_chunk ? PTR_ERR(res_chunk) : -ENOMEM;
+		return PTR_ERR(res_chunk);
 	}
 
 	for (i = 0; i < res_chunk->cnt; i++) {
@@ -158,10 +158,10 @@ static int disable_qp_grp(struct usnic_ib_qp_grp *qp_grp)
 	vnic_idx = usnic_vnic_get_index(qp_grp->vf->vnic);
 
 	res_chunk = get_qp_res_chunk(qp_grp);
-	if (IS_ERR_OR_NULL(res_chunk)) {
+	if (IS_ERR(res_chunk)) {
 		usnic_err("Unable to get qp res with err %ld\n",
 			PTR_ERR(res_chunk));
-		return res_chunk ? PTR_ERR(res_chunk) : -ENOMEM;
+		return PTR_ERR(res_chunk);
 	}
 
 	for (i = 0; i < res_chunk->cnt; i++) {
@@ -186,11 +186,11 @@ static int init_filter_action(struct usnic_ib_qp_grp *qp_grp,
 	struct usnic_vnic_res_chunk *res_chunk;
 
 	res_chunk = usnic_ib_qp_grp_get_chunk(qp_grp, USNIC_VNIC_RES_TYPE_RQ);
-	if (IS_ERR_OR_NULL(res_chunk)) {
+	if (IS_ERR(res_chunk)) {
 		usnic_err("Unable to get %s with err %ld\n",
 			usnic_vnic_res_type_to_str(USNIC_VNIC_RES_TYPE_RQ),
 			PTR_ERR(res_chunk));
-		return res_chunk ? PTR_ERR(res_chunk) : -ENOMEM;
+		return PTR_ERR(res_chunk);
 	}
 
 	uaction->vnic_idx = usnic_vnic_get_index(qp_grp->vf->vnic);
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
index a5bfbba..79766db 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
@@ -87,12 +87,12 @@ static int usnic_ib_fill_create_qp_resp(struct usnic_ib_qp_grp *qp_grp,
 	resp.bar_len = bar->len;
 
 	chunk = usnic_ib_qp_grp_get_chunk(qp_grp, USNIC_VNIC_RES_TYPE_RQ);
-	if (IS_ERR_OR_NULL(chunk)) {
+	if (IS_ERR(chunk)) {
 		usnic_err("Failed to get chunk %s for qp_grp %d with err %ld\n",
 			usnic_vnic_res_type_to_str(USNIC_VNIC_RES_TYPE_RQ),
 			qp_grp->grp_id,
 			PTR_ERR(chunk));
-		return chunk ? PTR_ERR(chunk) : -ENOMEM;
+		return PTR_ERR(chunk);
 	}
 
 	WARN_ON(chunk->type != USNIC_VNIC_RES_TYPE_RQ);
@@ -101,12 +101,12 @@ static int usnic_ib_fill_create_qp_resp(struct usnic_ib_qp_grp *qp_grp,
 		resp.rq_idx[i] = chunk->res[i]->vnic_idx;
 
 	chunk = usnic_ib_qp_grp_get_chunk(qp_grp, USNIC_VNIC_RES_TYPE_WQ);
-	if (IS_ERR_OR_NULL(chunk)) {
+	if (IS_ERR(chunk)) {
 		usnic_err("Failed to get chunk %s for qp_grp %d with err %ld\n",
 			usnic_vnic_res_type_to_str(USNIC_VNIC_RES_TYPE_WQ),
 			qp_grp->grp_id,
 			PTR_ERR(chunk));
-		return chunk ? PTR_ERR(chunk) : -ENOMEM;
+		return PTR_ERR(chunk);
 	}
 
 	WARN_ON(chunk->type != USNIC_VNIC_RES_TYPE_WQ);
@@ -115,12 +115,12 @@ static int usnic_ib_fill_create_qp_resp(struct usnic_ib_qp_grp *qp_grp,
 		resp.wq_idx[i] = chunk->res[i]->vnic_idx;
 
 	chunk = usnic_ib_qp_grp_get_chunk(qp_grp, USNIC_VNIC_RES_TYPE_CQ);
-	if (IS_ERR_OR_NULL(chunk)) {
+	if (IS_ERR(chunk)) {
 		usnic_err("Failed to get chunk %s for qp_grp %d with err %ld\n",
 			usnic_vnic_res_type_to_str(USNIC_VNIC_RES_TYPE_CQ),
 			qp_grp->grp_id,
 			PTR_ERR(chunk));
-		return chunk ? PTR_ERR(chunk) : -ENOMEM;
+		return PTR_ERR(chunk);
 	}
 
 	WARN_ON(chunk->type != USNIC_VNIC_RES_TYPE_CQ);
