Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010038.outbound.protection.outlook.com [52.101.85.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF354F85A6;
	Thu, 17 Sep 2026 18:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668662; cv=fail; b=cCZrlVzO22FU8ngT9d2AB17zyNUjfAuww1cbs/EgtH1n1s8Ahiu36ScKqjOVOpqTDPvyhhsUPdPZD7qwPgKMKTNHNLA0NvpLFh1MAZooAxlKWs+3xX/XxwjiLfa7VMuwHy5saZjjuROrlh/OvYky3eoi1+YnJnigV3JaPpYx/CQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668662; c=relaxed/simple;
	bh=x3L61W/0969CL++/jwdqGVpx4tVFYhuAfcv9v/fgqgg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cg4cWNxtsbX5YWvFEwjGae6862V/aIwOr8u3wfdmIekmzsdFGAY7SxZFyBXv6onHTxv6/VN6dRZRo16QQjBNgWOjEwYjehqYa5UzVA1a1/0sfX38l53AMrdSPKu9K/Ai6x1BsS+1+cAtTKpmFnbSK6duFGdN6YX7zXTZyE/hMcM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=W1TT/XJA; arc=fail smtp.client-ip=52.101.85.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="W1TT/XJA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nQ0msimck3a9MXeGGXM0o4BSb1p+VnfmhqTLPAMzf+bn9xDdJJhzsnd7uZaOUfCzL6gbAGYcsfeqxCnUZZEBVizGwczQcuQ4UVNLhX61yjrkddTVujPmXLoqpleofaWTyvfcPOinRNbqaZF/t6IBsSUEKnrk07hh0UNIe1Z7q3TCK37QHaZxCn2uzQkfA7S3ERoCmMbTsu1Cdn9HWPBE1l04o+N7NrRqN6HvMjE9jUOESxCiImNDwwElIW6Yo9FRzoWX6kkRyNwqGb+LHI2PaF6Q5vhDMtY5PtdGAKfBNMoq5w0x+xxRe1gdgpwgrdEPTcnDnbpETr9oHQTL9aL/Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OFFCLEh61YJYcReWClWUh9U+C45pSkuR7GCJx8igCro=;
 b=F0bSUAcoAwDebwPxrtdoh1XZsUcxL+rR/ImUJcX895YU75BRqSpJfxFyAvlBp/V1i7TalMyExMZpT3kTTIy2HxoRaU4OZMeW3houLfskgtcz/gouFxpsVqJ7zB0pL74CI6TTzpNtykspvQEXe3r8ckwaV9T3atyZHBu5ZZpw+6HJuzKlyCHOEHdtlc8lEZ+niRcbpM1SiDQhyzznu1/5E1pOZI7ZwTmHZDZWjipkE70MekSNm3lWnWLTl1JQO5edJxZbqQg12baicYOX1dxdxF2EUK7HIFUtulhKMIuq+VDq1KrcvvbC9GA35QljRQWxcpj12AZNjfPGhw2j8xOEkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OFFCLEh61YJYcReWClWUh9U+C45pSkuR7GCJx8igCro=;
 b=W1TT/XJAyATEKUoxoZdC8A/sd/tYEI8YjCTWh9TbqW63u8+LSbXi/v5oRTZYwu5cCisshgUHzouiGqADG3GJUmqH2ABfkjoCZsHvNI+T+E2+cBJFL6WfWQ1kjCoFJ/h43f7m/3oJBkgrOtMu+INT5G2DM8gt4m4lNfGHBioiyE1uP/1ojcx0+PZp7ptSeqAkqG4xk2PCqDtOyASYuWHjPe7DJbaxSzYSkUC+7HmsPbblaugoc36dD2+Nfzex5Dyncd+KAbaz3Eg1FJsdHh+GcG4FaeFH2K8wdFVB8YvZDZknBjM5ZSYNf9kfDZUnhxGc4DvTqlSvT9Q42GCNcMvwWw==
Received: from MW4PR04CA0189.namprd04.prod.outlook.com (2603:10b6:303:86::14)
 by DSWPR12MB999175.namprd12.prod.outlook.com (2603:10b6:8:36f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.12; Thu, 17 Sep
 2026 18:10:52 +0000
Received: from MWH0EPF000C6194.namprd02.prod.outlook.com
 (2603:10b6:303:86:cafe::8e) by MW4PR04CA0189.outlook.office365.com
 (2603:10b6:303:86::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.12 via Frontend Transport; Thu,
 17 Sep 2026 18:10:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MWH0EPF000C6194.mail.protection.outlook.com (10.167.249.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Thu, 17 Sep 2026 18:10:51 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 17 Sep
 2026 11:10:22 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 17 Sep
 2026 11:10:21 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Thu, 17
 Sep 2026 11:10:15 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>
CC: Boris Pismenny <borisp@nvidia.com>, Carolina Jubran <cjubran@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>, Daniel Zahka <daniel.zahka@gmail.com>,
	Dragos Tatulea <dtatulea@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>, "Gal
 Pressman" <gal@nvidia.com>, Jianbo Liu <jianbol@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Lior Nahmanson <liorna@nvidia.com>, Mark Bloch
	<mbloch@nvidia.com>, Parav Pandit <parav@nvidia.com>, Raed Salem
	<raeds@nvidia.com>, Rahul Rameshbabu <rrameshbabu@nvidia.com>, Roi Dayan
	<roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Steffen Klassert
	<steffen.klassert@secunet.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net 4/7] net/mlx5e: macsec: Track hardware object ownership for SA teardown
Date: Thu, 17 Sep 2026 20:54:30 +0300
Message-ID: <20260917175433.4090878-5-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260917175433.4090878-1-tariqt@nvidia.com>
References: <20260917175433.4090878-1-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000C6194:EE_|DSWPR12MB999175:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ee977ce-4ae6-479a-91a0-08df14e701f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|1800799024|82310400026|36860700016|6133799003|22082099003|18002099003|11063799006|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	IdH14gWaK1AKdedJbdWxL08P146ChBpSKYaaO3HYbLYkBhpiieLQkarRUYEINPC0OY9YKmT02oBqf55FMxM6Kc37zrjS2prTUFgQKO6AHm5d8/Ku2CVE0xFL5E0CPLI/4MSSBIbIAKEeHGr/cSclvrtBB/W2t69Yf2IGbjBLJLAtqJxH/fNvoQDGu++TacI7Nis4qE6W3KK4z8e5pv55Jim399W3XTCuKUp/PoCFctiP/6DtWwuM4/LH58IYRC/sc8Zf2geOJAyF4J+w1/e8eY6xNwuOkUUxEGcX9zE/Iokhuv+6bBI+nMIMl0gO4HncEeP2rgn8VE7tIVNZ97Ogh7JL2zXruLYEaNq3J7hvYCd+6R03qYZxRmrpFY9fbHb6MN7XycDENhfltQCCF6Mh7Mfz6JoRAC54NEgsPyMSRZ51GJeKfh2LYYhv+iIaxDDeOtMx+GeEnfPoGVeK+VN96zb6i5y2hjw2Ju2NDk5pLvgzei+koF6gOwuLNy26GdaSOs0QWBuzp/I1RLYgscGbOLunfFsJpYtz4ExClyWAooMXA6kWrQIH9G2KoMvH8Dy3f6bG1MPcXaar0sPU2H/Zgv9+umDC/PBLsfJRugT1DJgYe1ZvB9I18u8GCIt3gg5OAFZHSNN9trev9cBP13Axt+/ODORiUXEXvcrlMa153V89h1urAmiL/YOkLFhowxo1VDPl41RWPr0iLywA+swKSA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(1800799024)(82310400026)(36860700016)(6133799003)(22082099003)(18002099003)(11063799006)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	W8fXhGFVV2SgQyGMV7uPOLQAuDglXHfubgsIwnoByU0ihlF+zrRxwdwtYFXrO1CGdLwHyD5WYg1/FwP8Rp8H6btJtdNx90Si0MMAds4Mr+r8aHUG6kd4IQ7X2suKIk0VSXeX7ASOLmHy197oMpV7KdLKasz6A7yTClralmO2xT+nTa8asx7+A731D73vtlz5ZaekZiyue6YVoHT6cKZWfY3PAwRUgLNMkTbyn0u/NWb9Of/xSjr6rXE7eRkuF2EztyTwLVOBvS0zxi0btqdYuNO2kijvz5gcv7KYCPQ+pDMGKZnDt3G8QQf/tgwnG30z18EBzSfp8Wt68V//fXV/ZbeUaAn7ZtfULLUK9FMP2xRjiVPjha55DvEeS6c+PMTCo2g8sueyCExAtvJNlMhax0BhilxFO/dhrAJi/6DcD48LLacoB4JpWoMVWW3jfB3I
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 18:10:51.1329
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ee977ce-4ae6-479a-91a0-08df14e701f5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C6194.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSWPR12MB999175

From: Cosmin Ratiu <cratiu@nvidia.com>

A driver MACsec SA can exist without a hardware MACsec object. Adding
an inactive RX SA or a TX SA while the SecY is non-operational creates
the encryption key but skips MACsec object creation. RX SA deactivation
also destroys the hardware object while retaining the driver SA and
its object ID.

TX SA deletion and the SA teardown performed by RX SC and SecY deletion
unconditionally destroy the hardware object. This can issue a destroy
command with an unallocated zero ID or an ID that has already been
destroyed and potentially reused. Failed RX SA activation can leave
the same stale-ID state after steering creation unwinds.

Track hardware object creation separately from SA activity. Set the
ownership flag after successful creation, clear it on destruction and
creation unwind, and check it before destroying the object during SA
cleanup. This preserves destruction of objects retained by inactive
TX SAs while avoiding destruction of unowned objects.

Fixes: 8ff0ac5be144 ("net/mlx5: Add MACsec offload Tx command support")
Fixes: aae3454e4d4c ("net/mlx5e: Add MACsec offload Rx command support")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index daff53ba7d09..20eec345b36c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -58,6 +58,7 @@ struct mlx5e_macsec_async_work {
 
 struct mlx5e_macsec_sa {
 	bool active;
+	bool macsec_obj_created;
 	u8  assoc_num;
 	u32 macsec_obj_id;
 	u32 enc_key_id;
@@ -331,7 +332,10 @@ static void mlx5e_macsec_cleanup_sa(struct mlx5e_macsec *macsec,
 				    struct net_device *netdev, u32 fs_id)
 {
 	mlx5e_macsec_cleanup_sa_fs(macsec, sa, is_tx, netdev, fs_id);
-	mlx5e_macsec_destroy_object(macsec->mdev, sa->macsec_obj_id);
+	if (sa->macsec_obj_created) {
+		mlx5e_macsec_destroy_object(macsec->mdev, sa->macsec_obj_id);
+		sa->macsec_obj_created = false;
+	}
 }
 
 static int mlx5e_macsec_init_sa_fs(struct macsec_context *ctx,
@@ -396,6 +400,7 @@ static int mlx5e_macsec_init_sa(struct macsec_context *ctx,
 		if (err)
 			goto destroy_macsec_object;
 	}
+	sa->macsec_obj_created = true;
 
 	return 0;
 
-- 
2.44.0

