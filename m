From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next] rdma: Add the prefix for driver attributes
Date: Wed, 27 Feb 2019 08:41:51 +0200
Message-ID: <20190227064151.25445-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>, Lijun Ou <oulijun@huawei.com>, Steve Wise <swise@opengridcomputing.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

There is a need to distinguish between driver vs. general exposed
attributes. The most common use case is to expose some internal
garbage under extremely common and sexy name, e.g. pi, ci e.t.c

In order to achieve that, we will add "drv_" prefix to all strings
which were received through RDMA_NLDEV_ATTR_DRIVER_* attributes.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>a
---
 rdma/utils.c | 34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/rdma/utils.c b/rdma/utils.c
index 6bc14cd5..1f6bf330 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -829,27 +829,37 @@ static int print_driver_entry(struct rd *rd, struct nlattr *key_attr,
 				struct nlattr *val_attr,
 				enum rdma_nldev_print_type print_type)
 {
-	const char *key_str = mnl_attr_get_str(key_attr);
 	int attr_type = nla_type(val_attr);
+	int ret = -EINVAL;
+	char *key_str;
+
+	if (asprintf(&key_str, "drv_%s", mnl_attr_get_str(key_attr)) == -1)
+		return -ENOMEM;

 	switch (attr_type) {
 	case RDMA_NLDEV_ATTR_DRIVER_STRING:
-		return print_driver_string(rd, key_str,
-				mnl_attr_get_str(val_attr));
+		ret = print_driver_string(rd, key_str,
+					  mnl_attr_get_str(val_attr));
+		break;
 	case RDMA_NLDEV_ATTR_DRIVER_S32:
-		return print_driver_s32(rd, key_str,
-				mnl_attr_get_u32(val_attr), print_type);
+		ret = print_driver_s32(rd, key_str, mnl_attr_get_u32(val_attr),
+				       print_type);
+		break;
 	case RDMA_NLDEV_ATTR_DRIVER_U32:
-		return print_driver_u32(rd, key_str,
-				mnl_attr_get_u32(val_attr), print_type);
+		ret = print_driver_u32(rd, key_str, mnl_attr_get_u32(val_attr),
+				       print_type);
+		break;
 	case RDMA_NLDEV_ATTR_DRIVER_S64:
-		return print_driver_s64(rd, key_str,
-				mnl_attr_get_u64(val_attr), print_type);
+		ret = print_driver_s64(rd, key_str, mnl_attr_get_u64(val_attr),
+				       print_type);
+		break;
 	case RDMA_NLDEV_ATTR_DRIVER_U64:
-		return print_driver_u64(rd, key_str,
-				mnl_attr_get_u64(val_attr), print_type);
+		ret = print_driver_u64(rd, key_str, mnl_attr_get_u64(val_attr),
+				       print_type);
+		break;
 	}
-	return -EINVAL;
+	free(key_str);
+	return ret;
 }

 void print_driver_table(struct rd *rd, struct nlattr *tb)
