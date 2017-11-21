From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-rc 1/2] IB/core: Only enforce security for InfiniBand
Date: Tue, 21 Nov 2017 12:26:17 +0200
Message-ID: <20171121102618.31216-2-leon@kernel.org>
References: <20171121102618.31216-1-leon@kernel.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20171121102618.31216-1-leon@kernel.org>
Sender: stable-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: linux-rdma@vger.kernel.org, Leon Romanovsky <leon@kernel.org>, Daniel Jurgens <danielj@mellanox.com>, Paul Moore <paul@paul-moore.com>, Don Dutile <ddutile@redhat.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj@mellanox.com>

For now the only LSM security enforcement mechanism available is
specific to InfiniBand. Bypass enforcement for non-IB link types.
This fixes a regression where modify_qp fails for iWARP because
querying the PKEY returns -EINVAL.

Cc: Paul Moore <paul@paul-moore.com>
Cc: Don Dutile <ddutile@redhat.com>
Cc: stable@vger.kernel.org
Reported-by: Potnuri Bharat Teja <bharat@chelsio.com>
Fixes: d291f1a65232("IB/core: Enforce PKey security on QPs")
Fixes: 47a2b338fe63("IB/core: Enforce security on management datagrams")
Signed-off-by: Daniel Jurgens <danielj@mellanox.com>
Reviewed-by: Parav Pandit <parav@mellanox.com>
Tested-by: Potnuri Bharat Teja <bharat@chelsio.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
---
 drivers/infiniband/core/security.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/infiniband/core/security.c b/drivers/infiniband/core/security.c
index 23278ed5be45..314bf1137c7b 100644
--- a/drivers/infiniband/core/security.c
+++ b/drivers/infiniband/core/security.c
@@ -417,8 +417,17 @@ void ib_close_shared_qp_security(struct ib_qp_security *sec)
 
 int ib_create_qp_security(struct ib_qp *qp, struct ib_device *dev)
 {
+	u8 i = rdma_start_port(dev);
+	bool is_ib = false;
 	int ret;
 
+	while (i <= rdma_end_port(dev) && !is_ib)
+		is_ib = rdma_protocol_ib(dev, i++);
+
+	/* If this isn't an IB device don't create the security context */
+	if (!is_ib)
+		return 0;
+
 	qp->qp_sec = kzalloc(sizeof(*qp->qp_sec), GFP_KERNEL);
 	if (!qp->qp_sec)
 		return -ENOMEM;
-- 
2.15.0
