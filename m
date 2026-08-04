Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012011.outbound.protection.outlook.com [40.107.200.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D5A43BDA4;
	Tue,  4 Aug 2026 08:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785832714; cv=fail; b=MIGhBGS/joXkDCrBAGlzzv01tOK0+f4vKB0DbNQ9UYqfNJBPqYI95s5V0ezEUNfBpEwAbu12lMtiQJfRxJIqM0Lmvv0x8GSwBANJnUujhBJhB2DyiAHFisoHefDi7lDddtWNu9aTT+B3QtRmMNq9dxDXTr4rUr4Alt2tyiTFeXQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785832714; c=relaxed/simple;
	bh=bfQNML775xZLqEJn4AMYO8JSu4/oE1+GqAuSjn22hSY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mWGXv7e77KD6/57nMYwUrpVcszJCeckeZWP1nHjOIIszLZx2YgoKA7VOG48C8tEJYeFkKqotdu7iVWBL2+OVE5tWL63+dTaoG2K61Xc/2UR46Aish7ifzWYSy/AqZklFjgp8Wo5woJJrELuj2eITix/abwCQpDmj78x3qS7rchg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=md36TKyt; arc=fail smtp.client-ip=40.107.200.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="md36TKyt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nnn/5omlmjBV1dfTAfaWBpfv6budyD1UBZzYVNLINAwq7ALumn1rwYlX5nh/pNMt9Za8HymBkySC9R2s228WWUPSuvYWpDCDW4yd4Kut9Jzo0J19y6lUgg41LUZlCBT7nS6eWuw1urbs+Ghq64PijrYROd11hoY11uC5oc48CTcudc5bmZTxpwQRIed/xgOHRnYxTrYmh4oN5P6chz7+0xz4wp5sukE8ytYkIdXKYfdtVEBOvXMhFkTgf2Wm9/tMGSwhNCU4ltpCo8TvEaxSZHHB/Ojbe2REvFmr/HNno+qY3iEAcCSH0T+uCiawVniqlmzMpH1hCSmRGlDxlAJ1dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7FfU6jR0F/JKdkyoTFATa1lhB9OBmyV3xWJnz4QGDs0=;
 b=RgDXEyiaGUUkBmIQJgV2OcU0prXzx2UT0UzGIxENLawrXDMXoU8p7LAA21/P/rzTj6k5l21GTbtoTDDCXZiqCbi9RnVDKMms7FzBCFUqh+2tUBoVBj8NFZiNM7B1GsdeM4LrnZY0C/P36aWrFBNapluTc/eaQeEUKBk0vS2CiZLVoGGEUQj7Ee+eCEUxOOdq4zpmn/5vJRrNjSkjj2aMIm1RU+cZ1/GU4VVcCLC/3efjZEnlUfVWqVd1/ivzDA4r/oF20UZbj4LRBErBgodmsYe6elaP0HdZE666Wuw0nnfGsO2Rg9Oc2nDg6OloRbZow/lRkJqkBnlerMuzuCjqrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7FfU6jR0F/JKdkyoTFATa1lhB9OBmyV3xWJnz4QGDs0=;
 b=md36TKytpaDuvIzyhY/LReAjpywreudcjkR1dTsn4uhtXLNWnMgzlQKgQ2QcJNEtxCoxjG4t/WdgwzqWrjF9ve0+akjK57SMOTdl9tGndFsqu0LqFvNOzTRy/fXV3y2/QrEvdvRHjxvhIA6nFivMXn8TSYtFtcOOwv2Ib02waQsqHl6QVwQKEGKmBm0Eogo/qJBexfvco1zOkjKdfXdQA5PGkxMIj80xEbCvNe6EG/4FFH/tyTHCGy2KS5mYKAQpEDGPdsPHXnT0EA3zsUlFGYGyPKQA0zwlQ0i2JjeWOMGDK95zrJ4H79dNMnuRmVEGVwW76TUDf2AXNMLNuqgwHA==
Received: from SA9PR10CA0016.namprd10.prod.outlook.com (2603:10b6:806:a7::21)
 by BY5PR12MB4097.namprd12.prod.outlook.com (2603:10b6:a03:213::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.15; Tue, 4 Aug
 2026 08:38:24 +0000
Received: from SN1PEPF000252A2.namprd05.prod.outlook.com
 (2603:10b6:806:a7:cafe::27) by SA9PR10CA0016.outlook.office365.com
 (2603:10b6:806:a7::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.17 via Frontend Transport; Tue, 4
 Aug 2026 08:38:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SN1PEPF000252A2.mail.protection.outlook.com (10.167.242.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Tue, 4 Aug 2026 08:38:23 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 4 Aug
 2026 01:38:08 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 4 Aug 2026 01:38:07 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Tue, 4 Aug 2026 01:38:00 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>
CC: Aleksandr Loktionov <aleksandr.loktionov@intel.com>, Alexei Lazar
	<alazar@nvidia.com>, Boris Pismenny <borisp@nvidia.com>, Carolina Jubran
	<cjubran@nvidia.com>, Chris Mi <cmi@nvidia.com>, Cosmin Ratiu
	<cratiu@nvidia.com>, Daniel Zahka <daniel.zahka@gmail.com>, Doruk Tan Ozturk
	<doruk@0sec.ai>, Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman
	<gal@nvidia.com>, Jacob Keller <Jacob.e.keller@intel.com>, Jianbo Liu
	<jianbol@nvidia.com>, Kees Cook <kees@kernel.org>, Lama Kayal
	<lkayal@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, "Patrisious
 Haddad" <phaddad@nvidia.com>, Raed Salem <raeds@nvidia.com>, Rahul Rameshbabu
	<rrameshbabu@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan
	<shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Simon Horman
	<horms@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, Stanislav Fomichev
	<sdf.kernel@gmail.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next V2 10/13] net/mlx5e: shampo: Flush session on PSP mismatch
Date: Tue, 4 Aug 2026 11:35:32 +0300
Message-ID: <20260804083535.2946459-11-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260804083535.2946459-1-tariqt@nvidia.com>
References: <20260804083535.2946459-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A2:EE_|BY5PR12MB4097:EE_
X-MS-Office365-Filtering-Correlation-Id: a1bfcaa8-1486-47c2-cd9f-08def203bf0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|1800799024|36860700016|23010399003|3023799007|18002099003|22082099003|11063799006|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	gorABt3QXyUi+1MLCJi61KD46cdzItwBD+qdcWwW0vZ4BSQX3c/F4khrLvYznW8H92bOUDpx9rHm72sXbbVG1vp+7KWHfW5+eUuE8V8QL9ydm4iumAGErGLl6egQKt4WaVWmhNmnMUI64GMA1kVPObcIfrM8wbrOKv8LAtZlo837r61G3Km95+h0iRKQZ49sPHlPjva67MsOlDmCN+ckm5KsDlmIJr8b36oYv4/9RBkeVIMhaHXI/qfF4n0ZCxKvOSoKHkRdBbSPnIrt+NwyIv75To7fRnpiCanp9TpIVzN27Fk7bPhg7inoIiolBOEc3mwVZT9rHcR6liL0t1gWKAAsTRYX/+kEO16RR7OMCaPumjzoQSdOgpyeV3U51RheaCipd1711ptLmDJTm6Ksis8tIytvgDvZmELzzhOPK8q6cnmcm1Y184HVJG7ZeunL1R/deZaX9l6bINAPJrwwNisN3YTzvWORl46m1+jtEayAPycv47kYj7nwXrsHj3veyEp1pAUZJ3dqWcU1rdwhK0vWeniUhj2lI0HIdywyDLNAHeVRSnWnStJR4ziLffB16/JNHdKqsIHpb017cBBsXBwuL9GlFoWwMVT4+s+YpHvG0+BbOVa5VVOjIsqroPerf6SUNUgzr2GKzL58FsXHaeJEeIx1mOdvFVXBeZmkxfYW8ZYKPHu9uxsW3kC1zGDFCFn82cESYMIwQuQS6+XQTA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(1800799024)(36860700016)(23010399003)(3023799007)(18002099003)(22082099003)(11063799006)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	GyEqlHqpzwVixXPrdrAj0hebgTaWeyQgVAeV1SDIMwyabpmoC1BfoVfaRK+I1lT8xFFtrH4+edGiucAuf3S+LiPziaBe2j3MMq2eub3hD6yYKL3ii73H4aag+UBTkKYf5laUnveN/YF/jnWB8ysFly4aK3QQ5rZ1ALpYG99uZNJHeRz7+D+dr6ZllMr8aq+4N6mFxQKtdj/IIoBMlCymPnJ1d6fiGnhcrrBDZQ2JXeAlSC/uDlHV8RF5ZYVLwaL4+hdYBJL3HYKJ6CeR0Yw0k3vcpkFR/6sh7sgoPyGZF86QLLss855qQ2Zui2Mcr3Fp2reuqfu4BI7TXhIZaC1yYSj9BJwxbkuzuGPE/nuyZ0PVjcDm/rB4cUCMfzzs8ocC0RHQFL8dTb+/NmYsZ/kaonsGvroZhKd2CThplfNQ49q9reIs/v92kKbyGdPGAaH8
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2026 08:38:23.5953
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a1bfcaa8-1486-47c2-cd9f-08def203bf0c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000252A2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4097

From: Cosmin Ratiu <cratiu@nvidia.com>

Flush SHAMPO session on PSP status change (no PSP -> PSP or vice-versa)
or on SPI/version mismatch. HW aggregates by 5-tuple but is unaware of
PSP fields, so sessions must be terminated when security parameters
change to avoid mixing packets from different PSP associations.

The session is also forcefully flushed if non-decapsulated packets are
received. This could happen if, for example, the decap table could not
be created so HW GRO is active but there's no decapsulation.

Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 32 +++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index fb7110b1b683..c7eaab3f7967 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -2221,6 +2221,33 @@ static bool mlx5e_hw_gro_skb_has_enough_space(struct sk_buff *skb,
 		return page_size * nr_frags + data_bcnt <= GRO_LEGACY_MAX_SIZE;
 }
 
+static bool mlx5e_hw_gro_psp_match(struct sk_buff *skb, struct mlx5_cqe64 *cqe)
+{
+#ifdef CONFIG_MLX5_EN_PSP
+	struct psp_skb_ext *pse = skb_ext_find(skb, SKB_EXT_PSP);
+	bool is_psp = mlx5e_psp_is_rx_flow(cqe);
+
+	if (likely(!is_psp && !pse))
+		return true;
+
+	/* No match on PSP status change (no crypto -> crypto or vice-versa). */
+	if (unlikely(is_psp != !!pse))
+		return false;
+
+	/* SPI and version are only available in CQE metadata for decap flows.
+	 * Non-decap PSP cannot be matched here, force a flush.
+	 */
+	if (unlikely(!mlx5e_psp_is_decap(cqe)))
+		return false;
+
+	/* No match on security parameters change. */
+	return pse->spi == mlx5e_psp_get_spi(cqe) &&
+		pse->version == mlx5e_psp_get_version(cqe);
+#else
+	return true;
+#endif
+}
+
 static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 {
 	u16 data_bcnt		= mpwrq_get_cqe_byte_cnt(cqe) - cqe->shampo.header_size;
@@ -2258,8 +2285,9 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cq
 	data_offset = wqe_offset & (page_size - 1);
 	page_idx = wqe_offset >> rq->mpwqe.page_shift;
 	if (*skb &&
-	    !(match && mlx5e_hw_gro_skb_has_enough_space(*skb, data_bcnt,
-							 page_size))) {
+	    !(match &&
+	      mlx5e_hw_gro_skb_has_enough_space(*skb, data_bcnt, page_size) &&
+	      mlx5e_hw_gro_psp_match(*skb, cqe))) {
 		match = false;
 		mlx5e_shampo_flush_skb(rq, cqe, match);
 	}
-- 
2.44.0

