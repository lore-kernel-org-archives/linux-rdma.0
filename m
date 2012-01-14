From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 14/18] ib_srp: Move target port removal code
Date: Sat, 14 Jan 2012 12:53:08 +0000
Message-ID: <1731814.WGsKYqVP6T@asus>
References: <3109536.qySrY1Ts3e@asus>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3109536.qySrY1Ts3e@asus>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dillowda-1Heg1YXhbW8@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Move the code for removing a target port if reconnecting during
a reset triggered by the SCSI mid-layer fails from inside
srp_reconnect_target() into srp_reset_host().

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   34 ++++++++++++++++------------------
 1 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index e8b699b..a8a3a2f 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -764,21 +764,7 @@ static int srp_reconnect_target(struct srp_target_port *target)
 	if (ret)
 		goto err;
 
-	return ret;
-
 err:
-	shost_printk(KERN_ERR, target->scsi_host,
-		     PFX "reconnect failed (%d), removing target port.\n", ret);
-
-	/*
-	 * We couldn't reconnect, so kill our target port off.
-	 * However, we have to defer the real removal because we
-	 * are in the context of the SCSI error handler now, which
-	 * will deadlock if we call scsi_remove_host().
-	 */
-	if (srp_change_state_to_removed(target))
-		queue_work(ib_wq, &target->remove_work);
-
 	return ret;
 }
 
@@ -1825,14 +1811,26 @@ static int srp_reset_device(struct scsi_cmnd *scmnd)
 static int srp_reset_host(struct scsi_cmnd *scmnd)
 {
 	struct srp_target_port *target = host_to_target(scmnd->device->host);
-	int ret = FAILED;
+	int res;
 
 	shost_printk(KERN_ERR, target->scsi_host, PFX "SRP reset_host called\n");
 
-	if (!srp_reconnect_target(target))
-		ret = SUCCESS;
+	res = srp_reconnect_target(target);
+	if (res == 0)
+		return SUCCESS;
 
-	return ret;
+	/*
+	 * We couldn't reconnect, so kill our target port off.  However, we
+	 * have to defer the real removal because we are in the context of the
+	 * SCSI error handler now, which will deadlock if we call
+	 * scsi_remove_host().
+	 */
+	shost_printk(KERN_ERR, target->scsi_host,
+		     PFX "reconnect failed (%d), removing target port.\n",
+		     res);
+	if (srp_change_state_to_removed(target))
+		queue_work(system_long_wq, &target->remove_work);
+	return FAILED;
 }
 
 static int srp_slave_configure(struct scsi_device *sdev)
-- 
1.7.7


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
