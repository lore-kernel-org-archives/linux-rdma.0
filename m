From: Vladimir Neyelov <vladimirn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] IB/iser: fix connection teardown race condition
Date: Thu, 18 May 2017 16:16:21 +0300
Message-ID: <1495113381-15564-2-git-send-email-vladimirn@mellanox.com>
References: <1495113381-15564-1-git-send-email-vladimirn@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1495113381-15564-1-git-send-email-vladimirn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: root <vladimirn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: root <vladimirn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Under heavy iser target(scst) start/stop stress on iser intitiator
side found race condition. When called function iscsi_iser_slave_alloc
iser_conn pointer could be NULL. Because function iscsi_iser_conn_stop
can be called before and free iser connection. Addition global mutex
help to avoid this race.

Signed-off-by: Vladimir Neyelov <vladimirn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 5a887ef..62fff2a 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -83,6 +83,7 @@
 static struct iscsi_transport iscsi_iser_transport;
 static struct scsi_transport_template *iscsi_iser_scsi_transport;
 static struct workqueue_struct *release_wq;
+static DEFINE_MUTEX(unbind_iser_conn_mutex);
 struct iser_global ig;
 
 int iser_debug_level = 0;
@@ -550,12 +551,14 @@ static void iscsi_iser_cleanup_task(struct iscsi_task *task)
 	 */
 	if (iser_conn) {
 		mutex_lock(&iser_conn->state_mutex);
+		mutex_lock(&unbind_iser_conn_mutex);
 		iser_conn_terminate(iser_conn);
 		iscsi_conn_stop(cls_conn, flag);
 
 		/* unbind */
 		iser_conn->iscsi_conn = NULL;
 		conn->dd_data = NULL;
+		mutex_unlock(&unbind_iser_conn_mutex);
 
 		complete(&iser_conn->stop_completion);
 		mutex_unlock(&iser_conn->state_mutex);
@@ -977,13 +980,20 @@ static int iscsi_iser_slave_alloc(struct scsi_device *sdev)
 	struct iser_conn *iser_conn;
 	struct ib_device *ib_dev;
 
+	mutex_lock(&unbind_iser_conn_mutex);
+
 	session = starget_to_session(scsi_target(sdev))->dd_data;
 	iser_conn = session->leadconn->dd_data;
+	if(!iser_conn) {
+		mutex_unlock(&unbind_iser_conn_mutex);
+		return -EFAULT;
+	}
 	ib_dev = iser_conn->ib_conn.device->ib_device;
 
 	if (!(ib_dev->attrs.device_cap_flags & IB_DEVICE_SG_GAPS_REG))
 		blk_queue_virt_boundary(sdev->request_queue, ~MASK_4K);
 
+	mutex_unlock(&unbind_iser_conn_mutex);
 	return 0;
 }
 
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
