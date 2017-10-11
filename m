From: Ursula Braun <ubraun@linux.vnet.ibm.com>
Subject: [PATCH v2 net 2/2] net/smc: dev_put for netdev after usage of ib_query_gid()
Date: Wed, 11 Oct 2017 13:47:23 +0200
Message-ID: <20171011114723.30733-3-ubraun@linux.vnet.ibm.com>
References: <20171011114723.30733-1-ubraun@linux.vnet.ibm.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20171011114723.30733-1-ubraun@linux.vnet.ibm.com>
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, jwi@linux.vnet.ibm.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, raspl@linux.vnet.ibm.com, ubraun@linux.vnet.ibm.com, parav@mellanox.com
List-Id: linux-rdma@vger.kernel.org

For RoCEs ib_query_gid() takes a reference count on the net_device.
This reference count must be decreased by the caller.

Signed-off-by: Ursula Braun <ubraun@linux.vnet.ibm.com>
Reported-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Parav Pandit <parav@mellanox.com>
Fixes: 0cfdd8f92cac ("smc: connection and link group creation")
---
 net/smc/smc_core.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 20b66e79c5d6..5f6a20084157 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -380,10 +380,14 @@ static int smc_link_determine_gid(struct smc_link_group *lgr)
 		if (ib_query_gid(lnk->smcibdev->ibdev, lnk->ibport, i, &gid,
 				 &gattr))
 			continue;
-		if (gattr.ndev &&
-		    (vlan_dev_vlan_id(gattr.ndev) == lgr->vlan_id)) {
-			lnk->gid = gid;
-			return 0;
+		if (gattr.ndev) {
+			if (is_vlan_dev(gattr.ndev) &&
+			    vlan_dev_vlan_id(gattr.ndev) == lgr->vlan_id) {
+				lnk->gid = gid;
+				dev_put(gattr.ndev);
+				return 0;
+			}
+			dev_put(gattr.ndev);
 		}
 	}
 	return -ENODEV;
-- 
2.13.5
