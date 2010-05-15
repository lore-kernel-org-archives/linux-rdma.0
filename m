From: Julia Lawall <julia-dAYI7NvHqcQ@public.gmane.org>
Subject: [PATCH 31/37] drivers/infiniband/core: Use kmemdup
Date: Sat, 15 May 2010 23:22:38 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.1005152322190.21345@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-jani
List-Id: linux-rdma@vger.kernel.org

From: Julia Lawall <julia-dAYI7NvHqcQ@public.gmane.org>

Use kmemdup when some other buffer is immediately copied into the
allocated region.

A simplified version of the semantic patch that makes this change is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression from,to,size,flag;
statement S;
@@

-  to = \(kmalloc\|kzalloc\)(size,flag);
+  to = kmemdup(from,size,flag);
   if (to==NULL || ...) S
-  memcpy(to, from, size);
// </smpl>

Signed-off-by: Julia Lawall <julia-dAYI7NvHqcQ@public.gmane.org>

---
 drivers/infiniband/core/cma.c |    4 ++--
 drivers/infiniband/core/mad.c |    4 +---
 2 files changed, 3 insertions(+), 5 deletions(-)

diff -u -p a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1676,13 +1676,13 @@ int rdma_set_ib_paths(struct rdma_cm_id 
 	if (!cma_comp_exch(id_priv, CMA_ADDR_RESOLVED, CMA_ROUTE_RESOLVED))
 		return -EINVAL;
 
-	id->route.path_rec = kmalloc(sizeof *path_rec * num_paths, GFP_KERNEL);
+	id->route.path_rec = kmemdup(path_rec, sizeof *path_rec * num_paths,
+				     GFP_KERNEL);
 	if (!id->route.path_rec) {
 		ret = -ENOMEM;
 		goto err;
 	}
 
-	memcpy(id->route.path_rec, path_rec, sizeof *path_rec * num_paths);
 	id->route.num_paths = num_paths;
 	return 0;
 err:
diff -u -p a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -291,13 +291,11 @@ struct ib_mad_agent *ib_register_mad_age
 	}
 
 	if (mad_reg_req) {
-		reg_req = kmalloc(sizeof *reg_req, GFP_KERNEL);
+		reg_req = kmemdup(mad_reg_req, sizeof *reg_req, GFP_KERNEL);
 		if (!reg_req) {
 			ret = ERR_PTR(-ENOMEM);
 			goto error3;
 		}
-		/* Make a copy of the MAD registration request */
-		memcpy(reg_req, mad_reg_req, sizeof *reg_req);
 	}
 
 	/* Now, fill in the various structures */
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
