From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 16/22] ucma: ucma_write(): check userspace buffer length first
Date: Sun, 18 Aug 2013 20:28:52 +0200
Message-ID: <982f816ee3459f533f093db134c74e4779880901.1376847403.git.ydroneaud@opteya.com>
References: <cover.1376847403.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Like uverbs, check the length parameter before the command type.

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Link: http://mid.gmane.org/cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
---
 drivers/infiniband/core/ucma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index ecc6fad..92f2248 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -1573,10 +1573,10 @@ static ssize_t ucma_write(struct file *filp, const char __user *buf,
 	if (copy_from_user(&hdr, buf, sizeof(hdr)))
 		return -EFAULT;
 
-	if (hdr.cmd >= ARRAY_SIZE(ucma_cmd_table))
+	if (hdr.in + sizeof(hdr) > len)
 		return -EINVAL;
 
-	if (hdr.in + sizeof(hdr) > len)
+	if (hdr.cmd >= ARRAY_SIZE(ucma_cmd_table))
 		return -EINVAL;
 
 	if (!ucma_cmd_table[hdr.cmd])
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
