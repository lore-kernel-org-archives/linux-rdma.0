Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793724095;
	b=U8q9HGTOGEiwaHK0jvAZ2tEIaZT9bIN9/x5wcC4R3SToNE+KeAERUsAejqOvVtohh3ME
	 bXiAoh9tG4AtJX/E3KKP9JFVPx/UE9eqVu+yNARi84ZfeBA/la/aB93WrBJkn1fV2c8Vr
	 JIGSlQWVpm1Z6mzKZctoV6ffECuyZGWMpPdYn7uZcBIllksL50SIxkWqJhpcJyvnAGF4n
	 WuzmUlAgN6+1aaeZh+uZr9SbICVYla+sWqWuBgQnhal96IhSxmldLKgJZGm0MTuwEzPr5
	 6m92h8wDu1DQHwEdYowG4ZM7Ht7/ymg/pK8QbB8vO4hKWN2B5sm4BV+j8VrWDNw4Q0A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793724095;
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
	b=5QXWE4FItCt7VYomnGQvzWHgE9MsOtETO36Jg0f9a5tmufGa6EXoH27osTxCPRuXo6UT
	 2V+wv0FqwfZFl242V5a8+8rV1tj+K6LR0ikgGz8klduTLyebvHZCuit1WiXtbK6SdDnzZ
	 BiJbfrNtPaDPzPw2PbgLIeeBTuNVMGTeHx/apIVscjfnuHw49uDstI+fEbrc3j2O57gN2
	 zCEcgIiUpXp03ELxUyguEfN0rjL9B+eI4rHtJalIUw8Jw9+qRn60ytQePUtZWxzRhwFWG
	 pmm68jbByqjx6tO3U2wKY7F04jxjy43ycyER0qPl77TVsAYeUtmIj6oZ0pyWQ/O8AHg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=kL7Zw0At;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.45
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012045.outbound.protection.outlook.com [52.101.48.45])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E4D606EE95;
	Tue,  3 Nov 2026 16:41:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D8E4D606EE95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=kL7Zw0At
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gI1K2Gkhx8HOYNRIjvdRpPDoUL4GhrtUdBmv8UJOZ6gsuCRyQy/V7U3hpkDUePCAgesvJTE8L6vcLeG6/TSyIY4zv3Fkbdgq8Dffa5puLi0FhUCq0FuZfaGoeZtL79d5p4T7x73rGpXeSN0hiVu0u4sXjG+aB4vaphg95RHdAR416ifUC0JV0EDdP1j/EZwatxLriEQcq37ZsquPa/nUyqqXspDwpQ0WzJRpulEKOjPnEtJ2c1UhshE88NvZu6v7+dKi8795NiN1XBhFiCZSKpYhMGGDl8u1TsD4y5OHdrfXGCvqy6xsB73mAzt3l2ffnGrHpZWOWu4tcialeOo5MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kj613+5gfXHSWvslDWy8ItVjw8jcJqEXxUL6qAEg0+E=;
 b=TvZYWUfv6ellrqRRkAjjnOYnorEtOuTgTYwrld2NQuNs+FzMbUW2FrZ7ltOoPKEp0xXUSvF+e144bF82CguL6eW7UpgUO6uMpx7aEde0bKO8oV+SJjxPXhQwB6qPbrqYuABCcwA+Yw6RcdUIOko+vTu0LBRU256jY6K58ypY8bBbhWcJkaMyBHWmaXlnqO0HeYnMr9mHfjcH+WeoreG2sLjy876kGUV88RZfNgFY9SIMxUI/91Wyww6FQVfISlCC4I4G6n51zFDki2DWDw3+w+bwcfXX9SUk6zv4DSp4ujj8wGAThy23FpLfEZZyiDkTdvrCgfXNeuTyWrdwYDrCiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kj613+5gfXHSWvslDWy8ItVjw8jcJqEXxUL6qAEg0+E=;
 b=kL7Zw0AtUDS67t2IFRrdqv/2scjf+1cCApttjE2LF7ExjIZtXUZ69lDQWiS5veM+8lIpjrGJzxcNv4v2B/sez6OI7eEDbmadF4zTD2DFBuOevhm6VgNUkdNLtGNkpGkz6MOloYXgGI63nKS8JgDn7bVq9ktL5/OtPYQ9P1mqd1MfTTOuyNSdzwnXDaruhs9N3XqMHCfmQ+b1JWdXh9KfVGw0JxSvlKsHpoCFJ8hkJM/+KPE7sL2XrO7EiTDw2/Qf5MzCNx1u3MxrjZaxLElTbpiN3n4kq453OzJ5pn0hkip0/n7wYieVqMF5kK85lxYILDed6Qr1hIOkIYs0H9bBOA==
Received: from CH0PR03CA0088.namprd03.prod.outlook.com (2603:10b6:610:cc::33)
 by SACPR12MB220062.namprd12.prod.outlook.com (2603:10b6:806:546::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 16:41:31 +0000
Received: from BL2PEPF000352CC.namprd02.prod.outlook.com
 (2603:10b6:610:cc:cafe::ae) by CH0PR03CA0088.outlook.office365.com
 (2603:10b6:610:cc::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Tue, 3
 Nov 2026 16:41:31 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL2PEPF000352CC.mail.protection.outlook.com (10.167.249.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 16:41:31 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:41:03 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:41:03 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 3 Nov
 2026 08:40:59 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH rdma-next 09/23] RDMA/mlx5: Remove duplicate mlx5_ib_umr_context struct
Date: Tue, 3 Nov 2026 18:39:35 +0200
Message-ID: <20261103163949.1554-10-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL2PEPF000352CC:EE_|SACPR12MB220062:EE_
X-MS-Office365-Filtering-Correlation-Id: eaa267b7-2571-43b4-174f-08df39c95090
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|82310400026|1800799024|376014|22082099003|10067099003|18002099003|261102123227099003|261021123027099003|261009223027099003|11063799006|261026140227099003|261021121427099003|261022075727099003|261026121527099003|261028144727099003|261022105027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	v3ezaigc315GkJsIrLrBb54Ch9/D5oezEWCIMYKUp0N45GYIXldddjwnSPwozWF9pEhrBuP2P8xBYHLARjbOfaSKQwU9NFfAW3UF8vjL/atZa6W5/0VUzxotkoMZ4rKxV+riq+3g4vVlivus5voK8xe38H01tjkihqSifk/4WLP+/cE7WskVJUJfMORz/8QCStn1NaraoMAL4aNv8Yl5G4xC+cFOrfeW2p+33kzXrYuqHCjJ6kmsx8r0A53dpxkdMBY/Mhsu6ZtS8ckIBDAZJq77QdyL6fhoxYRbpWhuGoXwNaN9omVsR7yPjl6g83HLN9jiWoplCMSnpFD78lCAGsudlyDNeisykk3qFSY04/G8gJHsbKtuAOubffbfybH/hQ4V5YYIf0vyoioQ0uurXV/aGHswr85im+rArRrG86KPL1UUL5Yei9ZW1Rjbicy4wsnvzYiEGepmzotFPmVcfvP82hcOyxl6IZW/cvZGSeb+rnXFnbhRpJUWtRSoXMpSkPzY245o5B2QC4J0lmM2+4LyIY4me36jCxA5HQ8J/7aENdxRy1s2pY+QtcZwGUlmwGazvhar9gAdbeHIlGM/VbCBIU6Z7orr3AdLXCPctzmrpOtAxTmkBSycOtgEQ3N5mxX8qChwc7hgwhm3FxxA8UYtsmrm+ejGTZBH63OqPr9SSsxWWdd2QeCZxnJQDm2AFRYX1B89KFBq/BBo2hAX4Q==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(82310400026)(1800799024)(376014)(22082099003)(10067099003)(18002099003)(261102123227099003)(261021123027099003)(261009223027099003)(11063799006)(261026140227099003)(261021121427099003)(261022075727099003)(261026121527099003)(261028144727099003)(261022105027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	HbTIAZ7lIWtyjQ33v10N6yj8gpdbrWNJcEuWBuGmc4Kwy3WFCp3CVIHPxLosw6YtzS2xQ8Z7taTTF3XpQzNGUDFQ1or/OsKl6A9xiFP1Hse6YoEU/+tq/35YyxNdUPmn1WTWqtztIHrJ9WnvGJv+fVKknaLo588aRQESAqB6v/8/Ykhj//V6D7CNvZF7qxrKC6QvCwtsoM/6gB1u/Za3ZrNcbvyMJZixQW1me7aswVLf0Mlzv+Wrf3UNUBajyN+ifl41iVW+UpMMmzmcWlSYTagE97tkAtOhjC0vz2pAO1aFvh23J6kBWULOiOr4fPFIL/4FPzHv3gyDGsutZRFDhRijgVV4yYWnp6jfWN+lbgBRtqU+XEvGnNz0lBU/Vh4a8aloQUUeoCNPIFijw5gEw4YQgUpnlUUWE2cvKyDh9ESbd6dBOrcXGlHRvbMdpYhd
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 16:41:31.0955
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eaa267b7-2571-43b4-174f-08df39c95090
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL2PEPF000352CC.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SACPR12MB220062

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

