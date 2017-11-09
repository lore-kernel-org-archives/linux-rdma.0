From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 rdma-core 1/2] bnxt_re/lib: fix the memory barrier call during poll-cq
Date: Thu,  9 Nov 2017 06:10:39 -0500
Message-ID: <1510225840-20034-2-git-send-email-devesh.sharma@broadcom.com>
References: <1510225840-20034-1-git-send-email-devesh.sharma@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1510225840-20034-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Putting a read barrier before issuing a read on valid bit
is incorrect. When checking for the validity of CQE in the
CQ buffer the code must wait for the read-barrier to finish
after issuing a read operation on CQE valid bit.

Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 providers/bnxt_re/main.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/providers/bnxt_re/main.h b/providers/bnxt_re/main.h
index 9688fec..82c8948 100644
--- a/providers/bnxt_re/main.h
+++ b/providers/bnxt_re/main.h
@@ -366,9 +366,13 @@ static inline uint8_t bnxt_re_to_ibv_wc_status(uint8_t bnxt_wcst,
 static inline uint8_t bnxt_re_is_cqe_valid(struct bnxt_re_cq *cq,
 					   struct bnxt_re_bcqe *hdr)
 {
+	uint8_t valid = 0;
+
+	valid = ((le32toh(hdr->flg_st_typ_ph) &
+		  BNXT_RE_BCQE_PH_MASK) == cq->phase);
 	udma_from_device_barrier();
-	return ((le32toh(hdr->flg_st_typ_ph) &
-		 BNXT_RE_BCQE_PH_MASK) == cq->phase);
+
+	return valid;
 }
 
 static inline void bnxt_re_change_cq_phase(struct bnxt_re_cq *cq)
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
