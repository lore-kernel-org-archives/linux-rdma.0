Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795163485;
	b=mlGZHHLL8ZQMBL/ZOx9rK9OeEYSbMQTnLSaKBjDGtrOiAuhAgf8Q2qT+VjmKxDuz8fgJ
	 I+py5E00xcWh969tZoQjTo2OB8vbAXC2k7n1Dfh2m1/KzkjK9en8NpxI8z1pgciXcmj8O
	 Pq8Rnz0BNUL6SrBGqHnrbRGGz60OmX86qXeptPt3SEl1ufwo0gvERpdrcCpV7A0g8vhbY
	 skTWdedv+7YzTlFZ+sXA6A75Wbtu/CdhG9ixkcvuMlD3l79zovEJuAfUXEqy8ILrUSkxi
	 7cL8bqizyCZFswZWo/95ZrC6C06+wNKYagF/NAci68oZtJ9OQV4e0LrQBszmooMjSPA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795163485;
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
	bh=alsuIIV8K61g4Ejcwy0iCbzR+hveJeez++g/+NUFzeI=;
	b=OUga1kU05JEGKu8hEm1viRh5T7tg3eoYeCDLEbtSmVSTF9OTJg0xVaHVKGlHmuwes4pQ
	 QA9pkxUzM8bppxRt1oOShpbp6PV29nMbMuySAZ4RgwV5jo6eZApcl58XZt+vp70tNXYR2
	 GqqHrbLpsCj1ZiTRLqZsc3allrJGEXQHBJMtKGRQxI9hUQAcUHiBSZZmion+dewdsKZqM
	 8Vfa/MK8uNGROIC9UX0GNvT0aMZfeQ7dUtmukn0QlfWHWQBUwrm+jMMV5JJDKsk5lpDrJ
	 JtL6Xxz0ul/OKJ/07a7URrIlWQkCEgZE4mLhK+xLpslzcFsOdPIcx9wyuPOIuGP78bg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=gjOmjfxV;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.51
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010051.outbound.protection.outlook.com [40.93.198.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5BD606A320;
	Fri, 20 Nov 2026 08:31:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1F5BD606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=gjOmjfxV
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QxMvxOqefqm2s062hnd1A3AdGd8ARKVthC2rHlq44343YwpKxQfwhSdsYsVF5SbBtpMixgMppz1y66dn+NgtZpZ0PHsOqgqdX0Sq7kwRZTV5MDA9qB0zu4GF9pu/WlUiQAFq2ebuSA0Bacn9hPzkLtGi/TorWhgw0Myw8jSBVj8oUTi4Bsx5n/Oj//euWuVHtnBJ/6vC8XrOMU4T/llN3OeyiSD36O4aJrSrbTn7q5TQYb3ATwY1heZluJQmh5TPAfZc8oIRbNCTMNA7dowzntdDz6r6lPM5FbeQ8ZI8YA8v9/T2Lb5Kcu13D3nUwtz74uPFB6fBNImFki17yRqEfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=alsuIIV8K61g4Ejcwy0iCbzR+hveJeez++g/+NUFzeI=;
 b=FZjSLEKsolbbWn/cDWQL1emFnrnW1axXnjOioZ+S8PcTjbk58HtiXwIRErhCWuHZTxPhtx4Arwro/rO6+Kf2RQ8izDucA5t/FabGoC952ohRYnqnbR/03DloB9sQU5pSgBxkSrObv9eiHsyabArnxCCCJj4pzE+V54nM/9W06D5hatrPiikaJxxXZ8/h9j5/pPhSdWhE1GhLpLP60/tJ/Fwb7kDl6CDW4aF6rymaxAH2wcc4ezJtxCECBcQTqZgOz6PxsilhDuJUXqZIFrjGHk5mUDUdGIg5Y84l672fNhUSrQ+3aQTV/n81d6guBaPZmzNfQOvS9kktHJqO+R4fjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=alsuIIV8K61g4Ejcwy0iCbzR+hveJeez++g/+NUFzeI=;
 b=gjOmjfxVHAxdyG8QurcYk7zWt6TrbT790jzbwt+XDMv1euXBkFZDoge2Yz5DLNVYMS+dG3IzGo2osRqOrOK/FAcTSTMZ56zhWlnTm1BGzQBepxv/QCyrp59KwZpmrV45N81HdSebf5hQGo/CkBYqy9IpK3PCwvBivpbut15bqS2oK8Nx8TPT6ABNp6vxcFcF0nByrgAn/eb3rbq5qBXab02e8/tG7kxgN8VkgqMdtD/nwDccP21pLThTwaUrJqNPD3gGPdoQTgI5RV00ycpnQEh1yQ1rWtAyzZJPK7YW3fKfzTBGUsY8Map/ffW/P/c3FZPobr6fGlMLPZf3D8MI9g==
Received: from BL1PR13CA0371.namprd13.prod.outlook.com (2603:10b6:208:2c0::16)
 by MW5PR12MB5651.namprd12.prod.outlook.com (2603:10b6:303:19f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Fri, 20 Nov
 2026 08:31:20 +0000
Received: from MN1PEPF000793FA.namprd05.prod.outlook.com
 (2603:10b6:208:2c0:cafe::a6) by BL1PR13CA0371.outlook.office365.com
 (2603:10b6:208:2c0::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.639.10 via Frontend Transport; Fri,
 20 Nov 2026 08:31:20 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 MN1PEPF000793FA.mail.protection.outlook.com (10.167.249.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Fri, 20 Nov 2026 08:31:19 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Fri, 20 Nov
 2026 00:31:00 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Fri, 20 Nov 2026 00:31:00 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Fri, 20 Nov 2026 00:30:55 -0800
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
Subject: [PATCH net-next 0/2] net/mlx5e: Fix mlx5e counters documentation errors
Date: Fri, 20 Nov 2026 10:30:46 +0200
Message-ID: <20261120083050.2540739-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF000793FA:EE_|MW5PR12MB5651:EE_
X-MS-Office365-Filtering-Correlation-Id: 40dea7e7-5d2f-4252-4008-08df46e0a6bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|82310400026|7416014|376014|23010399003|18002099003|261009223027099003|261022075727099003|261021123027099003|261021121427099003|261026121527099003|56012099006|10067099003|261102123227099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	ZojQUFW4o6rxZX8QwarwPtZVAkuIa3X3F9VemB6XVfwsvgSsVI0KaZNvi8WBN1I3eSQ+SSHr1A4+/l98pSG4Ayur3EHu5qHCLkaDElm8sWrDWnj4JPIMeBifpkm4+Nhgll4pLI0kjuWiF3XT4XpFydV1i1wT4wao4diu9DnqAKOkHKeK4Ul4KVYI20u2YzRJX1a03d3eNZzWTxZ72+BS1RQek2fG9rCDSBJDM376urnE9cOH9j5L6Iz+4/INVzKaTAjoJugDESxTjz9hdiH0oMKrOQm/xrHu0gcVRc7/LDJWljpEwsvMA4HZGkkaos7s4ETGadIL/oC3i+jXyLdH6I4MiOECTWmzfU2jsFUk8DprEKyrXz6EVDfTsz5Oa3/RNlb2N2KQfAYTPsVCJ0MnHyCdTlQMvdPjy+IU8cugMnlSULrU+IGDxXBy94ov6Robj9zZqhozp3PLVVRAUKJao/vfg+ErKRCwZ/lQXY1QuK9zPTWvzZyiuH6kTh8hSKqBAZX6zNE/BpjQRSPtbhxrklINmZulAzIQw+LUqLy/duFAkzlrudsNXMz2mDCsVDkmN9rhYfcW+PJuaRl0mIKPpjdAfOavcYgc/gXBDtgC61bAQpvl1IFGUXynuBf9KLJI2JQumvl4eI74HFRbyPelIYrYg065+fvVQD+hfXFMUWOuj0kOp9dFZT5wZWwGUgOYco94dTgeXfbv+WrmAicMPQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(82310400026)(7416014)(376014)(23010399003)(18002099003)(261009223027099003)(261022075727099003)(261021123027099003)(261021121427099003)(261026121527099003)(56012099006)(10067099003)(261102123227099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	G4UCIOAwQIWYAmqIBtPm+MGXuCPqzbbbfA/M+0QukhSD3sA2lAHAioIm9dkKJY/qib0rMWU8m//nsMqKX+6fJVplT0HMG3N6JITrasYauF16grdxrYC11gGUKMzsMkk8+3Nie7M5CKpOrXQalg58uLy6OcDuI5sF6VVvVleXY/gyv98bVRBPdBsmQFpAkgE/z/XZKoRpqzGikfOHKcA5Ra4TvCs+IZFWvoz8Szul9ETIspSEIwVwzU9kbMj0q9DRnAgzaJ/g9WIHJQCSIhfDDszX+D+CAxqiulld49b5tOGF4VxDiengRL03MRonDmgFA9O/Vk06vSz9jyvtTJu0oJKzIRgd90nUHsF3XBbCYeZNsUxpnWc9Fz5XvmqTuJ2L+5IgZ+b0MAV85USdS8WE0g2KnqhW8hytzq+RwUasftP/P3lvskspzkoyDc82fqMv
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 08:31:19.2104
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 40dea7e7-5d2f-4252-4008-08df46e0a6bd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF000793FA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5651

Hi,

This series by Gal fixes errors in the mlx5e counters documentation.

Commit 8ce3b586faa4 ("net/mlx5: Add counter information to mlx5 driver
documentation") added descriptions for counters that do not exist, and
referenced one counter by a wrong name.

Patch 1 removes the documentation of counters that do not exist:
rx_bits_phy never existed, rx_mpwqe_frag was removed by commit
7e426671704d ("net/mlx5e: Single flow order-0 pages for Striding RQ"),
and dev_out_of_buffer never existed and looks like a duplicate of
dev_internal_queue_oob.

Patch 2 fixes the name of the rx_symbol_err_phy counter, which was
referenced as rx_symbol_error_phy in the rx_crc_errors_phy description.

Regards,
Tariq

Gal Pressman (2):
  net/mlx5e: Remove documentation of nonexistent counters
  net/mlx5e: Fix incorrect name of rx_symbol_err_phy counter in
    documentation

 .../ethernet/mellanox/mlx5/counters.rst       | 30 ++-----------------
 1 file changed, 3 insertions(+), 27 deletions(-)


base-commit: 2208ab00f4f213ade91ab775e7f8c4dacdcc856e
-- 
2.44.0

