From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 5/6] IB/srp: Make writing into the "add_target" sysfs attribute
 interruptible
Date: Thu, 20 Feb 2014 11:54:44 +0100
Message-ID: <5305DEF4.8050607@acm.org>
References: <5305DE01.7030004@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5305DE01.7030004-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Avoid that stopping srp_daemon takes unusually long due to a cable
pull by making writing into the "add_target" sysfs attribute
interruptible.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 7d9413e..0d934b7 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -411,6 +411,8 @@ static void srp_path_rec_completion(int status,
 
 static int srp_lookup_path(struct srp_target_port *target)
 {
+	int ret;
+
 	target->path.numb_path = 1;
 
 	init_completion(&target->done);
@@ -431,7 +433,9 @@ static int srp_lookup_path(struct srp_target_port *target)
 	if (target->path_query_id < 0)
 		return target->path_query_id;
 
-	wait_for_completion(&target->done);
+	ret = wait_for_completion_interruptible(&target->done);
+	if (ret < 0)
+		return ret;
 
 	if (target->status < 0)
 		shost_printk(KERN_WARNING, target->scsi_host,
@@ -710,7 +714,9 @@ static int srp_connect_target(struct srp_target_port *target)
 		ret = srp_send_req(target);
 		if (ret)
 			return ret;
-		wait_for_completion(&target->done);
+		ret = wait_for_completion_interruptible(&target->done);
+		if (ret < 0)
+			return ret;
 
 		/*
 		 * The CM event handling code will set status to
-- 
1.8.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
