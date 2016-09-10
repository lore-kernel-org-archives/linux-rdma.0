From: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 4/8] net: hns: delete repeat read fbd num after while
Date: Sat, 10 Sep 2016 05:09:26 +0100
Message-ID: <20160910040930.25988-5-salil.mehta@huawei.com>
References: <20160910040930.25988-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160910040930.25988-1-salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Daode Huang <huangdaode-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daode Huang <huangdaode-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>

Because we handle the received packets after napi, so delete the checking
before submitting. It delete the code of read the fbd number register,
which reduces the cpu usages while receiving packets

Signed-off-by: Daode Huang <huangdaode-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
Reviewed-by: Yisen Zhuang <yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/net/ethernet/hisilicon/hns/hns_enet.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index e6bfc51..09ed237 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -760,7 +760,7 @@ static int hns_nic_rx_poll_one(struct hns_nic_ring_data *ring_data,
 {
 	struct hnae_ring *ring = ring_data->ring;
 	struct sk_buff *skb;
-	int num, bnum, ex_num;
+	int num, bnum;
 #define RCB_NOF_ALLOC_RX_BUFF_ONCE 16
 	int recv_pkts, recv_bds, clean_count, err;
 	int unused_count = hns_desc_unused(ring);
@@ -770,7 +770,7 @@ static int hns_nic_rx_poll_one(struct hns_nic_ring_data *ring_data,
 
 	recv_pkts = 0, recv_bds = 0, clean_count = 0;
 	num -= unused_count;
-recv:
+
 	while (recv_pkts < budget && recv_bds < num) {
 		/* reuse or realloc buffers */
 		if (clean_count + unused_count >= RCB_NOF_ALLOC_RX_BUFF_ONCE) {
@@ -798,17 +798,6 @@ recv:
 		recv_pkts++;
 	}
 
-	/* make all data has been write before submit */
-	if (recv_pkts < budget) {
-		ex_num = readl_relaxed(ring->io_base + RCB_REG_FBDNUM);
-		ex_num -= unused_count;
-		if (ex_num > clean_count) {
-			num += ex_num - clean_count;
-			rmb(); /*complete read rx ring bd number*/
-			goto recv;
-		}
-	}
-
 out:
 	/* make all data has been write before submit */
 	if (clean_count + unused_count > 0)
-- 
1.9.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
