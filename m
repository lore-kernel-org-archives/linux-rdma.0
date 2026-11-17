Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.3
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794935485;
	b=rZQFFs2IqqJ2SMB1ZRynkNDMRy+mVpU47inHFtuDcGbaa8JcLVdG2gcNFCVE6sFAC6jD
	 ajbRBtIHUyre+V+pxriALLdvzS0g/4/Sd5xZd5VIy5N4bMdGX88FEkIHpB7Bx9u/jublt
	 thzlKpNnCPWVg7JL9BELVyy/IgOnrAw0GP+QKFAMLnSF1yInGvznXe5FKNKUk+4+EWXvM
	 5TvTYanGWulcHgo5h3yQPHOJ0P2u9bVH8aC6XJjSrBSb3RsKjYkyHdAz8WvOUelKW0Bec
	 vnk/TP0/MD0W3hJ7CD+Gba/qwmPaOphbQ8Y16DeeIkcKfRPMh67DbQwEbAB6ykwLT+g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794935485;
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
	bh=foTnTSVzTWeB3RKXWr/0wKAHE3phdxQV6jGDWAlAz6s=;
	b=O0lzkML1TA4Tiqw9iBnpgFa1nQiykJu2KJok/0UKP96XOKrgWL4jx3oY7XFRKW+9WTIa
	 ErAKiTfVl8EOJtEVYGwf6PpuDufmuoEHrBNcmGtzsaEhjAql/bh5tsokZseIgvF03TtlM
	 f+tZ+aBjcMvFjeuxXIIASrkMpfzoIEUqIXsFGBq+W5NE6y86kFqxRI0z0aCmAo7RbAxfJ
	 ngBA18vVb9CL0zD/1q8j0xF00igXHJaaPxxb8he1UPyUJh2DUdvPoZj9X/qWj7IL8jofK
	 w0TnhX3gb/tOjUvQ4onP29roG5eexfwixL22Oviu+dG5fZsf5S70cZWRRvpx8entN/Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=M3qFjjCr;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.3
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013003.outbound.protection.outlook.com [40.93.196.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9276606A31C;
	Tue, 17 Nov 2026 17:11:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B9276606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=M3qFjjCr
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L/GjuwzbbZLSEAsy88Xqq5/pJ7aeQZXthuGn1AwCaJKbN7CZv0uizOcHnmBbsdqEK8s/m5ZTYRd7T0zgGvQwN/1IVa2Pc3EZ+N2hbvyMJAfJQWcSInnrF8qBmAp1jTOLO+RAKhg9kyyuiigQz6k0vVIvDFgLCQ977CDMsGADzR0+mxxh6FQp8oencM/1Aw05DlZCmS/4Msm7wqgSaoOCzOsSDaGg3HGatfa4Uo36QTAjgeMRdiOYHvJIjx4gGXZr6UZXOmU4vCe33RD4V1tzWTypBzCM/AMfbdKORs/+dkk0/5edNIcQuOXgBkcNnkEk/t/iXvPuJ7g3SYGqL4VxyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=foTnTSVzTWeB3RKXWr/0wKAHE3phdxQV6jGDWAlAz6s=;
 b=HD+rZtBeMAp42qQs/SQ1J6obhmRnACaoM8VjkjX/XVqSOf8RDDpLiCDJErJwUu/a+curHxm3QIK470HNfBBrZk/tg71wLowPzK6igkpbLyxM4LDOw3vTsnhHa7viysGelCLerVbo96JG0i2aet07cY+YUX70n1hUeivaRSNMoC1QuQpDTUFy132C7ayWBkilbPB69bSefH4VsKqQKwXp6odEYGJDgYOgYcYvqeH7k2o/p6XAzpSzBCTo5TNRYjq3j/KDLnsmUNAm5ySQondLVu+FA277bvuoTvfdWVLBJohEcbQKVpYY4i8qgtrjdgdqus6G2j1c94HIz9G4Y9G3Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=foTnTSVzTWeB3RKXWr/0wKAHE3phdxQV6jGDWAlAz6s=;
 b=M3qFjjCrODJmLr4cUDBp9MubJ2x8m8GUEy3ClNJM9iBraFuGorK7UzcHn1LfuFxocnP8I7jQV8UIxuYS2KEZS5obwmjp6BxLMGuiDw6HHvQdyOzITx07qr6hKuplNZitHU//7Q1j1wFRutqE5VIEzU+tgzNka+Ktry2LMdGXZuJQ19gDvFGEK64ULUiBoECBUyrTPnuQxuQnX42XTH5Uc/Rwsbe9hQOKPBhe+XXByJnw2o5e0Ea0+PIXLOtN+RUB8wYsarvn+BYL7XHAuaMd4ZztpilvzXbopOaVQu+WOBpDIjWvR1qWX2bgnoGdcWssnB9SX5udbDbzeIRPxVEmSw==
Received: from PH7P222CA0001.NAMP222.PROD.OUTLOOK.COM (2603:10b6:510:33a::14)
 by MW4PR12MB8609.namprd12.prod.outlook.com (2603:10b6:303:1e2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 17:11:16 +0000
Received: from MWH0EPF000A6730.namprd04.prod.outlook.com
 (2603:10b6:510:33a:cafe::2) by PH7P222CA0001.outlook.office365.com
 (2603:10b6:510:33a::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Tue, 17
 Nov 2026 17:11:10 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 MWH0EPF000A6730.mail.protection.outlook.com (10.167.249.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 17 Nov 2026 17:11:09 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 17 Nov
 2026 09:10:30 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Tue, 17 Nov 2026 09:10:29 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Tue, 17 Nov 2026 09:10:25 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V2 rdma-next 10/21] RDMA/mlx5: Remove duplicate mlx5_ib_umr_context struct
Date: Tue, 17 Nov 2026 19:09:03 +0200
Message-ID: <20261117170914.27410-11-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6730:EE_|MW4PR12MB8609:EE_
X-MS-Office365-Filtering-Correlation-Id: 417534d0-3c77-4806-6545-08df44cdc684
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|376014|23010399003|1800799024|22082099003|18002099003|261009223027099003|11063799006|261028144727099003|56012099006|261102123227099003|261026140227099003|261026121527099003|261022075727099003|261021123027099003|261022105027099003|261021121427099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	pl9o6xL8iBYjRRzpljHkhBd8vwUSJAaMHhwRN+OuXZac23PLqTjOI/0BDyFMNIhT5tePGgJChv1jlkdBtXDgxNM/wPl+avgD3in4y8YaP7oXXIpdl9k9dwiteZBQ7TZBFp/AHky7RoFXM8qLzxrgOAcrFCO1R4iZyr/LkP3y3NLfxONCoBdMrY6nWxiCwHopEeeTCOT5PLgV7aCSI+ZCrfyuS9+jUaN2R3BENOuIFvB2hltPOVTbN7uCv9/eUbm36HgpT6b6PTbH+HNpnMNqePrExBZmoiJMzN5KiYU+fui23T2mBEfm/IKb5RYf7uGMhRA3QLDC5PtevsnwSb5Hub4GoulJjNPeDSkMkbx058LRlhJPCvnoUTlVmGWbQgsl95tHXEioLlYTbETbPrrtKjlnWP3UPgrg9LicC03JwOeOVHJ8DUVQIMDHqdQMnSp9Y/Y1xQgb9RfA5+rq8naDWHyO8+HjO0icl6WnB1VIYgsNxAaoxhOVk/DSsBjeQ882KBpBLVFzQXt4IcuR3PWX/h/fUwAWNoKEUNtZqBmR2ZM2g14Tygbx/2B1Og2KrrYYTvy8qmZZWs4Ke5JpH4TTG2vJbMZ6eL19AwNB5YfttgQYobMKPHYcpCOBnTtPZgyOPV/jlNyEzoVb5TR3S4bkPkOLjZzKu2t66nOdwhRgEejOkQYK+h2umnFiBReNzd30jXFN9yVS4enPNQIKPp0Z7g==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(376014)(23010399003)(1800799024)(22082099003)(18002099003)(261009223027099003)(11063799006)(261028144727099003)(56012099006)(261102123227099003)(261026140227099003)(261026121527099003)(261022075727099003)(261021123027099003)(261022105027099003)(261021121427099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	UvyKvN/mdoBkIenRu2LpCJyj2wPuFwIuqBNznmgxJVBTQ8LyJT3e405eU9ezAFCDchOof7g4ACrIo03hL5sGKID5H3R4RMepQ/NKcyMsPKxoNCKSsVEZf2aH9MFBP3Ul8JBXEzJ028TSKLjiP33k39Wc0H0mM+NWIRzB4eF8HTs3qYXAg8uJX8aUXNfflm1QgTbjlLpBlJzadhYouFTZsa4PVnjgVWrdrggQVoZjoawhJwP4dJPI0FJj+0Dqa1DHIXZ4Mz0B9WWt2LFebLVCXWcZk8Hy3nKnoOSKUDlsXoH/+rwrkJIwQfjRrzIAd9tKohlF8rMcKVpXNX2hr2tFlFk8XdsK1Mjrhcgi70MMz9IJnFaSg9Hkr03eKFKSrSs+Nc7peDCLOI/jdPKalkzG3TDUS41TrzvTXyUdymeiBtmaXJtaO1VLasNXmf8yGisk
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 17:11:09.8274
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 417534d0-3c77-4806-6545-08df44cdc684
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6730.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB8609

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
index 4a6ee14ffd7d..5b81d7596bea 100644
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

