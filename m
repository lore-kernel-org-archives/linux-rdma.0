From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v2 13/22] staging/rdma/hfi1: Macro code clean up
Date: Mon, 19 Oct 2015 22:11:28 -0400
Message-ID: <1445307097-8244-14-git-send-email-ira.weiny@intel.com>
References: <1445307097-8244-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445307097-8244-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Clean up the context and sdma macros and move them to a more logical place in
hfi.h

Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/hfi.h | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 8ca171bf3e36..16110149991e 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -1104,6 +1104,16 @@ struct hfi1_filedata {
 	int rec_cpu_num;
 };
 
+/* for use in system calls, where we want to know device type, etc. */
+#define fp_to_fd(fp) ((struct hfi1_filedata *)(fp)->private_data)
+#define ctxt_fp(fp) (fp_to_fd((fp))->uctxt)
+#define subctxt_fp(fp) (fp_to_fd((fp))->subctxt)
+#define tidcursor_fp(fp) (fp_to_fd((fp))->tidcursor)
+#define user_sdma_pkt_fp(fp) (fp_to_fd((fp))->pq)
+#define user_sdma_comp_fp(fp) (fp_to_fd((fp))->cq)
+#define notifier_fp(fp) (fp_to_fd((fp))->mn)
+#define rb_fp(fp) (fp_to_fd((fp))->tid_rb_root)
+
 extern struct list_head hfi1_dev_list;
 extern spinlock_t hfi1_devs_lock;
 struct hfi1_devdata *hfi1_lookup(int unit);
@@ -1411,18 +1421,6 @@ int snoop_send_pio_handler(struct hfi1_qp *qp, struct ahg_ib_header *ibhdr,
 void snoop_inline_pio_send(struct hfi1_devdata *dd, struct pio_buf *pbuf,
 			   u64 pbc, const void *from, size_t count);
 
-/* for use in system calls, where we want to know device type, etc. */
-#define ctxt_fp(fp) \
-	(((struct hfi1_filedata *)(fp)->private_data)->uctxt)
-#define subctxt_fp(fp) \
-	(((struct hfi1_filedata *)(fp)->private_data)->subctxt)
-#define tidcursor_fp(fp) \
-	(((struct hfi1_filedata *)(fp)->private_data)->tidcursor)
-#define user_sdma_pkt_fp(fp) \
-	(((struct hfi1_filedata *)(fp)->private_data)->pq)
-#define user_sdma_comp_fp(fp) \
-	(((struct hfi1_filedata *)(fp)->private_data)->cq)
-
 static inline struct hfi1_devdata *dd_from_ppd(struct hfi1_pportdata *ppd)
 {
 	return ppd->dd;
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
