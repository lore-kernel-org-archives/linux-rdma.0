Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011005.outbound.protection.outlook.com [52.101.62.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1378D377AAC;
	Sun, 26 Jul 2026 09:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785057001; cv=fail; b=LQdmtDEELSm2QaXV4B7hr1Mb+PbY/VaFlfWk3VHfo1LdA3GDWjnCCv2bvcLZ1+c0gk6wLJM+k0QwYB04yZfZw8NHEKRNcDlHHQ/GEm+XKRTo8MZ58nm3fu761pe6ZFalAtmj4g93vZx5iWZagSmtctMLtMMn609FbzbKcXkIGVQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785057001; c=relaxed/simple;
	bh=IEIquP7m/KvqmmajHmFsYp2lTx1b9u25nLAs57DDiY4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=N+sVsoIKMMRoYrSjn/uaCjJZkGVkT5Pnf2A5Fsx0SnB7atuKaaxdHT3aQkhlasWZo0CjJy8M6C0d4mQPCh/DV8iFsfH4Njju+2arf2VX7SEZ5EjQUM1TB81cBN1l6bclCs0VKxec+Lqn0Q1nxsQirbgCpNLkCdZicz8FG5fgNR0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tlXhXt21; arc=fail smtp.client-ip=52.101.62.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tlXhXt21"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ihn0cl0inTH54rkt5mieQmt+a3/VG6hy8NiblxACGyHodGWhjSBZBMP2CACGN4kntwGjaOPqmhKAEA+0wzHJgcaSwkpVH19tpsu04hYTlYvcGzKelzvyyl3R7z8L16x7W+NmZLgzgIYGB0vnwqMWAMIw7ZHB4bg32jFE0jJvS23yTNiMM4HLiOnR843WukBJj6TzcSA241Tae6fk7iPo0F3noyMvKQf5uVOkQLrZ1qe5hQW3NskHkYRoMQ93cMHp4HIalajWXpRfi3Y3DxHbdiroY6Q7nO6S/GnVL7KOr3qtPzWYzNCErwQ+/WeNGqIa/NCx+EB0ygAWeH2+/jQvgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7GTH7aDIOzwn2FDoFWtVs999P0wcjSAbC4YQKRKzq8w=;
 b=qVdvyWvOP2MxR0IOucVOVuJcp/PzHTs1e5+Q42MoD6jwQfQ5kvqlpSZXsxi8KqHCTr7NeYXXMEY7yTRfK0xsp2VXbM81W4VCNDD1aBf5ULU8fYq4IdKv+mrzKKa56SDWPsabF8BG2Rz42c53fikkoQoeykMZTB36QW1ZpGN6NMF2tlrs7A5g/kEiQGyTH5r0MfxWSscs/AMopL+RXQGS/7ptzXyfIcVhQvtgNTHnaXjeDdsE39l6PqQA39nagsOH389YSPAJzImXxMIJqq/5F/kzsX74XIpZrokHlaYXHKn5d70sEoj6dUZ6ytrqSdqwm/PHeAfBZCZK1D7RnGJUdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7GTH7aDIOzwn2FDoFWtVs999P0wcjSAbC4YQKRKzq8w=;
 b=tlXhXt21biEHthdrEgG077cvdwtSvgyRCULqtkZPsELrJpOPEn+uVD5+QO6Z7rOQjCsqMiP6r0iGixqNNjlJDG05VMy4AV9vaV3QLKgMQd07SMvCsmJCs8/7iJz2wb9gf6W8KniaC7qQ8R/HEBekFHYqHT6xdqBPGIPFAlzu/uk/ndpOH+x2/oFCCNdLqJBq+2/0NpGeSZbE24XNWms4N23CRRb5J+nVnfIo3OoEzaAJZFE5FzU5vwZennD21u1QJaBnWruIVT6imAPb7rFiOH4jMx+9ztnMv1HuI4EyIJyU6Kb1M8rf7SZhs41LcvbBTJzR07i62dk1nhMF3Hab8A==
Received: from BY3PR05CA0026.namprd05.prod.outlook.com (2603:10b6:a03:254::31)
 by SJ5PPFDF5E260D0.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::9a6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Sun, 26 Jul
 2026 09:09:54 +0000
Received: from SJ1PEPF00001CE6.namprd03.prod.outlook.com
 (2603:10b6:a03:254:cafe::f) by BY3PR05CA0026.outlook.office365.com
 (2603:10b6:a03:254::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.8 via Frontend Transport; Sun, 26
 Jul 2026 09:09:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ1PEPF00001CE6.mail.protection.outlook.com (10.167.242.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Sun, 26 Jul 2026 09:09:54 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Sun, 26 Jul
 2026 02:09:53 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Sun, 26 Jul 2026 02:09:53 -0700
Received: from [10.135.59.1] (10.127.8.10) by mail.nvidia.com (10.126.190.181)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Sun, 26
 Jul 2026 02:09:50 -0700
From: Edward Srouji <edwards@nvidia.com>
Date: Sun, 26 Jul 2026 12:09:41 +0300
Subject: [PATCH rdma-next v2 2/2] RDMA/mlx5: Deprecate latency-sensitive
 QPs feature
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260726-deprecate-lat-qps-v2-2-5e0c2ee55046@nvidia.com>
References: <20260726-deprecate-lat-qps-v2-0-5e0c2ee55046@nvidia.com>
In-Reply-To: <20260726-deprecate-lat-qps-v2-0-5e0c2ee55046@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, "Saeed
 Mahameed" <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Mark Bloch
	<mbloch@nvidia.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<netdev@vger.kernel.org>, Edward Srouji <edwards@nvidia.com>, "Michael
 Guralnik" <michaelgur@nvidia.com>, Patrisious Haddad <phaddad@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785056984; l=2722;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=6AECL2w0c+zmx7KwsDI1jqwovell6TlNq9owtV4P6xQ=;
 b=QRacklWuyTSIYtT/QQAjFpiJCUU099GZsJfF68vALs3LIaHodFbKLtUWgqcUuGJQRf3PqkP4O
 BUXzxCGylJ1DTIBkvyXU1XuyzaQonHiVe5BqfxKjk6CC7aRix8SdMX9
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE6:EE_|SJ5PPFDF5E260D0:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d7767ac-087e-4c19-ce7a-08deeaf5a813
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|1800799024|23010399003|376014|11063799006|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	KjtCIfFkqzfiFcoNIuiPTXlzF13QssZ3CrrwUiSgK+99vqgtmAiBZ70szuPkpC/hs9l49FacxZpjtcTRhLga1vw3EFqx+HaG6B+F5MUkMCwLyu4v9gkjoCViWQyyiG2Rb63QXfxlxtpbcbRSb0wOIuJyFXk39BJYf81R7Efp3vQPPoxODwX3nevVXcVx50E0KOXfvID09AprgNsMBG8VmmlxidB7qNbNtT5UFgBtEvyRi0EoIaUEGzv7zF/bF2+L0U14g6UqInebs1ulwLBwZ5U7uVv09M6rehhejy2kOZciVo9Tol0s3KSpDRrhLXR/cmqylPkOMkE1omvdRMdDuAzkEmdHmmIVFFMRGoh1DqrdKi1VWIcs3jhNm2VcveGT0M0KJyqCiMJlPJ7xiMq4MTBqKWcgGiVGpy1kh8MFSH9JeeI4RW27+hxV2EAxDXJ+PUuqcdZE9slLR8tCdTAe0G4RzAhjX7o9dMtfvSGXkog6rLsOr6R5QIG07fss0SimfVhi54WhM7geGiM1w2X7J8NN7Bse9FL8EPSaplbMVxHgVaKwcW5wYxE6tAxm04lLPSY7eQ6wJtZeDdWfurxiGdTh6SnYzBji+WZRGbwTsfvuc/Dbifp5xspHimLx1tXmKnzXn/K2QGGnICP5lKLDcr9iR98sYBWmokWyFvZm4L7ZG/Bc2LGV4xy3BHYWt3d496Jf5E9KZBTf1w75t6SRTw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(1800799024)(23010399003)(376014)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	4e2jXCPHasJGq2dEutyo2WctiKhzP+wQQ/mQj5mZIRQ7AzOYP2g3iAE08/nwKkFHXtPM9MGmtJ2DzTzYJcGkqC03KGGGD+JGG+EjMKMkeU8TTAullMLjsaeDHIbBn1gfS73q5IxCVKOMwSXbxsexcCk0hm/2PqOUUH1ckp3BYJAPy5KmGBHO6/AZXxQGy9pHfnq3oMk/R+MosnTWqR61VqThEDTUOtCQRo8Is8qDKGd7LvCcDeDSW5P6TNSTtDbGDKE6qBI7VXek/DDyHBpq+SUWqXR/A1E3u+RVQSOPc9pKtFelnl0MHpG5kI3Snri18xbkp+4sPIRyzzQWmh3ZVUzMptyXJp2lPPysGMKzJYLFlc++H32ZWCpQzxeEPz7qkvazMuC6dS6Nq/qJAS4SvB/87tHIEmDnij6buou+JQcN0DLOhm0nv70k7FvmFyKu
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2026 09:09:54.0770
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d7767ac-087e-4c19-ce7a-08deeaf5a813
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE6.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFDF5E260D0

From: Michael Guralnik <michaelgur@nvidia.com>

New HW no longer implements a separate class for latency-sensitive QPs and
advertises this by a new cap bit.
REG_UMR is the only QP that used this feature, so gate its usage of the
feature on this cap.

Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
Reviewed-by: Patrisious Haddad <phaddad@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c |  6 +++++-
 drivers/infiniband/hw/mlx5/qp.c   | 12 +++++++-----
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index d65ebdef28234fe91ad4c24a5ded2d3af8bc646e..a0f5341f40ff1c0414939dba50301f0255825065 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4950,6 +4950,9 @@ static int mlx5_ib_stage_bfrag_init(struct mlx5_ib_dev *dev)
 	if (err)
 		return err;
 
+	if (MLX5_CAP_GEN(dev->mdev, qp_latency_sensitive_disable))
+		return 0;
+
 	err = mlx5_alloc_bfreg(dev->mdev, &dev->fp_bfreg, false, true);
 	if (err)
 		mlx5_free_bfreg(dev->mdev, &dev->bfreg);
@@ -4959,7 +4962,8 @@ static int mlx5_ib_stage_bfrag_init(struct mlx5_ib_dev *dev)
 
 static void mlx5_ib_stage_bfrag_cleanup(struct mlx5_ib_dev *dev)
 {
-	mlx5_free_bfreg(dev->mdev, &dev->fp_bfreg);
+	if (!MLX5_CAP_GEN(dev->mdev, qp_latency_sensitive_disable))
+		mlx5_free_bfreg(dev->mdev, &dev->fp_bfreg);
 	mlx5_free_bfreg(dev->mdev, &dev->bfreg);
 }
 
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 7ff02d89c31d5b4db4c94453efafc0fce212acea..9253402ed645c9985eed098d3b21bea638028218 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1123,7 +1123,8 @@ static int _create_kernel_qp(struct mlx5_ib_dev *dev,
 	void *qpc;
 	int err;
 
-	if (init_attr->qp_type == MLX5_IB_QPT_REG_UMR)
+	if (init_attr->qp_type == MLX5_IB_QPT_REG_UMR &&
+	    !MLX5_CAP_GEN(dev->mdev, qp_latency_sensitive_disable))
 		qp->bf.bfreg = &dev->fp_bfreg;
 	else
 		qp->bf.bfreg = &dev->bfreg;
@@ -2509,11 +2510,12 @@ static int create_kernel_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	MLX5_SET(qpc, qpc, st, mlx5_st);
 	MLX5_SET(qpc, qpc, pm_state, MLX5_QP_PM_MIGRATED);
 
-	if (attr->qp_type != MLX5_IB_QPT_REG_UMR)
+	if (attr->qp_type == MLX5_IB_QPT_REG_UMR) {
+		if (!MLX5_CAP_GEN(dev->mdev, qp_latency_sensitive_disable))
+			MLX5_SET(qpc, qpc, latency_sensitive, 1);
+	} else {
 		MLX5_SET(qpc, qpc, pd, to_mpd(pd ? pd : devr->p0)->pdn);
-	else
-		MLX5_SET(qpc, qpc, latency_sensitive, 1);
-
+	}
 
 	if (qp->flags & IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK)
 		MLX5_SET(qpc, qpc, block_lb_mc, 1);

-- 
2.49.0

