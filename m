From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] IB/srp: Stop the scsi_eh_<n> and scsi_tmf_<n> threads if
 login fails
Date: Fri, 14 Aug 2015 11:01:09 -0700
Message-ID: <55CE2CE5.40103@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Konstantin Krotov <kkv-IRcc4E3C6l4@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

scsi_host_alloc() not only allocates memory for a SCSI host but also
creates the scsi_eh_<n> kernel thread and the scsi_tmf_<n> workqueue.
Stop these threads if login fails by calling scsi_host_put().

Reported-by: Konstantin Krotov <kkv-IRcc4E3C6l4@public.gmane.org>
Fixes: fb49c8bbaae7 ("Remove an extraneous scsi_host_put() from an error path")
Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> #v3.19
---
 drivers/infiniband/ulp/srp/ib_srp.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index f962267..83f45e0 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2765,6 +2765,13 @@ static int srp_sdev_count(struct Scsi_Host *host)
 	return c;
 }
 
+/*
+ * Return values:
+ * < 0 upon failure. Caller is responsible for SRP target port cleanup.
+ * 0 and target->state == SRP_TARGET_REMOVED if asynchronous target port
+ *    removal has been scheduled.
+ * 0 and target->state != SRP_TARGET_REMOVED upon success.
+ */
 static int srp_add_target(struct srp_host *host, struct srp_target_port *target)
 {
 	struct srp_rport_identifiers ids;
@@ -3303,6 +3310,8 @@ out:
 	mutex_unlock(&host->add_target_mutex);
 
 	scsi_host_put(target->scsi_host);
+	if (ret < 0)
+		scsi_host_put(target->scsi_host);
 
 	return ret;
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
