From: Mitesh Ahuja <Mitesh.Ahuja@Emulex.Com>
Subject: RE: [PATCH next] RDMA/ocrdma: ocrdma_sysfs_rcv_pkts() can be static
Date: Wed, 18 Feb 2015 11:30:22 +0000
Message-ID: <80a631cc-5b3b-4059-bea6-6656c2d8669a@CMEXHTCAS2.ad.emulex.com>
References: <201502181128.AqJYFmKG%fengguang.wu@intel.com>
 <20150218034553.GA38068@snb>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150218034553.GA38068@snb>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: kbuild test robot <fengguang.wu@intel.com>
Cc: "kbuild-all@01.org" <kbuild-all@01.org>, Roland Dreier <roland@purestorage.com>, Devesh Sharma <Devesh.Sharma@Emulex.Com>, Selvin Xavier <Selvin.Xavier@Emulex.Com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Duan Jiong <duanj.fnst@cn.fujitsu.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Acked-by: Mitesh Ahuja.

-----Original Message-----
From: kbuild test robot [mailto:fengguang.wu@intel.com] 
Sent: Wednesday, February 18, 2015 9:16 AM
To: Mitesh Ahuja
Cc: kbuild-all@01.org; Roland Dreier; Devesh Sharma; Selvin Xavier; Sean Hefty; Hal Rosenstock; Duan Jiong; linux-rdma@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: [PATCH next] RDMA/ocrdma: ocrdma_sysfs_rcv_pkts() can be static

drivers/infiniband/hw/ocrdma/ocrdma_stats.c:253:5: sparse: symbol 'ocrdma_sysfs_rcv_pkts' was not declared. Should it be static?
drivers/infiniband/hw/ocrdma/ocrdma_stats.c:264:5: sparse: symbol 'ocrdma_sysfs_rcv_data' was not declared. Should it be static?
drivers/infiniband/hw/ocrdma/ocrdma_stats.c:317:5: sparse: symbol 'ocrdma_sysfs_xmit_pkts' was not declared. Should it be static?
drivers/infiniband/hw/ocrdma/ocrdma_stats.c:332:5: sparse: symbol 'ocrdma_sysfs_xmit_data' was not declared. Should it be static?

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
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
 		(struct ocrdma_rdma_stats_resp *)dev->stats_mem.va; @@ -261,7 +261,7 @@ u64 ocrdma_sysfs_rcv_pkts(struct ocrdma_dev *dev)
 		+ (u64)rx_stats->roce_frame_payload_len_drops;
 }
 
-u64 ocrdma_sysfs_rcv_data(struct ocrdma_dev *dev)
+static u64 ocrdma_sysfs_rcv_data(struct ocrdma_dev *dev)
 {
 	struct ocrdma_rdma_stats_resp *rdma_stats =
 		(struct ocrdma_rdma_stats_resp *)dev->stats_mem.va; @@ -314,7 +314,7 @@ static char *ocrdma_tx_stats(struct ocrdma_dev *dev)
 	return stats;
 }
 
-u64 ocrdma_sysfs_xmit_pkts(struct ocrdma_dev *dev)
+static u64 ocrdma_sysfs_xmit_pkts(struct ocrdma_dev *dev)
 {
 	struct ocrdma_rdma_stats_resp *rdma_stats =
 		(struct ocrdma_rdma_stats_resp *)dev->stats_mem.va; @@ -329,7 +329,7 @@ u64 ocrdma_sysfs_xmit_pkts(struct ocrdma_dev *dev)
 	convert_to_64bit(tx_stats->ack_pkts_lo, tx_stats->ack_pkts_hi));  }
 
-u64 ocrdma_sysfs_xmit_data(struct ocrdma_dev *dev)
+static u64 ocrdma_sysfs_xmit_data(struct ocrdma_dev *dev)
 {
 	struct ocrdma_rdma_stats_resp *rdma_stats =
 		(struct ocrdma_rdma_stats_resp *)dev->stats_mem.va;
