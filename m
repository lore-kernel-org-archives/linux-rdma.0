From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH RFC 1/2] driver core: allow EPROBE_DEFER after boot
Date: Mon, 06 Feb 2017 11:15:28 -0800
Message-ID: <148640852878.13713.11121939459524566022.stgit@tstruk-mobl1.ra.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org
Cc: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Currently EPROBE_DEFER error code is only honored by the core during
boot time, where the deferred probes are triggered by the late_initcall.
After boot, if a driver returns EPROBE_DEFER for whatever reason, during
manual insmod, it is not handled, as there is nothing to trigger the
driver_deferred_probe_trigger() function.
This change allow drivers to be re-probed after boot.
The deferred_trigger_count counter is not needed as the
driver_deferred_probe_trigger() is safe to call multiple times.
There is also a warning added, which warns if drivers would try to abuse
EPROBE_DEFER causing the core to busy loop.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/base/dd.c      |   26 +++++++++-----------------
 drivers/base/driver.c  |    2 +-
 include/linux/device.h |    2 ++
 3 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index a1fbf55..dfee412 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -51,7 +51,6 @@
 static DEFINE_MUTEX(deferred_probe_mutex);
 static LIST_HEAD(deferred_probe_pending_list);
 static LIST_HEAD(deferred_probe_active_list);
-static atomic_t deferred_trigger_count = ATOMIC_INIT(0);
 
 /*
  * In some cases, like suspend to RAM or hibernation, It might be reasonable
@@ -142,17 +141,6 @@ static bool driver_deferred_probe_enable = false;
  * This functions moves all devices from the pending list to the active
  * list and schedules the deferred probe workqueue to process them.  It
  * should be called anytime a driver is successfully bound to a device.
- *
- * Note, there is a race condition in multi-threaded probe. In the case where
- * more than one device is probing at the same time, it is possible for one
- * probe to complete successfully while another is about to defer. If the second
- * depends on the first, then it will get put on the pending list after the
- * trigger event has already occurred and will be stuck there.
- *
- * The atomic 'deferred_trigger_count' is used to determine if a successful
- * trigger has occurred in the midst of probing a driver. If the trigger count
- * changes in the midst of a probe, then deferred processing should be triggered
- * again.
  */
 static void driver_deferred_probe_trigger(void)
 {
@@ -165,7 +153,6 @@ static void driver_deferred_probe_trigger(void)
 	 * into the active list so they can be retried by the workqueue
 	 */
 	mutex_lock(&deferred_probe_mutex);
-	atomic_inc(&deferred_trigger_count);
 	list_splice_tail_init(&deferred_probe_pending_list,
 			      &deferred_probe_active_list);
 	mutex_unlock(&deferred_probe_mutex);
@@ -324,7 +311,6 @@ static DECLARE_WAIT_QUEUE_HEAD(probe_waitqueue);
 static int really_probe(struct device *dev, struct device_driver *drv)
 {
 	int ret = -EPROBE_DEFER;
-	int local_trigger_count = atomic_read(&deferred_trigger_count);
 	bool test_remove = IS_ENABLED(CONFIG_DEBUG_TEST_DRIVER_REMOVE) &&
 			   !drv->suppress_bind_attrs;
 
@@ -384,6 +370,8 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 		ret = drv->probe(dev);
 		if (ret)
 			goto probe_failed;
+		else
+			atomic_set(&drv->deferred_probe_ctr, 0);
 	}
 
 	if (test_remove) {
@@ -435,9 +423,13 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 		/* Driver requested deferred probing */
 		dev_dbg(dev, "Driver %s requests probe deferral\n", drv->name);
 		driver_deferred_probe_add(dev);
-		/* Did a trigger occur while probing? Need to re-trigger if yes */
-		if (local_trigger_count != atomic_read(&deferred_trigger_count))
-			driver_deferred_probe_trigger();
+		/* Need to re-trigger, but prevent busy looping */
+		if (atomic_add_return(1, &drv->deferred_probe_ctr) % 10 == 0) {
+			dev_warn(dev, "Driver %s loops on probe deferred\n",
+				 drv->name);
+			msleep(1000);
+		}
+		driver_deferred_probe_trigger();
 		break;
 	case -ENODEV:
 	case -ENXIO:
diff --git a/drivers/base/driver.c b/drivers/base/driver.c
index 4eabfe2..afbd84de 100644
--- a/drivers/base/driver.c
+++ b/drivers/base/driver.c
@@ -174,7 +174,7 @@ int driver_register(struct device_driver *drv)
 		return ret;
 	}
 	kobject_uevent(&drv->p->kobj, KOBJ_ADD);
-
+	atomic_set(&drv->deferred_probe_ctr, 0);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(driver_register);
diff --git a/include/linux/device.h b/include/linux/device.h
index 491b4c0c..2992fde 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -284,6 +284,8 @@ struct device_driver {
 	const struct dev_pm_ops *pm;
 
 	struct driver_private *p;
+
+	atomic_t deferred_probe_ctr;
 };
 
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
