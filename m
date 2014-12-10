From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 09/10] IB/srp: Use P_Key cache for P_Key lookups
Date: Wed, 10 Dec 2014 11:47:06 -0500
Message-ID: <245993b4f220916ced6a4af58f974dc0ad736549.1418229671.git.dledford@redhat.com>
References: <cover.1418229671.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1418229671.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1418229671.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
References: <cover.1418229671.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>

This change slightly reduces the time needed to log in.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 5461924c9f1..8fa3da255cf 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -40,6 +40,7 @@
 #include <linux/parser.h>
 #include <linux/random.h>
 #include <linux/jiffies.h>
+#include <rdma/ib_cache.h>
 
 #include <linux/atomic.h>
 
@@ -265,10 +266,10 @@ static int srp_init_qp(struct srp_target_port *target,
 	if (!attr)
 		return -ENOMEM;
 
-	ret = ib_find_pkey(target->srp_host->srp_dev->dev,
-			   target->srp_host->port,
-			   be16_to_cpu(target->pkey),
-			   &attr->pkey_index);
+	ret = ib_find_cached_pkey(target->srp_host->srp_dev->dev,
+				  target->srp_host->port,
+				  be16_to_cpu(target->pkey),
+				  &attr->pkey_index);
 	if (ret)
 		goto out;
 
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
