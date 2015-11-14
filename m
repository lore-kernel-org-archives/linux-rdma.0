From: Jubin John <jubin.john@intel.com>
Subject: [PATCH 05/18] staging/rdma/hfi1: Clean up comments
Date: Fri, 13 Nov 2015 19:37:03 -0800
Message-ID: <1447472236-622-5-git-send-email-jubin.john@intel.com>
References: <1447472236-622-1-git-send-email-jubin.john@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1447472236-622-1-git-send-email-jubin.john@intel.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org
Cc: linux-rdma@vger.kernel.org, dledford@redhat.com
List-Id: linux-rdma@vger.kernel.org

From: Edward Mascarenhas <edward.mascarenhas@intel.com>

Clean up comments

Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Edward Mascarenhas <edward.mascarenhas@intel.com>
Signed-off-by: Jubin John <jubin.john@intel.com>
---
 drivers/staging/rdma/hfi1/chip.c   |    1 -
 drivers/staging/rdma/hfi1/driver.c |    2 +-
 drivers/staging/rdma/hfi1/hfi.h    |    4 ++--
 drivers/staging/rdma/hfi1/pcie.c   |    2 +-
 drivers/staging/rdma/hfi1/ud.c     |    2 +-
 5 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index e489819..a5b3653 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -10274,7 +10274,6 @@ int hfi1_set_ctxt_jkey(struct hfi1_devdata *dd, unsigned ctxt, u16 jkey)
 	write_kctxt_csr(dd, sctxt, SEND_CTXT_CHECK_JOB_KEY, reg);
 	/*
 	 * Enable send-side J_KEY integrity check, unless this is A0 h/w
-	 * (due to A0 erratum).
 	 */
 	if (!is_a0(dd)) {
 		reg = read_kctxt_csr(dd, sctxt, SEND_CTXT_CHECK_ENABLE);
diff --git a/drivers/staging/rdma/hfi1/driver.c b/drivers/staging/rdma/hfi1/driver.c
index ce69141..9e58662 100644
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
index 190f7a2..e7ed319 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -1714,7 +1714,7 @@ static inline u64 hfi1_pkt_default_send_ctxt_mask(struct hfi1_devdata *dd,
 		base_sc_integrity |= HFI1_PKT_KERNEL_SC_INTEGRITY;
 
 	if (is_a0(dd))
-		/* turn off send-side job key checks - A0 erratum */
+		/* turn off send-side job key checks - A0 */
 		return base_sc_integrity &
 		       ~SEND_CTXT_CHECK_ENABLE_CHECK_JOB_KEY_SMASK;
 	return base_sc_integrity;
@@ -1741,7 +1741,7 @@ static inline u64 hfi1_pkt_base_sdma_integrity(struct hfi1_devdata *dd)
 	| SEND_DMA_CHECK_ENABLE_CHECK_ENABLE_SMASK;
 
 	if (is_a0(dd))
-		/* turn off send-side job key checks - A0 erratum */
+		/* turn off send-side job key checks - A0 */
 		return base_sdma_integrity &
 		       ~SEND_DMA_CHECK_ENABLE_CHECK_JOB_KEY_SMASK;
 	return base_sdma_integrity;
diff --git a/drivers/staging/rdma/hfi1/pcie.c b/drivers/staging/rdma/hfi1/pcie.c
index a956044..bfaf137 100644
--- a/drivers/staging/rdma/hfi1/pcie.c
+++ b/drivers/staging/rdma/hfi1/pcie.c
@@ -994,7 +994,7 @@ retry:
 	 * PcieCfgRegPl100 - Gen3 Control
 	 *
 	 * turn off PcieCfgRegPl100.Gen3ZRxDcNonCompl
-	 * turn on PcieCfgRegPl100.EqEieosCnt (erratum)
+	 * turn on PcieCfgRegPl100.EqEieosCnt
 	 * Everything else zero.
 	 */
 	reg32 = PCIE_CFG_REG_PL100_EQ_EIEOS_CNT_SMASK;
diff --git a/drivers/staging/rdma/hfi1/ud.c b/drivers/staging/rdma/hfi1/ud.c
index d40d1a1..c77c11b 100644
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
1.7.0.7
