From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 5/5] IB/srp: Make writing into the add_target sysfs attribute
 interruptible
Date: Mon, 21 Nov 2016 13:58:18 -0800
Message-ID: <bcae771a-6d3f-f93d-32a5-713198502160@sandisk.com>
References: <ba32b251-135f-c57d-44cc-658ae35a49ca@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ba32b251-135f-c57d-44cc-658ae35a49ca-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Avoid that shutdown of srp_daemon is delayed if add_target_mutex is
held by another process.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index bb9d73d..8ddc071 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3299,7 +3299,9 @@ static ssize_t srp_create_target(struct device *dev,
 	 */
 	scsi_host_get(target->scsi_host);
 
-	mutex_lock(&host->add_target_mutex);
+	ret = mutex_lock_interruptible(&host->add_target_mutex);
+	if (ret < 0)
+		goto put;
 
 	ret = srp_parse_options(buf, target);
 	if (ret)
@@ -3455,6 +3457,7 @@ static ssize_t srp_create_target(struct device *dev,
 out:
 	mutex_unlock(&host->add_target_mutex);
 
+put:
 	scsi_host_put(target->scsi_host);
 	if (ret < 0)
 		scsi_host_put(target->scsi_host);
-- 
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
