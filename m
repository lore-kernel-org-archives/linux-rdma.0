From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH rdma-core 4/5] hns: Remove useless assignments
Date: Thu, 14 Dec 2017 15:35:42 -0700
Message-ID: <20171214223544.30117-5-jgg@ziepe.ca>
References: <20171214223544.30117-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171214223544.30117-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

We free the memory a few lines later, the first assign cannot do anything
useful.

No sense in zeroing a stack variable before exiting.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/hns/hns_roce_u.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/providers/hns/hns_roce_u.c b/providers/hns/hns_roce_u.c
index 9b5de441a3fdf1..489b71614614fe 100644
--- a/providers/hns/hns_roce_u.c
+++ b/providers/hns/hns_roce_u.c
@@ -167,10 +167,7 @@ static void hns_roce_free_context(struct ibv_context *ibctx)
 	if (to_hr_dev(ibctx->device)->hw_version == HNS_ROCE_HW_VER1)
 		munmap(context->cq_tptr_base, HNS_ROCE_CQ_DB_BUF_SIZE);
 
-	context->uar = NULL;
-
 	free(context);
-	context = NULL;
 }
 
 static void hns_uninit_device(struct verbs_device *verbs_device)
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
