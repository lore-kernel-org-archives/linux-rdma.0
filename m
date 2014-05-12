From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 1/3] IB/umad: Remove container_of() != NULL tests
Date: Mon, 12 May 2014 11:17:42 +0200
Message-ID: <537091B6.5000007@acm.org>
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

container_of() never returns NULL. Hence remove the code that tests
whether container_of() returns NULL.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Alex Chiang <achiang-VXdhtT5mjnY@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
---
 drivers/infiniband/core/user_mad.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index f0d588f..e61287c 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -783,10 +783,7 @@ static int ib_umad_open(struct inode *inode, struct file *filp)
 	int ret;
  	port = container_of(inode->i_cdev, struct ib_umad_port, cdev);
-	if (port)
-		kref_get(&port->umad_dev->ref);
-	else
-		return -ENXIO;
+	kref_get(&port->umad_dev->ref);
  	mutex_lock(&port->file_mutex);
 @@ -880,10 +877,7 @@ static int ib_umad_sm_open(struct inode *inode, struct file *filp)
 	int ret;
  	port = container_of(inode->i_cdev, struct ib_umad_port, sm_cdev);
-	if (port)
-		kref_get(&port->umad_dev->ref);
-	else
-		return -ENXIO;
+	kref_get(&port->umad_dev->ref);
  	if (filp->f_flags & O_NONBLOCK) {
 		if (down_trylock(&port->sm_sem)) {
-- 
1.8.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
