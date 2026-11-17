Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.8
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794935433;
	b=TkxucgcYnKTnwhQPd1/PSEFzjh634v+FqzNB4EJ8DEyBt34kk2V9E+vb+TqmlA9Gu4OE
	 coNHrJJV5DkwA6yIppU9XN4ACsqEd0cg5yyw8hPgt566Gl5f77yYPfoKQ5PLMNwZlL3EP
	 G9j1knDD7P0vw/K+CsIsiGB4/0j28vcUxJrg6zz3dV3DGt2N/JXbIW+LiiK8gGiASgB0e
	 gj6FRYdy11zAuqzLvPH3WmCoOLRK1c9ZKAl3B6zzIBoKKJ1jwAkJdbrq20ZaFfng49tzK
	 9KMi3GJEx7PtV12ML8QfZvt3v3YmvKXoJ5pIwaWq8kWRAGIKAfHBoj0pwA2r/txXcYA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794935433;
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
	b=pI993gzwAtPUEGo+OaNLQDMSeMec7SEXE3za41y0q0sK948aC/9UVfyK2hQgfNoQoz/2
	 PL6+60aUomqprEhDAtmrGZdzduMBB1izL95heJWokzRbfk3g51WujCeZOuTsoiw4lUUla
	 3//S2VVrRUyiwpOnAcR0Zdpz4hFJpC34w6MJlOlXmSPDQmjcbpsbpN66h5qgQ/eOcp7r1
	 1PadavdvWaqTaKYaIWUo7LLG+9lN3gKWw95/IXFxkpDydjUelclpfvbKZckdC6LndR7kM
	 UQ1/lrb7ydmyMsEAOmxCSiGyfyQcoVcdyqZFwTjncoWSR4Bm3w6Kx+FCr/1TcaOtlWg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ZZDxbzmS;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.8
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013008.outbound.protection.outlook.com [40.93.196.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93D4606A32F;
	Tue, 17 Nov 2026 17:10:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A93D4606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ZZDxbzmS
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vVNprsipI/qQ3qU5lXn4p9fvXo5ug7t0b9ThxpBgafyIPt6acNDaX9/Ne9UEv83wW/1uStXPYBrBaotsxWaDfrqwJedS/uzdF7CYSZgtkCjkzj4nGxWAcd+4lcOPaQxDGnxuRvgnzeA0xa+RPCxW27MY96d5yc0A0GvilT/ql5+I4iXZbbEdjXX0bPKVg7HF3rzhKkOBPvgCuS3A6DY30ZDyc616Xrvr7BbWMhaXnsbqfrjAkCgacBwSNaBKY4Fv/NMQ0ieAMM0BD2S0fV2DXjX/LaeyBpEn5jcm4OBXFT7jT0FwtmEhydSM4hG7T7dR4Us1q2feggvfguwFPMlv9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UVdlhV6REm1e00s8GzoJMmtK6VFxIIRWTEvRLovhjzI=;
 b=p+Rdr1A36dnSI95XfyMSmnmCfZmN3HbfoxNa7BF416l5Ys/jgWQp9pLqKKTCOOF/xHhkk4GGmrQlOwIfBIse+V51tlZ3Yepkqtms7kMoplbUasZtgCYsa/2j+BOp8svn8VOd8YqJE5nMIeNfHLdOsN22ZId+5PW++Y1rmxhEswCSvpIMQxIDBE0JgETMUpOlYZS+9v9uNXqrwGtFkUISMBicNLWUrguDSDmfH2siNe0UJdHlY097C+QVAf8qJ97vIQB4G/wbZfUxPcsyets6XcvXLYPDCEA//T+in/PxE4v2H6zEjbqMZHrwCRgFgXyUfPFq8nVK89RQ0E/sRzq+Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UVdlhV6REm1e00s8GzoJMmtK6VFxIIRWTEvRLovhjzI=;
 b=ZZDxbzmSOfcStvUqW+Co9hZJ1uLh79CsRoynUi4jLSE/xlCpWqCBdV1DLEtNa8CZjTK9i63TnxdSIxIkX84YFIvmCSHYebdxx2/tM50uZWL6GviwQ1zK6EFvge+CbtHvS/V4t+w+l/mbwGgQtrhND1I+6tiaeBdNttm9Av/eQM6ZxaYUdXxbfBd0P/yeK1LtYkMwnqPFZFJkpi5/LQjDWd3cMCkPxZOsu4tIflLTcshoRx6WQ6Bf4UnhOY5qDcuStRC17lNmNYQzE8KTKDh/W/LXhZFecz4UJBIfTHd6M/M2fUAtTcb40J3OhekarQYp1sm+5BJUyBHW91USUSgg1A==
Received: from PH7P220CA0100.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:32d::14)
 by MN0PR12MB6001.namprd12.prod.outlook.com (2603:10b6:208:37d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 17:10:24 +0000
Received: from SJ1PEPF00002326.namprd03.prod.outlook.com
 (2603:10b6:510:32d:cafe::a3) by PH7P220CA0100.outlook.office365.com
 (2603:10b6:510:32d::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.13 via Frontend Transport; Tue,
 17 Nov 2026 17:10:24 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF00002326.mail.protection.outlook.com (10.167.242.89) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Tue, 17 Nov 2026 17:10:24 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 17 Nov
 2026 09:10:07 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Tue, 17 Nov 2026 09:10:06 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Tue, 17 Nov 2026 09:10:02 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V2 rdma-next 05/21] net/mlx5: Add macros for reading log-based caps
Date: Tue, 17 Nov 2026 19:08:58 +0200
Message-ID: <20261117170914.27410-6-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20261117170914.27410-1-yishaih@nvidia.com>
References: <20261117170914.27410-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002326:EE_|MN0PR12MB6001:EE_
X-MS-Office365-Filtering-Correlation-Id: da8898eb-d237-45b6-7604-08df44cdab44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|82310400026|1800799024|376014|22082099003|18002099003|6133799003|261009223027099003|3023799007|11063799006|56012099006|261028144727099003|261102123227099003|261022105027099003|261026140227099003|261026121527099003|261021121427099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	QFNSb3h5d7F2EOA/XFGiEa2qMX3QOmMbPQwngPJAO6TCfn1K7ipRuSUMBE3J7rk3Lh5aq6Bt9WF786QEWOoY6HL/TKk6kNMpG7Yx2kKP4qa2czPWRCNHiqKtitRPpj4GAsqiMnRCHL8K3I+vpOwm4jYYi1dTJEt9ZHmO2JadT27UQpkc+7jGQPm1pUkjluaDUMGyxoozoeA1swI6MtScNgLKqTSqTNzJxW7j3Nh1TTo8Wml/RVYXknDMBn0IhceY5SZDjy0TA99XK/TngZVG4HXuuzOQGRDPG9K0HGFRfpj1EuHRHgmfvdoyXQHz2a0BulwvulEY1bCk26SJNTE4MSvBBRTplW5V/nD+24vUAx4cdeOkQQb15KEut+yEs6uGXeRXs44LLaLZHzY52u2LoiZF0Wn6d947gMvzy+mPh/UWHslVlxs4NOoJy6jsQCWKJaaJRne6z1JG/ZLQEkxVAp/5p0MG+WzCIRt2FIrJJE0fzNQpG7u/yHx21RWMwIkf7sNIwW8CkiHXlUON80pokn6+cIvEv76ybumrtxHgeaA4TCxrzGfOaLVrtSahifjVmgFhFwtb7HDResQ60bsLMMpIlL7b11YBB8mqOG6PLWDBIIuRQXM/RG1NecA4VZQGHpdvCWm2LutAp5aVKHnaHt2v908KWJsPrUhrcbVPkT0YFqhfmbKCcaNRc/XXid8KbBsWpQwJt4lWYNLYq/stBQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(82310400026)(1800799024)(376014)(22082099003)(18002099003)(6133799003)(261009223027099003)(3023799007)(11063799006)(56012099006)(261028144727099003)(261102123227099003)(261022105027099003)(261026140227099003)(261026121527099003)(261021121427099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	SnxE6KnT4IY7MypeodW7t12s03G8YNDI64Xe20ZhKL9QqU/aE/nybyisCq9jbr0IGEe1wRU0j/nOZiZ4zQs7QSh2rcQA9FOm5DMESJrtf8bSpfyk+8oCJltBDmC1F5u11wegaXJm+GEq6qRkqFmemMYJRcew0l57FgH9+wh1udTs6Kbj9+VRI1+au1FkeSrgHTTF5zQBX1MlWX26/qAPo7GlWQxX+F0taLFjhDvFjQPjODmAiH1KQFiGADvIEkeesfqYniTyvVf3zYwvd0K6ENa0Hy1RurGnx7DutwepX5pyswLpUWSnlbzizho8mll1CUN4OgS5Mj6VuxwADZLi9bCZCt07io8+RZ8eWaDRLXD9gQnjjaCGUNgazFoAzhBEXRF0qaOfIBLcz3+AfH6uX3SvwxO0I3dLgD0Qt6PPbGUVJj2XUtOxTO2PdzgPHhdt
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 17:10:24.2015
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: da8898eb-d237-45b6-7604-08df44cdab44
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002326.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6001

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

