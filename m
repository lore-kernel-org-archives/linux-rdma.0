Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.200.35
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794840426;
	b=1ytYyJuDC2FddvVQZKBdNrsHqh7g7Os1HmOL3t8Vwk0lYN30kkNFOe2mY7tNSln6RwM9
	 z8o5BGroGq6PrIbXxPfcKaklGMT/gaiKq8TqDbZ4GOkSL2eOpm/sz6q1AXxWCAg7wav4c
	 GUoAYPiS7owgWZ0oJy4CNOd8Qev4DBTIaJ1TXb4uXTG9UoWjNnhlegCO9GEZHnxLBNssF
	 IbwzkzF0WY3cwY6oIN4SiPyxUzmnC4c1TtUUWP3uyPrcydFsu2OO8W4Rfcm8useVLwd2s
	 bHdTtrCpPTtm382T90t3M+O8dIp0tMNALdLVT1DYmdLxfCMTdGj2gmJnSBzYFpZ6XHQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794840426;
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
	bh=H2SS/ZE7RPzbpWqJ1YZBF+oRkV7pXaac43378905a5A=;
	b=TnWEMa+8dLh2734i5HlSYu4PtxhmEjP724BLq/rH0OX3QW2df4j/H5nqPqEntWnAkFeY
	 ikD1muEZUcXRMhrcKCnppdWw7LPr22Rrg7/0Unsyu8RLPZmIy4IFx10FL4GK7/W8yi5nA
	 oPUsz/tJEF7TXaGdMi4MNqO6VmVqvrux9ypnOUdKO/G2h29MXoNwZ1LVWKBGlt5qQw05T
	 0sTPkVZ3bSve5++qiCjiDoQY42PXW7EkJ2cltRyyyQ0xSJzhp7hyfyV485tua+b2eVCAT
	 Vfa6qRbXW2Jpy6SFjK9tapbviChNQJXFDBAF2v3nc6KSr8vxrsEwhdDIpNAuDXN0J7w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ZjbWiJHr;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.200.35
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012035.outbound.protection.outlook.com [40.107.200.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B79D3606A32C;
	Mon, 16 Nov 2026 14:47:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B79D3606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ZjbWiJHr
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yVENsUqQxSZea7DEh2KDbVgBpeKROdvRxP00Ln3PaCqLNxnmQ5XYNVW24DfYFd6VSPo/aGbAUAyjI84RxGEE19sKBuHUviSuSzIAHGL+vBmOTFXIVuU0B3TFkRSwdQiOf+SJAFKiOpFZ7wBEkpv4JW5PWH5loyD8qTMRKBskBEsmJ9HA2MVsMus00IxFnsq8tjVnsKuuvZdWi/MmDwcMfwbS/fnNacfWBjsW4+gKgEdM6at2iElL0yvilTYu3M0hHG7YE1j9lz+SGROL4j0tXjFkAn/hSENuuUpVtjziqK21HhZ3JMlr1cm5pu613/5QiZrhoepoBXzY/oOC7AV/xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H2SS/ZE7RPzbpWqJ1YZBF+oRkV7pXaac43378905a5A=;
 b=DkFiSj3oECUosidawmWOhGGR8eClRvBybTnFAdhvlggqPC+DxdLxq1WB0iUuW+dWi8QoGqmI/JIyG38Kv5PP8HHQk7uTiVnVQ+vLCkvapjGiTkOLxEPcfh3NsrAnOVwdUPVMoR0ZiccFY8s+S/aHT3eAeuKc4qvpvgz7o1w2UI9x4O5IAaYxiwkJe8/mQbSzf27slYkUaoGSwsr3feH2iw0fENI0vpbc06a8xW4roAT1ZRrfUVIvRsOnIqMeW3hRrYroT+/IyEmShwkfLW45S98lP+xYjL55UpKMXHKsNdoUbms8Fosdv7EnlRWyT8mOoJJZvSsGf8d2cshx93xkag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H2SS/ZE7RPzbpWqJ1YZBF+oRkV7pXaac43378905a5A=;
 b=ZjbWiJHrn0RaQLeUghdgWs6hnWRGGof9o8tW5GQs9aym3vVK0KTj7y/QhPtO9kWb0Hm7AjPri3wGf95p+nCn6nMGyaso8QX47NMnrRhK7g+vJZ0TaEIVpvOSsiRN+xG8pQgcDAn40J5xrYxmXy6ink3ywSvBTr0s7mVy9tL1aVo9aOHyz/+NxZs7qfy0DlEhyG1iL4PmsO/czKwUkcGBdUtVANI9yuaD0tzFJz02s7S1Yg7K5gwjFoh8/bFY1ox3uT5zO+owN9bVwyh69Dbbm7BjCEUqRGzsrtji2dQQ5B2siV/qaNon80GQpu3oy1rMW7f2fhPLE7kGUMk5tK8dDA==
Received: from BN9PR03CA0883.namprd03.prod.outlook.com (2603:10b6:408:13c::18)
 by CH3PR12MB9097.namprd12.prod.outlook.com (2603:10b6:610:1a6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Mon, 16 Nov
 2026 14:46:55 +0000
Received: from LV8PEPF0000006C.namprd03.prod.outlook.com
 (2603:10b6:408:13c:cafe::3e) by BN9PR03CA0883.outlook.office365.com
 (2603:10b6:408:13c::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.10 via Frontend Transport; Mon,
 16 Nov 2026 14:46:55 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 LV8PEPF0000006C.mail.protection.outlook.com (10.167.248.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Mon, 16 Nov 2026 14:46:55 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 16 Nov
 2026 06:46:20 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 16 Nov
 2026 06:46:20 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Mon, 16
 Nov 2026 06:46:16 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, <linux-rdma@vger.kernel.org>, "Mark
 Bloch" <mbloch@nvidia.com>, <netdev@vger.kernel.org>, Saeed Mahameed
	<saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
CC: Andrew Lunn <andrew+netdev@lunn.ch>, Chris Mi <cmi@nvidia.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, "Gal
 Pressman" <gal@nvidia.com>, Jakub Kicinski <kuba@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, Moshe Shemesh <moshe@nvidia.com>, Paolo Abeni
	<pabeni@redhat.com>, Parav Pandit <parav@nvidia.com>, Shay Drori
	<shayd@nvidia.com>
Subject: [PATCH mlx5-next 0/3] mlx5-next updates 2026-11-16
Date: Mon, 16 Nov 2026 16:45:51 +0200
Message-ID: <20261116144554.1194389-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: LV8PEPF0000006C:EE_|CH3PR12MB9097:EE_
X-MS-Office365-Filtering-Correlation-Id: 52a06069-6908-4a14-4f99-08df43f0757b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700016|23010399003|82310400026|11063799006|260925021911599003|260925021311599003|260925022911599003|10067099003|56012099006|261026140227099003|261028144727099003|261021135927099003|261022105027099003|261021121427099003|261102123227099003|261021123027099003|261009223027099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	fBRfolxUlYKNewn8hPgonOHj9nofBdjePYnpDNKHHq157Pz+XCMCq4K0D8f7A+Y2k/8rRyahZbAY2h1+7r4Ei2PElvuOI2vdK8rglXofBRpsExH9t6eJheOO/fuPMpCt8PRTHduvGee2bpOGHK/LVEfzhu7+/NKriUDCEwWLKwX7ZFDHALo5pn58Tj7EL9eh7gximOEeeOhbE7F8G/9QekVqOr9sckCFp8H13AxUzF2aNoVsxeGiBq6ihah3CFLXhEm8kxhSqlFDfUvfRXtB/+8aHvY4aEUNMJymITNwfC62t9/a+y3xNg+l4Ca3YXa9lJQXLr/O4ix5ndv6TF/74LQn3p+zSoNtFyNpJKZ3Jwe33eUDAtWA/IGhg1BkacZg/HzDNNPfegSnLuXLMLHQ2ovgO/tpJAsq4h9KIw4xggVD3tsLxVdldMiHm7X2xbs6V25ac6LmXuBqyIAV8cJYoqobbo53OznqGN5BXjjSY/NEXHlvNgbJdmQzcTYE7rVg0r8CHIdhhG8VJbwz4pueE/XZXh2jQ2yGYrNO+m89TGkwV5LtPat1qcg/JWwTEoDskRdDf+vUlcSh0VDnTMw3tsSxk4knv/LfDRuGN4xBRcZ6cbyZ/1vxR6DU3jeSyHwZPFTooszf2jHxUtuCLX+2GKAQySgJJxh+atiPPfIkY5PbT/+0zW8mK00PjRj922NkxtLNQUlVfqryYHx58b/s9A==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700016)(23010399003)(82310400026)(11063799006)(260925021911599003)(260925021311599003)(260925022911599003)(10067099003)(56012099006)(261026140227099003)(261028144727099003)(261021135927099003)(261022105027099003)(261021121427099003)(261102123227099003)(261021123027099003)(261009223027099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	GeV9gT8/q8lGO6O2PU9sTRbNCa8Ha63aurDCLcRatuXm5v1MPBncnQ+PDsHdxs33JduWbj4YhIukckzB5Xs4JoDkRCd1oyDDLIbR/3Gy6BKKTqZJIGAGcquXcOqWKgdszbgdANeSmCjeSinZdjY1T6/1Sz/XPloALUZbvyeHBThFfX47R7z1hV0c7KgaaSfrcBJ9I4I5sCH23edFRxeiAhfJTtgY5MPFUGt+VCwhAFffghdFTKQi7o/q27ivniK71z8Rh9j3HSRZqXeGoVqUQvwnC8jhc2HfdQ8tTewmAg2plOCqDn8/dQTMNlJ7926cG/suJYgmJToKWSCiF9Z9Vw4/JCMK4E8hX5bPMWuwFuxTU0zpHAI2Ahe3371WxfWBB/VrjzcRD8VtHdD2hkElCA8AyGUj8JNPlWxFjlWaNoUgYDridECuauWhVflKTl31
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 14:46:55.0460
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 52a06069-6908-4a14-4f99-08df43f0757b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	LV8PEPF0000006C.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9097

Hi,

This series contains mlx5 shared updates as preparation for
upcoming features.

Regards,
Tariq

Chris Mi (1):
  net/mlx5: Add MLX5_PCI_PF_TYPE_QUERY_PF to mlx5_ifc

Moshe Shemesh (2):
  net/mlx5: Extend nic_cap_reg layout to its full register size
  net/mlx5: Add IFC bits for SW RoCE monitor matched packets counter

 include/linux/mlx5/mlx5_ifc.h | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)


base-commit: 8049809206dcd95a122f1a49171e00833901f499
-- 
2.44.0

