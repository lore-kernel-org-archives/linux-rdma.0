From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH RESEND v1 rdma-next 6/6] RDMA/nldev: provide detailed PD
 information
Date: Fri, 2 Feb 2018 13:24:44 -0800
Message-ID: <f272bfd34c913d540bd74008cccfa2544d8e100f.1518552800.git.swise@opengridcomputing.com>
References: <cover.1518552800.git.swise@opengridcomputing.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1518552800.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Implement the RDMA nldev netlink interface for dumping detailed PD
information.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/core/nldev.c  | 173 +++++++++++++++++++++++++++++++++++++++
 include/uapi/rdma/rdma_netlink.h |   8 ++
 2 files changed, 181 insertions(+)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 8d96f3e..42cbec0 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -101,6 +101,11 @@
 	[RDMA_NLDEV_ATTR_RES_IOVA]		= { .type = NLA_U64 },
 	[RDMA_NLDEV_ATTR_RES_MRLEN]		= { .type = NLA_U64 },
 	[RDMA_NLDEV_ATTR_RES_PGSIZE]		= { .type = NLA_U32 },
+	[RDMA_NLDEV_ATTR_RES_PD]		= { .type = NLA_NESTED },
+	[RDMA_NLDEV_ATTR_RES_PD_ENTRY]		= { .type = NLA_NESTED },
+	[RDMA_NLDEV_ATTR_RES_LOCAL_DMA_LKEY]	= { .type = NLA_U32 },
+	[RDMA_NLDEV_ATTR_RES_PD_FLAGS]		= { .type = NLA_U32 },
+	[RDMA_NLDEV_ATTR_RES_UNSAFE_GLOBAL_RKEY] = { .type = NLA_U32 },
 };
 
 static int fill_nldev_handle(struct sk_buff *msg, struct ib_device *device)
@@ -499,6 +504,53 @@ static int fill_res_mr_entry(struct sk_buff *msg,
 	return -EMSGSIZE;
 }
 
+static int fill_res_pd_entry(struct sk_buff *msg,
+			     struct ib_pd *pd)
+{
+	struct rdma_restrack_entry *res = &pd->res;
+	struct nlattr *entry_attr;
+
+	entry_attr = nla_nest_start(msg, RDMA_NLDEV_ATTR_RES_PD_ENTRY);
+	if (!entry_attr)
+		goto out;
+
+	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_LOCAL_DMA_LKEY,
+			pd->local_dma_lkey))
+		goto err;
+	if (nla_put_u64_64bit(msg, RDMA_NLDEV_ATTR_RES_USECNT,
+			      atomic_read(&pd->usecnt), 0))
+		goto err;
+	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_PD_FLAGS, pd->flags))
+		goto err;
+	if ((pd->flags & IB_PD_UNSAFE_GLOBAL_RKEY) &&
+	    nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_UNSAFE_GLOBAL_RKEY,
+			pd->unsafe_global_rkey))
+		goto err;
+
+	/*
+	 * Existence of task means that it is user PD and netlink
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
@@ -1269,6 +1321,124 @@ static int nldev_res_get_mr_dumpit(struct sk_buff *skb,
 	return ret;
 }
 
+static int nldev_res_get_pd_dumpit(struct sk_buff *skb,
+				   struct netlink_callback *cb)
+{
+	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX];
+	struct rdma_restrack_entry *res;
+	int err, ret = 0, idx = 0;
+	struct nlattr *table_attr;
+	struct ib_device *device;
+	int start = cb->args[0];
+	struct ib_pd *pd = NULL;
+	struct nlmsghdr *nlh;
+	u32 index;
+
+	err = nlmsg_parse(cb->nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
+			  nldev_policy, NULL);
+	/*
+	 * Right now, we are expecting the device index to get PD information,
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
+		RDMA_NL_GET_TYPE(RDMA_NL_NLDEV, RDMA_NLDEV_CMD_RES_PD_GET),
+		0, NLM_F_MULTI);
+
+	if (fill_nldev_handle(skb, device)) {
+		ret = -EMSGSIZE;
+		goto err;
+	}
+
+	table_attr = nla_nest_start(skb, RDMA_NLDEV_ATTR_RES_PD);
+	if (!table_attr) {
+		ret = -EMSGSIZE;
+		goto err;
+	}
+
+	down_read(&device->res.rwsem);
+	hash_for_each_possible(device->res.hash, res, node, RDMA_RESTRACK_PD) {
+		if (idx < start)
+			goto next;
+
+		if ((rdma_is_kernel_res(res) &&
+		     task_active_pid_ns(current) != &init_pid_ns) ||
+		    (!rdma_is_kernel_res(res) &&
+		     task_active_pid_ns(current) !=
+		     task_active_pid_ns(res->task)))
+			/*
+			 * 1. Kernel PDs should be visible in init namspace only
+			 * 2. Present only PDs visible in the current namespace
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
+		pd = container_of(res, struct ib_pd, res);
+
+		up_read(&device->res.rwsem);
+		ret = fill_res_pd_entry(skb, pd);
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
+	 * No more PDs to fill, cancel the message and
+	 * return 0 to mark end of dumpit.
+	 */
+	if (!pd)
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
@@ -1304,6 +1474,9 @@ static int nldev_res_get_mr_dumpit(struct sk_buff *skb,
 	[RDMA_NLDEV_CMD_RES_MR_GET] = {
 		.dump = nldev_res_get_mr_dumpit,
 	},
+	[RDMA_NLDEV_CMD_RES_PD_GET] = {
+		.dump = nldev_res_get_pd_dumpit,
+	},
 };
 
 void __init nldev_init(void)
diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
index 6adaeaa..4aeb59c 100644
--- a/include/uapi/rdma/rdma_netlink.h
+++ b/include/uapi/rdma/rdma_netlink.h
@@ -246,6 +246,8 @@ enum rdma_nldev_command {
 
 	RDMA_NLDEV_CMD_RES_MR_GET, /* can dump */
 
+	RDMA_NLDEV_CMD_RES_PD_GET, /* can dump */
+
 	RDMA_NLDEV_NUM_OPS
 };
 
@@ -400,6 +402,12 @@ enum rdma_nldev_attr {
 	RDMA_NLDEV_ATTR_RES_MRLEN,		/* u64 */
 	RDMA_NLDEV_ATTR_RES_PGSIZE,		/* u32 */
 
+	RDMA_NLDEV_ATTR_RES_PD,			/* nested table */
+	RDMA_NLDEV_ATTR_RES_PD_ENTRY,		/* nested table */
+	RDMA_NLDEV_ATTR_RES_LOCAL_DMA_LKEY,	/* u32 */
+	RDMA_NLDEV_ATTR_RES_PD_FLAGS,		/* u32 */
+	RDMA_NLDEV_ATTR_RES_UNSAFE_GLOBAL_RKEY,	/* u32 */
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
