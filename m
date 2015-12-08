From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC libibverbs 1/2] Add contiguous pages support
Date: Tue,  8 Dec 2015 17:17:04 +0200
Message-ID: <1449587825-26444-2-git-send-email-yishaih@mellanox.com>
References: <1449587825-26444-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449587825-26444-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

To enable contiguous the application should supply NULL address
as part of ibv_reg_mr and turn on a bit in the access flags
asking for.

In that mode the provider allocates contiguous pages and it also
manages the un/do_fork_range calls.

An extra extended verb between the library and the provider asking
for the ibv_mr access flags was added so that the library can know
whether to call ibv_dofork_range in its code
upon ibv_dereg_mr.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/infiniband/verbs.h |  2 ++
 src/verbs.c                | 29 +++++++++++++++++++++++------
 2 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index ae22768..b80eb4f 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -384,6 +384,7 @@ enum ibv_access_flags {
 	IBV_ACCESS_REMOTE_ATOMIC	= (1<<3),
 	IBV_ACCESS_MW_BIND		= (1<<4),
 	IBV_ACCESS_ON_DEMAND		= (1<<6),
+	IBV_ACCESS_ALLOC_MR             = (1<<7),
 };
 
 struct ibv_pd {
@@ -1021,6 +1022,7 @@ enum verbs_context_mask {
 
 struct verbs_context {
 	/*  "grows up" - new fields go here */
+	int (*get_mr_access_flags)(struct ibv_mr *ibv_mr);
 	int (*query_device_ex)(struct ibv_context *context,
 			       const struct ibv_query_device_ex_input *input,
 			       struct ibv_device_attr_ex *attr,
diff --git a/src/verbs.c b/src/verbs.c
index ada3515..32d36d6 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -211,18 +211,27 @@ struct ibv_mr *__ibv_reg_mr(struct ibv_pd *pd, void *addr,
 			    size_t length, int access)
 {
 	struct ibv_mr *mr;
+	int is_contig;
 
-	if (ibv_dontfork_range(addr, length))
-		return NULL;
+	is_contig = !addr && !!((access & IBV_ACCESS_ALLOC_MR));
+
+	/* fork support for contig is handled by the provider */
+	if (!is_contig) {
+		if (ibv_dontfork_range(addr, length))
+			return NULL;
+	}
 
 	mr = pd->context->ops.reg_mr(pd, addr, length, access);
 	if (mr) {
 		mr->context = pd->context;
 		mr->pd      = pd;
-		mr->addr    = addr;
+		if (!is_contig)
+			/* for contig addr is set internally */
+			mr->addr    = addr;
 		mr->length  = length;
-	} else
+	} else if (!is_contig) {
 		ibv_dofork_range(addr, length);
+	}
 
 	return mr;
 }
@@ -233,10 +242,18 @@ int __ibv_dereg_mr(struct ibv_mr *mr)
 	int ret;
 	void *addr	= mr->addr;
 	size_t length	= mr->length;
+	int access_flags	= 0;
+	struct verbs_context *vctx;
+
+	vctx = verbs_get_ctx_op(mr->context, get_mr_access_flags);
+	if (vctx)
+		access_flags = vctx->get_mr_access_flags(mr);
 
 	ret = mr->context->ops.dereg_mr(mr);
-	if (!ret)
-		ibv_dofork_range(addr, length);
+	if (!ret) {
+		if (!(access_flags & IBV_ACCESS_ALLOC_MR))
+			ibv_dofork_range(addr, length);
+	}
 
 	return ret;
 }
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
