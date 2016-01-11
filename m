From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH RESEND v3 1/2] staging/rdma/hfi1: Clean up comments
Date: Mon, 11 Jan 2016 18:31:43 -0500
Message-ID: <1452555104-6171-2-git-send-email-jubin.john@intel.com>
References: <1452555104-6171-1-git-send-email-jubin.john@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452555104-6171-1-git-send-email-jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Edward Mascarenhas <edward.mascarenhas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Edward Mascarenhas <edward.mascarenhas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Clean up comments by deleting numbering and terms internal to Intel.

The information on the actual bugs is not deleted.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Edward Mascarenhas <edward.mascarenhas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Changes in v2:
	- Added more information in commit message

Changes in v3:
	- Refreshed patch against latest staging-next

 drivers/staging/rdma/hfi1/chip.c   |    1 -
 drivers/staging/rdma/hfi1/driver.c |    2 +-
 drivers/staging/rdma/hfi1/hfi.h    |    4 ++--
 drivers/staging/rdma/hfi1/pcie.c   |    2 +-
 drivers/staging/rdma/hfi1/ud.c     |    2 +-
 5 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index bbe5ad8..02ba78f 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -13537,7 +13537,6 @@ int hfi1_set_ctxt_jkey(struct hfi1_devdata *dd, unsigned ctxt, u16 jkey)
 	write_kctxt_csr(dd, sctxt, SEND_CTXT_CHECK_JOB_KEY, reg);
 	/*
 	 * Enable send-side J_KEY integrity check, unless this is A0 h/w
-	 * (due to A0 erratum).
 	 */
 	if (!is_ax(dd)) {
 		reg = read_kctxt_csr(dd, sctxt, SEND_CTXT_CHECK_ENABLE);
diff --git a/drivers/staging/rdma/hfi1/driver.c b/drivers/staging/rdma/hfi1/driver.c
index 8485de1..3218520 100644
--- a/drivers/staging/rdma/hfi1/driver.c
+++ b/drivers/staging/rdma/hfi1/driver.c
@@ -368,7 +368,7 @@ static void rcv_hdrerr(struct hfi1_ctxtdata *rcd, struct hfi1_pportdata *ppd,
 		if (opcode == IB_OPCODE_CNP) {
 			/*
 			 * Only in pre-B0 h/w is the CNP_OPCODE handled
-			 * via this code path (errata 291394).
+			 * via this code path.
 			 */
 			struct hfi1_qp *qp = NULL;
 			u32 lqpn, rqpn;
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 2611bb2..9785a22 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -1730,7 +1730,7 @@ static inline u64 hfi1_pkt_default_send_ctxt_mask(struct hfi1_devdata *dd,
 		base_sc_integrity |= HFI1_PKT_KERNEL_SC_INTEGRITY;
 
 	if (is_ax(dd))
-		/* turn off send-side job key checks - A0 erratum */
+		/* turn off send-side job key checks - A0 */
 		return base_sc_integrity &
 		       ~SEND_CTXT_CHECK_ENABLE_CHECK_JOB_KEY_SMASK;
 	return base_sc_integrity;
@@ -1757,7 +1757,7 @@ static inline u64 hfi1_pkt_base_sdma_integrity(struct hfi1_devdata *dd)
 	| SEND_DMA_CHECK_ENABLE_CHECK_ENABLE_SMASK;
 
 	if (is_ax(dd))
-		/* turn off send-side job key checks - A0 erratum */
+		/* turn off send-side job key checks - A0 */
 		return base_sdma_integrity &
 		       ~SEND_DMA_CHECK_ENABLE_CHECK_JOB_KEY_SMASK;
 	return base_sdma_integrity;
diff --git a/drivers/staging/rdma/hfi1/pcie.c b/drivers/staging/rdma/hfi1/pcie.c
index 8317b07..6745c82 100644
--- a/drivers/staging/rdma/hfi1/pcie.c
+++ b/drivers/staging/rdma/hfi1/pcie.c
@@ -986,7 +986,7 @@ retry:
 	 * PcieCfgRegPl100 - Gen3 Control
 	 *
 	 * turn off PcieCfgRegPl100.Gen3ZRxDcNonCompl
-	 * turn on PcieCfgRegPl100.EqEieosCnt (erratum)
+	 * turn on PcieCfgRegPl100.EqEieosCnt
 	 * Everything else zero.
 	 */
 	reg32 = PCIE_CFG_REG_PL100_EQ_EIEOS_CNT_SMASK;
diff --git a/drivers/staging/rdma/hfi1/ud.c b/drivers/staging/rdma/hfi1/ud.c
index bd1b402..25e6053 100644
--- a/drivers/staging/rdma/hfi1/ud.c
+++ b/drivers/staging/rdma/hfi1/ud.c
@@ -671,7 +671,7 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 	if (unlikely(bth1 & HFI1_BECN_SMASK)) {
 		/*
 		 * In pre-B0 h/w the CNP_OPCODE is handled via an
-		 * error path (errata 291394).
+		 * error path.
 		 */
 		struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
 		u32 lqpn =  be32_to_cpu(ohdr->bth[1]) & HFI1_QPN_MASK;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
