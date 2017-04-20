From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next] IB/mlx5: Set correct SL in completion for RoCE
Date: Thu, 20 Apr 2017 13:26:54 +0300
Message-ID: <20170420102654.765-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

There is a difference when parsing a completion entry between Ethernet
and IB ports. When link layer is Ethernet the bits describe the type of
L3 header in the packet. In the case when link layer is Ethernet and VLAN
header is present the value of SL is equal to the 3 UP bits in the VLAN
header. If VLAN header is not present then the SL is undefined and consumer
of the completion should check if IB_WC_WITH_VLAN is set.

While that, this patch also fills the vlan_id field in the completion if
present.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/cq.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 5a31cec947fa..94c049b62c2f 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -172,6 +172,8 @@ static void handle_responder(struct ib_wc *wc, struct mlx5_cqe64 *cqe,
 	struct mlx5_ib_srq *srq;
 	struct mlx5_ib_wq *wq;
 	u16 wqe_ctr;
+	u8  roce_packet_type;
+	bool vlan_present;
 	u8 g;

 	if (qp->ibqp.srq || qp->ibqp.xrcd) {
@@ -223,7 +225,6 @@ static void handle_responder(struct ib_wc *wc, struct mlx5_cqe64 *cqe,
 		break;
 	}
 	wc->slid	   = be16_to_cpu(cqe->slid);
-	wc->sl		   = (be32_to_cpu(cqe->flags_rqpn) >> 24) & 0xf;
 	wc->src_qp	   = be32_to_cpu(cqe->flags_rqpn) & 0xffffff;
 	wc->dlid_path_bits = cqe->ml_path;
 	g = (be32_to_cpu(cqe->flags_rqpn) >> 28) & 3;
@@ -237,10 +238,22 @@ static void handle_responder(struct ib_wc *wc, struct mlx5_cqe64 *cqe,
 		wc->pkey_index = 0;
 	}

-	if (ll != IB_LINK_LAYER_ETHERNET)
+	if (ll != IB_LINK_LAYER_ETHERNET) {
+		wc->sl = (be32_to_cpu(cqe->flags_rqpn) >> 24) & 0xf;
 		return;
+	}
+
+	vlan_present = cqe->l4_l3_hdr_type & 0x1;
+	roce_packet_type   = (be32_to_cpu(cqe->flags_rqpn) >> 24) & 0x3;
+	if (vlan_present) {
+		wc->vlan_id = (be16_to_cpu(cqe->vlan_info)) & 0xfff;
+		wc->sl = (be16_to_cpu(cqe->vlan_info) >> 13) & 0x7;
+		wc->wc_flags |= IB_WC_WITH_VLAN;
+	} else {
+		wc->sl = 0;
+	}

-	switch (wc->sl & 0x3) {
+	switch (roce_packet_type) {
 	case MLX5_CQE_ROCE_L3_HEADER_TYPE_GRH:
 		wc->network_hdr_type = RDMA_NETWORK_IB;
 		break;
--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
