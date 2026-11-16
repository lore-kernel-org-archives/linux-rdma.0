Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.14
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794825085;
	b=t0v/D9ZqMx8SwjyTkcTETBwFoGt0vC8nrU5EWw1unRRBEy5dGA9iessb10QyDvbT2Oon
	 eK/q3n9v0P/2snkUQokaGOdPTAV9FFLTHbpvvHU8dyFvTNbNS2ZWUgMkq4tm2SZ0s0LRB
	 Vc/EcvD8MSOJuph0h4p6CzSN5pqT1sm3wM+7q5LM27OyaeV2r4U9Q6jAJM4piUpFlJPKk
	 1Iig4gthn/+9MgZwzdClwUNa1sy4VcPFd6pjl8zkChDjf+0AwXhFYrZPf1hT05mS42akc
	 rR7YEpvUgecdcB/fMNwRZDCM0syBgz9jckI3CVQY6Wo0HJBvozYBkUMuB5KeWfov3oQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794825085;
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
	bh=ddt9o0+ZGeNAnQT3u1udDaaU/5YnHDp56S0wz+eVJTI=;
	b=D0OsH9IjxGJRRjx5COpc7UMlsnBwSP9J26UCFASzphxQ7vMkjZgUCqXAXrV4R1kGcvvS
	 A0CmS38OqLd0/FzGzf3tP8bKiuDMRHoKd1bQ2xBcmQbVuAdZ0DWtVYizgSkx/Zl91GHZh
	 3STGjbxhdkhNTumin1O9sBAGH6r7v1FaGb4GPwkCSSlhHDrMpnghP25CNuQusCse1lezj
	 FRhnOVdk7fjsyyT8IftE1lA0IEvYn19M/8KjXQxrhyRgKlJV+jYGTyhdnFz9BQWSOf5Ro
	 WbgTVBcdc7CGvhUE9ByOqgFcz5+Gts4z8B74SXwmeAIX3p4PddhjnyCim7xvNLAHkJA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="tAF/QWzX";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.14
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010014.outbound.protection.outlook.com [52.101.61.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BE6606A335;
	Mon, 16 Nov 2026 10:31:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17BE6606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=tAF/QWzX
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sj+E+nfCnSXG7u7pgHYVha1oTbTXyCLuZm1xkRjtb9iTGLDQ6muxVU7Kj0s+yiZgaE3LT5bFDC5d1oaJYv+MHnXRxZ5s0mDURBgJGhqBXdvNKtvQeA6Gdt7zXnrXl7UFKZdOEzxvZiDUTO4viB7holVwG2s4fGc5dhAK9MaLovXU3TLGwVwUKHHgWkfsGwjcRFMXzKUYkE1iBOeMXSA+Ajgc/RHrN0m37DRhFE6MKxKXvQs0H3hzzIaFbLkG2EnGhBwo8vXf+trzMEhb5qelJd4Cl5c/rW48HYhvotowkBQ1BehXdKQFbbLtBO2yN2rFy4WYatjqGaWIsJ1WE6Tavg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ddt9o0+ZGeNAnQT3u1udDaaU/5YnHDp56S0wz+eVJTI=;
 b=VFCybN3rqqR8yZbqvikNV45hig1ui2KLIunTOOcEC0zE0erDingUgMvGFAv6lM1LxirsWbdNfJV0aNoIz/Q771vdCMwT7aGXPKD6clAUjoQi6IBUbyt55qVgtplZ1yVSI4bdtgIJTpt88q1UH//N3y1fLlFHp2cuinaBc5uokC+SHzCFr/RG1DMFq7Lk3KcwGIkn7C9msd6PcXC2Y1a9PNbyEIhx5Y9euLAJ5NwsWR5kWoEMfH7A/Vsqj+7r4kWtfCR2YTpL6NH5zL4Pu/TRtMIVh58o6JGaszjNyiaqGd+6V9MRNZ9c46cb4ueWgdxrLglD/bn7d4p/5+smlWDZww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ddt9o0+ZGeNAnQT3u1udDaaU/5YnHDp56S0wz+eVJTI=;
 b=tAF/QWzXvjhIMetJfNUHDzflSWVmMx8ofBtaopeBQ9H1235JSpxA+rwA6siYpW8y08GgkaTQMj6qG+d+SX/HzmUjeeb9jgue6EZgQQmtcr9U3h8RSMYvLBayHZbGjwaeoEwHBxTiKH0pIlhAZcUdExlI1hRJZmD+hyq9UHdPXscrlQgv+wAyiWpNIsseH9fvmaKaEQ1afhPdYX4zc8j9/mjnj8m108+1VClJy7lrcTe5T4zl8vF3Oa8q6Rly+xjRotBUQohk6BlK46QFqoDnDIHz79ylNowZAP92+UPGTDZaPidRwUJm1jBmnDYYHt6zDx4+a3VqNZsLyKkzi1jDrg==
Received: from PH5P220CA0013.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:34a::10)
 by LV1PR12MB104611.namprd12.prod.outlook.com (2603:10b6:408:516::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Mon, 16 Nov
 2026 10:31:09 +0000
Received: from PH4PEPF0000B60D.namprd21.prod.outlook.com
 (2603:10b6:510:34a:cafe::56) by PH5P220CA0013.outlook.office365.com
 (2603:10b6:510:34a::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.14 via Frontend Transport; Mon,
 16 Nov 2026 10:31:08 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 PH4PEPF0000B60D.mail.protection.outlook.com (10.167.243.88) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.0 via Frontend Transport; Mon, 16 Nov 2026 10:31:08 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 16 Nov
 2026 02:30:48 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Mon, 16 Nov 2026 02:30:47 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Mon, 16 Nov 2026 02:30:42 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>,
	Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Or Har-Toov
	<ohartoov@nvidia.com>, Patrisious Haddad <phaddad@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shay Drory <shayd@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>, Uri Dar <udar@nvidia.com>
Subject: [PATCH net-next V2 01/10] net/mlx5: Distinguish VFs/SFs in the SW system image GUID for LAG grouping
Date: Mon, 16 Nov 2026 12:30:01 +0200
Message-ID: <20261116103010.1129666-2-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261116103010.1129666-1-tariqt@nvidia.com>
References: <20261116103010.1129666-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: PH4PEPF0000B60D:EE_|LV1PR12MB104611:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e53ccf2-92e0-4a17-0848-08df43ccba33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|82310400026|36860700016|10067099003|56012099006|11063799006|261026135527099003|261026130827099003|261026121527099003|261026140227099003|261028144727099003|261022115727099003|261021135927099003|261021133027099003|261021130227099003|261022113327099003|261021121427099003|261022075727099003|261021123027099003|261022105027099003|261102130727099003|261102123227099003|261009223027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	yzC+TwxCGq2DgtrfyLJr6PYybFx/zwKGcxAihz0WWJ5JCF5+ay0ny9rYdU1oHmymsEP1rTXiLQayDvvlTwa+1dUEdBXik9CkOWTHNtvHKfmgzB5fN66iDZFXMLBuMbpuAnmDEc3aw3VrrncJ/pjqicnvLp2Q8nhUlq743gxkIq5/cmlQCDoc7p+azf9ARfuiUCcRHC6dCB0uRvrIKCGob6G8tBmtN8SZ7cPgs2bZpafFbGyMPgBSvlLjVpaxk+whIQC/BDYinCRM1MDjTq2k8/Xv0PrL6JFGRII4kCoqAajtiMRKM2mmZrWGzCwYgbPyFsJTKGGtW6Sxs2B18fMsoUwd3Dp+9Mehieks1d337b+eV5x68NIxmwnI0pV+b+3G37jrGTpp/cytb2fIVowTV8BTQyaM8KzF1bSy5UHtgaKk++tWnRIw8xR23XL7MNzP61dRTU0dzJ8B0iy99w4m9PxUrIcQDeAORvkZqQ/Lw4FiMnyYfZ76xINbeU+hudE1LZBP4iVGojRdOkRNu4Y5+JB7QEVHPNyrWAOar/IQ7QeVOk0SXb2QfBHIPr+CVIRVci+Io/tDwaaN2CK9PMF9Zb/8TnE3RqeNDBEsia8utT1rtzUtnrLkNwDtHCOM9al3N69jyij6apaD8RCRcgLR9Zwojcf/jBM+Iz8Fkj7Vm8yPSLaF5a3mFeQ35Ff557Z5OOoDB7GPYBp4S70ZHzs2LQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(82310400026)(36860700016)(10067099003)(56012099006)(11063799006)(261026135527099003)(261026130827099003)(261026121527099003)(261026140227099003)(261028144727099003)(261022115727099003)(261021135927099003)(261021133027099003)(261021130227099003)(261022113327099003)(261021121427099003)(261022075727099003)(261021123027099003)(261022105027099003)(261102130727099003)(261102123227099003)(261009223027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	oLHIey9Cc5pbRkhlQN5hjeiLFZBKyD0KAC5CDKfgTiT2ln/VSHEzvbBDk7t/9TNGfLJnYaPV5f9BHJrnsLr1Vovtxkp2vT+7GqO7uSyQrl/EktigUlCQyTe6OjMJ/Lr7vQdiKOGtz110bTeavbhySBiu9NTHyVvZmCbkf6Ljl9rnDP4XBwhCIg+/cE5Pqy0mFPDOd7NI/qpM1DBjVWK/jQsZBbiBH6DgRwiujlLU0zmTyjkhbjYLjzeoMGSbIQ6kmyJDnVKFfxnwIAsySO6GUz8JIoKK1fWJTJxPXr+LKqMsVF1NXCdHItxsOCqsNIVeCeCMpCHiitu+It+sA2y8OWuzaOb+/oZDDADiffrpX2SPKCZvaQzfd9pMiXsFBR67zImqpsWOHbd6BceqYqi+L6FtT7HH2eCkUytLO3f1Hs92i+ONWg7KHnr3+621zgJq
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 10:31:08.5223
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e53ccf2-92e0-4a17-0848-08df43ccba33
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	PH4PEPF0000B60D.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV1PR12MB104611

From: Shay Drory <shayd@nvidia.com>

mlx5_query_nic_sw_system_image_guid() builds the key used to group
devices that may form a LAG. A PF and its VFs/SFs share the same FW
system image GUID, so without a discriminator a VF/SF that can join a
virt LAG would be grouped with its PF.

Appending bare discriminator bytes at conditional offsets is not enough:
distinct capability sets can collapse to the same key (a PF ending in a
load_balance byte of 0x01 vs a VF whose marker is 0x01). Give each
discriminator a fixed position instead, and add the VF and SF as such
fields. Trailing zero fields are trimmed, so keys of devices that set
none of the new fields are unchanged.

Set the VF/SF markers only when mlx5_virt_lag_is_supported(). The same
key also backs mlx5_same_hw_devs(), so a VF/SF that cannot join a virt
LAG keeps its current key and is still identified as the same HW as its
PF.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/vport.c   | 40 +++++++++++++++++--
 include/linux/mlx5/driver.h                   | 11 ++++-
 2 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index 78f3d15b599d..bab43df6a7d7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -1308,10 +1308,37 @@ u64 mlx5_query_nic_system_image_guid(struct mlx5_core_dev *mdev)
 }
 EXPORT_SYMBOL_GPL(mlx5_query_nic_system_image_guid);
 
+static u8 mlx5_sw_guid_load_balance(const struct mlx5_core_dev *mdev)
+{
+	if (MLX5_CAP_GEN_2(mdev, load_balance_id) &&
+	    MLX5_CAP_GEN_2(mdev, lag_per_mp_group))
+		return MLX5_CAP_GEN_2(mdev, load_balance_id);
+	return 0;
+}
+
+static u8 mlx5_sw_guid_sf(const struct mlx5_core_dev *mdev)
+{
+	return mlx5_core_is_sf(mdev) && mlx5_virt_lag_is_supported(mdev);
+}
+
+static u8 mlx5_sw_guid_vf(const struct mlx5_core_dev *mdev)
+{
+	return mlx5_core_is_vf(mdev) && mlx5_virt_lag_is_supported(mdev);
+}
+
+static u8 (* const mlx5_sw_guid_fields[])(const struct mlx5_core_dev *mdev) = {
+	mlx5_sw_guid_load_balance,
+	mlx5_sw_guid_vf,
+	mlx5_sw_guid_sf,
+	/* New fields should be added at the end */
+};
+
 void mlx5_query_nic_sw_system_image_guid(struct mlx5_core_dev *mdev, u8 *buf,
 					 u8 *len)
 {
 	u64 fw_system_image_guid;
+	u8 trim_len;
+	int i;
 
 	*len = 0;
 
@@ -1321,10 +1348,17 @@ void mlx5_query_nic_sw_system_image_guid(struct mlx5_core_dev *mdev, u8 *buf,
 
 	memcpy(buf, &fw_system_image_guid, sizeof(fw_system_image_guid));
 	*len += sizeof(fw_system_image_guid);
+	trim_len = *len;
 
-	if (MLX5_CAP_GEN_2(mdev, load_balance_id) &&
-	    MLX5_CAP_GEN_2(mdev, lag_per_mp_group))
-		buf[(*len)++] = MLX5_CAP_GEN_2(mdev, load_balance_id);
+	for (i = 0; i < ARRAY_SIZE(mlx5_sw_guid_fields); i++) {
+		u8 val = mlx5_sw_guid_fields[i](mdev);
+
+		buf[(*len)++] = val;
+		if (val)
+			trim_len = *len;
+	}
+
+	*len = trim_len;
 }
 
 bool mlx5_vport_use_vhca_id_as_func_id(struct mlx5_core_dev *dev,
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 84e9f6bdb7c1..e28b9c23c165 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1270,6 +1270,15 @@ static inline int mlx5_lag_is_lacp_owner(struct mlx5_core_dev *dev)
 		    MLX5_CAP_GEN(dev, lag_master);
 }
 
+static inline bool mlx5_virt_lag_is_supported(const struct mlx5_core_dev *dev)
+{
+	if (!MLX5_CAP_GEN(dev, multi_uplink_eswitch) ||
+	    !MLX5_CAP_GEN(dev, lag_master) ||
+	    MLX5_CAP_GEN(dev, num_lag_ports) >= 2)
+		return false;
+	return true;
+}
+
 static inline u16 mlx5_core_max_ec_vfs(const struct mlx5_core_dev *dev)
 {
 	return dev->priv.sriov.max_ec_vfs;
@@ -1399,7 +1408,7 @@ static inline struct net *mlx5_core_net(struct mlx5_core_dev *dev)
 	return devlink_net(priv_to_devlink(dev));
 }
 
-#define MLX5_SW_IMAGE_GUID_MAX_BYTES 9
+#define MLX5_SW_IMAGE_GUID_MAX_BYTES 11
 
 static inline bool mlx5_data_direct_supported(struct mlx5_core_dev *mdev)
 {
-- 
2.44.0

