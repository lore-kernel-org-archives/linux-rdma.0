Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.64
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792510686;
	b=Y0YRlF3zrvvcLEn+9jcyb2fw4D+wRkdngi4DgyvKiRvZy26MItrWYyu6CWCq5J0A4ZfP
	 lWg4HvLAOIQ9n5nuDtmS/DyWlJbGhkWl5ph27Mqjxd8Ywn00GyFSURfTb+AEa7BYBtbJ/
	 jBmVno9ZWr+eSjHAq0MxrKR7TY68EM9fxA/iEyqW+GXF7XsjsxVTHt67baqx9uiB1VSU/
	 s9gypwmMtobWw8YqQ4HQcBVA8w0AicbsxJvSLZKpgIlvnev+QBUG8XaLFAymPk9BMw7g6
	 ep8L3J8uexpEZxENqUBtoPi7IsbuDVc7GZJOFCSWEVJ0bPimcwYMfBGQ6GZmiyGmn+w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792510686;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-NV-OnPremToCloud:X-EOPAttributedMessage:X-MS-PublicTrafficType:
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
	bh=bpGkno2UJbNxpH7zyJlPfvvfmItoDaARVRdYTWFmY68=;
	b=lgd20nSDLrqkMViTG69rmgjtCTsbsRXrszDw2sXSCHSd5MMjzYPfMYPBnIfgi+USNMMO
	 a6+tzcooaD4Vdw2GwT9EGmJqABDuPxEBbsnjcfkOZ1pjUC7k1hqjZJv6tmFXUPj70ehqj
	 UICZyfNO9GTSdTDfYwtJbHAsgwjHYOxwK+XS8gM649BCVi36+vqMu744JgW/Zt2NCdk6X
	 7Uvmvper3I3ij3+1H69gl4gxzoo7dba3EjK/cYhsKsS3RlVo19hwXz5+boJmVoRmkSDsr
	 0kTdBdZAZxDUw6TdAKtm6pclIrvPj8C6q2CODoM6b8jXPGYAPYgmZ5uvyLV0GaEIjxA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=i1tTqkhj;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.64
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010064.outbound.protection.outlook.com [52.101.201.64])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41539606A323;
	Tue, 20 Oct 2026 15:38:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41539606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=i1tTqkhj
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f5vA05/KUK3HiuLnZmdsuLxR4VXf0A/QYEPIfsYqW95jm6gIhSqul7yskER1UxmnNwYQiCHT/ak9oEuc5EnKupVgT5h/JjKDiC4obOZg3gjuKagCGLwkSfYhvOGre/VgO7q3a7yJG35F8+XcNSXzMmBbT2v+zi53xYQ2AgOMaPBB9/NCG9MvPn6u1Y21oai2e16DYGSAmlZQp6qWJJ/HvwYe4TYDBjM3wjo0wxdh5ZAEBeaJ0S7VlPwRTqJHALBevYXbV8f4k2GemhaMqAd/y9p8sSYB31WWiMgOsgKaoTtcr2XScTICi2EcRcI73CzGFjda/BXDBudQDOkfV65bMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bpGkno2UJbNxpH7zyJlPfvvfmItoDaARVRdYTWFmY68=;
 b=S07+GE5FYzp/Q/iUIztvhiFA9tRv5AxvDAoIjD8ycsiKdghX9cPBo1MwODN103p66+KQO8Ma+NYaebMq+kXnCrYTSyiH+Oz0PyJzfhLTHhJjtscwH5MA08Gigq/QBwtyfECe2bMLmDWERY9t+eKUncXwKR0bsEvgHoSuAj3RmrIONIbq7DFr72GPfCRS8KYjMxH2Fb+vM8RB3Vb6WueN+13fzOVMjPikJgr4a14s77BuyyNum+6XmUh0ZkaiEpuUeeNj7E/FRtAB0ztq2crMQdazqsQBCiTLLIokYuiVn1TiHQAfVmQMOi1x5EpMOSeB4nnQvcWLnHVaD1LlmZo1Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bpGkno2UJbNxpH7zyJlPfvvfmItoDaARVRdYTWFmY68=;
 b=i1tTqkhjZJf7sUgUxXKLvewCTz1xqnz7a/u/ckq2rnkcPdYlbc74NvNR2Infd798XJDzSje6Mo8ix5kZXy9Riv4oos6H+O7A+6xaR/98M20dDqtI5MRaQauXocCNXvIBjtOQ/CE4nIXNFObM17Rp0HN+1Ouk5qSZPrHXYjXnjbzvTwlD2K8L134WBgV9FLcPKLSniQG0k8ZFb9pG29rj6H6eQWE4slFa6PoTCpz7609BiI9ceAwqoluJtfNJBsF268a0xcMRpp1bG4azzi5CElYWNgBTqIoSnW2Fr5fdJ+432zl9t7fafdah0ULDS/75Yj3ASYj6ZV4m7iHAVzpUvA==
Received: from MN0P220CA0022.NAMP220.PROD.OUTLOOK.COM (2603:10b6:208:52e::12)
 by SA3PR12MB603307.namprd12.prod.outlook.com (2603:10b6:806:58b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Tue, 20 Oct
 2026 15:38:03 +0000
Received: from BN3PEPF00022BD1.namprd03.prod.outlook.com
 (2603:10b6:208:52e:cafe::a1) by MN0P220CA0022.outlook.office365.com
 (2603:10b6:208:52e::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.17 via Frontend Transport; Tue,
 20 Oct 2026 15:38:03 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN3PEPF00022BD1.mail.protection.outlook.com (10.167.248.171) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.546.15 via Frontend Transport; Tue, 20 Oct 2026 15:38:02 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 20 Oct
 2026 08:37:38 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 20 Oct 2026 08:37:38 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Tue, 20 Oct 2026 08:37:34 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Leon
 Romanovsky" <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net] net/mlx5e: Stop asserting for RTNL when closing channels
Date: Tue, 20 Oct 2026 18:36:59 +0300
Message-ID: <20261020153659.3440902-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BD1:EE_|SA3PR12MB603307:EE_
X-MS-Office365-Filtering-Correlation-Id: 809cd97f-e176-4e8b-e22d-08df2ec020c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|36860700016|82310400026|56012099006|11063799006|261009223027099003|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	xk0skrMHfIvJaikovBa/u3QKqXIBCRw/DVfo3fYvqZnZwfv1WGMYDhoy1T12UIDm0KnrhSXgUsN9UacdMpa5BDz/bLgvoJI7nUTsEa3mPLXTWJdfP5+0hP1BejcItXIWwt+HBIJ0ioosICW4YHeMjJccdBa2tpz1qlb+SEn6yH0MvoIvT0Wz75xlrPb/sIm0XzUWKArRMG2wn2ZbgQVN2WYOoKo+hWxZX3DpZBa9Kgnl8yp9wJgS4+iE/qW61ml99DCPpawxjnbQ8dT8M4WtLzgvJqYHIJYw736lXm/78S/Vdg42mfEf1joYZO3E6bQm2eZIhZVBM2mpgBVyceBO86iVHhQgtE1vAcRtUwPIJw+EcPeH8sSHK1rGY5ZE5oZuKlpsvkm+RkZqW5mQEupd7+lsAD/DbBxC74J/VUBe8rvHWO/0qd8KpO5axRuQMI89tsf5NsXZrJZUxoRfuGcCb2zB6oizYMAzJIIvlWfoxL9S4kwQcQdBL67AyIADVcqLgo8smWZuvfxITA2a/3Qn8zcTNljjep/vdhaw9jmIQaOvlS/qetW7kXisRPVk44awjMgD/nnwyrr/gO6yAF9BASOKVod8HjW7TR+/O+puHxqB4KyLJ72utXqpP0I3ziUUE9Pc3xGq+vVUXQCEU07YfWtN6qj0LbFojH68u95eXpq9FJTeLudfmy3U799mPqy7n6H6G3Z9T2qoABReKVsqFg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(36860700016)(82310400026)(56012099006)(11063799006)(261009223027099003)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	tpX1mJjYVylZjvtK58+M4aEyUfsH6+sm8pzLV8fw5lshz24MuB1mRwNsIxWr4H/k8KzcOUhI0HW3p8Lm6f8tzYDpuQPUZFVaEcVg3awskvRpKvCxDraQfvA+MMuDwS7X2xsf/UKtrDP7WODc4scAleHMpEL+cBRbxzukKZ89SNcvGCsCfec3SyTzcfdK7oSaOxJ4jepShuLIa6V4jasMtVnlHVhamqF2UtbVtjIbXhgkh+aCUWt3fzv8Qd8hJTqAVXxTmZmLgay9HnIUaXoPpjydY/WG+4TH39kybar51cb1gAzzeipskVTnIXJW8q1dAD+3zRQFlW/iLDmdGJ2f8UX5aR5mpPLzLw2jcRkcC8+BUotA6bKat8qBPnEHoSAMBqiOw0JBAD9F4lhEBpXsI5pVhuV2bOsaoFQKI1Ln9MypavkHgzpQN4fo/lDGzK+x
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2026 15:38:02.6247
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 809cd97f-e176-4e8b-e22d-08df2ec020c2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BD1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB603307

From: Cosmin Ratiu <cratiu@nvidia.com>

mlx5e_close_channels() has an ASSERT_RTNL() from the time when RTNL was
required for closing channels.
But the driver has been switched to using the netdev lock a while back,
and this fired from a flow which was forgotten during the conversion:

mlx5e_tx_timeout_work()
  -> mlx5e_reporter_tx_timeout()
  -> mlx5e_health_report()
  -> mlx5e_tx_reporter_timeout_recover()
  -> mlx5e_safe_reopen_channels()
  -> mlx5e_safe_switch_params()
  -> mlx5e_close_channels()

The RTNL is not acquired here, but the netdev lock is, and it is enough.

Rather than switching to netdev_assert_locked(), simply drop the assert.
Upper layers (networking core, ethtool core) provide locking and lower
layers (NAPI helpers) assert that the netdev lock is held.

Fixes: 8f7b00307bf1 ("net/mlx5e: Convert mlx5 netdevs to instance locking")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 4c6060d54fbe..38ce7d0a9001 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3075,7 +3075,6 @@ void mlx5e_close_channels(struct mlx5e_channels *chs)
 {
 	int i;
 
-	ASSERT_RTNL();
 	if (chs->ptp) {
 		mlx5e_ptp_close(chs->ptp);
 		chs->ptp = NULL;

base-commit: b6ef0d965fe8ce0ee4b4dcb58b3511f83003e42d
-- 
2.44.0

