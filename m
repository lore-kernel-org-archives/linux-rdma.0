From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: [PATCH 2/8] IB/core: Replace semaphore sm_sem with completion
Date: Mon, 17 Oct 2016 22:00:56 +0530
Message-ID: <1476721862-7070-3-git-send-email-binoy.jayan@linaro.org>
References: <1476721862-7070-1-git-send-email-binoy.jayan@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1476721862-7070-1-git-send-email-binoy.jayan@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Binoy Jayan <binoy.jayan@linaro.org>
List-Id: linux-rdma@vger.kernel.org

The semaphore 'sm_sem' is used as completion, so convert it to
struct completion. Semaphores are going away in the future. The initial
status of the completion variable is marked as completed by a call to
the function 'complete' immediately following the initialization.

Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
---
 drivers/infiniband/core/user_mad.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 415a318..df070cc 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -47,6 +47,7 @@
 #include <linux/kref.h>
 #include <linux/compat.h>
 #include <linux/sched.h>
+#include <linux/completion.h>
 #include <linux/semaphore.h>
 #include <linux/slab.h>
 
@@ -87,7 +88,7 @@ struct ib_umad_port {
 
 	struct cdev           sm_cdev;
 	struct device	      *sm_dev;
-	struct semaphore       sm_sem;
+	struct completion      sm_comp;
 
 	struct mutex	       file_mutex;
 	struct list_head       file_list;
@@ -1030,12 +1031,12 @@ static int ib_umad_sm_open(struct inode *inode, struct file *filp)
 	port = container_of(inode->i_cdev, struct ib_umad_port, sm_cdev);
 
 	if (filp->f_flags & O_NONBLOCK) {
-		if (down_trylock(&port->sm_sem)) {
+		if (!try_wait_for_completion(&port->sm_comp)) {
 			ret = -EAGAIN;
 			goto fail;
 		}
 	} else {
-		if (down_interruptible(&port->sm_sem)) {
+		if (wait_for_completion_interruptible(&port->sm_comp)) {
 			ret = -ERESTARTSYS;
 			goto fail;
 		}
@@ -1060,7 +1061,7 @@ static int ib_umad_sm_open(struct inode *inode, struct file *filp)
 	ib_modify_port(port->ib_dev, port->port_num, 0, &props);
 
 err_up_sem:
-	up(&port->sm_sem);
+	complete(&port->sm_comp);
 
 fail:
 	return ret;
@@ -1079,7 +1080,7 @@ static int ib_umad_sm_close(struct inode *inode, struct file *filp)
 		ret = ib_modify_port(port->ib_dev, port->port_num, 0, &props);
 	mutex_unlock(&port->file_mutex);
 
-	up(&port->sm_sem);
+	complete(&port->sm_comp);
 
 	kobject_put(&port->umad_dev->kobj);
 
@@ -1177,7 +1178,8 @@ static int ib_umad_init_port(struct ib_device *device, int port_num,
 
 	port->ib_dev   = device;
 	port->port_num = port_num;
-	sema_init(&port->sm_sem, 1);
+	init_completion(&port->sm_comp);
+	complete(&port->sm_comp);
 	mutex_init(&port->file_mutex);
 	INIT_LIST_HEAD(&port->file_list);
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
