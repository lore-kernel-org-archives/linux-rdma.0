From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC for accelerated IPoIB 08/26] linux/mlx5/mlx5_ifc.h: Add underlay_qpn field to PRM objects
Date: Wed,  1 Mar 2017 16:02:16 +0200
Message-ID: <1488376954-8346-9-git-send-email-erezsh@mellanox.com>
References: <1488376954-8346-1-git-send-email-erezsh@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1488376954-8346-1-git-send-email-erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Add to the TIS and flow_table objects, and to hca capability table.

1. New capability bit: ipoib_enhanced_offloads, indicates new ability for UD
QP to do RSS.
2. In order to support SET_ROOT cmd, to connect between QP to FS table.

Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/linux/mlx5/mlx5_ifc.h | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 2d197d8a7025..afb6c8ab156a 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -859,7 +859,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 
 	u8         compact_address_vector[0x1];
 	u8         striding_rq[0x1];
-	u8         reserved_at_202[0x2];
+	u8         reserved_at_202[0x1];
+	u8         ipoib_enhanced_offloads[0x1];
 	u8         ipoib_basic_offloads[0x1];
 	u8         reserved_at_205[0xa];
 	u8         drain_sigerr[0x1];
@@ -2217,7 +2218,9 @@ struct mlx5_ifc_tisc_bits {
 	u8         reserved_at_120[0x8];
 	u8         transport_domain[0x18];
 
-	u8         reserved_at_140[0x3c0];
+	u8         reserved_at_140[0x8];
+	u8         underlay_qpn[0x18];
+	u8         reserved_at_160[0x3a0];
 };
 
 enum {
@@ -7906,7 +7909,9 @@ struct mlx5_ifc_set_flow_table_root_in_bits {
 	u8         reserved_at_a0[0x8];
 	u8         table_id[0x18];
 
-	u8         reserved_at_c0[0x140];
+	u8         reserved_at_c0[0x8];
+	u8         underlay_qpn[0x18];
+	u8         reserved_at_e0[0x120];
 };
 
 enum {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
