Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011007.outbound.protection.outlook.com [40.93.194.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240E74322F1;
	Thu, 23 Jul 2026 09:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784800496; cv=fail; b=pBMASJi9GwD70uBffrNlw/vHoS1NwTzXffgpXGUW0GNLaGk47EfdfbO44g71/9KupCpRn8WS3wANYXWgMnWNk3zXQxQc8Dv80J17sRQS50UjKkcURA48KMptUZnOtrX0InTZ2hsHyFvxeQpTp6E+TeXiFNfsHh8B7xirutCRtlY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784800496; c=relaxed/simple;
	bh=/GCqifligbeh/pm5JS4f1e4WhClbttnsEWTGKyv8m7Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pAjsFHhJObMt2ANy3Ap/WIK1xNKWgwLMyKB0dIcnVJxr/EBv08i2sax13PSRHyDEYdZxn5DIa8+SIMlHuQeerkj3hfhB53RTp9efeBHUwU/CF9hzfEOhqBHC/b/zoJfvoJ5Y61aurrfy+mogI5c2dx2wHo1y9Ifw62dyWVUZNEw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=n+TsUuGx; arc=fail smtp.client-ip=40.93.194.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="n+TsUuGx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eijcxFT+OkgGBEaRh/l+4g2cDv1g7/ugbSwKnwFoCgh/wA98gettbXsYTD6sS9sgkltTYaomM2Dm8nxrnUCMjSNkWR9SBkI35Wrsh8G/0JMBrwXUzeivcf27iDSr1ciO3JtiKua4EeyXZjuBKJ/wgpMUXy5woy/GrXcsjGuprSHOMJTJSAvSo5Yxa/MsKM6hLLgqM2JE9oxcRNuTFGNwkg1GpkEvf5xQQ28NavagQwA28bNl5IWvRSQkEsyMhYLxCHgyH+Y/rO4T6pIJusQ4oftu7xQ0oVCDZJeQjl7WGDMP2HsEDse9aZYyBI1YVyOB1fKuLAo2nxBgxsDIQRZmzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R2A0NGAxy8AMJNr03AXwLbFBp1YCre7sWvchJGAg7oI=;
 b=CJ8BPYSqiBpLoNKSNVMRs5VQa3hsZnx6NtaCIqG+fdPCBAQrnp9ALUH+SgExVs+bbRwisdK9qmfpj8Bt8jGxies4wg15GWwFApmZpkZG5nPQtONE4FG5/yyAArGhevwcg4BZGd/tZSDFQ1L2hTnUDF1wb05BB95PhqLpX0HIgYgsVI6+MDmrEPieg0+Ls/2WxwBxmadUGUpKyclFkRHrPEtmVp05wC9IlmlShErdpDD5eAKFTP6X1bCYSl7+WSYw0ED2+w98oxGkDInTx6sed4VbvXJPcC4XpriFZV1gKD8o22mtf8ebDtkycjjTAzGKG7G7PKRBsZZea4WWbi7dWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R2A0NGAxy8AMJNr03AXwLbFBp1YCre7sWvchJGAg7oI=;
 b=n+TsUuGxv6ptoVU7tuFbCuzImeYR0nGDbLC2YFZZWn86SEAQcmT/vRi3Lo1RY8vvMSv0IVkeef80u0mTkGE2JJNOj/xjFShk64fpX7knh2VaEn+nK6QOlyjzCOHcDTssIUjTPJmAxywpZMAucDSYUib+2IAJPBQVY2K8pXcIpWNsmZfFuv4Y0Bq2Jlc45AfpGk/ULGJqOlaOakKzIXAHQgJYEf4f2EakZU98m6+5jhMMfsGOc3jR5Mlmo6nMPH/8V/3C9l8ybaSs4h7iVMbWchjQyZnlmAAmh+aI23Ocgv/Btbb2DgdUXDhdvsNKUsrmMwbX4wsP4ChLpvnn4WlfXg==
Received: from MN0P221CA0004.NAMP221.PROD.OUTLOOK.COM (2603:10b6:208:52a::11)
 by BY5PR12MB4049.namprd12.prod.outlook.com (2603:10b6:a03:201::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 09:54:50 +0000
Received: from BL6PEPF00022573.namprd02.prod.outlook.com
 (2603:10b6:208:52a:cafe::af) by MN0P221CA0004.outlook.office365.com
 (2603:10b6:208:52a::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Thu,
 23 Jul 2026 09:54:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF00022573.mail.protection.outlook.com (10.167.249.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Thu, 23 Jul 2026 09:54:49 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 23 Jul
 2026 02:54:34 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 23 Jul
 2026 02:54:33 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Thu, 23
 Jul 2026 02:54:27 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Alexei Lazar
	<alazar@nvidia.com>, Alex Vesker <valex@nvidia.com>, Cosmin Ratiu
	<cratiu@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>, Erez Shitrit
	<erezsh@nvidia.com>, Feng Liu <feliu@nvidia.com>, Gal Pressman
	<gal@nvidia.com>, Kees Cook <kees@kernel.org>, Leon Romanovsky
	<leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Parav Pandit <parav@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Simon Horman <horms@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>, Vlad Dogaru <vdogaru@nvidia.com>, Yevgeny Kliteynik
	<kliteyn@nvidia.com>
Subject: [PATCH net-next 3/5] net/mlx5: HWS, Set the num of queues only when alloc succeeded
Date: Thu, 23 Jul 2026 12:53:47 +0300
Message-ID: <20260723095349.1890983-4-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260723095349.1890983-1-tariqt@nvidia.com>
References: <20260723095349.1890983-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00022573:EE_|BY5PR12MB4049:EE_
X-MS-Office365-Filtering-Correlation-Id: 8db3980b-12e1-46ea-72e2-08dee8a06f66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|7416014|23010399003|376014|18002099003|22082099003|10067099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	xUkUTiSWj7NP3ZyqxiZbHUyE+ElkXlWwiHm0OPqDF/j9swKzMIPKt1habLArXOlNaFIlg6Uf/2RuIAUkH6v4bw9mtlUdRv8nC3l5NJtucYyNPM9E5806a5lM7NclDyjINBEX+Vgac36q7xAHgoHNiuI4X7wn+jOQsY2K6Zsq/OupYnuTwCyT1HPpdtj/oB7D5JXOc+ZX9EspihIeWPUHRzOJQw3yJkRTECTXSI0kMxthEKkGd0AIKqTsExgRNV+y/mbLrL66vsM550takigT9q6VKAm/MBivC0HWV1mj17XsMX/53/osWX75J9EjEHIuLN1vVkY2Qn/YaRjMqBBhlnUmXL0wtCEpLc52bEqG/TLzqJvNwfxeuc4Fb8+D5ABfNCDmfdtuW1vhB2NITVxNMqYY6UIiQbMdJyX9O1owkaxu5O5RLmK278OgomRmS5N5ZrTN4Wy8Vz5Z1rUf5SEek0pjc7Oz3Px1AK7K80vgjnSo9XfnKQO5EV4Yvxsukv7VhnrwZcBqtLGBkoezvypQ1Db0oHz1coek/NC8oO+ipN+IsZKs46Kn4I25wZ4xaHcstPGT/jh23Nf/Nl8laSVb9ulBESPMmh1BvqNwWOPYf9+Iy4SLuxb0FbEigpkgMwitNZzcxwJhnM3vjhtJe89ZJVprSKB+a2DgENyfAfbuGt5w9tPVR+El2j967dHjudUkMLL0wXElTIEM8x3/QIGlZg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(7416014)(23010399003)(376014)(18002099003)(22082099003)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	XcNep5diC68FWz2GHiMroy5QyURTvi0ln5guYu+lG2zFdUNnxIdo7kgUcmpqiXqyRtI6nfqEdEjlCitCDnVI8SpBrTGMXSZfnIkEtKLDToACzCeZ9xqFTFgFVwUMlfj6RgJ0fyxTWRhx5xPlDIQdvLLGqa3K6ZxtfejkMsDpBI14C08v0lcE2xO6BPRrb8ZKGr4fDMU57wFGaH/gT1Y038w0C1CG8KEwr9Uw84BJlq2MIhJmWx3cAd6/LXnB8a01GIPev1/ABdIVlpjg+h1NxjrUrDslO71ir0xfEfeFVNPtMJp3qjRTPX+4I2tQXjjCXemZQecG8C2RD+tqsZWSpTzrs2wmJtS43azCwvmnHgfx99ria1tsSgU3+wOJ0Hi7UwlT28SmsHTuPJNreGGhKeJ58TsH69w7zN82ptiuJGbAxP+SjOpVp9xp5y30h1T3
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 09:54:49.2691
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8db3980b-12e1-46ea-72e2-08dee8a06f66
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022573.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4049

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

When initializing send queues, set the number of queues only
when allocations are over.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
index 1c9206f74aaa..f0c3a2bda0c7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
@@ -1121,8 +1121,6 @@ static int hws_bwc_send_queues_init(struct mlx5hws_context *ctx)
 	if (!mlx5hws_context_bwc_supported(ctx))
 		return 0;
 
-	ctx->queues += bwc_queues;
-
 	ctx->bwc_send_queue_locks = kzalloc_objs(*ctx->bwc_send_queue_locks,
 						 bwc_queues);
 
@@ -1134,6 +1132,8 @@ static int hws_bwc_send_queues_init(struct mlx5hws_context *ctx)
 	if (!ctx->bwc_lock_class_keys)
 		goto err_lock_class_keys;
 
+	ctx->queues += bwc_queues;
+
 	for (i = 0; i < bwc_queues; i++) {
 		mutex_init(&ctx->bwc_send_queue_locks[i]);
 		lockdep_register_key(ctx->bwc_lock_class_keys + i);
-- 
2.44.0

