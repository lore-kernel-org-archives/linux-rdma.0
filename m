From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 01/10] mlx4_core: Change fw profile and qp context
 to enable FC
Date: Mon, 16 Aug 2010 15:16:13 -0700
Message-ID: <4C69B8AD.1070404@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030202010502080100010309"
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------030202010502080100010309
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



--------------030202010502080100010309
Content-Type: text/x-patch;
 name="0001-mlx4_core-Change-fw-profile-and-qp-context-to-enable.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-mlx4_core-Change-fw-profile-and-qp-context-to-enable.pa";
 filename*1="tch"

>From 5fd7e9795e085ff64b2396a5339f98e9b7021965 Mon Sep 17 00:00:00 2001
From: Vu Pham <vu-OnC3O1emZK9LiOotz6YBiwC/G2K4zDHf@public.gmane.org>
Date: Tue, 10 Aug 2010 13:55:43 -0700
Subject: [PATCH 01/10] mlx4_core: Change fw profile and qp context to enable FC

Increase num_qp, num_mpt resource in fw profile to enable FC
Add fields in qp context and qp path to enable FC qps

Signed-off-by: Oren Duer <oren-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/mlx4/main.c |    4 ++--
 include/linux/mlx4/qp.h |   13 +++++++++++--
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/mlx4/main.c b/drivers/net/mlx4/main.c
index 5102ab1..fe3be88 100644
--- a/drivers/net/mlx4/main.c
+++ b/drivers/net/mlx4/main.c
@@ -79,12 +79,12 @@ static char mlx4_version[] __devinitdata =
 	DRV_VERSION " (" DRV_RELDATE ")\n";
 
 static struct mlx4_profile default_profile = {
-	.num_qp		= 1 << 17,
+	.num_qp		= 1 << 18,
 	.num_srq	= 1 << 16,
 	.rdmarc_per_qp	= 1 << 4,
 	.num_cq		= 1 << 16,
 	.num_mcg	= 1 << 13,
-	.num_mpt	= 1 << 17,
+	.num_mpt	= 1 << 19,
 	.num_mtt	= 1 << 20,
 };
 
diff --git a/include/linux/mlx4/qp.h b/include/linux/mlx4/qp.h
index 7abe643..249dacf 100644
--- a/include/linux/mlx4/qp.h
+++ b/include/linux/mlx4/qp.h
@@ -109,7 +109,7 @@ struct mlx4_qp_path {
 	__be32			tclass_flowlabel;
 	u8			rgid[16];
 	u8			sched_queue;
-	u8			snooper_flags;
+	u8			vlan_index;
 	u8			reserved3[2];
 	u8			counter_index;
 	u8			reserved4[7];
@@ -151,7 +151,16 @@ struct mlx4_qp_context {
 	u8			reserved4[2];
 	u8			mtt_base_addr_h;
 	__be32			mtt_base_addr_l;
-	u32			reserved5[10];
+	u8			VE;
+	u8			reserved5;
+	__be16			VFT_id_prio;
+	u8			reserved6;
+	u8			exch_size;
+	__be16			exch_base;
+	u8			VFT_hop_cnt;
+	u8			my_fc_id_idx;
+	__be16			reserved7;
+	u32			reserved8[7];
 };
 
 /* Which firmware version adds support for NEC (NoErrorCompletion) bit */
-- 
1.6.3.3


--------------030202010502080100010309
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
ewg mailing list
ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
--------------030202010502080100010309--
