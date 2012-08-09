From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 08/20] ib_srp: Introduce the helper function, srp_remove_target()
Date: Thu, 09 Aug 2012 15:50:55 +0000
Message-ID: <5023DC5F.10302@acm.org>
References: <5023DA39.7020000@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5023DA39.7020000-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index b7a5e92..88557f7 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -506,6 +506,17 @@ static void srp_del_scsi_host_attr(struct Scsi_Host *shost)
 		device_remove_file(&shost->shost_dev, *attr);
 }
 
+static void srp_remove_target(struct srp_target_port *target)
+{
+	srp_del_scsi_host_attr(target->scsi_host);
+	srp_remove_host(target->scsi_host);
+	scsi_remove_host(target->scsi_host);
+	ib_destroy_cm_id(target->cm_id);
+	srp_free_target_ib(target);
+	srp_free_req_data(target);
+	scsi_host_put(target->scsi_host);
+}
+
 static void srp_remove_work(struct work_struct *work)
 {
 	struct srp_target_port *target =
@@ -518,13 +529,7 @@ static void srp_remove_work(struct work_struct *work)
 	list_del(&target->list);
 	spin_unlock(&target->srp_host->target_lock);
 
-	srp_del_scsi_host_attr(target->scsi_host);
-	srp_remove_host(target->scsi_host);
-	scsi_remove_host(target->scsi_host);
-	ib_destroy_cm_id(target->cm_id);
-	srp_free_target_ib(target);
-	srp_free_req_data(target);
-	scsi_host_put(target->scsi_host);
+	srp_remove_target(target);
 }
 
 static int srp_connect_target(struct srp_target_port *target)
-- 
1.7.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
