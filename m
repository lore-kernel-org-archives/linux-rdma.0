From: Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] bnxt_re: changing the ip address shouldn't affect new connections
Date: Fri,  3 Nov 2017 02:39:04 +0530
Message-ID: <20171102210904.13020-1-sriharsha.basavapatna@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

While adding a new gid, the driver currently does not return the context
back to the stack. A subsequent del_gid() (e.g, when ip address is changed)
doesn't find the right context in the driver and it ends up dropping that
request. This results in the HW caching a stale gid entry and traffic fails
because of that. Fix by returning the proper context in bnxt_re_add_gid().

Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 0d89621d9fe8..b210495ff33c 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -394,6 +394,7 @@ int bnxt_re_add_gid(struct ib_device *ibdev, u8 port_num,
 	ctx->idx = tbl_idx;
 	ctx->refcnt = 1;
 	ctx_tbl[tbl_idx] = ctx;
+	*context = ctx;
 
 	return rc;
 }
-- 
2.11.0.258.ge05806da9

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
