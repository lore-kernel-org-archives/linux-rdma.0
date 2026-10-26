Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.200.60
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793004460;
	b=qrlh7psffMXtTq9DYh++wAegjMfXgdDNqIG3zHIQ4KK2cR81kJk1+jT113BARo7P7/HI
	 yJeI3jgiZTErjBy8ahrPXNrLcPW3ZlzwhmiGKV6LrS9bUCSKsgTkEQnuCfTpbOD0gaPiw
	 HX2c1Pkb+ZzWckqnu2CX25Y01EqnqTx1Z9roI7+yl7Te8AXfEYd8/9BJ5t4YtA115yv7/
	 E1eVYpAvyzFh4ioOyPIc26lfV7U+Qw/BURIaEsnR3BWMuNrhbIcoUBOWqDV3uNhtCnGu+
	 8sIf/6OPPnqAkP3Z+ZiAnIaQ1UbeOqQNczO1hXSBnzQTfXur/5nF1MTXcSwKp3Ixcgw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793004460;
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
	bh=UzjUjW3g/uf7bMl7PbDDoGSNW6ZrLHMGUJoyDNZ9p3E=;
	b=pMDOjXmEV0BY6OfTCJSZ21y07VfdDGi2Fh6+KrSt1xAkElL+c+0qKdWX59bZfxMW/P8k
	 H1G0mbpzG5SV4FVGoUQTCrcAt2MOKA6xzO6/kr07CJws0V/KDrL0fddXDqUMiODnkCyhf
	 jy7OgyI7p2GVmZVwYFBm2VhxDTREiH6GrQ7SQloiTcOxdIoMvBpJAV96i3A6TYh9ywvyb
	 ucBWkiDfmEmioYLscNoxnMTnKO1WkgZOCXbvqvrK+a2OAv4wmEDMitQcU19n0ZUgy/vuO
	 4yNirribmb6R6lF1JS4IlQ+D72/smt9FGp7uncCxQvSxM/NiNaOxDIQ6uuhnEFG18EA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=t7NJLDLP;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.200.60
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012060.outbound.protection.outlook.com [40.107.200.60])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E482A606A31A;
	Mon, 26 Oct 2026 08:47:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E482A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=t7NJLDLP
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ppy18kymhJdiwcJUUfOgNcfcpDyMJs/eyuNCLl78DcbiT6CKJ4KNG7AogheUsremm+dLDaBSuvjRaI/sLe53Nm7styR2OH+E/SWun1nptqco77r1oLkdbVDd41aQlHsRsj4odCQlhqypan0USprtKQEiq6V4//0h3xjxw+vRqeb0EiEWIZO8qqDDvZq9KlHfcFuNTObdSExdjcojJ0+PKo5q4Tb/Yh+PrfpM3B6sv+ckOBSwaa8WRA820tEoDWp53UEfwiJuIUUcSvKwKYuIIUIDr+LZJ9xP93PMgGnLNrRvf2IOsALNyyMmSVo8kxdKSe/rW6kudKEPrFNH1m8aQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UzjUjW3g/uf7bMl7PbDDoGSNW6ZrLHMGUJoyDNZ9p3E=;
 b=dpYRIJ4pyoPre5Im67yOVf63A1Xxh7Igk3YHwL3Ba5xf/3sCzGRMwd+Aejw8eehWLJppJcyokprlC/3aELGGD6NhM84EKpJ4bhjrQ11Ax+qP/WjK6bKZ/b/Jy1r0tKZ+0E2Op7brPc6VkghZfrZvTOqo+b+f0CqAqEqaW77HxqSyewVUR7AUJelU/imgBLJWAlvJ4VoVuwYb+hOk1GOYpVViNjl3z4oYGoom49E3YjSl3jQB3aHnn/5wnjRa7gmJCjnDjDEdD98f4K6oyM9GLJLuCjSdqSZL/Q/MGjiHWXnndhK4i2WpFofGbQQ7rLDSMNX2s1GZvnhbQ9WBLXSITQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UzjUjW3g/uf7bMl7PbDDoGSNW6ZrLHMGUJoyDNZ9p3E=;
 b=t7NJLDLPrMHpEyBTfs/+yer8kjV3ahhHDbTQp4yGordP9vwISUvh8HrbO7FJwMxTmCjT0nyTrzaENyLh49Zg8bfgnp+0BmKzNqmydHtEvVqoUpfxSugtp7m29CdUy+2U1iPYxB5xT/TjLRuy8fJeijFNAYCJ8B4uHkF6+w8t3HGkO7oRlSp5rOVIAnnRljc+D655MYbRntyY3W0lUPjr9rs+BmPW/GiLtrGq7ZWPXQ4iNYIZp7uMhbulNXIhGIOkY/9ildmOl+uqkd9SBmX5qS9Ner/CiLgjc3G0YxIefavHeXlrOUPeGTtlhGz5oSI+5ja3cte4YJGegpztVbnYWw==
Received: from CH0P220CA0002.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:ef::14)
 by EAYPR12MB999157.namprd12.prod.outlook.com (2603:10b6:303:2bf::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 08:45:35 +0000
Received: from CH2PEPF000166BF.namprd04.prod.outlook.com
 (2603:10b6:610:ef:cafe::29) by CH0P220CA0002.outlook.office365.com
 (2603:10b6:610:ef::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.546.19 via Frontend Transport; Mon,
 26 Oct 2026 08:45:34 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF000166BF.mail.protection.outlook.com (10.167.252.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.569.4 via Frontend Transport; Mon, 26 Oct 2026 08:45:34 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 26 Oct
 2026 01:45:22 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 26 Oct
 2026 01:45:22 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Mon, 26
 Oct 2026 01:45:18 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Cosmin Ratiu <cratiu@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>,
	Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Simon Horman
	<horms@kernel.org>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net] net/mlx5: Only set num_doorbells on a fully initialized SF
Date: Mon, 26 Oct 2026 10:45:03 +0200
Message-ID: <20261026084503.4122732-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF000166BF:EE_|EAYPR12MB999157:EE_
X-MS-Office365-Filtering-Correlation-Id: 71980d51-e1f1-4227-f1cd-08df333d8022
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|7416014|23010399003|376014|82310400026|1800799024|261009223027099003|261021121427099003|10067099003|56012099006|6133799003|18002099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	8Xh7ZLU+TnVtPXc8wgXsYzSdhHhkZEO78nbTVUHTPRExOniJcEmZIkK3J+PPbSv1+bC60olIe+EF+gEZ2i7u5rFkDeKd0Mh+fxdpIIIhOBwRsJcHdutsSaO4l6F1Wh/g1tD5Chz42IVjiBgW4izqny5xmqwNZ/J1OvK2PuALi3uQm3GJFXI87K7f98t5+oI3Nks6yyiBhFOz2ICS9xH8/DFzEOZgE0NBIYhqUYfQPAVSv4jJhvG78Y8Vl1/X5WU6gP6FYdUjJUjEehAZBE6N73rDPmkq7V/bdiho37L5yOo8LHdCExLfLqTmJoFL2isNZFEl6T4pxIlMNZ/x6S4BxWidLg6jpkyZjAMKJY16IgUDotVeO1mq66rMCWcCxFOBH9pSjmOsassm+t/HXB0S+NnC0QW8VzSw96gPF/FGWOtuaGJ9E3HSXqippAH15MXtkO1Wv3ntyxiNXjyyGPTOpFNof7NHRK4rH1GicBUf6x2mKVGVO84DHJMKGVVK1ynVCPehPcUmYrwmoD+Sz4pTTvV92hKVZMFjN4reSspE6lLqx1TyB78OPn33Nu+cgAMqKpYGbiVNp9ntXt09gP88kwq57F408gDcXbcf4GFSfzCJAlgCxjRlUHItuug4fFc2nUWjRfQnSFiXEZnDisqQFYE0EQDLWyodvin6oxOXpysDBDKiNskXm8dBRaS+TCGtjDlI8uuHAe3TxwcJsptgcQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(7416014)(23010399003)(376014)(82310400026)(1800799024)(261009223027099003)(261021121427099003)(10067099003)(56012099006)(6133799003)(18002099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	i1wySUNGlllemNQD5Y2YEORxeFnt5JGb0NaU7LnPKZVmHRkKSbKr8dnO+VfRnDZy8K4Xtz/DsKXEG1zcE04uLBepcIc+KW89RXVSpaE7DAmSnj+ezKzblmtZwRWVkT4JR6Fhmh5+F8KZsqZnTqCvuo+0ONNmp19MY5l55I9mV0e+cwA2zvioa4lycpZeKZ/I5fPda/YQ3iZCU9hVqBj6sl/0EzXvvdJLjpz15rLp52JVdCF0hCs8YcU1tP+9vvxXuODBkBGSzz9cfsabD5MbIxbQ1FSIbUbhptB8zONimrJ/N57QXCTjuzDlKqbH2sgn+Cg99qzFjBW/CDcVdNchRgqfdkbujdX1Dwjr2NnGEOob/OE5lGPhzos+0GxyZE3Qx0AxC3ccJU+PSR0CvYtpJJj/PGKH6Q4FszfXAB4EL/ykwT9yCdmQPJavS2eYRJgt
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 08:45:34.4055
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 71980d51-e1f1-4227-f1cd-08df333d8022
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF000166BF.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: EAYPR12MB999157

From: Cosmin Ratiu <cratiu@nvidia.com>

The validation for the num_doorbells devlink param rejects values
greater than num_channels. For lightweight SFs, this ends up accessing
a NULL priv->eq_table, leading to a crash.

Fix that by rejecting setting num_doorbells on uninitialized SFs.

Fixes: 11bbcfb7668c ("net/mlx5e: Use the 'num_doorbells' devlink param")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index b9026cc64383..30a97e48dda7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -542,6 +542,12 @@ static int mlx5_devlink_num_doorbells_validate(struct devlink *devlink, u32 id,
 	u32 val32 = val->vu32;
 	u32 max_num_channels;
 
+	if (mlx5_dev_is_lightweight(mdev)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Setting num_doorbells requires full device initialization; reload the device first");
+		return -EOPNOTSUPP;
+	}
+
 	max_num_channels = mlx5e_get_max_num_channels(mdev);
 	if (val32 > max_num_channels) {
 		NL_SET_ERR_MSG_FMT_MOD(extack,

base-commit: f4377bf85887f57b59abb5479f7660a81ffe4449
-- 
2.44.0

