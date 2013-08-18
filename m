From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 10/22] ucm: ib_ucm_write(): check userspace buffer length first
Date: Sun, 18 Aug 2013 20:28:46 +0200
Message-ID: <d1c1bdb0aacfdb8a4a831654015593c8a8ff3dd2.1376847403.git.ydroneaud@opteya.com>
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
 drivers/infiniband/core/ucm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index 8f8a0a8..49bf680 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -1178,10 +1178,10 @@ static ssize_t ib_ucm_write(struct file *filp, const char __user *buf,
 	if (copy_from_user(&hdr, buf, sizeof(hdr)))
 		return -EFAULT;
 
-	if (hdr.cmd >= ARRAY_SIZE(ucm_cmd_table))
+	if (hdr.in + sizeof(hdr) > len)
 		return -EINVAL;
 
-	if (hdr.in + sizeof(hdr) > len)
+	if (hdr.cmd >= ARRAY_SIZE(ucm_cmd_table))
 		return -EINVAL;
 
 	result = ucm_cmd_table[hdr.cmd](file, buf + sizeof(hdr),
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
