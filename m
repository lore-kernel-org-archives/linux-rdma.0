From: Hariprasad Shenai <hariprasad@chelsio.com>
Subject: [PATCH net-next 07/31] iw_cxgb4: Allow loopback connections.
Date: Wed, 26 Feb 2014 20:36:46 +0530
Message-ID: <1393427230-14532-8-git-send-email-hariprasad@chelsio.com>
References: <1393427230-14532-1-git-send-email-hariprasad@chelsio.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1393427230-14532-1-git-send-email-hariprasad@chelsio.com>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: davem@davemloft.net, roland@purestorage.com, kumaras@chelsio.com, dm@chelsio.com, swise@opengridcomputing.com, leedom@chelsio.com, santosh@chelsio.com, hariprasad@chelsio.com, nirranjan@chelsio.com
List-Id: linux-rdma@vger.kernel.org

From: Steve Wise <swise@opengridcomputing.com>

find_route() must treat loopback as a valid
egress interface.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---
 drivers/infiniband/hw/cxgb4/cm.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index d286bde..360807e 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -400,7 +400,8 @@ static struct dst_entry *find_route(struct c4iw_dev *dev, __be32 local_ip,
 	n = dst_neigh_lookup(&rt->dst, &peer_ip);
 	if (!n)
 		return NULL;
-	if (!our_interface(dev, n->dev)) {
+	if (!our_interface(dev, n->dev) &&
+	    !(n->dev->flags & IFF_LOOPBACK)) {
 		dst_release(&rt->dst);
 		return NULL;
 	}
-- 
1.7.1
