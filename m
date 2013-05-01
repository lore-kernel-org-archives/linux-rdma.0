From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-3.10 3/4] IB/iser: Return error to upper layers on EAGAIN registration failures
Date: Wed,  1 May 2013 16:25:26 +0300
Message-ID: <1367414727-22680-4-git-send-email-ogerlitz@mellanox.com>
References: <1367414727-22680-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1367414727-22680-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Commit 819a087 "IB/iser: Avoid error prints on EAGAIN registration
failures" not only eliminated the error print on that case, but
rather also modified the code such that it doesn't return any error
to upper layers. As a result a wrong mapping was used. Fix this
such that we do return error on that case.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_memory.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index be1edb0..68ebb7f 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -416,8 +416,9 @@ int iser_reg_rdma_mem(struct iscsi_iser_task *iser_task,
 			for (i=0 ; i<ib_conn->page_vec->length ; i++)
 				iser_err("page_vec[%d] = 0x%llx\n", i,
 					 (unsigned long long) ib_conn->page_vec->pages[i]);
-			return err;
 		}
+		if (err)
+			return err;
 	}
 	return 0;
 }
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
