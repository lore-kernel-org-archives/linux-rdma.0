Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.65
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795369203;
	b=F+ZuqugA1RuAc9g0jykHOo0kDbT5014cXRWAmKE8y5oRvRg7kaZXv8qRPx8L4bWMDy3c
	 uki/yMYMvl1ZNpyrGO9hhe+tw1noz6vwWlMNoDU5K+1/eMBYwVj1pLOp1ew+u2CpuYm8V
	 ss39Gjo8KcR2wd5BQIQfOyIffBbz4Dhsy6QcZ2FPCc9I1ug6TaLBfJOsiWitI+ugiuvuN
	 VflnsVr+tIQedBBiBrzSQx9pTUtXFI/s+sTGcOws+PKU/KdJ1lAAFQ8cW17mkFsjB4HZL
	 JLYrnsn6siLizwVXjrati5OpaeBjCOqipVUFE5xmuoEDtjwhJi4fL9Xw8cJSIrJL25A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795369203;
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
	bh=pM0YMyq/UUQWGiRcK63mQNdMSFUeMOniY4ym34Sl1lo=;
	b=R42o6sogOUUiZS+MMAlAuMHzo2aBfcE0jZl7VJdwQiigvZWd8Xme08SDnrrX+QCk5yQf
	 Jh2xL52vnNQQbolbBGn1jhzYZ9a5AlFhmvY/AipHdblv/nzxN0tJpMKWdZnUD6InYH4Qu
	 nFtaDtmZDAo/ihPOaXMnCAi/cjrbBY2ngsWJ2UJYBFUXM2/zcEebi5iSm25yxC+s5BrCP
	 bk2cPWmd7wG/brm6GCG+qZns3PvxM4UQWFlGFAMKuTwnagqQylmmj5OZXVGlifSLH0jke
	 wMUGqM+ExnbySk6ZZtz0kUjwd4en5HnMS0NL/9XupQuq0cRYuOjFYZicwdSKmekEoow==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=CBlFwi0k;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.65
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010065.outbound.protection.outlook.com [52.101.85.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E0C606A32A;
	Sun, 22 Nov 2026 17:40:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 54E0C606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=CBlFwi0k
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pJmXGg2QiIPaMZ1qb/LBCom6a+7sgL0L/m1nPmu5Bk4yx4uCsFMo2GiG6YUzbGMjsdTPUe/BG2GnF9bl7FFZ8Ws4d4+yyZDsIGzGYS+wrau1e4AAPIHcUftD5b5Rg4Taq3e1RSWL0ZsWh8ozL2kKJh/E23ei0dxOISXVLKLb7GzGHIJdVbV+liAgbTFgMT+Fank2yXvCoZbcpJCdsswYw5d98HwSsCoAfAQjT9BjUqL8k3MAWOmMaBIhiNLc1Whxz7HBtME2431coL7qvfp7fVIiJRpiXwwgul3um02NbEFraOhvYo2X+gEAr1AeqLdISwEd/T6X+nu62vZQfBIHcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pM0YMyq/UUQWGiRcK63mQNdMSFUeMOniY4ym34Sl1lo=;
 b=yQ/kSwL+G9CEUEB52ajXimmeaGhwgaPwEMJMagS5d1ZAW//pXKKAmYfYwlp4WxjrQH8kVEXIVNLTQCufZZ+/gIx1EptgPUvPjJlEkuDtnvsOwMQVtMUwckz/Bi7eBCyh80v5kh666Gkz+BKp8pDCTR+tmG3oDo5plZzLghp9TN+cA5nhXVpsa+TFGqC+Wz7W5ZLGxFRq9obw8bKu4lslsrqTjAdQ7RsFNQc3EG6GXOqj9/uFU0Tn31tuj721AYduhzuHnn5ySwSKJpBEz8PwBBJKCtUF2SWiK1W6O9NM3A65acHrE95WpgzH1IWvSzMiWnARLAtq8LRKxxWfn4tzdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pM0YMyq/UUQWGiRcK63mQNdMSFUeMOniY4ym34Sl1lo=;
 b=CBlFwi0kmIjPmHbg9WrQwJhKb1j9sQ+A+b+1FnlFDYVNcGHZE+qJK6K2El/nTualWuRblh+8IL01AkItlQPl1Z16RL67+LhgJnIuUkK8PsneyK4aTtlR2GgKH7GxlxfBtEltaOXoXt5oS9k5zrI4CMAQIrG8GcNSQCOi/K3b0aIWAXGMMEGFUaZ3ZSOrIJls0rYU+khWZ+atTAXlWfmgbIOzYHZk8pnkg9vVPSL1FcRW6ZHWzCV5obUpwQvc9l7SsKkmM4M+z79dhkWM2h032xN89d7ae+vLtvZnpnrVP8BMjIHifvKA/B5KvV3GTQfwqxXsHm2t3t6q2A1imR42uQ==
Received: from PH0PR07CA0070.namprd07.prod.outlook.com (2603:10b6:510:f::15)
 by DM4PR12MB6064.namprd12.prod.outlook.com (2603:10b6:8:af::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Sun, 22 Nov
 2026 17:39:59 +0000
Received: from PH4PEPF0000B60A.namprd21.prod.outlook.com
 (2603:10b6:510:f:cafe::17) by PH0PR07CA0070.outlook.office365.com
 (2603:10b6:510:f::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.639.14 via Frontend Transport; Sun,
 22 Nov 2026 17:39:59 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 PH4PEPF0000B60A.mail.protection.outlook.com (10.167.243.84) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.0 via Frontend Transport; Sun, 22 Nov 2026 17:39:59 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Sun, 22 Nov
 2026 09:39:43 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Sun, 22 Nov 2026 09:39:43 -0800
Received: from [192.168.122.1] (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Sun, 22 Nov 2026 09:39:40 -0800
From: Edward Srouji <edwards@nvidia.com>
Date: Sun, 22 Nov 2026 19:39:15 +0200
Subject: [PATCH rdma-next 7/9] RDMA/mlx5: Activate the device in a stage of
 its own
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
Message-ID: <20261122-mlx5-port-events-probe-v1-7-0d54e3d53c61@nvidia.com>
References: <20261122-mlx5-port-events-probe-v1-0-0d54e3d53c61@nvidia.com>
In-Reply-To: <20261122-mlx5-port-events-probe-v1-0-0d54e3d53c61@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, "Maor
 Gottlieb" <maorg@nvidia.com>, Chiara Meiohas <cmeiohas@nvidia.com>, Mark
 Bloch <mbloch@nvidia.com>, Maher Sanalla <msanalla@nvidia.com>, Patrisious
 Haddad <phaddad@nvidia.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Edward
 Srouji" <edwards@nvidia.com>, Michael Gur <michaelgur@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795369157; l=3105;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=GcZd3Op1Dmae86eDDoUjBPrEehDqtshnDlogP6x2crg=;
 b=T4SRII+IxaJ/TO9SyWpftprcrCK/omTPfj+PZVLI21sslPmxD/7oD/uoPy6pFrm9GNipgSTe9
 XdhZ+w6715cBj77BW86O4sxoqZY8kZXmZS8s2HE3a5CYfO1VDe1wlOQ
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH4PEPF0000B60A:EE_|DM4PR12MB6064:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a9980f1-0a65-446b-1d31-08df48bfa140
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700016|23010399003|261009223027099003|18002099003|22082099003|261021123027099003|261021121427099003|261022105027099003|261026140227099003|261026121527099003|261028144727099003|56012099006|10067099003|261102123227099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	Vbw7Tc00f56mJFPO3DwKZ2SYNgJ1/UaLZL7ghvaWrRN2+VpRkfC1iMnd6OMPH/d65w+WZMFtRpFRSndE/5y3qJtGD/l2LxYqU13y/ROdaJm/aQoNGTKv2+RBqeMIYTH+IlHE2HyMTGt7VlUUL10BmUX5Qoi02ZlkShjeI6BR8JiabfeJfIVJTB5PJoA8ULWV5mntJr9b8imnmHgmQfZ5PlF5TjgAnkKGr7USz5bRqxB+wmDz/jgPQ/Zxddr+O64uBmIizwbguf155eh/lux7vseQe7Tbrx5991q9Ta7VCKGo/UaNhmLMnRVfTs4HqDythxYwMVsglJOAfRPb0MsK88NchXYxJyTUrTyG+Ris12y5GfNf3ukA9q92Ba4OdXr27Ubie0sKQCZAJBGxjmhCpzM9QDKahLYTvkaf8KEqFo5/rZ0oyvGjBTdrioatpvi8ixav39F1T9UBGf2+J0XxD+jQOLHANvpCImG7muNmLbOy1QIymPPHqf7AnVSXnOl+TuYMXAB/vqgCLt3rT3ar3tWPKoSyUn9dFvJOq+CYgBc3/f+lvk9g8AGuhjU/7Uv63w0K29cWNvfomRWT1HkZBnyKoIB1oFTD38v/7RTSF1fnI/EJNHlHnIM1ldH8UnldwLluRx1Sew0OSu+BYl9hKJT9xpfiZyF5EnTP13mFe3wz5lJNUhKLPfP+JTn0abO3We0HBC31ndJ4cepoVWXa0Q==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700016)(23010399003)(261009223027099003)(18002099003)(22082099003)(261021123027099003)(261021121427099003)(261022105027099003)(261026140227099003)(261026121527099003)(261028144727099003)(56012099006)(10067099003)(261102123227099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	tJG6R5yVYRIGmPOnS+bWA1zOfVJLLmYyDhb5DYnDBYKoq1VygjLemqJiOAoO6LZFCkpjlVAd8iD6hqLa8AF48UkpCQ2Wfmia4bk/MkW0yvBZDKE/dUjqix8Lvj7aqKeEvKfD7t6DBVByLoYv6O/OndCUmHC7CDTC6KiiW5tpihSYRTNrkZlo7YqgPW/B/jvSagXUzrYiKfznH8pNPKuF0Jhw796LApFROlckunyMptOsSIxAkL+I7mYVh1kyrPEL51Kwk+a3c1ZdgNDTEKxc3+8lK7PJLpIKTtQ82Iy2pGlDPKtTL65YMQGG/fJC23vDSDh4wfEq12eIxEytvvEOWzhKaIWGjWzHVgR9TZbT7lN3R1tTn/WJv8VN5EXSPouBbp2wQ7camUkryP5unV9u8YQF88ak4UP6/ByjiCtdIi+zQZ0k03b0LsFcE1R3kSji
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2026 17:39:59.0390
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a9980f1-0a65-446b-1d31-08df48bfa140
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	PH4PEPF0000B60A.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6064

__mlx5_ib_add() sets ib_active after its last stage, and
__mlx5_ib_remove() clears it before cleaning up any. Do both in a new
last stage, MLX5_IB_STAGE_ACTIVE, so that a later patch can fail the
activation and start work from it, and stop that work on removal.

No functional change.

Reviewed-by: Michael Gur <michaelgur@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c    | 23 ++++++++++++++++++++---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  1 +
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 954b141a9c927d5cf4f20a17cc633de09624b0ef..80399920078edfca8f672fb77514ba6b90966068 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -5022,12 +5022,21 @@ static void mlx5_ib_stage_dev_notifier_cleanup(struct mlx5_ib_dev *dev)
 		cancel_work_sync(&devr->ports[port].pkey_change_work);
 }
 
+static int mlx5_ib_stage_active_init(struct mlx5_ib_dev *dev)
+{
+	dev->ib_active = true;
+	return 0;
+}
+
+static void mlx5_ib_stage_active_cleanup(struct mlx5_ib_dev *dev)
+{
+	dev->ib_active = false;
+}
+
 void __mlx5_ib_remove(struct mlx5_ib_dev *dev,
 		      const struct mlx5_ib_profile *profile,
 		      int stage)
 {
-	dev->ib_active = false;
-
 	/* Number of stages to cleanup */
 	while (stage) {
 		stage--;
@@ -5055,7 +5064,6 @@ int __mlx5_ib_add(struct mlx5_ib_dev *dev,
 		}
 	}
 
-	dev->ib_active = true;
 	return 0;
 
 err_out:
@@ -5129,6 +5137,9 @@ static const struct mlx5_ib_profile pf_profile = {
 	STAGE_CREATE(MLX5_IB_STAGE_RESTRACK,
 		     mlx5_ib_restrack_init,
 		     NULL),
+	STAGE_CREATE(MLX5_IB_STAGE_ACTIVE,
+		     mlx5_ib_stage_active_init,
+		     mlx5_ib_stage_active_cleanup),
 };
 
 const struct mlx5_ib_profile raw_eth_profile = {
@@ -5189,6 +5200,9 @@ const struct mlx5_ib_profile raw_eth_profile = {
 	STAGE_CREATE(MLX5_IB_STAGE_RESTRACK,
 		     mlx5_ib_restrack_init,
 		     NULL),
+	STAGE_CREATE(MLX5_IB_STAGE_ACTIVE,
+		     mlx5_ib_stage_active_init,
+		     mlx5_ib_stage_active_cleanup),
 };
 
 static const struct mlx5_ib_profile plane_profile = {
@@ -5216,6 +5230,9 @@ static const struct mlx5_ib_profile plane_profile = {
 	STAGE_CREATE(MLX5_IB_STAGE_IB_REG,
 		     mlx5_ib_stage_ib_reg_init,
 		     mlx5_ib_stage_ib_reg_cleanup),
+	STAGE_CREATE(MLX5_IB_STAGE_ACTIVE,
+		     mlx5_ib_stage_active_init,
+		     mlx5_ib_stage_active_cleanup),
 };
 
 static struct ib_device *mlx5_ib_add_sub_dev(struct ib_device *parent,
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index b2d4db344071bcc068a767f94ffb64b80df9499d..3884e5524e7dfb2a37515a6f4e8caaa82224c964 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -940,6 +940,7 @@ enum mlx5_ib_stages {
 	MLX5_IB_STAGE_POST_IB_REG_UMR,
 	MLX5_IB_STAGE_DELAY_DROP,
 	MLX5_IB_STAGE_RESTRACK,
+	MLX5_IB_STAGE_ACTIVE,
 	MLX5_IB_STAGE_MAX,
 };
 

-- 
2.49.0

