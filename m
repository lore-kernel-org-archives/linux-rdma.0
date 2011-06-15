From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 9/9] ib/mlx4: support PMA counters for IBoE
Date: Wed, 15 Jun 2011 17:51:27 +0300
Message-ID: <alpine.LRH.2.00.1106151751060.15844@ogerlitz.voltaire.com>
References: <alpine.LRH.2.00.1106151733410.15844@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1106151733410.15844-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Use the per port counter attached to all QPs created on that port
to implement port level packets/bytes performance counters ala IB.
Derived from patch by Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mad.c |   68 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 67 insertions(+), 1 deletion(-)

Index: b/drivers/infiniband/hw/mlx4/mad.c
===================================================================
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -35,6 +35,7 @@

 #include <linux/mlx4/cmd.h>
 #include <linux/gfp.h>
+#include <rdma/ib_pma.h>

 #include "mlx4_ib.h"

@@ -232,7 +233,7 @@ static void forward_trap(struct mlx4_ib_
 	}
 }

-int mlx4_ib_process_mad(struct ib_device *ibdev, int mad_flags,	u8 port_num,
+static int ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 			struct ib_wc *in_wc, struct ib_grh *in_grh,
 			struct ib_mad *in_mad, struct ib_mad *out_mad)
 {
@@ -302,6 +303,71 @@ int mlx4_ib_process_mad(struct ib_device
 	return IB_MAD_RESULT_SUCCESS | IB_MAD_RESULT_REPLY;
 }

+static void edit_counter(struct mlx4_counter *cnt,
+					struct ib_pma_portcounters *pma_cnt)
+{
+	pma_cnt->port_xmit_data = cpu_to_be32((be64_to_cpu(cnt->tx_bytes)>>2));
+	pma_cnt->port_rcv_data  = cpu_to_be32((be64_to_cpu(cnt->rx_bytes)>>2));
+	pma_cnt->port_xmit_packets = cpu_to_be32(be64_to_cpu(cnt->tx_frames));
+	pma_cnt->port_rcv_packets  = cpu_to_be32(be64_to_cpu(cnt->rx_frames));
+}
+
+static int iboe_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
+			struct ib_wc *in_wc, struct ib_grh *in_grh,
+			struct ib_mad *in_mad, struct ib_mad *out_mad)
+{
+	struct mlx4_cmd_mailbox *mailbox;
+	struct mlx4_ib_dev *dev = to_mdev(ibdev);
+	int err;
+	u32 inmod = dev->counters[port_num - 1] & 0xffff;
+	u8 mode;
+
+	if (in_mad->mad_hdr.mgmt_class != IB_MGMT_CLASS_PERF_MGMT)
+		return -EINVAL;
+
+	mailbox = mlx4_alloc_cmd_mailbox(dev->dev);
+	if (IS_ERR(mailbox))
+		return IB_MAD_RESULT_FAILURE;
+
+	err = mlx4_cmd_box(dev->dev, 0, mailbox->dma, inmod, 0,
+			   MLX4_CMD_QUERY_IF_STAT, MLX4_CMD_TIME_CLASS_C);
+	if (err)
+		err = IB_MAD_RESULT_FAILURE;
+	else {
+		memset(out_mad->data, 0, sizeof out_mad->data);
+		mode = ((struct mlx4_counter *)mailbox->buf)->counter_mode;
+		switch (mode & 0xf) {
+		case 0:
+			edit_counter(mailbox->buf,
+						(void *)(out_mad->data + 40));
+			err = IB_MAD_RESULT_SUCCESS | IB_MAD_RESULT_REPLY;
+			break;
+		default:
+			err = IB_MAD_RESULT_FAILURE;
+		}
+	}
+
+	mlx4_free_cmd_mailbox(dev->dev, mailbox);
+
+	return err;
+}
+
+int mlx4_ib_process_mad(struct ib_device *ibdev, int mad_flags,	u8 port_num,
+			struct ib_wc *in_wc, struct ib_grh *in_grh,
+			struct ib_mad *in_mad, struct ib_mad *out_mad)
+{
+	switch (rdma_port_get_link_layer(ibdev, port_num)) {
+	case IB_LINK_LAYER_INFINIBAND:
+		return ib_process_mad(ibdev, mad_flags, port_num, in_wc,
+				      in_grh, in_mad, out_mad);
+	case IB_LINK_LAYER_ETHERNET:
+		return iboe_process_mad(ibdev, mad_flags, port_num, in_wc,
+					  in_grh, in_mad, out_mad);
+	default:
+		return -EINVAL;
+	}
+}
+
 static void send_handler(struct ib_mad_agent *agent,
 			 struct ib_mad_send_wc *mad_send_wc)
 {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
