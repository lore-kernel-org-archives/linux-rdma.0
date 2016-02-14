From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 2/2] IB/mlx4: Add support for the port info class for RoCE ports
Date: Sun, 14 Feb 2016 15:51:11 +0200
Message-ID: <1455457871-17354-3-git-send-email-matanb@mellanox.com>
References: <1455457871-17354-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455457871-17354-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In RoCE, mlx4_ib_process_mad calls iboe_process_mad directly.
iboe_process_mad assumes that we should always fill counters in the
MAD's response buffer (without the actual MAD attribute). Therefore,
when IB_PMA_CLASS_PORT_INFO is sent, we always fill counters data.
If the sysfs parses this data as "extended counters are supported",
it'll call the mlx4 driver expecting to get these counters. However,
this functionality didn't exist before applying this patch.

In order to fix that, this patch Report that the driver supports
IB_PMA_CLASS_CAP_EXT_WIDTH in response for IB_MGMT_CLASS_PERF_MGMT mad
with IB_PMA_CLASS_PORT_INFO attr id.

Signed-off-by: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mad.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index db37782..74335ca 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -841,6 +841,15 @@ static void edit_counter(struct mlx4_counter *cnt, void *counters,
 	}
 }
 
+static int iboe_process_mad_port_info(void *out_mad)
+{
+	struct ib_class_port_info cpi = {};
+
+	cpi.capability_mask = IB_PMA_CLASS_CAP_EXT_WIDTH;
+	memcpy(out_mad, &cpi, sizeof(cpi));
+	return IB_MAD_RESULT_SUCCESS | IB_MAD_RESULT_REPLY;
+}
+
 static int iboe_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 			const struct ib_wc *in_wc, const struct ib_grh *in_grh,
 			const struct ib_mad *in_mad, struct ib_mad *out_mad)
@@ -853,6 +862,9 @@ static int iboe_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 	if (in_mad->mad_hdr.mgmt_class != IB_MGMT_CLASS_PERF_MGMT)
 		return -EINVAL;
 
+	if (in_mad->mad_hdr.attr_id == IB_PMA_CLASS_PORT_INFO)
+		return iboe_process_mad_port_info((void *)(out_mad->data + 40));
+
 	memset(&counter_stats, 0, sizeof(counter_stats));
 	mutex_lock(&dev->counters_table[port_num - 1].mutex);
 	list_for_each_entry(tmp_counter,
@@ -908,7 +920,8 @@ int mlx4_ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 		if (mlx4_is_slave(dev->dev) &&
 		    (in_mad->mad_hdr.mgmt_class == IB_MGMT_CLASS_PERF_MGMT &&
 		     (in_mad->mad_hdr.attr_id == IB_PMA_PORT_COUNTERS ||
-		      in_mad->mad_hdr.attr_id == IB_PMA_PORT_COUNTERS_EXT)))
+		      in_mad->mad_hdr.attr_id == IB_PMA_PORT_COUNTERS_EXT ||
+		      in_mad->mad_hdr.attr_id == IB_PMA_CLASS_PORT_INFO)))
 			return iboe_process_mad(ibdev, mad_flags, port_num, in_wc,
 						in_grh, in_mad, out_mad);
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
