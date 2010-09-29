From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH] RDMA/cxgb4: use simple_read_from_buffer() for debugfs
	handlers.
Date: Wed, 29 Sep 2010 13:21:33 -0500
Message-ID: <20100929182133.30260.84058.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/device.c |   26 +-------------------------
 1 files changed, 1 insertions(+), 25 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index b254357..22a290d 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -68,32 +68,8 @@ static ssize_t debugfs_read(struct file *file, char __user *buf, size_t count,
 			    loff_t *ppos)
 {
 	struct c4iw_debugfs_data *d = file->private_data;
-	loff_t pos = *ppos;
-	loff_t avail = d->pos;
 
-	if (pos < 0)
-		return -EINVAL;
-	if (pos >= avail)
-		return 0;
-	if (count > avail - pos)
-		count = avail - pos;
-
-	while (count) {
-		size_t len = 0;
-
-		len = min((int)count, (int)d->pos - (int)pos);
-		if (copy_to_user(buf, d->buf + pos, len))
-			return -EFAULT;
-		if (len == 0)
-			return -EINVAL;
-
-		buf += len;
-		pos += len;
-		count -= len;
-	}
-	count = pos - *ppos;
-	*ppos = pos;
-	return count;
+	return simple_read_from_buffer(buf, count, ppos, d->buf, d->pos);
 }
 
 static int dump_qp(int id, void *p, void *data)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
