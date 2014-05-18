From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 3/3] mlx5: Copy DIF fields only when input and output space values match
Date: Sun, 18 May 2014 18:32:40 +0300
Message-ID: <1400427160-11314-4-git-send-email-sagig@mellanox.com>
References: <1400427160-11314-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1400427160-11314-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: roland@kernel.org
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, martin.petersen@oracle.com, oren@mellanox.com
List-Id: linux-rdma@vger.kernel.org

Some DIF implementations (SCSI initiator/target) may want to
use different input/output values for application tag and/or
reference tag. So in case memory/wire domain values don't
match HW must not copy them.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/hw/mlx5/qp.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 242fb2d..d3fc805 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -2066,6 +2066,7 @@ static int mlx5_set_bsf(struct ib_mr *sig_mr,
 	struct ib_sig_domain *wire = &sig_attrs->wire;
 	int ret, selector;
 
+	memset(bsf, 0, sizeof(*bsf));
 	switch (sig_attrs->mem.sig_type) {
 	case IB_SIG_TYPE_T10_DIF:
 		if (sig_attrs->wire.sig_type != IB_SIG_TYPE_T10_DIF)
@@ -2078,9 +2079,11 @@ static int mlx5_set_bsf(struct ib_mr *sig_mr,
 			/* Same block structure */
 			basic->bsf_size_sbs = 1 << 4;
 			if (mem->sig.dif.bg_type == wire->sig.dif.bg_type)
-				basic->wire.copy_byte_mask = 0xff;
-			else
-				basic->wire.copy_byte_mask = 0x3f;
+				basic->wire.copy_byte_mask |= 0xc0;
+			if (mem->sig.dif.app_tag == wire->sig.dif.app_tag)
+				basic->wire.copy_byte_mask |= 0x30;
+			if (mem->sig.dif.ref_tag == wire->sig.dif.ref_tag)
+				basic->wire.copy_byte_mask |= 0x0f;
 		} else
 			basic->wire.bs_selector = bs_selector(wire->sig.dif.pi_interval);
 
-- 
1.7.1
