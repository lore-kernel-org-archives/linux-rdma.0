From: ira.weiny@intel.com
Subject: [RESUBMIT PATCH v2 03/14] uapi/rdma/hfi/hfi1_user.h: Convert
 definitions to use BIT() macro
Date: Mon, 11 Jan 2016 12:56:39 -0500
Message-ID: <1452535010-14087-4-git-send-email-ira.weiny@intel.com>
References: <1452535010-14087-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1452535010-14087-1-git-send-email-ira.weiny@intel.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: dledford@redhat.com, linux-rdma@vger.kernel.org
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org, Mitko Haralanov <mitko.haralanov@intel.com>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov@intel.com>

Convert bit definitions to use BIT() macro as per checkpatch.pl
requirements.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Mitko Haralanov <mitko.haralanov@intel.com>
---
 include/uapi/rdma/hfi/hfi1_user.h | 56 +++++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/include/uapi/rdma/hfi/hfi1_user.h b/include/uapi/rdma/hfi/hfi1_user.h
index cf172718e3d5..a65f2fe17660 100644
--- a/include/uapi/rdma/hfi/hfi1_user.h
+++ b/include/uapi/rdma/hfi/hfi1_user.h
@@ -83,29 +83,29 @@
  * driver features. The same set of bits are communicated to user
  * space.
  */
-#define HFI1_CAP_DMA_RTAIL        (1UL <<  0) /* Use DMA'ed RTail value */
-#define HFI1_CAP_SDMA             (1UL <<  1) /* Enable SDMA support */
-#define HFI1_CAP_SDMA_AHG         (1UL <<  2) /* Enable SDMA AHG support */
-#define HFI1_CAP_EXTENDED_PSN     (1UL <<  3) /* Enable Extended PSN support */
-#define HFI1_CAP_HDRSUPP          (1UL <<  4) /* Enable Header Suppression */
-/* 1UL << 5 unused */
-#define HFI1_CAP_USE_SDMA_HEAD    (1UL <<  6) /* DMA Hdr Q tail vs. use CSR */
-#define HFI1_CAP_MULTI_PKT_EGR    (1UL <<  7) /* Enable multi-packet Egr buffs*/
-#define HFI1_CAP_NODROP_RHQ_FULL  (1UL <<  8) /* Don't drop on Hdr Q full */
-#define HFI1_CAP_NODROP_EGR_FULL  (1UL <<  9) /* Don't drop on EGR buffs full */
-#define HFI1_CAP_TID_UNMAP        (1UL << 10) /* Disable Expected TID caching */
-#define HFI1_CAP_PRINT_UNIMPL     (1UL << 11) /* Show for unimplemented feats */
-#define HFI1_CAP_ALLOW_PERM_JKEY  (1UL << 12) /* Allow use of permissive JKEY */
-#define HFI1_CAP_NO_INTEGRITY     (1UL << 13) /* Enable ctxt integrity checks */
-#define HFI1_CAP_PKEY_CHECK       (1UL << 14) /* Enable ctxt PKey checking */
-#define HFI1_CAP_STATIC_RATE_CTRL (1UL << 15) /* Allow PBC.StaticRateControl */
-/* 1UL << 16 unused */
-#define HFI1_CAP_SDMA_HEAD_CHECK  (1UL << 17) /* SDMA head checking */
-#define HFI1_CAP_EARLY_CREDIT_RETURN (1UL << 18) /* early credit return */
-
-#define HFI1_RCVHDR_ENTSIZE_2    (1UL << 0)
-#define HFI1_RCVHDR_ENTSIZE_16   (1UL << 1)
-#define HFI1_RCVDHR_ENTSIZE_32   (1UL << 2)
+#define HFI1_CAP_DMA_RTAIL        BIT(0) /* Use DMA'ed RTail value */
+#define HFI1_CAP_SDMA             BIT(1) /* Enable SDMA support */
+#define HFI1_CAP_SDMA_AHG         BIT(2) /* Enable SDMA AHG support */
+#define HFI1_CAP_EXTENDED_PSN     BIT(3) /* Enable Extended PSN support */
+#define HFI1_CAP_HDRSUPP          BIT(4) /* Enable Header Suppression */
+/* BIT(5) unused */
+#define HFI1_CAP_USE_SDMA_HEAD    BIT(6) /* DMA Hdr Q tail vs. use CSR */
+#define HFI1_CAP_MULTI_PKT_EGR    BIT(7) /* Enable multi-packet Egr buffs*/
+#define HFI1_CAP_NODROP_RHQ_FULL  BIT(8) /* Don't drop on Hdr Q full */
+#define HFI1_CAP_NODROP_EGR_FULL  BIT(9) /* Don't drop on EGR buffs full */
+#define HFI1_CAP_TID_UNMAP        BIT(10) /* Disable Expected TID caching */
+#define HFI1_CAP_PRINT_UNIMPL     BIT(11) /* Show for unimplemented feats */
+#define HFI1_CAP_ALLOW_PERM_JKEY  BIT(12) /* Allow use of permissive JKEY */
+#define HFI1_CAP_NO_INTEGRITY     BIT(13) /* Enable ctxt integrity checks */
+#define HFI1_CAP_PKEY_CHECK       BIT(14) /* Enable ctxt PKey checking */
+#define HFI1_CAP_STATIC_RATE_CTRL BIT(15) /* Allow PBC.StaticRateControl */
+/* BIT(16) unused */
+#define HFI1_CAP_SDMA_HEAD_CHECK  BIT(17) /* SDMA head checking */
+#define HFI1_CAP_EARLY_CREDIT_RETURN BIT(18) /* early credit return */
+
+#define HFI1_RCVHDR_ENTSIZE_2    BIT(0)
+#define HFI1_RCVHDR_ENTSIZE_16   BIT(1)
+#define HFI1_RCVDHR_ENTSIZE_32   BIT(2)
 
 /*
  * If the unit is specified via open, HFI choice is fixed.  If port is
@@ -149,11 +149,11 @@
 #define _HFI1_EVENT_SL2VL_CHANGE_BIT   4
 #define _HFI1_MAX_EVENT_BIT _HFI1_EVENT_SL2VL_CHANGE_BIT
 
-#define HFI1_EVENT_FROZEN            (1UL << _HFI1_EVENT_FROZEN_BIT)
-#define HFI1_EVENT_LINKDOWN          (1UL << _HFI1_EVENT_LINKDOWN_BIT)
-#define HFI1_EVENT_LID_CHANGE        (1UL << _HFI1_EVENT_LID_CHANGE_BIT)
-#define HFI1_EVENT_LMC_CHANGE        (1UL << _HFI1_EVENT_LMC_CHANGE_BIT)
-#define HFI1_EVENT_SL2VL_CHANGE      (1UL << _HFI1_EVENT_SL2VL_CHANGE_BIT)
+#define HFI1_EVENT_FROZEN            BIT(_HFI1_EVENT_FROZEN_BIT)
+#define HFI1_EVENT_LINKDOWN          BIT(_HFI1_EVENT_LINKDOWN_BIT)
+#define HFI1_EVENT_LID_CHANGE        BIT(_HFI1_EVENT_LID_CHANGE_BIT)
+#define HFI1_EVENT_LMC_CHANGE        BIT(_HFI1_EVENT_LMC_CHANGE_BIT)
+#define HFI1_EVENT_SL2VL_CHANGE      BIT(_HFI1_EVENT_SL2VL_CHANGE_BIT)
 
 /*
  * These are the status bits readable (in ASCII form, 64bit value)
-- 
1.8.2
