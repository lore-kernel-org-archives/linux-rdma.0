From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH v2 1/2] IB/umad: Fix error handling
Date: Tue, 13 May 2014 12:31:05 +0200
Message-ID: <5371F469.7020603@acm.org>
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
---
 drivers/infiniband/core/user_mad.c | 58 ++++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 25 deletions(-)

diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index f0d588f..2b3dfcc 100644
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
@@ -815,9 +807,20 @@ static int ib_umad_open(struct inode *inode, struct file *filp)
 
 	ret = nonseekable_open(inode, filp);
 
+	if (ret)
+		goto del;
+
+	kref_get(&port->umad_dev->ref);
+
 out:
 	mutex_unlock(&port->file_mutex);
+
 	return ret;
+
+del:
+	list_del(&file->port_list);
+	kfree(file);
+	goto out;
 }
 
 static int ib_umad_close(struct inode *inode, struct file *filp)
@@ -880,36 +883,41 @@ static int ib_umad_sm_open(struct inode *inode, struct file *filp)
 	int ret;
 
 	port = container_of(inode->i_cdev, struct ib_umad_port, sm_cdev);
-	if (port)
-		kref_get(&port->umad_dev->ref);
-	else
-		return -ENXIO;
 
 	if (filp->f_flags & O_NONBLOCK) {
 		if (down_trylock(&port->sm_sem)) {
 			ret = -EAGAIN;
-			goto fail;
+			goto out;
 		}
 	} else {
 		if (down_interruptible(&port->sm_sem)) {
 			ret = -ERESTARTSYS;
-			goto fail;
+			goto out;
 		}
 	}
 
 	ret = ib_modify_port(port->ib_dev, port->port_num, 0, &props);
-	if (ret) {
-		up(&port->sm_sem);
-		goto fail;
-	}
+	if (ret)
+		goto up_sem;
 
 	filp->private_data = port;
 
-	return nonseekable_open(inode, filp);
+	ret = nonseekable_open(inode, filp);
+	if (ret)
+		goto clr_sm_cap;
 
-fail:
-	kref_put(&port->umad_dev->ref, ib_umad_release_dev);
+	kref_get(&port->umad_dev->ref);
+
+out:
 	return ret;
+
+clr_sm_cap:
+	swap(props.set_port_cap_mask, props.clr_port_cap_mask);
+	ib_modify_port(port->ib_dev, port->port_num, 0, &props);
+
+up_sem:
+	up(&port->sm_sem);
+	goto out;
 }
 
 static int ib_umad_sm_close(struct inode *inode, struct file *filp)
-- 
1.8.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
