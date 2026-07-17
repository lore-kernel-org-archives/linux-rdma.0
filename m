Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010001.outbound.protection.outlook.com [52.101.201.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECD838D417;
	Fri, 17 Jul 2026 07:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784274725; cv=fail; b=t3PBPgGOg9nTReIwW+4ybAYdIJJPU/Dly+nbShi4M9YuzgEqUPP19vISVrjqwIbocEpCfuTLODx9xTbJOFujG4LlMEyjl9R0NF6sYYawQ3LwLZGOlcNOaHQIRWzYpcywudqzoXFOJRpjhOHl64DnkmYI7JpfraGJ6V7SFASEqkM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784274725; c=relaxed/simple;
	bh=EKGz3592G1cOAvgJiEptn05YYkccYBQOrK6EHt9bqAo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PX79jGXNY28r3dCem288uJFOOOFo0eJw3O39g7P3f1jIDm4JliouZOUVnxnT9ix6Xa5SxbiPvPGQrzBeEzkGpfX0zab6jnAINSFNDFRc+Q8G6b52Z4Dt7/mr6aRy3JHOTa2X/+/RI1rYGW7NYkKBKr4cpvKtAxOktwsiekeZE3s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tAGEkK2B; arc=fail smtp.client-ip=52.101.201.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tAGEkK2B"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MdICBI1K0oehK0/31HxSzh8S3ieOKqUMY09EWiePIBLaY+x7p2nYzTEXdc8AyOjU2vPzYYhnQTldzvxCevYyBVVseLbpaPd9viNWK0UEfCiD0EYVGl8VFtmk6gtcgAfguTW9obfWL9eAMir6VkTNdXeGtYA1Pd9CocIXFy636FYcyPPu911oTN7Pa/qjbzxLJNHt6tli5cGagdaSHuafl529uHBVH2QhrlIQ8iZ5ZAnjhzmjJspGyk4C+z5Ks2Eoe276coVkFOpYJuOilC2YgZmSSiDUszaLzmdMD8yXSvWnlrTFonHWrwPTthjHQxQySifqB5sLQzGBL7lF5+GB4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pIn46mipAs0g08Uk+49dLGj26GAI2/g3gEnE4q7WlkY=;
 b=dfLYVCiV13eQOxNrzSKU4AZqV6JvpgX49WnhLZsr69/Wotn6yJXGfGifjvOgqfif4qBk06m3UcXAQNMh8PWfi+v1edBg5+E/XWmT0GHwZAjCbtSiGSQchjIRPm27k4vhI3YZuwFs0+AtUQNFgDiv0zIyu4hbMOB5Pc4YaHSQtEouYVRF/PGc13//sUTsofxOeJkkdbatQbYDgEReErz3cHjDp/bKt837osfSSe76ZUoZLfUqCpcaNWfX3KL4DCXjBVOm0O5ogpX9Fk+fynjURLuLl4KPQdCeFDCIGQKAGh/C6692dQw0ZuREV0q5/MZUQb9kYYZmx10jDKOGdUkOhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pIn46mipAs0g08Uk+49dLGj26GAI2/g3gEnE4q7WlkY=;
 b=tAGEkK2BNng7ufhP68uWzRb0aO7xIq02/zDwE1rgY52pgon5XthTuwV7U2Vp5HRXXf6KJkFuI/Hh4GStgWnukAFfGazPAFSMBp/5WW8Mp23Fjy82FZwoyBu9iX0AvcCv3tmkY/rB+1qgExfSLiW+a5RNrGm+OwRQhEUicaiMotGXMGQ1hIk09lobdeAe0HdwdVNDElmNTJ6vilgXXMr04/eikCavoKVEaFzIehiuE2bPHjb3Qa0lMsT2l9rmBV0ptV2FbLF9dqdVq/3Gu6gZOA32z7rNd2MWp0jkamBbEYLPgka9sBNefQYFfQip1Sl5J1bnJV5iPd7wGJWk9h4Uyg==
Received: from PH8P221CA0065.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:349::13)
 by CY3PR12MB9680.namprd12.prod.outlook.com (2603:10b6:930:100::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.10; Fri, 17 Jul
 2026 07:51:59 +0000
Received: from SA2PEPF000015CC.namprd03.prod.outlook.com
 (2603:10b6:510:349:cafe::35) by PH8P221CA0065.outlook.office365.com
 (2603:10b6:510:349::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.223.13 via Frontend Transport; Fri,
 17 Jul 2026 07:51:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SA2PEPF000015CC.mail.protection.outlook.com (10.167.241.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.5 via Frontend Transport; Fri, 17 Jul 2026 07:51:58 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Fri, 17 Jul
 2026 00:51:48 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Fri, 17 Jul 2026 00:51:47 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Fri, 17 Jul 2026 00:51:44 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Alexei Lazar <alazar@nvidia.com>, Carolina Jubran <cjubran@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Pavan Chebbi
	<pavan.chebbi@broadcom.com>, Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [PATCH net V2 1/2] net/mlx5e: Report zero bandwidth for non-ETS traffic classes
Date: Fri, 17 Jul 2026 10:51:24 +0300
Message-ID: <20260717075125.1244877-2-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260717075125.1244877-1-tariqt@nvidia.com>
References: <20260717075125.1244877-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF000015CC:EE_|CY3PR12MB9680:EE_
X-MS-Office365-Filtering-Correlation-Id: 3006570e-0105-4603-39bb-08dee3d8479a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|36860700016|23010399003|82310400026|11063799006|18002099003|22082099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	mWwTaets/G41MGaAVnEQPUaqafr6Zrx3jO03f84aF45DyHFDtiiqzMpDFQrITz3Y7WlyyMi4HOIib8mQkMqQdFykpC0p4L0qSbL91WONxX0c9ckQx+TdC2vQtG0s47m/FeEHgkqxASoWnVSnTlBAWs6FzN/Wfd6tHwCA3sOD+WYRpBXk7boifpNi6cFGTXjmdJKv6UGtBkhav/n2J0sPCnwaQ9XGhVEsEyoajpJZWYnldpBQbSTsctmckJtVbL7vcIyBnesxToLFssXHCVSDsbmXtDuvXmWGmhl9fjSdcPwUBMMPGeEH13jwe+viX595sft1L5N8tzLWgziX1jHS0ZGnGJERynYthL+VcreG93XuOmgGYbe4iRfWrzgaiL871RtuvfaIRkTf7+ZdL6Dj7V0NCLqDugkk0fh6XqrSqY3ffvxo86YK4QzDjKhLgn6PLwufnsoYpN25cH+hKgKSEgA7xa4W9wxXtRdgnMmMbq5qeEo5mwYgdL987a9Bqu4+DaPhwBMsmZGgYzEHLiz1nmDS8BZwd+VwQ0xftk5yYNCgUulVv8xOQvRdNzz4tOhJ+oyTWveFePMIqN4ZQrmSvCc2aaT5YSK3P1igz1erMIE/HDMMM8WX6/2VehlVxYun+gc0LsBxyf5/YBZCZklUl+82bKAg6QMm9j0o+QWjt+y4SAMD7iwYCZDGXU2tVuTNzYl5w77xZvYWp0CvpG5Epg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(36860700016)(23010399003)(82310400026)(11063799006)(18002099003)(22082099003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	pfyzYv6PKB/0QptQWtPn6qSRe3Z+k9WriwThG5FuW3xoi84ldgnEhkWCT1Q+hL9tp5ZAWNXTwqmcCVHP8B+10SkdC5mQV8BUvTO/Q0pyqv9xbv21BwNM9OJO5s/SD0ohH5zKpjjvBph7XFqEmhXvVGse49lIEsdHov6UShnMB7SQ8KoDQWxH2iUr/LaX0DN1WNDrI18QeXVbNj+SazGrZSuaGnYQRIY+Q5Lzch4TAGMf/mxgMJLls6ztvFWBtkTEMWa9yNJxa3hsw+CEi51qe6w7u6gvu6ySxw8I2C1HuVhNT2lPbav30QYmlGEarcpSjZ0fsXLzAAL5iQ00iNEX9NQ5iWjJaDcs/WUGHrnJeXRwLox1lGJRX5bKluErmjue+4xwnj9qiXPVIp8rcBFIfefAjVUYMoQcUZiKGW6F4XmEGjq3PrOO6t5casZ9Ac6b
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2026 07:51:58.5575
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3006570e-0105-4603-39bb-08dee3d8479a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015CC.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9680

From: Alexei Lazar <alazar@nvidia.com>

The IEEE 802.1Qaz standard defines that bandwidth allocation percentages
only apply to Enhanced Transmission Selection (ETS) traffic classes.
For STRICT and VENDOR transmission selection algorithms, bandwidth
percentage values are not applicable.

Currently for non-ETS 100 bandwidth is being reported for all traffic
classes in the get operation due to hardware limitation, regardless of
their TSA type.

Fix this by reporting 0 for non-ETS traffic classes.

Fixes: 820c2c5e773d ("net/mlx5e: Read ETS settings directly from firmware")
Signed-off-by: Alexei Lazar <alazar@nvidia.com>
Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
index 4b86df6d5b9e..762f0a46c120 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
@@ -173,6 +173,13 @@ static int mlx5e_dcbnl_ieee_getets(struct net_device *netdev,
 	}
 	memcpy(ets->tc_tsa, priv->dcbx.tc_tsa, sizeof(ets->tc_tsa));
 
+	/* Report 0 for non ETS TSA */
+	for (i = 0; i < ets->ets_cap; i++) {
+		if (ets->tc_tx_bw[i] == MLX5E_MAX_BW_ALLOC &&
+		    priv->dcbx.tc_tsa[i] != IEEE_8021QAZ_TSA_ETS)
+			ets->tc_tx_bw[i] = 0;
+	}
+
 	return err;
 }
 
-- 
2.44.0

