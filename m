From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] RDMA/nldev: Fix multiple potential NULL pointer dereferences
Date: Fri, 9 Feb 2018 00:37:02 -0600
Message-ID: <20180209063702.GA28685@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <garsilva@embeddedor.com>
List-Id: linux-rdma@vger.kernel.org

In case the message header and payload cannot be stored, function
nlmsg_put returns null.

Fix this by adding multiple sanity checks and avoid a potential
null dereference on _nlh_ when calling nlmsg_end.

Addresses-Coverity-ID: 1454215 ("Dereference null return value")
Addresses-Coverity-ID: 1454223 ("Dereference null return value")
Addresses-Coverity-ID: 1454224 ("Dereference null return value")
Addresses-Coverity-ID: 1464669 ("Dereference null return value")
Addresses-Coverity-ID: 1464670 ("Dereference null return value")
Addresses-Coverity-ID: 1464672 ("Dereference null return value")
Fixes: e5c9469efcb1 ("RDMA/netlink: Add nldev device doit implementation")
Fixes: c3f66f7b0052 ("RDMA/netlink: Implement nldev port doit callback")
Fixes: 7d02f605f0dc ("RDMA/netlink: Add nldev port dumpit implementation")
Fixes: b5fa635aab8f ("RDMA/nldev: Provide detailed QP information")
Fixes: bf3c5a93c523 ("RDMA/nldev: Provide global resource utilization")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/infiniband/core/nldev.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 5326a68..dc8f6eb 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -313,6 +313,11 @@ static int nldev_get_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	nlh = nlmsg_put(msg, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
 			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV, RDMA_NLDEV_CMD_GET),
 			0, 0);
+	if (!nlh) {
+		err = -EMSGSIZE;
+		goto err_free;
+
+	}
 
 	err = fill_dev_info(msg, device);
 	if (err)
@@ -344,6 +349,8 @@ static int _nldev_get_dumpit(struct ib_device *device,
 	nlh = nlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
 			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV, RDMA_NLDEV_CMD_GET),
 			0, NLM_F_MULTI);
+	if (!nlh)
+		goto out;
 
 	if (fill_dev_info(skb, device)) {
 		nlmsg_cancel(skb, nlh);
@@ -354,7 +361,8 @@ static int _nldev_get_dumpit(struct ib_device *device,
 
 	idx++;
 
-out:	cb->args[0] = idx;
+out:
+	cb->args[0] = idx;
 	return skb->len;
 }
 
@@ -404,6 +412,10 @@ static int nldev_port_get_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	nlh = nlmsg_put(msg, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
 			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV, RDMA_NLDEV_CMD_GET),
 			0, 0);
+	if (!nlh) {
+		err = -EMSGSIZE;
+		goto err_free;
+	}
 
 	err = fill_port_info(msg, device, port);
 	if (err)
@@ -464,6 +476,8 @@ static int nldev_port_get_dumpit(struct sk_buff *skb,
 				RDMA_NL_GET_TYPE(RDMA_NL_NLDEV,
 						 RDMA_NLDEV_CMD_PORT_GET),
 				0, NLM_F_MULTI);
+		if (!nlh)
+			goto out;
 
 		if (fill_port_info(skb, device, p)) {
 			nlmsg_cancel(skb, nlh);
@@ -507,6 +521,10 @@ static int nldev_res_get_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	nlh = nlmsg_put(msg, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
 			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV, RDMA_NLDEV_CMD_RES_GET),
 			0, 0);
+	if (!nlh) {
+		ret = -EMSGSIZE;
+		goto err_free;
+	}
 
 	ret = fill_res_info(msg, device);
 	if (ret)
@@ -537,6 +555,8 @@ static int _nldev_res_get_dumpit(struct ib_device *device,
 	nlh = nlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
 			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV, RDMA_NLDEV_CMD_RES_GET),
 			0, NLM_F_MULTI);
+	if (!nlh)
+		goto out;
 
 	if (fill_res_info(skb, device)) {
 		nlmsg_cancel(skb, nlh);
@@ -603,6 +623,10 @@ static int nldev_res_get_qp_dumpit(struct sk_buff *skb,
 	nlh = nlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
 			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV, RDMA_NLDEV_CMD_RES_QP_GET),
 			0, NLM_F_MULTI);
+	if (!nlh) {
+		ret = -EMSGSIZE;
+		goto err_index;
+	}
 
 	if (fill_nldev_handle(skb, device)) {
 		ret = -EMSGSIZE;
-- 
2.7.4
