From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-rc 2/4] IB/core: Don't enforce PKey security on SMI MADs
Date: Tue,  5 Dec 2017 22:30:02 +0200
Message-ID: <20171205203004.28386-3-leon@kernel.org>
References: <20171205203004.28386-1-leon@kernel.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20171205203004.28386-1-leon@kernel.org>
Sender: stable-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: linux-rdma@vger.kernel.org, Leon Romanovsky <leon@kernel.org>, Daniel Jurgens <danielj@mellanox.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj@mellanox.com>

Per the infiniband spec an SMI MAD can have any PKey. Checking the pkey
on SMI MADs is not necessary, and it seems that some older adapters
using the mthca driver don't follow the convention of using the default
PKey, resulting in false denials, or errors querying the PKey cache.

SMI MAD security is still enforced, only agents allowed to manage the
subnet are able to receive or send SMI MADs.

Reported-by: Chris Blake <chrisrblake93@gmail.com>
Cc: <stable@vger.kernel.org> # v4.12
Fixes: 47a2b338fe63 ("IB/core: Enforce security on management datagrams")
Signed-off-by: Daniel Jurgens <danielj@mellanox.com>
Reviewed-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
---
 drivers/infiniband/core/security.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/security.c b/drivers/infiniband/core/security.c
index a337386652b0..feafdb961c48 100644
--- a/drivers/infiniband/core/security.c
+++ b/drivers/infiniband/core/security.c
@@ -739,8 +739,11 @@ int ib_mad_enforce_security(struct ib_mad_agent_private *map, u16 pkey_index)
 	if (!rdma_protocol_ib(map->agent.device, map->agent.port_num))
 		return 0;
 
-	if (map->agent.qp->qp_type == IB_QPT_SMI && !map->agent.smp_allowed)
-		return -EACCES;
+	if (map->agent.qp->qp_type == IB_QPT_SMI) {
+		if (!map->agent.smp_allowed)
+			return -EACCES;
+		return 0;
+	}
 
 	return ib_security_pkey_access(map->agent.device,
 				       map->agent.port_num,
-- 
2.15.1
