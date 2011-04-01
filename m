From: Liu Yuan <namei.unix-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] drivers/infiniband: Add a check for strict_strtoul()
Date: Fri,  1 Apr 2011 14:23:49 +0800
Message-ID: <1301639029-15251-1-git-send-email-namei.unix@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "open list:NETEFFECT IWARP R..." <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Liu Yuan <tailai.ly-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

It should check if strict_strtoul() succeeds before using
'wqm_quanta_value'.

Signed-off-by: Liu Yuan <tailai.ly-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes.c b/drivers/infiniband/hw/nes/nes.c
index 13de119..119d60d 100644
--- a/drivers/infiniband/hw/nes/nes.c
+++ b/drivers/infiniband/hw/nes/nes.c
@@ -1138,7 +1138,9 @@ static ssize_t nes_store_wqm_quanta(struct device_driver *ddp,
 	u32 i = 0;
 	struct nes_device *nesdev;
 
-	strict_strtoul(buf, 0, &wqm_quanta_value);
+	if (strict_strtoul(buf, 0, &wqm_quanta_value) < 0)
+		return -EINVAL;
+
 	list_for_each_entry(nesdev, &nes_dev_list, list) {
 		if (i == ee_flsh_adapter) {
 			nesdev->nesadapter->wqm_quanta = wqm_quanta_value;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
