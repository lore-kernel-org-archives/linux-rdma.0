Received: from outbound.baidu.com (mx22.baidu.com [220.181.50.185])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 360782C3244
	for <linux-rdma@vger.kernel.org>; Fri, 18 Sep 2026 09:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.181.50.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789723443; cv=none; b=VQyoyzh+z2TvEpP7xZEB+NUJ7U4zLNQH0CkpojJzLyMMAYOEP9frJ8sH4Ll1YgwbHXsxlv0AoIoocQVsi1J6yZa/6aPnKckk+bJKvODD7ZoXFAxMKsPVg/y8X30+kTObI8QxD0N8W3O+Kz+NqgZrjCi3ajySrMQ4jE4l36i+vjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789723443; c=relaxed/simple;
	bh=MZn/9kex4cY91BsmvkMUxqpQmlR0MhskeY0k7cen+ME=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=BLldkruo0Gx5xAVLxVl+td3Wv7ZpJmcIpFGtAgsjluh2t5J8XLb5FisoIl7r6ctYvIUpAhow4ZnliFr7vhWPYeblFCsUWWYc6gnB2gD4mlVDEFc1XT1q4d4L1JR47TqY58QoGwSzfptXe8exoQ8OBilk8yHeRcONQzx9xSvd6/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b=aYpCH/3w; arc=none smtp.client-ip=220.181.50.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b="aYpCH/3w"
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Zhu
 Yanjun <yanjun.zhu@linux.dev>, <linux-rdma@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH v2] RDMA/mlx5: Use DEFINE_RAW_FLEX for leftovers flow attributes
Date: Fri, 18 Sep 2026 17:23:37 +0800
Message-ID: <20260918092337.2338-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: bjkjy-exc7.internal.baidu.com (172.31.50.51) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1789723427;
	bh=uemA0jIPc5Zw8zvG1K8gBbtEVgXhG81LtyAcyFUkQ2s=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=aYpCH/3w4OpRWFkfUEWNpLcZ7UgZvF6MiNx1sn5Z/wmOjWO0E8YBf9BkwOzOJBCfT
	 3+ZVvR694bqu2yJCC2TdLouaKUxsn6zOduhxsiAB9zgC0AJrPZfxraGCffovHDkjJ2
	 UXkl53JWVI67rmQguC1gcubVqQcYbrF2WDBzHk8/5oNZTlbT8R0yYqD3WjPuUHaPAp
	 LtQP8cRDqhNfO4jvSxcMZOGrU3RGEJYHB4u3w8ICpjcNAwherOlx/9rgtTcx0shsk8
	 6RIVWaFa9R4MeR0kyskHEelQY+45Bx70Vxh1poLXowQAHTlDUx8JquXjTM7zr1bT6z
	 JiV9lnUdctmNw==

From: Li RongQing <lirongqing@baidu.com>

Commit e91fb8b9d0ed ("RDMA/mlx5: Avoid flexible array warning") split
the leftovers_specs[] array into two separate structs to silence the
sparse "array of flexible structures" warning, but in doing so reversed
the member order: eth_flow was placed before flow_attr.

_create_flow_rule() locates the flow specs with:

    ib_flow = (void *)flow_attr + sizeof(*flow_attr);

which expects the spec data to immediately follow the ib_flow_attr.
With the reversed order, flow_attr is the last member, so ib_flow
points past the end of the struct and the num_of_specs = 1 loop reads
out-of-bounds memory (whatever static data follows in the .data
section), producing incorrect flow rules or a crash.

Rebuild the leftovers attributes with DEFINE_RAW_FLEX(), which declares
an on-stack struct ib_flow_attr with a properly sized trailing flows[]
array.  The ETH spec lives in flows[0].eth at exactly the offset
_create_flow_rule() expects, so no layout-dependent composite struct is
needed.  This also avoids embedding a structure that contains a flexible
array member as a non-last member, which would trigger
-Wflex-array-member-not-at-end once the warning is enabled.

Fixes: e91fb8b9d0ed ("RDMA/mlx5: Avoid flexible array warning")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 drivers/infiniband/hw/mlx5/fs.c | 45 +++++++++++++++++++----------------------
 1 file changed, 21 insertions(+), 24 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/fs.c b/drivers/infiniband/hw/mlx5/fs.c
index 98cdc5c..e63fdb4 100644
--- a/drivers/infiniband/hw/mlx5/fs.c
+++ b/drivers/infiniband/hw/mlx5/fs.c
@@ -17,6 +17,7 @@
 #include <linux/mlx5/fs.h>
 #include <linux/mlx5/fs_helpers.h>
 #include <linux/mlx5/eswitch.h>
+#include <linux/overflow.h>
 #include <net/inet_ecn.h>
 #include "mlx5_ib.h"
 #include "counters.h"
@@ -1647,36 +1648,32 @@ static struct mlx5_ib_flow_handler *create_leftovers_rule(struct mlx5_ib_dev *de
 							  struct ib_flow_attr *flow_attr,
 							  struct mlx5_flow_destination *dst)
 {
+	DEFINE_RAW_FLEX(struct ib_flow_attr, flow_attr_wc, flows, 1);
+	DEFINE_RAW_FLEX(struct ib_flow_attr, flow_attr_uc, flows, 1);
+
 	struct mlx5_ib_flow_handler *handler_ucast = NULL;
 	struct mlx5_ib_flow_handler *handler = NULL;
 
-	static struct {
-		struct ib_flow_spec_eth eth_flow;
-		struct ib_flow_attr	flow_attr;
-	} leftovers_wc = { .flow_attr = { .num_of_specs = 1,
-					  .size = sizeof(leftovers_wc) },
-			   .eth_flow = {
-				   .type = IB_FLOW_SPEC_ETH,
-				   .size = sizeof(struct ib_flow_spec_eth),
-				   .mask = { .dst_mac = { 0x1 } },
-				   .val = { .dst_mac = { 0x1 } } } };
-
-	static struct {
-		struct ib_flow_spec_eth eth_flow;
-		struct ib_flow_attr	flow_attr;
-	} leftovers_uc = { .flow_attr = { .num_of_specs = 1,
-					  .size = sizeof(leftovers_uc) },
-			   .eth_flow = {
-				   .type = IB_FLOW_SPEC_ETH,
-				   .size = sizeof(struct ib_flow_spec_eth),
-				   .mask = { .dst_mac = { 0x1 } },
-				   .val = { .dst_mac = {} } } };
-
-	handler = create_flow_rule(dev, ft_prio, &leftovers_wc.flow_attr, dst);
+	flow_attr_wc->num_of_specs = 1;
+	flow_attr_wc->size = sizeof(struct ib_flow_attr) +
+			      sizeof(struct ib_flow_spec_eth);
+	flow_attr_wc->flows[0].eth.type = IB_FLOW_SPEC_ETH;
+	flow_attr_wc->flows[0].eth.size = sizeof(struct ib_flow_spec_eth);
+	flow_attr_wc->flows[0].eth.mask.dst_mac[0] = 0x1;
+	flow_attr_wc->flows[0].eth.val.dst_mac[0] = 0x1;
+
+	flow_attr_uc->num_of_specs = 1;
+	flow_attr_uc->size = sizeof(struct ib_flow_attr) +
+			      sizeof(struct ib_flow_spec_eth);
+	flow_attr_uc->flows[0].eth.type = IB_FLOW_SPEC_ETH;
+	flow_attr_uc->flows[0].eth.size = sizeof(struct ib_flow_spec_eth);
+	flow_attr_uc->flows[0].eth.mask.dst_mac[0] = 0x1;
+
+	handler = create_flow_rule(dev, ft_prio, flow_attr_wc, dst);
 	if (!IS_ERR(handler) &&
 	    flow_attr->type == IB_FLOW_ATTR_ALL_DEFAULT) {
 		handler_ucast = create_flow_rule(dev, ft_prio,
-						 &leftovers_uc.flow_attr, dst);
+						 flow_attr_uc, dst);
 		if (IS_ERR(handler_ucast)) {
 			mlx5_del_flow_rules(handler->rule);
 			ft_prio->refcount--;
-- 
2.9.4

