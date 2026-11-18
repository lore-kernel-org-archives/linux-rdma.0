Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.55
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795020775;
	b=WG8GhuXH9BbBnJHt2Ri9mUYVjM5OvxF8KvNyRI6XkRBHqyt2Oof/tKEddDqu98qvdnVS
	 enEu/NVzvI+8ZqgNvHWOw/EJAFWr9jFv3tOmBwC2Sjg4StR5ACmQPVMkvCyWgY+JfUogo
	 KqK3jg12SiY/JsI0DxI/3SO0CGj+rBJf3V/ltwTg6ieePMFGJL1jk1JFZfjfE96VVWfuP
	 dHUr1hUwFrQ8zW4AthKlqxoH84nYguG+uZRxoy7u7jGZjhM/GkSqo31Nw5+0bCNU28Wos
	 HYW0/3HmGNQTSUC5gen2IqbkEmnwH32BiHPwN053/Obgjf7nRS0xD/2lTam3rwyfrbg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020775;
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
	bh=k6aKBs05qAIGo8eiNT4of11ZOAH6eFPWZ9+ESGI1HOs=;
	b=zc2vzD3J8Vmz6Oswg06yS8KIM1Eg/ARuLKpoPvTyByazwpF/1I/dJ1YMrtbjll2Tp6Ud
	 3ELT82DXp4rRzHdN5zqgwdjzp4pZjo04zHhiK4Rs4FClbOoyv448I0r9bXtSLZdfb1V4m
	 eTjtvip4vl9uYBLh71kOOe+JF/hpapNaYWGNJ10TsjHqfCGZrDjXkNdR/sxkQfCKBHV9z
	 X+XjXeS71TYjfmGwNeSAzVjw5Jj6mKkRinI/Xh0ATyciyW0NEwglszn5qZJyVdql2bMp5
	 M9lLU94f5mjP9/onC0xK1ChjUKQA5w2XdW+8QiNh6qsO/C+ubWWQy/QMgiZtVIp4fAg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=N3zm5IyB;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.55
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013055.outbound.protection.outlook.com [40.93.201.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0BE60A2631;
	Wed, 18 Nov 2026 16:52:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BC0BE60A2631
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=N3zm5IyB
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AdSjMR5rR+06mlqdzhiTi9dyCzKag2ylRbIzRbCpqlVuIN6eay5HPIrqovSwpk7cW8lr5y1qHz69nd6KimsJKxL8NF8HKTNR5Y23I4HhGf/FS6Sx0Ye9T4SbJ+5YMkXauRz0GFZSZqNvJzQ7YD4WpiXJjL68OyhBaCGfb5hNW43LKszK6VobiDewo3eX7v6SFIY29tD/HweDYWz9mPlATq9OTlMZ5gdPo0eXiUprcH/+ND1iq/s8t+62+Pa7G1nCgdJU9p+CTHLwHLcJch/fBzZ3jFL8nc4/hKYzFfWhdUUBiDAFU4IXRzHhJvhFiuV4rYUF7srpcrjv3bu0yfmwzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k6aKBs05qAIGo8eiNT4of11ZOAH6eFPWZ9+ESGI1HOs=;
 b=JspJFD9UUfx8HXnR4HNPTelcJAi9qTJW6egCHI+LaGDEacwd2TUz6EDv5YqEsf+cM9eni9XHg7HFtLrbgx5+dyihcAsHUzk+n87OqjJRT4qUZcI/g6Urvh62bWd2p40W+fVAC7U2hHzmQusA/0wmMavMhaCuBs5znV2xeOlNtm59508GQkXvrjrvPxJbQSObxS7NCIZqeq5fvhTZHXbS1WnpQIsD5MjV0MC0X+ydDP1SVd8dBA8BKzkRUrJhs9XS8DsbaDNQU48pTv3CZRMYspBbrEyLaN6sxARS/BSi8Po0X0hC/pi2rIvehWeWF6A99BqUF5dyjcMzU4v1h+5GTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k6aKBs05qAIGo8eiNT4of11ZOAH6eFPWZ9+ESGI1HOs=;
 b=N3zm5IyBFUjDT4gXrJjeRVVI1j+aadS8D6XMQdfj2A89lLWkeJbGFOkK3ofDVGnAopOpadfjKNHda0lKmoS+TYQEBIKxF67vl2x6SoGD3D/ii67Jb0/b3bhV137EjkhUleGxGRFc7BIOVue2AcQkz2cJh/i9UUSkWoyMgz3XJ7qGpPlUk/Nl8j0B4gYxrTq1jv5X/LzL5sCvWNwZmHP5gMQxExGPsVpJpMKHKkjVztLucoxTcSQj7T6ajejs11a9bX52ZX1Np1Wb8vCAS2nDWi3+5j6VOL5/cdVHIwysm52VA6/L/1umej/sawjlGYlDjJ1z1dcoDZOhQYhi1JyxJA==
Received: from DS1PR06CA0026.namprd06.prod.outlook.com (2603:10b6:8:23e::18)
 by IA1PR12MB8465.namprd12.prod.outlook.com (2603:10b6:208:457::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 16:52:41 +0000
Received: from DS1PEPF00053452.namprd04.prod.outlook.com
 (2603:10b6:8:23e:cafe::2f) by DS1PR06CA0026.outlook.office365.com
 (2603:10b6:8:23e::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.13 via Frontend Transport; Wed,
 18 Nov 2026 16:52:41 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF00053452.mail.protection.outlook.com (10.167.23.234) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Wed, 18 Nov 2026 16:52:40 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 18 Nov
 2026 08:52:18 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Wed, 18 Nov
 2026 08:52:18 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Wed, 18
 Nov 2026 08:52:13 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>, "open
 list" <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark
 Bloch <mbloch@nvidia.com>, Parav Pandit <parav@nvidia.com>, Roi Dayan
	<roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drory
	<shayd@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Uri Dar
	<udar@nvidia.com>, Vu Pham <vuhuong@nvidia.com>
Subject: [PATCH net] net/mlx5: E-Switch, skip vport change work for disabled vports
Date: Wed, 18 Nov 2026 18:51:55 +0200
Message-ID: <20261118165155.1946097-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00053452:EE_|IA1PR12MB8465:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b93f958-68ec-403e-baa7-08df45945bc1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700016|23010399003|18002099003|261009223027099003|11063799006|261026140227099003|5023799004|56012099006|10067099003|261021123027099003|261028144727099003|261022105027099003|261021121427099003|261102123227099003;
X-Microsoft-Antispam-Message-Info:
	bUpbX94N8QKKz0J/tnMjYmD3ZTf9h2vAffNKsZj/vgjwF1vUM7IopxbuvHLp+hn5XwWAjvGs2cHlVNlQ6cOMg9Yu5CI73m8znNWTRFS7L3t/LGa6+iBhDlQRsbKZe822+wiwKTkSFBsajAN7Sstbu7cEjTr1+jnsXQiC6mzJ9WXBDUT+jm9EaHED6PZb4vfZZntbT4Fybkf00N/eAV8P8pE+0NkTIrXOwt/NGjjIE+Z0cDFxeOSlehU5WgD2StwvQDvMFJ0l4Q4N0mHQW4uOJ2GaCRuIU6+H3XT7uUvCKxdivOby/FJrO6k7MR1tGwx9a8WnaydINWpSp5B7DaBk3kGrG7qQQJY68peLHriIBaH58fSi20boAk+Tpxzuw+EayjUTAS1IF5Vll0+98/nuuZJPs3ngh1VYnWZ3Atfm+iL2a5OBodPaJADzaLZ1jTp+0yi8hnwQaQSzDYZsfkbKfwXYrfDmgUoA1dDYcEzUVBah3brCqa8oNHvOW2d7Ujv88jxBdb6s1H7Gh7YoCM401OZ5/O2qoCIeGLKU49t5mvrEKSIiFBYpBAmJneTQKwAiiFQG4OD3K+EK4ZJRAogdnAEDtgeiT+B2T7X2cqnjo45NmVtIDVleiCtArs20TsEyX7DoI2Hh2m6Kd9BrywHnQDSyKnfZQc13ev4YFsiPR7Fb5JfNv5XdDiQ9NyECeeojLT+CrY/0Y9QGJ7L5NDSpsw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700016)(23010399003)(18002099003)(261009223027099003)(11063799006)(261026140227099003)(5023799004)(56012099006)(10067099003)(261021123027099003)(261028144727099003)(261022105027099003)(261021121427099003)(261102123227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	jIlgKIonMW/azLtFETkthQcjD/IjQyFDOw1IsE32w+egwRZKLY7LqoFQ4xa8S56hYySpIfE1j+g+0b9BnyEGKvL+EwaQZO4ZlyPNHBqjf/eZDOJPH5y4w6uLkqosE/NWivGwBRFLfNO9mAMn1+AGvTd7tVVrl5frzdRyIdhuThY77FNXQl6bMr4JYFpvyWk3mkcqqybPR2kaNnfFaYFyAIaqTqY7gEbV9q3JKVv2wuuUwref3JIaS3RmIlQ43Ek0Fxsb+ZpXMadkTbtHdA3N6HK7BE+nF3nuXjATBIGJKjKzOgHq2NBW33KnATCiQHYyA7sgGbJPGM4MZoR9vB7+6Zy3RKFKM0lGZMnK37LZs+AU5hP8aQpcfDtzWaR5jYrGhcd1+TBIsqOct9nzYVKbqkMstyAGlla49IQdoZG9XkoT6QfRC+BZ0ZXiBjiZGPSi
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 16:52:40.5546
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b93f958-68ec-403e-baa7-08df45945bc1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00053452.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8465

From: Uri Dar <udar@nvidia.com>

A vport change work can still be pending when its vport is disabled.
For an SF, the vport is then freed in FW and the work's query fails
with syndrome 0x29d722. A disabled vport has nothing to sync, so skip
the work.

Fixes: d970812b91d0 ("net/mlx5: E-switch, Add eswitch helpers for SF vport")
Signed-off-by: Uri Dar <udar@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 76f808e06a88..174197f69888 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -758,7 +758,8 @@ static void esw_vport_change_handler(struct work_struct *work)
 	struct mlx5_eswitch *esw = vport->dev->priv.eswitch;
 
 	mutex_lock(&esw->state_lock);
-	esw_vport_change_handle_locked(vport);
+	if (vport->enabled)
+		esw_vport_change_handle_locked(vport);
 	mutex_unlock(&esw->state_lock);
 }
 

base-commit: aa40afa831ebfe45e40a23721711059f2ac584d4
-- 
2.44.0

