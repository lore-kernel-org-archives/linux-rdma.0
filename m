From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 01/14] RDMA/ocrdma: Add support for IB stack compliant stats in sysfs.
Date: Thu, 18 Dec 2014 14:12:55 +0530
Message-ID: <9f68b3e3-baa2-421d-8958-89ecab311cbd@CMEXHTCAS1.ad.emulex.com>
References: <1418892188-6623-1-git-send-email-devesh.sharma@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418892188-6623-1-git-send-email-devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mitesh Ahuja <mitesh.ahuja-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitesh Ahuja <mitesh.ahuja-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

Add following per port sysfs traffic counters for RoCE
        port_xmit_packets
        port_rcv_packets
        port_rcv_data
        port_xmit_data

Signed-off-by: Mitesh Ahuja <mitesh.ahuja-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c    |   19 +++++++-
 drivers/infiniband/hw/ocrdma/ocrdma_stats.c |   69 +++++++++++++++++++++++++++
 drivers/infiniband/hw/ocrdma/ocrdma_stats.h |    2 +
 3 files changed, 89 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
index f3cc8c9..b80b57b 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
@@ -29,11 +29,13 @@
 #include <net/netevent.h>
 
 #include <rdma/ib_addr.h>
+#include <rdma/ib_mad.h>
 
 #include "ocrdma.h"
 #include "ocrdma_verbs.h"
 #include "ocrdma_ah.h"
 #include "ocrdma_hw.h"
+#include "ocrdma_stats.h"
 
 #define OCRDMA_VID_PCP_SHIFT	0xD
 
@@ -191,5 +193,20 @@ int ocrdma_process_mad(struct ib_device *ibdev,
 		       struct ib_grh *in_grh,
 		       struct ib_mad *in_mad, struct ib_mad *out_mad)
 {
-	return IB_MAD_RESULT_SUCCESS;
+	int status;
+	struct ocrdma_dev *dev;
+
+	switch (in_mad->mad_hdr.mgmt_class) {
+	case IB_MGMT_CLASS_PERF_MGMT:
+		dev = get_ocrdma_dev(ibdev);
+		if (!ocrdma_pma_counters(dev, out_mad))
+			status = IB_MAD_RESULT_SUCCESS | IB_MAD_RESULT_REPLY;
+		else
+			status = IB_MAD_RESULT_SUCCESS;
+		break;
+	default:
+		status = IB_MAD_RESULT_SUCCESS;
+		break;
+	}
+	return status;
 }
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_stats.c b/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
index 41a9aec..df48218 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
@@ -26,6 +26,7 @@
  *******************************************************************/
 
 #include <rdma/ib_addr.h>
+#include <rdma/ib_pma.h>
 #include "ocrdma_stats.h"
 
 static struct dentry *ocrdma_dbgfs_dir;
@@ -249,6 +250,27 @@ static char *ocrdma_rx_stats(struct ocrdma_dev *dev)
 	return stats;
 }
 
+u64 ocrdma_sysfs_rcv_pkts(struct ocrdma_dev *dev)
+{
+	struct ocrdma_rdma_stats_resp *rdma_stats =
+		(struct ocrdma_rdma_stats_resp *)dev->stats_mem.va;
+	struct ocrdma_rx_stats *rx_stats = &rdma_stats->rx_stats;
+
+	return convert_to_64bit(rx_stats->roce_frames_lo,
+		rx_stats->roce_frames_hi) + (u64)rx_stats->roce_frame_icrc_drops
+		+ (u64)rx_stats->roce_frame_payload_len_drops;
+}
+
+u64 ocrdma_sysfs_rcv_data(struct ocrdma_dev *dev)
+{
+	struct ocrdma_rdma_stats_resp *rdma_stats =
+		(struct ocrdma_rdma_stats_resp *)dev->stats_mem.va;
+	struct ocrdma_rx_stats *rx_stats = &rdma_stats->rx_stats;
+
+	return (convert_to_64bit(rx_stats->roce_frame_bytes_lo,
+		rx_stats->roce_frame_bytes_hi))/4;
+}
+
 static char *ocrdma_tx_stats(struct ocrdma_dev *dev)
 {
 	char *stats = dev->stats_mem.debugfs_mem, *pcur;
@@ -292,6 +314,37 @@ static char *ocrdma_tx_stats(struct ocrdma_dev *dev)
 	return stats;
 }
 
+u64 ocrdma_sysfs_xmit_pkts(struct ocrdma_dev *dev)
+{
+	struct ocrdma_rdma_stats_resp *rdma_stats =
+		(struct ocrdma_rdma_stats_resp *)dev->stats_mem.va;
+	struct ocrdma_tx_stats *tx_stats = &rdma_stats->tx_stats;
+
+	return (convert_to_64bit(tx_stats->send_pkts_lo,
+				 tx_stats->send_pkts_hi) +
+	convert_to_64bit(tx_stats->write_pkts_lo, tx_stats->write_pkts_hi) +
+	convert_to_64bit(tx_stats->read_pkts_lo, tx_stats->read_pkts_hi) +
+	convert_to_64bit(tx_stats->read_rsp_pkts_lo,
+			 tx_stats->read_rsp_pkts_hi) +
+	convert_to_64bit(tx_stats->ack_pkts_lo, tx_stats->ack_pkts_hi)) ;
+}
+
+u64 ocrdma_sysfs_xmit_data(struct ocrdma_dev *dev)
+{
+        struct ocrdma_rdma_stats_resp *rdma_stats =
+		(struct ocrdma_rdma_stats_resp *)dev->stats_mem.va;
+        struct ocrdma_tx_stats *tx_stats = &rdma_stats->tx_stats;
+
+	return (convert_to_64bit(tx_stats->send_bytes_lo,
+				 tx_stats->send_bytes_hi) +
+		convert_to_64bit(tx_stats->write_bytes_lo,
+				 tx_stats->write_bytes_hi) +
+		convert_to_64bit(tx_stats->read_req_bytes_lo,
+				 tx_stats->read_req_bytes_hi) +
+		convert_to_64bit(tx_stats->read_rsp_bytes_lo,
+				 tx_stats->read_rsp_bytes_hi))/4;
+}
+
 static char *ocrdma_wqe_stats(struct ocrdma_dev *dev)
 {
 	char *stats = dev->stats_mem.debugfs_mem, *pcur;
@@ -448,6 +501,22 @@ static void ocrdma_update_stats(struct ocrdma_dev *dev)
 	}
 }
 
+int ocrdma_pma_counters(struct ocrdma_dev *dev,
+			struct ib_mad *out_mad)
+{
+	struct ib_pma_portcounters *pma_cnt;
+
+	memset(out_mad->data, 0, sizeof out_mad->data);
+	pma_cnt = (void *)(out_mad->data + 40);
+	ocrdma_update_stats(dev);
+
+	pma_cnt->port_xmit_data    = cpu_to_be32(ocrdma_sysfs_xmit_data(dev));
+	pma_cnt->port_rcv_data     = cpu_to_be32(ocrdma_sysfs_rcv_data(dev));
+	pma_cnt->port_xmit_packets = cpu_to_be32(ocrdma_sysfs_xmit_pkts(dev));
+	pma_cnt->port_rcv_packets  = cpu_to_be32(ocrdma_sysfs_rcv_pkts(dev));
+	return 0;
+}
+
 static ssize_t ocrdma_dbgfs_ops_read(struct file *filp, char __user *buffer,
 					size_t usr_buf_len, loff_t *ppos)
 {
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_stats.h b/drivers/infiniband/hw/ocrdma/ocrdma_stats.h
index 5f5e20c..89afe06 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_stats.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_stats.h
@@ -50,5 +50,7 @@ void ocrdma_rem_debugfs(void);
 void ocrdma_init_debugfs(void);
 void ocrdma_rem_port_stats(struct ocrdma_dev *dev);
 void ocrdma_add_port_stats(struct ocrdma_dev *dev);
+int ocrdma_pma_counters(struct ocrdma_dev *dev,
+			struct ib_mad *out_mad);
 
 #endif	/* __OCRDMA_STATS_H__ */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
