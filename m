From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/3] net/mlx4: report thermal error event
Date: Tue,  6 Mar 2012 15:50:49 +0200
Message-ID: <1331041851-20498-2-git-send-email-ogerlitz@mellanox.com>
References: <1331041851-20498-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1331041851-20498-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Dotan Barak <dotanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Print an error message when an async event of thermal error is
being reported by the HW.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Dotan Barak <dotanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/eq.c   |   32 ++++++++++++++++++++++++++++-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h |    4 +++
 include/linux/mlx4/device.h               |    5 ++++
 3 files changed, 40 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/eq.c b/drivers/net/ethernet/mellanox/mlx4/eq.c
index 8fa41f3..780b5ad 100644
--- a/drivers/net/ethernet/mellanox/mlx4/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/eq.c
@@ -79,7 +79,8 @@ enum {
 			       (1ull << MLX4_EVENT_TYPE_SRQ_LIMIT)	    | \
 			       (1ull << MLX4_EVENT_TYPE_CMD)		    | \
 			       (1ull << MLX4_EVENT_TYPE_COMM_CHANNEL)       | \
-			       (1ull << MLX4_EVENT_TYPE_FLR_EVENT))
+			       (1ull << MLX4_EVENT_TYPE_FLR_EVENT)	    | \
+			       (1ull << MLX4_EVENT_TYPE_FATAL_WARNING))
 
 static void eq_set_ci(struct mlx4_eq *eq, int req_not)
 {
@@ -443,6 +444,35 @@ static int mlx4_eq_int(struct mlx4_dev *dev, struct mlx4_eq *eq)
 			queue_work(priv->mfunc.master.comm_wq,
 				   &priv->mfunc.master.slave_flr_event_work);
 			break;
+
+		case MLX4_EVENT_TYPE_FATAL_WARNING:
+			if (eqe->subtype == MLX4_FATAL_WARNING_SUBTYPE_WARMING) {
+				if (mlx4_is_master(dev))
+					for (i = 0; i < dev->num_slaves; i++) {
+						mlx4_dbg(dev, "%s: Sending "
+							"MLX4_FATAL_WARNING_SUBTYPE_WARMING"
+							" to slave: %d\n", __func__, i);
+						if (i == dev->caps.function)
+							continue;
+						mlx4_slave_event(dev, i, eqe);
+					}
+				mlx4_err(dev, "Temperature Threshold was reached! "
+					"Threshold: %d celsius degrees; "
+					"Current Temperature: %d\n",
+					be16_to_cpu(eqe->event.warming.warning_threshold),
+					be16_to_cpu(eqe->event.warming.current_temperature));
+			} else
+				mlx4_warn(dev, "Unhandled event FATAL WARNING (%02x), "
+					  "subtype %02x on EQ %d at index %u. owner=%x, "
+					  "nent=0x%x, slave=%x, ownership=%s\n",
+					  eqe->type, eqe->subtype, eq->eqn,
+					  eq->cons_index, eqe->owner, eq->nent,
+					  eqe->slave_id,
+					  !!(eqe->owner & 0x80) ^
+					  !!(eq->cons_index & eq->nent) ? "HW" : "SW");
+
+			break;
+
 		case MLX4_EVENT_TYPE_EEC_CATAS_ERROR:
 		case MLX4_EVENT_TYPE_ECC_DETECT:
 		default:
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4.h b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
index c92269f..ac2d606 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
@@ -363,6 +363,10 @@ struct mlx4_eqe {
 		struct {
 			__be32	slave_id;
 		} __packed flr_event;
+		struct {
+			__be16  current_temperature;
+			__be16  warning_threshold;
+		} __packed warming;
 	}			event;
 	u8			slave_id;
 	u8			reserved3[2];
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 263d2ae..4b3fbf1 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -133,6 +133,7 @@ enum mlx4_event {
 	MLX4_EVENT_TYPE_CMD		   = 0x0a,
 	MLX4_EVENT_TYPE_VEP_UPDATE	   = 0x19,
 	MLX4_EVENT_TYPE_COMM_CHANNEL	   = 0x18,
+	MLX4_EVENT_TYPE_FATAL_WARNING	   = 0x1b,
 	MLX4_EVENT_TYPE_FLR_EVENT	   = 0x1c,
 	MLX4_EVENT_TYPE_NONE		   = 0xff,
 };
@@ -143,6 +144,10 @@ enum {
 };
 
 enum {
+	MLX4_FATAL_WARNING_SUBTYPE_WARMING = 0,
+};
+
+enum {
 	MLX4_PERM_LOCAL_READ	= 1 << 10,
 	MLX4_PERM_LOCAL_WRITE	= 1 << 11,
 	MLX4_PERM_REMOTE_READ	= 1 << 12,
-- 
1.6.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
