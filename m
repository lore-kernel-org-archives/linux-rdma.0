Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794318399;
	b=sViinLewr4ext7uqkn55b3OQaSxprpTMeRAN+gmwcggSWptnyfMAv6xBz7d2Jw5VkWkQ
	 MXDD0qIp0Aq/KBAOP0QSAHaTN8sUTyy5ZmPqLsS61jlxKxJP47Hwk+zruHiTXYvrETUk/
	 6v2qgxAnqk8sUQLv98/FuL4FiG4YQRJGTx7BaVaogSjW/7QBocPLIOWehsarR2QTkcjXc
	 3aKxbZBPcDfyd+g8qq8sDFkdzSvC7EewQU0v1TOakKa3WEYgDTEtw+pXjAEIuEfU/iOh8
	 t2R1DJ7pfo8EyDmqsiuI74nZAoZchQzKoT2dpp+ZteGNwlnpuGLpSLPCzQZYy13enyg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794318399;
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
	b=F0pd64vD/H1XWug/NETlEEK2pW6Q8Qy3dargzirO39EWg4uhx0ZiqYh3hI6TMoU5JRXY
	 Ycek/vRJXZiapBKYXXPpL9U07p2DeJppWg/bvvEUpMMlqWP7P77O2CqRByyXKaOUNkR9w
	 RhVxhV783NWFvu6BZpKqkEMFfe9fzh2yFwvP3ChSf7p63GITpqZ9UKmvjoCaAxrLZED+C
	 hGPiEmavSptVc4JU7cpHmVVmIaL8NfqrS99dF/jTzvF8CsZ7jQnT7HqWaHpBHXM2lX8an
	 SJuiVF8apVspuiHpbbE2j51RJptdAv3piIJwjGQE7moCc1wGzksVCI+LNuXNqde1tvQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=HlkNRugC;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.42
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011042.outbound.protection.outlook.com [40.93.194.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE60606A31C;
	Tue, 10 Nov 2026 13:46:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2DE60606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=HlkNRugC
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JRnc2Hf43b2ElTHxjjQMUjLTwA1nUexRrhj4yXxXR6PISxaaZ3xcdf05JW2WKXTmK3O6WV61+piCZ407K729SYeLZsk3Hf2Ay/afEJ4h1ID23kCcw7FdNsahHj7rQdrg/uXn1iKDjXN+P7eH7DyxPBOGvIMRJ9mcxbQJZporuD46H7mcVic+MiJ5hZbutxLqX+cQxzObs0ppzgbAaTlP7DpVAYNiz9Wrp9Y7913/NuKcP3eHXbGJR2pms1+2y4o1PVNWCB0sfGey4hyk2xzEayf1rZvP48GOL7JxCZ/KLm+XoUJaFWZqpOuTBUEzC2jziDRvDxzclWeQ9At+BihByQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UVdlhV6REm1e00s8GzoJMmtK6VFxIIRWTEvRLovhjzI=;
 b=XV01Qu8fFYK1Z6DKil1kiwJb8X9t5pP6NiAN5ob/OipeBQXRycaYNwNdlDp8lF8F9xVO+lDwp2LflcH3FtLwm/3Hc7lXsTyYI5RONEnS4cCJCYtON8Ie+t34jC/v+qXEWNuP6PuCNKEip9kMtWtkZi/aJzq/xcYrsutammz5M0qvId9zKH34KGTx4ZQssnbgY1JZCBkp27ky6I5LxOPCkHKChsyMdn6WUiCtEfmNAcLv7/PiVhNvbu1TjtO6urOqNraPapgj6GZ/RBnu+YT8DLLbftZNqDQpuOLU1xw9h8S4U+jDD3Yo3Elx0DgbaQSkDs6a0WrPG3kXGBSShP1Ilg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UVdlhV6REm1e00s8GzoJMmtK6VFxIIRWTEvRLovhjzI=;
 b=HlkNRugC55KlqHC/DVRy88s+7dXvg2Vyh+rgy440jO/KCru6Kx8v/UsL2+NCrzDEChdPodXaSf+c437EH39yrozApV+Yb9FYTVIEv1GLZTFaG0Ac0Uw1uW5vhkNfJL4UO68t3mVy3IPU59dXWnym54w23yuW/6uZX+yyEj9FmvjWb+nOq6/pP9gZcyYu/Ls+aapbG6l2R//b64GokPl9ACwOXMtXqj02b7f2YsaBJ/6KfG3zt0uSqckqajLa3i8yLae8iBJj5OwgGD2RvTJrzkD4T8gp2fTIHYrUx23ZsBrLyEvXgd1+5aA0yGSCJYRnz0mjPIzOkwylgj6QtQCXlg==
Received: from PH8PR15CA0016.namprd15.prod.outlook.com (2603:10b6:510:2d2::26)
 by BL3PR12MB6428.namprd12.prod.outlook.com (2603:10b6:208:3b7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Tue, 10 Nov
 2026 13:44:32 +0000
Received: from CY4PEPF000392DC.namprd03.prod.outlook.com
 (2603:10b6:510:2d2:cafe::1e) by PH8PR15CA0016.outlook.office365.com
 (2603:10b6:510:2d2::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Tue, 10
 Nov 2026 13:44:31 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF000392DC.mail.protection.outlook.com (10.167.247.122) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 13:44:31 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:44:12 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:44:12 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 10
 Nov 2026 05:44:08 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 rdma-next 05/24] net/mlx5: Add macros for reading log-based caps
Date: Tue, 10 Nov 2026 15:43:01 +0200
Message-ID: <20261110134320.34408-6-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20261110134320.34408-1-yishaih@nvidia.com>
References: <20261110134320.34408-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF000392DC:EE_|BL3PR12MB6428:EE_
X-MS-Office365-Filtering-Correlation-Id: b6224e0c-48cb-4d96-efd0-08df3f30bfb6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|23010399003|376014|18002099003|22082099003|6133799003|10067099003|3023799007|11063799006|56012099006|261028144727099003|261102123227099003|261022105027099003|261021121427099003|261026140227099003|261009223027099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	aFaWUvl1T5G1aar7G0tX8aZCm07TzQA2Bi9tst/7Rv4DsHyu/8AVvTrQt0c/7gvx2/hOrc2ZITZ4T12JhPS5Z7xy5JW2obELzyDWHQX1KkHGCZcxi97KAIPpbuhJr8020DwpVthvzGsve3a+PtaahNQIBfKxKTKzahfAKg51YlFlp405AIV+YlFobHJHpO2RkiheqNjxet3JfJSsv5kuTLx+JMGQRdL8t8UZkzFXDRWtF4iChVXqhRSjANiwi+Diw3T068KVj9MeHsp3Xune7rcEG9VfMcefzV/9Ox9L0aUUTtsi6rI5YfzmTJdBSBXoNwcFrKTxGTloqQh0Y0Ms5bE0A3cqQFY4RgvSJgEuT5W3cYL3oURGnG17GoRIVzqwtwAFcB5453VZcOCQs3p6q/EvlCB7IzvIbHX5q9mC39qn5xwNKU74DIwVaF2ElP6EgPdEpZKDqtGYsXrHhHDYuHljMnLMySxTqfCl34dvI2R81yJnU2m5yfoeIqxekhCho4w6J5dJ4aTKrx1eGi+iBjTtKEA9XrqeEDkHxYs0XeMuihIZ9GZjD+Gj5Kt3tvMDq+XY3vt2qsUzTvFApqDVDOqB68aHiO9xDmXwOScZkAbDJEwnDhL5JcNN7rXxefS+2T1Qad8LMuB8e8ovaMNsM8R3l0hFw/wjKALdP96B2zjaZrRzOCUbGWQAHJOpETG2PfJV64PxbLsgw+av2g7xvQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(23010399003)(376014)(18002099003)(22082099003)(6133799003)(10067099003)(3023799007)(11063799006)(56012099006)(261028144727099003)(261102123227099003)(261022105027099003)(261021121427099003)(261026140227099003)(261009223027099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ns0fxA/lCm6r0jG6VPG5yCTqLDshwkdVpJyn1qzh1Ipj2SeEXJdJu2WtZfb294md3xs8oPS/pBztM4voLdaN8rQFndbGZxG3Qah67CDtx4WgAT2B8KOkG1ucZjahi/MZqhgUOa7mLl5lpJ3oR/yLIsl94KS+Eochr9BjJkXr8zR6idTvowDZqwe9WocbkITN45Ne/5pJfBP+fqK/AuCVqbqA05twk+reuRz+QMoE7V8KbnDqI0VF5U3e7OdOEX0jvGoSfiBT3JvYU9xd2LQnVFxsBa910QjwIU0j39UEPTxhGHFX3iTlDrqJ2MD75OqTMjlv3c5cA0WuNv9k3CuOzR0atRkf0b9ZlnVtjPsmpA4Mc3HY+YpAIiRS4T3S67KYjq1qCXo6N+QK+lm0IGRYP9trgBfzpmglgxC5l1Vhw9/QgmhGBSvbiie5ZB4yTtSw
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 13:44:31.6296
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b6224e0c-48cb-4d96-efd0-08df3f30bfb6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF000392DC.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6428

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

