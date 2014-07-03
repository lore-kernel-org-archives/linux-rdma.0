From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 4/5] IB/srp: Use P_Key cache for P_Key lookups
Date: Thu, 03 Jul 2014 15:47:41 +0200
Message-ID: <53B55EFD.8080601@acm.org>
References: <53B55E55.5040907@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53B55E55.5040907-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This change slightly reduces the time needed to log in.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 6abfff4..f685e06 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -40,6 +40,7 @@
 #include <linux/parser.h>
 #include <linux/random.h>
 #include <linux/jiffies.h>
+#include <rdma/ib_cache.h>
 
 #include <linux/atomic.h>
 
@@ -260,10 +261,10 @@ static int srp_init_qp(struct srp_target_port *target,
 	if (!attr)
 		return -ENOMEM;
 
-	ret = ib_find_pkey(target->srp_host->srp_dev->dev,
-			   target->srp_host->port,
-			   be16_to_cpu(target->path.pkey),
-			   &attr->pkey_index);
+	ret = ib_find_cached_pkey(target->srp_host->srp_dev->dev,
+				  target->srp_host->port,
+				  be16_to_cpu(target->path.pkey),
+				  &attr->pkey_index);
 	if (ret)
 		goto out;
 
-- 
1.8.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
