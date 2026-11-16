Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.71
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794840475;
	b=dZQlXJjq7qdVbnkb9MuStIJBUsiEPtAMieDIdibrgTZWA4HieYSi7lV4fLEPYL9/uhYO
	 vNFpAfFhq2X6keKm15L1U17CJy/uLSc8XcVHzfF2b95T8Hp1tY9tnf9eqMoi8yUoKZGHk
	 rbsu/NjoGNZncGz7HOy5WjYfubhFiXtP+6IrFqXIfSdfL0WMtZQpNOpmta4UyPClm7FfT
	 MXU8GcyiIRiUWfOI4eKv8a6JYZyvUESyQ30/APyNG0Fv4qZLdOUoDCplPkJwykcaDILfE
	 PeBcAgrALT0zJbbuYmwM1X/uZoeit2pfhr1GS2eYiGu2tQ+xWE+ugZtjF4cNaYre5SQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794840475;
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
	bh=a2B5GVRP+96SmLxj867NKJWIOsuZAUGjYsEBipV+upw=;
	b=lPftEH5jOYzWJIc5XZ1Tw9HrYzDDkwg0N6wFjtPeLIq9z1G6qgRJ4ECwiTbGvPcbfiq8
	 sG+ZYFJZIkCbDgSw6X33csMYYqJR3z3rRwtCYDVjIepD8hcEkKRsHWgDVvqps7S8TASb/
	 LZaosMJvMueKUKBeXh1dD/7Pm/XKMP2Tp0rekTTKj09nTbnKNLy54gUR5r5JwCPVdqLMl
	 qTjUohAtXNA5HDjzuyWtRxBpEerujRBJPn0N/GL3o2t5WhTUenE8py5DMWqp3KLstNg1T
	 r3gDZdiQQLSoauhl0rFltHtDLgIgl7mnZ2DWFo3R/CZSrepUoI7QvCDLh5grdmeHo9Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=IFnxrtAY;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.71
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013071.outbound.protection.outlook.com [40.107.201.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78AC6606A323;
	Mon, 16 Nov 2026 14:47:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 78AC6606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=IFnxrtAY
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XGb2CwJ7H4nL4sagakgoi7j8UefwZunO9htpDcBgQy2k/xWTMSr9XOeEc43hmebMeKESIG88rIXsyF5s+eEW2/Ns+jYpPfAUaB1LO5tHWmcZaAA7fRKBXEmc1PTOy3Obxgd9B91jYpFa5sKZ08Zu+EM33FlRJXZoQnHq8pgKJm496qH2SKkpl2kWvqTjm6E3/7Xk6irwrSHEd7lDkdLm21UHppFzxD70k6x6dpkG66yCwMysZWTMKZaCLsBwSS/zfIcw/R2/kGEVQQGD3nTLoi46M4GPcndvNQDTvj80yWXEpx+xrMtzT7ZClgEhQ91tkQuMFypE5Uq5GvLV+mV+7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a2B5GVRP+96SmLxj867NKJWIOsuZAUGjYsEBipV+upw=;
 b=risP13lBGIeJDTUNTHo9eN12SDjoom8Rt3t+XeyC84zm9nb/vwrIRV1XMghWz+X84aLtfJaZdyK0sTsysmNAd9Ni/qdus1TiJ6klXC+VfYeqsxLMKSrGwtth+CVk7fUSyXexx0tA66JTXIgBE6KfuzIIHF69VK37f/xg5AqRoszLTsYCPLDKA2VVK+fdOdsFQ9IyMakl+sCj//j+QSeJGXvGdJsets1MiUfpASWr+slNUaL3P6EiJZM/l7y03PFQdozpaNwo/4H3hVVWgn4kQp4uzTtdFEwvQamBpxukskyCXNzh7+RrNtfkzQCAkRH5k3KU5CSnJA2HPerDC2y6wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a2B5GVRP+96SmLxj867NKJWIOsuZAUGjYsEBipV+upw=;
 b=IFnxrtAY6Lmf0AlEZ7/pI7OuLjEizeG/sXhDRBTxV7XX0iV0419GFyc3voO8QuihbU9WTPKdFZ8Q25EFg1j3rBMf/IswJwSLPFme9rYX9Os4+DCfVMNUbaTxPTz5Jh4PSFAoR6hxGqyPQfDJF8UcN4kGyIxKC631EkZAo5xZjQp672645odd8PRqxnoUPsgxwD6F0nWYmaAqtt3vm89BId/MR6BnCh+gPFhO+bV3igAIl1Bpega/oCLpdvnlobZ21EQtyPeFSxKJFYPCQiFwP1kFl2jFGz9wcsEUSbQZeif2QuJWAIzD2wSXwuarIfZYg70u2ifK95hZyjrh8iPTLw==
Received: from CH0PR03CA0005.namprd03.prod.outlook.com (2603:10b6:610:b0::10)
 by IA0PR12MB9010.namprd12.prod.outlook.com (2603:10b6:208:48e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Mon, 16 Nov
 2026 14:46:48 +0000
Received: from CH3PEPF0002457B.namprd04.prod.outlook.com
 (2603:10b6:610:b0:cafe::49) by CH0PR03CA0005.outlook.office365.com
 (2603:10b6:610:b0::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.10 via Frontend Transport; Mon,
 16 Nov 2026 14:46:48 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH3PEPF0002457B.mail.protection.outlook.com (10.167.252.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Mon, 16 Nov 2026 14:46:48 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 16 Nov
 2026 06:46:26 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 16 Nov
 2026 06:46:25 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Mon, 16
 Nov 2026 06:46:20 -0800
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
Subject: [PATCH mlx5-next 1/3] net/mlx5: Extend nic_cap_reg layout to its full register size
Date: Mon, 16 Nov 2026 16:45:52 +0200
Message-ID: <20261116144554.1194389-2-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261116144554.1194389-1-tariqt@nvidia.com>
References: <20261116144554.1194389-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF0002457B:EE_|IA0PR12MB9010:EE_
X-MS-Office365-Filtering-Correlation-Id: 49b3dc2f-f795-4654-cefe-08df43f07196
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|82310400026|1800799024|36860700016|10067099003|261102123227099003|5023799004|11063799006|56012099006|261021135927099003|261021123027099003|261026121527099003|261021121427099003|261009223027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	KqAih4aLCIH+ni04xTcq7qfwtW7lawSalFta5KbDxfNgGF7dRbCN8Ecab8Nn7OaUAc4LTpAucyzWpu54p6QqBfC6N4sHXhMlmmHCtOt7flTyF746Qh336j/oIEvn7ZZYQA1h+Xeksl49RhgtV6nVRlfs8SY/ca/3SVU2JtBiF9ohEwAJeZRMVxwyNLga2yrLTxa5LQi/X5+Ib1qrFLJNZrr2EWSVzPRCUBIyxawVGAZA01JAJYVSZ06g9a5ePXzu0wDntzT6JuYpjTrQUdQ+kgj55gOODf6WxU5FcFJE3rIfGlw/07Cuh4LPEsJ3LncUhOgnUEURr4hdYnZV8lyGHRS7k8JZNxE+3QXjME024YDST2H8t84ZuIYlScyXlliyYSMv8PBAR0m9pv+rp9m9n+aRKVQ0CWwqc5EFDQ92rc8V22XAyxYQcyPD/6ZSBirjLNJ0eYnIXP/izi67u9LH2ztEVnMOZ3g4EzTOoynYI8nZD4ivh1TmjLJJuJ6XXMljYR4ArV+UYthmLBBmmhTjaKD/xgpn/K/8DgGY1TtfaOYCMIdsiYEWbdp1RrOq+I3yPqatldT7Agn3Cmrm/6t3zr07Lpm9+E83hV3ahQM2miCpHax3Cmq8YeJtR40QYO/TsWNzCtCDVzEGqI+PhTpbcxNmXeLMuArOb/6/jfOOrDGBNXf07U+p3Aef6245ultcPLUaW89LXpcWhtof+1jsQA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(82310400026)(1800799024)(36860700016)(10067099003)(261102123227099003)(5023799004)(11063799006)(56012099006)(261021135927099003)(261021123027099003)(261026121527099003)(261021121427099003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	pOsU90wqwW0McU47IZcn4FWiTEgzmJAgeQBZdFhPuJJSMNBGL09Rs+zvWyewHFkY6dzkhqVURpYMpD7l+iwegbM+yn6Mr3SFqwvzch+JdNy9ZvYX2H/krkQPrwovBdRCqKOkv6u2msrv6j6ciRsHKKdFOB9TuSUS9LWKlJ5fX9tc6QLj7raypBN/8Jhu1o86XbAp+KqH5NgULaHBGhl/eOhxiTNsAiKdH96zrldVpI06mTwJtvviH5EBp9Kf4lnfE3SrRV1bwDqpw/iXFPL9xGmBxEnRNgR+7YwlVV71OuULl8LFzfrx0IQyQJ3qOSZQvl89ri3Dk7TvjM9cF06+eXbEtclh34ZuIgoOj8XTqnRQydCo3iGPyWIekQ6qamZXKrouGSFoAUSolJroZOHCU8pPM8nfhIM6KqTvB8Afc1/dYVL2BWeEh90wRfEHimWz
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 14:46:48.5317
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 49b3dc2f-f795-4654-cefe-08df43f07196
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0002457B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB9010

From: Moshe Shemesh <moshe@nvidia.com>

Struct mlx5_ifc_nic_cap_reg_bits describes only the first 4 dwords of
NIC_CAP_REG, while the register itself is 32 dwords long. The driver
reads the register through mlx5_core_access_reg(), which derives the
access length from the struct size, so today it issues a partial read.
Partial reads of a register using access reg command are accepted by
the device, hence nothing is broken and no fix is needed.

It does mean, though, that naming any field deeper in the register
changes the length requested on the wire as a side effect. Describe
NIC_CAP_REG up to its full size, as is done for the other register
layouts in mlx5_ifc.h, so that the access length is fixed and further
fields can be added without altering it.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index a7cf67264a17..04300c8765a0 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -3448,7 +3448,7 @@ struct mlx5_ifc_nic_cap_reg_bits {
 	u8	   vhca_icm_ctrl[0x1];
 	u8	   reserved_at_1b[0x5];
 
-	u8	   reserved_at_20[0x60];
+	u8	   reserved_at_20[0x3e0];
 };
 
 struct mlx5_ifc_default_timeout_bits {
-- 
2.44.0

