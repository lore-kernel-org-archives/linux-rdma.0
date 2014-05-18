From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 1/3] mlx5: Fix signature handover operation for interleaved buffers
Date: Sun, 18 May 2014 18:32:38 +0300
Message-ID: <1400427160-11314-2-git-send-email-sagig@mellanox.com>
References: <1400427160-11314-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1400427160-11314-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: roland@kernel.org
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, martin.petersen@oracle.com, oren@mellanox.com
List-Id: linux-rdma@vger.kernel.org

When the data and protection are interleaved in the memory
domain, no need to expand the mkey total length.

At the moment no Linux user works (iSER initiator & target) in interleaved
mode. This may change in the future as for SCSI pass-through devices there
is no real point in target performing de-interleaving and re-interleaving
of the protection data in the PT stage. Regardless, signature verbs support
this mode.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/hw/mlx5/qp.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index ae788d2..410d3a0 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -2263,7 +2263,10 @@ static int set_sig_umr_wr(struct ib_send_wr *wr, struct mlx5_ib_qp *qp,
 
 	/* length of the protected region, data + protection */
 	region_len = wr->sg_list->length;
-	if (wr->wr.sig_handover.prot)
+	if (wr->wr.sig_handover.prot &&
+	    (wr->wr.sig_handover.prot->lkey != wr->sg_list->lkey  ||
+	     wr->wr.sig_handover.prot->addr != wr->sg_list->addr  ||
+	     wr->wr.sig_handover.prot->length != wr->sg_list->length))
 		region_len += wr->wr.sig_handover.prot->length;
 
 	/**
-- 
1.7.1
