From: Jubin John <jubin.john@intel.com>
Subject: [PATCH 13/18] staging/rdma/hfi1: remove SPC freeze error messages
Date: Fri, 13 Nov 2015 19:37:11 -0800
Message-ID: <1447472236-622-13-git-send-email-jubin.john@intel.com>
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

An SPC freeze is not an error.  Remove the messages.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Dean Luick <dean.luick@intel.com>
Signed-off-by: Jubin John <jubin.john@intel.com>
---
 drivers/staging/rdma/hfi1/chip.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index a62a538..2ac145f 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -6496,7 +6496,6 @@ void handle_freeze(struct work_struct *work)
 	struct hfi1_devdata *dd = ppd->dd;
 
 	/* wait for freeze indicators on all affected blocks */
-	dd_dev_info(dd, "Entering SPC freeze\n");
 	wait_for_freeze_status(dd, 1);
 
 	/* SPC is now frozen */
@@ -6554,7 +6553,6 @@ void handle_freeze(struct work_struct *work)
 	wake_up(&dd->event_queue);
 
 	/* no longer frozen */
-	dd_dev_err(dd, "Exiting SPC freeze\n");
 }
 
 /*
-- 
1.7.0.7
