From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-rc 1/4] IB/core: Bound check alternate path port number
Date: Tue,  5 Dec 2017 22:30:01 +0200
Message-ID: <20171205203004.28386-2-leon@kernel.org>
References: <20171205203004.28386-1-leon@kernel.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20171205203004.28386-1-leon@kernel.org>
Sender: stable-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: linux-rdma@vger.kernel.org, Leon Romanovsky <leon@kernel.org>, Daniel Jurgens <danielj@mellanox.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj@mellanox.com>

The alternate port number is used as an array index in the IB
security implementation, invalid values can result in a kernel panic.

Cc: <stable@vger.kernel.org> # v4.12
Fixes: d291f1a65232 ("IB/core: Enforce PKey security on QPs")
Signed-off-by: Daniel Jurgens <danielj@mellanox.com>
Reviewed-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 16d55710b116..d0202bb176a4 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1971,6 +1971,12 @@ static int modify_qp(struct ib_uverbs_file *file,
 		goto release_qp;
 	}
 
+	if ((cmd->base.attr_mask & IB_QP_ALT_PATH) &&
+	    !rdma_is_port_valid(qp->device, cmd->base.alt_port_num)) {
+		ret = -EINVAL;
+		goto release_qp;
+	}
+
 	attr->qp_state		  = cmd->base.qp_state;
 	attr->cur_qp_state	  = cmd->base.cur_qp_state;
 	attr->path_mtu		  = cmd->base.path_mtu;
-- 
2.15.1
