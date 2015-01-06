From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 2/2] IB/core: properly handle registration of on-demand paging MRs after dereg
Date: Tue,  6 Jan 2015 11:23:20 +0200
Message-ID: <1420536200-5705-3-git-send-email-haggaie@mellanox.com>
References: <1420536200-5705-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1420536200-5705-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When the last on-demand paging MR is released the notifier count is left
non-zero so that concurrent page faults will have to abort. If a new MR
is then registered, the counter is reset. However, the decision is made
to put the new MR in the list waiting for the notifier count to reach
zero, before the counter is reset. An invalidation or another MR
registration can release the MR to handle page faults, but without such
an event the MR can wait forever.

The patch fixes this issue by adding a check whether the MR is the first
on-demand paging MR when deciding whether it is ready to handle page
faults. If it is the first MR, we know that there are no mmu notifiers
running in parallel to the registration.

Fixes: 882214e2b128 ("IB/core: Implement support for MMU notifiers regarding on demand paging regions")
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/umem_odp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
index 6095872549e7..8b8cc6fa0ab0 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -294,7 +294,8 @@ int ib_umem_odp_get(struct ib_ucontext *context, struct ib_umem *umem)
 	if (likely(ib_umem_start(umem) != ib_umem_end(umem)))
 		rbt_ib_umem_insert(&umem->odp_data->interval_tree,
 				   &context->umem_tree);
-	if (likely(!atomic_read(&context->notifier_count)))
+	if (likely(!atomic_read(&context->notifier_count)) ||
+	    context->odp_mrs_count == 1)
 		umem->odp_data->mn_counters_active = true;
 	else
 		list_add(&umem->odp_data->no_private_counters,
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
