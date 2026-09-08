Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011024.outbound.protection.outlook.com [52.101.52.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87D138DC56;
	Tue,  8 Sep 2026 06:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788850437; cv=fail; b=leFBl3hVsWJ7ogBxNPpnyCTDPbWjIeYY5d5E4yXyI8g5uvkI1KRAPRa1IheVIXaclKn/KxlXQ7wPO2BCxbrTxokImgYp+bjHnrSZOsGaV0mBhE5cVSsYbaODVyYY6RJDlFwOnIIHZlwfKUhhzbosxkY0N/DZeklQGzjOMrqo3mA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788850437; c=relaxed/simple;
	bh=T5S3PBu1Bpy9aokSxvCp/IKhfwHjN55HKb6GFxN5AJk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OAW2GKfgY4qo4d/XnTB33mZCxwI7Wp7Vtj3bSQ5kuiNXnJGcaVFcGEMRPzq8JKzRuFO6nXLVXgk4/tfVUo5JGPZyT45POcvOHWtJX0bmVALkMk5Ax5vu3L6uWrdOz0mnKHU4r8RO5YVTS+p0R9pcqFWFJHZeNcB/PQW6XeDz3eU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ggZaCb7A; arc=fail smtp.client-ip=52.101.52.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ggZaCb7A"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AATTnJyUldNfqY1APN1kHhbEuXtGGBRpwDqPoiU13OpX6Ndvm2x7A2yzpV9BJml2iHZy571zxsxutNdBBLrVt/h+hYoz9mNjbJ2vQ56nli9VS1f1loaL8geHf/dUG4Q+4F07I3uw6VIaj8ZOE0MYU0OwQ2V8Q8sdC1lbX2i4XesdPjZkOVwasvTU2pPVjI0enhW4ECVSJaFGgzTRDV8RPPVIEGnbpcmszk3NjFXCaIkXwswCDR+6NVfqB6hWY7jWWbaY1Z8BN64H33551ZoYdm0l7ISJXgbpHE68tqbq/u7MlEhbsLjnDyYjqsuHDA1B40lYkVYG1grBczN4Bn+/xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VQwrEY0lVKouYPaSnkQLMapmOKzsb4BwniugkL3XInI=;
 b=K/PpOgVtI4UPjNCJEeMZQgihAMZBS/7YceK8Ldz7s3Ar58L9tFEVotjE6h0B9H6UB6m5vVtKqRvNIDg8PcO0CBb8Y1PoJjgC/5XhY79Woh+nwydXR05/mnpaPn8si9kIsQfJzHncUP0MIgvsKx06G1fHSM4y9Pj9mge3FbrH7e094TBiItc8aHaB4VwxWOCXsk+vSwiLGWOWi/rvfPBHSeXg1Wk6z+mir59pbLueAWSaIiGowKOuYmbXLjrHtPdSXJxuvg7X4pnHn18YnHwAla9RZ096YozLF23N/adMTgH6d+pdsw9eb1GR47xLTZppT7aB+uRMBSf1ss1AD/Ki8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VQwrEY0lVKouYPaSnkQLMapmOKzsb4BwniugkL3XInI=;
 b=ggZaCb7AQ4SEllRMjt73vvJR9jLr4LZpWBfPkRlm8/KKpod+sNOI09yfc23diLgwaHGCISy/4NEcGs76jolG1pgqEThEdp4eCMQIK6+M+uGgmZzu1oVmW+MwXf0lv+B7/mzBDxrIoo1dzwsvTmnii1Uee0xz87f0BaevEHShy++PDAtu8U9IZEpUa0jUMieWcogRLTp/FLFp3sQNRnDYtv0ccRDssuEyHBaAOHxQZhNy2Q8k31iqOGl8AaL6i5Vbs0sjro4XsZkHUXAoANx+iwKN8EBGbz0ZMniXtVgi4+wbCiIlNu+Oq1qRTplMKd8vuYc9wxgb7lASpAM66ctUew==
Received: from BN9PR03CA0524.namprd03.prod.outlook.com (2603:10b6:408:131::19)
 by SJ2PR12MB9237.namprd12.prod.outlook.com (2603:10b6:a03:554::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Tue, 8 Sep
 2026 06:53:50 +0000
Received: from BN7PEPF000000AA.namprd05.prod.outlook.com
 (2603:10b6:408:131:cafe::4f) by BN9PR03CA0524.outlook.office365.com
 (2603:10b6:408:131::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.15 via Frontend Transport; Tue, 8
 Sep 2026 06:53:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN7PEPF000000AA.mail.protection.outlook.com (10.167.245.234) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Tue, 8 Sep 2026 06:53:49 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Mon, 7 Sep
 2026 23:53:36 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Mon, 7 Sep
 2026 23:53:35 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Mon, 7 Sep
 2026 23:53:28 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>
CC: Bobby Eshleman <bobbyeshleman@meta.com>, Boris Pismenny
	<borisp@nvidia.com>, Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu
	<cratiu@nvidia.com>, Daniel Zahka <daniel.zahka@gmail.com>, Doruk Tan Ozturk
	<doruk@0sec.ai>, Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman
	<gal@nvidia.com>, Jianbo Liu <jianbol@nvidia.com>, Kees Cook
	<kees@kernel.org>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Petr Machata
	<petrm@nvidia.com>, Raed Salem <raeds@nvidia.com>, Rahul Rameshbabu
	<rrameshbabu@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan
	<shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Simon Horman
	<horms@kernel.org>, Tariq Toukan <tariqt@nvidia.com>, Willem de Bruijn
	<willemb@google.com>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [PATCH net-next V4 02/14] net/mlx5e: ipsec: Block TC offload when IPsec is enabled
Date: Tue, 8 Sep 2026 09:52:32 +0300
Message-ID: <20260908065244.3799142-3-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260908065244.3799142-1-tariqt@nvidia.com>
References: <20260908065244.3799142-1-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN7PEPF000000AA:EE_|SJ2PR12MB9237:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a761c45-ac74-4b5e-e9ad-08df0d75eff6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|23010399003|376014|7416014|36860700016|10067099003|22082099003|18002099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	ew+quQ46nsyO4XgBVoBvYTTAzZ6jz7eJioRxuVxoDCyE8xvPPkPAzGvn3vcg5s3mSXxrhrb7ks1lA6uuSjjP1ececZ8xU5tzjLjCvCdfUuLT5D4eJA2B1/AEi3vKL+P8Zuj/Vhg0LzHDeBdM9dj7btYu6TKyZ5kL9dPVkCf/x9JOwuUlrmpRLRvZgywgyTtePJknYt+DL2PyslGLAtPgYd50+1Hh1yHwE3YPJ/Im2Umjk8X82IzjFPwRqHMS3L51/a5BxhvRS2hss2XV+oXeAu62arEwXykouIEoESyusAVMpyM3DS9Z6D+JyKXWJWvWhv4SBveOl86PDG5u5wwl6Yt9lGOrIy8+8toqtX4ggupVBDz7ddaTOIXk+5Qrq/9rYZBwi0p5GecP8MNxOcMSVeyDIOcIxX+SH555tJ3S6QVpg9ueMqRdRldkjRm0CimoUqLPmHh2HzBXZFm/PCSWs5JmWaeA+tk0bUZZv3of6OTeHcEkZuBmLkWgyNnO/4Dg5Cw0Lh+MRTJhYEEHRTVkU12Xq3e2TfJT6Vn/SEUrxJBhbJo3dI3lYYqXRJ8OO3MUejtDJBp8FpKnSh1qeBXdX7M6nNempORsXlWhv+XNV/4Gb0n0VPFmQyscbSn70nfEFd2xDJYUEN1FefG8HzJn1caGL03yKMtageCPvpjDqetvIjVaHuNFCAgpA0uTo+ED3ibiDPrazjGekRMwAqhvdw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(23010399003)(376014)(7416014)(36860700016)(10067099003)(22082099003)(18002099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	fh2YLHUuLbzufdeiqHtblvMPPNwL+/V0CCo8qXiawWlsbQ089tLL6D0fptwX+qBejYhxB5Bt9kgIo/JZtgDCYAhGhju/ebeT3Ugt1P6FsEUy6xUxR8BmWKeWKcM0ZkThV0jLXsowTdOk9409JEr3ee+cqeBCBa7MfGnc9f/Ub4Y8Lf8gY4EW+FPy4uLXGv3kSisWLuxqP5E2ekgu5PqCvf3CpPmm6JsuQkQEgrzScguFItGHgRiAYgyPgGguMsqjqg7ukR7cgbC6DGfdw1DHQSUvo6Wr0r0dorN82XSZfwDf8lV0Mmx1kJzEZ0xHtmfxJyqHY3mb+QdJjLUhIzt5smKOiWfmtyBuqm/1wB+41A8DLyUA1cyOD/0/2Ah6eViKwLPCm9bVtKbdh4RqPp3v+JdDcfvu8HVPpNNikrH/Kz5nPslZsRxhObhS7fzXl4Fu
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 06:53:49.6354
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a761c45-ac74-4b5e-e9ad-08df0d75eff6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN7PEPF000000AA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9237

From: Cosmin Ratiu <cratiu@nvidia.com>

Currently the mutual exclusion mechanism is only used in packet offload
mode. But with the upcoming changes to flow_tag, all RX IPsec flows need
to block TC offload, so do that with the help of a small helper.

Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 74e0aa5b6133..f236672d3a2a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -2575,11 +2575,18 @@ void mlx5e_accel_ipsec_fs_read_stats(struct mlx5e_priv *priv, void *ipsec_stats)
 	}
 }
 
+static bool accel_ipsec_should_block_tc(struct mlx5e_ipsec_sa_entry *sa_entry)
+{
+	return sa_entry->attrs.type == XFRM_DEV_OFFLOAD_PACKET ||
+		sa_entry->attrs.dir == XFRM_DEV_OFFLOAD_IN;
+}
+
 int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
+	bool block_tc = accel_ipsec_should_block_tc(sa_entry);
 	int err;
 
-	if (sa_entry->attrs.type == XFRM_DEV_OFFLOAD_PACKET) {
+	if (block_tc) {
 		err = mlx5e_accel_block_tc_offload(sa_entry->ipsec->mdev);
 		if (err)
 			return err;
@@ -2596,7 +2603,7 @@ int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 	return 0;
 
 err_out:
-	if (sa_entry->attrs.type == XFRM_DEV_OFFLOAD_PACKET)
+	if (block_tc)
 		mlx5e_accel_unblock_tc_offload(sa_entry->ipsec->mdev);
 	return err;
 }
@@ -2611,7 +2618,7 @@ void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 	if (ipsec_rule->pkt_reformat)
 		mlx5_packet_reformat_dealloc(mdev, ipsec_rule->pkt_reformat);
 
-	if (sa_entry->attrs.type == XFRM_DEV_OFFLOAD_PACKET)
+	if (accel_ipsec_should_block_tc(sa_entry))
 		mlx5e_accel_unblock_tc_offload(mdev);
 
 	if (sa_entry->attrs.dir == XFRM_DEV_OFFLOAD_OUT) {
-- 
2.44.0

