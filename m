From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH v2 4/7] IB/srp: Avoid duplicate connections
Date: Mon, 10 Mar 2014 12:44:14 +0100
Message-ID: <531DA58E.40605@acm.org>
References: <531DA483.3010400@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <531DA483.3010400-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The connection uniqueness check is performed before a new connection
is added to the target list. This patch protects both actions by a
mutex such that simultaneous writes from two different threads into the
"add_target" variable do not result in duplicate connections.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 12 +++++++++---
 drivers/infiniband/ulp/srp/ib_srp.h |  1 +
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 2ec9c05..3294f10 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2614,6 +2614,8 @@ static ssize_t srp_create_target(struct device *dev,
 	target->tl_retry_count	= 7;
 	target->queue_size	= SRP_DEFAULT_QUEUE_SIZE;
 
+	mutex_lock(&host->add_target_mutex);
+
 	ret = srp_parse_options(buf, target);
 	if (ret)
 		goto err;
@@ -2682,7 +2684,11 @@ static ssize_t srp_create_target(struct device *dev,
 		     be64_to_cpu(target->service_id),
 		     target->path.sgid.raw, target->path.dgid.raw);
 
-	return count;
+	ret = count;
+
+out:
+	mutex_unlock(&host->add_target_mutex);
+	return ret;
 
 err_disconnect:
 	srp_disconnect_target(target);
@@ -2698,8 +2704,7 @@ err_free_mem:
 
 err:
 	scsi_host_put(target_host);
-
-	return ret;
+	goto out;
 }
 
 static DEVICE_ATTR(add_target, S_IWUSR, NULL, srp_create_target);
@@ -2735,6 +2740,7 @@ static struct srp_host *srp_add_port(struct srp_device *device, u8 port)
 	INIT_LIST_HEAD(&host->target_list);
 	spin_lock_init(&host->target_lock);
 	init_completion(&host->released);
+	mutex_init(&host->add_target_mutex);
 	host->srp_dev = device;
 	host->port = port;
 
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 5756810..aad27b7 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -105,6 +105,7 @@ struct srp_host {
 	spinlock_t		target_lock;
 	struct completion	released;
 	struct list_head	list;
+	struct mutex		add_target_mutex;
 };
 
 struct srp_request {
-- 
1.8.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
