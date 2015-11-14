From: Jubin John <jubin.john@intel.com>
Subject: [PATCH 12/18] staging/rdma/hfi1: Unexpected link up pkey values are
 not an error
Date: Fri, 13 Nov 2015 19:37:10 -0800
Message-ID: <1447472236-622-12-git-send-email-jubin.john@intel.com>
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

From: Dean Luick <dean.luick@intel.com>

Only warn when link up pkeys are not what we expect.  Also, allow
for the pkey to already be initialized.

Reviewed-by: Arthur Kepner <arthur.kepner@intel.com>
Signed-off-by: Dean Luick <dean.luick@intel.com>
Signed-off-by: Jubin John <jubin.john@intel.com>
---
 drivers/staging/rdma/hfi1/chip.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index c83f360..a62a538 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -6725,10 +6725,10 @@ static void add_full_mgmt_pkey(struct hfi1_pportdata *ppd)
 {
 	struct hfi1_devdata *dd = ppd->dd;
 
-	/* Sanity check - ppd->pkeys[2] should be 0 */
-	if (ppd->pkeys[2] != 0)
-		dd_dev_err(dd, "%s pkey[2] already set to 0x%x, resetting it to 0x%x\n",
-			   __func__, ppd->pkeys[2], FULL_MGMT_P_KEY);
+	/* Sanity check - ppd->pkeys[2] should be 0, or already initalized */
+	if (!((ppd->pkeys[2] == 0) || (ppd->pkeys[2] == FULL_MGMT_P_KEY)))
+		dd_dev_warn(dd, "%s pkey[2] already set to 0x%x, resetting it to 0x%x\n",
+			    __func__, ppd->pkeys[2], FULL_MGMT_P_KEY);
 	ppd->pkeys[2] = FULL_MGMT_P_KEY;
 	(void)hfi1_set_ib_cfg(ppd, HFI1_IB_CFG_PKEYS, 0);
 }
-- 
1.7.0.7
