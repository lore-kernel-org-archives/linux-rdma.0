From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [RFC PATCH rdma-next 06/14] RDMA/netlink: Protect device query from device removal
Date: Thu, 21 Dec 2017 20:17:40 +0200
Message-ID: <20171221181748.17126-7-leon@kernel.org>
References: <20171221181748.17126-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171221181748.17126-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

There is a chance that device will be removed during device query
operations and it will cause to kernel panic in the flows which
doesn't hold lists_rwsem semaphore.

Fixes: e5c9469efcb1 ("RDMA/netlink: Add nldev device doit implementation")
Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/nldev.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 2b631307349d..e3033d7a4029 100644
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
--
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
