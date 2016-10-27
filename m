From: Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v4 02/10] IB/core: Replace semaphore sm_sem with an atomic wait
Date: Thu, 27 Oct 2016 12:29:06 +0530
Message-ID: <1477551554-30349-3-git-send-email-binoy.jayan@linaro.org>
References: <1477551554-30349-1-git-send-email-binoy.jayan@linaro.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477551554-30349-1-git-send-email-binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The semaphore 'sm_sem' is used for an exclusive ownership of the device
so model the same as an atomic variable with an associated wait_event.
Semaphores are going away in the future.

Signed-off-by: Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/user_mad.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 415a318..6101c0a 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -67,6 +67,8 @@ enum {
 	IB_UMAD_MINOR_BASE = 0
 };
 
+#define UMAD_F_CLAIM	0x01
+
 /*
  * Our lifetime rules for these structs are the following:
  * device special file is opened, we take a reference on the
@@ -87,7 +89,8 @@ struct ib_umad_port {
 
 	struct cdev           sm_cdev;
 	struct device	      *sm_dev;
-	struct semaphore       sm_sem;
+	wait_queue_head_t     wq;
+	unsigned long         flags;
 
 	struct mutex	       file_mutex;
 	struct list_head       file_list;
@@ -1030,12 +1033,14 @@ static int ib_umad_sm_open(struct inode *inode, struct file *filp)
 	port = container_of(inode->i_cdev, struct ib_umad_port, sm_cdev);
 
 	if (filp->f_flags & O_NONBLOCK) {
-		if (down_trylock(&port->sm_sem)) {
+		if (test_and_set_bit(UMAD_F_CLAIM, &port->flags)) {
 			ret = -EAGAIN;
 			goto fail;
 		}
 	} else {
-		if (down_interruptible(&port->sm_sem)) {
+		if (wait_event_interruptible(port->wq,
+					     !test_and_set_bit(UMAD_F_CLAIM,
+					     &port->flags))) {
 			ret = -ERESTARTSYS;
 			goto fail;
 		}
@@ -1060,7 +1065,8 @@ static int ib_umad_sm_open(struct inode *inode, struct file *filp)
 	ib_modify_port(port->ib_dev, port->port_num, 0, &props);
 
 err_up_sem:
-	up(&port->sm_sem);
+	clear_bit(UMAD_F_CLAIM, &port->flags);
+	wake_up(&port->wq);
 
 fail:
 	return ret;
@@ -1079,7 +1085,8 @@ static int ib_umad_sm_close(struct inode *inode, struct file *filp)
 		ret = ib_modify_port(port->ib_dev, port->port_num, 0, &props);
 	mutex_unlock(&port->file_mutex);
 
-	up(&port->sm_sem);
+	clear_bit(UMAD_F_CLAIM, &port->flags);
+	wake_up(&port->wq);
 
 	kobject_put(&port->umad_dev->kobj);
 
@@ -1177,7 +1184,8 @@ static int ib_umad_init_port(struct ib_device *device, int port_num,
 
 	port->ib_dev   = device;
 	port->port_num = port_num;
-	sema_init(&port->sm_sem, 1);
+	init_waitqueue_head(&port->wq);
+	__clear_bit(UMAD_F_CLAIM, &port->flags);
 	mutex_init(&port->file_mutex);
 	INIT_LIST_HEAD(&port->file_list);
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
