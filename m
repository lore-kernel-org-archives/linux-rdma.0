From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] staging/rdma/hfi1: fix sdma build failures to always clean
 up
Date: Thu, 03 Dec 2015 16:41:05 -0500
Message-ID: <20151203214105.6103.23333.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

There are holes in the sdma build support routines that do
not clean any partially built sdma descriptors after mapping or
allocate failures.

This patch corrects these issues.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/sdma.c |   10 ++++++----
 drivers/staging/rdma/hfi1/sdma.h |    7 +++++--
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/sdma.c b/drivers/staging/rdma/hfi1/sdma.c
index 90b7072..8023eeb 100644
--- a/drivers/staging/rdma/hfi1/sdma.c
+++ b/drivers/staging/rdma/hfi1/sdma.c
@@ -2724,22 +2724,21 @@ static int _extend_sdma_tx_descs(struct hfi1_devdata *dd, struct sdma_txreq *tx)
 			tx->coalesce_buf = kmalloc(tx->tlen + sizeof(u32),
 						   GFP_ATOMIC);
 			if (!tx->coalesce_buf)
-				return -ENOMEM;
-
+				goto enomem;
 			tx->coalesce_idx = 0;
 		}
 		return 0;
 	}
 
 	if (unlikely(tx->num_desc == MAX_DESC))
-		return -ENOMEM;
+		goto enomem;
 
 	tx->descp = kmalloc_array(
 			MAX_DESC,
 			sizeof(struct sdma_desc),
 			GFP_ATOMIC);
 	if (!tx->descp)
-		return -ENOMEM;
+		goto enomem;
 
 	/* reserve last descriptor for coalescing */
 	tx->desc_limit = MAX_DESC - 1;
@@ -2747,6 +2746,9 @@ static int _extend_sdma_tx_descs(struct hfi1_devdata *dd, struct sdma_txreq *tx)
 	for (i = 0; i < tx->num_desc; i++)
 		tx->descp[i] = tx->descs[i];
 	return 0;
+enomem:
+	sdma_txclean(dd, tx);
+	return -ENOMEM;
 }
 
 /*
diff --git a/drivers/staging/rdma/hfi1/sdma.h b/drivers/staging/rdma/hfi1/sdma.h
index 85701ee..da89e64 100644
--- a/drivers/staging/rdma/hfi1/sdma.h
+++ b/drivers/staging/rdma/hfi1/sdma.h
@@ -774,10 +774,13 @@ static inline int _sdma_txadd_daddr(
 	tx->tlen -= len;
 	/* special cases for last */
 	if (!tx->tlen) {
-		if (tx->packet_len & (sizeof(u32) - 1))
+		if (tx->packet_len & (sizeof(u32) - 1)) {
 			rval = _pad_sdma_tx_descs(dd, tx);
-		else
+			if (rval)
+				return rval;
+		} else {
 			_sdma_close_tx(dd, tx);
+		}
 	}
 	tx->num_desc++;
 	return rval;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
