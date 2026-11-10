Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.10
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794318273;
	b=Y84qw7eLAc1U8COIeQew+nLqyLhThEc2csTFrHfEwTM1MPCRZKQ1+CMANtHbDAfL2T4J
	 DPHj6+KGhZg5OoDvP5ifJlChZw/6Ui52gcp0NT4e4Gs4GAvHuu62aH/KC/mrvlIljzXE0
	 OLitGwgwQDniBx9CN9jzSCQQu+/cNYNPlzA8UTmB3/mZC5/1YFurapFvlXG2230V40Ez9
	 nuOpCDQaR9voYgMyNriBjTlhe72Tefb4CmALiPQzKomkYggaO+V7/nLxGRb7WOAAjZend
	 CWfZ5PKpDLnuTXixaigLyxCZQ3iMUQLx9ZzPQxQisZS1FymmRtYoFFlqoyLEriUf5UA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794318273;
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
	bh=8+qR/z/BGB3qHhsBzEntLH7SlnTfSXirw9EWLfPDLSI=;
	b=dOkEbSFozkQIGRy23bnJwqGJMc1aKXRK3Op9H2A4hkfF2IChdkxEgQBXkZB0I2UKI4fL
	 6MWgJf4/KxMor0pynTiR8ozF4QILfb8TskAEWtqAwLopj/chh8+5UWUTdIUnGnwJvVUjU
	 Bw9x28u259kIjHk6fTGIjdx+e0XxF04w1vBArKmHZk77qvp/bkxjZQJBsqNSAY1GuUBzD
	 oRUtYyQdcXFfU+nqJh2Sc2yb63IIhh/IXJzRVvj2bJuejPMlWaIMojgt+YFlR+dz7nUo5
	 3tWGzOYLYkCnC3d/FKZSDw9YgPK8VHKpZojzxGTmKJ2oCowGsUFHUCWlJQ2u0yyo++w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=agjSjEJc;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.10
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012010.outbound.protection.outlook.com [40.93.195.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B5A60A2607;
	Tue, 10 Nov 2026 13:44:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42B5A60A2607
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=agjSjEJc
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q3Cpb+oRUxa+UAHngYpC2xDBMr5MIxgtxT654NnoVq+mH+8cwVA42C6OZjW4uMTQ8p2Sr6LSFSqMcJRblAUUJC+hi7/+/0ENC5Rm9TwDyn1dfsX/UtGKbh/w+GPhGnub6iNW1lz+3MQlSdDEfJDcsilkFFepV84ET9PQ6lA8DylKTOlnwmujMsrDv1Jv0pbpb6oqPS0XeEBL842d1m7Td77QgLa8GjBvTl7H+Ib2rAfvrtwymBEIVK8fvaSkUfgMXrUa0oqSVBg017c4B8ssazg4cHuw0Jo5xRG88OQalyb8D4oIFHlsv6jfY6YCchvOZd08AmWQE4F4nY8c9aHVLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8+qR/z/BGB3qHhsBzEntLH7SlnTfSXirw9EWLfPDLSI=;
 b=IlPeUTCnIqBv5pxxx5pzIA6YQW/5iwstox0J+ARoKOAAiORHuQlpUzPsVNmailsSelUVV7viVz7eHBdxboFNnODAeSd7Ov915kofFyip8wvI8CSTNqwpkuI9FQZJph5pDjXtM00YCOhOUeGkxUy4oc9gIPVqH0A9UKlYosCCNg3/Y24QHA7wZAvxyL2QX5Q2QBVfRXYlXBuqd2V1OJw9ZQqidwRjozpo0qjPf9nMiUVlt/Yj+loCWCXwZwOLQFM1oQhyZl6QE45clc+NvPPjzeFzTBjCx2F3dUf49XP/SySd0vhaZ516S1NQ3TopGOPCQA37+XCI4J3L9QqoXVTmVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8+qR/z/BGB3qHhsBzEntLH7SlnTfSXirw9EWLfPDLSI=;
 b=agjSjEJc4zRB/65yXs6/auN0/+y2JgJu6T4LDlY5209QGX4OWEuaKB4o2y7xsHQrj0lJvtUxYfXEuF0xW/eUmBqQsXb+oBuv7lUiLT+V6S3vjlO0sgmnWt9+gMxLFvevJ06GPcQ0Oa44CS8Ipr8LYS3Xgd2KmZfa/1Do13VzeGo7jFKAacZIyO4uukK4i4gtWFroKLT9R4fqY9K7A7EHhj8rGdPT9zCdlOZ6XT3kC84E8kf4Gq8jR/OLNcGHkYMoAdSkX3D7SZhcKkRiIliP5E7eKTHRBmlJ0AahZD73wgGxcfjquqyLa2aVnVL73EexykSsn2IJo9LQuChZFtSjHg==
Received: from PH8PR02CA0032.namprd02.prod.outlook.com (2603:10b6:510:2da::11)
 by IA0PPF95ABFC125.namprd12.prod.outlook.com (2603:10b6:20f:fc04::bdb) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Tue, 10 Nov
 2026 13:44:26 +0000
Received: from CY4PEPF000392DD.namprd03.prod.outlook.com
 (2603:10b6:510:2da:cafe::3f) by PH8PR02CA0032.outlook.office365.com
 (2603:10b6:510:2da::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Tue, 10
 Nov 2026 13:44:25 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF000392DD.mail.protection.outlook.com (10.167.247.123) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 13:44:25 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:44:03 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:44:03 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 10
 Nov 2026 05:43:59 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 rdma-next 03/24] net/mlx5: Add capability filtering in adversarial mode
Date: Tue, 10 Nov 2026 15:42:59 +0200
Message-ID: <20261110134320.34408-4-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF000392DD:EE_|IA0PPF95ABFC125:EE_
X-MS-Office365-Filtering-Correlation-Id: b8a37285-c0f7-4fdf-9aac-08df3f30bbcd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|36860700016|82310400026|1800799024|22082099003|18002099003|6133799003|3023799007|10067099003|11063799006|261102123227099003|261026121527099003|261028144727099003|261022105027099003|261009223027099003|261022115727099003|261022075727099003|261021130227099003|261021121427099003|261021135927099003|261021133027099003|261021123027099003|261022113327099003|261026135527099003|56012099006|261026140227099003|261026130827099003|260925021911599003|260925021311599003|260925022911599003;
X-Microsoft-Antispam-Message-Info:
	xxCgVYg8j8JSlMa4xhf28S35sXec7HkXrtrx2hltWKExPpyZ5mqFVvXcG73/WiMvBw6nWDxh/16QuipXBjjuyGrO4SbrprXlovmyGnB8Pgih9dcwQjRoAAmBvIHScaWwwpMpnn1cWWZNPLOB+dLFgh6Fl4INhahvG+qIU0qTYMezLOW7QBixvN+AxgWuHIzraeHoV7vECRip3a27HSWYaHN5WEplvFHpB2on+yxrwrv0HV72thh7U+unyDzmRTOBOD2Md+Yr3QY1MwT42V1prQrM/DJH0MRLN9QjdGRghHLXVm2PAPXZ85CyLpDOnt4VKpARmIW5Qm9Zv0s2P5TbhLj3rtumvRNw6NuDf0G6JrZl11jLtX9cyHDNQ8315bVGimacyxYHjJoclEX+15hBFL/7N3ECegZyNCkJtSfqEbQHvaD+RwXiqY3OpoiBsJKwUXxuNhtVO01vwRhXIgJMKUmRFCQmv8ubj4sQJQqMrEXT002AwkzBlMhNm2J6ZBg0lWmF0Y3IsD+XV3d2m5Za2lJkOb7GWFgxRMd57rk+HDGGuTEB1skh6chq2e4qKOuE0bFsme08jki3xJE16T/Tgz1x9EQ068Q8CFRJ4NhiGM1mqvO5RD7DcXRpsXCU3YCDAHE5NXjJlWqmhjxBLsqaCrN21pXn8sTYyPqGC3+wkP8r40ibgpZofxXQnHttUZMBfQ2jUexcs69bYodx5i/eqw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(23010399003)(36860700016)(82310400026)(1800799024)(22082099003)(18002099003)(6133799003)(3023799007)(10067099003)(11063799006)(261102123227099003)(261026121527099003)(261028144727099003)(261022105027099003)(261009223027099003)(261022115727099003)(261022075727099003)(261021130227099003)(261021121427099003)(261021135927099003)(261021133027099003)(261021123027099003)(261022113327099003)(261026135527099003)(56012099006)(261026140227099003)(261026130827099003)(260925021911599003)(260925021311599003)(260925022911599003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	1G6mIaLv0a+6FwkoFjvxZRDV3ljqQUMmFQVznhRYy1iBfjrGPqaI+IZMI6163dIn3KUuxvRb5dUKbYjcZFqMuYe+vc5q62pQGDbminBjswT7OBK4kXO4MeszLht/UtuqJtAOEcpzT4PxAlO64JWs7/tbO0quxOtas2tIw8W4drKV7hSuT5zkFILJLco1NO6B2cUTDf38zLyE9eiSfSDdn+akNB9jm90v/2qY1nAA1yT6dMLIKilVNp0PwH8/dJU2ifqzLhW2gOLhMbmnCyiqWQ62/Avqxk1AoiL2RjK45bBEN7Q4a4aa8KYgOKHRGnIjOMAIutS4h/NM36euQ/nqPj5TMeNpJ0GPXF9eBDJL9p+GI+v1iM725rjszvETuaYSKlPpL6hZGqI2VhIKXuvFwXsH+OWrQqQ8bIawvAUjIREcMNr4ADD6BvBhQ23CmiDr
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 13:44:25.0589
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b8a37285-c0f7-4fdf-9aac-08df3f30bbcd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF000392DD.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPF95ABFC125

From: Dragos Tatulea <dtatulea@nvidia.com>

When in adversarial mode, trust only a subset of capabilities
and do some additional validations.

Start off by clearing all firmware capabilities and enabling
them one by one. Some numeric capabilities are validated.
Unexpected values will trigger a driver load failure flow.

Where it applies, the filtering is done on both current and max caps.
Allowed capabilities are simply passed through. Clamped and checked
capabilities also apply to max values.

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../ethernet/mellanox/mlx5/core/caps_filter.c | 381 ++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/main.c    |   8 +-
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   2 +
 4 files changed, 388 insertions(+), 5 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/caps_filter.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index a1871259210d..dc8eabee631f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -11,7 +11,7 @@ obj-$(CONFIG_MLX5_CORE) += mlx5_core.o
 #
 # mlx5 core basic
 #
-mlx5_core-y :=	main.o cmd.o debugfs.o fw.o eq.o uar.o pagealloc.o \
+mlx5_core-y :=	main.o caps_filter.o cmd.o debugfs.o fw.o eq.o uar.o pagealloc.o \
 		health.o mcg.o cq.o alloc.o port.o mr.o pd.o \
 		transobj.o vport.o sriov.o fs_cmd.o fs_core.o pci_irq.o \
 		fs_counters.o fs_ft_pool.o rl.o lag/debugfs.o lag/lag.o dev.o events.o wq.o lib/gid.o \
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/caps_filter.c b/drivers/net/ethernet/mellanox/mlx5/core/caps_filter.c
new file mode 100644
index 000000000000..023f996bc95e
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/caps_filter.c
@@ -0,0 +1,381 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2026, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#include "linux/mlx5/device.h"
+#include <linux/mlx5/driver.h>
+#include <linux/mlx5/qp.h>
+#include "mlx5_core.h"
+
+#define MLX5_HCA_CAP_ALLOW(cap, fld) \
+	MLX5_SET(cap, dst, fld, MLX5_GET(cap, src, fld))
+#define MLX5_HCA_CAP_ALLOW64(cap, fld) \
+	MLX5_SET64(cap, dst, fld, MLX5_GET64(cap, src, fld))
+
+/* Allow a numeric capability range restricted to [lo, hi]. */
+#define MLX5_HCA_CAP_CLAMP(cap, fld, lo, hi) \
+	MLX5_SET(cap, dst, fld, mlx5_cap_clamp(dev, #fld, \
+					       MLX5_GET(cap, src, fld), \
+					       (lo), (hi)))
+
+/* Check cap range and return error otherwise. */
+#define MLX5_HCA_CAP_CHECK(cap, fld, lo, hi) \
+	mlx5_cap_check(dev, #fld, MLX5_GET(cap, dst, fld), (lo), (hi), false)
+/* Same but zero is also a valid value. */
+#define MLX5_HCA_CAP_CHECK_Z(cap, fld, lo, hi) \
+	mlx5_cap_check(dev, #fld, MLX5_GET(cap, dst, fld), (lo), (hi), true)
+
+static u32 mlx5_cap_clamp(struct mlx5_core_dev *dev, const char *name,
+			  u32 val, u32 lo, u32 hi)
+{
+	u32 clamped = clamp_t(u32, val, lo, hi);
+
+	if (clamped != val)
+		mlx5_core_warn(dev, "cap filter: FW reported %s=%u, outside [%u, %u], using %u\n",
+			       name, val, lo, hi, clamped);
+
+	return clamped;
+}
+
+static int mlx5_cap_check(struct mlx5_core_dev *dev, const char *name,
+			  u32 val, u32 lo, u32 hi, bool zero)
+{
+	if (val >= lo && val <= hi)
+		return 0;
+
+	if (zero && !val)
+		return 0;
+
+	mlx5_core_err(dev, "cap filter: FW reported %s=%u, outside [%u, %u] %s\n",
+		      name, val, lo, hi,
+		      zero ? "or 0" : "");
+
+	return -EINVAL;
+}
+
+static int mlx5_adversarial_filter_general(struct mlx5_core_dev *dev, void *dst,
+					   void *src)
+{
+	int err;
+
+	memset(dst, 0, MLX5_UN_SZ_BYTES(hca_cap_union));
+
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, page_request_disable);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, vhca_resource_manager);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, hca_cap_2);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, event_on_vhca_state_teardown_request);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, event_on_vhca_state_in_use);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, event_on_vhca_state_active);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, event_on_vhca_state_allocated);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, event_on_vhca_state_invalid);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, vhca_id);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_srq_sz);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_qp_sz);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, event_cap);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_qp);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_srq);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, max_sgl_for_optimized_performance);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_cq_sz);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, relaxed_ordering_write_umr);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, relaxed_ordering_read_umr);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_cq);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, relaxed_ordering_write);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, relaxed_ordering_read_pci_enabled);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_mkey);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, terminate_scatter_list_mkey);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, fast_teardown);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_eq);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, max_indirection);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, fixed_buffer_size);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, force_teardown);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, umr_extended_translation_offset);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_klm_list_size);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, qpc_extension);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_ra_req_dc);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, vnic_env_cq_overrun);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_ra_res_dc);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, release_all_pages);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, roce_accl);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_ra_req_qp);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_ra_res_qp);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, end_pad);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, cc_query_allowed);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, cc_modify_allowed);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, cache_line_128byte);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, rts2rts_qp_counters_set_id);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, vnic_env_int_rq_oob);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, sbcam_reg);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, qcam_reg);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, gid_table_size);
+
+	/* Values outside of [0, 4] range are unexpected. */
+	err = MLX5_HCA_CAP_CHECK(cmd_hca_cap, gid_table_size, 0, 4);
+	if (err)
+		return err;
+
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, out_of_seq_cnt);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, vport_counters);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, retransmission_q_counters);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, debug);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, modify_rq_counter_set_id);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, rq_delay_drop);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, max_qp_cnt);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, pkey_table_size);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, vport_group_manager);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, vnic_env_queue_counters);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, ets);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, nic_flow_table);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, mcam_reg);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, pcam_reg);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, local_ca_ack_delay);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, enhanced_error_q_counters);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, beacon_led);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, port_type);
+	/* 0 is invalid, 8 is for MLX5_MAX_PORTS */
+	MLX5_HCA_CAP_CLAMP(cmd_hca_cap, num_ports, 1, 8);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_msg);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, max_tc);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, dcbx);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, general_notification_event);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, stat_rate_support);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, pci_sync_for_fw_update_event);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, cqe_version);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, umr_modify_entity_size_disabled);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, umr_modify_atomic_disabled);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, umr_indirect_mkey_disabled);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, umr_fence);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, cmdif_checksum);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, sho);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, qos);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, eth_net_offloads);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, roce);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, atomic);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, cq_moderation);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, cq_period_mode_modify);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, cq_period_start_from_cqe);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, apm);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, umr_ptr_rlky);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, qp_packet_based);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, pkv);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, rc);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, uar_4k);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, fl_rc_qp_when_roce_disabled);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_pg_sz);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, bf);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, driver_version);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, mkey_by_name);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_bf_reg_size);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, disciplined_fr_counter);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, qp_error_syndrome);
+	MLX5_HCA_CAP_CLAMP(cmd_hca_cap, num_lag_ports, 0, 1);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, max_wqe_sz_sq);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, icm_mng_function_id_mode);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, tis_tir_td_order);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, max_wqe_sz_rq);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, query_host_net_function_num_max);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, max_qp_mcg);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_mcg);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_transport_domain);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, relaxed_ordering_read);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_pd);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, dp_ordering_ooo_all_ud);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, dp_ordering_ooo_all_uc);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, dp_ordering_ooo_all_xrc);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, dp_ordering_ooo_all_dc);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, dp_ordering_ooo_all_rc);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, pcie_reset_using_hotreset_method);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap,
+			   pci_sync_for_fw_update_with_driver_unload);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, vnic_env_cnt_steering_fail);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, vport_counter_local_loopback);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, q_counter_aggregation);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, q_counter_other_vport);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, nic_receive_steering_discard);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, receive_discard_vport_down);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, transmit_discard_vport_down);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, eq_overrun_count);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, invalid_command_count);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, quota_exceeded_count);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_flow_counter_bulk);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_rq);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_sq);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_tir);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, basic_cyclic_rcv_wqe);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_rqt);
+	MLX5_HCA_CAP_CLAMP(cmd_hca_cap, log_max_rqt_size, 0, 13);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, vnic_env_cnt_bar_uar_access);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, vnic_env_cnt_odp_page_fault);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, roce_rw_supported);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_wq_sz);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, vhca_state);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_vlan_list);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_current_mc_list);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_current_uc_list);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, sq_ts_format);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, rq_ts_format);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, steering_format_version);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, create_qp_start_hint);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, ats);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, cross_vhca_rqt);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_uctx);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, max_num_eqs);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_uar_page_sz);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, max_geneve_tlv_options);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, max_geneve_tlv_option_data_len);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_dci_stream_channels);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_dci_errored_streams);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, crossing_vhca_mkey);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, native_port_num);
+	MLX5_HCA_CAP_CLAMP(cmd_hca_cap, num_vhca_ports, 0, 1);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, sw_owner_id);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, max_num_of_monitor_counters);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, num_ppcnt_monitor_counters);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, num_q_monitor_counters);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, apu);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, uctx_cap);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, num_total_dynamic_vf_msix);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, min_dynamic_vf_msix_table_size);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, data_direct);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, max_dynamic_vf_msix_table_size);
+	MLX5_HCA_CAP_ALLOW64(cmd_hca_cap, vhca_tunnel_commands);
+
+	MLX5_SET(cmd_hca_cap, dst, num_of_uars_per_page, MLX5_UARS_IN_PAGE);
+
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, flow_counter_bulk_alloc);
+
+	err = MLX5_HCA_CAP_CHECK(cmd_hca_cap, log_pg_sz,
+				 MLX5_ADAPTER_PAGE_SHIFT,
+				 MLX5_ADAPTER_PAGE_SHIFT);
+	if (err)
+		return err;
+
+#define LOG_BF_REG_SIZE_MIN ilog2(2 * MLX5_SEND_WQE_BB)
+#define LOG_BF_REG_SIZE_MAX \
+	ilog2((MLX5_ADAPTER_PAGE_SIZE - MLX5_BF_OFFSET) / MLX5_BFREGS_PER_UAR)
+
+	err = MLX5_HCA_CAP_CHECK(cmd_hca_cap, log_bf_reg_size,
+				 LOG_BF_REG_SIZE_MIN,
+				 LOG_BF_REG_SIZE_MAX);
+	if (err)
+		return err;
+
+#undef LOG_BF_REG_SIZE_MAX
+#undef LOG_BF_REG_SIZE_MIN
+
+	return MLX5_HCA_CAP_CHECK(cmd_hca_cap, min_dynamic_vf_msix_table_size, 0,
+				  MLX5_GET(cmd_hca_cap, dst,
+					   max_dynamic_vf_msix_table_size));
+}
+
+static int mlx5_adversarial_filter_general_2(struct mlx5_core_dev *dev, void *dst,
+					     void *src)
+{
+	int err;
+	u32 val;
+
+	memset(dst, 0, MLX5_UN_SZ_BYTES(hca_cap_union));
+
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap_2, dp_ordering_force);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap_2, query_vuid);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap_2, umr_log_entity_size_5);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap_2, max_reformat_insert_size);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap_2, max_reformat_insert_offset);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap_2, max_reformat_remove_size);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap_2, max_reformat_remove_offset);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap_2, sf_eq_usage);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap_2, max_rqt_vhca_id);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap_2,
+			   min_mkey_log_entity_size_fixed_buffer_valid);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap_2, log_min_mkey_entity_size);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap_2,
+			   min_mkey_log_entity_size_fixed_buffer);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap_2,
+			   max_mkey_log_entity_size_fixed_buffer);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap_2, max_mkey_log_entity_size_mtt);
+	MLX5_HCA_CAP_ALLOW(cmd_hca_cap_2, max_num_eqs_24b);
+
+	err = MLX5_HCA_CAP_CHECK_Z(cmd_hca_cap_2, max_mkey_log_entity_size_mtt,
+				   MLX5_ADAPTER_PAGE_SHIFT, BITS_PER_LONG - 1);
+	if (err)
+		return err;
+
+	err = MLX5_HCA_CAP_CHECK_Z(cmd_hca_cap_2,
+				   max_mkey_log_entity_size_fixed_buffer,
+				   MLX5_ADAPTER_PAGE_SHIFT, BITS_PER_LONG - 1);
+	if (err)
+		return err;
+
+	val = MLX5_GET(cmd_hca_cap_2, dst, max_mkey_log_entity_size_mtt) ?: 31;
+	err = MLX5_HCA_CAP_CHECK(cmd_hca_cap_2, log_min_mkey_entity_size, 0,
+				 min_t(u32, val, PAGE_SHIFT));
+	if (err)
+		return err;
+
+	/* The fixed buffer min is don't-care when its valid bit is clear. */
+	if (!MLX5_GET(cmd_hca_cap_2, dst,
+		      min_mkey_log_entity_size_fixed_buffer_valid))
+		return 0;
+
+	val = MLX5_GET(cmd_hca_cap_2, dst,
+		       max_mkey_log_entity_size_fixed_buffer) ?: 31;
+	return MLX5_HCA_CAP_CHECK(cmd_hca_cap_2,
+				  min_mkey_log_entity_size_fixed_buffer, 0, val);
+}
+
+static int mlx5_adversarial_filter_per_protocol(struct mlx5_core_dev *dev,
+						 void *dst, void *src)
+{
+	memset(dst, 0, MLX5_UN_SZ_BYTES(hca_cap_union));
+
+	MLX5_HCA_CAP_ALLOW(per_protocol_networking_offload_caps, csum_cap);
+	MLX5_HCA_CAP_ALLOW(per_protocol_networking_offload_caps, vlan_cap);
+	MLX5_HCA_CAP_ALLOW(per_protocol_networking_offload_caps,
+			   self_lb_en_modifiable);
+	MLX5_HCA_CAP_ALLOW(per_protocol_networking_offload_caps, max_lso_cap);
+	MLX5_HCA_CAP_ALLOW(per_protocol_networking_offload_caps,
+			   wqe_inline_mode);
+	MLX5_HCA_CAP_ALLOW(per_protocol_networking_offload_caps,
+			   rss_ind_tbl_cap);
+	MLX5_HCA_CAP_ALLOW(per_protocol_networking_offload_caps,
+			   cqe_checksum_full);
+	MLX5_HCA_CAP_ALLOW(per_protocol_networking_offload_caps,
+			   max_vxlan_udp_ports);
+
+	return 0;
+}
+
+#undef MLX5_HCA_CAP_ALLOW
+#undef MLX5_HCA_CAP_ALLOW64
+#undef MLX5_HCA_CAP_CLAMP
+#undef MLX5_HCA_CAP_CHECK
+#undef MLX5_HCA_CAP_CHECK_Z
+
+int mlx5_store_caps(struct mlx5_core_dev *dev, enum mlx5_cap_type cap_type,
+		    void *dst, void *src)
+{
+	if (!mlx5_is_adversarial()) {
+		memcpy(dst, src, MLX5_UN_SZ_BYTES(hca_cap_union));
+		return 0;
+	}
+
+	switch (cap_type) {
+	case MLX5_CAP_GENERAL:
+		return mlx5_adversarial_filter_general(dev, dst, src);
+	case MLX5_CAP_GENERAL_2:
+		return mlx5_adversarial_filter_general_2(dev, dst, src);
+	case MLX5_CAP_ETHERNET_OFFLOADS:
+		return mlx5_adversarial_filter_per_protocol(dev, dst, src);
+
+	case MLX5_CAP_ATOMIC:
+	case MLX5_CAP_ROCE:
+	case MLX5_CAP_FLOW_TABLE:
+	case MLX5_CAP_DEV_EVENT:
+		memcpy(dst, src, MLX5_UN_SZ_BYTES(hca_cap_union));
+		break;
+
+	default:
+		memset(dst, 0, MLX5_UN_SZ_BYTES(hca_cap_union));
+		break;
+	}
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index f9e10464a71b..e76a4486b5a3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -325,12 +325,12 @@ int mlx5_core_get_caps_mode(struct mlx5_core_dev *dev, enum mlx5_cap_type cap_ty
 
 	switch (cap_mode) {
 	case HCA_CAP_OPMOD_GET_MAX:
-		memcpy(dev->caps.hca[cap_type]->max, hca_caps,
-		       MLX5_UN_SZ_BYTES(hca_cap_union));
+		err = mlx5_store_caps(dev, cap_type,
+				      dev->caps.hca[cap_type]->max, hca_caps);
 		break;
 	case HCA_CAP_OPMOD_GET_CUR:
-		memcpy(dev->caps.hca[cap_type]->cur, hca_caps,
-		       MLX5_UN_SZ_BYTES(hca_cap_union));
+		err = mlx5_store_caps(dev, cap_type,
+				      dev->caps.hca[cap_type]->cur, hca_caps);
 		break;
 	default:
 		mlx5_core_warn(dev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index d84d0424d04e..0084bed669f6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -215,6 +215,8 @@ static inline int mlx5_flexible_inlen(struct mlx5_core_dev *dev, size_t fixed,
 	mlx5_flexible_inlen(dev, fixed, item_size, num_items, __func__, __LINE__)
 
 int mlx5_core_get_caps(struct mlx5_core_dev *dev, enum mlx5_cap_type cap_type);
+int mlx5_store_caps(struct mlx5_core_dev *dev, enum mlx5_cap_type cap_type,
+		    void *dst, void *src);
 int mlx5_core_get_caps_mode(struct mlx5_core_dev *dev, enum mlx5_cap_type cap_type,
 			    enum mlx5_cap_mode cap_mode);
 int mlx5_query_hca_caps(struct mlx5_core_dev *dev);
-- 
2.18.1

