Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.67
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794318304;
	b=dg6BXAXqHrJQAVbbegFANF/SNiZEGUbHBdsu+IQRfST3ueihUCA7PKfQmreYRPXje1wS
	 nMgMYZaHPd91qiowIrmt81Jx+VBA5bscXaUhksWld4DZZ4z4fk2+SiXcCox4CQKDci6O9
	 ID83XQK1l/g/yxRWxfkR6IsVTHicADeXo6YBufqM1sub11Yi3ovSU7SUQJ2qzIj+Rmdhp
	 fAH64H9KMGWgoL2lSnA1Q/KlYMEMAJO+8y8LTFZmdQnjZOO3waI1ZoAqNd8lyU9BjFxKR
	 J5KzmDFodUrfZnnteKiTql7LF8w5EcWAayck8ehlxJkjtmocO+9YbLUy+cTrUju+B1w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794318304;
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
	bh=kj613+5gfXHSWvslDWy8ItVjw8jcJqEXxUL6qAEg0+E=;
	b=24RE7UkrD5OayIA2F9yAGxx2W+2T+kfeKHHdfdqIDHzSDsg9wEjTgKq57/qUWkG15nBi
	 KN/IhJi88wdzMaaT7hZszzYab7NL3F6w/VrEwUmo9hoGDS+qLujPl9vE25+m0PRP7fT4x
	 p5ygqnpbntoJNbuWYmXd3ZhagdGcnVCLwiQZHodzHfs+jYQ4+IOJE72jl+kvG7tXnbB8Q
	 8In0++j4KXMQ7WWatv03EoJRGzDNIL25RnfC2rWB1Y9BHJC5WHJv0Gwvqb8KAHXRAV6FU
	 oVZ8lVIL/6Jsef/Q5Yn+rKbayTDx0B2l9FPaTDuWlG1kAG7yCOC2/VTofMPCiQmHPCw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=UJdyXbNV;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.67
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013067.outbound.protection.outlook.com [40.93.196.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0E460A2603;
	Tue, 10 Nov 2026 13:45:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0E0E460A2603
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=UJdyXbNV
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VI8xMABvzAhX/ZW4wpGPmYfuUpbgWDwKiYyFew8Hmk/3TL1U4OYvTrsJBndHSFZhSqFVgUjkUmP1vbNJE9FYC+J6IZneRWcoePOJ7eK2wBPbJ1PMjmjAHlyo+obqFbHPkP3EH9CdfCm2hFC9SV6ICgbXKbt4GfmBkL1eW4rmAFMKaS1KGLg5+2YLh1pU1me1n779iDTvwzXMYxmZNlwEUk3GJ4jdVYWS24gnLcy7RgSVYjrSsCmfpfoYsCQdq+2TflclgT0Y0ZWi8alvXN+8xFatye0UA1oHRoJycYLLua/BZCZy+aIeorFbmH3/JnNVaQW59YCUIuUSuDubPzfPmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kj613+5gfXHSWvslDWy8ItVjw8jcJqEXxUL6qAEg0+E=;
 b=bwqzatOkEgh/4n3C9l4iIYSZlavnzKoSvoClYiSMCgEsfugpnzbpMxGup7ViJWPsYJdMElT0H8IG9HnIB111Gc1nWpA2x0kpON/9bTscHPLC6lzEmJZ2fuRGIpG0lFkwX2KhQWE8xEKjqzWZFHnvNt+srWrIg2mK/Tl6Dgg5FyTQvTo6B/hu6j+yaZbcDYQKrRAU1pvLeLx14c64yk1OrEFdY+iUie0KPg5V5054r/J9XgCfEIKOMWIjtSVXCZfID3t6Ak4vk3IeDfhL7GAT2eY9vxc4VxjGbv/X2J57J7OkMc31az4xffrGBwU9LuBQLnuLfeh2mVZH+izEoYlNHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kj613+5gfXHSWvslDWy8ItVjw8jcJqEXxUL6qAEg0+E=;
 b=UJdyXbNV8f6yCJNgmVRGkJzi26l9Z3e24y5nYVr1y3frwy9L/3YVyWI/50fbu/sknQWd1Q19nPgguEtOippu9cA+j5XGEnfopFyKiP0dFhFbbOWbniyE5Vqh2TEs6N9CSxoUMQErPTQcey7HBvysvo6tZ8++aRFxEG+E3ZTbzeW+Rz4+l6gZey6PiihUn2uIBYsRHAMbglITluKY3zhHrxT8LI9SXe+kt+C39FFOVnVvUwG0uiN00IxVEDz5Z6T2c91FhOwL4urPQu0OwFNBb0UiDZVohLIO1H1IqOIQpOX9AHeHuXuCvDu0vwlxSlpcac+MO+Bh8Lbd8w8GmsIWBw==
Received: from SJ0PR03CA0016.namprd03.prod.outlook.com (2603:10b6:a03:33a::21)
 by CH3PR12MB8755.namprd12.prod.outlook.com (2603:10b6:610:17e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Tue, 10 Nov
 2026 13:44:56 +0000
Received: from SJ5PEPF000001F1.namprd05.prod.outlook.com
 (2603:10b6:a03:33a:cafe::ab) by SJ0PR03CA0016.outlook.office365.com
 (2603:10b6:a03:33a::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.13 via Frontend Transport; Tue,
 10 Nov 2026 13:44:56 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001F1.mail.protection.outlook.com (10.167.242.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 13:44:56 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:44:34 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:44:34 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 10
 Nov 2026 05:44:30 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 rdma-next 10/24] RDMA/mlx5: Remove duplicate mlx5_ib_umr_context struct
Date: Tue, 10 Nov 2026 15:43:06 +0200
Message-ID: <20261110134320.34408-11-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F1:EE_|CH3PR12MB8755:EE_
X-MS-Office365-Filtering-Correlation-Id: 36bd3d91-3fc9-4850-097e-08df3f30ce5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|1800799024|23010399003|376014|22082099003|18002099003|10067099003|261028144727099003|11063799006|261022075727099003|261026121527099003|261009223027099003|261022105027099003|56012099006|261102123227099003|261021123027099003|261021121427099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	amHr1vCJ2pUXRJYQBKYgZL0KGrQl1e8z6AyAAzrIeHYjMqLMSdEkA4UStPSWDfw0GumoVjgpCzT58J76ofPDIdvn2hFtokKi3+gLcdCQ47cTvBIWRiGBaSFqM3qXcpZzXg3MhxNlFyMWXPGCTV+aaPvZKdP2irghdqZztH9FI823t0ntHdMUY9T0AL6qfl0jJbRJ7X9Lzm4z4oIaRpHWUDctDZVHlfxuug2sqNK/c8qFCutZgKW23QhB1QzWkWmmFTpmGVT+46ya/EA/qmvp0m5srwCEWwCV9JURcc8SFHQegRuGNTNbhAo5fx2Ob4ONDddFQ9cZjHIjG7KlkvnmpNoCFojcgYNtq62kA3AJqK3qLpxcn7aZ1TOn+ZvHeB7ufFZ7kxE53A9T2QDBHtjL6Qp6m0SU5GV0QibaXYqX/8hIs6xPiQ0b4mecM8gVRi6+gYNeJp0BueLViIF7Rz+BddIqaUGYJtoqlffzJ9K6e6jTyNnuWoHfofiUlko52IJi8zva2kCZ0tzQJ6cJGnZSy2PDC1b+wyD0ioMR1arWrrizNeHlwxF7MBb/JCyi9ETwixibRKX2B2gznil/Q9jfN1sLFGUjYV2Fo+1FgchFvVqwquIexAA6OZHDsJVNW+n8SbXTfblLw3AV1e/d7zwH+3hMW3iYnZRphZf2PKeJVeD3O1i7Fj1ZYOA5xBkU1vbQgN29Te+Ebbsl5ym8jqWhkQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(1800799024)(23010399003)(376014)(22082099003)(18002099003)(10067099003)(261028144727099003)(11063799006)(261022075727099003)(261026121527099003)(261009223027099003)(261022105027099003)(56012099006)(261102123227099003)(261021123027099003)(261021121427099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	mYFuSgTymT8+ITzT/0wecYSIODhA3A26YuzEdyk5cIougdIzKU56Uujym8uo/arPOaJ/PtEekodCiJSSBq/B2YTnfJSUhu/c7KA6uxaLJS7PRk0Dn+wTtht/RvwID/5hS/nmIC7572jtsiiAEU8/Vsz3uT4SPqt9OsyYYVC1rSwHsxGoaNZCETSrCz7hkE9e1wB0eGHWuWM4vx/n+eksQ6Io+YR64ffUvu9b8c3bB+M/sbfYhI9qxG5AqeADmNemErtjv4D/Fvg2fM5QSAC3Dpddd2A9a774R4Z2V72McflwX8DyZZuIw1pzpRsLrAHx2pdkYtVpDXGeuVsORHVS3+kKs7EMGF5HJZRcp+AkupxHwy+Rl/B0bEFBnSmeQ7GxykxMtk3wh20b06hDBaTGInoHADz0MT1WDJ2tl48ItcCAbQXm0FXN9Is922o6o8P9
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 13:44:56.2807
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 36bd3d91-3fc9-4850-097e-08df3f30ce5d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8755

mlx5_ib_umr_context in mlx5_ib.h and mlx5r_umr_context in umr.h have
identical layouts: an ib_cqe, a status, and a completion.  The done
callback used mlx5_ib_umr_context via container_of, while every other
site in umr.c used mlx5r_umr_context.

Remove the duplicate and use mlx5r_umr_context consistently throughout.
No behaviour change.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 6 ------
 drivers/infiniband/hw/mlx5/umr.c     | 4 ++--
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 0f81b8aa487e..980b41800df5 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -749,12 +749,6 @@ struct mlx5_ib_mw {
 	struct mlx5_ib_mkey	mmkey;
 };
 
-struct mlx5_ib_umr_context {
-	struct ib_cqe		cqe;
-	enum ib_wc_status	status;
-	struct completion	done;
-};
-
 enum {
 	MLX5_UMR_STATE_UNINIT,
 	MLX5_UMR_STATE_ACTIVE,
diff --git a/drivers/infiniband/hw/mlx5/umr.c b/drivers/infiniband/hw/mlx5/umr.c
index 711075e3d9ea..4a3fa79eba3a 100644
--- a/drivers/infiniband/hw/mlx5/umr.c
+++ b/drivers/infiniband/hw/mlx5/umr.c
@@ -339,8 +339,8 @@ static int mlx5r_umr_recover(struct mlx5_ib_dev *dev, u32 mkey,
 
 static void mlx5r_umr_done(struct ib_cq *cq, struct ib_wc *wc)
 {
-	struct mlx5_ib_umr_context *context =
-		container_of(wc->wr_cqe, struct mlx5_ib_umr_context, cqe);
+	struct mlx5r_umr_context *context =
+		container_of(wc->wr_cqe, struct mlx5r_umr_context, cqe);
 
 	context->status = wc->status;
 	complete(&context->done);
-- 
2.18.1

