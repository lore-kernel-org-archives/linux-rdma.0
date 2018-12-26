From: Kangjie Lu <kjlu@umn.edu>
Subject: [PATCH] infiniband: fix a missing check of nla_put
Date: Tue, 25 Dec 2018 20:05:48 -0600
Message-ID: <20181226020549.71446-1-kjlu@umn.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kjlu@umn.edu
Cc: pakki001@umn.edu, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Parav Pandit <parav@mellanox.com>, Daniel Jurgens <danielj@mellanox.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

nla_put() may fail. The fix adds a check for its return value, and
returns -EMSGSIZE if it fails.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/infiniband/core/addr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index 0dce94e3c495..32d033ebaa5b 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -178,7 +178,8 @@ static int ib_nl_ip_send_msg(struct rdma_dev_addr *dev_addr,
 	/* Construct the family header first */
 	header = skb_put(skb, NLMSG_ALIGN(sizeof(*header)));
 	header->ifindex = dev_addr->bound_dev_if;
-	nla_put(skb, attrtype, size, daddr);
+	if (nla_put(skb, attrtype, size, daddr))
+		return -EMSGSIZE;
 
 	/* Repair the nlmsg header length */
 	nlmsg_end(skb, nlh);
-- 
2.17.2 (Apple Git-113)
