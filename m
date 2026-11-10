Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.56
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794335966;
	b=0AbcGABjf4wDTYjpZonqL8O8J521HZIWBXPqYnY56iA43GrKgfKkMQcS0khGPMrCrkSF
	 CodUQmV5pZapmmkmW5msgNHo8NIelDfL5Mqp8IFKuxlroLJm/hQX0WkYJALNhrdKIEL0B
	 yt7NpjmwQEqiFbXXKkqQXCSunymE1Tuu9rTINHD9P/xuU2BJcQFVFElH9QDAFQXUXO9EK
	 TtF7Uvl+8+IWzFnnRIwDzwCJRPoV97jri4j92jU+a1cXBAz7/yfsa65QWmaLYiUCysnzf
	 ufwwYKP+os/u8SEjYOUETt3Tw1gR4TZH4z5xxJlKsiEtupB4E29PjfSYJKJEEnzfiNw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794335966;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 Content-Type:X-NV-OnPremToCloud:X-EOPAttributedMessage:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=jOEMxoUEgyaH9s4xJSZpflr7D+DAKAUbyZlR15cMXHY=;
	b=HymDuUeH2skdROeoZX6et+iooJcEgTcHclWZMToY8u9HXooCoXT6CCrpT5IXSJyTC1iY
	 5Ib1fYkMKSKayGc76mAkenImF2gO9Q1EvociuDL2g89SWM/kCktW4FH0ExXYV1LLArvUB
	 ZjCtpkxfsPE7tJVjJmU+tliL7aB5ilFvdqMf67cmZjdoSNVOulARVWEkadnWXt4W0tTCK
	 rOqMaRhqSWZnOwfcoUZEMJAxUapPkJZoVPWwOdeyD5KLIHziRhNQOifFbvb/UJudBBEi0
	 /qDu8SbCWc2iFVDXUThF75d2C8y0AxcqIll15hQ9qOFP/BnaK941yfoLhuLo/a/vwog==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=UfN4GKg8;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.56
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010056.outbound.protection.outlook.com [52.101.56.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5416606A320;
	Tue, 10 Nov 2026 18:39:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C5416606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=UfN4GKg8
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NGnhLxB4XLNDKtGn6jPMq1JcGEsuDWba5mzzcUu5PCJzQkxB7TW+DKWsj6iT6+Fevj4XgZkMSdX7C5jRpHEsau286Lk4EO8Lt+lICHByiI7nMp3nJzYM2+1ZRIWdGQe9aP9QplpZUlqD5H3/ldejobAuYazRCm5NVhs+F2/6MLg+kddBbuFFhQqynhYODDuWuf5v4c+6+4HcV+S8Vn6cnOS6YMPe2gRzJlxK5pWx61q9enNfNEpW7NJ2jZ+0iOQsCgJItry/T1h+5YZ/9vXJY8QsgMape+M/+8DyDfHvYM63MLgjD5q+SiKgAY/eLxhVoNO+jTs56GpjqaK6ttPSRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jOEMxoUEgyaH9s4xJSZpflr7D+DAKAUbyZlR15cMXHY=;
 b=L3q4M5h/ZcHZSCJ4WqS7zKW6gS82tVI280CX++cP1v6FYYqrnKP4nJPNg1LdfjPTwML4l1UiDf8vTtnvKOQNrI5mmO00eEc/0T7nXZxlnxK90ZwGb0T8wGmChpYhOC6uiPapbioSsm9mrJoboQEDtWJZx7xrPYubnraIJpzLJusGMq1BZMjQ2Ocj/QCqIlMD39ByWb64UK/kMiE/nw6qi6ppJ5u4ANr7pmCVKeF9MYuNG76eaaT0CYSbUnsoknDAL65Uz9YmqYCX/EUspkgeTDkihWeowRoGeKr78jTYyVndysA5J6gLowhwHrKMpCGtS6AAdPj+5FUu8tQqXWcuwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jOEMxoUEgyaH9s4xJSZpflr7D+DAKAUbyZlR15cMXHY=;
 b=UfN4GKg8scBIGE0mPzkf6PZhONhPdSzO+xIlPmnVSJTQGXj2jlP4jN1G7Ioyqw1DP+J0tchBSi2fcvgwvwTYf+MYnphN5phO3D1U080QmA+pUY55wzjPkjttkI4g3BYNMUN0tm9WWgXjBnDyJmTMmC0vqsp9sXynje9Uxgs0vHfcl+Fer3DtSSkvmx9XRTlTDR4zZLPi5Zxd/+LnO7v/O1mezvQ/Mwqwq2LYBxPzyIdxWZN+mAf3hnwL1udLtHXN+JXdv6yomArGPM2U/cteefiQXi79GDiHk54PgE/ae4ub/iBrWR7xiXJBEyOqQjenHsibk13Mwr1f4VRkD/WjOA==
Received: from CY8P222CA0011.NAMP222.PROD.OUTLOOK.COM (2603:10b6:930:6b::18)
 by SN7PR12MB6931.namprd12.prod.outlook.com (2603:10b6:806:261::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 18:39:18 +0000
Received: from CY4PEPF000392DD.namprd03.prod.outlook.com
 (2603:10b6:930:6b:cafe::8c) by CY8P222CA0011.outlook.office365.com
 (2603:10b6:930:6b::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Tue, 10
 Nov 2026 18:39:18 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF000392DD.mail.protection.outlook.com (10.167.247.123) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 18:39:18 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 10:38:55 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 10:38:55 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 10
 Nov 2026 10:38:47 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Bobby Eshleman <bobbyeshleman@meta.com>, Carolina Jubran
	<cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, Daniel Borkmann
	<daniel@iogearbox.net>, David Wei <dw@davidwei.uk>, Dragos Tatulea
	<dtatulea@nvidia.com>, Erfan Sharafzadeh <erfansh@meta.com>, Gal Pressman
	<gal@nvidia.com>, Jacob Keller <Jacob.e.keller@intel.com>, Kaifeng Wang
	<kaifengw@google.com>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Matt Fleming <mfleming@cloudflare.com>, Mina Almasry
	<almasrymina@google.com>, Nikolay Aleksandrov <razor@blackwall.org>, "Saeed
 Mahameed" <saeedm@nvidia.com>, Simon Horman <horms@kernel.org>, "Stanislav
 Fomichev" <sdf@fomichev.me>, Stanislav Fomichev <sdf.kernel@gmail.com>,
	"Tariq Toukan" <tariqt@nvidia.com>, William Tu <witu@nvidia.com>
Subject: [PATCH net-next V2 01/13] net/mlx5: Log the data direct to PF device mapping
Date: Tue, 10 Nov 2026 20:38:14 +0200
Message-ID: <20261110183826.2927274-2-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261110183826.2927274-1-tariqt@nvidia.com>
References: <20261110183826.2927274-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF000392DD:EE_|SN7PR12MB6931:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f523d84-e2dd-4b1b-0a40-08df3f59edd7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|7416014|23010399003|376014|18002099003|22082099003|6133799003|56012099006|11063799006|261102123227099003|261021121427099003|261009223027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	TZDBWYbh3wsA55YEF2YR5qa72s3YtMCpK2hlqbjfamGf7ZzJTiNrUdC1VgrsFEUzfIDqZuNwTHsOBDIjIAS7wE1x7gzyQwwp1G4bPb2h6B5esv0gkqYW7aJ2lLSRrnIsS6Kn1Uk2/Xl0dT549jOS4bujVOKxBbEcQC7useOefcTCJYHAq6ouJTgwy9DWtpBU+idCEACw9OFuzXwyNWtZJVGNXtspnmTQpmFXMRbyjwel+7JcRwhPWUqOZyT/mJsQIgoNN+ToFx6z55CVtVo3Lj+ufEimDY4W3yc1yYDtkak8RPJlvKmryp0oPG2VwJNuHh2n0UhGQ3elrTgYSrtamc4SkHKT42KDL+k8PolYC73EB9Nf1H0E6uAGdALYDc9arvXx89uWIBv4eUQ+dyl3CDxgZ1DZ/FtrehxTevMx5A4mYxPCs/O2jjx2GMDr5vTDWUvC1Yx5d4vnM5tFVsBVk/+cZz+b+hKFfmSVUzH40BVe/nptMSht6Dr8t98yiVDsG0mq0ajnO+7RIeSdwmo18xTK0CUc5DN+8jqz1/ag42Og+sVeupFopCZ8PRCmsFjQdElfHhybKlgBZhYlfEQYT55V4P/2hAZAt5nTzJLiZ3+O/d8nqapokJzZWFXMQVFhaTVdStZiP62cTYexBnQyYNH2SdnWjH/JJHwGPqaN0J+73Rs4jVqAQlByD15vnrGNXmo+z0LLMny/k4235JQfbg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(7416014)(23010399003)(376014)(18002099003)(22082099003)(6133799003)(56012099006)(11063799006)(261102123227099003)(261021121427099003)(261009223027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	TfKsUkeZvw67qbC1CItBgw86yw5BwG8DPsTSThcJZXUO0vihtdTyLPIWW1MioBzmgD9BIb74uYRpzPIb2NUxRZK4ZzDq0iLv4s3vHxR7BvVMM8joEajWAVmjluYNph4RrC5kd67efOBAGEs8HRP2bh+VOHczqOLoNWxDswByjIJ6D1ZjnI7Lex4DABOPl6tMl2qySa5bzxDkc8bLwqBZryqN7s5UTjQ7s4mDBkvPs2a1rX64JAA147jkXXTeBZGFCKj6xnta7o+6darMwC2eqmB+nBKcOoBnwCkoiJvsql33tZRGVxD8Wc3ukC+iZzYnS72S9qdwJHNM49IaY8JNsT3uoQq723gsmx2QnXWfn3KG3MbcPOh5n9TOWjy6Gv3a4vxK6pbssy8q3r86OokUIEwIygfLsui1vQpSSSG1sutotMkapu1OuSTZzk/p2H9L
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 18:39:18.3859
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f523d84-e2dd-4b1b-0a40-08df3f59edd7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF000392DD.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6931

From: Dragos Tatulea <dtatulea@nvidia.com>

Emit an informational message when a data direct device is bound to a
PF, showing the data direct BDF alongside the PF BDF (the mlx5_core log
prefix), to make the mapping observable from dmesg.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/data_direct.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/data_direct.c b/drivers/net/ethernet/mellanox/mlx5/core/data_direct.c
index 5afb11a2a9f0..7db94b8a5b79 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/data_direct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/data_direct.c
@@ -21,6 +21,7 @@ static LIST_HEAD(mlx5_data_direct_reg_list);
 static DEFINE_MUTEX(mlx5_data_direct_mutex);
 
 struct mlx5_data_direct_registration {
+	struct mlx5_core_dev *mdev;
 	char vuid[MLX5_ST_SZ_BYTES(array1024_auto) + 1];
 	struct list_head list;
 	struct blocking_notifier_head users;
@@ -189,6 +190,9 @@ static void mlx5_data_direct_bind(struct mlx5_data_direct_registration *reg,
 				  struct mlx5_data_direct_dev *dev)
 {
 	WRITE_ONCE(reg->dd.dev, dev);
+
+	mlx5_core_info(reg->mdev, "bound data direct device %s\n",
+		       pci_name(dev->pdev));
 }
 
 static void
@@ -212,6 +216,7 @@ int mlx5_data_direct_init(struct mlx5_core_dev *mdev)
 	if (!reg)
 		return -ENOMEM;
 
+	reg->mdev = mdev;
 	BLOCKING_INIT_NOTIFIER_HEAD(&reg->users);
 
 	err = mlx5_data_direct_query_vuid(mdev, reg->vuid);
-- 
2.44.0

