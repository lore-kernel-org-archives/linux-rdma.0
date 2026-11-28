Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.14
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795870910;
	b=C36oTnEnN9OkWBgv295hEcI3gQsS2YiHf3sd9sObmPrnIxa1nS1sWYEgFleCEkIDRscS
	 lixdjwdGiRQR2AEcwrAtaZgpy2/lelhTclWf2H5hcIHlqevfQNi/BoHMFb26wWUX4Eozg
	 JDYS25hI2vRfJKZ7Cq2FjCJ9XO1QRJyLDqhX0scVj53NbRh0nLQcnWNnWuqcyMCWakSfK
	 /FbW1NZCSVdiKwDHuhnt89mwXWg21z3ICqUI4X491vp+qTbzT1eOYGQhuKyYyqI706ygz
	 IjC0DJPMmw014w2dlqpTNSty/mKb4ofxVe26sf0uxnOr6+NL4a8BtY93kfjKlp6ZA8w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795870910;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-ID:References:In-Reply-To:To:CC:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-NV-OnPremToCloud:
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
	bh=Ac7Fev54KwcWcNuf+b/hDNHETvI8XqzdSerYC4x7ylk=;
	b=MLwSUm31JsxHO/7lOXglL7+PrQMgAzooAKxzRNaz8BLk84OWlR2w8yimdCZf9324byjG
	 2T0uXLtInciD1n1xLtutQIgSCpaKMXAF5hzkERIYm/WYqoeiqtXA6KzKisGuCrEKuPsOt
	 XGruUl/o75I6iaVvQtL7zYaZkrIav1q2tO9LLqpwHYzgXl6BxXzakTfNfnE+yP2yNX7Lu
	 JSwGfUDBPgZr0XqG1iwl0aBKMEdtdcK0+pfSzwtSWYT3Q4YqAxmrrpyWq/88BSSfO9ZQ4
	 0gl0OOPFPbCcXDQQnSZcBbSqrrDo3P0dOXl6Lz01UsrcMav/fLH9R78DUXWdQnGtJzg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="rrII/B+Z";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.14
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010014.outbound.protection.outlook.com [52.101.46.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0AA6606A32C;
	Sat, 28 Nov 2026 13:01:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F0AA6606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=rrII/B+Z
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mcK6Kg6CD5RqVXqifDGhWkVe2GoMNGfyoy/7V+KTsnIa5CYRPBKrQcOz2FqmevyT3G0Oe3CLOySoswiTmKE1/JknwJA5j+9oRc4s71U5q8G/5Cv0XtnlR2CtGqHGDT+fqWmsDsqb+xERZ3BYaKtBmFFnXjmmRC/c/BkEI/NyfyCOjTTfQRX2rlvBkAa+3Lns3VzG+NMcnhM1oo6WGZn6I47khCinvHT2+kzgEoIRYJvCylQ61st9GB/kTk8CfjJubcn8q7b+Q07dOedPSn4D3txuGAh18ctVm+tImK7gOjNsM3qbYJjual5o8FsJEazLMB6JGyWvDFrpqEg7oz7uVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ac7Fev54KwcWcNuf+b/hDNHETvI8XqzdSerYC4x7ylk=;
 b=wLwQRLcqCZnc7aCw5mXArkGJu4/ZyHjt0hJcO0pO84CCxHQ4a3wH4wmj6fxGaBeRCa54B+CCm4GZ2sF9x9N8EvxdWadWlbpHKtknDtnBiSMBPi4IageNNnMRK+UouCA3ZS1BY0ufM7hZ3jCGNGJ9246YTeTYuC2qbxEUUNeIyFdy+03UpLaKZwwRu6MpDr6ac49rAGG9W3agMoVQyu3c5ysrdNFjhRYOdjF1lOyyHygsFOIWz2Kw2Re6xTikPta5nSwzJFyTDafC8dEkkI9aDRDIyqjSG/NUKKUy0umoRai3DVYbO17AZ3J60rjWDTJ0D9TnSggUM2zplhkmcKguuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ac7Fev54KwcWcNuf+b/hDNHETvI8XqzdSerYC4x7ylk=;
 b=rrII/B+Zdz0PZc1JINTB9OXGXD4i4BFEQoHM0oPWTFDICY9Z/ioOAUle+nm+RQvbCFGVPNbQy7a4XNiHMlFBRJEDvoRHAaVtvIQsxzTsGmKQOlhzkURPxr2U+r/enPXVmnI1yoz+NjVJIqLWniz9A47OdD344NRUx+rKzfqPSihyR2fQ8WmYDwsxRRcluMmN5AIz0fuqho7uI2FlC8xfkp5LJbd4lnAlT94CDK1Ef9q8l0NqeAyskAz8OIUp0AzwMDec0jOm4NY0zZj2FJqfM0JtFVUD+UQKlPLan6mHPZyLmaYK7tOfLl/QgkJoLbU7JlLs3kWjJPvVbnT2s+38XA==
Received: from BN9PR03CA0411.namprd03.prod.outlook.com (2603:10b6:408:111::26)
 by SA1PR12MB7197.namprd12.prod.outlook.com (2603:10b6:806:2bd::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Sat, 28 Nov
 2026 13:01:43 +0000
Received: from BN5PEPF0004698C.namprd02.prod.outlook.com
 (2603:10b6:408:111:cafe::7a) by BN9PR03CA0411.outlook.office365.com
 (2603:10b6:408:111::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.11 via Frontend Transport; Sat,
 28 Nov 2026 13:01:43 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN5PEPF0004698C.mail.protection.outlook.com (10.167.245.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.688.5 via Frontend Transport; Sat, 28 Nov 2026 13:01:43 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Sat, 28 Nov
 2026 05:01:36 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Sat, 28 Nov 2026 05:01:35 -0800
Received: from [192.168.122.1] (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Sat, 28 Nov 2026 05:01:33 -0800
From: Edward Srouji <edwards@nvidia.com>
Date: Sat, 28 Nov 2026 15:01:19 +0200
Subject: [PATCH rdma-next v2 06/11] RDMA/mlx5: Select the AH core device
 through their PD
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261128-mlx5-sd-prep-v2-6-751878123711@nvidia.com>
References: <20261128-mlx5-sd-prep-v2-0-751878123711@nvidia.com>
In-Reply-To: <20261128-mlx5-sd-prep-v2-0-751878123711@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Edward
 Srouji" <edwards@nvidia.com>, Akiva Goldberger <agoldberger@nvidia.com>,
	Michael Gur <michaelgur@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795870878; l=7405;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=nqg69GX+ZwGLr1idGWscDQsOB7ARQtpvui+wCzJc+PI=;
 b=OZf2NfdFF6b76HTGIC4sLNqXtTIYBEO63fp+NPsV8XY75+HzeqJXDUnf/Fpz2ZEHCtyjFg85i
 93jRq6XFBDQBzdAkR0wbZaXSA3cj/xomQMNG3BE01CxfTjiPWNvHPIT
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN5PEPF0004698C:EE_|SA1PR12MB7197:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a6d533e-bcf4-43a5-4c74-08df4d4fc07e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|82310400026|36860700016|10067099003|261009223027099003|261028144727099003|261026135527099003|261022113327099003|11063799006|56012099006|260925021911599003|260925022911599003|261022115727099003|260925021311599003|261102123227099003|261021121427099003|261021123027099003|261022105027099003|261021133027099003|261021135927099003|261026130827099003|261022075727099003|261026121527099003|261026140227099003|261021130227099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	hm1Dj9FHQHUo/N+Xskq4I5PdrhwvZ65Y8RqDPTOfR/YDnEYS3vCX9fMXMEPH8QzWghepnwEPeWHgfpQlXKa2pv7ZybwC3HCp7vYZgfHdFaErDvnAtk5Op7wsWwW7oBQob+MzwfVkzs39GXerfDNeSodJBRKAXNwXX9iMibxc6l+iTd8FeQ0b38wIOYwP3ZjMyYTWa2+CA+gd2aWj369X9Pzfn8cY7m2g49f5fMMghhoLP9cfpYkjfziTD+7IynfO9CZToITkT0oXecLUlXbcSUeEcekdQ3Ooj7k5ozIAihxJKexcsiDOPgUtka3lBSboTZ3EoJCiKKgBJwGeYdZbUtvIvgD4Xv7Zp4kZ94FCSenc2+PI/W9R8bLqluhIT6Op61LfztcyfUA/DwraShmwSnADLw8R2qiodEbPc+4bIfhHptDWKHileCBG7dy4hI+lvyu84yX6LMgs1Z8Wgd+mem/jR1OO8BXIrpCwPDkoWZYxlOPSScKsA348RPwTT0znpag9Dvrt7PeUazVA7aOzllJiy95dzYCcYa71EvrRN5q84rFmdu+7xeQSGfqEztUphyg/rTJgMB1ShS6W+naWtXUFhTsv+yKNj6Sdy/DOYdEiaYaqf673JE1oUekERwAQJ2cUneUH8doj/g0bGmqFposlDBICN26F+dJW05a1Pfj2SK472hNLSgdQ2/0Vke32TW25230gYwWzle9nSDyGCA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(82310400026)(36860700016)(10067099003)(261009223027099003)(261028144727099003)(261026135527099003)(261022113327099003)(11063799006)(56012099006)(260925021911599003)(260925022911599003)(261022115727099003)(260925021311599003)(261102123227099003)(261021121427099003)(261021123027099003)(261022105027099003)(261021133027099003)(261021135927099003)(261026130827099003)(261022075727099003)(261026121527099003)(261026140227099003)(261021130227099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	V8znXYjY23KMx9hI4FEoyWFuDL5dvAYr9RtJy592b2QzrU7Cvjv3zQaTk6RUDea8dJ2F2opbGo2LDKtPp+QQiEp5TLsKjGzCkRQBXpoSmszlqu0l+nxNZ0qf4rMdlZnFV/3jFvHb4Qgy6cfHwUonI+IrCpleBI3u/WCbYN+kHmFC+Yrj2ckATTOkmQXosZKKRdaAwCO68+E13ULJNigrPec9q3pKQeGMHa97oz3YSsKIKXApx02L3a4zv2iDH8X5CsJM7JijIqpvh7Dggsx8OYS2Nu/GYPevm3vh0+PWgEXVJsfK/ivyJSj/5L+aIV//3hz0Os7510eabZSdLhGReIrPKM0E/eQSnEq7OvEUFC7WEHGuuod3Fubvlnm8ZjVNJQkk1KP4VwFw62EC7MgkM0mplbr3PqwarfProeO+EXNcArEx0TmdEHKwpJoSwtUU
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2026 13:01:43.5338
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a6d533e-bcf4-43a5-4c74-08df4d4fc07e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN5PEPF0004698C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7197

From: Akiva Goldberger <agoldberger@nvidia.com>

An AH retains its PD through ib_ah->pd. Use this PD to access the core
device instead of accessing it through dev->mdev.

No functional change.

Signed-off-by: Akiva Goldberger <agoldberger@nvidia.com>
Reviewed-by: Michael Gur <michaelgur@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/hw/mlx5/ah.c      | 20 ++++++++++----------
 drivers/infiniband/hw/mlx5/main.c    |  4 ++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  2 +-
 drivers/infiniband/hw/mlx5/qp.c      |  7 ++++---
 drivers/infiniband/hw/mlx5/qp.h      |  2 +-
 5 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/ah.c b/drivers/infiniband/hw/mlx5/ah.c
index 643d0ce3452696352f7edac5bbf83012b8689033..758c41312c16f4a46d683539ffdc0a857c40ad48 100644
--- a/drivers/infiniband/hw/mlx5/ah.c
+++ b/drivers/infiniband/hw/mlx5/ah.c
@@ -32,8 +32,8 @@
 
 #include "mlx5_ib.h"
 
-static __be16 mlx5_ah_get_udp_sport(const struct mlx5_ib_dev *dev,
-				  const struct rdma_ah_attr *ah_attr)
+static __be16 mlx5_ah_get_udp_sport(struct mlx5_core_dev *mdev,
+				    const struct rdma_ah_attr *ah_attr)
 {
 	enum ib_gid_type gid_type = ah_attr->grh.sgid_attr->gid_type;
 	__be16 sport;
@@ -44,15 +44,16 @@ static __be16 mlx5_ah_get_udp_sport(const struct mlx5_ib_dev *dev,
 		sport = cpu_to_be16(
 			rdma_flow_label_to_udp_sport(ah_attr->grh.flow_label));
 	else
-		sport = mlx5_get_roce_udp_sport_min(dev,
+		sport = mlx5_get_roce_udp_sport_min(mdev,
 						    ah_attr->grh.sgid_attr);
 
 	return sport;
 }
 
-static int create_ib_ah(struct mlx5_ib_dev *dev, struct mlx5_ib_ah *ah,
-			 struct rdma_ah_init_attr *init_attr)
+static int create_ib_ah(struct mlx5_ib_ah *ah,
+			struct rdma_ah_init_attr *init_attr)
 {
+	struct mlx5_core_dev *mdev = pd_to_mdev(ah->ibah.pd);
 	struct rdma_ah_attr *ah_attr = init_attr->ah_attr;
 	enum ib_gid_type gid_type;
 	int rate_val;
@@ -68,7 +69,7 @@ static int create_ib_ah(struct mlx5_ib_dev *dev, struct mlx5_ib_ah *ah,
 		ah->av.tclass = grh->traffic_class;
 	}
 
-	rate_val = mlx5r_ib_rate(dev, rdma_ah_get_static_rate(ah_attr));
+	rate_val = mlx5r_ib_rate(mdev, rdma_ah_get_static_rate(ah_attr));
 	if (rate_val < 0)
 		return rate_val;
 	ah->av.stat_rate_sl = rate_val << 4;
@@ -76,13 +77,13 @@ static int create_ib_ah(struct mlx5_ib_dev *dev, struct mlx5_ib_ah *ah,
 	if (ah_attr->type == RDMA_AH_ATTR_TYPE_ROCE) {
 		if (init_attr->xmit_slave)
 			ah->xmit_port =
-				mlx5_lag_get_slave_port(dev->mdev,
+				mlx5_lag_get_slave_port(mdev,
 							init_attr->xmit_slave);
 		gid_type = ah_attr->grh.sgid_attr->gid_type;
 
 		memcpy(ah->av.rmac, ah_attr->roce.dmac,
 		       sizeof(ah_attr->roce.dmac));
-		ah->av.udp_sport = mlx5_ah_get_udp_sport(dev, ah_attr);
+		ah->av.udp_sport = mlx5_ah_get_udp_sport(mdev, ah_attr);
 		ah->av.stat_rate_sl |= (rdma_ah_get_sl(ah_attr) & 0x7) << 1;
 		if (gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP)
 #define MLX5_ECN_ENABLED BIT(1)
@@ -102,7 +103,6 @@ int mlx5_ib_create_ah(struct ib_ah *ibah, struct rdma_ah_init_attr *init_attr,
 {
 	struct rdma_ah_attr *ah_attr = init_attr->ah_attr;
 	struct mlx5_ib_ah *ah = to_mah(ibah);
-	struct mlx5_ib_dev *dev = to_dev(ibah->device);
 	enum rdma_ah_attr_type ah_type = ah_attr->type;
 
 	if ((ah_type == RDMA_AH_ATTR_TYPE_ROCE) &&
@@ -126,7 +126,7 @@ int mlx5_ib_create_ah(struct ib_ah *ibah, struct rdma_ah_init_attr *init_attr,
 			return err;
 	}
 
-	return create_ib_ah(dev, ah, init_attr);
+	return create_ib_ah(ah, init_attr);
 }
 
 int mlx5_ib_query_ah(struct ib_ah *ibah, struct rdma_ah_attr *ah_attr)
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 5bba04ac16d5b749ddb50ae7ec7823a7a0115fc9..109b305559b37ee26bf9e46999e8b7bb60727828 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -705,13 +705,13 @@ static int mlx5_ib_del_gid(const struct ib_gid_attr *attr,
 	return 0;
 }
 
-__be16 mlx5_get_roce_udp_sport_min(const struct mlx5_ib_dev *dev,
+__be16 mlx5_get_roce_udp_sport_min(const struct mlx5_core_dev *mdev,
 				   const struct ib_gid_attr *attr)
 {
 	if (attr->gid_type != IB_GID_TYPE_ROCE_UDP_ENCAP)
 		return 0;
 
-	return cpu_to_be16(MLX5_CAP_ROCE(dev->mdev, r_roce_min_src_udp_port));
+	return cpu_to_be16(MLX5_CAP_ROCE(mdev, r_roce_min_src_udp_port));
 }
 
 static int mlx5_use_mad_ifc(struct mlx5_ib_dev *dev)
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 1cf856e314d394fec694a6e4273592e5c85cd73e..36340c4aaee84b56df42b136cfbd201025cd0f38 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1549,7 +1549,7 @@ int mlx5_ib_get_vf_guid(struct ib_device *device, int vf, u32 port,
 int mlx5_ib_set_vf_guid(struct ib_device *device, int vf, u32 port,
 			u64 guid, int type);
 
-__be16 mlx5_get_roce_udp_sport_min(const struct mlx5_ib_dev *dev,
+__be16 mlx5_get_roce_udp_sport_min(const struct mlx5_core_dev *mdev,
 				   const struct ib_gid_attr *attr);
 
 void mlx5_ib_cleanup_cong_debugfs(struct mlx5_ib_dev *dev, u32 port_num);
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 416d3abfaeee0773bee5c1cf9245c373c3568449..c6ad1621ce67a3e2f5859193738050ed1edebab6 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -3493,7 +3493,7 @@ static int ib_to_mlx5_rate_map(u8 rate)
 	return 0;
 }
 
-int mlx5r_ib_rate(struct mlx5_ib_dev *dev, u8 rate)
+int mlx5r_ib_rate(struct mlx5_core_dev *mdev, u8 rate)
 {
 	u32 stat_rate_support;
 
@@ -3504,7 +3504,7 @@ int mlx5r_ib_rate(struct mlx5_ib_dev *dev, u8 rate)
 	if (rate < IB_RATE_2_5_GBPS || rate > IB_RATE_1600_GBPS)
 		return -EINVAL;
 
-	stat_rate_support = MLX5_CAP_GEN(dev->mdev, stat_rate_support);
+	stat_rate_support = MLX5_CAP_GEN(mdev, stat_rate_support);
 	while (rate != IB_RATE_PORT_CURRENT &&
 	       !(1 << ib_to_mlx5_rate_map(rate) & stat_rate_support))
 		--rate;
@@ -3583,6 +3583,7 @@ static int mlx5_set_path(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 			 int attr_mask, u32 path_flags,
 			 const struct ib_qp_attr *attr, bool alt)
 {
+	struct mlx5_core_dev *mdev = qp_to_mdev(qp);
 	const struct ib_global_route *grh = rdma_ah_read_grh(ah);
 	int err;
 	enum ib_gid_type gid_type;
@@ -3643,7 +3644,7 @@ static int mlx5_set_path(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 		       sizeof(grh->dgid.raw));
 	}
 
-	err = mlx5r_ib_rate(dev, rdma_ah_get_static_rate(ah));
+	err = mlx5r_ib_rate(mdev, rdma_ah_get_static_rate(ah));
 	if (err < 0)
 		return err;
 	MLX5_SET(ads, path, stat_rate, err);
diff --git a/drivers/infiniband/hw/mlx5/qp.h b/drivers/infiniband/hw/mlx5/qp.h
index 9dabf0326071814eb44c47637ef95e6088ba35d8..e3be8077a481bb3ea1eb974938e2b55234790ff3 100644
--- a/drivers/infiniband/hw/mlx5/qp.h
+++ b/drivers/infiniband/hw/mlx5/qp.h
@@ -56,5 +56,5 @@ int mlx5_core_xrcd_dealloc(struct mlx5_core_dev *mdev, u32 xrcdn);
 int mlx5_ib_qp_set_counter(struct ib_qp *qp, struct rdma_counter *counter);
 int mlx5_ib_qp_event_init(void);
 void mlx5_ib_qp_event_cleanup(void);
-int mlx5r_ib_rate(struct mlx5_ib_dev *dev, u8 rate);
+int mlx5r_ib_rate(struct mlx5_core_dev *mdev, u8 rate);
 #endif /* _MLX5_IB_QP_H */

-- 
2.49.0

