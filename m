From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 5/NNN] mlx4: Fix layout of QP context for correct location
 of counter index
Date: Wed, 15 Jun 2011 17:43:43 +0300
Message-ID: <alpine.LRH.2.00.1106151743180.15844@ogerlitz.voltaire.com>
References: <alpine.LRH.2.00.1106151733410.15844@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1106151733410.15844-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fix the address handle portion of the QP context structure to have
the correct bit location for the counter index field.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 include/linux/mlx4/qp.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: b/include/linux/mlx4/qp.h
===================================================================
--- a/include/linux/mlx4/qp.h
+++ b/include/linux/mlx4/qp.h
@@ -99,7 +99,7 @@ struct mlx4_qp_path {
 	u8			fl;
 	u8			reserved1[2];
 	u8			pkey_index;
-	u8			reserved2;
+	u8			counter_index;
 	u8			grh_mylmc;
 	__be16			rlid;
 	u8			ackto;
@@ -111,8 +111,7 @@ struct mlx4_qp_path {
 	u8			sched_queue;
 	u8			vlan_index;
 	u8			reserved3[2];
-	u8			counter_index;
-	u8			reserved4;
+	u8			reserved4[2];
 	u8			dmac[6];
 };


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
