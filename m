From: ira.weiny@intel.com
Subject: [PATCH v3 05/23] staging/rdma/hfi1: Remove QSFP_ENABLED from HFI
 capability mask
Date: Mon, 26 Oct 2015 10:28:31 -0400
Message-ID: <1445869729-7507-6-git-send-email-ira.weiny@intel.com>
References: <1445869729-7507-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1445869729-7507-1-git-send-email-ira.weiny@intel.com>
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
Cc: linux-rdma@vger.kernel.org, dennis.dalessandro@intel.com, Easwar Hariharan <easwar.hariharan@intel.com>, dledford@redhat.com
List-Id: linux-rdma@vger.kernel.org

From: Easwar Hariharan <easwar.hariharan@intel.com>

The QSFP interface code has been running without issues and the flag is
never set to off. This patch removes the QSFP_ENABLED bit from HFI1_CAP.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Easwar Hariharan <easwar.hariharan@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/staging/rdma/hfi1/chip.c   |  3 +--
 drivers/staging/rdma/hfi1/common.h |  2 --
 drivers/staging/rdma/hfi1/qsfp.c   | 13 ++++---------
 include/uapi/rdma/hfi/hfi1_user.h  |  4 ++--
 4 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 23b8813d044b..aad25b6686ff 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -5716,8 +5716,7 @@ void init_qsfp(struct hfi1_pportdata *ppd)
 	u64 qsfp_mask;
 
 	if (loopback == LOOPBACK_SERDES || loopback == LOOPBACK_LCB ||
-			ppd->dd->icode == ICODE_FUNCTIONAL_SIMULATOR ||
-			!HFI1_CAP_IS_KSET(QSFP_ENABLED)) {
+			ppd->dd->icode == ICODE_FUNCTIONAL_SIMULATOR) {
 		ppd->driver_link_ready = 1;
 		return;
 	}
diff --git a/drivers/staging/rdma/hfi1/common.h b/drivers/staging/rdma/hfi1/common.h
index 5f2293729cf9..de62cbe2224c 100644
--- a/drivers/staging/rdma/hfi1/common.h
+++ b/drivers/staging/rdma/hfi1/common.h
@@ -147,7 +147,6 @@
 				  HFI1_CAP_USE_SDMA_HEAD |		\
 				  HFI1_CAP_EXTENDED_PSN |		\
 				  HFI1_CAP_PRINT_UNIMPL |		\
-				  HFI1_CAP_QSFP_ENABLED |		\
 				  HFI1_CAP_NO_INTEGRITY |		\
 				  HFI1_CAP_PKEY_CHECK) <<		\
 				 HFI1_CAP_USER_SHIFT)
@@ -163,7 +162,6 @@
 				 HFI1_CAP_SDMA |			\
 				 HFI1_CAP_PRINT_UNIMPL |		\
 				 HFI1_CAP_STATIC_RATE_CTRL |		\
-				 HFI1_CAP_QSFP_ENABLED |		\
 				 HFI1_CAP_PKEY_CHECK |			\
 				 HFI1_CAP_MULTI_PKT_EGR |		\
 				 HFI1_CAP_EXTENDED_PSN |		\
diff --git a/drivers/staging/rdma/hfi1/qsfp.c b/drivers/staging/rdma/hfi1/qsfp.c
index 3138936157db..ffdb1d787a80 100644
--- a/drivers/staging/rdma/hfi1/qsfp.c
+++ b/drivers/staging/rdma/hfi1/qsfp.c
@@ -403,16 +403,11 @@ static const char *pwr_codes = "1.5W2.0W2.5W3.5W";
 
 int qsfp_mod_present(struct hfi1_pportdata *ppd)
 {
-	if (HFI1_CAP_IS_KSET(QSFP_ENABLED)) {
-		struct hfi1_devdata *dd = ppd->dd;
-		u64 reg;
+	struct hfi1_devdata *dd = ppd->dd;
+	u64 reg;
 
-		reg = read_csr(dd,
-			dd->hfi1_id ? ASIC_QSFP2_IN : ASIC_QSFP1_IN);
-		return !(reg & QSFP_HFI0_MODPRST_N);
-	}
-	/* always return cable present */
-	return 1;
+	reg = read_csr(dd, dd->hfi1_id ? ASIC_QSFP2_IN : ASIC_QSFP1_IN);
+	return !(reg & QSFP_HFI0_MODPRST_N);
 }
 
 /*
diff --git a/include/uapi/rdma/hfi/hfi1_user.h b/include/uapi/rdma/hfi/hfi1_user.h
index 78c442fbf263..599562fe5d57 100644
--- a/include/uapi/rdma/hfi/hfi1_user.h
+++ b/include/uapi/rdma/hfi/hfi1_user.h
@@ -88,7 +88,7 @@
 #define HFI1_CAP_SDMA_AHG         (1UL <<  2) /* Enable SDMA AHG support */
 #define HFI1_CAP_EXTENDED_PSN     (1UL <<  3) /* Enable Extended PSN support */
 #define HFI1_CAP_HDRSUPP          (1UL <<  4) /* Enable Header Suppression */
-/* 1UL << 5 reserved */
+/* 1UL << 5 unused */
 #define HFI1_CAP_USE_SDMA_HEAD    (1UL <<  6) /* DMA Hdr Q tail vs. use CSR */
 #define HFI1_CAP_MULTI_PKT_EGR    (1UL <<  7) /* Enable multi-packet Egr buffs*/
 #define HFI1_CAP_NODROP_RHQ_FULL  (1UL <<  8) /* Don't drop on Hdr Q full */
@@ -99,7 +99,7 @@
 #define HFI1_CAP_NO_INTEGRITY     (1UL << 13) /* Enable ctxt integrity checks */
 #define HFI1_CAP_PKEY_CHECK       (1UL << 14) /* Enable ctxt PKey checking */
 #define HFI1_CAP_STATIC_RATE_CTRL (1UL << 15) /* Allow PBC.StaticRateControl */
-#define HFI1_CAP_QSFP_ENABLED     (1UL << 16) /* Enable QSFP check during LNI */
+/* 1UL << 16 unused */
 #define HFI1_CAP_SDMA_HEAD_CHECK  (1UL << 17) /* SDMA head checking */
 #define HFI1_CAP_EARLY_CREDIT_RETURN (1UL << 18) /* early credit return */
 
-- 
1.8.2
