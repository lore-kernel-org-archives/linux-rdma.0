From: Alex Chiang <achiang-VXdhtT5mjnY@public.gmane.org>
Subject: [PATCH v2 09/18] IB/umad: remove port_table[]
Date: Tue, 02 Feb 2010 12:08:30 -0700
Message-ID: <20100202190830.28217.54315.stgit@bob.kio>
References: <20100202185235.28217.64521.stgit@bob.kio>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100202185235.28217.64521.stgit-tBlMHHroXgg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, justin.chen-VXdhtT5mjnY@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

We no longer need this data structure, as it was used to associate
an inode back to a struct ib_umad_port during ->open().

But now that we're embedding a struct cdev in struct ib_umad_port,
we can use the container_of() macro to go from the inode back to
the device instead.

Signed-off-by: Alex Chiang <achiang-VXdhtT5mjnY@public.gmane.org>
---

 drivers/infiniband/core/user_mad.c |   45 +++++++-----------------------------
 1 files changed, 9 insertions(+), 36 deletions(-)

diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 40440ef..46c8879 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -65,12 +65,9 @@ enum {
 };
 
 /*
- * Our lifetime rules for these structs are the following: each time a
- * device special file is opened, we look up the corresponding struct
- * ib_umad_port by minor in the umad_port[] table while holding the
- * port_lock.  If this lookup succeeds, we take a reference on the
- * ib_umad_port's struct ib_umad_device while still holding the
- * port_lock; if the lookup fails, we fail the open().  We drop these
+ * Our lifetime rules for these structs are the following:
+ * device special file is opened, we take a reference on the
+ * ib_umad_port's struct ib_umad_device. We drop these
  * references in the corresponding close().
  *
  * In addition to references coming from open character devices, there
@@ -78,12 +75,7 @@ enum {
  * module's reference taken when allocating the ib_umad_device in
  * ib_umad_add_one().
  *
- * When destroying an ib_umad_device, we clear all of its
- * ib_umad_ports from umad_port[] while holding port_lock before
- * dropping the module's reference to the ib_umad_device.  This is
- * always safe because any open() calls will either succeed and obtain
- * a reference before we clear the umad_port[] entries, or fail after
- * we clear the umad_port[] entries.
+ * When destroying an ib_umad_device, we drop the module's reference.
  */
 
 struct ib_umad_port {
@@ -136,7 +128,6 @@ static struct class *umad_class;
 static const dev_t base_dev = MKDEV(IB_UMAD_MAJOR, IB_UMAD_MINOR_BASE);
 
 static DEFINE_SPINLOCK(port_lock);
-static struct ib_umad_port *umad_port[IB_UMAD_MAX_PORTS];
 static DECLARE_BITMAP(dev_map, IB_UMAD_MAX_PORTS);
 
 static void ib_umad_add_one(struct ib_device *device);
@@ -779,15 +770,11 @@ static long ib_umad_compat_ioctl(struct file *filp, unsigned int cmd,
 /*
  * ib_umad_open() does not need the BKL:
  *
- *  - umad_port[] accesses are protected by port_lock, the
- *    ib_umad_port structures are properly reference counted, and
+ *  - the ib_umad_port structures are properly reference counted, and
  *    everything else is purely local to the file being created, so
  *    races against other open calls are not a problem;
  *  - the ioctl method does not affect any global state outside of the
  *    file structure being operated on;
- *  - the port is added to umad_port[] as the last part of module
- *    initialization so the open method will either immediately run
- *    -ENXIO, or all required initialization will be done.
  */
 static int ib_umad_open(struct inode *inode, struct file *filp)
 {
@@ -795,13 +782,10 @@ static int ib_umad_open(struct inode *inode, struct file *filp)
 	struct ib_umad_file *file;
 	int ret = 0;
 
-	spin_lock(&port_lock);
-	port = umad_port[iminor(inode) - IB_UMAD_MINOR_BASE];
+	port = container_of(inode->i_cdev, struct ib_umad_port, cdev);
 	if (port)
 		kref_get(&port->umad_dev->ref);
-	spin_unlock(&port_lock);
-
-	if (!port)
+	else
 		return -ENXIO;
 
 	mutex_lock(&port->file_mutex);
@@ -892,13 +876,10 @@ static int ib_umad_sm_open(struct inode *inode, struct file *filp)
 	};
 	int ret;
 
-	spin_lock(&port_lock);
-	port = umad_port[iminor(inode) - IB_UMAD_MINOR_BASE - IB_UMAD_MAX_PORTS];
+	port = container_of(inode->i_cdev, struct ib_umad_port, sm_cdev);
 	if (port)
 		kref_get(&port->umad_dev->ref);
-	spin_unlock(&port_lock);
-
-	if (!port)
+	else
 		return -ENXIO;
 
 	if (filp->f_flags & O_NONBLOCK) {
@@ -1042,10 +1023,6 @@ static int ib_umad_init_port(struct ib_device *device, int port_num,
 	if (device_create_file(port->sm_dev, &dev_attr_port))
 		goto err_sm_dev;
 
-	spin_lock(&port_lock);
-	umad_port[port->dev_num] = port;
-	spin_unlock(&port_lock);
-
 	return 0;
 
 err_sm_dev:
@@ -1079,10 +1056,6 @@ static void ib_umad_kill_port(struct ib_umad_port *port)
 	cdev_del(&port->cdev);
 	cdev_del(&port->sm_cdev);
 
-	spin_lock(&port_lock);
-	umad_port[port->dev_num] = NULL;
-	spin_unlock(&port_lock);
-
 	mutex_lock(&port->file_mutex);
 
 	port->ib_dev = NULL;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
