From: Jubin John <jubin.john@intel.com>
Subject: [PATCH 15/18] staging/rdma/hfi1: Consider VL15 MTU also when
 calculating the maximum VL MTU
Date: Fri, 13 Nov 2015 19:37:13 -0800
Message-ID: <1447472236-622-15-git-send-email-jubin.john@intel.com>
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

From: Harish Chegondi <harish.chegondi@intel.com>

Currently, only MTUs of VLs 0-7 are checked when calculating the maximum VL
MTU which is used to set the port MTU capability in DCC_CFG_PORT_CONFIG CSR
This can cause a port MTU capability to be set to 0 if MTUs of VLs 0-7 is 0
This would affect the VL15 traffic.

Reviewed-by: Dean Luick <dean.luick@intel.com>
Reviewed-by: Arthur Kepner <arthur.kepner@intel.com>
Signed-off-by: Harish Chegondi <harish.chegondi@intel.com>
Signed-off-by: Jubin John <jubin.john@intel.com>
---
 drivers/staging/rdma/hfi1/chip.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index f26b9d5..043bfc6 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -9367,7 +9367,8 @@ u32 lrh_max_header_bytes(struct hfi1_devdata *dd)
 static void set_send_length(struct hfi1_pportdata *ppd)
 {
 	struct hfi1_devdata *dd = ppd->dd;
-	u32 max_hb = lrh_max_header_bytes(dd), maxvlmtu = 0, dcmtu;
+	u32 max_hb = lrh_max_header_bytes(dd), dcmtu;
+	u32 maxvlmtu = dd->vld[15].mtu;
 	u64 len1 = 0, len2 = (((dd->vld[15].mtu + max_hb) >> 2)
 			      & SEND_LEN_CHECK1_LEN_VL15_MASK) <<
 		SEND_LEN_CHECK1_LEN_VL15_SHIFT;
-- 
1.7.0.7
