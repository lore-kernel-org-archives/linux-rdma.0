From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 3/3] IB/umad: Fix a use-after-free
Date: Mon, 12 May 2014 10:31:13 +0200
Message-ID: <537086D1.8010209@acm.org>
References: <53708666.6060209@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53708666.6060209-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Alex Chiang <achiang-VXdhtT5mjnY@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
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
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
---
 drivers/infiniband/core/user_mad.c | 37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 5c67d80..7bec4ca 100644
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
@@ -783,7 +787,7 @@ static int ib_umad_open(struct inode *inode, struct file *filp)
 	int ret = -ENXIO;
 
 	port = container_of(inode->i_cdev, struct ib_umad_port, cdev);
-	kref_get(&port->umad_dev->ref);
+	kobject_get(&port->umad_dev->kobj);
 
 	mutex_lock(&port->file_mutex);
 
@@ -812,7 +816,7 @@ out:
 	mutex_unlock(&port->file_mutex);
 
 	if (ret)
-		kref_put(&port->umad_dev->ref, ib_umad_release_dev);
+		kobject_put(&port->umad_dev->kobj);
 
 	return ret;
 }
@@ -849,7 +853,7 @@ static int ib_umad_close(struct inode *inode, struct file *filp)
 	mutex_unlock(&file->port->file_mutex);
 
 	kfree(file);
-	kref_put(&dev->ref, ib_umad_release_dev);
+	kobject_put(&dev->kobj);
 
 	return 0;
 }
@@ -877,7 +881,7 @@ static int ib_umad_sm_open(struct inode *inode, struct file *filp)
 	int ret;
 
 	port = container_of(inode->i_cdev, struct ib_umad_port, sm_cdev);
-	kref_get(&port->umad_dev->ref);
+	kobject_get(&port->umad_dev->kobj);
 
 	if (filp->f_flags & O_NONBLOCK) {
 		if (down_trylock(&port->sm_sem)) {
@@ -903,7 +907,7 @@ static int ib_umad_sm_open(struct inode *inode, struct file *filp)
 
 fail:
 	if (ret)
-		kref_put(&port->umad_dev->ref, ib_umad_release_dev);
+		kobject_put(&port->umad_dev->kobj);
 	return ret;
 
 clr_sm_cap:
@@ -930,7 +934,7 @@ static int ib_umad_sm_close(struct inode *inode, struct file *filp)
 
 	up(&port->sm_sem);
 
-	kref_put(&port->umad_dev->ref, ib_umad_release_dev);
+	kobject_put(&port->umad_dev->kobj);
 
 	return ret;
 }
@@ -998,6 +1002,7 @@ static int find_overflow_devnum(void)
 }
 
 static int ib_umad_init_port(struct ib_device *device, int port_num,
+			     struct ib_umad_device *umad_dev,
 			     struct ib_umad_port *port)
 {
 	int devnum;
@@ -1063,6 +1068,11 @@ static int ib_umad_init_port(struct ib_device *device, int port_num,
 	if (device_create_file(port->sm_dev, &dev_attr_port))
 		goto err_sm_dev;
 
+	port->cdev.kobj.parent = &umad_dev->kobj;
+	kobject_get(&umad_dev->kobj);
+	port->sm_cdev.kobj.parent = &umad_dev->kobj;
+	kobject_get(&umad_dev->kobj);
+
 	return 0;
 
 err_sm_dev:
@@ -1141,7 +1151,7 @@ static void ib_umad_add_one(struct ib_device *device)
 	if (!umad_dev)
 		return;
 
-	kref_init(&umad_dev->ref);
+	kobject_init(&umad_dev->kobj, &ib_umad_dev_ktype);
 
 	umad_dev->start_port = s;
 	umad_dev->end_port   = e;
@@ -1149,7 +1159,8 @@ static void ib_umad_add_one(struct ib_device *device)
 	for (i = s; i <= e; ++i) {
 		umad_dev->port[i - s].umad_dev = umad_dev;
 
-		if (ib_umad_init_port(device, i, &umad_dev->port[i - s]))
+		if (ib_umad_init_port(device, i, umad_dev,
+				      &umad_dev->port[i - s]))
 			goto err;
 	}
 
@@ -1161,7 +1172,7 @@ err:
 	while (--i >= s)
 		ib_umad_kill_port(&umad_dev->port[i - s]);
 
-	kref_put(&umad_dev->ref, ib_umad_release_dev);
+	kobject_put(&umad_dev->kobj);
 }
 
 static void ib_umad_remove_one(struct ib_device *device)
@@ -1175,7 +1186,7 @@ static void ib_umad_remove_one(struct ib_device *device)
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
