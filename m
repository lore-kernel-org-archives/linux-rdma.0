Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011047.outbound.protection.outlook.com [52.101.57.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F3942B303;
	Thu, 23 Jul 2026 09:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784800493; cv=fail; b=GO/qnnmQwuUJBHFRFhk+LTgD6qiS2rgd3svzlYDx4X0sMk4ubRX72I6fKnNex9gInrS36XBsrGnszUswXuBocl1xU2BROENx/qIuM1/Fq6JZvWPt34NzpUm3GxO5BuyYoc0DMXqfz/iw7evWSf8YvlpsLlF/rfCgZSmImqWFrDQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784800493; c=relaxed/simple;
	bh=Mxfhe/Da4T+vI328wT2fjEHCPrvd7d47KPDLZdDbuxk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rF4pjwCrN1nAsNPiK3a1LACI0UOEIc+VoV7Y1J0/0KgTPcZxcBrBwRfQAFrl5/USYZmZWu5+330KLHaMhp8dG2G2CfecW/MiOeqdEJ1LVDS7assbjL/KgfExBT8Pg9Os2eefJajJ03QTPzMJ+4lEFagGrvk87sWzj7fMVZnV9Yw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=e+XJtHB+; arc=fail smtp.client-ip=52.101.57.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="e+XJtHB+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WmNRnByws1sWK6uwYmgT6Y1TkqrNQfHqgaQZUwwOscMZZ36PGB7E0H2SFdz8qqJE5kB/eRjJKMUMwq6NL6oJPS1Xk6b1ucn5rMrku6y8wjru6aqlo7xwQTXIupJoCbQrt2FPhZf29Mj0IzkOozQliEXASSwAfIbCgQYTu9JapSOMXjBw8f4SPsynXxUKjTRStEtdxdhLnluRvxv8MCYlhf4w6kgJk0yPWuzYFMVh8H+Ro+u+VQE14qpYdtzhpPVf/EBjOVjM+0tmKAaNuEL5sZJzPW/KR0PfHp3kXFO80521Pu8HJWtK3FLT8Yz71Q5HMH1B7NLJcnzarnPRvumaUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Ons6JyUHk4+AWYjYbqBrqNhMuVVTF0AB9JWBgu4vmU=;
 b=wD1p5+3V+wtHcd0sH0NdSraLfKatwl1JMYDvGGS3jOXH0JEc4Uk76d1QrXKt6l/2qMt35+4/EdXRUk+mLyRThQT2MXt99KLXxFQopF7UuRp3ohUi1wK6OG2DIXtlgwhT4JH3TAnmtOxn+gkfb6+bgUBfh4mfkNNI+DbnUWNUgfbKgNeu3v6WFR83/ywABk+69BGiL/0umF/L2H8c0mceXfEvwGvUjqjEzDfgtVy2WvBkDqckIpm9jn6SHswRCmcOILzea8zrSSvSWrLmxi3rjcJgy+o/HYEi0+EzZ/QMYIri+cPEYpk4hia4gp3uIrOxEoSlCfE19HX/0A3fSTUeEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Ons6JyUHk4+AWYjYbqBrqNhMuVVTF0AB9JWBgu4vmU=;
 b=e+XJtHB+8e5mASj2Xcsk3A6GFqupPaUCIfvTI9HSia9lh0ZMWIQ9SC25MS/602v7tJuar9ObSr+os+Z0KCQuEl5V58IOEYWJq5XQI+F43umh3P/BnKttS8eLgB4XfporN0cb8H38wx4w9Aymw14FonMwLO85mtwhFj20rzqYWMxf+tZoSJCiaal20rl9Vni9l5pwfATSe6fhyk3rzHjQHMYrL2K7Yvum26tMCH5e3pIyPlBSYf16mu1g0sEVbGQyxEJUSiJtDFRcO6e4X5HvnmrK/cQOPjrwOKM51emvnwHywRMe+WL4ocvRz0LbMI+rPfUrniZEMbdDs6sz0cBUcQ==
Received: from SJ0PR05CA0022.namprd05.prod.outlook.com (2603:10b6:a03:33b::27)
 by SA3PR12MB7976.namprd12.prod.outlook.com (2603:10b6:806:312::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 09:54:45 +0000
Received: from SJ5PEPF000001E9.namprd05.prod.outlook.com
 (2603:10b6:a03:33b:cafe::37) by SJ0PR05CA0022.outlook.office365.com
 (2603:10b6:a03:33b::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5 via Frontend Transport; Thu, 23
 Jul 2026 09:54:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ5PEPF000001E9.mail.protection.outlook.com (10.167.242.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Thu, 23 Jul 2026 09:54:44 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 23 Jul
 2026 02:54:27 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 23 Jul
 2026 02:54:27 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Thu, 23
 Jul 2026 02:54:21 -0700
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
Subject: [PATCH net-next 2/5] net/mlx5: HWS, Log syndrome on STC modify failure
Date: Thu, 23 Jul 2026 12:53:46 +0300
Message-ID: <20260723095349.1890983-3-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001E9:EE_|SA3PR12MB7976:EE_
X-MS-Office365-Filtering-Correlation-Id: a5a0c913-ed39-4f23-9f54-08dee8a06c78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|82310400026|36860700016|376014|7416014|3023799007|11063799006|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Kdb76cX0nSks/bAQUDY8Sv4PuBkumlRxRTCjsasJGdGMIXAhi6eC0faSKb+qPINWMf4Igd9LptGE6/AtjTymVw/2eAjVmAE4Vo1J49SzfR76/7xhEHIlLy/X38zR2JNQ/V2pscam8BE8IgmrF3Y+DvC7pBpvyhmDEQdMQlVVzu0IrFxbu/ukrWQxuy07SzWcNm6/lx7+/ptq33HjOwdaKyWT/a6Lsb36m6SvGTKDo9oWTxncU0ef7PA4wyjCNd3X9xCEz4eQdfcW1Tuj2Z2zLMhNV0SVFtFkHSuNnGsjb0j0FHgLrKRi79Q1HEoKS+79/YidpgQZDNTAwZBZsZrnKGE0mYp5hjLxk6+3lD1X8sfapDIpD8MWlbvEBfV3qz2+s1yHG9cbVxt9JNT4g/IgGfgd5EBl6ESKwLPaH41DN2dj7/AIjfbxLyif/xSpNpd2dPhm3uMTu7sl5nwXrK7LF5ud2coQvXKaujeXbLQIFc0oz4uAS+EiagacBG0+G55sQ8cc1lZivkxm9nY4JPb57elscZR7BkWBfYnsvXcxuIGLDcAAzLu5rwc7fQlvZcN+YF4+QzNzpJgEjZrREEheYBlQ3UwbZ9JsqD3vTnZNKHv74KgEXaknsHW88EEVG+fRF5ykIGDkOrZM/gZTHDkeqY5xQ5Wl8BR7lq2hcT55Syo1VlL6+NvR1SRZzO4UdmiiuiIIk/2lgS+g6f+pyPQexg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(82310400026)(36860700016)(376014)(7416014)(3023799007)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Yg+KJZj5T9MA8ZhTujKVy8HJhU+6G+b6Wj3Uka60vGLYmCQEJkZDpBdiAhfOJDDLFH20K6BOQOziNqmCOY4ON3nNhQ6Lc7R4kX9BOmChJEG4lvbg28J4oMDUBn+iTrFCYXuXwC7OLCR47kcnWC08XnXNdse1o4i9Eu0/dtEEwoR5S/ldnJTA7hf/YZ0GfM8igCudv1naWjXt6TqG3OgBG/V90HBxx4+e9E67Zcg6Lc0Aj2sricAJjT365P+55M8CgvQrDiCepRYTODoCCV/gcmj5qVTPZsHnCABFsg40J21K8t1CuxaeEh5QS9Y18oXe3YfSy4c1MI2NXzsy78yUCUTua/9zGuCQ9SHqek91GsZrHvyFDKgc9CUdGFpsnzSfuOzS1k8/KWd/l0WndlWpHJVlbJ93zSsh8OM+qBrrDijgDPJ/Siaqrv7PPDOYVidQ
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 09:54:44.4130
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a5a0c913-ed39-4f23-9f54-08dee8a06c78
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001E9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7976

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

When mlx5_cmd_exec fails for STC modify, include the command syndrome
from the output buffer in the error message to aid debugging.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/steering/hws/cmd.c    | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/cmd.c
index e624f5da96c8..c04ac970705b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/cmd.c
@@ -611,9 +611,11 @@ int mlx5hws_cmd_stc_modify(struct mlx5_core_dev *mdev,
 
 	ret = mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
 	if (ret)
-		mlx5_core_err(mdev, "Failed to modify STC FW action_type %d\n",
-			      stc_attr->action_type);
-
+		mlx5_core_err(mdev,
+			      "Failed to modify STC action_type %d, err %d, syndrome 0x%x\n",
+			      stc_attr->action_type, ret,
+			      MLX5_GET(general_obj_out_cmd_hdr,
+				       out, syndrome));
 	return ret;
 }
 
-- 
2.44.0

