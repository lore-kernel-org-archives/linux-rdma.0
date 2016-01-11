From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 libibverbs 1/2] Change rereg_mr API between libibverbs and the provider's library
Date: Mon, 11 Jan 2016 17:05:17 +0200
Message-ID: <1452524718-21575-2-git-send-email-yishaih@mellanox.com>
References: <1452524718-21575-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452524718-21575-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Currently, MR re-registration isn't implemented in libibverbs.
The only part which does exist is an API call between libibverbs
and the provider's library. Since there's no way for a user application
to invoke this API call, it's safe to assume it's unused.

Similarly to other verbs (for example, ibv_modify_qp), a modification
to the MR shouldn't change the user's handle. The current existing API is:
struct ibv_mr *         (*rereg_mr)(struct ibv_mr *mr,
                                    int flags,
                                    struct ibv_pd *pd, void *addr,
                                    size_t length,
                                    int access);

As a result, this API call returns the exact same pointer it gets.
Instead, we propose retuning a status int, which is far more useful
than the current return value.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/infiniband/verbs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index ae22768..48e868c 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -951,7 +951,7 @@ struct ibv_context_ops {
 	int			(*dealloc_pd)(struct ibv_pd *pd);
 	struct ibv_mr *		(*reg_mr)(struct ibv_pd *pd, void *addr, size_t length,
 					  int access);
-	struct ibv_mr *		(*rereg_mr)(struct ibv_mr *mr,
+	int			(*rereg_mr)(struct ibv_mr *mr,
 					    int flags,
 					    struct ibv_pd *pd, void *addr,
 					    size_t length,
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
