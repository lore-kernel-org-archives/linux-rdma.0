From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/6] IB: use central enum for speed instead of hard-coded
 values
Date: Wed, 11 Jan 2012 18:54:39 +0200
Message-ID: <alpine.LRH.2.00.1201111854190.10264@ogerlitz.voltaire.com>
References: <alpine.LRH.2.00.1201111850330.10264@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1201111850330.10264-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The kernel IB stack uses one enumeration for IB speed, which wasn't
explicitly specified in the verbs header file. Add that enum, and
use it all over the code. Note that the IB speed/width notation is
also used by iWARP and IBoE hw drivers who apply the convention of
rate = speed X width, to advertize their port link rate.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/sysfs.c              |   15 +++++++++------
 drivers/infiniband/hw/amso1100/c2_provider.c |    2 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |    2 +-
 drivers/infiniband/hw/cxgb4/provider.c       |    2 +-
 drivers/infiniband/hw/ehca/ehca_hca.c        |    2 +-
 drivers/infiniband/hw/mlx4/main.c            |   10 +++++-----
 drivers/infiniband/hw/nes/nes_verbs.c        |    2 +-
 include/rdma/ib_verbs.h                      |    9 +++++++++
 8 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index c61bca3..9ce70ca 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -189,21 +189,24 @@ static ssize_t rate_show(struct ib_port *p, struct port_attribute *unused,
 	rate = (25 * attr.active_speed) / 10;

 	switch (attr.active_speed) {
-	case 2:
+	case IB_SPEED_SDR:
+		speed = " SDR";
+		break;
+	case IB_SPEED_DDR:
 		speed = " DDR";
 		break;
-	case 4:
+	case IB_SPEED_QDR:
 		speed = " QDR";
 		break;
-	case 8:
+	case IB_SPEED_FDR10:
 		speed = " FDR10";
 		rate = 10;
 		break;
-	case 16:
+	case IB_SPEED_FDR:
 		speed = " FDR";
 		rate = 14;
 		break;
-	case 32:
+	case IB_SPEED_EDR:
 		speed = " EDR";
 		rate = 25;
 		break;
@@ -214,7 +217,7 @@ static ssize_t rate_show(struct ib_port *p, struct port_attribute *unused,
 		return -EINVAL;

 	return sprintf(buf, "%d%s Gb/sec (%dX%s)\n",
-		       rate, (attr.active_speed == 1) ? ".5" : "",
+		       rate, (attr.active_speed == IB_SPEED_SDR) ? ".5" : "",
 		       ib_width_enum_to_int(attr.active_width), speed);
 }

diff --git a/drivers/infiniband/hw/amso1100/c2_provider.c b/drivers/infiniband/hw/amso1100/c2_provider.c
index 12f923d..07eb3a8 100644
--- a/drivers/infiniband/hw/amso1100/c2_provider.c
+++ b/drivers/infiniband/hw/amso1100/c2_provider.c
@@ -94,7 +94,7 @@ static int c2_query_port(struct ib_device *ibdev,
 	props->pkey_tbl_len = 1;
 	props->qkey_viol_cntr = 0;
 	props->active_width = 1;
-	props->active_speed = 1;
+	props->active_speed = IB_SPEED_SDR;

 	return 0;
 }
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 37c224f..0bdf09a 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -1227,7 +1227,7 @@ static int iwch_query_port(struct ib_device *ibdev,
 	props->gid_tbl_len = 1;
 	props->pkey_tbl_len = 1;
 	props->active_width = 2;
-	props->active_speed = 2;
+	props->active_speed = IB_SPEED_DDR;
 	props->max_msg_sz = -1;

 	return 0;
diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index 247fe70..be1c18f 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -329,7 +329,7 @@ static int c4iw_query_port(struct ib_device *ibdev, u8 port,
 	props->gid_tbl_len = 1;
 	props->pkey_tbl_len = 1;
 	props->active_width = 2;
-	props->active_speed = 2;
+	props->active_speed = IB_SPEED_DDR;
 	props->max_msg_sz = -1;

 	return 0;
diff --git a/drivers/infiniband/hw/ehca/ehca_hca.c b/drivers/infiniband/hw/ehca/ehca_hca.c
index 73edc36..9ed4d25 100644
--- a/drivers/infiniband/hw/ehca/ehca_hca.c
+++ b/drivers/infiniband/hw/ehca/ehca_hca.c
@@ -233,7 +233,7 @@ int ehca_query_port(struct ib_device *ibdev,
 		props->phys_state      = 5;
 		props->state           = rblock->state;
 		props->active_width    = IB_WIDTH_12X;
-		props->active_speed    = 0x1;
+		props->active_speed    = IB_SPEED_SDR;
 	}

 query_port1:
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 7b445df..6ff6bdf 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -215,16 +215,16 @@ static int ib_link_query_port(struct ib_device *ibdev, u8 port,

 		switch (ext_active_speed) {
 		case 1:
-			props->active_speed = 16; /* FDR */
+			props->active_speed = IB_SPEED_FDR;
 			break;
 		case 2:
-			props->active_speed = 32; /* EDR */
+			props->active_speed = IB_SPEED_EDR;
 			break;
 		}
 	}

 	/* If reported active speed is QDR, check if is FDR-10 */
-	if (props->active_speed == 4) {
+	if (props->active_speed == IB_SPEED_QDR) {
 		if (to_mdev(ibdev)->dev->caps.ext_port_cap[port] &
 		    MLX_EXT_PORT_CAP_FLAG_EXTENDED_PORT_INFO) {
 			init_query_mad(in_mad);
@@ -238,7 +238,7 @@ static int ib_link_query_port(struct ib_device *ibdev, u8 port,

 			/* Checking LinkSpeedActive for FDR-10 */
 			if (out_mad->data[15] & 0x1)
-				props->active_speed = 8;
+				props->active_speed = IB_SPEED_FDR10;
 		}
 	}

@@ -259,7 +259,7 @@ static int eth_link_query_port(struct ib_device *ibdev, u8 port,
 	enum ib_mtu tmp;

 	props->active_width	= IB_WIDTH_1X;
-	props->active_speed	= 4;
+	props->active_speed	= IB_SPEED_QDR;
 	props->port_cap_flags	= IB_PORT_CM_SUP;
 	props->gid_tbl_len	= to_mdev(ibdev)->dev->caps.gid_table_len[port];
 	props->max_msg_sz	= to_mdev(ibdev)->dev->caps.max_msg_sz;
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 5095bc4..b7b9c85 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -597,7 +597,7 @@ static int nes_query_port(struct ib_device *ibdev, u8 port, struct ib_port_attr
 	props->pkey_tbl_len = 1;
 	props->qkey_viol_cntr = 0;
 	props->active_width = IB_WIDTH_4X;
-	props->active_speed = 1;
+	props->active_speed = IB_SPEED_SDR;
 	props->max_msg_sz = 0x80000000;

 	return 0;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index bf5daaf..01179b0 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -239,6 +239,15 @@ static inline int ib_width_enum_to_int(enum ib_port_width width)
 	}
 }

+enum ib_port_seed {
+	IB_SPEED_SDR	= 1,
+	IB_SPEED_DDR	= 2,
+	IB_SPEED_QDR	= 4,
+	IB_SPEED_FDR10	= 8,
+	IB_SPEED_FDR	= 16,
+	IB_SPEED_EDR	= 32
+};
+
 struct ib_protocol_stats {
 	/* TBD... */
 };
-- 
1.7.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
