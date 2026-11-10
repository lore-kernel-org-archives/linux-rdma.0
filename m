Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.69
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794311070;
	b=afwEW0NexoBwgiCUTHcRinzwiHh9oFD4G2Y632WxR1QigrRaFkt32ZlvRjIFXpfe5hGO
	 W/2Xwo6we+tGyCaf7YHbrgPDPIwLWf414TUzx0YCMaaNG7Upm0hS3r6PIQC0n5OiLM37X
	 Z3qA9l5IiOwsFRYdE3gvyLZD1xHsu/laEYT32yk/EkMJdfItvBBsEvVzGUpcr1M7dog2r
	 MnKTeoEnT4osoXyE/+FSQFqtE2HyfGpu00gKZepmNbS1PC8+WF1xEGKpAuqIuflPoZUNY
	 OZQgPXVmV5yQ9qSAvaxdhC9XOGxfiwmQ2dIJ98yQADJ4qdj76sl0b1NzKHKAOwdpv3g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794311070;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-NV-OnPremToCloud:X-EOPAttributedMessage:X-MS-PublicTrafficType:
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
	bh=wm/XesGVgRae6Q41FoOnGvk3cP4z4xYuZl7g7IB8N9s=;
	b=qtwpHhbhDmCOpBR/ucv3XV/Ek1O3EAxkn1t3dRXH/qvz5yxBBgtKTiR8Bm7a2lzKTgBY
	 3CdcTo0VDSRmcgc3I/h0RG1/cvG8+U1PqK/2Cnfx10LPnCn2VCJvkYLtzm0NT4hRE8f+s
	 c8ji3Th6ydGy1QM+x3UUeemr5h+btsgZHaiZBHaOn2GHARi6xzwToKzG4lfRn2NrAzE29
	 XllF7S62MP5bMzVS8iwqWyuUXaVkQaBXxWl6jfNG9laYA0cbvNkKIqkh9s5JQ+wLTsSn2
	 jDUiNBT0sLluASd30GMBF1N4bU2NFtHnsldynaqfSSom53votRUtpwwioCoGOqraCew==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=M6J1kqTQ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.69
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010069.outbound.protection.outlook.com [52.101.46.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90420606A31C;
	Tue, 10 Nov 2026 11:44:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 90420606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=M6J1kqTQ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sGXPEa2CiKPjiQ+KGR0mgPjveN/xqj61tPye1KGS+Z9CUf+VPLvcFZu+wzI2VI3GQHlsaP9ZOKcwzNdr6zjzFdtKGa8G2V0obhdMNGQA/dsTiXbhC6k6v6Pq7M4zPW8S3p5PcJWGig8LNm+jnMfmqy0iHhu+6GaqCwdC8V6DlMjbuNM0v/afXi7uLVHW3QW3Z4kJyLKGWhVVm5ZH+Q9uU/F3Bk+rysLjgmJtnn6wRdhUf99qRRteDi0LlnhN6ucyKhFVM4T2kTu4WvxmcGM5BT2bz0f8JY6+RR4WT5mzF4wxdhpuuNAmf26tew0PFkJi1xWd2LKUX4Vwt9ByjhtQPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wm/XesGVgRae6Q41FoOnGvk3cP4z4xYuZl7g7IB8N9s=;
 b=szoGOfNuYCR00Xb14dLsNusDdf4BQRlN/b5PADdNcJ3E6bJp5QfprHAnZhsKAODZP5QcQBxPNDy4WOt+T5U2mibJQfh1GAsBgnRCxuXqJVsxuvpHfvJQbFHwpLbuAki2JSJyK2AzbJufQ5OmDfwYQQd3B2tOZCRjc8gmM7/cG4k+P35TWNuF48b7pWAqy/j4pyFSAHlqp5zR0me+jyMUShOS7Ql/mlOx8MQfgxwbhqWjGRINaV7QAHs8gbrcsmOi5tHWuQDKNn/Ey/Hg7d+MqxsRuwsWPEI9DKbIw3oZWr45Es8JfKE8OWEw98NpS88Rhw8dRHxcoCVetnbA+87+Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wm/XesGVgRae6Q41FoOnGvk3cP4z4xYuZl7g7IB8N9s=;
 b=M6J1kqTQ0+w4Lj6zudGxZZ7GfF/nKQJceirPfTpAQevXqcsYjaYLDW9fZ2otJ2lHMlsvlYWPYM9zgRS8GhB1hX3cf61hNwpiB6wVtBpSlsLZyv+aOlhv3IBVtQ1L3tTK9rLfxyBF6jHuvwl/Wht0mLtdd3t1UB9zYnMEB4QvRBpQbQUJk7CnessuX4QrTnaFunzMTmtDm54ZyOdnuAZK7uJEwstgekhCzpOMU3/ja6paDOJ4i8PQuvFvTI8y+z3gZozjJmljsNONeVRAhbUjxEZ8pVoeDppq2s1LWA0ZCye4+qjHcroxV1BJwWJjfP+ZFcu+7XY5LIc6nfy6qXgWNQ==
Received: from MW4PR03CA0342.namprd03.prod.outlook.com (2603:10b6:303:dc::17)
 by MN0PR12MB6222.namprd12.prod.outlook.com (2603:10b6:208:3c2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Tue, 10 Nov
 2026 11:44:25 +0000
Received: from MWH0EPF000C6186.namprd02.prod.outlook.com
 (2603:10b6:303:dc:cafe::3d) by MW4PR03CA0342.outlook.office365.com
 (2603:10b6:303:dc::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Tue, 10
 Nov 2026 11:44:25 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MWH0EPF000C6186.mail.protection.outlook.com (10.167.249.118) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 11:44:24 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 03:44:01 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 03:44:01 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 10
 Nov 2026 03:43:56 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>, "open
 list" <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, "Maor
 Dickman" <maord@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, Roi Dayan
	<roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drori
	<shayd@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Uri Dar
	<udar@nvidia.com>
Subject: [PATCH net] net/mlx5: Lag, Return error when enabling MPESW without LAG support
Date: Tue, 10 Nov 2026 13:43:50 +0200
Message-ID: <20261110114350.2639891-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000C6186:EE_|MN0PR12MB6222:EE_
X-MS-Office365-Filtering-Correlation-Id: d146232e-93f7-485a-bc2d-08df3f1ff830
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|36860700016|1800799024|82310400026|5023799004|11063799006|56012099006|261021121427099003|261021123027099003|261009223027099003|261102123227099003|261022075727099003|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	bCbqtSCX3a8dHpnXZrn/cuNBmlCaQox1DKQoPG1G6dx02OYPQehHTEMYfzGbqZCmsedi5awXUX2oB0+Si4LuVUahC0BhxSr0LaiFjh/T1ST9UBLzRgPJZqhz2PWVCc9UksdLgvPVxLQeKGD1xwr0JR/HV+6jBLczyfzYlAjD3QBEqRv/Thpg32QYmm3p4Tn56NG8+PL/oTLnAAgXxH6Z8pJXR2WlGWb1OhFg8vq/SslT3H4Bhavuw5b+C0+zVVd1qvgyBhdHSHH53lmIXeHupB6/r2u9PWHlUz0iBBfx6tkEMsPH8XClTVwS7UvYwQWcwhYcMlADoaDmF9zs/cnw3XHm5msEYjoXAI2Xd54EkL2jTMxHp1+GArWv9NmEOpdnmhJCmPxefR2u59ZHdUdnTXh4KikKTLchAdZ2ZHkT1Ch8lA4oXe68llqxiQOaxTYcUBxIiz/GUo+mzmp04U19PQoa6/28+eB+LIxdmgIhYEi6yfjVE6QfD+E+2Ya8Lqsd0Bb8almFa3iKR/siPGwrZWMpyTKUG3SivmC7tXEsCGekob03+L6tdiWvbVEEg/a5y7iElf4XTF59SQNBPonHU280ef/JIYULuI1aiaPYDChJqcc+llZXiIvRGzCZnTTaavw+LZwknZTfRz2MU1fGifjDOTuCh9LMsYTFf0tDzSH/5zuFH7bRt3YsDSAXAt9x3V3aW6iU8mhX6QR3moPqQQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(36860700016)(1800799024)(82310400026)(5023799004)(11063799006)(56012099006)(261021121427099003)(261021123027099003)(261009223027099003)(261102123227099003)(261022075727099003)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	PpWRRgq05if4GB5/Y4wPIAV6B8MjHTMU8xmh2G2sHROy1z4aMhxU3nSKKNohNENcw6yG5j4DG6wnLX2Jj0KyQrvEqYd/paLJmlTy0kuUNmUyKZ1w4hK7udqKAg/GOkhZZUu6B05EoXrnOC9+EFe3zk4RoqDU8y/0FFmRtQr/E0/4ikHdOKD3uThFCJbGyTqlnCPZxnFgqClp/e1RA9PKvdli+R4HgTWUkwh9YB2VlRtId0xV63hWhFdXFDSJtI+CyXRMRAf3x5xH5z9WJ31Ob+rkCvQ11ENyAJPuylrEVrm94A7VQeuta0oF4eSxgD4LoOMfqmNWtL5cTkQDt9ROt+JeGokJWU4i8saNbZj6QlavWd8coGHUj63LMzJxVs8hxj3I+R2tpBy73uhbOJjfrh2BPQ/8DTXeFqs8rpVefiVpaug6Rw3gseRHNzd7/oCM
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 11:44:24.9280
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d146232e-93f7-485a-bc2d-08df3f1ff830
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C6186.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6222

From: Uri Dar <udar@nvidia.com>

When firmware reports a function as not LAG capable (lag_master=0 or
num_lag_ports < 2), mlx5_lag_add_mdev() creates no LAG object for it.
Enabling multiport E-Switch on such a device returns 0 from
mlx5_lag_mpesw_queue_work(), so
"devlink dev param set ... esw_multiport value true" reports success
although nothing was enabled, and a following "devlink dev param show"
still reports false.

Return -EOPNOTSUPP instead. mlx5_lag_mpesw_disable() ignores the return
value, so disabling keeps its current behavior.

Fixes: a32327a3a02c ("net/mlx5: Lag, Control MultiPort E-Switch single FDB mode")
Signed-off-by: Uri Dar <udar@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
index abf72026c751..549d31812c2f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
@@ -227,7 +227,7 @@ static int mlx5_lag_mpesw_queue_work(struct mlx5_core_dev *dev,
 	int err = 0;
 
 	if (!ldev)
-		return 0;
+		return -EOPNOTSUPP;
 
 	work = kzalloc_obj(*work);
 	if (!work)

base-commit: b71c101bbb9814d163c00234d43c41f0a17907d4
-- 
2.44.0

