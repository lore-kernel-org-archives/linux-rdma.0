From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v1 6/7] RDMA/netlink: Protect device and port queries from device removal
Date: Mon,  1 Jan 2018 13:07:16 +0200
Message-ID: <20180101110717.29686-7-leon@kernel.org>
References: <20180101110717.29686-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180101110717.29686-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

There is a chance that device will be removed during device query
operations and it will cause to kernel panic in the flows which
doesn't hold lists_rwsem semaphore.

Fixes: e5c9469efcb1 ("RDMA/netlink: Add nldev device doit implementation")
Fixes: c3f66f7b0052 ("RDMA/netlink: Implement nldev port doit callback")
Fixes: 7d02f605f0dc ("RDMA/netlink: Add nldev port dumpit implementation")
Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/core_priv.h |  1 -
 drivers/infiniband/core/device.c    |  5 ++-
 drivers/infiniband/core/nldev.c     | 62 +++++++++++++++++++++++--------------
 3 files changed, 42 insertions(+), 26 deletions(-)

diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index a7e516d720d7..8dbfc3ab48a6 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -294,7 +294,6 @@ static inline int ib_mad_enforce_security(struct ib_mad_agent_private *map,
 }
 #endif
 
-struct ib_device *__ib_device_get_by_index(u32 ifindex);
 struct ib_device *ib_device_get_by_index(u32 ifindex);
 /* RDMA device netlink */
 void nldev_init(void);
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 34c6cb2a0977..a0ea3dca479d 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -134,7 +134,10 @@ static int ib_device_check_mandatory(struct ib_device *device)
 	return 0;
 }
 
-struct ib_device *__ib_device_get_by_index(u32 index)
+/*
+ * Caller to this function should hold lists_rwsem
+ */
+static struct ib_device *__ib_device_get_by_index(u32 index)
 {
 	struct ib_device *device;
 
diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 2b631307349d..ed7e639e7dee 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -141,36 +141,41 @@ static int nldev_get_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct ib_device *device;
 	struct sk_buff *msg;
 	u32 index;
-	int err;
+	int ret = -ENOMEM;
 
-	err = nlmsg_parse(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
+	ret = nlmsg_parse(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
 			  nldev_policy, extack);
-	if (err || !tb[RDMA_NLDEV_ATTR_DEV_INDEX])
+	if (ret || !tb[RDMA_NLDEV_ATTR_DEV_INDEX])
 		return -EINVAL;
 
 	index = nla_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
 
-	device = __ib_device_get_by_index(index);
+	device = ib_device_get_by_index(index);
 	if (!device)
 		return -EINVAL;
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg)
-		return -ENOMEM;
+		goto err;
 
 	nlh = nlmsg_put(msg, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
 			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV, RDMA_NLDEV_CMD_GET),
 			0, 0);
 
-	err = fill_dev_info(msg, device);
-	if (err) {
-		nlmsg_free(msg);
-		return err;
-	}
+	ret = fill_dev_info(msg, device);
+	if (ret)
+		goto err_free;
 
 	nlmsg_end(msg, nlh);
 
+	put_device(&device->dev);
 	return rdma_nl_unicast(msg, NETLINK_CB(skb).portid);
+
+err_free:
+	nlmsg_free(msg);
+err:
+	put_device(&device->dev);
+	return ret;
 }
 
 static int _nldev_get_dumpit(struct ib_device *device,
@@ -218,41 +223,48 @@ static int nldev_port_get_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct sk_buff *msg;
 	u32 index;
 	u32 port;
-	int err;
+	int ret = -EINVAL;
 
-	err = nlmsg_parse(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
+	ret = nlmsg_parse(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
 			  nldev_policy, extack);
-	if (err ||
+	if (ret ||
 	    !tb[RDMA_NLDEV_ATTR_DEV_INDEX] ||
 	    !tb[RDMA_NLDEV_ATTR_PORT_INDEX])
 		return -EINVAL;
 
 	index = nla_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
-	device = __ib_device_get_by_index(index);
+	device = ib_device_get_by_index(index);
 	if (!device)
 		return -EINVAL;
 
 	port = nla_get_u32(tb[RDMA_NLDEV_ATTR_PORT_INDEX]);
 	if (!rdma_is_port_valid(device, port))
-		return -EINVAL;
+		goto err;
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (!msg)
-		return -ENOMEM;
+	if (!msg) {
+		ret = -ENOMEM;
+		goto err;
+	}
 
 	nlh = nlmsg_put(msg, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
 			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV, RDMA_NLDEV_CMD_GET),
 			0, 0);
 
-	err = fill_port_info(msg, device, port);
-	if (err) {
-		nlmsg_free(msg);
-		return err;
-	}
+	ret = fill_port_info(msg, device, port);
+	if (ret)
+		goto err_free;
 
 	nlmsg_end(msg, nlh);
+	put_device(&device->dev);
 
 	return rdma_nl_unicast(msg, NETLINK_CB(skb).portid);
+
+err_free:
+	nlmsg_free(msg);
+err:
+	put_device(&device->dev);
+	return ret;
 }
 
 static int nldev_port_get_dumpit(struct sk_buff *skb,
@@ -273,7 +285,7 @@ static int nldev_port_get_dumpit(struct sk_buff *skb,
 		return -EINVAL;
 
 	ifindex = nla_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
-	device = __ib_device_get_by_index(ifindex);
+	device = ib_device_get_by_index(ifindex);
 	if (!device)
 		return -EINVAL;
 
@@ -307,7 +319,9 @@ static int nldev_port_get_dumpit(struct sk_buff *skb,
 		nlmsg_end(skb, nlh);
 	}
 
-out:	cb->args[0] = idx;
+out:
+	put_device(&device->dev);
+	cb->args[0] = idx;
 	return skb->len;
 }
 
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
