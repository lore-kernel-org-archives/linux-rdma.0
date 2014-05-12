From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 2/3] IB/umad: Fix error handling
Date: Mon, 12 May 2014 10:30:50 +0200
Message-ID: <537086BA.3020807@acm.org>
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

Avoid leaking a kref count in ib_umad_open() if port->ib_dev == NULL
or if nonseekable_open() fails. Avoid leaking a kref count, that
sm_sem is kept down and also that the IB_PORT_SM capability mask is
not cleared in ib_umad_sm_open() if nonseekable_open() fails.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
---
 drivers/infiniband/core/user_mad.c | 37 +++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index e61287c..5c67d80 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -780,24 +780,20 @@ static int ib_umad_open(struct inode *inode, struct file *filp)
 {
 	struct ib_umad_port *port;
 	struct ib_umad_file *file;
-	int ret;
+	int ret = -ENXIO;
 
 	port = container_of(inode->i_cdev, struct ib_umad_port, cdev);
 	kref_get(&port->umad_dev->ref);
 
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
@@ -814,6 +810,10 @@ static int ib_umad_open(struct inode *inode, struct file *filp)
 
 out:
 	mutex_unlock(&port->file_mutex);
+
+	if (ret)
+		kref_put(&port->umad_dev->ref, ib_umad_release_dev);
+
 	return ret;
 }
 
@@ -892,18 +892,27 @@ static int ib_umad_sm_open(struct inode *inode, struct file *filp)
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
 
 fail:
-	kref_put(&port->umad_dev->ref, ib_umad_release_dev);
+	if (ret)
+		kref_put(&port->umad_dev->ref, ib_umad_release_dev);
 	return ret;
+
+clr_sm_cap:
+	swap(props.set_port_cap_mask, props.clr_port_cap_mask);
+	ib_modify_port(port->ib_dev, port->port_num, 0, &props);
+
+up_sem:
+	up(&port->sm_sem);
+	goto fail;
 }
 
 static int ib_umad_sm_close(struct inode *inode, struct file *filp)
-- 
1.8.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
