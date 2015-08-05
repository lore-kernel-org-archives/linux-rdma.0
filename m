From: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 2/2] IB/mlx4_ib: Add support for RX/TX checksum offload capabilities report
Date: Wed,  5 Aug 2015 18:34:27 +0300
Message-ID: <1438788867-18332-3-git-send-email-amirv@mellanox.com>
References: <1438788867-18332-1-git-send-email-amirv@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438788867-18332-1-git-send-email-amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eric Dube <edube-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Use the new capability flags for RX/TX checksum offload.

Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 1437ed5..2af7554 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -442,6 +442,12 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 		props->device_cap_flags |= IB_DEVICE_MANAGED_FLOW_STEERING;
 	}
 
+	if ((dev->dev->caps.rx_checksum_flags_port[1] > 0) ||
+	    (dev->dev->caps.rx_checksum_flags_port[2] > 0))
+		props->csum_caps |= IB_CSUM_RX_TCP_UDP | IB_CSUM_RX_IP_HDR;
+
+	props->csum_caps |= IB_CSUM_TX_TCP_UDP | IB_CSUM_TX_IP_HDR;
+
 	props->vendor_id	   = be32_to_cpup((__be32 *) (out_mad->data + 36)) &
 		0xffffff;
 	props->vendor_part_id	   = dev->dev->persist->pdev->device;
-- 
2.4.3.413.ga5fe668

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
