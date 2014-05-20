From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3.1] IB/umad: Fix error handling
Date: Tue, 20 May 2014 10:33:41 +0200
Message-ID: <1400574821-9562-1-git-send-email-ydroneaud@opteya.com>
References: <53708666.6060209@acm.org> <537086BA.3020807@acm.org> <1399889890.3017.6.camel@localhost.localdomain> <5375F094.30809@acm.org> <5375F0CD.5080809@acm.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5375F0CD.5080809-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>

Avoid leaking a kref count in ib_umad_open() if port->ib_dev == NULL
or if nonseekable_open() fails. Avoid leaking a kref count, that
sm_sem is kept down and also that the IB_PORT_SM capability mask is
not cleared in ib_umad_sm_open() if nonseekable_open() fails.
Since container_of() never returns NULL, remove the code that tests
whether container_of() returns NULL. Note: moving the kref_get() call
from the start of ib_umad_*open() to the end is safe since it is the
responsibility of the caller of these functions to ensure that the
cdev pointer remains valid until at least when these functions return.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Alex Chiang <achiang-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
[ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org: rework a bit to reduce the amount of code changed]
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>

---
Hi Bart,

Please find a slightly modified version of your patch to simplify
a bit the error paths (no backward goto's) and to reduces the amount
of lines touched.

I wasn't able to explain it clearly enough in the previous patch review,
so I've made the changes directly in the file and propose the modified
patch for you to review.

As it's only suggestion, feel free to integrate the changes in your
patch or discard them.

Regards.

 drivers/infiniband/core/user_mad.c | 50 +++++++++++++++++++++-----------------
 1 file changed, 27 insertions(+), 22 deletions(-)

diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index f0d588f8859e..055893b870ee 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -780,27 +780,19 @@ static int ib_umad_open(struct inode *inode, struct file *filp)
 {
 	struct ib_umad_port *port;
 	struct ib_umad_file *file;
-	int ret;
+	int ret = -ENXIO;
 
 	port = container_of(inode->i_cdev, struct ib_umad_port, cdev);
-	if (port)
-		kref_get(&port->umad_dev->ref);
-	else
-		return -ENXIO;
 
 	mutex_lock(&port->file_mutex);
 
-	if (!port->ib_dev) {
-		ret = -ENXIO;
+	if (!port->ib_dev)
 		goto out;
-	}
 
+	ret = -ENOMEM;
 	file = kzalloc(sizeof *file, GFP_KERNEL);
-	if (!file) {
-		kref_put(&port->umad_dev->ref, ib_umad_release_dev);
-		ret = -ENOMEM;
+	if (!file)
 		goto out;
-	}
 
 	mutex_init(&file->mutex);
 	spin_lock_init(&file->send_lock);
@@ -814,9 +806,16 @@ static int ib_umad_open(struct inode *inode, struct file *filp)
 	list_add_tail(&file->port_list, &port->file_list);
 
 	ret = nonseekable_open(inode, filp);
+	if (ret) {
+		list_del(&file->port_list);
+		kfree(file);
+		goto out;
+	}
+
+	kref_get(&port->umad_dev->ref);
 
 out:
 	mutex_unlock(&port->file_mutex);
 	return ret;
 }
 
@@ -880,10 +880,6 @@ static int ib_umad_sm_open(struct inode *inode, struct file *filp)
 	int ret;
 
 	port = container_of(inode->i_cdev, struct ib_umad_port, sm_cdev);
-	if (port)
-		kref_get(&port->umad_dev->ref);
-	else
-		return -ENXIO;
 
 	if (filp->f_flags & O_NONBLOCK) {
 		if (down_trylock(&port->sm_sem)) {
@@ -898,17 +894,27 @@ static int ib_umad_sm_open(struct inode *inode, struct file *filp)
 	}
 
 	ret = ib_modify_port(port->ib_dev, port->port_num, 0, &props);
-	if (ret) {
-		up(&port->sm_sem);
-		goto fail;
-	}
+	if (ret)
+		goto err_up_sem;
 
 	filp->private_data = port;
 
-	return nonseekable_open(inode, filp);
+	ret = nonseekable_open(inode, filp);
+	if (ret)
+		goto err_clr_sm_cap;
+
+	kref_get(&port->umad_dev->ref);
+
+	return 0;
+
+err_clr_sm_cap:
+	swap(props.set_port_cap_mask, props.clr_port_cap_mask);
+	ib_modify_port(port->ib_dev, port->port_num, 0, &props);
+
+err_up_sem:
+	up(&port->sm_sem);
 
 fail:
-	kref_put(&port->umad_dev->ref, ib_umad_release_dev);
 	return ret;
 }
 
-- 
1.9.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
