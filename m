Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.35
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794924138;
	b=HBXkib3amQSOojlrgROxHkuhwDqyDG/VGo5X44KXegH/m3jwkeqeL10q0KiRFkaLgX5D
	 lrVRnUG4NMw/WSJD39tvVj5xWJ/wafw5/9tnOTLoZTZ33npiaOAC4ZVTmbkOzPWAwRVsu
	 oZRz5rnxVNdGHDepXQGSlRxXBsmqeXqG8yzp6SQmnB7XdOyWbRbdHvtBZEcleaAm8/L13
	 k1MCJMra8jBk5hWHWOgRlYmGxSZ4H4CMHri3T7jQptjL1GFHQgcjigIF62QSt+DhFURlo
	 NOSMNgUbkw1YtB7vuwxWuW/qXvgPnweg9oiebGl0WaWbXtdAZIyaxnyTYwnZhcbMTLw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794924138;
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
	bh=phoonDiu8t53CxMe6redvVAAydjynhA7hTI6HEQI9nI=;
	b=sbj+XGwV/PWlfLVJ+h6Fu4DwMeHx3EPCgoG94OIjJ802Gov5dbRgnTrO1L539OsmuyJH
	 fqGt1o64vYvlhLOOK//SJc9ezpn5SJbReiyrCUL9AdgGTAPqKpYirOaMTB7Px4EmJIfZJ
	 Su3y5/fKcqkoW+ehO7lMstDPyz9yFSSR9xBi3uSP8vYUZR5nMe7Agf8gr6rEew5v4pbh7
	 d7bVqUruX4MkbEjGE8kKWAzv2F8b4T0KW41imqwg7nGEWn8P8y/L1IRfeAsj5M3RZNlz+
	 nBXE044mEulbTOgegk9yM6dVfS+SOqIU0Mpxfl8v1Oz85cTQypGHXV086HLlMoD8KWA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=n+tLM8FL;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.35
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012035.outbound.protection.outlook.com [40.107.209.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D67F606A899;
	Tue, 17 Nov 2026 14:02:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7D67F606A899
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=n+tLM8FL
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UHDT5euTbQMOjM6kQ4BiSDydMHppL4oR1hK0Z7hlu8lGg+ISS27hsfwUdLXje0wvpQ0aWzhLBPdanzrFbpxO2Y5t2X514WmdwjXOKUX4Ivakso0elvJ5j3iMzrBzn9XwSk4tXDnecFPfe+VQwWvtjvD0dTJSxAJifEj9onFgzCy2Yur7+YlIYEZL7xBXqaOCSiOuKqswyHnBR1NIDKdb9BUnOr6tVPQD9BHKrSImM11f2BJ2tBHaTAhVydL2VrvSHTgIk3G0rsaoSyvN8SgrT8OpgjfmQBzQhVi3xhtl8jrCEctylD3EHT3YAGyoZXsy+ONNOKHgOQzuKhVnTSF65w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=phoonDiu8t53CxMe6redvVAAydjynhA7hTI6HEQI9nI=;
 b=OuMabFWfx2J+CD+RjA0XxgDqRIlN7emQ5tvZW/DpLZbi943yrof/KX//sw5tE4gvRMtCQJLcFjKfi1yXAzCs6PiOb0Xjcl8NmFAXu4FZOwO0LHwnUvZjYfmPtDLXKpuUxnyqO3LB2GdnYfGguAxXNorSOxUld+o+qPAz/grIddxAja2yYCzNKdl1/laSGUvB6SpkKmRGPFi+vL4P6lUlFy2brfVXYML2nj3JN5QHyBkKDLRYm8gt4pq310OQ2efM+cIuiq1Qmm9ak1uudhyr6OewyRN79aQv00zH+H79dMuhN3NbKHU0MkbfAefMtRX708aYF5QU0s3eOlkltFJ2kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=phoonDiu8t53CxMe6redvVAAydjynhA7hTI6HEQI9nI=;
 b=n+tLM8FLnYrPghmucv7QCPxYVA3SLhxA7qboAqL3oSa6u4SqMnbhl4uBtbYBzLm831tjXYBpCR8oYPghNKqdrAZKXY4UhzIVoRAKg9HFS9bPVDF2KzqxwxKOp6JBPgi8EdSe8Akv9D/lBETrswZaXdzVgEo5pkliau7bafUhsomPz3aR2dydb7ptuBeAQh7YDzW3EXjGXK/QXbo4vhYkNv8FxRtzTKH6ooFXwBVJkj6I02FKoxlc5HaFhrKfLWTpppHgCRTd234AFgWfZJG/SbPH4wCClOaluBQ/j0zyy1YsgBueekXh32LOYYhewu+1Smaaqwc5z+9ooDZej99vWA==
Received: from PH8PR21CA0005.namprd21.prod.outlook.com (2603:10b6:510:2ce::21)
 by MN2PR12MB4221.namprd12.prod.outlook.com (2603:10b6:208:1d2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 14:02:12 +0000
Received: from MW2PEPF00014678.namprd04.prod.outlook.com
 (2603:10b6:510:2ce:cafe::20) by PH8PR21CA0005.outlook.office365.com
 (2603:10b6:510:2ce::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.1 via Frontend Transport; Tue, 17
 Nov 2026 14:02:11 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MW2PEPF00014678.mail.protection.outlook.com (10.167.249.185) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 17 Nov 2026 14:02:11 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 17 Nov
 2026 06:01:38 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 17 Nov
 2026 06:01:37 -0800
Received: from [192.168.122.1] (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 17
 Nov 2026 06:01:35 -0800
From: Edward Srouji <edwards@nvidia.com>
Date: Tue, 17 Nov 2026 16:01:17 +0200
Subject: [PATCH rdma-next 06/11] RDMA/mlx5: Select the AH core device
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
Message-ID: <20261117-mlx5-sd-prep-v1-6-8efd124c7895@nvidia.com>
References: <20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com>
In-Reply-To: <20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	"Sabrina Dubroca" <sd@queasysnail.net>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<netdev@vger.kernel.org>, Edward Srouji <edwards@nvidia.com>, "Akiva
 Goldberger" <agoldberger@nvidia.com>, Michael Gur <michaelgur@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794924076; l=7405;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=8Uc96zb7t9J4GML4mWKsvOZD5qDq9zwdmOJjf0n/djQ=;
 b=+3XtVQb3+XeuoRwW/5zqV7xkeW3g1BK0fS+ddRthGIcFTEysub4K8QydyYQm5H4mxa+5UK0AK
 drnAN38xFiCAAKRLHDioSHaqxIjcTYmlO9jqguKaGB7nTzFKVPh7hjh
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW2PEPF00014678:EE_|MN2PR12MB4221:EE_
X-MS-Office365-Filtering-Correlation-Id: fffff1dd-fd05-4a56-d5b0-08df44b36081
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|376014|23010399003|18002099003|22082099003|261009223027099003|56012099006|260925022911599003|260925021911599003|11063799006|260925021311599003|261026135527099003|261102123227099003|261028144727099003|261026140227099003|261026121527099003|261021121427099003|261022075727099003|261026130827099003|261022105027099003|261022113327099003|261021123027099003|261022115727099003|261021130227099003|261021133027099003|261021135927099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	3Y2PlBTMcchrb0kbE4sBiFNkQ0rQoqCZQKE+UYdj45swgzs2fptHeKN5XFNt/4zjqJQyk4FWCHA2uM6NZWGPUu27HzFL5ESYPpFMe4faEa2qyZ0ocYfJrVR/0Fp3OCXs5HGi7zNKKurCpsJIquotekUUCeKDrlw5Q3nW+Ko/Htfbs/jZzyR9KRFxc4dfkMhqOKsLCypZJgzsqwYMxVbJ4CTJAahwVv7mGNiakR+HbwLObNu0koEIxmALUl5m26ffbX1Rle9QAzA7FNGTo4vBZW30NBi/D9Ow3BifNE7iJKmCgee0eQFQF2DixBYqbDUoHY4iGUH0Vd62fIHpmzfMgRwJleFx/qWzqkU+sgE1P+aSHxD2G3Zw0yrnFarrXCyk9RGa14dKPUoMcdKRQY1K6czVOgYRcVDPwSCQPKvWKZC7FDqo8+w59AR3Ik0V3cO8/W2t5sQFhHXvUTt7TuO6v8dvDrPtGppv7dpx4BEB0N+nyuUuiaDjEd1P3L7cPRdsH4JWOrbRR8xkoi+yeZeUBDn7a2mhVNuLh6dnNUCxXvVz/0mFEVEaaJ8RrmwPdRY9FqMI1cSFHmKERh3cKGQW3y3+N5SlVej6wmZCNTrOkcm6RZwZsg3pfAFe3y/OhKgKvFihqEY/3jwnM8IVJM+/dUyUQtUScKIFoOupRszf6CQmDjxVGhvrj2c5TRza9ow7EBC90iEZkJmkyGaE+/5aJw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(376014)(23010399003)(18002099003)(22082099003)(261009223027099003)(56012099006)(260925022911599003)(260925021911599003)(11063799006)(260925021311599003)(261026135527099003)(261102123227099003)(261028144727099003)(261026140227099003)(261026121527099003)(261021121427099003)(261022075727099003)(261026130827099003)(261022105027099003)(261022113327099003)(261021123027099003)(261022115727099003)(261021130227099003)(261021133027099003)(261021135927099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	7iibQodYFAG0EFWZCRdvglUx/u/IGMAWGb6CoyEVqA7xxht0p3TsYTqUETMVfV2NzTLwR74RUSrfI+aM56GwnBDC8ZtgD81LvUSV2MOVB0uDQvi4peK34zRh4vtEbJrw6ZJ8EwAn31/WCPhJZTfMGkV0pGBeWYaXpan4Tn7XdsYoN9KvJul3wuIRwiRf1ltUV99CB0yChELLDQnfEHy3IN7uWVa5dyR54tm0D3L6NfQZuNt/vv/UHOOCF8ZdONF4t/WsHdgHV2RAnF8S2OBsj/I+QYWTcZr2kaFeGOEehWQWdYq7+YsZ/cdWRNe+ATWnN46mSKVeVp1+mMVN0Vv4gQKynkbOLYPD/fIuf08y2DZ1Fs+lrYdfiewMQxTC6ieQ/MF1AbQxpa+Lpiyhe+W1W/Nwj+y4VZaP4fg6aMNkDeZRuFG7bCRq+X8P0uaM/yFH
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 14:02:11.7829
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fffff1dd-fd05-4a56-d5b0-08df44b36081
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MW2PEPF00014678.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4221

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
index 4ec9b56afef7d9fb52ebcd22e0858eb741d010be..f7ea8aa4ad210c51c2dfd82bbe16043af667b7d9 100644
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
index f110803cd30694f05ce7d5bf9fdd35e6b5c003fd..8b878b33fcdff72ecfa37a860585193ab0ea9c13 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1534,7 +1534,7 @@ int mlx5_ib_get_vf_guid(struct ib_device *device, int vf, u32 port,
 int mlx5_ib_set_vf_guid(struct ib_device *device, int vf, u32 port,
 			u64 guid, int type);
 
-__be16 mlx5_get_roce_udp_sport_min(const struct mlx5_ib_dev *dev,
+__be16 mlx5_get_roce_udp_sport_min(const struct mlx5_core_dev *mdev,
 				   const struct ib_gid_attr *attr);
 
 void mlx5_ib_cleanup_cong_debugfs(struct mlx5_ib_dev *dev, u32 port_num);
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 2196e06f593e16693f682fc0e9eb7a3b18131f60..2709e5465d3316eb08f25663a248fba62ebfe8c9 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -3497,7 +3497,7 @@ static int ib_to_mlx5_rate_map(u8 rate)
 	return 0;
 }
 
-int mlx5r_ib_rate(struct mlx5_ib_dev *dev, u8 rate)
+int mlx5r_ib_rate(struct mlx5_core_dev *mdev, u8 rate)
 {
 	u32 stat_rate_support;
 
@@ -3508,7 +3508,7 @@ int mlx5r_ib_rate(struct mlx5_ib_dev *dev, u8 rate)
 	if (rate < IB_RATE_2_5_GBPS || rate > IB_RATE_1600_GBPS)
 		return -EINVAL;
 
-	stat_rate_support = MLX5_CAP_GEN(dev->mdev, stat_rate_support);
+	stat_rate_support = MLX5_CAP_GEN(mdev, stat_rate_support);
 	while (rate != IB_RATE_PORT_CURRENT &&
 	       !(1 << ib_to_mlx5_rate_map(rate) & stat_rate_support))
 		--rate;
@@ -3587,6 +3587,7 @@ static int mlx5_set_path(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 			 int attr_mask, u32 path_flags,
 			 const struct ib_qp_attr *attr, bool alt)
 {
+	struct mlx5_core_dev *mdev = qp_to_mdev(qp);
 	const struct ib_global_route *grh = rdma_ah_read_grh(ah);
 	int err;
 	enum ib_gid_type gid_type;
@@ -3647,7 +3648,7 @@ static int mlx5_set_path(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
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

