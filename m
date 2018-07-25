From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH] drivers: infiniband: core: Remove extra parentheses
Date: Wed, 25 Jul 2018 20:43:56 +0200
Message-ID: <20180725184356.3754-1-rvarsha016@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Lukas Bulwahn <lukas.bulwahn@gmail.com>, Nicholas Mc Guire <der.herr@hofr.at>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Varsha Rao <rvarsha016@gmail.com>
List-Id: linux-rdma@vger.kernel.org

Remove unnecessary parentheses to fix the clang warning of extraneous
parentheses.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 drivers/infiniband/core/cma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index bff10ab141b0..c200a2e748f0 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -4010,7 +4010,7 @@ static void cma_set_mgid(struct rdma_id_private *id_priv,
 		memcpy(mgid, &sin6->sin6_addr, sizeof *mgid);
 	} else if (addr->sa_family == AF_IB) {
 		memcpy(mgid, &((struct sockaddr_ib *) addr)->sib_addr, sizeof *mgid);
-	} else if ((addr->sa_family == AF_INET6)) {
+	} else if (addr->sa_family == AF_INET6) {
 		ipv6_ib_mc_map(&sin6->sin6_addr, dev_addr->broadcast, mc_map);
 		if (id_priv->id.ps == RDMA_PS_UDP)
 			mc_map[7] = 0x01;	/* Use RDMA CM signature */
-- 
2.17.0
