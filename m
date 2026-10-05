Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010015.outbound.protection.outlook.com [52.101.193.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26353400DF6;
	Mon,  5 Oct 2026 08:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791189683; cv=fail; b=nqxliuBHrRVWE2m5ivpV+/gpDGvl8PpQ3q2GTjhKTmRCN24MEsm1YKRXPgaKHgqQOtUD7VwUf8HJ9N5tWGujCRc6YqNqueWu5Mj/IzJScOX/gKX64AxQ/U/BUMF6b5TmUTrYGawoLxd+mQfwTBR5MthWR1LLf/n19uDyw683ml8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791189683; c=relaxed/simple;
	bh=schO8ERm/kypgWw8ukGHPbFV5ktS7/1YFcfxSv4Ugmc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=IPdUyLCDlo8ANhZXgWCv1srKyky+An+b8A3QNOg9wNEY1ZSTkGJq6PyFb9MEVnDPKtNfFNkx44ysRTODRwCctxtzNY3KJCbRqV0tep4R9w1EWFe0QFVOMNDcjY/r3Cs4vc+SbTnhYUIxuvpUpypCeI8/iGM1CsW1eA/2hVoRBHg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Nzx1GrN7; arc=fail smtp.client-ip=52.101.193.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Nzx1GrN7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LbdMkHAHjeAUuaXv4GfZXB5CacIllAkzvOu9WN1EQhbuFu4occOF9pUdEAPNi03lvqcrUqTTgJgs2B8TBTOLEJxYZANrshjSfQ+elh4cVcN0jI9u9WK49fUOIF2eOX8Tb51ABwjU7EDniJPmwEGX2U7tStEX+YjomOmBTc/zC20GcnRvT9OnOcbw+86l1eXPQLuInvNVdhayYX2pUylKCnuQi0Tunmv4/xbxzx/E9GzFmLIOO8S2LnFqjn/hUwk+YXRl/qO6fQ0blGWXEX1Ybz9/vJWgid2/LCd/XRvUsB3t756QksMAkSCJgRqr98OF8+IOgfAMTSTRbbHeEBghLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cg1d6rRqWUbl+b1lVivk8mUToSOJdeKuReM2AqFrECg=;
 b=AyyrIPpaLULjQ0xNsmX1I+VwIV8aZF8egyMJiuuUrIAD6S2ZBzBv330FHoEQyATFtkTDQUz+YiTHzt7xJn6IVNAqCorfkYUJVAtyAiuI7SPCAz8B3eFHIun5oFhI6SY6Zgn36PGT7/oTNrZc4IwQzkn1uOpyipzWc9N4E4nHv3LhwYda/YDV+WA78cZQWC+1pT/+2N4wPpfuy+tFT4ZVhYHdF387Kq37QoIyuD2iuZma0dOwlBGG6SLkimKgBK0zCtmpSIeAE1wAtttc/e6csbyBD7o6UCpO5rpe9t6CxiFbIuhvFRjPMdfXW1NQYyDwKwf8FFkkRNXF+5XT3DDRwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cg1d6rRqWUbl+b1lVivk8mUToSOJdeKuReM2AqFrECg=;
 b=Nzx1GrN7uil4rpkSONOr7dxptlFqdA1KzvTPGGIaRX9ekmemsFnamWE+NSxtVw0p+r5TPsW4Y74KZ29oo9CGFVK6y1tWVmrhoQHmBVvZnbsgZyrDjuVkDuuZNMQ+cH5MyBwlDaoE3XofUSbPt6hp9DhqELUgvyc7GXBl4jDKAoXvQLopxzZBv6fmzISlpB+jnHlSvt6qmF6W6esLK6nOnvRlGvrQndpc/z3KrMo8S95rOWNm7BFZutaPjEFdDOKncEsMwdMiGLPorjKGQc7oMOIPJoYJcLeSaAyVMXAIcFxd4z6uQkdpVbGyVRVrnzyvccrVDf4cH2m3ZrMOVHmISw==
Received: from SJ0PR03CA0036.namprd03.prod.outlook.com (2603:10b6:a03:33e::11)
 by DS0PR12MB8069.namprd12.prod.outlook.com (2603:10b6:8:f0::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.26; Mon, 5 Oct 2026 08:41:16 +0000
Received: from BY1PEPF0001AE16.namprd04.prod.outlook.com
 (2603:10b6:a03:33e:cafe::50) by SJ0PR03CA0036.outlook.office365.com
 (2603:10b6:a03:33e::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.20 via Frontend Transport; Mon, 5
 Oct 2026 08:41:16 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BY1PEPF0001AE16.mail.protection.outlook.com (10.167.242.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Mon, 5 Oct 2026 08:41:15 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Mon, 5 Oct
 2026 01:41:03 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Mon, 5 Oct
 2026 01:41:02 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Mon, 5 Oct
 2026 01:40:58 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, <linux-rdma@vger.kernel.org>, "Mark
 Bloch" <mbloch@nvidia.com>, <netdev@vger.kernel.org>, Saeed Mahameed
	<saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
CC: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Gal Pressman
	<gal@nvidia.com>, Jakub Kicinski <kuba@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, Moshe Shemesh <moshe@nvidia.com>, Nimrod Oren
	<noren@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, Paolo Abeni
	<pabeni@redhat.com>, Shay Drory <shayd@nvidia.com>
Subject: [PATCH mlx5-next 0/2] mlx5-next updates 2026-10-05
Date: Mon, 5 Oct 2026 11:40:45 +0300
Message-ID: <20261005084047.237081-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BY1PEPF0001AE16:EE_|DS0PR12MB8069:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cb222ca-196d-465b-6f96-08df22bc6b5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|376014|82310400026|23010399003|18002099003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	K/SsdY2qUxG2Uha1YS+4+wNWcLzgyr79n9GrqRn/qE1TW7BxEHiek37cWgK7p8eM5jiW+1dKqbSnIrew41sSS66IslL8z9FcUNb/E65QAdjNkfkzg5MTV3D2RCZCkK8J9aER0VJ76YLNn2xTFIiJNgYcD5rL/G3OiT7Eoo3KUD9bJI5po8qGmnmgKXTB5RIH8yMGG5Q8nuR9AWtAUjH4xPclMKXrF6SYIDHtdefhvOOUyEqXQxolOm/kbYjX2/5DQ/hNGyIdfilr1OH8CUzYm8XAaF4Gtihbo00NW5SQTJzrxc7jQG+Mznfzg1RSw13yLC/RlBeGroVr2679J6piUKlmgszsuHJhyc+Vi0vZEWezbqckwZ9gMJxIp3eZVyGTh39TAs9u6o2Dr2WRGC+f3BIZwbHNE54/6UZDSp7/eFNyG8oCDAaH/WreRQVXpKRT+UPhR/mgBWCXQxsk2hXrR2RjF3OxUWINyDMDY2+3ARZW/hluNPvqA/lroNwuIhbHxrxX4KxzCjWs+GhW5o+F2daL3BJj6eGJlZauRqKBDiaDc4Lt1Z2lSJMAVxrQhwxxg4KfloXUzVoqBexdh1dnsbDKUB7+3rNyWqGTJs3VoGJzPVyJMGH8q1yQY3hNZOrGiubuIFD120+WO/82dyvsQEISSl8GIOVqQIpOuanGsm349Xo6n0zAXTO+kYn6+K9GWV/6s7XZ93bP+bMya3y3yg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(376014)(82310400026)(23010399003)(18002099003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	mbRPnBkjBgxFfnNU/0hsbEOyeVB6EO1HF2wQzigUdquJNyTycGpw2ffJr4Kinh0G/wftXXXpl/JRpY+aABi/cyab8o41AwrJ8G3FtnHxjn+KaL3zCuJkX8GfCh7PwLy/Sd2oqbcL2yIwuV2+8NPSSt6+8j9vG0qPMO+P+S1h2nhpR4uhE4bWzrStV7eJT7FfQtzg2g+Swqps4VXdeQAdoFeAptrjVCAM1s+BuN+bFjBrz9SGz68Q5+20cKttHLUB4x71xDms3UVjY+rc7E+IsVUXTqnWF4WGx99GdN6SCq2XjZM3OAMJoL7CCXp+waf4wR0buRzlMVY5GNen594CZHoIisSmJWO37KMzEgA0i+IcWjC1Kb1Y1H8bt7VU40tSKQA0o4GBuzUbFqzNTr5sn6GrBJ2lbtkvJwBXnvTHk1kVFI+q3c/qNoCpwHfK7EyM
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2026 08:41:15.9933
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cb222ca-196d-465b-6f96-08df22bc6b5c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF0001AE16.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8069

Hi,

This series contains mlx5 shared updates as preparation for upcoming
features.

Regards,
Tariq

Or Har-Toov (1):
  net/mlx5: Add cap_tx_speed and effective_tx_speed support to IFC

Shay Drory (1):
  net/mlx5: IFC, Add capability bits for virtual LAG

 include/linux/mlx5/mlx5_ifc.h | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)


base-commit: 00290b9ff59ef47b990d26a6b1a8b2ea6dedf5e9
-- 
2.44.0

