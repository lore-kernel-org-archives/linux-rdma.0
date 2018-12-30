From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-rc] rdma: Fix incorrectly handled NLA validation
Date: Sun, 30 Dec 2018 15:34:09 +0200
Message-ID: <20181230133409.20446-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Leon Romanovsky <leonro@mellanox.com>, David Ahern <dsahern@gmail.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

mnl_attr_type_valid() receives maximum attribute type, which means that
we were supposed to supply the latest valid netlink attribute and not
the number of attributes. Such coding mistake caused to failures while
NLA attributes were extended.

Fixes: 74bd75c2b68d ("rdma: Add basic infrastructure for RDMA tool")
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/utils.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/rdma/utils.c b/rdma/utils.c
index 61f4aeb1..069d44fe 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -425,8 +425,8 @@ int rd_attr_cb(const struct nlattr *attr, void *data)
 	const struct nlattr **tb = data;
 	int type;

-	if (mnl_attr_type_valid(attr, RDMA_NLDEV_ATTR_MAX) < 0)
-		/* We received uknown attribute */
+	if (mnl_attr_type_valid(attr, RDMA_NLDEV_ATTR_MAX - 1) < 0)
+		/* We received unknown attribute */
 		return MNL_CB_OK;

 	type = mnl_attr_get_type(attr);
