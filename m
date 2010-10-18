From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] librdmacm: Do not modify qp_init_attr in rdma_get_request
Date: Mon, 18 Oct 2010 10:27:28 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7EFD851@orsmsx501.amr.corp.intel.com>
References: <loom.20101018T140608-776@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20101018T140608-776-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Rosser <jonathan.rosser-gjMux1o1B1/QXOPxS62xeg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

rdma_create_qp modifies the qp_init_attr structure passed in
by the user to return the actual QP capabilities that were
allocated.  If the qp_init_attr does not specify CQs, the
librdmacm will allocate CQs for the user and return them.

rdma_get_request will allocate a QP off newly connected rdma_cm_id
if the corresponding listen request is associated with a
qp_init_attr structure.  The librdmacm passes in the listen->
qp_init_attr structure into the rdma_create_qp call.
rdma_create_qp ends up modifying the qp_init_attr's associated
with the listen.  The result is that future calls to
rdma_get_request will use the modified qp attributes, rather
than those specified by the user.

Fix this by having rdma_get_request pass in a copy of the
qp_init_attr, rather than modifying those associated with the
listen.  Also update the man page for rdma_create_qp to indicate
that the qp_init_attr structure may be modified on output.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
I added a while(1) loop to rdma_server to allow clients to connected
repeatedly, and this worked for me.  Jonathan, can you see if this
works for your testing as well?  If so, I'll commit.

 man/rdma_create_qp.3 |    3 +++
 src/cma.c            |    5 ++++-
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/man/rdma_create_qp.3 b/man/rdma_create_qp.3
index 9d2de76..7445db3 100644
--- a/man/rdma_create_qp.3
+++ b/man/rdma_create_qp.3
@@ -39,6 +39,9 @@ a send or receive completion queue is not specified, then a CQ will be
 allocated by the rdma_cm for the QP, along with corresponding completion
 channels.  Completion channels and CQ data created by the rdma_cm are
 exposed to the user through the rdma_cm_id structure.
+.P
+The actual capabilities and properties of the created QP will be
+returned to the user through the qp_init_attr parameter.
 .SH "SEE ALSO"
 rdma_bind_addr(3), rdma_resolve_addr(3), rdma_destroy_qp(3), ibv_create_qp(3),
 ibv_modify_qp(3)
diff --git a/src/cma.c b/src/cma.c
index 253cf80..7ac5335 100755
--- a/src/cma.c
+++ b/src/cma.c
@@ -1368,7 +1368,10 @@ int rdma_get_request(struct rdma_cm_id *listen, struct rdma_cm_id **id)
 	}
 
 	if (id_priv->qp_init_attr) {
-		ret = rdma_create_qp(event->id, id_priv->pd, id_priv->qp_init_attr);
+		struct ibv_qp_init_attr attr;
+
+		attr = *id_priv->qp_init_attr;
+		ret = rdma_create_qp(event->id, id_priv->pd, &attr);
 		if (ret)
 			goto err;
 	}


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
