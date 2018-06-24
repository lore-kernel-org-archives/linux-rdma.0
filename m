From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 02/12] RDMA/uverbs: Check existence of create_flow callback
Date: Sun, 24 Jun 2018 11:23:43 +0300
Message-ID: <20180624082353.16138-3-leon@kernel.org>
References: <20180624082353.16138-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180624082353.16138-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Hadar Hen Zion <hadarh@mellanox.com>, Matan Barak <matanb@mellanox.com>, Michael J Ruhl <michael.j.ruhl@intel.com>, Noa Osherovich <noaos@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

In the accepted series "Refactor ib_uverbs_write path", we presented the
roadmap to get rid of uverbs_cmd_mask and uverbs_ex_cmd_mask fields in
favor of simple check of function pointer. So let's put NULL check of
create_flow function callback despite the fact that uverbs_ex_cmd_mask
still exists.

Link: https://www.spinics.net/lists/linux-rdma/msg60753.html
Suggested-by: Michael J Ruhl <michael.j.ruhl@intel.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/uverbs_cmd.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index c842a9423fbf..6251d80db732 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3565,6 +3565,11 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 		goto err_put;
 	}
 
+	if (!qp->device->create_flow) {
+		err = -EOPNOTSUPP;
+		goto err_put;
+	}
+
 	flow_attr = kzalloc(struct_size(flow_attr, flows,
 					cmd.flow_attr.num_of_specs), GFP_KERNEL);
 	if (!flow_attr) {
-- 
2.14.4
