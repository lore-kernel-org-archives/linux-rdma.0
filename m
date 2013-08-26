From: <bgottumukka-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 11/14] RDMA/ocrdma: Consider multiple SGES in case of DPP.
Date: Mon, 26 Aug 2013 15:27:48 +0530
Message-ID: <891bb2e3-d431-4864-af21-163ccde73e7b@CMEXHTCAS1.ad.emulex.com>
References: <1377511071-16967-1-git-send-email-bgottumukka@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1377511071-16967-1-git-send-email-bgottumukka-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

While posting inline DPP data, we are not considering multiple sges.
Fixed this.

Signed-off-by: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 32 ++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index f09a940..0504e73 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -1820,24 +1820,42 @@ static void ocrdma_build_sges(struct ocrdma_hdr_wqe *hdr,
 		memset(sge, 0, sizeof(*sge));
 }
 
+static inline uint32_t ocrdma_sglist_len(struct ib_sge *sg_list, int num_sge)
+{
+	uint32_t total_len = 0, i;
+
+	for (i = 0; i < num_sge; i++)
+		total_len += sg_list[i].length;
+	return total_len;
+}
+
+
 static int ocrdma_build_inline_sges(struct ocrdma_qp *qp,
 				    struct ocrdma_hdr_wqe *hdr,
 				    struct ocrdma_sge *sge,
 				    struct ib_send_wr *wr, u32 wqe_size)
 {
+	int i;
+	char *dpp_addr;
+
 	if (wr->send_flags & IB_SEND_INLINE && qp->qp_type != IB_QPT_UD) {
-		if (wr->sg_list[0].length > qp->max_inline_data) {
+		hdr->total_len = ocrdma_sglist_len(wr->sg_list, wr->num_sge);
+		if (unlikely(hdr->total_len > qp->max_inline_data)) {
 			pr_err("%s() supported_len=0x%x,\n"
 			       " unspported len req=0x%x\n", __func__,
-			       qp->max_inline_data, wr->sg_list[0].length);
+				qp->max_inline_data, hdr->total_len);
 			return -EINVAL;
 		}
-		memcpy(sge,
-		       (void *)(unsigned long)wr->sg_list[0].addr,
-		       wr->sg_list[0].length);
-		hdr->total_len = wr->sg_list[0].length;
+		dpp_addr = (char *)sge;
+		for (i = 0; i < wr->num_sge; i++) {
+			memcpy(dpp_addr,
+			       (void *)(unsigned long)wr->sg_list[i].addr,
+			       wr->sg_list[i].length);
+			dpp_addr += wr->sg_list[i].length;
+		}
+
 		wqe_size += roundup(hdr->total_len, OCRDMA_WQE_ALIGN_BYTES);
-		if (0 == wr->sg_list[0].length)
+		if (0 == hdr->total_len)
 			wqe_size += sizeof(struct ocrdma_sge);
 		hdr->cw |= (OCRDMA_TYPE_INLINE << OCRDMA_WQE_TYPE_SHIFT);
 	} else {
-- 
1.8.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
