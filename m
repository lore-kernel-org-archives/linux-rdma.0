From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 11/12] RDMA/uverbs: Remove redundant check
Date: Sun, 24 Jun 2018 11:23:52 +0300
Message-ID: <20180624082353.16138-12-leon@kernel.org>
References: <20180624082353.16138-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180624082353.16138-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Hadar Hen Zion <hadarh@mellanox.com>, Matan Barak <matanb@mellanox.com>, Michael J Ruhl <michael.j.ruhl@intel.com>, Noa Osherovich <noaos@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

kern_spec->reserved is checked prior to calling to
kern_spec_to_ib_spec_filter() and it makes this second check redundant.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/uverbs_cmd.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 8ed4b674416f..3a0bc4c1b17b 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3045,9 +3045,6 @@ static int kern_spec_to_ib_spec_filter(struct ib_uverbs_flow_spec *kern_spec,
 	void *kern_spec_mask;
 	void *kern_spec_val;
 
-	if (kern_spec->reserved)
-		return -EINVAL;
-
 	kern_filter_sz = kern_spec_filter_sz(&kern_spec->hdr);
 
 	kern_spec_val = (void *)kern_spec +
-- 
2.14.4
