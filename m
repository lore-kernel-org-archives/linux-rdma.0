From: Sudip Mukherjee <sudipm.mukherjee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] IB/sysfs: fix NULL dereference
Date: Sun,  5 Jun 2016 21:13:55 +0100
Message-ID: <1465157636-10120-1-git-send-email-sudipm.mukherjee@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sudip Mukherjee <sudipm.mukherjee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If stats->names is NULL or stats->num_counters <= 0 we are jumping to
the error path where the for loop is freeing hsag->attrs[i]. But as i
is initialized to 0 so i >= 0 will be true and the loop will execute
once trying to free hsag->attrs[0]. But hsag is NULL still now leading
to a NULL pointer dereference.

Signed-off-by: Sudip Mukherjee <sudip.mukherjee-4yDnlxn2s6sWdaTGBSpHTA@public.gmane.org>
---
 drivers/infiniband/core/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 5e573bb..fcf6f9c 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -891,7 +891,7 @@ static void setup_hw_stats(struct ib_device *device, struct ib_port *port,
 {
 	struct attribute_group *hsag = NULL;
 	struct rdma_hw_stats *stats;
-	int i = 0, ret;
+	int i = -1, ret;
 
 	stats = device->alloc_hw_stats(device, port_num);
 
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
