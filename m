From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH rdma-core] cxgb4: Add missing null termination of hca_table
Date: Tue, 21 Nov 2017 08:27:17 -0700
Message-ID: <20171121152717.GA18003@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Otherwise there are random crashes during device discovery.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/cxgb3/iwch.c | 1 +
 1 file changed, 1 insertion(+)

Fix a little typo I made when reworking the init scheme.

https://github.com/linux-rdma/rdma-core/pull/262

diff --git a/providers/cxgb3/iwch.c b/providers/cxgb3/iwch.c
index 3cc1d4c185e97e..da9179fbbe2a8d 100644
--- a/providers/cxgb3/iwch.c
+++ b/providers/cxgb3/iwch.c
@@ -72,6 +72,7 @@ static const struct verbs_match_ent hca_table[] = {
 	HCA(CHELSIO, T3B02, T3B),
 	HCA(CHELSIO, T3C20, T3B),
 	HCA(CHELSIO, S320E, T3B),
+	{},
 };
 
 static struct ibv_context_ops iwch_ctx_ops = {
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
