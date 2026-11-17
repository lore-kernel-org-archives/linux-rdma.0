Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.38
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794935471;
	b=aIj9wqHgdR7vwHFy9fmAeYQ084B4M9P8RN7Tl5BFhADKjWgHauek5+Xq4sLg+Ew/7Xm/
	 XbLowX8YMo7bHhUDl1IBH95Sj5zM4zDJXj1f3/pTLO5nbjhjYXsukjFSqACNvd7mw4V9u
	 YfPwubw7UB8ccfjzF2JUPFLE6YCfLhKXdZqEpe04VUw6O2V5YqdO7BtT3F89rOBk5A7Ju
	 DWNvH7phqXx8sPCldEivXoKljzSqFeA0SR9JbZaYnvOy6Uucz9y46bvRoalfPmRbH4ugJ
	 ncbEZPjX324Ndw1Q6pUCNq7qb6LEzA9nMO29nfjvVLssk99MMDUfjrf9j+qSwKMZ3fg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794935471;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-NV-OnPremToCloud:
	 X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=79Ietno09lvyap9u3cGalF67HqL1c+vPGQ4MKxS9ur4=;
	b=uv+wIAhY+s80AzTLxfbdtOa4Ar2TkTG5qCpRwOuQDvDqfaamx+REuZ/d4xG40wdzdaVW
	 LCbn0NG8YTidtLmwrcbJigGpQ3rVmRZWHx2Vbl4YOnHHn+be19ZGvhHkD0V2LrE45pU/P
	 pcvUo6s+kbL04CikQ6gl1AhAcP9+zLGbi4K9+akG7T7KlHkgmMF5breBDAJtH03Qrix8O
	 uLgn2fZ26rn0IclCYB9l+9iqVKW9JYa58UvioCM5Qj7on/N2SGE/cjKwh9bMfPA0KSE3x
	 e4jDOyfcSjEjxVey8CKwQ6qrulL43ws07jMfg9RMBVJSFcPnDSTRZ1D3wBHDVuYDKCA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="kUyNj/kF";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.38
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011038.outbound.protection.outlook.com [40.93.194.38])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 163CC606A334;
	Tue, 17 Nov 2026 17:11:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 163CC606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=kUyNj/kF
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BSVoW3bOQjTP7eVwCjq8NAIXmYM16E/apRz+6Xn745utJAdUGXzLuWV/CdHmryZxWtcnC85SxFPZEzh8Am43Zgfl1/IE4E6tOmVn5QvLIqJ1jv5JYWaR9IwnnH95wpJqrxO6TWcEiO8qSq15j0AJH++oq8ajDYE2bDcznvOiAjj2H0bPlDPyAVP468VYOQ+s9DeOytJVW725Su+wRaKocPU5huafwCJT1YajYyjVC6sKpERA7+2oPRYOF5ZgQooD4cHsiB/YOYdSBgHowxhtadRB2V4oz7FqwqCG4T123ReXcVYC/960UFqk/8fO2D6ejlQ5ybgmdN59fSH1+G3cTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=79Ietno09lvyap9u3cGalF67HqL1c+vPGQ4MKxS9ur4=;
 b=nZtJmoOnAkoy+dGXdcJYwXvQgcN2m4+EkNScijWeQzglWwTGiIsxP7YHSCdzTJnZ/KrY9GEbuSwd0l4ULULiGYfEZ5aJBgxZ4CSpcQyf5KRMoeqrRgjsiZ3p7yuwLxLU8G3Xw7KjI1xVFrVFpEJmcs0A1r3SfNvZzCg5h3HPHTfslJnc99JZTZToMNWO+HRW50jTPPB/S35sSOh92S/7xmfYbCONSDPVwwWqmXBTYdA78QoSjNxeZFRnWd7UBFxTDJ5xoS5TW8FamyqzLmwNm/kYj0DNNPTdciOTn8vNpVFdBaw4lSXkymBunU05bDlKOPlWO4+E/9jlCMwbDP+F0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=79Ietno09lvyap9u3cGalF67HqL1c+vPGQ4MKxS9ur4=;
 b=kUyNj/kFhwIay88iQEd9TRMESFFdaHeH33z4GUuQ8MRRgY0MtZ05vt3slKtcFtt2AvDFf3Pld03N4iH92O3QWtN1V5Z0orrQ/xT7L4jr7TqiXDqxJ1YtOia6H/ygHsWJT/yK4vgrEs27R9Fumj/e8neA1UPiOi5Ten9fZFN4CVmUCSbyBSuOc/KNBrulX+TtD0wJRvYs4r6/gnlRK5c3s/EYmNE3EyahSUOQiUCmZ0fE+gkiZ2/0Z0vfLl7rZD0QHCH2oCUKVNU0X4wwcR9FAM40N5psBo2I3e4i/8Ojbp6CTo0sO3m2yU/YnC6vnIePDSTNXgNInJRBUUhxOG8mkg==
Received: from SJ0PR05CA0010.namprd05.prod.outlook.com (2603:10b6:a03:33b::15)
 by DS7PR12MB6143.namprd12.prod.outlook.com (2603:10b6:8:99::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 17:10:52 +0000
Received: from SJ1PEPF00002327.namprd03.prod.outlook.com
 (2603:10b6:a03:33b:cafe::51) by SJ0PR05CA0010.outlook.office365.com
 (2603:10b6:a03:33b::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.6 via Frontend Transport; Tue, 17
 Nov 2026 17:10:51 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF00002327.mail.protection.outlook.com (10.167.242.90) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 17 Nov 2026 17:10:51 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 17 Nov
 2026 09:10:35 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Tue, 17 Nov 2026 09:10:34 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Tue, 17 Nov 2026 09:10:30 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V2 rdma-next 11/21] RDMA/mlx5: Add shadow FIFO infrastructure for UMR completions
Date: Tue, 17 Nov 2026 19:09:04 +0200
Message-ID: <20261117170914.27410-12-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20261117170914.27410-1-yishaih@nvidia.com>
References: <20261117170914.27410-1-yishaih@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002327:EE_|DS7PR12MB6143:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a6918e3-b112-48fc-e46d-08df44cdbbcd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|1800799024|376014|23010399003|22082099003|18002099003|261009223027099003|261022113327099003|261021135927099003|261022075727099003|261022105027099003|261022115727099003|261021123027099003|261021121427099003|261021133027099003|261026130827099003|261026140227099003|261026121527099003|261026135527099003|261028144727099003|56012099006|5023799004|11063799006|261021130227099003|10067099003|261102123227099003;
X-Microsoft-Antispam-Message-Info:
	o0ZbKktsCm6u5fr1XwTTsrZjHE7TmNwtERLrbanvV+/Xpl1IashW7OWBFedk/K3Rly3IQezVt3BBaO/dX6Q82y+WlLRCuNE7uF5Hrj8Q9vF15ik2JRSA+6w5g5agoja7WbbdYjf+Tc3ATzkG2RmO0AvUtc65LyUyEwHlB0Hih788ImGBo59Qbkjzb8Y5AIA9WwDMd1C5/jPvHHC7jyHopW5wnjhyhWh0OxACZ04ot9v9u1vHoo/iqC+oiQbuEO6lJFxy7ReeS9frLxS69OOazGcgD225jZnLoYY3328K3UUOmm0F0dC3g+ySw3SPcdPSLQIHqFgljOmvoX6vI19HX4xjHFKLGg2oDyjCP/rbsGNOxOLeJdnEInEh92BpesWk0xKbFJm3blKCqBH9rT8sYCXAsmZgk9PDTYTuYe+Bvk10DmAHH5XjkQQa1LoaILzI90kHe9caYWDIuNp931Cyglm6piT41oAudLi8z4fsIvKZ1JSykl2/tZicngIZSJFvXf2aJq1sUrdDjdYkQTO1aujlAcvA/HCZqAcQfyWxOPlt5a2n6yM6A7hCr6wMpEMCk/OA9t38UC7cZiTNgad5QBjmN8DHJgca3g0ciN2sDIQsgphCuLm4gEDpUBaOjvYgbMBhtBpaQU2Eu0gSkJ7pxD1tMBp6NCy0XQBvTH4LOU04Tz4qVO+0DQ+z09GZur45LIAFErotzhJ8uVh1X2RVcg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(1800799024)(376014)(23010399003)(22082099003)(18002099003)(261009223027099003)(261022113327099003)(261021135927099003)(261022075727099003)(261022105027099003)(261022115727099003)(261021123027099003)(261021121427099003)(261021133027099003)(261026130827099003)(261026140227099003)(261026121527099003)(261026135527099003)(261028144727099003)(56012099006)(5023799004)(11063799006)(261021130227099003)(10067099003)(261102123227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ELwH6DWvCWXE0dtJwm0RGQnfDEIRo1AjszA9QdKDi4UvMlKgtCyLaiM875HDKj89u5syMr2zrgq5LuBH//chLZrkDaClksYS4I74TNEgS4URtqrTNDQkXddg+USVNI5Y4STPUoEeP/kEvzpAadqI2j9O0lJvnEGo/V9p5+M3yesoS1fL3VS0jtCKG7lBSfWx+X8+WZaFfKke1R7z2JDEfmulV1HhyyS8+x45f4vDSf6ufWSkioSBefseAlqxjvqzt3DelHvMdzVzL9LlSkYo82qfPJJQuMObkflMoaX61c/IatnTrPnqMHYbRXGRmIGqfdAgImxkfEoTAVSBVYA1qhLyms590ujY4ur9qAzOtxzC9zewPOBwc74eS2taIPK/7Qw4NN4Ox4IjPtDDXfcIKDPY/gM948HsGujpYF3BUiXyNrySk/2ilrzNyZQDTlpn
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 17:10:51.9546
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a6918e3-b112-48fc-e46d-08df44cdbbcd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002327.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6143

The UMR CQ is polled by the generic path, which finds the completed
request by indexing qp->sq.wrid[] with the CQE wqe_counter. A hostile
NIC can forge it to complete a request other than the one that really
completed, or one that is not pending at all.

The UMR QP signals every WR, and its send queue completes in posting
order. In adversarial mode, keep a FIFO of the posted UMR contexts, so
a follow-up patch can check each CQE against the oldest pending
request instead of trusting it. Each context also records the
SQ producer counter it was posted at, as its address alone doesn't
identify the post: it is usually on the stack and reused across posts.

Nothing consumes the FIFO yet.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 10 +++++++
 drivers/infiniband/hw/mlx5/umr.c     | 42 +++++++++++++++++++++++-----
 drivers/infiniband/hw/mlx5/umr.h     |  6 ++++
 3 files changed, 51 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 5b81d7596bea..08d2a37a5f3b 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -756,6 +756,12 @@ enum {
 	MLX5_UMR_STATE_ERR,
 };
 
+#define MLX5_UMR_MAX_WR 128
+static_assert((MLX5_UMR_MAX_WR & (MLX5_UMR_MAX_WR - 1)) == 0,
+	      "MLX5_UMR_MAX_WR must be a power of two for FIFO index masking");
+
+struct mlx5r_umr_context;
+
 struct umr_common {
 	struct ib_pd	*pd;
 	struct ib_cq	*cq;
@@ -769,6 +775,10 @@ struct umr_common {
 	unsigned int state;
 	/* Protects from repeat UMR QP creation */
 	struct mutex init_lock;
+	/* Posted UMR contexts in posting order, adversarial_mode only */
+	struct mlx5r_umr_context **pending;
+	u32 pending_head;
+	u32 pending_tail;
 };
 
 struct mlx5_ib_port_resources {
diff --git a/drivers/infiniband/hw/mlx5/umr.c b/drivers/infiniband/hw/mlx5/umr.c
index 4a3fa79eba3a..bd180cb7f211 100644
--- a/drivers/infiniband/hw/mlx5/umr.c
+++ b/drivers/infiniband/hw/mlx5/umr.c
@@ -98,9 +98,7 @@ static int umr_check_mkey_mask(struct mlx5_ib_dev *dev, u64 mask)
 	return 0;
 }
 
-enum {
-	MAX_UMR_WR = 128,
-};
+#define MAX_UMR_WR MLX5_UMR_MAX_WR
 
 static int mlx5r_umr_qp_rst2rts(struct mlx5_ib_dev *dev, struct ib_qp *qp)
 {
@@ -181,6 +179,16 @@ int mlx5r_umr_resource_init(struct mlx5_ib_dev *dev)
 	if (ret)
 		goto destroy_qp;
 
+	if (dev->ib_dev.adversarial_mode) {
+		dev->umrc.pending = kcalloc(MAX_UMR_WR,
+					    sizeof(*dev->umrc.pending),
+					    GFP_KERNEL);
+		if (!dev->umrc.pending) {
+			ret = -ENOMEM;
+			goto destroy_qp;
+		}
+	}
+
 	dev->umrc.cq = cq;
 
 	sema_init(&dev->umrc.sem, MAX_UMR_WR);
@@ -208,6 +216,7 @@ void mlx5r_umr_resource_cleanup(struct mlx5_ib_dev *dev)
 	/* After device init, UMR cp/qp are not unset during the lifetime. */
 	ib_destroy_qp(dev->umrc.qp);
 	ib_free_cq(dev->umrc.cq);
+	kfree(dev->umrc.pending);
 }
 
 int mlx5r_umr_init(struct mlx5_ib_dev *dev)
@@ -236,7 +245,8 @@ void mlx5r_umr_cleanup(struct mlx5_ib_dev *dev)
 }
 
 
-static int mlx5r_umr_post_send(struct ib_qp *ibqp, u32 mkey, struct ib_cqe *cqe,
+static int mlx5r_umr_post_send(struct ib_qp *ibqp, u32 mkey,
+			       struct mlx5r_umr_context *ctx,
 			       struct mlx5r_umr_wqe *wqe, bool with_data)
 {
 	unsigned int wqe_size =
@@ -245,6 +255,7 @@ static int mlx5r_umr_post_send(struct ib_qp *ibqp, u32 mkey, struct ib_cqe *cqe,
 				    sizeof(struct mlx5_wqe_data_seg);
 	struct mlx5_ib_dev *dev = to_mdev(ibqp->device);
 	struct mlx5_core_dev *mdev = dev->mdev;
+	struct umr_common *umrc = &dev->umrc;
 	struct mlx5_ib_qp *qp = to_mqp(ibqp);
 	struct mlx5_wqe_ctrl_seg *ctrl;
 	union {
@@ -267,13 +278,30 @@ static int mlx5r_umr_post_send(struct ib_qp *ibqp, u32 mkey, struct ib_cqe *cqe,
 		goto out;
 
 	qp->sq.wr_data[idx] = MLX5_IB_WR_UMR;
+	if (dev->ib_dev.adversarial_mode) {
+		/* mlx5r_finish_wqe() advances cur_post, so record it first */
+		ctx->wqe_ctr = qp->sq.cur_post;
+	}
 
 	mlx5r_memcpy_send_wqe(&qp->sq, &cur_edge, &seg, &size, wqe, wqe_size);
 
-	id.ib_cqe = cqe;
+	id.ib_cqe = &ctx->cqe;
 	mlx5r_finish_wqe(qp, ctrl, seg, size, cur_edge, idx, id.wr_id, 0,
 			 MLX5_FENCE_MODE_INITIATOR_SMALL, MLX5_OPCODE_UMR);
 
+	/*
+	 * Push to the shadow FIFO before the doorbell, so the entry exists
+	 * before a CQE for it can arrive. A hostile NIC can post a CQE before
+	 * the doorbell, so the UMR CQ poller, on another CPU, can't rely on
+	 * the doorbell to see ctx->wqe_ctr and ctx->cqe.done with the entry.
+	 * Publish it with a release, which pairs with the poller's acquire.
+	 */
+	if (dev->ib_dev.adversarial_mode) {
+		smp_store_release(&umrc->pending[umrc->pending_tail & (MAX_UMR_WR - 1)],
+				  ctx);
+		umrc->pending_tail++;
+	}
+
 	mlx5r_ring_db(qp, 1, ctrl);
 
 out:
@@ -303,7 +331,7 @@ static int mlx5r_umr_recover(struct mlx5_ib_dev *dev, u32 mkey,
 	 * This will ensure that all the previous WRs got a completion before
 	 * we set the QP state to RESET.
 	 */
-	err = mlx5r_umr_post_send(umrc->qp, mkey, &umr_context->cqe, wqe,
+	err = mlx5r_umr_post_send(umrc->qp, mkey, umr_context, wqe,
 				  with_data);
 	if (err) {
 		mlx5_ib_warn(dev, "UMR recovery post send failed, err %d\n", err);
@@ -380,7 +408,7 @@ static int mlx5r_umr_post_send_wait(struct mlx5_ib_dev *dev, u32 mkey,
 			continue;
 		}
 
-		err = mlx5r_umr_post_send(umrc->qp, mkey, &umr_context.cqe, wqe,
+		err = mlx5r_umr_post_send(umrc->qp, mkey, &umr_context, wqe,
 					  with_data);
 		mutex_unlock(&umrc->lock);
 		if (err) {
diff --git a/drivers/infiniband/hw/mlx5/umr.h b/drivers/infiniband/hw/mlx5/umr.h
index bda7123781a9..0b245eec521f 100644
--- a/drivers/infiniband/hw/mlx5/umr.h
+++ b/drivers/infiniband/hw/mlx5/umr.h
@@ -84,6 +84,12 @@ struct mlx5r_umr_context {
 	struct ib_cqe cqe;
 	enum ib_wc_status status;
 	struct completion done;
+	/*
+	 * SQ producer counter the WQE was posted at, matched against the CQE
+	 * wqe_counter in adversarial_mode. Unlike the context address, which
+	 * is reused across posts, or the ring slot, it identifies the WQE.
+	 */
+	u16 wqe_ctr;
 };
 
 struct mlx5r_umr_wqe {
-- 
2.18.1

