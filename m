From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] librdmacm: Only allow a user to allocate a single QP off an
 rdma_cm_id
Date: Fri, 4 Mar 2011 15:25:43 -0800
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25CC92EA32@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add a simple check to rdma_create_qp() to see if a QP has already been
associated with an rdma_cm_id.  Otherwise a user can allocate a
second QP with an ID, with the reference to the first QP replaced
by the second allocation.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 man/rdma_create_qp.3 |    3 ++-
 src/cma.c            |    3 +++
 2 files changed, 5 insertions(+), 1 deletions(-)
 mode change 100644 => 100755 man/rdma_create_qp.3

diff --git a/man/rdma_create_qp.3 b/man/rdma_create_qp.3
index 7445db3..7e37888
--- a/man/rdma_create_qp.3
+++ b/man/rdma_create_qp.3
@@ -41,7 +41,8 @@ channels.  Completion channels and CQ data created by the rdma_cm are
 exposed to the user through the rdma_cm_id structure.
 .P
 The actual capabilities and properties of the created QP will be
-returned to the user through the qp_init_attr parameter.
+returned to the user through the qp_init_attr parameter.  An rdma_cm_id
+may only be associated with a single QP.
 .SH "SEE ALSO"
 rdma_bind_addr(3), rdma_resolve_addr(3), rdma_destroy_qp(3), ibv_create_qp(3),
 ibv_modify_qp(3)
diff --git a/src/cma.c b/src/cma.c
index 7ac5335..846b5ce 100755
--- a/src/cma.c
+++ b/src/cma.c
@@ -1176,6 +1176,9 @@ int rdma_create_qp(struct rdma_cm_id *id, struct ibv_pd *pd,
 	struct ibv_qp *qp;
 	int ret;
 
+	if (id->qp)
+		return ERR(EINVAL);
+
 	id_priv = container_of(id, struct cma_id_private, id);
 	if (!pd)
 		pd = id_priv->cma_dev->pd;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
