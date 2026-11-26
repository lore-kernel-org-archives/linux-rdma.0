Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795730265;
	b=0ERm+jX9tqRVK+Lk9/qKczYtcTx3OjVQNrFPPZZ4XjALXVH96uBHc8lfMuxxy6znEKs4
	 /+Q7DWiWZV+KTaUYzJ17lX8Sq/K/qEFhbn3QcGmvLhx7vVQw6oYkfbEeSpT/SfR0bFUHO
	 TMWmkDwMc8JnomkK/JIKKzLQUK9vaRGPyXMCpa63qfUY4tS0RZ4u5pq9oLnSIy0TW0ies
	 8+AIRX/jlde2fW4V3zY5zA1FreY005Z0PJhr0M50xvlISUly5S0P/WBgfIMYmGeZq05hY
	 ZT0sPeF7Q71iqFok7xqCgF4QYos0R9hdE96r9X1wS9pFiCJ5i5s96MPMPKeG9huxaDg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795730265;
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
	bh=zz9kV+PPmiiy0CiifVEU99MoSj/jBhyKUXoCs/4sp/0=;
	b=PedMPObStz9dD64zoFXg969We+6fYL9Q9+aXWOTRYNkmaoGfag9lf8aH1HUVyOGRjWoc
	 WkxDVm6hSgHb8vhmI/66iYvPYBP0z+2Agrf8YcK5Zeb4GWppxBl6XVculaPQ1cKuRI0t2
	 t/GCTCnzvoMlrLgkCgPfIb9lBODG6C9Os/hGhBKbwqT2oGC+fkzuSfYMQYz9DQ4U+RSTg
	 2dYcras9K/2chO2YGYb1yN5h5SwWGZqNXD3gZhED0Sfuk4Bg2P8BLxxZV4UuSh5VesbmO
	 Tvj1vgSy1M++T5zEAcbosE4Bd+KmR2kv4gljeyh4eIiqliJ+4b7u+xkurL81Rta8vaQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=GHmJrL4w;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.49
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010049.outbound.protection.outlook.com [52.101.201.49])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49424606A333;
	Thu, 26 Nov 2026 21:57:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 49424606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=GHmJrL4w
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F+kUurlaZirIuff/Px+XsDalgC2eOtsZM3C+W6idKYbNN2ZVbNgE2P7/aLedNcT4wUa7OQFaLQONjdN4YCErvP1hrCn34lq0ZpvnqgTpfYPb3EMYqIN7zJdJu3KMz5kBKfBRb176GheSGdmqFNcZNf6HhL6jIuD1H/Bq/JwmedUI4ZGaBu5JzEX3qZ0MyGsqI76Qkj9lpyJmiFTQdB00ggeoXcPyPbMkvBfF28pUzZw64+wNtqEXzFDdqOHdLCClwWT3jGsbl7+riTeHVCdHV1DhL/DtRf9hbU1g3pP4JZLZQyiGLPlsQ0kf65JwHJb3kxgcYK40gfAoudCxViz+Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zz9kV+PPmiiy0CiifVEU99MoSj/jBhyKUXoCs/4sp/0=;
 b=QaWUb/HRZksIn0sLWuEXTbr9QjhbcA+Jk9NHPBNWlSFiUgtmIPbq07riHst1K+I8bZk2zHQxgg/0ezfc8CGPcZ7kZvFhUX+tUNygpEwmJ24Wmh1i6GEJu8WKKSrsaEDB0/WFLlLrD7I7qbNbi3tOd0OsisHJBeoWoqlyFsEfsXwt7TCJ8Tey8LF27JuK43aTE3SkIaYozC1zhn8rTdevNCaRsS+bpUcoo9oV9XiK9LhHrutXD1A5nrI4/73rRC9xJmJkUcr9ESLb0Bd7N8P0g9PO1GDzWBXiBuxHEZ0XU4F9jImD93CMk6MdJbzQyoWmoVdyCguxXD8wM07rzfi1jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zz9kV+PPmiiy0CiifVEU99MoSj/jBhyKUXoCs/4sp/0=;
 b=GHmJrL4wQuKDytR3M5t9x6Iq16pS8RRnyGyKdXAH63EoF00FaPz4DLJOkz1UoqMJStMFm7+RIjes65f2IH78EmTEt1CZyIjpmGxtVQrh1gIEdidWp8pR1xEIbu9+AsEXUPf38AGVjOnR9kViRNG0WuOL6AcW5RlbUydiZUpexZHJz3PcOJIgeDnwpDUpsor3BQPWGIu4ppAwhPiAFB3vEWpfJH4tn8FTdpe/sgrAFin2oIMEccMigdoYQ90AUWS0z4V7LjwYRYRoCbQQhymVDlDwFHu+i9y86XtDqBPmlfoS7QkNuES7dZmY7nQ3kGPoPdW4NKS0CdkpA2h7miqFNA==
Received: from DS7PR05CA0075.namprd05.prod.outlook.com (2603:10b6:8:57::16) by
 DS7PR12MB5790.namprd12.prod.outlook.com (2603:10b6:8:75::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.7; Thu, 26 Nov 2026 21:57:29 +0000
Received: from DM3PEPF000265BA.namprd04.prod.outlook.com
 (2603:10b6:8:57:cafe::6f) by DS7PR05CA0075.outlook.office365.com
 (2603:10b6:8:57::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.688.5 via Frontend Transport; Thu, 26
 Nov 2026 21:57:29 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DM3PEPF000265BA.mail.protection.outlook.com (10.167.23.247) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.688.5 via Frontend Transport; Thu, 26 Nov 2026 21:57:28 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 26 Nov
 2026 13:57:21 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Thu, 26 Nov 2026 13:57:21 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Thu, 26 Nov 2026 13:57:15 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>
CC: Andrea Parri <parri.andrea@gmail.com>, Boris Pismenny <borisp@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>, Elliot Edmunds <eedmunds@nvidia.com>, "Gal
 Pressman" <gal@nvidia.com>, Jeroen Massar <jmassar@nvidia.com>, Jianbo Liu
	<jianbol@nvidia.com>, Kuniyuki Iwashima <kuniyu@google.com>, Leon Romanovsky
	<leon@kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Patrisious Haddad <phaddad@nvidia.com>, Raed Salem
	<raeds@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Simon Horman
	<horms@kernel.org>, Sridhar Samudrala <sridhar.samudrala@intel.com>, "Steffen
 Klassert" <steffen.klassert@secunet.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net 06/10] net/mlx5e: Fix IPv6 neighbour fallback for IPsec tunnels
Date: Thu, 26 Nov 2026 23:56:10 +0200
Message-ID: <20261126215614.792598-7-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261126215614.792598-1-tariqt@nvidia.com>
References: <20261126215614.792598-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DM3PEPF000265BA:EE_|DS7PR12MB5790:EE_
X-MS-Office365-Filtering-Correlation-Id: 673ec211-3e64-48b6-358b-08df4c084367
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|23010399003|36860700016|7416014|376014|6133799003|18002099003|22082099003|11063799006|56012099006|261026140227099003|261021123027099003|261021121427099003|261022075727099003|261102123227099003|261009223027099003|261022105027099003|261028144727099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	tzY0flExUUup3Te2FHoE/uTvHAuTX9iLMeJWaMIIDtRymVoEW5ukFYv3R7p6p/LCCsONGEmCjL+24TWeoRsBN3GlDZG93WUmZhhAo8pRVv3j5My7Mw9TcSy2Bj2h/jHJcHFWRN2aoIcnyKIjD//pXw5U8vIodP14Y63Nh3pbp0KeW7HRiDX5KPtJsGT/hPAaNNl9Pqwe/4uqX3sSi/oetMkeaW5VjXZbCcY6I3EW7hhs9vPhfIhZ1H/dL5vypSoHV/CrCdQzYG8MRjg8lmiZMwpawNYoy+HWD8uIXodtgvnP2q/azEcpqYcLw0Pu9EkHjjxtgXFn6d/zxRmAE0M9AF8j6f2DYEzcaF7e9/AhASXUmJjxzXPx3IIbyu3w7wUmen+goPXYjuStqpXlJNwu5H/LldZnCq7edgb9xPBDAQXDxzuIgdKR8IExlhLjam5RgGLBPfdwvtg23E7LdGDbkpQHvWLcIcreiHePJ3Fx+rEB+FN+lgNLcX8CPbB/IjlW9ij9S7mfEpk0cUIo15h+QCHFngs/ZfNmcmiTQErrYy8EkIC3lXS+hv4FEFpu4oCy6gg/WV3RwWky8c43U5c/urWMy+7lC+gUSqgdMtTpwYYYABNpVkdsopOJzynncx0wVd1MhF6FeKPo4rjMVUzIHfQZ0AYYJVkhzHurGBH/e1QFUOS6zhq7ezS6OYyl0SKdyhT19JcyU4J8zDS/amEq/w==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(23010399003)(36860700016)(7416014)(376014)(6133799003)(18002099003)(22082099003)(11063799006)(56012099006)(261026140227099003)(261021123027099003)(261021121427099003)(261022075727099003)(261102123227099003)(261009223027099003)(261022105027099003)(261028144727099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	RXIAvHgej9BSzs4XM+Tzg1KpibaQgrpWRRqRZgXcUQIyXMY0iAXsjrcfihHB2fU6bFe+27zkuJv57rz78XQEXfhaobFow4SCmWwwRynEJ0L1ILrRWa2RvAIQAlchC/41zrwXuEEBxp3ppRHoT0njDfwKfuhsbrQ6R449krbEGvm0EuWQtCg7iZiuR+yNW5vUMKVHEzjDXQO5vqxoVjC62G/zOBRTnzY8fgkMforD8QARlPmgNWQbgUv4VsD8U4ncKXA1CmYmqOvEtSVgFCcsmoD99qmrmnvvGRVUOoPgwMqNncfjD2Q0ilWU6pSQHZ1W3vRRImJHJjiUkYwxyrys/VhpyEX4hYQprZ3G6L52yu12GSQfM5lXJsHmCD3qzYPQsWi+PsMY+e6Yem290pg5kGAW6OcDkfEwuie5d7TbQZbUJ39iiv4cMfgd4TJrBWvl
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 21:57:28.3251
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 673ec211-3e64-48b6-358b-08df4c084367
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM3PEPF000265BA.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5790

From: Jianbo Liu <jianbol@nvidia.com>

mlx5e_ipsec_init_macs() falls back to a neighbour lookup when the route
lookup yields no neighbour, but always in the ARP table. For an IPv6 SA
the first four bytes of the address are used as an IPv4 key: the SA
takes the MAC of an unrelated ARP entry, or creates one, probes for it
and drops traffic waiting for a reply that never comes.

Look the neighbour up in the table of the SA's address family.

Found while debugging IPsec tunnel failures on a ConnectX-8 Kubernetes
cluster. Reproduced on ConnectX-7 (fw 28.48.1000): IPv6 RX SA with an
unreachable route to the peer fd00:99::2. An ARP entry for 253.0.0.153
is probed and the SA drops all packets. With the fix the peer is
resolved by ND and traffic passes.

Fixes: 37a417ca911a ("net/mlx5e: Support IPsec RX packet offload in tunnel mode")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c   | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 4daad648460f..4084f8a88695 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -365,9 +365,15 @@ static void mlx5e_ipsec_init_macs(struct mlx5e_ipsec_sa_entry *sa_entry,
 	return;
 
 neigh:
-	n = ipv4_neigh_lookup(netdev, pkey);
+	if (addrs->family == AF_INET)
+		n = ipv4_neigh_lookup(netdev, pkey);
+	else
+		n = ipv6_neigh_lookup(netdev, pkey);
 	if (!n) {
-		n = ipv4_neigh_create(netdev, pkey);
+		if (addrs->family == AF_INET)
+			n = ipv4_neigh_create(netdev, pkey);
+		else
+			n = ipv6_neigh_create(netdev, pkey);
 		attrs->drop = true;
 		if (IS_ERR(n))
 			return;
-- 
2.44.0

