From: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v1 for-next 5/6] IB/usnic: Add UDP support in usnic_ib_qp_grp.[hc]
Date: Thu,  9 Jan 2014 14:48:18 -0800
Message-ID: <1389307699-11545-6-git-send-email-umalhi@cisco.com>
References: <1389307699-11545-1-git-send-email-umalhi@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389307699-11545-1-git-send-email-umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

UDP support for qp_grps/qps.

Signed-off-by: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c | 88 +++++++++++++++++++++++++++
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.h | 11 ++++
 2 files changed, 99 insertions(+)

diff --git a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
index 2b7e0a1..d6667a1 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
@@ -246,6 +246,80 @@ static void release_roce_custom_flow(struct usnic_ib_qp_grp_flow *qp_flow)
 }
 
 static struct usnic_ib_qp_grp_flow*
+create_udp_flow(struct usnic_ib_qp_grp *qp_grp,
+		struct usnic_transport_spec *trans_spec)
+{
+	struct socket *sock;
+	int sock_fd;
+	int err;
+	struct filter filter;
+	struct usnic_filter_action uaction;
+	struct usnic_ib_qp_grp_flow *qp_flow;
+	struct usnic_fwd_flow *flow;
+	enum usnic_transport_type trans_type;
+	uint32_t addr;
+	uint16_t port_num;
+	int proto;
+
+	trans_type = trans_spec->trans_type;
+	sock_fd = trans_spec->udp.sock_fd;
+
+	/* Get and check socket */
+	sock = usnic_transport_get_socket(sock_fd);
+	if (IS_ERR_OR_NULL(sock))
+		return ERR_CAST(sock);
+
+	err = usnic_transport_sock_get_addr(sock, &proto, &addr, &port_num);
+	if (err)
+		goto out_put_sock;
+
+	if (proto != IPPROTO_UDP) {
+		usnic_err("Protocol for fd %d is not UDP", sock_fd);
+		err = -EPERM;
+		goto out_put_sock;
+	}
+
+	/* Create flow */
+	usnic_fwd_init_udp_filter(&filter, addr, port_num);
+	err = init_filter_action(qp_grp, &uaction);
+	if (err)
+		goto out_put_sock;
+
+	flow = usnic_fwd_alloc_flow(qp_grp->ufdev, &filter, &uaction);
+	if (IS_ERR_OR_NULL(flow)) {
+		usnic_err("Unable to alloc flow failed with err %ld\n",
+				PTR_ERR(flow));
+		err = (flow) ? PTR_ERR(flow) : -EFAULT;
+		goto out_put_sock;
+	}
+
+	/* Create qp_flow */
+	qp_flow = kzalloc(sizeof(*qp_flow), GFP_ATOMIC);
+	if (IS_ERR_OR_NULL(qp_flow)) {
+		err = (qp_flow) ? PTR_ERR(qp_flow) : -ENOMEM;
+		goto out_dealloc_flow;
+	}
+	qp_flow->flow = flow;
+	qp_flow->trans_type = trans_type;
+	qp_flow->udp.sock = sock;
+	qp_flow->qp_grp = qp_grp;
+	return qp_flow;
+
+out_dealloc_flow:
+	usnic_fwd_dealloc_flow(flow);
+out_put_sock:
+	usnic_transport_put_socket(sock);
+	return ERR_PTR(err);
+}
+
+static void release_udp_flow(struct usnic_ib_qp_grp_flow *qp_flow)
+{
+	usnic_fwd_dealloc_flow(qp_flow->flow);
+	usnic_transport_put_socket(qp_flow->udp.sock);
+	kfree(qp_flow);
+}
+
+static struct usnic_ib_qp_grp_flow*
 create_and_add_flow(struct usnic_ib_qp_grp *qp_grp,
 			struct usnic_transport_spec *trans_spec)
 {
@@ -257,6 +331,9 @@ create_and_add_flow(struct usnic_ib_qp_grp *qp_grp,
 	case USNIC_TRANSPORT_ROCE_CUSTOM:
 		qp_flow = create_roce_custom_flow(qp_grp, trans_spec);
 		break;
+	case USNIC_TRANSPORT_IPV4_UDP:
+		qp_flow = create_udp_flow(qp_grp, trans_spec);
+		break;
 	default:
 		usnic_err("Unsupported transport %u\n",
 				trans_spec->trans_type);
@@ -278,6 +355,9 @@ static void release_and_remove_flow(struct usnic_ib_qp_grp_flow *qp_flow)
 	case USNIC_TRANSPORT_ROCE_CUSTOM:
 		release_roce_custom_flow(qp_flow);
 		break;
+	case USNIC_TRANSPORT_IPV4_UDP:
+		release_udp_flow(qp_flow);
+		break;
 	default:
 		WARN(1, "Unsupported transport %u\n",
 				qp_flow->trans_type);
@@ -544,11 +624,19 @@ static int qp_grp_id_from_flow(struct usnic_ib_qp_grp_flow *qp_flow,
 				uint32_t *id)
 {
 	enum usnic_transport_type trans_type = qp_flow->trans_type;
+	int err;
 
 	switch (trans_type) {
 	case USNIC_TRANSPORT_ROCE_CUSTOM:
 		*id = qp_flow->usnic_roce.port_num;
 		break;
+	case USNIC_TRANSPORT_IPV4_UDP:
+		err = usnic_transport_sock_get_addr(qp_flow->udp.sock,
+							NULL, NULL,
+							(uint16_t *) id);
+		if (err)
+			return err;
+		break;
 	default:
 		usnic_err("Unsupported transport %u\n", trans_type);
 		return -EINVAL;
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.h b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.h
index 570fea2..a8ba1b9 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.h
+++ b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.h
@@ -56,6 +56,9 @@ struct usnic_ib_qp_grp_flow {
 		struct {
 			uint16_t	port_num;
 		} usnic_roce;
+		struct {
+			struct socket	*sock;
+		} udp;
 	};
 	struct usnic_ib_qp_grp		*qp_grp;
 	struct list_head		link;
@@ -76,6 +79,14 @@ usnic_vnic_res_spec min_transport_spec[USNIC_TRANSPORT_MAX] = {
 			{.type = USNIC_VNIC_RES_TYPE_EOL,	.cnt = 0,},
 		},
 	},
+	{ /*USNIC_TRANSPORT_IPV4_UDP*/
+		.resources = {
+			{.type = USNIC_VNIC_RES_TYPE_WQ,	.cnt = 1,},
+			{.type = USNIC_VNIC_RES_TYPE_RQ,	.cnt = 1,},
+			{.type = USNIC_VNIC_RES_TYPE_CQ,	.cnt = 1,},
+			{.type = USNIC_VNIC_RES_TYPE_EOL,	.cnt = 0,},
+		},
+	},
 };
 
 const char *usnic_ib_qp_grp_state_to_string(enum ib_qp_state state);
-- 
1.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
