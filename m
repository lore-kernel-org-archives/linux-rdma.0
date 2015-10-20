From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v2 07/22] staging/rdma/hfi1: Fix sparse error in sdma.h file
Date: Mon, 19 Oct 2015 22:11:22 -0400
Message-ID: <1445307097-8244-8-git-send-email-ira.weiny@intel.com>
References: <1445307097-8244-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445307097-8244-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Use NULL instead of 0 for pointer argument to fix the sparse error.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/sdma.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rdma/hfi1/sdma.h b/drivers/staging/rdma/hfi1/sdma.h
index 52a7d04067e0..cc22d2ee2054 100644
--- a/drivers/staging/rdma/hfi1/sdma.h
+++ b/drivers/staging/rdma/hfi1/sdma.h
@@ -893,7 +893,7 @@ static inline int sdma_txadd_kvaddr(
 
 	if ((unlikely(tx->num_desc == tx->desc_limit))) {
 		rval = ext_coal_sdma_tx_descs(dd, tx, SDMA_MAP_SINGLE,
-					      kvaddr, 0, 0, len);
+					      kvaddr, NULL, 0, len);
 		if (rval <= 0)
 			return rval;
 	}
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
