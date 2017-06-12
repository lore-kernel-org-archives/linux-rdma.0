From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 1/3] IB/core: Fix the validations of a multicast LID in attach or detach operations
Date: Mon, 12 Jun 2017 11:14:02 +0300
Message-ID: <20170612081404.17553-2-leon@kernel.org>
References: <20170612081404.17553-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170612081404.17553-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

RoCE Annex (A16.9.10/11) declares that during attach (detach) QP to a
multicast group, if the QP is associated with a RoCE port, the
multicast group MLID is unused and is ignored.

During attach or detach multicast, when the QP is associated with a
port, it is enough to check the port's link layer and validate the
LID only if it is Infiniband. Otherwise, avoid validating the
multicast LID.

Fixes: 8561eae60ff9 ("IB/core: For multicast functions, verify that LIDs are multicast LIDs")
Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/verbs.c | 44 +++++++++++++++++++++++++++++++++++++----
 1 file changed, 40 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 4792f5209ac2..38f6bec08d56 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1519,6 +1519,44 @@ EXPORT_SYMBOL(ib_dealloc_fmr);

 /* Multicast groups */

+static bool is_valid_mcast_lid(struct ib_qp *qp, u16 lid)
+{
+	struct ib_qp_init_attr init_attr = {};
+	struct ib_qp_attr attr = {};
+	int num_eth_ports = 0;
+	int port;
+
+	/* If QP state >= init, it is assigned to a port and we can check this
+	 * port only.
+	 */
+	if (!ib_query_qp(qp, &attr, IB_QP_STATE | IB_QP_PORT, &init_attr)) {
+		if (attr.qp_state >= IB_QPS_INIT) {
+			if (qp->device->get_link_layer(qp->device, attr.port_num) !=
+			    IB_LINK_LAYER_INFINIBAND)
+				return true;
+			goto lid_check;
+		}
+	}
+
+	/* Can't get a quick answer, iterate over all ports */
+	for (port = 0; port < qp->device->phys_port_cnt; port++)
+		if (qp->device->get_link_layer(qp->device, port) !=
+		    IB_LINK_LAYER_INFINIBAND)
+			num_eth_ports++;
+
+	/* If we have at lease one Ethernet port, RoCE annex declares that
+	 * multicast LID should be ignored. We can't tell at this step if the
+	 * QP belongs to an IB or Ethernet port.
+	 */
+	if (num_eth_ports)
+		return true;
+
+	/* If all the ports are IB, we can check according to IB spec. */
+lid_check:
+	return !(lid < be16_to_cpu(IB_MULTICAST_LID_BASE) ||
+		 lid == be16_to_cpu(IB_LID_PERMISSIVE));
+}
+
 int ib_attach_mcast(struct ib_qp *qp, union ib_gid *gid, u16 lid)
 {
 	int ret;
@@ -1526,8 +1564,7 @@ int ib_attach_mcast(struct ib_qp *qp, union ib_gid *gid, u16 lid)
 	if (!qp->device->attach_mcast)
 		return -ENOSYS;
 	if (gid->raw[0] != 0xff || qp->qp_type != IB_QPT_UD ||
-	    lid < be16_to_cpu(IB_MULTICAST_LID_BASE) ||
-	    lid == be16_to_cpu(IB_LID_PERMISSIVE))
+	    !is_valid_mcast_lid(qp, lid))
 		return -EINVAL;

 	ret = qp->device->attach_mcast(qp, gid, lid);
@@ -1544,8 +1581,7 @@ int ib_detach_mcast(struct ib_qp *qp, union ib_gid *gid, u16 lid)
 	if (!qp->device->detach_mcast)
 		return -ENOSYS;
 	if (gid->raw[0] != 0xff || qp->qp_type != IB_QPT_UD ||
-	    lid < be16_to_cpu(IB_MULTICAST_LID_BASE) ||
-	    lid == be16_to_cpu(IB_LID_PERMISSIVE))
+	    !is_valid_mcast_lid(qp, lid))
 		return -EINVAL;

 	ret = qp->device->detach_mcast(qp, gid, lid);
--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
