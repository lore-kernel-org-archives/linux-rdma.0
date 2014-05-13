From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH v2 2/2] IB/umad: Fix a use-after-free
Date: Tue, 13 May 2014 12:31:52 +0200
Message-ID: <5371F498.6010101@acm.org>
References: <5371F430.5010109@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5371F430.5010109-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Alex Chiang <achiang-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Avoid that closing /dev/infiniband/umad<n> or /dev/infiniband/issm<n>
triggers a use-after-free. __fput() in fs/file_table.c invokes
f_op->release() before it invokes cdev_put(). Make sure that the
ib_umad_device structure is freed by the cdev_put() call instead of
f_op->release(). This avoids that changing the port mode from IB into
Ethernet and back to IB followed by restarting opensmd triggers the
following kernel oops:

general protection fault: 0000 [#1] PREEMPT SMP
RIP: 0010:[<ffffffff810cc65c>]  [<ffffffff810cc65c>] module_put+0x2c/0x170
Call Trace:
 [<ffffffff81190f20>] cdev_put+0x20/0x30
 [<ffffffff8118e2ce>] __fput+0x1ae/0x1f0
 [<ffffffff8118e35e>] ____fput+0xe/0x10
 [<ffffffff810723bc>] task_work_run+0xac/0xe0
 [<ffffffff81002a9f>] do_notify_resume+0x9f/0xc0
 [<ffffffff814b8398>] int_signal+0x12/0x17

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=75051
Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Alex Chiang <achiang-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
---
 drivers/infiniband/core/user_mad.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 2b3dfcc..93d0823 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -98,7 +98,7 @@ struct ib_umad_port {
 
 struct ib_umad_device {
 	int                  start_port, end_port;
-	struct kref          ref;
+	struct kobject       kobj;
 	struct ib_umad_port  port[0];
 };
 
@@ -134,14 +134,18 @@ static DECLARE_BITMAP(dev_map, IB_UMAD_MAX_PORTS);
 static void ib_umad_add_one(struct ib_device *device);
 static void ib_umad_remove_one(struct ib_device *device);
 
-static void ib_umad_release_dev(struct kref *ref)
+static void ib_umad_release_dev(struct kobject *kobj)
 {
 	struct ib_umad_device *dev =
-		container_of(ref, struct ib_umad_device, ref);
+		container_of(kobj, struct ib_umad_device, kobj);
 
 	kfree(dev);
 }
 
+static struct kobj_type ib_umad_dev_ktype = {
+	.release = ib_umad_release_dev,
+};
+
 static int hdr_size(struct ib_umad_file *file)
 {
 	return file->use_pkey_index ? sizeof (struct ib_user_mad_hdr) :
@@ -810,7 +814,7 @@ static int ib_umad_open(struct inode *inode, struct file *filp)
 	if (ret)
 		goto del;
 
-	kref_get(&port->umad_dev->ref);
+	kobject_get(&port->umad_dev->kobj);
 
 out:
 	mutex_unlock(&port->file_mutex);
@@ -855,7 +859,7 @@ static int ib_umad_close(struct inode *inode, struct file *filp)
 	mutex_unlock(&file->port->file_mutex);
 
 	kfree(file);
-	kref_put(&dev->ref, ib_umad_release_dev);
+	kobject_put(&dev->kobj);
 
 	return 0;
 }
@@ -906,7 +910,7 @@ static int ib_umad_sm_open(struct inode *inode, struct file *filp)
 	if (ret)
 		goto clr_sm_cap;
 
-	kref_get(&port->umad_dev->ref);
+	kobject_get(&port->umad_dev->kobj);
 
 out:
 	return ret;
@@ -935,7 +939,7 @@ static int ib_umad_sm_close(struct inode *inode, struct file *filp)
 
 	up(&port->sm_sem);
 
-	kref_put(&port->umad_dev->ref, ib_umad_release_dev);
+	kobject_put(&port->umad_dev->kobj);
 
 	return ret;
 }
@@ -1003,6 +1007,7 @@ static int find_overflow_devnum(void)
 }
 
 static int ib_umad_init_port(struct ib_device *device, int port_num,
+			     struct ib_umad_device *umad_dev,
 			     struct ib_umad_port *port)
 {
 	int devnum;
@@ -1068,6 +1073,11 @@ static int ib_umad_init_port(struct ib_device *device, int port_num,
 	if (device_create_file(port->sm_dev, &dev_attr_port))
 		goto err_sm_dev;
 
+	port->cdev.kobj.parent = &umad_dev->kobj;
+	kobject_get(&umad_dev->kobj);
+	port->sm_cdev.kobj.parent = &umad_dev->kobj;
+	kobject_get(&umad_dev->kobj);
+
 	return 0;
 
 err_sm_dev:
@@ -1146,7 +1156,7 @@ static void ib_umad_add_one(struct ib_device *device)
 	if (!umad_dev)
 		return;
 
-	kref_init(&umad_dev->ref);
+	kobject_init(&umad_dev->kobj, &ib_umad_dev_ktype);
 
 	umad_dev->start_port = s;
 	umad_dev->end_port   = e;
@@ -1154,7 +1164,8 @@ static void ib_umad_add_one(struct ib_device *device)
 	for (i = s; i <= e; ++i) {
 		umad_dev->port[i - s].umad_dev = umad_dev;
 
-		if (ib_umad_init_port(device, i, &umad_dev->port[i - s]))
+		if (ib_umad_init_port(device, i, umad_dev,
+				      &umad_dev->port[i - s]))
 			goto err;
 	}
 
@@ -1166,7 +1177,7 @@ err:
 	while (--i >= s)
 		ib_umad_kill_port(&umad_dev->port[i - s]);
 
-	kref_put(&umad_dev->ref, ib_umad_release_dev);
+	kobject_put(&umad_dev->kobj);
 }
 
 static void ib_umad_remove_one(struct ib_device *device)
@@ -1180,7 +1191,7 @@ static void ib_umad_remove_one(struct ib_device *device)
 	for (i = 0; i <= umad_dev->end_port - umad_dev->start_port; ++i)
 		ib_umad_kill_port(&umad_dev->port[i]);
 
-	kref_put(&umad_dev->ref, ib_umad_release_dev);
+	kobject_put(&umad_dev->kobj);
 }
 
 static char *umad_devnode(struct device *dev, umode_t *mode)
-- 
1.8.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
