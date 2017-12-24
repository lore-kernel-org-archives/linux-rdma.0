From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 7/8] RDMA/nldev: Protect port query from accidental device removal
Date: Sun, 24 Dec 2017 15:43:27 +0200
Message-ID: <20171224134328.17398-8-leon@kernel.org>
References: <20171224134328.17398-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171224134328.17398-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

There is a chance that device will be removed during port query
operations and it will cause to kernel panic in the flows which doesn't
hold lists_rwsem semaphore.

Fixes: c3f66f7b0052 ("RDMA/netlink: Implement nldev port doit callback")
Fixes: 7d02f605f0dc ("RDMA/netlink: Add nldev port dumpit implementation")
Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/nldev.c | 37 +++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index e3033d7a4029..ed7e639e7dee 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -223,41 +223,48 @@ static int nldev_port_get_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
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
@@ -278,7 +285,7 @@ static int nldev_port_get_dumpit(struct sk_buff *skb,
 		return -EINVAL;
 
 	ifindex = nla_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
-	device = __ib_device_get_by_index(ifindex);
+	device = ib_device_get_by_index(ifindex);
 	if (!device)
 		return -EINVAL;
 
@@ -312,7 +319,9 @@ static int nldev_port_get_dumpit(struct sk_buff *skb,
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
