From: Aditya Pakki <pakki001@umn.edu>
Subject: [PATCH] [V2] infiniband: fix a missing check of nla_put
Date: Sat,  5 Jan 2019 10:18:07 -0600
Message-ID: <20190105161808.3496-1-pakki001@umn.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: pakki001@umn.edu
Cc: kjlu@umn.edu, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Parav Pandit <parav@mellanox.com>, Daniel Jurgens <danielj@mellanox.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

nla_put() may fail. The fix adds a check for its return value, and
returns -EMSGSIZE if it fails, post canceling netlink msg.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
---
 drivers/infiniband/core/addr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index 0dce94e3c495..e847b34bacd1 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -178,7 +178,10 @@ static int ib_nl_ip_send_msg(struct rdma_dev_addr *dev_addr,
 	/* Construct the family header first */
 	header = skb_put(skb, NLMSG_ALIGN(sizeof(*header)));
 	header->ifindex = dev_addr->bound_dev_if;
-	nla_put(skb, attrtype, size, daddr);
+	if (nla_put(skb, attrtype, size, daddr)) {
+		nlmsg_cancel(skb, nlh);
+		return -EMSGSIZE;
+	}
 
 	/* Repair the nlmsg header length */
 	nlmsg_end(skb, nlh);
-- 
2.17.1
