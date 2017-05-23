From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 1/2] IB/core: Namespace is a mandatory input parameter for address resolution
Date: Tue, 23 May 2017 10:48:44 +0300
Message-ID: <20170523074845.10845-1-leon@kernel.org>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, Moni Shoua <monis@mellanox.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis@mellanox.com>

In function addr_resolve() the namespace is a required input parameter
and not an output. It is passed later for searching the routing table
and device addresses. Also, it shouldn't be copied back to the caller.

Fixes: 565edd1d5555 ('IB/addr: Pass network namespace as a parameter')
Cc: <stable@vger.kernel.org> # v4.3+
Signed-off-by: Moni Shoua <monis@mellanox.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
---
 drivers/infiniband/core/addr.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index 02971e239a18..d2afcb3dd81a 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -518,6 +518,11 @@ static int addr_resolve(struct sockaddr *src_in,
 	struct dst_entry *dst;
 	int ret;
 
+	if (!addr->net) {
+		pr_warn_ratelimited("%s: missing namespace\n", __func__);
+		return -EINVAL;
+	}
+
 	if (src_in->sa_family == AF_INET) {
 		struct rtable *rt = NULL;
 		const struct sockaddr_in *dst_in4 =
@@ -555,7 +560,6 @@ static int addr_resolve(struct sockaddr *src_in,
 	}
 
 	addr->bound_dev_if = ndev->ifindex;
-	addr->net = dev_net(ndev);
 	dev_put(ndev);
 
 	return ret;
-- 
2.12.2
