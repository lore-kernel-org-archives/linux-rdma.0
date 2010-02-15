From: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH] mlx4_core: num reserved eqs presented as log and actual
Date: Mon, 15 Feb 2010 10:58:21 +0200
Message-ID: <4B790CAD.2070007@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Multifunctional firmware should present number of reserved EQs as
an actual number (number of reserved eqs is not necessarily a power
of 2).
Older drivers treat this field as log, so when there are relatively big
number of reserved eqs, they would fail.
The firmware would present the number of EQs as log in a single function mode
(which would also work for older driver versions) and as actual number (in other field)
in multifunctional mode. The new code would check both fields.
Fixes commit be504b0b9fbe9ba447c93ef0f5789f377102d555

Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/net/mlx4/fw.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/mlx4/fw.c b/drivers/net/mlx4/fw.c
index 04f42ae..b5b4799 100644
--- a/drivers/net/mlx4/fw.c
+++ b/drivers/net/mlx4/fw.c
@@ -155,11 +155,12 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 #define QUERY_DEV_CAP_MAX_SRQ_OFFSET		0x15
 #define QUERY_DEV_CAP_RSVD_EEC_OFFSET		0x16
 #define QUERY_DEV_CAP_MAX_EEC_OFFSET		0x17
+#define QUERY_DEV_CAP_RSVD_EQ_OFFSET		0x18
 #define QUERY_DEV_CAP_MAX_CQ_SZ_OFFSET		0x19
 #define QUERY_DEV_CAP_RSVD_CQ_OFFSET		0x1a
 #define QUERY_DEV_CAP_MAX_CQ_OFFSET		0x1b
 #define QUERY_DEV_CAP_MAX_MPT_OFFSET		0x1d
-#define QUERY_DEV_CAP_RSVD_EQ_OFFSET		0x1e
+#define QUERY_DEV_CAP_LOG_RSVD_EQ_OFFSET	0x1e
 #define QUERY_DEV_CAP_MAX_EQ_OFFSET		0x1f
 #define QUERY_DEV_CAP_RSVD_MTT_OFFSET		0x20
 #define QUERY_DEV_CAP_MAX_MRW_SZ_OFFSET		0x21
@@ -236,7 +237,11 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 	MLX4_GET(field, outbox, QUERY_DEV_CAP_MAX_MPT_OFFSET);
 	dev_cap->max_mpts = 1 << (field & 0x3f);
 	MLX4_GET(field, outbox, QUERY_DEV_CAP_RSVD_EQ_OFFSET);
-	dev_cap->reserved_eqs = field & 0xf;
+	if (!field) {
+		MLX4_GET(field, outbox, QUERY_DEV_CAP_LOG_RSVD_EQ_OFFSET);
+		dev_cap->reserved_eqs = 1 << (field & 0xf);
+	} else
+		dev_cap->reserved_eqs = field;
 	MLX4_GET(field, outbox, QUERY_DEV_CAP_MAX_EQ_OFFSET);
 	dev_cap->max_eqs = 1 << (field & 0xf);
 	MLX4_GET(field, outbox, QUERY_DEV_CAP_RSVD_MTT_OFFSET);
-- 
1.6.1.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
