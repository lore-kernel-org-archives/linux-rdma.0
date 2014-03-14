From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH v3 3/7] IB/srp: Add more logging
Date: Fri, 14 Mar 2014 13:52:21 +0100
Message-ID: <5322FB85.5060502@acm.org>
References: <531DA483.3010400@acm.org> <5322FAF8.6020504@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5322FAF8.6020504-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, James Bottomley <jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Masanari Iida <standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Log sgid and dgid when reporting that a login has been rejected or when
a host has been added. This makes it easy to figure out which initiator
and target ports these messages apply to.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 8903226..2ec9c05 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1804,8 +1804,10 @@ static void srp_cm_rej_handler(struct ib_cm_id *cm_id,
 				shost_printk(KERN_WARNING, shost,
 					     PFX "SRP_LOGIN_REJ: requested max_it_iu_len too large\n");
 			else
-				shost_printk(KERN_WARNING, shost,
-					    PFX "SRP LOGIN REJECTED, reason 0x%08x\n", reason);
+				shost_printk(KERN_WARNING, shost, PFX
+					     "SRP LOGIN from %pI6 to %pI6 REJECTED, reason 0x%08x\n",
+					     target->path.sgid.raw,
+					     target->orig_dgid, reason);
 		} else
 			shost_printk(KERN_WARNING, shost,
 				     "  REJ reason: IB_CM_REJ_CONSUMER_DEFINED,"
@@ -2653,15 +2655,6 @@ static ssize_t srp_create_target(struct device *dev,
 	if (ret)
 		goto err_free_mem;
 
-	shost_printk(KERN_DEBUG, target->scsi_host, PFX
-		     "new target: id_ext %016llx ioc_guid %016llx pkey %04x "
-		     "service_id %016llx dgid %pI6\n",
-	       (unsigned long long) be64_to_cpu(target->id_ext),
-	       (unsigned long long) be64_to_cpu(target->ioc_guid),
-	       be16_to_cpu(target->path.pkey),
-	       (unsigned long long) be64_to_cpu(target->service_id),
-	       target->path.dgid.raw);
-
 	ret = srp_create_target_ib(target);
 	if (ret)
 		goto err_free_mem;
@@ -2681,6 +2674,14 @@ static ssize_t srp_create_target(struct device *dev,
 	if (ret)
 		goto err_disconnect;
 
+	shost_printk(KERN_DEBUG, target->scsi_host, PFX
+		     "new target: id_ext %016llx ioc_guid %016llx pkey %04x service_id %016llx sgid %pI6 dgid %pI6\n",
+		     be64_to_cpu(target->id_ext),
+		     be64_to_cpu(target->ioc_guid),
+		     be16_to_cpu(target->path.pkey),
+		     be64_to_cpu(target->service_id),
+		     target->path.sgid.raw, target->path.dgid.raw);
+
 	return count;
 
 err_disconnect:
-- 
1.8.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
