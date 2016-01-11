From: ira.weiny@intel.com
Subject: [RESUBMIT PATCH v2 02/14] uapi/rdma/hfi/hfi1_user.h: Correct comment
 for capability bit
Date: Mon, 11 Jan 2016 12:56:38 -0500
Message-ID: <1452535010-14087-3-git-send-email-ira.weiny@intel.com>
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

The HFI1_CAP_TID_UNMAP comment was incorrectly implying the
opposite of what capability actually did. Correct this error.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Mitko Haralanov <mitko.haralanov@intel.com>
---
 include/uapi/rdma/hfi/hfi1_user.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/rdma/hfi/hfi1_user.h b/include/uapi/rdma/hfi/hfi1_user.h
index 288694e422fb..cf172718e3d5 100644
--- a/include/uapi/rdma/hfi/hfi1_user.h
+++ b/include/uapi/rdma/hfi/hfi1_user.h
@@ -93,7 +93,7 @@
 #define HFI1_CAP_MULTI_PKT_EGR    (1UL <<  7) /* Enable multi-packet Egr buffs*/
 #define HFI1_CAP_NODROP_RHQ_FULL  (1UL <<  8) /* Don't drop on Hdr Q full */
 #define HFI1_CAP_NODROP_EGR_FULL  (1UL <<  9) /* Don't drop on EGR buffs full */
-#define HFI1_CAP_TID_UNMAP        (1UL << 10) /* Enable Expected TID caching */
+#define HFI1_CAP_TID_UNMAP        (1UL << 10) /* Disable Expected TID caching */
 #define HFI1_CAP_PRINT_UNIMPL     (1UL << 11) /* Show for unimplemented feats */
 #define HFI1_CAP_ALLOW_PERM_JKEY  (1UL << 12) /* Allow use of permissive JKEY */
 #define HFI1_CAP_NO_INTEGRITY     (1UL << 13) /* Enable ctxt integrity checks */
-- 
1.8.2
