Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.64
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793724100;
	b=tsuLrCEl1b3m8Ts2UO1XaZUbmrXtsp6kkLIFotclOhpIpf7ZSXvE1fR6iNfpq0Yytuyh
	 1hMb2UMQLQ82zlmsj3+eLUxObysG4cfKXYD1rIJCFL6Lv9l3/5MFTlxkhF4PiWX7Gm/wM
	 kvZ+rrwX8qUdGgPnIuLhwpO7K6i7gk94eNYf6GCny+4M2NYKZ80odwrxLusI4hgG1Og0x
	 QAvBYde90CxzZRZSQla4T2g/Z2lMqj7UgDFAAAX1nficWcO23M3pNeOccFWfjFI2al7xq
	 noozmD0E3umluw7R27CS+L8k/Ex1ZRBNu9sXGwNOFX6OufnojNwvQceve7G2R3nzEYA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793724100;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-NV-OnPremToCloud:
	 X-EOPAttributedMessage:X-MS-PublicTrafficType:
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
	bh=UVdlhV6REm1e00s8GzoJMmtK6VFxIIRWTEvRLovhjzI=;
	b=5fTuIvfViPBxyKZcVimZda5+I5eeaTYdzdbz1qbt5ac3W/CwUYu59krzp3tYDFsAOHr1
	 5AtmgJqqoTP0pa5wVtdu3xP95v8ocRfy6wkeP4Br4KlV6dje15+1Ywv1Jr6+BalWED5yp
	 LsFCX+S/tgFjB3RKEmJ59Ws0WkOpdl46WGzrEcaKQ0ctB7PjAI6plAL+ss5mYnaXOlQuO
	 Wjs7SaAWhCSaCrVwJ1Hfu3M5phedKgp2JxYos7StX/zAdTRTos3wUGnIo4sbdKkAuFMN8
	 TEiZGhu4NdAG1VCjJNopEkU8NVYCdfbSPl4UW7nOUGtV7uSlZgzqT15x4Y4xLpbWcCQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=r+DAnFlm;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.64
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011064.outbound.protection.outlook.com [52.101.62.64])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C1560A2608;
	Tue,  3 Nov 2026 16:41:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B5C1560A2608
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=r+DAnFlm
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UQouggHgYQve7/qNDKlpQYD5kcTPhGeiqPhF6/Vm6vA6LxwQvu/dqzQVIp96+matocuiYhNfpXCn0oKM142hDNUFLlthDyjAB6EAUj9RHQGei20v4lAiNrqspPqF3X2l1E7x44AfP6Xro7jf0dRVYuWKiXd7HCbQQtlBu8R2SI8RJ36HWgYSZ55Qloie5DFTrMU/DzeWn2SPepQ2/sOUdMdh/KCPGtW0mpUbQbFC6kPIMl5ACbzSIzWXUHlQFVg2GmxXPv6v4/W5tcE3XS5miSjvakXBjKbJt59bnWjVLFoQO9STVbrehobowarxC0rQHdaP/uL+zqSpxL4FTHh93A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UVdlhV6REm1e00s8GzoJMmtK6VFxIIRWTEvRLovhjzI=;
 b=cWFVXQ21At+OaoaTFMx+IQDQmalI/7WOFdpgCKpIMXxjMMADeSCNY1hIXANSZNT2JiP0/ccpAwtzJVn9OuQsC8qBfkfzzxDWubfPQqh2SRqPxb3S4RCnPU55SmfdH9RuqscBedMSpLhlG5qzBi5X2SOb4fQ98aBcUpUpfB7h0NgNDp2M6VWyWoo3XBz+uGHiX3FbH4G0zzCTm5UcEPB4df6EY6M6EXUPQkRefAu7RYtZJf7YeSpuqjwOdTtWOJqzV2Mpfxg7YXMk0gK1QockJyRI6HjFnEW+qKIl2o1HxoTLIjiEM2Tfu2AxnUIwe8+qvfl+iY5N/9AwqTqGHPNj6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UVdlhV6REm1e00s8GzoJMmtK6VFxIIRWTEvRLovhjzI=;
 b=r+DAnFlm74JKsO7sJ+39L6NZgGRmhFVopRcqkwm7uJX93CNrJ9IKHhfRtu9WEkb3R0b9bXE74crnVe/HAlBanMv/pLqfqO6vFeW0MA/u9z1x1bvE4B0DQwv+gvyypTPWUM1QrwnwCocRxHGwXjuXUELmts7V6J25i80oOzAilV0uGF5DlCc2e0O7/nvC77Xz5+0BfDwpBf/Z/LxrsVhDh1uYe7ztXyc22dU7ktvnZbJ08uvJB45gQkGt3N7J318AwHI1+UwLH2YxuJqngYpCsLpmpHbMeD2IjeVKw+8Z1bVOktx72EVTlUSjpTy4jFwaTP5akVL87T9qBEWAWHVJWQ==
Received: from CH0PR03CA0077.namprd03.prod.outlook.com (2603:10b6:610:cc::22)
 by SA3PR12MB9177.namprd12.prod.outlook.com (2603:10b6:806:39d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 16:41:12 +0000
Received: from BL2PEPF000352CC.namprd02.prod.outlook.com
 (2603:10b6:610:cc:cafe::9c) by CH0PR03CA0077.outlook.office365.com
 (2603:10b6:610:cc::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Tue, 3
 Nov 2026 16:41:09 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL2PEPF000352CC.mail.protection.outlook.com (10.167.249.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 16:41:09 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:40:41 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:40:40 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 3 Nov
 2026 08:40:36 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH rdma-next 04/23] net/mlx5: Add macros for reading log-based caps
Date: Tue, 3 Nov 2026 18:39:30 +0200
Message-ID: <20261103163949.1554-5-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20261103163949.1554-1-yishaih@nvidia.com>
References: <20261103163949.1554-1-yishaih@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL2PEPF000352CC:EE_|SA3PR12MB9177:EE_
X-MS-Office365-Filtering-Correlation-Id: 72db1835-5cc5-4579-64f4-08df39c943a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700016|23010399003|6133799003|18002099003|22082099003|261102123227099003|3023799007|56012099006|10067099003|261009223027099003|261022105027099003|261021121427099003|11063799006|261026121527099003|261028144727099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	07AAKHRqRT/ZxQjWZ5rdDFUvtoSWlrArDJWj6LXyLq33jf9ENkz4NZfBk47PrG+lASMf2KoaAQ7wjb2yPp3Td/MRtcEtgUSFlgW8+ZtXVEWjhnacQdCMl/w72hTy284jbzi23Z1e/b0QOsKLQtp1u40SW+frCiz+ErMe74YotCW7Y2XrqO4b76bn85ZugcDGB0RxP4whPCd1jhekHu8eOA8yAI01PqTVWVFu1Biz5ks/6xQRY585LPeJgE4+WKi5XunhxWy075b55LwOojeHTqkJJl7/A9OBkTke8LDN6mmL7sKzAHZfcB9Xt0SLLogXzqeNDi6zIDCpLUtG32gswweBNQmfCkI9XYoNT2o4ttzPOUoFkLfeOChf3or3Ees0tcNpVhM33HeF1KSF5PLAGfoDJw7LCvmex2UL3cY+1S1b3RQbpvEFms5iQQZjYOOzZjgVEMEwX2Abw18hBOMPvfRnEAVdVL5GEJDuazRyRcGXDVa7B1i07cK7v2AlKIz+So6/b4kMmNEkUih96fo3B/7R4rMOYQG6F0pPjl6eEOKqy4DtVYQz2g/1Lz7ojWRE/DMix6aceTUpkvXva/Sx1agaS0+4I1uq6shzWNajJd+42ymJ6/FVL3cnoEbqlz19TGWyO2sl61ZOV+/brL5g4sddlhWD4zAIxgdGEQD5UEtce6E2vyns1k+n2+xMEX03K16SDaYnczu5+nTTjMPKOQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700016)(23010399003)(6133799003)(18002099003)(22082099003)(261102123227099003)(3023799007)(56012099006)(10067099003)(261009223027099003)(261022105027099003)(261021121427099003)(11063799006)(261026121527099003)(261028144727099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	itTBG1+a5tX9tjZQvXhUB/yRTdznBnKKbZ6wbPBGSr4wa4sQq50RXVNbh+cIN4fcnPLrW5W5D60k/idG/CPtdODuSYc7L8W/5frbXJCjJ7pva9KjRGwDOYrO/4JZ2x+SgA4vbjVj5ooVmKFZtDeARfLwNA3lQtUee9rWCCpYCCvFeZ1b/53pMClaBqeoUdzxfZ+OgkdOsjwyrdZjDO+p3nG0JWxIA5PM5Qf6FW1vXRgAWtI+yCGhd9JarV21Rj2eWH9iSRNGXs8HA3JF1cPqxRa6SHld60cBT0N835kzMUnKuw9+Kt86H/BtOskal0Dy2kcP0/pOAurQ1BVOl7wX8WmAF8Myf0nZrs0AN9FE92/IHsU3cLCH9BGPY06fJr45vwm7WWuoA2OGbn7r+xlHz+kReBaKo0mkH6A+RRoi0ZIsLZPpNkiiZUsj0JC01XYl
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 16:41:09.4404
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 72db1835-5cc5-4579-64f4-08df39c943a6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL2PEPF000352CC.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9177

From: Dragos Tatulea <dtatulea@nvidia.com>

Add macros that can be used to exponentiate log based capabilities.

When a capability can represent more than the used version (u32 , u64),
value will be clamped to the largest representable power of two.

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 include/linux/mlx5/device.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 37727b5ab78f..f45454f65d5c 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -38,6 +38,7 @@
 #include <linux/mlx5/mlx5_ifc.h>
 #include <linux/mlx5/mlx5_ifc_macros.h>
 #include <linux/bitfield.h>
+#include <linux/minmax.h>
 
 #if defined(__LITTLE_ENDIAN)
 #define MLX5_SET_HOST_ENDIANNESS	0
@@ -47,6 +48,16 @@
 #error Host endianness not defined
 #endif
 
+/* Largest shift count that is defined behaviour for a value of type @T. */
+#define __mlx5_max_shift(T) (BITS_PER_TYPE(T) - 1 - is_signed_type(T))
+
+/* Calculate 2^@fld from a log2 cap field. Exponents that don't fit in @T
+ * saturate to the largest representable power of two (not to the type
+ * maximum), avoiding undefined shifts.
+ */
+#define MLX5_GET_LOGSZ_CLAMP(typ, p, fld, T) \
+	((T)((T)1 << min_t(u32, MLX5_GET(typ, p, fld), __mlx5_max_shift(T))))
+
 enum mlx5_inline_modes {
 	MLX5_INLINE_MODE_NONE,
 	MLX5_INLINE_MODE_L2,
@@ -1096,6 +1107,15 @@ enum mlx5_qcam_feature_groups {
 #define MLX5_CAP_GEN_MAX(mdev, cap) \
 	MLX5_GET(cmd_hca_cap, mdev->caps.hca[MLX5_CAP_GENERAL]->max, cap)
 
+/* 2^cap for log2-encoded general caps */
+#define MLX5_CAP_GEN_LOGSZ_U32(mdev, cap) \
+	MLX5_GET_LOGSZ_CLAMP(cmd_hca_cap, \
+			     mdev->caps.hca[MLX5_CAP_GENERAL]->cur, cap, u32)
+
+#define MLX5_CAP_GEN_LOGSZ_U64(mdev, cap) \
+	MLX5_GET_LOGSZ_CLAMP(cmd_hca_cap, \
+			     mdev->caps.hca[MLX5_CAP_GENERAL]->cur, cap, u64)
+
 #define MLX5_CAP_GEN_2(mdev, cap) \
 	MLX5_GET(cmd_hca_cap_2, mdev->caps.hca[MLX5_CAP_GENERAL_2]->cur, cap)
 
-- 
2.18.1

