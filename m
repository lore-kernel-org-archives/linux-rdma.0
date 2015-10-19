From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 21/23] staging/rdma/hfi1: Add unit # to verbs txreq cache name
Date: Mon, 19 Oct 2015 12:43:45 -0400
Message-ID: <1445273027-29634-22-git-send-email-ira.weiny@intel.com>
References: <1445273027-29634-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445273027-29634-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The name used to create the verbs txreq cache was not qualified with the unit
number. This causes a panic when destroying the cache on a dual HFI systems.
Create a unique name with the unit number with this patch

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/verbs.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index b2bb8ce97915..514956af5b5d 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -129,6 +129,9 @@ static void verbs_sdma_complete(
 	int status,
 	int drained);
 
+/* Length of buffer to create verbs txreq cache name */
+#define TXREQ_NAME_LEN 24
+
 /*
  * Note that it is OK to post send work requests in the SQE and ERR
  * states; hfi1_do_send() will process them and generate error
@@ -1899,6 +1902,7 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	int ret;
 	size_t lcpysz = IB_DEVICE_NAME_MAX;
 	u16 descq_cnt;
+	char buf[TXREQ_NAME_LEN];
 
 	ret = hfi1_qp_init(dev);
 	if (ret)
@@ -1952,8 +1956,9 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 
 	descq_cnt = sdma_get_descq_cnt();
 
+	snprintf(buf, sizeof(buf), "hfi1_%u_vtxreq_cache", dd->unit);
 	/* SLAB_HWCACHE_ALIGN for AHG */
-	dev->verbs_txreq_cache = kmem_cache_create("hfi1_vtxreq_cache",
+	dev->verbs_txreq_cache = kmem_cache_create(buf,
 						   sizeof(struct verbs_txreq),
 						   0, SLAB_HWCACHE_ALIGN,
 						   verbs_txreq_kmem_cache_ctor);
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
