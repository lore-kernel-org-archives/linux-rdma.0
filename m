From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH RESEND v1 rdma-next 3/6] RDMA/nldev: provide detailed CQ
 information
Date: Thu, 1 Feb 2018 08:58:48 -0800
Message-ID: <624bf08040287a4c558f3b84d2bd60a9423b8dca.1518552800.git.swise@opengridcomputing.com>
References: <cover.1518552800.git.swise@opengridcomputing.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1518552800.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Implement the RDMA nldev netlink interface for dumping detailed
CQ information.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/core/nldev.c  | 172 +++++++++++++++++++++++++++++++++++++++
 include/uapi/rdma/rdma_netlink.h |   8 ++
 2 files changed, 180 insertions(+)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 13f5c46..34fb0d3 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -89,6 +89,11 @@
 	[RDMA_NLDEV_ATTR_RES_DEV_TYPE]		= { .type = NLA_U8 },
 	[RDMA_NLDEV_ATTR_RES_TRANSPORT_TYPE]	= { .type = NLA_U8 },
 	[RDMA_NLDEV_ATTR_RES_NETWORK_TYPE]	= { .type = NLA_U8 },
+	[RDMA_NLDEV_ATTR_RES_CQ]		= { .type = NLA_NESTED },
+	[RDMA_NLDEV_ATTR_RES_CQ_ENTRY]		= { .type = NLA_NESTED },
+	[RDMA_NLDEV_ATTR_RES_CQE]		= { .type = NLA_U32 },
+	[RDMA_NLDEV_ATTR_RES_USECNT]		= { .type = NLA_U64 },
+	[RDMA_NLDEV_ATTR_RES_POLL_CTX]		= { .type = NLA_U8 },
 };
 
 static int fill_nldev_handle(struct sk_buff *msg, struct ib_device *device)
@@ -396,6 +401,51 @@ static int fill_res_cm_id_entry(struct sk_buff *msg,
 	return -EMSGSIZE;
 }
 
+static int fill_res_cq_entry(struct sk_buff *msg,
+			     struct ib_cq *cq)
+{
+	struct rdma_restrack_entry *res = &cq->res;
+	struct nlattr *entry_attr;
+
+	entry_attr = nla_nest_start(msg, RDMA_NLDEV_ATTR_RES_CQ_ENTRY);
+	if (!entry_attr)
+		goto out;
+
+	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_CQE, cq->cqe))
+		goto err;
+	if (nla_put_u64_64bit(msg, RDMA_NLDEV_ATTR_RES_USECNT,
+			      atomic_read(&cq->usecnt), 0))
+		goto err;
+
+	/* Poll context is only valid for kernel CQs */
+	if (rdma_is_kernel_res(res) &&
+	    nla_put_u8(msg, RDMA_NLDEV_ATTR_RES_POLL_CTX, cq->poll_ctx))
+		goto err;
+
+	/*
+	 * Existence of task means that it is user CQ and netlink
+	 * user is invited to go and read /proc/PID/comm to get name
+	 * of the task file and res->task_com should be NULL.
+	 */
+	if (rdma_is_kernel_res(res)) {
+		if (nla_put_string(msg, RDMA_NLDEV_ATTR_RES_KERN_NAME,
+				   res->kern_name))
+			goto err;
+	} else {
+		if (nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_PID,
+				task_pid_vnr(res->task)))
+			goto err;
+	}
+
+	nla_nest_end(msg, entry_attr);
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
@@ -929,6 +979,125 @@ static int nldev_res_get_cm_id_dumpit(struct sk_buff *skb,
 	put_device(&device->dev);
 	return ret;
 }
+
+static int nldev_res_get_cq_dumpit(struct sk_buff *skb,
+				   struct netlink_callback *cb)
+{
+	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX];
+	struct rdma_restrack_entry *res;
+	int err, ret = 0, idx = 0;
+	struct nlattr *table_attr;
+	struct ib_device *device;
+	int start = cb->args[0];
+	struct ib_cq *cq = NULL;
+	struct nlmsghdr *nlh;
+	u32 index;
+
+	err = nlmsg_parse(cb->nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
+			  nldev_policy, NULL);
+	/*
+	 * Right now, we are expecting the device index to get CQ information,
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
+	nlh = nlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
+		RDMA_NL_GET_TYPE(RDMA_NL_NLDEV, RDMA_NLDEV_CMD_RES_CQ_GET),
+		0, NLM_F_MULTI);
+
+	if (fill_nldev_handle(skb, device)) {
+		ret = -EMSGSIZE;
+		goto err;
+	}
+
+	table_attr = nla_nest_start(skb, RDMA_NLDEV_ATTR_RES_CQ);
+	if (!table_attr) {
+		ret = -EMSGSIZE;
+		goto err;
+	}
+
+	down_read(&device->res.rwsem);
+	hash_for_each_possible(device->res.hash, res, node, RDMA_RESTRACK_CQ) {
+		if (idx < start)
+			goto next;
+
+		if ((rdma_is_kernel_res(res) &&
+		     task_active_pid_ns(current) != &init_pid_ns) ||
+		    (!rdma_is_kernel_res(res) &&
+		     task_active_pid_ns(current) !=
+		     task_active_pid_ns(res->task)))
+			/*
+			 * 1. Kernel CQs should be visible in init namspace only
+			 * 2. Present only CQs visible in the current namespace
+			 */
+			goto next;
+
+		if (!rdma_restrack_get(res))
+			/*
+			 * Resource is under release now, but we are not
+			 * relesing lock now, so it will be released in
+			 * our next pass, once we will get ->next pointer.
+			 */
+			goto next;
+
+		cq = container_of(res, struct ib_cq, res);
+
+		up_read(&device->res.rwsem);
+		ret = fill_res_cq_entry(skb, cq);
+		down_read(&device->res.rwsem);
+		/*
+		 * Return resource back, but it won't be released till
+		 * the &device->res.rwsem will be released for write.
+		 */
+		rdma_restrack_put(res);
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
+next:		idx++;
+	}
+	up_read(&device->res.rwsem);
+
+	nla_nest_end(skb, table_attr);
+	nlmsg_end(skb, nlh);
+	cb->args[0] = idx;
+
+	/*
+	 * No more CQs to fill, cancel the message and
+	 * return 0 to mark end of dumpit.
+	 */
+	if (!cq)
+		goto err;
+
+	put_device(&device->dev);
+	return skb->len;
+
+res_err:
+	nla_nest_cancel(skb, table_attr);
+	up_read(&device->res.rwsem);
+
+err:
+	nlmsg_cancel(skb, nlh);
+	put_device(&device->dev);
+	return ret;
+}
+
 static const struct rdma_nl_cbs nldev_cb_table[RDMA_NLDEV_NUM_OPS] = {
 	[RDMA_NLDEV_CMD_GET] = {
 		.doit = nldev_get_doit,
@@ -958,6 +1127,9 @@ static int nldev_res_get_cm_id_dumpit(struct sk_buff *skb,
 	[RDMA_NLDEV_CMD_RES_CM_ID_GET] = {
 		.dump = nldev_res_get_cm_id_dumpit,
 	},
+	[RDMA_NLDEV_CMD_RES_CQ_GET] = {
+		.dump = nldev_res_get_cq_dumpit,
+	},
 };
 
 void __init nldev_init(void)
diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
index 13f0bed..fa677ef 100644
--- a/include/uapi/rdma/rdma_netlink.h
+++ b/include/uapi/rdma/rdma_netlink.h
@@ -242,6 +242,8 @@ enum rdma_nldev_command {
 
 	RDMA_NLDEV_CMD_RES_CM_ID_GET, /* can dump */
 
+	RDMA_NLDEV_CMD_RES_CQ_GET, /* can dump */
+
 	RDMA_NLDEV_NUM_OPS
 };
 
@@ -382,6 +384,12 @@ enum rdma_nldev_attr {
 	 */
 	RDMA_NLDEV_ATTR_RES_NETWORK_TYPE,	/* u8 */
 
+	RDMA_NLDEV_ATTR_RES_CQ,			/* nested table */
+	RDMA_NLDEV_ATTR_RES_CQ_ENTRY,		/* nested table */
+	RDMA_NLDEV_ATTR_RES_CQE,		/* u32 */
+	RDMA_NLDEV_ATTR_RES_USECNT,		/* u64 */
+	RDMA_NLDEV_ATTR_RES_POLL_CTX,		/* u8 */
+
 	RDMA_NLDEV_ATTR_MAX
 };
 #endif /* _UAPI_RDMA_NETLINK_H */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
