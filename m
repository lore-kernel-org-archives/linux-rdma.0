From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/5 v2] qedr: fix RDMA CM loopback
Date: Tue, 24 Jan 2017 13:51:41 +0200
Message-ID: <1485258703-11949-4-git-send-email-Ram.Amrani@cavium.com>
References: <1485258703-11949-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485258703-11949-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ram Amrani <Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>

The loopback logic in RDMA CM packets compares Ethernet addresses and
was accidently inverse.

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qedr/qedr_cm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/qedr_cm.c b/drivers/infiniband/hw/qedr/qedr_cm.c
index 00361f3..a9a8d87 100644
--- a/drivers/infiniband/hw/qedr/qedr_cm.c
+++ b/drivers/infiniband/hw/qedr/qedr_cm.c
@@ -398,9 +398,9 @@ static inline int qedr_gsi_build_packet(struct qedr_dev *dev,
 	}
 
 	if (ether_addr_equal(udh.eth.smac_h, udh.eth.dmac_h))
-		packet->tx_dest = QED_ROCE_LL2_TX_DEST_NW;
-	else
 		packet->tx_dest = QED_ROCE_LL2_TX_DEST_LB;
+	else
+		packet->tx_dest = QED_ROCE_LL2_TX_DEST_NW;
 
 	packet->roce_mode = roce_mode;
 	memcpy(packet->header.vaddr, ud_header_buffer, header_size);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
