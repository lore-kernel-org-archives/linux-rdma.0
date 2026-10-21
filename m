Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.40
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792569059;
	b=vTPbY1/IF/1WM1+hRFTrbw+Yabil4PXG6T84JBBcK8ATTmjtSxdO9EjAdj8aJgZhS2SB
	 La2+DIiENX9G+0I0W348DaSdv4o4IrvWP2mmg0sNPziVFdEcQZVHx7Q8Cda2ONBTabvU1
	 tdBGJ0O5HjjbRa9o706WlrraKWCx/+RCWOI0M1AoUYMKcNWDagIl1sq2xEz1d0owpCuNR
	 qoDsS4rFCe8aS2Y1k/f+vZaKg0dsBe8fnKpdJMQTF9xa6RbwX+rCIX1yGESpD+TBTyYO4
	 +8Qx2QKwzOaa8tl97eVEqjMIJc2TbzWU+TJTo+u/Ir1NkFuL/b7ldM7ajAUPRavgSAQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792569059;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 Content-Type:X-NV-OnPremToCloud:X-EOPAttributedMessage:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=iOH6OAbePqdL+pcZ3uJLPXvtguuyaI61fsqEmkm8klc=;
	b=WTNqWyUcF4V/lumvch3GezFTnXQoVeuMvhmS0q+BrUUjiMC77uNxqkJtejCHT8CtRF9U
	 1PRAZyXQxMZ2HyKhzvW4lkY23eOG0CrYdYkpnI4grS4w22SIgNo80ahex2FjFFUw+FpQI
	 8CScvRxjMaD4Ci37E6o/uQmWXsqhh+IziowgYXRJuUlP9Qluus9ZUqqi56i5ITuoGzdqp
	 7xQDVYsQodAoGdolwNS0wwg31e50mzoih5EaRz7nGkabTVi/M/PFTJadliOXLn5e2Kz/y
	 LPySJrbixs23/F1OQonhl/jseKFtB6Dqqhvl53M7uKjmKWZtVBALUgZL63lYxg650rA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=gPA8RxKK;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.40
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010040.outbound.protection.outlook.com [52.101.61.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD8C606A31B;
	Wed, 21 Oct 2026 07:50:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7CD8C606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=gPA8RxKK
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ctASeEhkwKQLf7t7q/l8uU+bP/omIVrmm3wYEkMvZh3LKTrhUgo/wo4R/tOLbmRU0FI4asrOKZKU9XEyT3JofV+orpU9b/1D9pzfjzG8t44N1rpCEvZEoqakIT+bc3PlveqPfZNs9zlGIQT0i/9Xbl0ihrA7/L2+2FtIlsdZUASY1swvn4t32BJ8xTw5AowhCrGGpS1wgGk4d1PYiH/1yCnCeJOaeb4R3bePV7luIUTXzeBaFnzEiCWcmq7SGldhpVsZ+g9H3UhJgkuStj2L575BkGJnyY//mAtJHMYN8j16CClGs0f63/3GHvYNBDSYsVrlzn1JCdm5iybGR0oI9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iOH6OAbePqdL+pcZ3uJLPXvtguuyaI61fsqEmkm8klc=;
 b=IdUB+4RkTJO+/BYyYuKIZgKoGZrr4ZZIhGuZ/9xXcT3keOFpQv4AOKwCr4PGsP00JkTyHNj7rF+fwvC9YliWEBaLdA4VdtoIToqguwRyxKbkMbJ2klZCWYjQUxHJH8iZCA4jZX0A+WixsaFXjwhIH58yA+uvYYsZXCncNf0B6OshPCKnaRiEMPjV6wO/U7xkfiD2f5+ij++IXSXpQXJ1yurSy0nainyajYUOc490NW5/04boFLtXOne+bR6E8RLdqdyjhmt9klUWU40lRo/wcT3a+jHI2AG+63hGkUe0P4p//UDv5KRQWtd6qUwI+kfuy21IBcYtXf7ErxF+rEIP2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iOH6OAbePqdL+pcZ3uJLPXvtguuyaI61fsqEmkm8klc=;
 b=gPA8RxKKePaTvl+Qw9pHdnNo2CbIFQF7QCQIUEB+BqWtbu5XA7WSQkcy5ZNcZC3qTOFiI4cEf2FT7v4Uznc928js8lq1746y9kBhyX2EayMbjFMXOp4PsE1dOhlPj9H4nw/QudSuRE31WWhnK/Cd7LDoHW6SY3iJA3p7Vod2OTg9mbrcqGFN3XSB0wnW7POdfc+0kLDrvJShR0BSnf32T0q9reWFSDuL1Tsvnquawg3Lo6/xpiH/Ywynht8okfQW7SgpP03qZKPPFkpMNj8WrgEbcNEdFN074aDZcYDYIJWUkW0KCVPcPjn/7d1146t2AUS5pPl28Ksccj3Odem0jQ==
Received: from SJ0PR13CA0108.namprd13.prod.outlook.com (2603:10b6:a03:2c5::23)
 by DM4PR12MB7646.namprd12.prod.outlook.com (2603:10b6:8:106::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 07:50:46 +0000
Received: from PH7PEPF0000000C.namprd04.prod.outlook.com
 (2603:10b6:a03:2c5:cafe::4a) by SJ0PR13CA0108.outlook.office365.com
 (2603:10b6:a03:2c5::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.546.16 via Frontend Transport; Wed,
 21 Oct 2026 07:50:46 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 PH7PEPF0000000C.mail.protection.outlook.com (10.167.243.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.546.15 via Frontend Transport; Wed, 21 Oct 2026 07:50:45 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Wed, 21 Oct
 2026 00:50:18 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 21 Oct
 2026 00:50:18 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Wed, 21
 Oct 2026 00:50:12 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Alexandre Cassen <acassen@corp.free.fr>, Alex Vesker <valex@nvidia.com>,
	Erez Shitrit <erezsh@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Itamar
 Gozlan" <igozlan@nvidia.com>, Kees Cook <kees@kernel.org>, Kees Cook
	<kees+treewide@kernel.org>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Prathamesh Deshpande
	<prathameshdeshpande7@gmail.com>, Saeed Mahameed <saeedm@nvidia.com>, "Tariq
 Toukan" <tariqt@nvidia.com>, William Theesfeld <william@theesfeld.net>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>
Subject: [PATCH net 1/3] net/mlx5: HWS, Handle NULL in vport destination action creation
Date: Wed, 21 Oct 2026 10:49:47 +0300
Message-ID: <20261021074949.3471704-2-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261021074949.3471704-1-tariqt@nvidia.com>
References: <20261021074949.3471704-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: PH7PEPF0000000C:EE_|DM4PR12MB7646:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e44e37c-c8de-45b4-c19a-08df2f4803ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|36860700016|82310400026|56012099006|11063799006|261009223027099003|10067099003|22082099003|18002099003|41080700001;
X-Microsoft-Antispam-Message-Info:
	KkgLAyPYMc6ovY9TBlp24weRaxJzLyeqhTEyTPMqmu480qvjDmxk+sTeIOXdMlFj0geP2ZwoXTNHE3eiRZRU1ezXKWNvk+lmjrdKyvk836x6PrLm8uKXpzLpo1MU9EXZjgSSBfp8/WYxquxV28MVoKQcKCfi/L7gkQbv7UVh/roSGTa62LTPG+mMJRdlEdaYDXgcX62KMODOYYSC4+GqXummx9llxo/uslhXqC1Kzr8DP7MMYysDL7jQZcX7JXGIoPS0ApTnLv0h2OeuL63zs6ChD+0YrtE9dha+U3z2BuwTFpO2MGHszA4Cqy8Tt6O9GNvIM34Z6u7HFGUgFHieA9z3RgMDibEk+9neirHXRGbOItjo8VvFN9L2OWw+dIrh3/JNEC96wpo1Djtbjodr37AFuyAR8QCj6MBTcb24D3Wv/QuHfIcbsl1QxuoCN/4FTkCApHD0SOT1guc3NEV6K5zwDBBp68/VGfJFAbcmNhpZefQDIlB2B0o88AIp4IFu9qdX0lb06KWxwDEk/kTsYoaF+U8JdebOjAd6CNEunW3PYNu1/K5b9TBUGwU6YTfSgGo7DtRvLG3r8tcQbIupJiGZDNn7ILZVuSoXreK6plLIWMDw9WEi67cwsg6Pr5iuo+q2DsjqcKEcEwQa494Uq43MlKXOqouh6rS+xVm9B9HqnTjY6LHYwd6o5IPVLGis6lb0GvjjIXJNjtRdqr2X9MGffBQC3aaMLioH3j8/gISyDcKY8sujo4duvXZFjhO1xIqmDWwtOpHgB5SC7ZfjJA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(36860700016)(82310400026)(56012099006)(11063799006)(261009223027099003)(10067099003)(22082099003)(18002099003)(41080700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	DxfC5xqcuZDKeTLwhnrK9JooKv54QutGwQ1TdopIEHnPiE6XEaIjDE4nAIlb3DSnwihVChb71wLKdJ9kHp9A6J15/3CYIldiAvsmEngnEitIgFVll/m6an02nu9CVLfkeJTzvO0QzJ5KCRQ9ECev2K8NXgHvS5ylCPfuYY+nzDU9MiyBx1GeL3wYFPBVID6tVLMxGn8DQXWxO2COPOUxRagRPXvTubNt28zcHS15SQ+O4PXfq0DSLydwynocwzf95Nsh1DgGaSp/KUCcw6x4Gs4AuvKD7Y7/YLpRA4KxVs6z5Bkh5+TPlpRpSIJz1fsFVTmk5+wajFhld8cjV0bhdH8k5CWL3M6e75bRGF0yaCaK2UudiEiKtZTNCUb2DBDTIh+LKnWKmeptIv7OMkvKOyMW1nnfHy7hzXXs+DQ2pvV/u/3Fval7tykOiJjkSEFe
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 07:50:45.9747
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e44e37c-c8de-45b4-c19a-08df2f4803ff
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	PH7PEPF0000000C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7646

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

mlx5hws_action_create_dest_vport can return NULL - handle
this case before trying to insert NULL into xarray.

Fixes: 8e2e08a6d1e0 ("net/mlx5: fs, add support for dest vport HWS action")
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Alex Vesker <valex@nvidia.com>
Reviewed-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
index 54761754e657..c4574c5f4ded 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
@@ -440,6 +440,9 @@ mlx5_fs_get_dest_action_vport(struct mlx5_fs_hws_context *fs_ctx,
 	dest = mlx5hws_action_create_dest_vport(ctx, vport_num,	vhca_id_valid,
 						dest_attr->vport.vhca_id, flags);
 
+	if (!dest)
+		return NULL;
+
 	err = xa_insert(dests_xa, idx, dest, GFP_KERNEL);
 	if (err) {
 		mlx5hws_action_destroy(dest);
-- 
2.44.0

