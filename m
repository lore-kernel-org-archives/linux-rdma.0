Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795023208;
	b=uLr3Jx4xWbPteO8C4BGlFu7moOHG+Qhd2DvWgIeL3Ow95ATPKZVSeGD/1w8HolvuyY85
	 cAcakgkj6vBz0+wmTqGlXtFiV59ynTkzhKjmk/cHppgEN52EEcML9jTUrtLszqtYVJtDD
	 JWt/WlwGt2TYBSnOf+ZLhRfVa91R8ZZI7VV2kQ6UH3xQY4xVEthyDDhGf2E1O7VNK4TX1
	 egnZnMA5i25W5TAohm7gO7zSLcOiiMeLk5wW2/Q697QIaQLq0j7Rr/V5FhRvz3Vb//TV+
	 18x/CYToQudl0WyjvU0Qf6imqjDSka/iuqSjTe/Dsv+CPABKDBjA0zaVx9+zFh1TaAw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023208;
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
	bh=GW1bT+NiWRjh5FxWkqjWNnySe32roAPjUmodhG2IUG8=;
	b=o24IG+/VWZySfgYJ8iigYJH07kBg9xLFtY6+UiPuiFXyKrwjSuK49iXzn87PabdE41k7
	 wh/o+Y1kbqnXRkKbKV00HMhsUrM/yUwkX5kI7FM1GawJmylZdTmTzd+phi+2vaszo5672
	 jEn/nsyZdnTcKLUgAGo1xTDGKuq6TeOEXYusPP9TsSw2WjjH7D+XkIQehyP/hc6VEsjir
	 y9gTdaJ0SuHyMNhkmUE/VTz+9hxXpdq8DZK+Zvn5kV3wPM6gJKt0XAROxA9XWkJnez4FP
	 pKPHP3TNhwlFEn0kYzdJtlvmsC9uXjKEh3qFTAjuCYgmSsbCF1MoTCugKuemzTMSySA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=fmawHGJo;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.46
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013046.outbound.protection.outlook.com [40.107.201.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB521606A31C;
	Wed, 18 Nov 2026 17:33:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AB521606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=fmawHGJo
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MHir0eX9b0COQz/3SckHQYxKGdm+e1gPVEbuQ2nwyt7UcQq8vp/EoFUhZepTOCNq1Cha88iEmHAoHadeKWiiEPJu+ogcV/4kpZMrnGNEcK6Ekt6bUkBEkEXMlWBs0LBaxWahSrFbi6EhZxYeRSGPtAy0kjZY5ZrFWoUhbJ166pmC/CGytvK4Gk+3xqpxLWLOzGqvowgBp0vp0n8DJ+SQ+LvaTAQ4TioHX/FvejvSnzv1fMsrPHoqiO5s7WH2nBsJtERLXXA/EeP2St2+X8nrSpxZQ6vg8Z/JK8nQKgn5BXWyiM/kzUl1e4LEG1t08laQlwEe7652y10vUUDC++vwQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GW1bT+NiWRjh5FxWkqjWNnySe32roAPjUmodhG2IUG8=;
 b=dutO65+S1V6vcx/l1lvYnaTvbchoXsJQXzjvDXcCYzfXnYl06YYbMva2w/Pt7QuDC/wtD+rhpHvw0DUPzqQQbWYyGO8KVGgc8Idqv8jpR14iz+1P02JphI22mUpOC7Mwju7/SSy3AHQCgcvjEcC0+54saTuXd1uKTs92Ya8xT9hiI0BuuDFFISapMfN/+dKeHRGBSi6CVK6qyNBfPMEnpFQcv4zZuXWIXUlg1HCphPTGV83/t+yG7wqKAz9JaJH1XiC+uyItLydC7zfgFR1qbjkk69wEWXY0t05JCn/wUnN9PQYiFDygbvTGxL9Gro8+jbI4PXLB2wd8DX661LGvsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GW1bT+NiWRjh5FxWkqjWNnySe32roAPjUmodhG2IUG8=;
 b=fmawHGJoI637KRT7BLNsLfKMDkNzJ4niFFoxcvbKiRbeHDOVLT5iOxOb5nhzO+QbTLi6TfGxFA5IjFowcHt5ODX2c+bDKm3w1PdGfzg7oDLlSqV4KPqoaGb3xsmgtZBya4YiEmNtjFE8TAw+0QMqnQ7QL+KRxLCS18CB2QJaFmGt6GAv0rbSI4UUYugKYBybuSYVBSlrkF+nFA1Wlg2DPNokewZvPLtUedgcUZliFIHsiRJtX/gciRxZtlC9CLQ8M38apv9d56uKse9wojzK7sRQwIWSxUAlumv7bV4unuuMGIYZtzbzN3mbd6fh3fwpCLCEWSJU/tNgqIYTMJQixQ==
Received: from BN0PR04CA0068.namprd04.prod.outlook.com (2603:10b6:408:ea::13)
 by DS7PR12MB9476.namprd12.prod.outlook.com (2603:10b6:8:250::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 17:33:20 +0000
Received: from BN3PEPF00022BCF.namprd03.prod.outlook.com
 (2603:10b6:408:ea:cafe::3f) by BN0PR04CA0068.outlook.office365.com
 (2603:10b6:408:ea::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.10 via Frontend Transport; Wed,
 18 Nov 2026 17:33:20 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN3PEPF00022BCF.mail.protection.outlook.com (10.167.248.170) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Wed, 18 Nov 2026 17:33:19 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 18 Nov
 2026 09:32:54 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Wed, 18 Nov 2026 09:32:53 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Wed, 18 Nov 2026 09:32:48 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Alexandre Cassen <acassen@corp.free.fr>, Alex Vesker <valex@nvidia.com>,
	Erez Shitrit <erezsh@nvidia.com>, Gal Pressman <gal@nvidia.com>, Kees Cook
	<kees+treewide@kernel.org>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Prathamesh Deshpande
	<prathameshdeshpande7@gmail.com>, Saeed Mahameed <saeedm@nvidia.com>, "Simon
 Horman" <horms@kernel.org>, Tariq Toukan <tariqt@nvidia.com>, "William
 Theesfeld" <william@theesfeld.net>, Yevgeny Kliteynik <kliteyn@nvidia.com>
Subject: [PATCH net V2 0/2] net/mlx5: Fix HWS and DR steering memory safety bugs
Date: Wed, 18 Nov 2026 19:32:25 +0200
Message-ID: <20261118173227.1957670-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BCF:EE_|DS7PR12MB9476:EE_
X-MS-Office365-Filtering-Correlation-Id: 078efa65-ef02-4d7e-1d72-08df459a09bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|36860700016|82310400026|261021123027099003|11063799006|56012099006|261026140227099003|261028144727099003|10067099003|261021121427099003|261022105027099003|261102123227099003|261009223027099003|18002099003|6133799003|13003099007|41080700001;
X-Microsoft-Antispam-Message-Info:
	N4OxxmI2YYRqxTKMh+vJABnmS9pA+NOGfWsFpxW9ixKszAPxDLGKDe0cfQBtyKnzbvrFfcaaXvcGWwckMaJgC4b2EPfC/FhYb0WHhH250kOxWWjguOl52Wmr+5miiUFHh0PjKHUsirWoG3PoWAGR57DWXr4jABmCpoMONwgcFf7L9O9Xf42wcB6Cgjdrxj5H9gb+yfEC3A6tef/EfOnpyzI9osmqwW9bOtApUL/wxwaq+LBlPN5Xx2R+87Pe0E5BPMt6Bawy7gvrtZb4aiCdzH3t6YN60EGTzU9g1WYT7tDdUbLkmJEx3VHAPSpWHRSCHep8Ugguynfkd0ZLDfZLyC9pn0fARz8FCzNR5nUgDXcu9KuuSz2DM2iw2kJ44zszkdlrhthZ8NI/AuMBKE1qiw/Eh9a7JJwiFZ/CuX3KF+eTEwqVBqAijLsLQ6w5GJrE9l7IFVtnaJO0VB6AzM5+qJhNEoGsFMLqAewrKfHs0EEAHMrzZbwjDUvAirZNhcXBySzD93etmJevXXgZUu3joCIASJyG5DVWOOSgB/SjZQ2vXeQcrE6zZ8H+OznMmYjzgYmoAg4k8jyc3y/8z+VzRcm3FS/g6bV86E4PVopTMBkmtJ4BEVSA8faVvBMjqXE3VGasqu+dzfWUm8RFPz9fZIea7/twOHll+zSr9ezGK3DfQDYI3BRB/TpRSkombqryzmOXOD0C5uqVUFwaWPYo6ypqgCMTwjzTVBEX9WGBkiG3cPT+VfkN1kAZfmIkAxpvNT1ZR4+buF73P2gRw7IrEg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(36860700016)(82310400026)(261021123027099003)(11063799006)(56012099006)(261026140227099003)(261028144727099003)(10067099003)(261021121427099003)(261022105027099003)(261102123227099003)(261009223027099003)(18002099003)(6133799003)(13003099007)(41080700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	gDIwjbKxSpsdWtiFYViRDEZMaFKZBD2MF8/19BcoYYUygEmNNaJ0C163eggLDxijfIKJms99qr8zh4ANInAKkr4gyDdNkCuD7aC9vJPwDBw5criwA09HuSMXM1ydLN/dLKlfL/5LcjhC8k9HrY0c6XWr3qLsYMcedy7vEcA6JZAJlSMxMR0JYDwAKw9V0IMKdYXuRpF4X1GgZ3O/LHLfQ12ftY9CQbpXM0iVNUuRBAxZI4+MvmhJWX1BDt8p5vcVzJqJiRrRKWGp6b00J7q+xNoS4loB065XUWGCTnq7sJzvLYV39xTdu0jVAQ4icFOT5ziVYuy8wzAHdrPNjb85kxs2GWNt+VmMz6Z1hs5LyP/gV5AWuvg/qEJQfKeUElcXXS/ABgGMu1Go9kmV6RGvBqO5UhrMD3D3LppuYR6y7NWhonqrUm9Lh8NY9gdrFlPy
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 17:33:19.8660
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 078efa65-ef02-4d7e-1d72-08df459a09bb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BCF.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB9476

Hi,

This series by Yevgeny fixes two memory safety bugs in the mlx5 software
and hardware steering code paths.

Both are missing-check or wrong-handling problems that lead to a NULL
pointer being inserted into an xarray, or an out-of-bounds write that
corrupts the kernel heap.

Regards,
Tariq

V2:
Took patch #2 out of the series.
Patch #1: Remove empty line. Updated commit message.
Patch #3 (now #2): Update commit message.
Not allocating chunks in error state.
Print error once when putting pool into error state

V1:
https://lore.kernel.org/all/20261021074949.3471704-1-tariqt@nvidia.com/

Yevgeny Kliteynik (2):
  net/mlx5: HWS, Handle NULL in vport destination action creation
  net/mlx5: DR, Fix out-of-bounds write when sync to HW fails

 .../mellanox/mlx5/core/steering/hws/fs_hws.c  |  2 ++
 .../mlx5/core/steering/sws/dr_icm_pool.c      | 32 +++++++++++++++++--
 2 files changed, 31 insertions(+), 3 deletions(-)


base-commit: aa40afa831ebfe45e40a23721711059f2ac584d4
-- 
2.44.0

