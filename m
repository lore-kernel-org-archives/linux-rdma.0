Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011040.outbound.protection.outlook.com [52.101.62.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60EF73AEF4E;
	Sun, 11 Oct 2026 11:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791718172; cv=fail; b=m9jwBuQooNEUmCY5jJ9N97t7PzxhCzlJ7Y1aSdyLtUSoTLliU4hGJoLtl0dJSSUVcK5hBs+XIHl1EaarxukT+NGg+B7Q8zSnNCHBvLdKpkGXE9vmbmZbu7a7K+TitymQaC6YHKZusiJiO4d8UgQz/UXjkHuWJ0B5aGt9yy49uIQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791718172; c=relaxed/simple;
	bh=jXjPe5AFyKOtgFmEahc6Qxu3P7r8+XURJDYymjTmOiU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=U5H8oEMiO1Wjk3LzRU7a6UeVaGCjIDecfFtToaBemQ62JdxQEVW/qUmZN8/9mx1ex3zqiynnGdJ2gtEbJuh/tsDfP4N7WYCnWXqeyu3mQKsypmeNLUAKgSBUGpmXY2A0khlKDiHx3noRYpKBPcpNTctBJKhxY39ZdPcaWL/75GM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MHK5XoLc; arc=fail smtp.client-ip=52.101.62.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MHK5XoLc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l5Ggo+X4vfiGFhDT1S8PtJbb5DRlgoDl73sBBSeRA5+8LApcpAPmNJcPxyzxmAU/ijaK6SkFHqFheSQVA4JdwJ+pLoECbC/2WNivPnlXZmZXcOrOOysO/nICErk3oCbwlrlEO6gy26hmOWjw6FdF0qvqz9Qgd9AuSUIXmAlRxm3oiSlS9SFVPLlYIX7fThTMAFAV0aniSFLcvI41uwtF05PxrkuYjYFB1eBVSaSwi1h6xy+75rMdoC/4FHQymZmpeX90cUdA3Ho43WFfoUb+BlCH9l/Ip5hytSFtfdeaor6enPAm7T4X5C4p18IDvoLNRgVsLj7vOufH+FH+DozIGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wqgI7zCt9LqoHqxvQNg4hW9Sknu+vvTkU6BdcjHSdVE=;
 b=QH6tjAIbuKsKV598PzTY9bBA09N9q387rnTRXqvwfKnLPbxkeX1UBxzyOqSrjo8yckddGnS8XyaNshHXmqE2hFZZ+iNreA1hFZ8B28LunRR5fSHijeooO/+Lj2xYlJQEUvtcOmfYE9OezY7GXSRGA3ugboOpcwgQC/XqE2kZ5O47CgzSxXT6k7DH4b1haAQ/VD2V97dlk6RuRrFIxMNJaf4wHXadnj2bOIEm4qBaeBhYDfS44HECm77CZ3S055/EEVAhw4QC6b5tcbNYZYDpBmDPQ7ZQekxZ5gMm1QpnvsbUMoWM3pNU6XP06tEeLH2BnrtMs3jLzqmvRsunQI0Dbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wqgI7zCt9LqoHqxvQNg4hW9Sknu+vvTkU6BdcjHSdVE=;
 b=MHK5XoLcrICgoaQaliexHxEifCz8JgVSvyPHqhXaY/yZVVMkO/cAG+vDSiXbDDs5kPk5gEvEtzTLMf8n5FYWUO3Q7cUSnyySNURbaLon9Qrqg3Ju2+S2aoMDCCkfwKF1DM4lIyJhMcs+b0ICrtngH0j5HJAvrtj2quB4M8JrE/ZAKXCR92h+Mwnc6jiOUorYjDVAma4JwECfgTKs/NSJv+BXFD8KJwPGOvCqWLxno7yrnhOoJk9XQY4qfw/40TqzAJIHX/E07jxWKNLvbudYuztRUlieaRTCEjsf3vc4cQuEzY3Ipk3AhSHZfASIeFnLa78p8Zx76F+nrmWSitoL8Q==
Received: from DS7P220CA0003.NAMP220.PROD.OUTLOOK.COM (2603:10b6:8:1ca::17) by
 IA1PR12MB6211.namprd12.prod.outlook.com (2603:10b6:208:3e5::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.496.17; Sun, 11 Oct 2026 11:29:21 +0000
Received: from DS2PEPF000061C3.namprd02.prod.outlook.com
 (2603:10b6:8:1ca:cafe::10) by DS7P220CA0003.outlook.office365.com
 (2603:10b6:8:1ca::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Sun, 11
 Oct 2026 11:29:20 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS2PEPF000061C3.mail.protection.outlook.com (10.167.23.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Sun, 11 Oct 2026 11:29:20 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Sun, 11 Oct
 2026 04:29:17 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 11 Oct 2026 04:29:17 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Sun, 11 Oct 2026 04:29:13 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Alexei Lazar <alazar@nvidia.com>, Carolina Jubran <cjubran@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Leon
 Romanovsky" <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 0/2] net/mlx5e: Align setdcbx with DCBX capability flags
Date: Sun, 11 Oct 2026 14:28:58 +0300
Message-ID: <20261011112900.802150-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
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
X-MS-TrafficTypeDiagnostic: DS2PEPF000061C3:EE_|IA1PR12MB6211:EE_
X-MS-Office365-Filtering-Correlation-Id: c1b43b44-279e-4028-9de9-08df278ae498
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|36860700016|376014|1800799024|10067099003|18002099003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	kE6WzluzDsX5HdxRSRKBnwHR+QJwTC3hz+fImG9ga3GRWxiVCuImafw7l+XgJkGSYnQI5eArrnhrhY6I5+x9mEw8HDnKV1RzaBThBhm2+5AjoIMW5QBgkEjSkRJcAKU+VdOGSBqgrOEax0WlycVsUhdFZGBjWBEDpYocKKEugSyPRuwagbUtZZ4rVdvRAkT2GxltknS+qRSVrMl6+c0sTyiKpMgCTpPf0BAwLTlKCSVMTe3c9oE3q88kg6Pwp4veLLRaH9hivxA0k9Eh4ewbFD5g7toQPRwZNQh8m/zwEZ3GesDlZeyKXwwq3ivj48ooxUUm/lxV9/GaVprfJZBBa5+3oW6Fxx9rqAxOKub4sruxK94dF/MeqBZh+awNId4i0/GFpJe7uhQj2TB3PmCPZss/1Q3h8U9UrgMOE3+5SSHYWv40wghh460/GZywc1li0onslBBzor0IclQ+Q9kalds7cHfnd3aBZBNYYMs35bvVYldb1UnH3UdL0TnwH9l0nUw20T1Zu3OFinCVWca6FYLL6sbisMZKv9xihERTRwEn5h+WL4qJh1RevdH8UVOC89Ul3bWnVYJ5/d9e7wa7dTR+//kPnwsDPyW4fwR/lCnfCWY47feDEZ/n+EU3mChRaOdm17K9GVMQeyTzRvObr36Oix2HmFp1zBGrg4RBwVK7FPGBpAIGJjBG8JnuqruWZHYMga+z4uj59UC3PDWUWw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(36860700016)(376014)(1800799024)(10067099003)(18002099003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	YzkvHyaOqXVXcxTHjauqdCmyW/QlNh7cIxwTrMF1Uj+mwnOnRtXiE7PPoEvVw5kHO7wauAk0sZJyzCvwGSngZ70NvTnDYcoljMq5b4+BHrRIg/nWRCv3tFnbkzW+v0O5ebB3JYvQNZ24FZd1+8EIbaV6k0MHteIMfUX6Zdf0sTMEIidcRN9uIigARwN5m9WCEvkEDGkUPMmnzh2h7sybOOq9pGanv1nDtRKwQ/Mp0zp7r07VH78+4llaMRNtYn6Q6LQ0cXurIlkWrrIpfqaawKhj9vgI4VKGxeyyh5yzP/gCQIJielNRKkkSKhhlcWGBLrNqHCeT1PxSfHkl0KMDsnlDbIHCAsctEjB3WRlP63GjtxDyjm3NxXFLo17adJAISPtGXQpx9l7c/iv5TmQk9rZGmf/ZhBO+EGApavnwjdZXVkgXcQnoKflj7NiSVnRS
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2026 11:29:20.2663
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c1b43b44-279e-4028-9de9-08df278ae498
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF000061C3.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6211

Hi,

This series by Alexei aligns the mlx5e DCBX mode handling in the setdcbx
DCB callback with the DCBX capability flags.

Today mlx5e_dcbnl_setdcbx() applies two different policies: a request of
mode 0 switches the firmware to AUTO, while any other request is
accepted only if it carries DCB_CAP_DCBX_HOST. Requests with
DCB_CAP_DCBX_LLD_MANAGED are rejected outright, even though that flag
describes exactly the case where DCBX negotiation is done by the
firmware/LLD agent rather than by the host.

Patch 1 switches the firmware between HOST and AUTO modes based solely
on the DCB_CAP_DCBX_HOST bit, which folds the two code paths into one
and removes the dedicated switch-to-host helper. When moving to
firmware-controlled mode, CEE, IEEE and LLD_MANAGED are reported
together due to a firmware limitation.

Patch 2 drops the rejection of DCB_CAP_DCBX_LLD_MANAGED, so that
requesting it switches to firmware-controlled DCBX mode.

Regards,
Tariq

Alexei Lazar (2):
  net/mlx5e: Select DCBX HOST/AUTO from capability flags in setdcbx
  net/mlx5e: Add DCB_CAP_DCBX_LLD_MANAGED support in setdcbx

 .../ethernet/mellanox/mlx5/core/en_dcbnl.c    | 51 +++++--------------
 1 file changed, 14 insertions(+), 37 deletions(-)


base-commit: d8674294aefef02266c4d47ad10131f1bffbe534
-- 
2.44.0

