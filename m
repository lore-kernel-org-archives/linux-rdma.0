From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH/RFC] RDMA/ucma: Add .nodename/.mode to tell userspace where to create device node
Date: Mon, 23 May 2011 10:53:50 -0700
Message-ID: <1306173230-17464-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Any objection to merging this?  Based on
https://bugzilla.redhat.com/show_bug.cgi?id=603264#c1 I think this is
the right thing to do these days.

-- 8< ---- snip ----

We want udev to create a device node under /dev/infiniband with
permission 0666 for rdma_cm, so add that info to our struct miscdevice.

Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/infiniband/core/ucma.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index b3fa798..3170899 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -1338,9 +1338,11 @@ static const struct file_operations ucma_fops = {
 };
 
 static struct miscdevice ucma_misc = {
-	.minor	= MISC_DYNAMIC_MINOR,
-	.name	= "rdma_cm",
-	.fops	= &ucma_fops,
+	.minor		= MISC_DYNAMIC_MINOR,
+	.name		= "rdma_cm",
+	.nodename	= "infiniband/rdma_cm",
+	.mode		= 0666,
+	.fops		= &ucma_fops,
 };
 
 static ssize_t show_abi_version(struct device *dev,
-- 
1.7.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
