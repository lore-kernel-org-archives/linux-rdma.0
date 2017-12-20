From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core] verbs: Remove comp_mask checks from verbs.h
Date: Wed, 20 Dec 2017 16:13:50 -0700
Message-ID: <20171220231350.GA19130@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In the case of ibv_create_cq_ex this duplicates a check already done
by ibv_cmd_create_cq_ex.

In the case of ibv_queryrt_values_ex, there is no check in the function
op, which is an ABI mistake. So move the check there.

comp_mask should never be tested in the inline trampolines to generate
EINVAL as the inlines are part of the app and could be from a future
libibverbs with an expanded comp_mask.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/verbs.h     | 8 --------
 providers/mlx4/verbs.c | 3 +++
 providers/mlx5/verbs.c | 3 +++
 3 files changed, 6 insertions(+), 8 deletions(-)

I missed these when reviewing the earlier patches, and now people are
cargo-cult copying them into new APIs.

diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 775bad52601781..7b53a6f5dff51f 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -1967,11 +1967,6 @@ struct ibv_cq_ex *ibv_create_cq_ex(struct ibv_context *context,
 		return NULL;
 	}
 
-	if (cq_attr->comp_mask & ~(IBV_CQ_INIT_ATTR_MASK_RESERVED - 1)) {
-		errno = EINVAL;
-		return NULL;
-	}
-
 	return vctx->create_cq_ex(context, cq_attr);
 }
 
@@ -2200,9 +2195,6 @@ ibv_query_rt_values_ex(struct ibv_context *context,
 	if (!vctx)
 		return ENOSYS;
 
-	if (values->comp_mask & ~(IBV_VALUES_MASK_RESERVED - 1))
-		return EINVAL;
-
 	return vctx->query_rt_values(context, values);
 }
 
diff --git a/providers/mlx4/verbs.c b/providers/mlx4/verbs.c
index ec02bd4642b2d2..0a4ed1fde001eb 100644
--- a/providers/mlx4/verbs.c
+++ b/providers/mlx4/verbs.c
@@ -135,6 +135,9 @@ int mlx4_query_rt_values(struct ibv_context *context,
 	uint32_t comp_mask = 0;
 	int err = 0;
 
+	if (!check_comp_mask(values->comp_mask, IBV_VALUES_MASK_RAW_CLOCK))
+		return EINVAL;
+
 	if (values->comp_mask & IBV_VALUES_MASK_RAW_CLOCK) {
 		uint64_t cycles;
 
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index a3323fd47651a7..579c0f3402d54d 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -108,6 +108,9 @@ int mlx5_query_rt_values(struct ibv_context *context,
 	uint32_t comp_mask = 0;
 	int err = 0;
 
+	if (!check_comp_mask(values->comp_mask, IBV_VALUES_MASK_RAW_CLOCK))
+		return EINVAL;
+
 	if (values->comp_mask & IBV_VALUES_MASK_RAW_CLOCK) {
 		uint64_t cycles;
 
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
