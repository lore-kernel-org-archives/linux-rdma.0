Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.22
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794405467;
	b=1VL+JEI1Npr2yAEEWeCgy0XS3BAC/ghwRlJ+j1DNKHz73w7nvKhDflx4h4r8m0VhC6XR
	 hA0jmo4dv/KVKBV8NibXOrOhuIuKv5ovBpmjYN80kSmFLVH1rxeKV5SY2jcbNa6MeK6TR
	 dUrPpr2aD8uwblRiHAhHyAaBeFDADTT0aIxhnSrPZobcbRtnlCKWbmjBMit1nSDalwXrQ
	 9bZaENTwZTldyXCoAx3rG4JRIpMwW+RnBnYHP/J4+JmOekNlR1ol9k9H5J3BJGFEHXGCy
	 4hnatj8HJn7FKy0Dp8dowkgTWy3FI9iG26IMpSqDtWSa2kqbv43l5aLWiCdS5nKbdvw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794405467;
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
	bh=z5o9RyO9Ne1BGMp/eSAc9Uk/NNH9hV1Wsp6FFZ/IgJg=;
	b=fSHXB8xgUhGjoHScSxcngbCGJ56PbdjBz/OqXxqlKPusCvwSyehkqehDkDFKAioJbjZX
	 YnSpaFSFmfcXO63OYAI5ezgpRbt3HyIuFmvZLyCi04UQjHuEikpSDPoQgSzDHca1vaDy7
	 Zpt9pt8fhjhnlkH0qBQQNVKG0L4IdptDPRictW2UjYhcLz6aXP24AImAP65FPp6vWstk2
	 b/po786fPvd28VulFIgPw8DhsyZzdxEuKoO+d+CZbeyWRfTvPVDnmyNdq2MiOFi7WJzZB
	 Yc0ZzTduStYQB5ZrSXtFY/SA++MgUlyvQJrzHaIRtb6aKl91rSDM8uLaVlHtVM7L08w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=qkmmcP+x;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.22
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013022.outbound.protection.outlook.com [40.93.201.22])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48010606A327;
	Wed, 11 Nov 2026 13:57:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 48010606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=qkmmcP+x
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lLkO9fCulXbg4xySs1qdcJ2RYaFWswNTQ8TymWcrUrWcCVqtV7AEL0Iqnvu6W/tbCTStdhxNE6bnrojO+jYkWoWZPQFEG1BVr1hpB5XwYpI97ZankfzdppasvSj/pZg9Zier+0FwMuGviNcIQ2Qw84aLVlthOCaAYi8BDTJaLK1ameC5oxrz5xXm5nVGCGnVTyng8Kz4MNKYpty9/ghy5LH/mCHh56sv/gr2SiGQpd+Lk7VznVm0x51vwh8FyRRJpm3C182y2GyczIXCrkjM/vfrPtX4Y1oqZg3zvs6Q7Dt/+8CS0Xp6t3x/O/YJO3aoJFgdN23TfosLWGKjdbpNNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z5o9RyO9Ne1BGMp/eSAc9Uk/NNH9hV1Wsp6FFZ/IgJg=;
 b=e6UANPH82tDSdr6We1kxbmbMxWfVNPWArM9zcbLRs3l1R5xLldPk2w4c5o1J62rzHw2VupSS4iiC8Ky1eXDHI8HfpLMr7wl0tlaKoB0kKON07xeXUe46+rIXe00ILg9PDBUNhRjvdHRLwn6rMv/J6Klf7Ig1DJSEuLM7zx48dOaT4wFY/Wa1PeRL2Q5C+MGoh/70IuLOdE1uBSTHL3kzruoAig2SI0ZkZJ3YFnlf0FRR2yZmDzcgKRxNBzwq6PV4ZyM2wmK8k3xjfLH4nhX0y/6D+W/2DCBC7IOq/A5EQE/H4ssS0sIv6YheXogNFBChU6b6F60LYQTc88KpvJT2Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z5o9RyO9Ne1BGMp/eSAc9Uk/NNH9hV1Wsp6FFZ/IgJg=;
 b=qkmmcP+xSdeu0T8RjiZbagoHzdgyBTD714u3/uSNbpmU1ZWzcH05ZeZy8ZQm/1aPe/ttTiefMICVLNaN67r/0MF5z72a6mCaIzaO/W6CDjjEp27gZi/kxPQhr56R4FRqH0jAtyQtJIBBP1oa5iL32JeG94L0EW6lQ/HkUbr8XqTGnAFAPYIuaTDeihc/baIGyoBzdsLNsfVltifnhjbEEWhJCdKp8RfRMkUtptjSE6WOsqm+hCEbtXa7TQPwe2JqbI/IcAq3xm3O5pur2Ae3g5smXJH/vxZXQHykk/cQuFu4thOwUKqYOA/G1MZUUYLkspD8nnseG+tUoxp1a5Wmsg==
Received: from SJ2P221CA0011.NAMP221.PROD.OUTLOOK.COM (2603:10b6:a03:5db::7)
 by BL1PR12MB5780.namprd12.prod.outlook.com (2603:10b6:208:393::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Wed, 11 Nov
 2026 13:57:39 +0000
Received: from MW1PEPF00018893.namprd03.prod.outlook.com
 (2603:10b6:a03:5db:cafe::a5) by SJ2P221CA0011.outlook.office365.com
 (2603:10b6:a03:5db::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Wed, 11
 Nov 2026 13:57:38 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MW1PEPF00018893.mail.protection.outlook.com (10.167.249.170) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Wed, 11 Nov 2026 13:57:38 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Wed, 11 Nov
 2026 05:57:21 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Wed, 11 Nov
 2026 05:57:21 -0800
Received: from [192.168.122.1] (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Wed, 11
 Nov 2026 05:57:18 -0800
From: Edward Srouji <edwards@nvidia.com>
Date: Wed, 11 Nov 2026 15:57:03 +0200
Subject: [PATCH rdma-next v2 2/3] RDMA/mlx5: Fix DEVX UMEM mailbox size
 truncation
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
Message-ID: <20261111-devx-umem-mailbox-overflow-v2-2-1e7ca8237b58@nvidia.com>
References: <20261111-devx-umem-mailbox-overflow-v2-0-1e7ca8237b58@nvidia.com>
In-Reply-To: <20261111-devx-umem-mailbox-overflow-v2-0-1e7ca8237b58@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, "Yishai
 Hadas" <yishaih@nvidia.com>, Yishai Hadas <yishaih@mellanox.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Edward
 Srouji" <edwards@nvidia.com>, Uri Dar <udar@nvidia.com>,
	<stable@vger.kernel.org>, Michael Gur <michaelgur@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794405431; l=2654;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=STcnDf71pLSRJuV0rL1IhU+cnSJlXapt5E9+HQuAsMY=;
 b=mD4AN8tTqodWyQWsGHwfVBFrRXgCaD45GG+/6wV/p1u+elKMsXaoPiTFwAyCvL/RwgKfisB5B
 FgZzgsRnDaqAHKmaeaABz5YumJ20OWWg4WJwhPf7C4Y81n/UVw64dgb
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW1PEPF00018893:EE_|BL1PR12MB5780:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a6c9c97-2c59-4c64-ecef-08df3ffbbf2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|1800799024|376014|36860700016|18002099003|22082099003|56012099006|261028144727099003|261026140227099003|261022105027099003|261102123227099003|261021121427099003|261021123027099003|11063799006|261009223027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	U/shJweBASfzvlRHjidsqFS1tgyrzyV7/RevVa+YkhAx0Mb3SaK+ivMW3FPYaJMVgWaMGtCepwaOZPzBv8II6//HgqoQRdh0fAe3wsAag6U8+uZMSdTmcYrKIpBWGNK1QGuVCSaCfgDBcPIuk6hEPvixpBRo0bCwTPRAPimGrr52g5nTZltrC0uO6KfX81kL0am1jZoC5duhhIbNUlWTq7WI237XCAFgwzAhUs5wsWBN076clgt2zI8U40Xqh8gpX8Y0bCve8TbguLDcdy/Doxp7wgsYgpFt80o1WSH27mkKH2TeqL2fY+qI61hlG6cYXRmmjxiG5mWm6yIdwNKhuCUUbh0oTeqB8bvq4PKqT1RhvIdhjvRznrO8sTqa8kTef2Bwi5W8/VffcM2PJA0MoeJDu63Fp/hjJrdq0Pq3nZw4acS7A6Ju5pZUH3G78kER1mIfwPVHeteNd6J5T2wiYWdDnuEDtsIv79a2HysuHTNWOcte+U90dCG01WyEIUggK8mG77Pb/yQyAPu8Gzoqb90mYnDon/0yOVCJCSAYrJhAqEqtb6GHwfCTR1mklDw87RYX8U/GLmV3E/1XTQeX3tfb4KfamnmUvf3t1qKH01ysud2Zvc8sDar+4EwMHrOXKgct/FzfBanRTeHfKTvSz8De1/xM+6F4mt3zMwtUE9oyuStyGJxcTZEf73C+54azjjbAK595DV+19C8jg4sUWg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(1800799024)(376014)(36860700016)(18002099003)(22082099003)(56012099006)(261028144727099003)(261026140227099003)(261022105027099003)(261102123227099003)(261021121427099003)(261021123027099003)(11063799006)(261009223027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	osQJ8xCfofrXk5O/s0DtC03bJS9na18JpvDE+yTazMzCZYk2xETFW5MujQ7Ir3e1ucRNzfgX615zIx2ww//xMfhLzWh9P2/cN4tEzK8R9ndUAOJWEcniveadg0BOYTJO7qxA9vixHCr7zDKutbppFvSCjtOWccmF6cTCdDzVdBcko0XDj7UWu+GzI0z/9WVk43XlrLm0vG5kOHqDmYHHsGZKz/uyoR0R5WynrqL+JpWIuCqOHdM9gt8aLFXDRoefq7AiFXNM24v5Rw1RGvmELiQU9YJOivmdmAof85QtleJIunW7TfEcQ47yPWwYLrsc3hcqtr80VuIbIVzhAZuCcoqwyFwEyhZ18NBKMz3OkmuaurhbSGp4v2VaDxnC+SRZ0OXUdD5pBmwpzWH1zbZEFe05FfR588q0QqFSCX7oWicw487/sNMznBdRxUy5xQL7
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2026 13:57:38.5954
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a6c9c97-2c59-4c64-ecef-08df3ffbbf2e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MW1PEPF00018893.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5780

From: Uri Dar <udar@nvidia.com>

devx_umem_reg_cmd_alloc() stores the CREATE_UMEM mailbox size, a header
plus 8 bytes per MTT, in the u32 cmd->inlen. The number of MTTs is
derived from the user-supplied length and pgsz_bitmap, so a UMEM of about
2TB registered with 4KB pages wraps the size, the mailbox is
under-allocated and mlx5_ib_populate_pas() writes past its end.

Compute the size with the saturating size_mul() and size_add() helpers
and reject a UMEM whose mailbox exceeds INT_MAX, the largest in_size
mlx5_cmd_exec() accepts.

Mailbox sizes within 512 bytes of INT_MAX still overflow the block count
in mlx5_calc_cmd_blocks(), but the command then fails with -ENOMEM
before reaching firmware. This predates the change.

Fixes: aeae94579caf ("IB/mlx5: Add DEVX support for memory registration")
Cc: stable@vger.kernel.org
Signed-off-by: Uri Dar <udar@nvidia.com>
Reviewed-by: Michael Gur <michaelgur@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/hw/mlx5/devx.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 6c34f2c2a91d0be26352100c243f24789feab3db..030aa2cbdc2a7a5d0148de6af1bcd929ac7e444f 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -2338,6 +2338,8 @@ static int devx_umem_reg_cmd_alloc(struct mlx5_ib_dev *dev,
 {
 	unsigned long pgsz_bitmap;
 	unsigned int page_size;
+	size_t num_mtt;
+	size_t inlen;
 	__be64 *mtt;
 	void *umem;
 	int ret;
@@ -2365,9 +2367,13 @@ static int devx_umem_reg_cmd_alloc(struct mlx5_ib_dev *dev,
 	if (!page_size)
 		return -EINVAL;
 
-	cmd->inlen = MLX5_ST_SZ_BYTES(create_umem_in) +
-		     (MLX5_ST_SZ_BYTES(mtt) *
-		      ib_umem_num_dma_blocks(obj->umem, page_size));
+	num_mtt = ib_umem_num_dma_blocks(obj->umem, page_size);
+	inlen = size_add(MLX5_ST_SZ_BYTES(create_umem_in),
+			 size_mul(MLX5_ST_SZ_BYTES(mtt), num_mtt));
+	if (inlen > INT_MAX)
+		return -EINVAL;
+
+	cmd->inlen = inlen;
 	cmd->in = uverbs_zalloc(attrs, cmd->inlen);
 	if (IS_ERR(cmd->in))
 		return PTR_ERR(cmd->in);
@@ -2376,8 +2382,7 @@ static int devx_umem_reg_cmd_alloc(struct mlx5_ib_dev *dev,
 	mtt = (__be64 *)MLX5_ADDR_OF(umem, umem, mtt);
 
 	MLX5_SET(create_umem_in, cmd->in, opcode, MLX5_CMD_OP_CREATE_UMEM);
-	MLX5_SET64(umem, umem, num_of_mtt,
-		   ib_umem_num_dma_blocks(obj->umem, page_size));
+	MLX5_SET64(umem, umem, num_of_mtt, num_mtt);
 	MLX5_SET(umem, umem, log_page_size,
 		 order_base_2(page_size) - MLX5_ADAPTER_PAGE_SHIFT);
 	MLX5_SET(umem, umem, page_offset,

-- 
2.49.0

