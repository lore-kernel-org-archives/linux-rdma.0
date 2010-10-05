From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] librdmacm: only allocate qp in rdma_create_ep if qp_attr
 provided
Date: Mon, 4 Oct 2010 17:12:23 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25AED7933E@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The comments and documentation for rdma_create_ep indicate that
it will only allocate a QP if initial QP attributes are provided.
However, the code always attempts to create a QP off an
active rdma_cm_id endpoint.

By _not_ allocating the QP, a user can first determine
what RDMA device an rdma_cm_id was associated with (returned from
rdma_create_ep).  The user can then call rdma_create_qp to
allocate a QP referencing an existing CQ, SRQ, or PD.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
This addresses an issue reported by Frank Zago while he was trying
to add XRC support to the librdmacm.

 src/cma.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/src/cma.c b/src/cma.c
index f7568cf..253cf80 100755
--- a/src/cma.c
+++ b/src/cma.c
@@ -2146,10 +2146,12 @@ int rdma_create_ep(struct rdma_cm_id **id, struct rdma_addrinfo *res,
 	if (ret)
 		goto err;
 
-	qp_init_attr->qp_type = res->ai_qp_type;
-	ret = rdma_create_qp(cm_id, pd, qp_init_attr);
-	if (ret)
-		goto err;
+	if (qp_init_attr) {
+		qp_init_attr->qp_type = res->ai_qp_type;
+		ret = rdma_create_qp(cm_id, pd, qp_init_attr);
+		if (ret)
+			goto err;
+	}
 
 	if (res->ai_connect_len) {
 		id_priv = container_of(cm_id, struct cma_id_private, id);


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
