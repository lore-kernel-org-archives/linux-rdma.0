From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2 rdma: Ignore unknown netlink attributes
Date: Tue,  3 Apr 2018 10:28:42 +0300
Message-ID: <20180403072842.32153-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, David Ahern <dsahern@gmail.com>, Steve Wise <swise@opengridcomputing.com>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

The check if netlink attributes supplied more than maximum supported
is to strict and may lead to backward compatibility issues with old
application with a newer kernel that supports new attribute.

CC: Steve Wise <swise@opengridcomputing.com>
Fixes: 74bd75c2b68d ("rdma: Add basic infrastructure for RDMA tool")
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/utils.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/rdma/utils.c b/rdma/utils.c
index a2e08e91..5c1e736a 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -399,7 +399,8 @@ int rd_attr_cb(const struct nlattr *attr, void *data)
 	int type;

 	if (mnl_attr_type_valid(attr, RDMA_NLDEV_ATTR_MAX) < 0)
-		return MNL_CB_ERROR;
+		/* We received uknown attribute */
+		return MNL_CB_OK;

 	type = mnl_attr_get_type(attr);
