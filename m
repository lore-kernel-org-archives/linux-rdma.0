Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.13
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795023337;
	b=wi6TkEREDvkkQAtsCxXdYreVU8qqfC7tcO/0HkahfeqhXHSeLGFYP8p3hotLEJc2hJYu
	 jVFDDDzjzmvjo90KdmdoqmDX7i2Zv9DJ3MVOO8dFMIDY7WPJ7l3IH42zTWF6YIsOeu+OF
	 OwUDUkRiWcHAXCEH5Ku//dIK5liAE7EX255P1MGSg5CUMPXc2A4ng3POeZmOdhilPacgA
	 8tqEwyRnl2Uo3HMAzYMb08D0dmgIsWKpZGKSDtG/leOOkktyvZ9DKSOWYTuxPq+1UEwHs
	 iYHiq56SG1gavfUvXqhjMWBCYUP1+AmKweKVYCfJUF4TGH9W8F4awWzoMjp4w64lDSQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023337;
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
	bh=fZkrCKfALBjWgZ8a9tqklG8lFBCOXzPuyVd43f4nQEQ=;
	b=1E1IUnczygY8goAuEbdf8lim15UjQTqUsGAwQcR7lbgLFzdqCRKMldAqfL6XzqrsmTd1
	 rgNSX/Hfov98vusMEysFJ+4lZWwaFU0D02ExtI7Gx9kKhVZXUui+KD7CPUn2CFaMpzOXC
	 stb5DSakX9/HsAJQ5Z7rjfR/0Z4KxGNMtf4vZzsfS+YB7DIMs4mLK52dHzC5ApC21t2kD
	 2Pb4LnYE+DejkREcvDcRTHncRKdKbdlVtd//YoO7G3MZ6xT851yP1NF0nvgmhniFo9ONW
	 1mcvEj4DniKbvSFN9uxrJgiy+a5r6YzxnhG5Ck4+bJSArGggOZM/oiZmJAtNuGkXyRQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="rXV2Z/iP";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.13
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010013.outbound.protection.outlook.com [40.93.198.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DBF5606A320;
	Wed, 18 Nov 2026 17:35:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0DBF5606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=rXV2Z/iP
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q67MROyLIAnmizFWCk9h1P1mLjn/59rWRS+s4Gb2RPyKPtKKX6JbPyXdg4Zkmvc65vpKCSW4dGZfCgUFTWr6qrSah6HK/XeQd8wDMxHgHpXC7WIIEiKEZ3P4JONAaKzCtZH+U/vyvNQHwTGhHodCn2sy86Dy6Gg+7+6j4rfm2M/5nwSNBFo8tGdFOaq/siG4OT8dzw4BtAYE148prH3lr/64hMVwl7zXVc2rrYvSQjDkpjWbsPK8iPaiSr7jF8fw8PAzqdQwQYNzSocmoqNmGi0X5LjQfsGVplN5VVcrSB09IhOt9d1PcMOXm1e4EsOt2xf45JeppYa/rrjxjjGcKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fZkrCKfALBjWgZ8a9tqklG8lFBCOXzPuyVd43f4nQEQ=;
 b=p7+X8t7BsGPzTRYsSS1NoMfEbAZVUMYnbb8ds62OdydaDp28SYsXgvOVviiDYyC7L0VX7prDD/UZMvOC5akg6gFqZf+9EG7gZj06bbJRoPqzlJLUDo5X5bW8IBJ8CK34H9s1C2VrqDondR8wgKVwnPWvobj200rL0bgxKhF7qrEbbYTj833DxS5YCCx/zJKOND9vTBTn+mxZ/NrNRRvVJk0XmI+sDnP/wdLgHAedHDSnI1Vl2vD7GOKBQWxY09IW44w4IrDdrXqxrD57NUjP2Ie6linCog5hrc8HCtJm1eKT7LMriH+ql5n9cNuV5J+6Wg7WT3GzrBdxjgIpT9Grkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fZkrCKfALBjWgZ8a9tqklG8lFBCOXzPuyVd43f4nQEQ=;
 b=rXV2Z/iPHdOpFzehLJLlZTaxmk5gccG5xVg2x3+CVzrXiwwYadKnsE19ElP5Lz+3nMgLge8T1dkmjHXOfSPryU8l7ij2AuQIHwC7Myj4/6YI2d9jYl5ieDdcPQKLhmb8spbYHuBWGrycdQQTHezYS0NOFTpAaFpfwfimlboSg8jKc8sLXSw5+P8asTmYs/xoq9D4kTamD/d2FvTA5HXUcjYL0YayTJu8bXvvVujAybO8aUhCBIoOEQe5IHQRgzsetzy/HYteWabAEo6ChZZNC+mKJ/aI8bvq4QsA/41RtF2Gc126rSn7NFft8kMyguR8yBUYaxfg5mfOR1jbR5TaxA==
Received: from MW4P221CA0012.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::17)
 by PH7PR12MB6492.namprd12.prod.outlook.com (2603:10b6:510:1f3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 17:33:30 +0000
Received: from CO1PEPF00012E66.namprd05.prod.outlook.com
 (2603:10b6:303:8b:cafe::92) by MW4P221CA0012.outlook.office365.com
 (2603:10b6:303:8b::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.13 via Frontend Transport; Wed,
 18 Nov 2026 17:33:30 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1PEPF00012E66.mail.protection.outlook.com (10.167.249.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Wed, 18 Nov 2026 17:33:29 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 18 Nov
 2026 09:32:59 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Wed, 18 Nov 2026 09:32:59 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Wed, 18 Nov 2026 09:32:54 -0800
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
Subject: [PATCH net V2 1/2] net/mlx5: HWS, Handle NULL in vport destination action creation
Date: Wed, 18 Nov 2026 19:32:26 +0200
Message-ID: <20261118173227.1957670-2-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261118173227.1957670-1-tariqt@nvidia.com>
References: <20261118173227.1957670-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF00012E66:EE_|PH7PR12MB6492:EE_
X-MS-Office365-Filtering-Correlation-Id: 0eacef73-651a-4ef8-9907-08df459a0f83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|82310400026|1800799024|7416014|376014|18002099003|22082099003|261009223027099003|11063799006|56012099006|261026140227099003|261102123227099003|261028144727099003|261021121427099003|261022105027099003|10067099003|41080700001;
X-Microsoft-Antispam-Message-Info:
	PMhmFPK15eH2n92LtrF+iX8oUKVaCEYgjwHKPAlarEvLdhjCtqiL5N+6ZF4Cmebn7lWsVk44A121tj7YCjKP1sZ6QpxSxJA9JeE39gjNbxNNkpqosX7EN+e6LaRnIg4mUSXWO4r5eGlGsXrSgmAgfQEj7sL2VduLLaKOCQa5tLReVv6u0gLNyScTpucPiDE31pdn9p3NxpdhwVLoGvqKfOq5XgmSi97PVU7scBPdivUFVXXuZ4CgnqMvjR85TsbvaCayymHFIj+nRPSsZihHf/ltx5rfOcNwV+jc6zYcdGuh6LoWTGKkQ40VQ509xw/MhyGI3WaizVYoAKUbReZI4/EYfobT/tLLmDiZ+XuGCLBhTjvDpAiUwFNAvnuS8yZ4mjZ0IOBC+axf6374E/mzGe/PVxjeuLD+mwl0VlAEgNYNZIVw5K6Gc1rlCQQbZIsijcIGONxV1FA5jrijhdoBoUECBwgeyk4XnZw9yTAbBvmEaTehHsMKVE5O25fgQHeMmFCwzVakZ861nPLZKOGibQNADzNNqjfyWyc7wKMXAX4O7PvnxB7ppyVHrKcTZrAHbYZ8TiWzxjKOifYbbHy/rcmVgNIHWekRHF8HQPFLaLH2EcC4L2hJIct4Ic+Flzeg7nzBL3d5kFUA6d3Ez1/s9f6N3S4jXKJh4s6r4VoPacpjE+UpDKcL4u1oEaX7hBzb1ev2VrJyF6fXymkK92JJYYpnGAbRZJnQoWQ/KJFMKgskuEOlB3J+3oO3FscYxUR6REeGV6Cl6SPc2tlXtXWHcw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(82310400026)(1800799024)(7416014)(376014)(18002099003)(22082099003)(261009223027099003)(11063799006)(56012099006)(261026140227099003)(261102123227099003)(261028144727099003)(261021121427099003)(261022105027099003)(10067099003)(41080700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Brq4zgAxGodkA9R/8HkSUwHOPYtZW5cPKbDidN6U4QVIXYjkuj2Udg7POMaF07JGvd3Wg2WbWICCHfoTTjbPzDr7/080oBZWmi3ucAHai9NrwX2Ish+83VRU4xXTjOfL+mAiHIIugldkLkPCGgKiv+8x0OMehfQ+oXsO8HIcvQ2ledp5bt4wad6pzncBA68jCi8nfiggaqsdVjxEKj+9vmfIzB8+WLSYC6bgHr75PrhWhQJIDCG6bdlJIqWKFj+E2s6sa7uR7051RybtwhdGXywM0GjlyXAIh8vDyza+/VS+yiEpV8gPyFWQdMBhJd8fumAAR6ExYa8JzAqsDCkG/ZMnKbZcJGnnxxQCaGAImDeQ2C38IZ7xDjKb4bt6XEX3NAaQwJZ21dGgwRINMxKjMVeEHjmQvW8RXfGQliI/d6TjBp/ubvSuMPr/8flt7d5S
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 17:33:29.6273
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0eacef73-651a-4ef8-9907-08df459a0f83
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00012E66.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6492

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

mlx5hws_action_create_dest_vport() can return NULL. If this
happens, xa_insert() will insert a NULL entry into the xarray.
The next mlx5hws_action_create_dest_vport() failure will try to
insert NULL again, but xa_insert() will return -EBUSY, because
we already have NULL entry. In such case the code will go into
error flow of action creation, and eventually will cause NULL
dereference at hws_action_destroy_hws().

The issue was discovered by code inspection.

Fixes: 8e2e08a6d1e0 ("net/mlx5: fs, add support for dest vport HWS action")
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Alex Vesker <valex@nvidia.com>
Reviewed-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
index cbcbc2b62809..de22e7279a31 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
@@ -441,6 +441,8 @@ mlx5_fs_get_dest_action_vport(struct mlx5_fs_hws_context *fs_ctx,
 
 	dest = mlx5hws_action_create_dest_vport(ctx, vport_num,	vhca_id_valid,
 						dest_attr->vport.vhca_id, flags);
+	if (!dest)
+		return NULL;
 
 	err = xa_insert(dests_xa, idx, dest, GFP_KERNEL);
 	if (err) {
-- 
2.44.0

