From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 11/16] IB/hfi1: Remove duplicate definitions of
 num_user_pages() function
Date: Mon, 21 Aug 2017 18:27:16 -0700
Message-ID: <20170822012715.32701.41769.stgit@scvm10.sc.intel.com>
References: <20170822011657.32701.22207.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170822011657.32701.22207.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

num_user_pages() function has been defined in both user_exp_rcv.c file
and user_sdma.c file. Move the function definition to a header file so
there is only one definition in the source repo.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/user_exp_rcv.c |    5 -----
 drivers/infiniband/hw/hfi1/user_exp_rcv.h |    9 +++++++++
 drivers/infiniband/hw/hfi1/user_sdma.c    |   18 +++---------------
 3 files changed, 12 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.c b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
index 04be178..026790e 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -67,11 +67,6 @@ struct tid_pageset {
 	u16 count;
 };
 
-#define num_user_pages(vaddr, len)				       \
-	(1 + (((((unsigned long)(vaddr) +			       \
-		 (unsigned long)(len) - 1) & PAGE_MASK) -	       \
-	       ((unsigned long)vaddr & PAGE_MASK)) >> PAGE_SHIFT))
-
 static void unlock_exp_tids(struct hfi1_ctxtdata *uctxt,
 			    struct exp_tid_set *set,
 			    struct hfi1_filedata *fd);
diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.h b/drivers/infiniband/hw/hfi1/user_exp_rcv.h
index 8c4eb5d..7461d11 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.h
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.h
@@ -60,6 +60,15 @@ struct tid_user_buf {
 	unsigned int n_psets;
 };
 
+static inline int num_user_pages(unsigned long addr,
+				 unsigned long len)
+{
+	const unsigned long spage = addr & PAGE_MASK;
+	const unsigned long epage = (addr + len - 1) & PAGE_MASK;
+
+	return 1 + ((epage - spage) >> PAGE_SHIFT);
+}
+
 int hfi1_user_exp_rcv_init(struct hfi1_filedata *fd,
 			   struct hfi1_ctxtdata *uctxt);
 void hfi1_user_exp_rcv_free(struct hfi1_filedata *fd);
diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index a3a9925..2837407 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -246,7 +246,6 @@ struct user_sdma_txreq {
 
 static int user_sdma_send_pkts(struct user_sdma_request *req,
 			       unsigned maxpkts);
-static int num_user_pages(const struct iovec *iov);
 static void user_sdma_txreq_cb(struct sdma_txreq *txreq, int status);
 static inline void pq_update(struct hfi1_user_sdma_pkt_q *pq);
 static void user_sdma_free_request(struct user_sdma_request *req, bool unpin);
@@ -1101,19 +1100,6 @@ static int user_sdma_send_pkts(struct user_sdma_request *req, unsigned maxpkts)
 	return ret;
 }
 
-/*
- * How many pages in this iovec element?
- */
-static inline int num_user_pages(const struct iovec *iov)
-{
-	const unsigned long addr  = (unsigned long)iov->iov_base;
-	const unsigned long len   = iov->iov_len;
-	const unsigned long spage = addr & PAGE_MASK;
-	const unsigned long epage = (addr + len - 1) & PAGE_MASK;
-
-	return 1 + ((epage - spage) >> PAGE_SHIFT);
-}
-
 static u32 sdma_cache_evict(struct hfi1_user_sdma_pkt_q *pq, u32 npages)
 {
 	struct evict_data evict_data;
@@ -1182,6 +1168,7 @@ static int pin_vector_pages(struct user_sdma_request *req,
 	struct hfi1_user_sdma_pkt_q *pq = req->pq;
 	struct sdma_mmu_node *node = NULL;
 	struct mmu_rb_node *rb_node;
+	struct iovec *iov;
 	bool extracted;
 
 	extracted =
@@ -1210,7 +1197,8 @@ static int pin_vector_pages(struct user_sdma_request *req,
 		atomic_set(&node->refcount, 0);
 	}
 
-	npages = num_user_pages(&iovec->iov);
+	iov = &iovec->iov;
+	npages = num_user_pages((unsigned long)iov->iov_base, iov->iov_len);
 	if (node->npages < npages) {
 		pinned = pin_sdma_pages(req, iovec, node, npages);
 		if (pinned < 0) {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
