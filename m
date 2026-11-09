Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.9
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794235392;
	b=fuF3bGatUpTEHVcbXXN7MPqkAZoY2n3qBowB8ITTYv+M9A80+veAshmfmqmhnWANDnKY
	 2ABVKIp2P/OW72dzdUZNRUes6XONJeS/1tJtLh2lI7rybg8c7ap5VdGQLUbdcSE96sls1
	 3QiHkFg9v5FUDh9pBSajrxcoH6V+5ILCN46Xkr4Jy41pLJ6hB5NTn6tejoZeImBNxUYqf
	 1IPOEulR1sw9PVvHi3oq65dDJ30XErPb6Np03abcnzSMCp/eIex0T7fnrRRHm9nO8i/m1
	 rCxsl7NORRicaQGexM9XEL07MqyIJnNmKzSlYd1dqojKExAz/FLeYOJxokKdkn0LUzw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794235392;
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
	bh=0ETuD02BdCbIl3hDTRwbhFwINmlR7ucIqKRMzNCFJpM=;
	b=ZQigRRPoRPMfDk+fsDmmP8VbUVQlKz/vF7dn/FADUmoN+D0eOYbDNrK+ur3yMqwIB+ve
	 2xvbjdLrQcpmuxeXBOUJi6J8/wesTCS+8ZnXMAqYWitTHDP8RkrDD+ulhlBZwVbWELG6s
	 uQLCREqbp5pvFS1/QXOxEZbftq2p6rpBKOwBXC970cHwOkTtJhsLVSfoKlyAX2qPir7L0
	 XuvknpAsCLM5GP0zG4T1tQ7wC57Ueb1j0+tu6dW/OcBwRO2chOhLjpju/3GFGprWBBsY5
	 NJ3HxX/VvfV4cigTV2t/cLN8HIFy1sq0j4YxKGnjAGspj/PTVHhGDberE3+1hrqYIfA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="V/TIy1Pi";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.9
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010009.outbound.protection.outlook.com [52.101.201.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8EC606A33C;
	Mon,  9 Nov 2026 14:43:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0D8EC606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=V/TIy1Pi
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XQdaPtYj9Fbq0eZ8Epp7/JgpSj6E/YmxGYRmAbs2abqN5ifF/pA1Tvi0QHJe9T4oKAcGRkJ1ZwgNY+wsrgTcJRJpmZzJkRiGZDV+3vBembKSoqD0jYTVQ+O9UNQyBbSwjrfYIVR69oXURvj/Gi8jYpuOPDawgQV0fCrCGhLDGkrhAQey2w4VqOZi9DdJ+Aa94hNWWO0w0WtYBEV1TL3yinBn7a/N3LJ8nOTVeHTAu/lmNmVBt+vqun70IPS9tVIY5jLj2nfXw8croByxoSMN3466kDs6Gefq72+JDVZ9nDlRVQOO8Ef12FEvRRUUWl9QsoJ6WAf69ouY7OSX1w3jdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ETuD02BdCbIl3hDTRwbhFwINmlR7ucIqKRMzNCFJpM=;
 b=pR2rDiKkvqB9RgK/vKSR+7ik3btir1MBUmgyrAYv6lo6HFv/uJ8f6wVjzPWzuG8cKOQ5l4l3X+i9XNkqLG+x+xCw9tKJFHvwt54NEWCROGz/e+wpK2AbAhtM7EZThOrqGSuhzPfl5fa6v9UJkHZt3ySieglayEvygiZhtn3GyyfGUqAQXxHLAwwGngmY4vEl7toG5tqaI+xHp5LSj11hS92T9zBGVLmWQvzRSNPU3zV0ZLgX9nz73I+76xYd1xBDHoFWeXXC8DBNGf+6aHVUWwN8R9VLfHe17Co5gh2AtVPiqSSpWNdxx6ve472epMp1T4J2Wa79f/ac6/dZB4HByQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ETuD02BdCbIl3hDTRwbhFwINmlR7ucIqKRMzNCFJpM=;
 b=V/TIy1PiTkycUl+9/dT/jw5aD99xxs9Y5TRFH5RAmfFFUCTg3wlc7FPa2MbuzXBH68Zr81G8qDCmhuYzI+JkzkYlahA6ishfT659mewoYTOkodtDRHpEBv20c2unhN1T9DDh5dVtHZ33rZz+3iLYjcYxs5qgj+uLpnG9F5ts8gNC47Zot9uHqcjrIalStwEEpOavNsm4hKxPVp1G4U9Q2u4mWb3ML3NS2rW4gT/ccsCLB+8tUS92YNj7IP/btYs/WMiiFurKkH83E9L1QAAaRJT8KaO3lh7yE+kJGe2V/T4tHEVbLnXr49fRMSTlH7P+cCaid9ySDuLiwqqJzvruqw==
Received: from CH2PR10CA0030.namprd10.prod.outlook.com (2603:10b6:610:4c::40)
 by DS2PR12MB741322.namprd12.prod.outlook.com (2603:10b6:8:3c0::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Mon, 9 Nov
 2026 14:43:08 +0000
Received: from BN3PEPF00022BD5.namprd03.prod.outlook.com
 (2603:10b6:610:4c:cafe::a1) by CH2PR10CA0030.outlook.office365.com
 (2603:10b6:610:4c::40) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.13 via Frontend Transport; Mon, 9
 Nov 2026 14:43:08 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN3PEPF00022BD5.mail.protection.outlook.com (10.167.248.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Mon, 9 Nov 2026 14:43:08 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 06:42:47 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 06:42:46 -0800
Received: from [192.168.122.1] (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Mon, 9 Nov
 2026 06:42:43 -0800
From: Edward Srouji <edwards@nvidia.com>
Date: Mon, 9 Nov 2026 16:42:32 +0200
Subject: [PATCH rdma-next 1/2] RDMA/mlx5: Fix DEVX UMEM mailbox size
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
Message-ID: <20261109-devx-umem-mailbox-overflow-v1-1-4a63baab25dc@nvidia.com>
References: <20261109-devx-umem-mailbox-overflow-v1-0-4a63baab25dc@nvidia.com>
In-Reply-To: <20261109-devx-umem-mailbox-overflow-v1-0-4a63baab25dc@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, "Yishai
 Hadas" <yishaih@nvidia.com>, Yishai Hadas <yishaih@mellanox.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Edward
 Srouji" <edwards@nvidia.com>, Uri Dar <udar@nvidia.com>,
	<stable@vger.kernel.org>, Michael Gur <michaelgur@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794235360; l=2829;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=Iu/9MVw59tnvrar87EmOEXsi1oneonS+L9jsDNtiAeM=;
 b=8TNMyeox3VX1Mf8W+gf/WQ4gB7IsK14wvYoJOVqFEAla1plC2CG3GdLYgq110DvzO38GbXgtr
 A/mqte48M3BBTSLwT/tJJbbhfhf9zyat2HPsxb54/M11gS4f8v1weFk
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BD5:EE_|DS2PR12MB741322:EE_
X-MS-Office365-Filtering-Correlation-Id: ecaf0d12-933d-45aa-5991-08df3e6fc55a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|376014|36860700016|1800799024|22082099003|18002099003|10067099003|261028144727099003|11063799006|261102123227099003|261021121427099003|261022105027099003|261021123027099003|56012099006|261026121527099003|261026140227099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	A5W1Nlu7sGsqfQJJcyNT8WNHyBeVhV9gmgo+QWuj5AGYk3On/vtPv84uVLgT+YIi2QEA7b+cMugxotMN8I8vfWSOssI1lg45TxzySlipP6kfuRTaZyH60F4p9J3KXcKCeUBvyNZxHVKQ3jSPUrp2tDWw9H0UEi4TqJwyiTrtJbawQESHMY8iSidrmmZfBV4dLdbWb+Q38sFoKupbUoGGK0Ai+C1shM56BSlcxdVFMaCKaQxsLKzdbbL6na+/A3S1DtjqwaZ5M/oZ1Qr9FQi7cle71/82+RZ6K6qahbrL11ttqwDKxOqd6ziN6160BGqj07apZ9rVoRAWv+7hqv/B8q/rG2Mn9jTWN0odwLc2a8EUTMsoAcf9shXzkioRZkqswQVbVnRgc+NsBKer7kfXsbobrpj9bd4kuOwnRcDjF5D7zoZ/Hnjtb4A+zl0KRkCKCXDOJlwf5N2EAFDypT8bfosIaSbd/3xRWtxhZR0Cm8q8Wz9POqjEyq/piDDvNivIJBWb6b4nvakqcnpGffK6NPOhZ9LRNWDxQFhrmY2Q5NkFpgzxS8iZTcBzW8jbXmFUNM3QSsnXAdGHdzMIbGNa5B2ynGm1TYB0d8HSwdo8audL1WdOIT/0JsmmqRujO3YYKSiPwkgpPKtLw/e3IgSqAOCWGZxvjP5a2BhR3Ud+TaNB2bxbdpOcp8ax4Hcjnfx65oqdiseUpMPRYpiN3ygaXw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(376014)(36860700016)(1800799024)(22082099003)(18002099003)(10067099003)(261028144727099003)(11063799006)(261102123227099003)(261021121427099003)(261022105027099003)(261021123027099003)(56012099006)(261026121527099003)(261026140227099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	q4EuEhVb3HRAYsCRqJlzbkcgNQ7WGMBCUocfvXUcLhCpAabmJTsf2w1N4GPvI8KEwgtjNtG7OlN/IteGGLZT9supFJjABEG3AzZ0Q/Wd8n1yi8ChrI3MlaZ99X+hNJ97aDvHa6rk52zKxaMZvcf5HUA/soNi1KW7ia5p+JE8QzwIBF0L4Ad057WbOgpUkh5PjmbXw4Xc8L60MNzMwYNHf80vsZ5u8emnL0treP0jeHGmnm+gkUNr0q2gxPNJoyA35wWv14Kblv6bc761BRL8L8S7rIyVMsgFtZVQeYted7EeYE2+xcxAoWZvxjq0s7tFJhNK0o7YQfJpmRcDaiC5CPNIXn74etDmzaB1ZNWeBe05RpqNp73jibgq80AmKRytQ8ZWxc145kJBSyvPk1SCAPBnSt3CRZ+nhdZGbWt1fwFO/tes7q5RmdfEjInrNJXW
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 14:43:08.1418
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ecaf0d12-933d-45aa-5991-08df3e6fc55a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BD5.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB741322

From: Uri Dar <udar@nvidia.com>

devx_umem_reg_cmd_alloc() stores the CREATE_UMEM mailbox size, a header
plus 8 bytes per MTT, in the u32 cmd->inlen. The number of MTTs is
derived from the user-supplied length and pgsz_bitmap, so a UMEM of about
2TB registered with 4KB pages wraps the size, the mailbox is
under-allocated and mlx5_ib_populate_pas() writes past its end.

Store the size in an int, the in_size type of mlx5_cmd_exec(), where a
larger value would turn negative, and compute it with overflow checks so
a UMEM whose mailbox does not fit is rejected.

Mailbox sizes within 512 bytes of INT_MAX still overflow the block count
in mlx5_calc_cmd_blocks(), but the command then fails with -ENOMEM
before reaching firmware. This predates the change.

Fixes: aeae94579caf ("IB/mlx5: Add DEVX support for memory registration")
Cc: stable@vger.kernel.org
Signed-off-by: Uri Dar <udar@nvidia.com>
Reviewed-by: Michael Gur <michaelgur@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/hw/mlx5/devx.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index fc6f793dcc6584e6a22b40c57e2df8f24579eb14..1da6c0e440d6e19d8791b012a148f479cfdddad7 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -113,7 +113,7 @@ struct devx_umem {
 
 struct devx_umem_reg_cmd {
 	void				*in;
-	u32				inlen;
+	int				inlen;
 	u32				out[MLX5_ST_SZ_DW(create_umem_out)];
 };
 
@@ -2334,6 +2334,7 @@ static int devx_umem_reg_cmd_alloc(struct mlx5_ib_dev *dev,
 {
 	unsigned long pgsz_bitmap;
 	unsigned int page_size;
+	size_t num_mtt;
 	__be64 *mtt;
 	void *umem;
 	int ret;
@@ -2361,9 +2362,12 @@ static int devx_umem_reg_cmd_alloc(struct mlx5_ib_dev *dev,
 	if (!page_size)
 		return -EINVAL;
 
-	cmd->inlen = MLX5_ST_SZ_BYTES(create_umem_in) +
-		     (MLX5_ST_SZ_BYTES(mtt) *
-		      ib_umem_num_dma_blocks(obj->umem, page_size));
+	num_mtt = ib_umem_num_dma_blocks(obj->umem, page_size);
+	if (check_add_overflow(MLX5_ST_SZ_BYTES(create_umem_in),
+			       size_mul(MLX5_ST_SZ_BYTES(mtt), num_mtt),
+			       &cmd->inlen))
+		return -EINVAL;
+
 	cmd->in = uverbs_zalloc(attrs, cmd->inlen);
 	if (IS_ERR(cmd->in))
 		return PTR_ERR(cmd->in);
@@ -2372,8 +2376,7 @@ static int devx_umem_reg_cmd_alloc(struct mlx5_ib_dev *dev,
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

