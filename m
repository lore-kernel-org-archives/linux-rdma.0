From: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH next] RDMA/ocrdma: ocrdma_sysfs_rcv_pkts() can be static
Date: Wed, 18 Feb 2015 11:45:53 +0800
Message-ID: <20150218034553.GA38068@snb>
References: <201502181128.AqJYFmKG%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201502181128.AqJYFmKG%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mitesh Ahuja <mitesh.ahuja-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Cc: kbuild-all-JC7UmRfGjtg@public.gmane.org, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Duan Jiong <duanj.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

drivers/infiniband/hw/ocrdma/ocrdma_stats.c:253:5: sparse: symbol 'ocrdma_sysfs_rcv_pkts' was not declared. Should it be static?
drivers/infiniband/hw/ocrdma/ocrdma_stats.c:264:5: sparse: symbol 'ocrdma_sysfs_rcv_data' was not declared. Should it be static?
drivers/infiniband/hw/ocrdma/ocrdma_stats.c:317:5: sparse: symbol 'ocrdma_sysfs_xmit_pkts' was not declared. Should it be static?
drivers/infiniband/hw/ocrdma/ocrdma_stats.c:332:5: sparse: symbol 'ocrdma_sysfs_xmit_data' was not declared. Should it be static?

Signed-off-by: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 ocrdma_stats.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_stats.c b/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
index 9d1701f..614d1a8 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
@@ -250,7 +250,7 @@ static char *ocrdma_rx_stats(struct ocrdma_dev *dev)
 	return stats;
 }
 
-u64 ocrdma_sysfs_rcv_pkts(struct ocrdma_dev *dev)
+static u64 ocrdma_sysfs_rcv_pkts(struct ocrdma_dev *dev)
 {
 	struct ocrdma_rdma_stats_resp *rdma_stats =
 		(struct ocrdma_rdma_stats_resp *)dev->stats_mem.va;
@@ -261,7 +261,7 @@ u64 ocrdma_sysfs_rcv_pkts(struct ocrdma_dev *dev)
 		+ (u64)rx_stats->roce_frame_payload_len_drops;
 }
 
-u64 ocrdma_sysfs_rcv_data(struct ocrdma_dev *dev)
+static u64 ocrdma_sysfs_rcv_data(struct ocrdma_dev *dev)
 {
 	struct ocrdma_rdma_stats_resp *rdma_stats =
 		(struct ocrdma_rdma_stats_resp *)dev->stats_mem.va;
@@ -314,7 +314,7 @@ static char *ocrdma_tx_stats(struct ocrdma_dev *dev)
 	return stats;
 }
 
-u64 ocrdma_sysfs_xmit_pkts(struct ocrdma_dev *dev)
+static u64 ocrdma_sysfs_xmit_pkts(struct ocrdma_dev *dev)
 {
 	struct ocrdma_rdma_stats_resp *rdma_stats =
 		(struct ocrdma_rdma_stats_resp *)dev->stats_mem.va;
@@ -329,7 +329,7 @@ u64 ocrdma_sysfs_xmit_pkts(struct ocrdma_dev *dev)
 	convert_to_64bit(tx_stats->ack_pkts_lo, tx_stats->ack_pkts_hi));
 }
 
-u64 ocrdma_sysfs_xmit_data(struct ocrdma_dev *dev)
+static u64 ocrdma_sysfs_xmit_data(struct ocrdma_dev *dev)
 {
 	struct ocrdma_rdma_stats_resp *rdma_stats =
 		(struct ocrdma_rdma_stats_resp *)dev->stats_mem.va;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
