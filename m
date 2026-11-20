Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.59
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795163541;
	b=0DLPpcEs4xpl7BovUXn3aUABYbDVt4TlWNeoEJROixTRGAhpe02+TOKoQWhgVHJFyQGB
	 EKznmcRCXUhAiUVqGULBqYGuCyADL4mFxx0+LDmDvp6Edga+Br4OaOKyVUs9bBIpnlX+j
	 MDm65BfFCyo0WnGA4oYSwvDAX3j2rCp/LArnCWaLLfF6Rh6LRPnKTsGhR6wzjBZ7GF4sP
	 FdKvGNlP8aIEd00ZJAYIzgmDTgrx5S4QAYDKUizt/Ut+DoTy55MtldeQjyoxHu2sa+54L
	 TgHrxPTfKG4oFRsTrWl+1LFHM1fJKPvYlYjjX7ztQc9pVyaxK0Mf/IRrrHUrpGC1D3w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795163541;
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
	bh=e+orVjCGf/dSGA4V1mH+EbPYtbl9IwIIuoX0lBqVXI0=;
	b=cDPzNRogcqGcD/BNBJTdw7OokKrdmp2AElW3Kb0Uc8yURx68XhZCiAao/0ImLSkFmyYU
	 MJqZF87C3ofFG1R+3lELxa9PZ4xL9UtCCRSLe0+K4wGfYK/4cSUSjpeoHa3Y+jHqHRR2x
	 tH23zJuQVIbhTx4l9OM2T9YTlfmB0PBl2ReWUC2Gy0AjIxR7vDxAGVpRHmpt0QAwJ9Bk9
	 o+i0Si3+HxXWsNT5WuGpVr/31igXywGVgLPq9bOlE2zMMkYM0g46iQWeNW8n3A2vB6fpi
	 U+Je1oMi6LcbjkhoNbImud8+sEgENIuueT4/2J94tLTG048WsqLgf09BycZC4I+i7zg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=HBd2mgA8;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.59
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011059.outbound.protection.outlook.com [52.101.62.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF0F606A320;
	Fri, 20 Nov 2026 08:32:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8EF0F606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=HBd2mgA8
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EWYqTDlb8+/BtI7FOyC1pEqoRYulyJobNl6oTGe18PQxW5lxtPlFlcPGMjIhVPup5pNaLMmw4CmEH1MD6I3ahp9R4bwodckI/Q91h8De5TTnu+PDaRhvowu4mKthwxaMLMWTTdnT398CJ7YoHA+w8q6Z8Mny1CGHH1XkLPGWABYrYM9lTquGUnJDO6DE26Y7e/jWWIHXC4eOSKhGPdf55RYZx+Y9owfWZmedCDPfWCFgXsWNydjtq2O4b+5DSb2ycsPubwz+SMYH1S0BMOJypI+mB45I6SdLdIUcv38xdUz6IV7Mje3hQTm2XXr5bHXl4N9O+VKSoI1xC/GA6+uY1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e+orVjCGf/dSGA4V1mH+EbPYtbl9IwIIuoX0lBqVXI0=;
 b=Lyb9zE70G9FGp8nQCdaxX1DtjRAQL5mSHI0sHl7w4T+PMwoyxaf7h8J/Fgff6dRtdvMsDH+/GYhdjrj+FQGFrzFhW/dN9UvXVlZnrroWLirEFqF2JVM1shAPRTAbtLat/YZIIgDvzsw1beI+wFnD3yn6ympYkzMXzBU08NJES/cAq/IqH3mOr9Az0+P4UMtHoCc74su7XGSvde4n9xNJR4XKmaQTOaY6sndGdpAI5l8J1MHTHmSgDnOZezEZFSOU+a+uWIkwKARaKw5WYu++Jmhh1o3Jdfcboab1k2qoybpRjULmnQ+FspZXZEvWtOLeL9gP/JuItXnbe1cll1xNOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e+orVjCGf/dSGA4V1mH+EbPYtbl9IwIIuoX0lBqVXI0=;
 b=HBd2mgA8vtUSGCGAxRc8VD6MqtO1OZR6HFJtd/Om83SVJz8i5l3EMouJy91j3spDt3xdVHN9bf9p7f/xN3iGTtQIz9v1IprZEvl/b3gTPgQ8VHoX4/cXAFmk43uOFl4ZSGB/DncoqqC4IaiSgzoiD4NwHfeVWfvASPzHekkgpu0ukTOJWbyFMmVrQ9brm4+bYtITuFqcYxH+B2RGKLhV1h6PDXZ4eCIBHrJTZfDhNw9ZyDsbTJiiCASREIZoPBz/JW0ommnzAa0AoV7+tadU0gtRt8p2RToawHFqwXc08EsMv8na1kAflpj1rkGJLdvR5VbfBOYJJKym+Ft4p37Vsw==
Received: from CH0PR04CA0028.namprd04.prod.outlook.com (2603:10b6:610:76::33)
 by SA3PR12MB626779.namprd12.prod.outlook.com (2603:10b6:806:590::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Fri, 20 Nov
 2026 08:31:26 +0000
Received: from MN1PEPF000793FE.namprd05.prod.outlook.com
 (2603:10b6:610:76:cafe::74) by CH0PR04CA0028.outlook.office365.com
 (2603:10b6:610:76::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.639.12 via Frontend Transport; Fri,
 20 Nov 2026 08:31:26 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 MN1PEPF000793FE.mail.protection.outlook.com (10.167.249.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Fri, 20 Nov 2026 08:31:25 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Fri, 20 Nov
 2026 00:31:10 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Fri, 20 Nov 2026 00:31:10 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Fri, 20 Nov 2026 00:31:05 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Gal Pressman <gal@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, "Leon
 Romanovsky" <leon@kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Nimrod Oren
	<noren@nvidia.com>, Rahul Rameshbabu <rrameshbabu@nvidia.com>, Randy Dunlap
	<rdunlap@infradead.org>, Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan
	<skhan@linuxfoundation.org>, Simon Horman <horms@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net-next 2/2] net/mlx5e: Fix incorrect name of rx_symbol_err_phy counter in documentation
Date: Fri, 20 Nov 2026 10:30:48 +0200
Message-ID: <20261120083050.2540739-3-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261120083050.2540739-1-tariqt@nvidia.com>
References: <20261120083050.2540739-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF000793FE:EE_|SA3PR12MB626779:EE_
X-MS-Office365-Filtering-Correlation-Id: 101bcd56-6dc2-42ae-dac0-08df46e0aa66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|7416014|376014|36860700016|1800799024|18002099003|22082099003|11063799006|56012099006|261026121527099003|261022075727099003|261102123227099003|261021121427099003|261021123027099003|261009223027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	Q7Y7M6+jzpTUSgJQ+BcOr3cJqkVJYbH9TgwYyKzN1kTj99FeyWkzxo4BJBka2tsGDKFtvDkjJgOHTY1rbX8ELe3/42/snY82Sj30uiCfNIQV221GbhRi1B0ek3BIoguvkVU25taDeOMCqakP9WTflFhU6GZummN6dDhUKS5qMr8F09WLd9Z1Z+zGgm+7RFJZYYbihmH8cyM0I807CoVNvi9Ry4hCKi8T1gtoLhHbdi7vpX0CzsNYEemtFtcqdciCzwsKZjgtA09IFcUSA0BNYSDH5XuaSx2+E6jMQyoedgkSzwUKT4d+9rxB/LK8gVsvzmicMOj5gFcvLJGZgAcAMHUyeguk4U+qksw+lZs3wM4zcbtcnB15lXQEm5IFAsaoU/BbzVCgf8aq/FCdxMbZcecmraedDjfo0XIdDIwOTFBBvYwbKTqpHW1ro7dhugYqY/UoAvR7fbWiHKn0f1KJ17irVPPEjYttpj8JkU4H5PfmkkGqM1kNkSl4L32Rrej4tlBCB9aMhLPhKTykoSNXWxDn2zyJhlrtHPaYZnE4CjPBF8dQ6GWX7/nMVMnri/TLauGZHriZIg2mqLWBhTRywkx03JLGQ1j40hpYBqd6nQdrTL2rSXCKq0MdJFTL4XQm5RQv5eD9VRIjN8T5Jt690p5Zisg4tJSGrBeV7pYcof3lhZHX9ky92kGTSYcJIGf4d/QwbM+6sSJVNNsizqOGog==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(7416014)(376014)(36860700016)(1800799024)(18002099003)(22082099003)(11063799006)(56012099006)(261026121527099003)(261022075727099003)(261102123227099003)(261021121427099003)(261021123027099003)(261009223027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	QPpDJqctPwS+L28gG21vi1pRhFXKNNW8pkMm7g17evi9GqSbWjIa15FVzJVd00dHlb9DGo1hgkKJmOdodiLG1w6Zvr7jEbTg3lBrpOklhXn2K7PpdaUgf3753MWQLS6IOhWjWzqEtplmnJd8ysCLp0j8DMhc+tBXxHGj+FKkWVkI0jQ8b9qC5nDUi9MPD+Z5fgdg1fwukzEFj7W3vcfeoEphNfJd14UcIu7e70WdJy3/AQFJknHHE9wYZyasJ9ZbnFc2oTsYl5HC9t/wz3e3K33Q0lkhg3BjcMqPs1JK1g/lPvsNKyThmUMwNUfz2093OFZRuCpv8aMsVkyLevXIYyUjPgQ3xbQCNWJPqx5l0K4OwtwDdUdeQEgLdac2FnOGIUIFHXlwS8Q+SJ1Zs8CKDY3EsTvGyq88IqrHC03lgVn8trPHPk14XyZOWEf1aWhK
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 08:31:25.3491
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 101bcd56-6dc2-42ae-dac0-08df46e0aa66
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF000793FE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB626779

From: Gal Pressman <gal@nvidia.com>

rx_symbol_err_phy was incorrectly referenced as rx_symbol_error_phy in
the rx_crc_errors_phy description, fix it.

Fixes: 8ce3b586faa4 ("net/mlx5: Add counter information to mlx5 driver documentation")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Nimrod Oren <noren@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../device_drivers/ethernet/mellanox/mlx5/counters.rst          | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/counters.rst b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/counters.rst
index 026259ae383c..de8d1a2bcdbe 100644
--- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/counters.rst
+++ b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/counters.rst
@@ -930,7 +930,7 @@ like flow control, FEC and more.
    * - `rx_crc_errors_phy`
      - The number of dropped received packets due to FCS (Frame Check Sequence)
        error on the physical port. If this counter is increased in high rate,
-       check the link quality using `rx_symbol_error_phy` and
+       check the link quality using `rx_symbol_err_phy` and
        `rx_corrected_bits_phy` counters below.
      - Error
 
-- 
2.44.0

