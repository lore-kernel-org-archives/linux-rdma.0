From: Jubin John <jubin.john@intel.com>
Subject: [PATCH 09/18] staging/rdma/hfi1: Correctly limit VLs against SDMA
 engines
Date: Fri, 13 Nov 2015 19:37:07 -0800
Message-ID: <1447472236-622-9-git-send-email-jubin.john@intel.com>
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

Correctly reduce the number of VLs when limited by the number
of SDMA engines.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dean Luick <dean.luick@intel.com>
Signed-off-by: Jubin John <jubin.john@intel.com>
---
 drivers/staging/rdma/hfi1/chip.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index f1ee644..b0c1e2b 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -10574,9 +10574,9 @@ struct hfi1_devdata *hfi1_init_dd(struct pci_dev *pdev,
 	/* insure num_vls isn't larger than number of sdma engines */
 	if (HFI1_CAP_IS_KSET(SDMA) && num_vls > dd->chip_sdma_engines) {
 		dd_dev_err(dd, "num_vls %u too large, using %u VLs\n",
-				num_vls, HFI1_MAX_VLS_SUPPORTED);
-		ppd->vls_supported = num_vls = HFI1_MAX_VLS_SUPPORTED;
-		ppd->vls_operational = ppd->vls_supported;
+			   num_vls, dd->chip_sdma_engines);
+		num_vls = dd->chip_sdma_engines;
+		ppd->vls_supported = dd->chip_sdma_engines;
 	}
 
 	/*
-- 
1.7.0.7
