From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 7/7] IB/core: Initialize sysfs attributes before sysfs create group
Date: Sat,  4 Jun 2016 15:15:24 +0300
Message-ID: <1465042524-25852-8-git-send-email-leon@kernel.org>
References: <1465042524-25852-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465042524-25852-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

For dynamically allocated sysfs attributes there is a need to call
sysfs_attr_init in order to comply with lockdep, not calling it
will result in error complaining key is not in .data section.

Fixes: b40f4757daa1 ("IB/core: Make device counter infrastructure dynamic")
Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/sysfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index c68f132..44b53e4 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -925,10 +925,13 @@ static void setup_hw_stats(struct ib_device *device, struct ib_port *port,
 		hsag->attrs[i] = alloc_hsa(i, port_num, stats->names[i]);
 		if (!hsag->attrs[i])
 			goto err;
+		sysfs_attr_init(hsag->attrs[i]);
 	}
 
 	/* treat an error here as non-fatal */
 	hsag->attrs[i] = alloc_hsa_lifespan("lifespan", port_num);
+	if (hsag->attrs[i])
+		sysfs_attr_init(hsag->attrs[i]);
 
 	if (port) {
 		struct kobject *kobj = &port->kobj;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
