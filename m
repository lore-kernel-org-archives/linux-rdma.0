From: ira.weiny@intel.com
Subject: [PATCH 7/8] staging/rdma/hfi1: Reduce snoop locking scope in IOCTL
 handler.
Date: Wed, 11 Nov 2015 00:43:08 -0500
Message-ID: <1447220589-9067-8-git-send-email-ira.weiny@intel.com>
References: <1447220589-9067-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1447220589-9067-1-git-send-email-ira.weiny@intel.com>
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
Cc: linux-rdma@vger.kernel.org, dledford@redhat.com, dennis.dalessandro@intel.com
List-Id: linux-rdma@vger.kernel.org

From: Dennis Dalessandro <dennis.dalessandro@intel.com>

This patch avoids issues while calling into copy from/to user while holding the
lock by only taking the lock when it is absolutely required.

The only commands which require the snoop lock are: *Set Filter *Clear Filter
*Clear Queue

Reported-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/staging/rdma/hfi1/diag.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/diag.c b/drivers/staging/rdma/hfi1/diag.c
index 43f08080480c..34a8c4da71d2 100644
--- a/drivers/staging/rdma/hfi1/diag.c
+++ b/drivers/staging/rdma/hfi1/diag.c
@@ -1008,8 +1008,6 @@ static long hfi1_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 		/* We do not support the old setlink state */
 		return -EINVAL;
 
-	spin_lock_irqsave(&dd->hfi1_snoop.snoop_lock, flags);
-
 	switch (cmd) {
 	case HFI1_SNOOP_IOCSETLINKSTATE_EXTRA:
 		memset(&link_info, 0, sizeof(link_info));
@@ -1125,11 +1123,14 @@ static long hfi1_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 
 	case HFI1_SNOOP_IOCCLEARQUEUE:
 		snoop_dbg("Clearing snoop queue");
+		spin_lock_irqsave(&dd->hfi1_snoop.snoop_lock, flags);
 		drain_snoop_list(&dd->hfi1_snoop.queue);
+		spin_unlock_irqrestore(&dd->hfi1_snoop.snoop_lock, flags);
 		break;
 
 	case HFI1_SNOOP_IOCCLEARFILTER:
 		snoop_dbg("Clearing filter");
+		spin_lock_irqsave(&dd->hfi1_snoop.snoop_lock, flags);
 		if (dd->hfi1_snoop.filter_callback) {
 			/* Drain packets first */
 			drain_snoop_list(&dd->hfi1_snoop.queue);
@@ -1137,6 +1138,7 @@ static long hfi1_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 		}
 		kfree(dd->hfi1_snoop.filter_value);
 		dd->hfi1_snoop.filter_value = NULL;
+		spin_unlock_irqrestore(&dd->hfi1_snoop.snoop_lock, flags);
 		break;
 
 	case HFI1_SNOOP_IOCSETFILTER:
@@ -1173,13 +1175,14 @@ static long hfi1_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 			break;
 		}
 		/* Drain packets first */
+		spin_lock_irqsave(&dd->hfi1_snoop.snoop_lock, flags);
 		drain_snoop_list(&dd->hfi1_snoop.queue);
 		dd->hfi1_snoop.filter_callback =
 			hfi1_filters[filter_cmd.opcode].filter;
 		/* just in case we see back to back sets */
 		kfree(dd->hfi1_snoop.filter_value);
 		dd->hfi1_snoop.filter_value = filter_value;
-
+		spin_unlock_irqrestore(&dd->hfi1_snoop.snoop_lock, flags);
 		break;
 	case HFI1_SNOOP_IOCGETVERSION:
 		value = SNOOP_CAPTURE_VERSION;
@@ -1203,7 +1206,6 @@ static long hfi1_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 		break;
 	}
 
-	spin_unlock_irqrestore(&dd->hfi1_snoop.snoop_lock, flags);
 	return ret;
 }
 
-- 
1.8.2
