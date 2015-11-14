From: Jubin John <jubin.john@intel.com>
Subject: [PATCH 11/18] staging/rdma/hfi1: Destroy workqueues if
 hfi1_register_ib_device() call returns error
Date: Fri, 13 Nov 2015 19:37:09 -0800
Message-ID: <1447472236-622-11-git-send-email-jubin.john@intel.com>
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

Currently, if hfi1_register_ib_device() call is unsuccessful, workqueues
are not being destroyed before bailing out. This patch fixes this issue.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Harish Chegondi <harish.chegondi@intel.com>
Signed-off-by: Jubin John <jubin.john@intel.com>
---
 drivers/staging/rdma/hfi1/init.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index 47a1202..54b2a4f 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -1308,6 +1308,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	int ret = 0, j, pidx, initfail;
 	struct hfi1_devdata *dd = NULL;
+	struct hfi1_pportdata *ppd;
 
 	/* First, lock the non-writable module parameters */
 	HFI1_CAP_LOCK();
@@ -1403,8 +1404,14 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (initfail || ret) {
 		stop_timers(dd);
 		flush_workqueue(ib_wq);
-		for (pidx = 0; pidx < dd->num_pports; ++pidx)
+		for (pidx = 0; pidx < dd->num_pports; ++pidx) {
 			hfi1_quiet_serdes(dd->pport + pidx);
+			ppd = dd->pport + pidx;
+			if (ppd->hfi1_wq) {
+				destroy_workqueue(ppd->hfi1_wq);
+				ppd->hfi1_wq = NULL;
+			}
+		}
 		if (!j)
 			hfi1_device_remove(dd);
 		if (!ret)
-- 
1.7.0.7
