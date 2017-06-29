From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 3/7] mlx4: Convert datagram segment to use mlx4_av struct
Date: Thu, 29 Jun 2017 14:47:04 +0300
Message-ID: <1498736828-17875-4-git-send-email-yishaih@mellanox.com>
References: <1498736828-17875-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1498736828-17875-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The datagram segment struct contains array which
represents the address vector, convert the array
to mlx4_av.

mlx4dv will use this struct in downstream patches.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx4/mlx4.h   | 13 -------------
 providers/mlx4/mlx4dv.h | 15 ++++++++++++++-
 providers/mlx4/qp.c     |  2 +-
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/providers/mlx4/mlx4.h b/providers/mlx4/mlx4.h
index 8f0d6f2..bdb7f16 100644
--- a/providers/mlx4/mlx4.h
+++ b/providers/mlx4/mlx4.h
@@ -214,19 +214,6 @@ struct mlx4_qp {
 	uint32_t			qp_cap_cache;
 };
 
-struct mlx4_av {
-	uint32_t			port_pd;
-	uint8_t				reserved1;
-	uint8_t				g_slid;
-	uint16_t			dlid;
-	uint8_t				reserved2;
-	uint8_t				gid_index;
-	uint8_t				stat_rate;
-	uint8_t				hop_limit;
-	uint32_t			sl_tclass_flowlabel;
-	uint8_t				dgid[16];
-};
-
 struct mlx4_ah {
 	struct ibv_ah			ibv_ah;
 	struct mlx4_av			av;
diff --git a/providers/mlx4/mlx4dv.h b/providers/mlx4/mlx4dv.h
index e677fe1..7679ece 100644
--- a/providers/mlx4/mlx4dv.h
+++ b/providers/mlx4/mlx4dv.h
@@ -325,8 +325,21 @@ struct mlx4_wqe_ctrl_seg {
 	uint32_t		imm;
 };
 
+struct mlx4_av {
+	uint32_t			port_pd;
+	uint8_t				reserved1;
+	uint8_t				g_slid;
+	uint16_t			dlid;
+	uint8_t				reserved2;
+	uint8_t				gid_index;
+	uint8_t				stat_rate;
+	uint8_t				hop_limit;
+	uint32_t			sl_tclass_flowlabel;
+	uint8_t				dgid[16];
+};
+
 struct mlx4_wqe_datagram_seg {
-	uint32_t		av[8];
+	struct mlx4_av		av;
 	uint32_t		dqpn;
 	uint32_t		qkey;
 	uint16_t		vlan;
diff --git a/providers/mlx4/qp.c b/providers/mlx4/qp.c
index b7e3669..1be100b 100644
--- a/providers/mlx4/qp.c
+++ b/providers/mlx4/qp.c
@@ -175,7 +175,7 @@ static void set_atomic_seg(struct mlx4_wqe_atomic_seg *aseg, struct ibv_send_wr
 static void set_datagram_seg(struct mlx4_wqe_datagram_seg *dseg,
 			     struct ibv_send_wr *wr)
 {
-	memcpy(dseg->av, &to_mah(wr->wr.ud.ah)->av, sizeof (struct mlx4_av));
+	memcpy(&dseg->av, &to_mah(wr->wr.ud.ah)->av, sizeof (struct mlx4_av));
 	dseg->dqpn = htobe32(wr->wr.ud.remote_qpn);
 	dseg->qkey = htobe32(wr->wr.ud.remote_qkey);
 	dseg->vlan = htobe16(to_mah(wr->wr.ud.ah)->vlan);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
