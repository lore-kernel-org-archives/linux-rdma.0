From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v2 7/7] RDMA/nldev: Provide detailed QP information
Date: Tue,  2 Jan 2018 10:18:32 +0200
Message-ID: <20180102081832.5264-8-leon@kernel.org>
References: <20180102081832.5264-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180102081832.5264-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Implement RDMA nldev netlink interface to get detailed
QP information.

Currently only dumpit variant is implemented.

Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/nldev.c  | 221 +++++++++++++++++++++++++++++++++++++++
 include/uapi/rdma/rdma_netlink.h |  43 ++++++++
 2 files changed, 264 insertions(+)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 7aca9458e946..3799af681775 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -58,6 +58,18 @@ static const struct nla_policy nldev_policy[RDMA_NLDEV_ATTR_MAX] = {
 					     .len = 16 },
 	[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_CURR] = { .type = NLA_U64 },
 	[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_MAX]	= { .type = NLA_U64 },
+	[RDMA_NLDEV_ATTR_RES_QP]		= { .type = NLA_NESTED },
+	[RDMA_NLDEV_ATTR_RES_QP_ENTRY]		= { .type = NLA_NESTED },
+	[RDMA_NLDEV_ATTR_RES_LQPN]		= { .type = NLA_U32 },
+	[RDMA_NLDEV_ATTR_RES_RQPN]		= { .type = NLA_U32 },
+	[RDMA_NLDEV_ATTR_RES_RQ_PSN]		= { .type = NLA_U32 },
+	[RDMA_NLDEV_ATTR_RES_SQ_PSN]		= { .type = NLA_U32 },
+	[RDMA_NLDEV_ATTR_RES_PATH_MIG_STATE] = { .type = NLA_U8 },
+	[RDMA_NLDEV_ATTR_RES_TYPE]		= { .type = NLA_U8 },
+	[RDMA_NLDEV_ATTR_RES_STATE]		= { .type = NLA_U8 },
+	[RDMA_NLDEV_ATTR_RES_PID]		= { .type = NLA_U32 },
+	[RDMA_NLDEV_ATTR_RES_PID_COMM]	= { .type = NLA_NUL_STRING,
+						    .len = TASK_COMM_LEN },
 };
 
 static int fill_nldev_handle(struct sk_buff *msg, struct ib_device *device)
@@ -213,6 +225,74 @@ static int fill_res_info(struct sk_buff *msg, struct ib_device *device)
 	return ret;
 }
 
+static int fill_res_qp_entry(struct sk_buff *msg,
+			     struct ib_qp *qp, uint32_t port)
+{
+	struct ib_qp_init_attr qp_init_attr;
+	struct nlattr *entry_attr;
+	struct ib_qp_attr qp_attr;
+	int ret;
+
+	ret = ib_query_qp(qp, &qp_attr, 0, &qp_init_attr);
+	if (ret)
+		return ret;
+
+	if (port && port != qp_attr.port_num)
+		return 0;
+
+	entry_attr = nla_nest_start(msg, RDMA_NLDEV_ATTR_RES_QP_ENTRY);
+	if (!entry_attr)
+		goto out;
+
+	/* In create_qp() port is not set yet */
+	if (qp_attr.port_num &&
+	    nla_put_u32(msg, RDMA_NLDEV_ATTR_PORT_INDEX, qp_attr.port_num))
+		goto err;
+
+	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_LQPN, qp->qp_num))
+		goto err;
+	if (qp->qp_type == IB_QPT_RC || qp->qp_type == IB_QPT_UC) {
+		if (nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_RQPN,
+				qp_attr.dest_qp_num))
+			goto err;
+		if (nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_RQ_PSN,
+				qp_attr.rq_psn))
+			goto err;
+	}
+
+	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_SQ_PSN, qp_attr.sq_psn))
+		goto err;
+
+	if (qp->qp_type == IB_QPT_RC || qp->qp_type == IB_QPT_UC ||
+	    qp->qp_type == IB_QPT_XRC_INI || qp->qp_type == IB_QPT_XRC_TGT) {
+		if (nla_put_u8(msg, RDMA_NLDEV_ATTR_RES_PATH_MIG_STATE,
+			       qp_attr.path_mig_state))
+			goto err;
+	}
+	if (nla_put_u8(msg, RDMA_NLDEV_ATTR_RES_TYPE, qp->qp_type))
+		goto err;
+	if (nla_put_u8(msg, RDMA_NLDEV_ATTR_RES_STATE, qp_attr.qp_state))
+		goto err;
+
+	/* PID == 0 means that this QP was created by kernel */
+	if (qp->res.pid && nla_put_u32(msg,
+				       RDMA_NLDEV_ATTR_RES_PID, qp->res.pid))
+		goto err;
+
+	if (nla_put_string(msg,
+			   RDMA_NLDEV_ATTR_RES_PID_COMM, qp->res.task_comm))
+		goto err;
+
+	nla_nest_end(msg, entry_attr);
+
+	return 0;
+
+err:
+	nla_nest_cancel(msg, entry_attr);
+out:
+	return -EMSGSIZE;
+}
+
 static int nldev_get_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 			  struct netlink_ext_ack *extack)
 {
@@ -486,6 +566,134 @@ static int nldev_res_get_dumpit(struct sk_buff *skb,
 	return ib_enum_all_devs(_nldev_res_get_dumpit, skb, cb);
 }
 
+static int nldev_res_get_qp_dumpit(struct sk_buff *skb,
+				   struct netlink_callback *cb)
+{
+	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX];
+	struct rdma_restrack_entry *res, *nxt;
+	int err, ret, key, idx = 0;
+	struct nlattr *table_attr;
+	struct ib_device *device;
+	int start = cb->args[0];
+	struct nlmsghdr *nlh;
+	u32 index, port = 0;
+	struct ib_qp *qp;
+
+	err = nlmsg_parse(cb->nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
+			  nldev_policy, NULL);
+	/*
+	 * Right now, we are expecting the device index to get QP information,
+	 * but it is possible to extend this code to return all devices in
+	 * one shot by checking the existence of RDMA_NLDEV_ATTR_DEV_INDEX.
+	 * if it doesn't exist, we will iterate over all devices.
+	 *
+	 * But it is not needed for now.
+	 */
+	if (err || !tb[RDMA_NLDEV_ATTR_DEV_INDEX])
+		return -EINVAL;
+
+	index = nla_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
+	device = ib_device_get_by_index(index);
+	if (!device)
+		return -EINVAL;
+
+	/*
+	 * If no PORT_INDEX is supplied, we will return QPs from whole device
+	 */
+	if (tb[RDMA_NLDEV_ATTR_PORT_INDEX]) {
+		port = nla_get_u32(tb[RDMA_NLDEV_ATTR_PORT_INDEX]);
+		if (!rdma_is_port_valid(device, port)) {
+			ret = -EINVAL;
+			goto err_index;
+		}
+	}
+
+	nlh = nlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
+			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV, RDMA_NLDEV_CMD_RES_QP_GET),
+			0, NLM_F_MULTI);
+
+	if (fill_nldev_handle(skb, device)) {
+		ret = -EMSGSIZE;
+		goto err;
+	}
+
+	table_attr = nla_nest_start(skb, RDMA_NLDEV_ATTR_RES_QP);
+	if (!table_attr) {
+		ret = -EMSGSIZE;
+		goto err;
+	}
+
+	rdma_restrack_lock(&device->res, RDMA_RESTRACK_QP);
+	for_each_res_safe(res, nxt, RDMA_RESTRACK_QP, device) {
+		if (idx < start) {
+			idx++;
+			continue;
+		}
+
+		if (!res->valid)
+			/*
+			 * It can be if resource failed to initialize srcu,
+			 * in other cases internal to restrack lock will esnure
+			 * that this list has only valid entries.
+			 */
+			continue;
+
+		key = srcu_read_lock(&res->srcu);
+
+		qp = container_of(res, struct ib_qp, res);
+		/*
+		 * We are releasing the object list lock to ensure that
+		 * object creation/destroy doesn't can progress while
+		 * we are getting information about QP.
+		 *
+		 * It is needed to prevent writer starvation, because of
+		 * large number of reources in object list.
+		 */
+		rdma_restrack_unlock(&device->res, RDMA_RESTRACK_QP);
+		ret = fill_res_qp_entry(skb, qp, port);
+		rdma_restrack_lock(&device->res, RDMA_RESTRACK_QP);
+
+		/*
+		 * There is a need to ensure that next QP is valid,
+		 * because we dropped the lock protecting our linked list.
+		 *
+		 * The RCU protection of "res" ensures that it is safe.
+		 */
+		list_safe_reset_next(res, nxt, list);
+
+		srcu_read_unlock(&res->srcu, key);
+
+		if (ret == -EMSGSIZE)
+			/*
+			 * There is a chance to optimize here.
+			 * It can be done by using list_prepare_entry
+			 * and list_for_each_entry_continue afterwards.
+			 */
+			break;
+		if (ret)
+			goto res_err;
+		idx++;
+	}
+	rdma_restrack_unlock(&device->res, RDMA_RESTRACK_QP);
+
+	nla_nest_end(skb, table_attr);
+	nlmsg_end(skb, nlh);
+	cb->args[0] = idx;
+	put_device(&device->dev);
+	return 0;
+
+res_err:
+	nla_nest_cancel(skb, table_attr);
+	rdma_restrack_unlock(&device->res, RDMA_RESTRACK_QP);
+
+err:
+	nlmsg_cancel(skb, nlh);
+
+err_index:
+	put_device(&device->dev);
+	return ret;
+}
+
 static const struct rdma_nl_cbs nldev_cb_table[RDMA_NLDEV_NUM_OPS] = {
 	[RDMA_NLDEV_CMD_GET] = {
 		.doit = nldev_get_doit,
@@ -499,6 +707,19 @@ static const struct rdma_nl_cbs nldev_cb_table[RDMA_NLDEV_NUM_OPS] = {
 		.doit = nldev_res_get_doit,
 		.dump = nldev_res_get_dumpit,
 	},
+	[RDMA_NLDEV_CMD_RES_QP_GET] = {
+		.dump = nldev_res_get_qp_dumpit,
+		/*
+		 * .doit is not implemented yet for two reasons:
+		 * 1. It is not needed yet.
+		 * 2. There is a need to provide identifier, while it is easy
+		 * for the QPs (device index + port index + LQPN), it is not
+		 * the case for the rest of resources (PD and CQ). Because it
+		 * is better to provide similar interface for all resources,
+		 * let's wait till we will have other resources implemented
+		 * too.
+		 */
+	},
 };
 
 void __init nldev_init(void)
diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
index e041d2eca4b8..9a90cd9f614e 100644
--- a/include/uapi/rdma/rdma_netlink.h
+++ b/include/uapi/rdma/rdma_netlink.h
@@ -241,6 +241,11 @@ enum rdma_nldev_command {
 	RDMA_NLDEV_CMD_RES_NEW,
 	RDMA_NLDEV_CMD_RES_DEL,
 
+	RDMA_NLDEV_CMD_RES_QP_GET, /* can dump */
+	RDMA_NLDEV_CMD_RES_QP_SET,
+	RDMA_NLDEV_CMD_RES_QP_NEW,
+	RDMA_NLDEV_CMD_RES_QP_DEL,
+
 	RDMA_NLDEV_NUM_OPS
 };
 
@@ -314,6 +319,44 @@ enum rdma_nldev_attr {
 	RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_CURR,	/* u64 */
 	RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_MAX,	/* u64 */
 
+	RDMA_NLDEV_ATTR_RES_QP,			/* nested table */
+	RDMA_NLDEV_ATTR_RES_QP_ENTRY,		/* nested table */
+	/*
+	 * Local QPN
+	 */
+	RDMA_NLDEV_ATTR_RES_LQPN,		/* u32 */
+	/*
+	 * Remote QPN,
+	 * Applicable for RC and UC only IBTA 11.2.5.3 QUERY QUEUE PAIR
+	 */
+	RDMA_NLDEV_ATTR_RES_RQPN,		/* u32 */
+	/*
+	 * Receive Queue PSN,
+	 * Applicable for RC and UC only 11.2.5.3 QUERY QUEUE PAIR
+	 */
+	RDMA_NLDEV_ATTR_RES_RQ_PSN,		/* u32 */
+	/*
+	 * Send Queue PSN
+	 */
+	RDMA_NLDEV_ATTR_RES_SQ_PSN,		/* u32 */
+	RDMA_NLDEV_ATTR_RES_PATH_MIG_STATE,	/* u8 */
+	/*
+	 * QP types as visible to RDMA/core, the reserved QPT
+	 * are not exported through this interface.
+	 */
+	RDMA_NLDEV_ATTR_RES_TYPE,		/* u8 */
+	RDMA_NLDEV_ATTR_RES_STATE,		/* u8 */
+	/*
+	 * Process ID created QP, in case of kernel PID is equal to 0
+	 * and this field won't be set, so user will distinguish user/kernel
+	 * processes without relying on PID number.
+	 */
+	RDMA_NLDEV_ATTR_RES_PID,		/* u32 */
+	/*
+	 * The name of process created following resource.
+	 */
+	RDMA_NLDEV_ATTR_RES_PID_COMM,		/* string */
+
 	RDMA_NLDEV_ATTR_MAX
 };
 #endif /* _UAPI_RDMA_NETLINK_H */
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
