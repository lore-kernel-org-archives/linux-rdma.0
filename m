From: Colin King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH] IB/core: fix null pointer dereference and memory leak in error handling
Date: Wed,  1 Jun 2016 19:06:36 +0100
Message-ID: <1464804396-13936-1-git-send-email-colin.king@canonical.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

The current error handling in setup_hw_stats has a couple of issues.
It is possible to generate a null pointer deference on the
kfree of hsag->attrs[i] because two of the early error exit paths
jump to the kfree when hsags NULL and not allocated. Fix this by
moving the kfree on stats and jumping to that, avoiding the hsag
freeing.

Secondly, there is a memory leak of stats if the hsag allocation
fails; instead of returning, jump to the kfree on stats.

Signed-off-by: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
 drivers/infiniband/core/sysfs.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 5e573bb..ed04a7b 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -899,14 +899,14 @@ static void setup_hw_stats(struct ib_device *device, struct ib_port *port,
 		return;
 
 	if (!stats->names || stats->num_counters <= 0)
-		goto err;
+		goto err_free_stats;
 
 	hsag = kzalloc(sizeof(*hsag) +
 		       // 1 extra for the lifespan config entry
 		       sizeof(void *) * (stats->num_counters + 1),
 		       GFP_KERNEL);
 	if (!hsag)
-		return;
+		goto err_free_stats;
 
 	ret = device->get_hw_stats(device, stats, port_num,
 				   stats->num_counters);
@@ -946,10 +946,11 @@ static void setup_hw_stats(struct ib_device *device, struct ib_port *port,
 	return;
 
 err:
-	kfree(stats);
 	for (; i >= 0; i--)
 		kfree(hsag->attrs[i]);
 	kfree(hsag);
+err_free_stats:
+	kfree(stats);
 	return;
 }
 
-- 
2.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
