From: Hariprasad Shenai <hariprasad@chelsio.com>
Subject: [PATCHv4 net-next 08/32] iw_cxgb4: Allow loopback connections
Date: Fri,  7 Mar 2014 16:03:05 +0530
Message-ID: <1394188409-9739-9-git-send-email-hariprasad@chelsio.com>
References: <1394188409-9739-1-git-send-email-hariprasad@chelsio.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1394188409-9739-1-git-send-email-hariprasad@chelsio.com>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: davem@davemloft.net, roland@purestorage.com, santosh@chelsio.com, dm@chelsio.com, kumaras@chelsio.com, swise@opengridcomputing.com, leedom@chelsio.com, nirranjan@chelsio.com, hariprasad@chelsio.com
List-Id: linux-rdma@vger.kernel.org

From: Steve Wise <swise@opengridcomputing.com>

find_route() must treat loopback as a valid
egress interface.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---
 drivers/infiniband/hw/cxgb4/cm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

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
1.8.4
