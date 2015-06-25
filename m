From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] IB/srp: Avoid using uninitialized variable
Date: Thu, 25 Jun 2015 13:34:15 +0300
Message-ID: <1435228455-25862-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We might return res which is not initialized. Also
reduce code duplication by exporting srp_parse_tmo so
srp_tmo_set can reuse it.

Detected by Coverity.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jenny Falkovich <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   11 ++++-------
 drivers/scsi/scsi_transport_srp.c   |    3 ++-
 include/scsi/scsi_transport_srp.h   |    1 +
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index c3f654d..0112e0c 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -161,13 +161,10 @@ static int srp_tmo_set(const char *val, const struct kernel_param *kp)
 {
 	int tmo, res;
 
-	if (strncmp(val, "off", 3) != 0) {
-		res = kstrtoint(val, 0, &tmo);
-		if (res)
-			goto out;
-	} else {
-		tmo = -1;
-	}
+	res = srp_parse_tmo(&tmo, val);
+	if (res)
+		goto out;
+
 	if (kp->arg == &srp_reconnect_delay)
 		res = srp_tmo_valid(tmo, srp_fast_io_fail_tmo,
 				    srp_dev_loss_tmo);
diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index a85292b..e3cd3ec 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -203,7 +203,7 @@ static ssize_t srp_show_tmo(char *buf, int tmo)
 	return tmo >= 0 ? sprintf(buf, "%d\n", tmo) : sprintf(buf, "off\n");
 }
 
-static int srp_parse_tmo(int *tmo, const char *buf)
+int srp_parse_tmo(int *tmo, const char *buf)
 {
 	int res = 0;
 
@@ -214,6 +214,7 @@ static int srp_parse_tmo(int *tmo, const char *buf)
 
 	return res;
 }
+EXPORT_SYMBOL(srp_parse_tmo);
 
 static ssize_t show_reconnect_delay(struct device *dev,
 				    struct device_attribute *attr, char *buf)
diff --git a/include/scsi/scsi_transport_srp.h b/include/scsi/scsi_transport_srp.h
index cdb05dd..d40d3ef 100644
--- a/include/scsi/scsi_transport_srp.h
+++ b/include/scsi/scsi_transport_srp.h
@@ -119,6 +119,7 @@ extern struct srp_rport *srp_rport_add(struct Scsi_Host *,
 extern void srp_rport_del(struct srp_rport *);
 extern int srp_tmo_valid(int reconnect_delay, int fast_io_fail_tmo,
 			 int dev_loss_tmo);
+int srp_parse_tmo(int *tmo, const char *buf);
 extern int srp_reconnect_rport(struct srp_rport *rport);
 extern void srp_start_tl_fail_timers(struct srp_rport *rport);
 extern void srp_remove_host(struct Scsi_Host *);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
