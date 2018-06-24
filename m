From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 06/12] RDMA/uverbs: Don't overwrite NULL pointer with ZERO_SIZE_PTR
Date: Sun, 24 Jun 2018 11:23:47 +0300
Message-ID: <20180624082353.16138-7-leon@kernel.org>
References: <20180624082353.16138-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180624082353.16138-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Hadar Hen Zion <hadarh@mellanox.com>, Matan Barak <matanb@mellanox.com>, Michael J Ruhl <michael.j.ruhl@intel.com>, Noa Osherovich <noaos@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Number of specs is provided by user and in valid case can be equal to zero.
Such argument causes to call to kcalloc() with zero-length request and in
return the ZERO_SIZE_PTR is assigned. This pointer is different from NULL
and makes various if (..) checks to success.

Fixes: b6ba4a9aa59f ("IB/uverbs: Add support for flow counters")
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/uverbs_cmd.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 3aba63aa1779..8ed4b674416f 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2768,6 +2768,9 @@ static struct ib_uflow_resources *flow_resources_alloc(size_t num_specs)
 	if (!resources)
 		return NULL;
 
+	if (!num_specs)
+		goto out;
+
 	resources->counters =
 		kcalloc(num_specs, sizeof(*resources->counters), GFP_KERNEL);
 	resources->collection =
@@ -2776,8 +2779,8 @@ static struct ib_uflow_resources *flow_resources_alloc(size_t num_specs)
 	if (!resources->counters || !resources->collection)
 		goto err;
 
+out:
 	resources->max = num_specs;
-
 	return resources;
 
 err:
-- 
2.14.4
