Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795607928;
	b=nskeGDZTiD1bu3TrYGUKIBHJkz+dYlEBMb3Pl34qjMBZQXA2RhKGxKLNKV3tXF0rpXMd
	 N1d0JzkYnFAzq2Awc8LgWwyEn6KlCS4kxzynWuagGaZfOvj4bOORFylU0I8Pj7Z79lA1m
	 RbfQeKGW1b39sIImQOT883ghHk1Xw4H4fUtlbXQSgWvG/a3k3M8ng2jOZ7XZCHkpMj9q1
	 pVVnDWZMDf4ntFFeU+G0I6g9trJlduoDiYEpoC4G3votJ+eT6gRbA3lqk+KJej0q7HlVB
	 DOeY+zowmUEFNs0hOYNEjI+lpKnyuBAk8Zo9G3Ra7JbUJHSsoSYmxfUUZg++JGTZD3Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795607928;
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
	bh=yqQcspYYoRInCe6r3iWmxTDIt9KDBFnZQYMi673wqmg=;
	b=eUc1GYlatVKth/+dhUpY/coJs7YFiv/0BPvrt9EHuTlsyQlCp4MnUN/5hm1XjybUzP6b
	 3cEK5i9MR+d1KrYRphUe3xhZGKSsHXAq8luBlTfjh7y+I+ZJBEzOY8HdUtMkzzu6xM33W
	 mgNLYVzFaxyJfX4Y0YGutPpidNldocCwuNdQPiNNxTJsYM1C6f9FMK2+myYzC49JxvgJV
	 JgzENaIjI6ouira64AcGSMQL3gF9VPiDGAcCVnzepkfxm2i0wRqQvjh/FpXqkl4FCZv3/
	 uGYOAvmNTA0QXagNaXqJDJD50RSFB2TQ6dkihM2x/jSteUCCpgOQTyRfqVdanRaDEtw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=c5VapSyF;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.53
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011053.outbound.protection.outlook.com [40.93.194.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B48E606A31E;
	Wed, 25 Nov 2026 11:58:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3B48E606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=c5VapSyF
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iWyxKlw1iEpRdCQA5TZNoB2IaKZuLiGHuzzAVwMD3TihebxjyN7s3z0HRX3/Yte5rkL9h/d8scmFRkNCs0edlja9q+XXLFgzc4p6A/DH5D337mq6ZyVJuVWM76inn7xNKi1rJdpphdPIOG3OPX52oqBWks21ZpEWNbOr2m9VGZOSfZ9LAKf6qAODqWQuY9aMnV83RrQ0d0XzOYRVQP1hwKqTStcWBQWoH/xm91y1KhR8km0H9QegVHGCZWN6Nvpi3hl6TqvXCYM4SldMTIvytSEPpBnXeTtJ4HWHsJcpjkd1Pw89Tzk9WBPwRcD1hiPBWz92J1o0My55+TB0bIVXeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yqQcspYYoRInCe6r3iWmxTDIt9KDBFnZQYMi673wqmg=;
 b=G8kqsbs9qyvMGBxuI9vq8rfWvtyq+zX5zvVfZnPXjAlgaF9Al7z5IWVWm+DXppM0SMWrXjK4WGbHEHF2dWsu8KMSfM61lHMDBdTg8kQBzNLjkYzRiKvTSxLRW1rTHoljIO5JxlffNpw8iKMppyqqA9fEsrt498c8rid1JPznMG3DBGqxt+IbSAtHAn8oFjA37Y1DYP5ZE5iN+iVITYXBIN8aV5KbVkILy/BC9VWnbdEJYsP7k3YleBjxqTmLFZ9Cn2ciRt8uNcbZfyOeS6wW1VvbQNiuQmAJhPclPjG/W9GJl5gMetAW0HH2zfsfIXdXt0mB7UFwjEJdfljILfjiaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yqQcspYYoRInCe6r3iWmxTDIt9KDBFnZQYMi673wqmg=;
 b=c5VapSyFR2KnEOWmEFHn7D4kilGeByL5AmybbuSpDiGztWPU6EIPBtYnLJl4jS5x7EFwiLsluqj3tobQnr34fBOvRe/acJ1VJwHr3NzcFeY5xH+TV1Sq2soYutjnbpQVQzNaob5t6zouVkPelQykX9hkjwEY1ZfkKtvQxZkldjb+ZAUe0T8IUB1erxEJg3RnTz8SWl5eezckByruDjyF2QEKlCfzISzjF5/jZfysj93NoBhzYSkTyEUGCZ3RaSCq6BlsHEF79OhWSxT506BeKEC2Yg1gVLwXPa664Bb3w8CqeLCyBaRspGwVaNfcfJWZmEpBiEdCQ8Sm8yTEv7CYDw==
Received: from BL1PR13CA0336.namprd13.prod.outlook.com (2603:10b6:208:2c6::11)
 by IA0PPFD78AA37BB.namprd12.prod.outlook.com (2603:10b6:20f:fc04::be6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Wed, 25 Nov
 2026 11:58:40 +0000
Received: from IA0PEPF0000003E.namprd03.prod.outlook.com
 (2603:10b6:208:2c6:cafe::f) by BL1PR13CA0336.outlook.office365.com
 (2603:10b6:208:2c6::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.6 via Frontend Transport; Wed, 25
 Nov 2026 11:58:40 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 IA0PEPF0000003E.mail.protection.outlook.com (10.167.249.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.3 via Frontend Transport; Wed, 25 Nov 2026 11:58:40 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 25 Nov
 2026 03:58:25 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 25 Nov
 2026 03:58:25 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.57 via Frontend Transport; Wed, 25
 Nov 2026 03:58:20 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>
CC: Ariel Levkovich <lariel@mellanox.com>, Cosmin Ratiu <cratiu@nvidia.com>,
	Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, "Muhammad
 Zuhayr al-Tayyar" <mzuhayr@earthlink.iq>, Roi Dayan <roid@mellanox.com>,
	"Saeed Mahameed" <saeedm@mellanox.com>, Saeed Mahameed <saeedm@nvidia.com>,
	"Tariq Toukan" <tariqt@nvidia.com>
Subject: [PATCH net] net/mlx5: E-Switch, Fix offloaded nf flowtable rules never being hit
Date: Wed, 25 Nov 2026 13:58:15 +0200
Message-ID: <20261125115815.87909-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: IA0PEPF0000003E:EE_|IA0PPFD78AA37BB:EE_
X-MS-Office365-Filtering-Correlation-Id: d6bcb989-8be9-47d3-cd75-08df4aeb724c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|7416014|1800799024|82310400026|376014|261102123227099003|261026140227099003|261026121527099003|261022105027099003|261028144727099003|261021123027099003|10067099003|261021121427099003|11063799006|56012099006|261009223027099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	vYkYprn4rRtcGw8wAIuioA+VP/cHyyECviaYCEaBjmedxO76Wur4GI+sbuI2S7t8CqnTbV0TxiMZRWEaGsHl3waC4ipU6nwm8TZr3eTxcdVvqxOTBe2f/zJnArJ8bDD+x3tll2DEjmd101lXMZJqOeWdjrzVS2BTiCYueManHiyZr3A4WVX/8kQ3M3ms+qE3kYzRL6LFSTJgHWp+Tik6YLwNQLDD+GcvK1xKR3e0cEzNbYcL4o66VAsuNq5u2MdM9INewNc8TZtRLRxm/0eIShxNFzC6y62dLyIu/WpOQZ/fpVwVhRX+xZ3V0b+CVX7LphfXm9EU3Qq2NgINcpcQ5/ZP+eFcudqB8XKqFBPQBxCDYYW+m7Hi1q9fdZeFQ/O8atrZ4NDBB+dIvry9y56qTxVrjXJyJ4G9hp8Rw9UuHYLjeuIO+54VRKLEdeTDtOXDvnJWWDxHtFwnvTFaosV1DrtQU5YRpK4Y+8UXyAUsaflq0FSYau1hsbP2sPobziQDetqKoIc3KvA2NI0DWzlc7NAS2uizbCw4hC8ckf4CNTNp3MFCKANTi8FU5cIB3NDtmsJqmE/JLROFH5ylYEHHyHmcLOjn3Eqq+529axr0coRGaYSiXxyokl1npoemWRslBVmUq8eyLypqiieaoE26V86sq54ZXZxLJ00ZK5UKZ5EzZc/hRQvuoFrLSjYZer35H7g5xbL4mqPKGVBcxxWkfw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(7416014)(1800799024)(82310400026)(376014)(261102123227099003)(261026140227099003)(261026121527099003)(261022105027099003)(261028144727099003)(261021123027099003)(10067099003)(261021121427099003)(11063799006)(56012099006)(261009223027099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	5Nxh87Pd5NP6EPUPiX4HM2gloLoL2TsETsH8o10lhQptCdBzJjQOhGVEOiLUHYl9Q406MJzsGR0FA3bPk3jfJPQwSA6CedZoxBTNMW8gopRd0SbIIJ4TQRh3yeKC4d5Cuvx32WRX0fuhJkP9zwALMtvBq97wIZYkrfWhv2QAvUADnnHo12qFlNBh7tgY9LfkkZ5ycDvThav0kruHZv+OeDWdJqiszc2X+C2IrtMdzEZDwzJVX2cY0LPVuXIWuVyNo+UFyxIdrioQmzURA6xN6Wzywpo9rIGjRwJ+lUzcIwV+171L8J8OeIXzU3/J93XT5hgp+/EJI2VTkzUBu1vMf9U+r4PTayBZIdh+g6axFcnwkqw+YWLW0c/aZo77b7wxv6ix+6iuc0qS0l5hv8LmzFSNVpU3LrXHTfKp4zNopy4lV74x5DtkWHw49dPrCdl2
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 11:58:40.3601
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d6bcb989-8be9-47d3-cd75-08df4aeb724c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	IA0PEPF0000003E.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPFD78AA37BB

In switchdev mode, nf flowtable entries offloaded to the FDB are
installed but never hit, and the traffic keeps going through the slow
path.

esw_chains_create() opens the nf flowtable chain, then the root table
(chain 0, prio 1), and only then sets the nf flowtable table as the end
table of the chains. mlx5_chains_create_prio() takes the miss
destination of a new prio from the end table when the prio is created,
which for the root is still the default table, i.e. the slow path. So
the root misses to the slow path, and the nf flowtable chain is never
reached.

Another chain 0 prio, e.g. of a tc rule, hides the issue: the root's
miss is rewired to it, and its own miss goes to the nf flowtable chain.
This stays so after that prio is destroyed, until the eswitch is set up
again. Setups that always have such a prio, like OVS, don't hit it.

Set the end table before opening the root, as it was before the
offending commit.

Tested on ConnectX-6 Dx in switchdev mode, with two VFs routed through
their representors and an nftables flowtable with offload on them.
Without this patch, the connections are HW_OFFLOAD but 99% of their
packets go through the representors until a chain 0 prio 2 tc rule is
added; with it, they are forwarded by the eswitch from the start, in
both SMFS and DMFS.

Fixes: ae430332557a ("net/mlx5: Refactor multi chains and prios support")
Reported-by: Muhammad Zuhayr al-Tayyar <mzuhayr@earthlink.iq>
Closes: https://lore.kernel.org/netdev/AM0PR02MB4307F6D53A2B0AD628D91C81C6682@AM0PR02MB4307.eurprd02.prod.outlook.com/
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 474784131091..f71cd0303592 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1693,6 +1693,11 @@ esw_chains_create(struct mlx5_eswitch *esw, struct mlx5_flow_table *miss_fdb)
 		goto nf_ft_err;
 	}
 
+	/* Set the end table before opening the root, so that the root's
+	 * miss rule goes to the nf flowtable chain, not to the slow path.
+	 */
+	mlx5_chains_set_end_ft(chains, nf_ft);
+
 	/* Always open the root for fast path */
 	ft = mlx5_chains_get_table(chains, 0, 1, 0);
 	if (IS_ERR(ft)) {
@@ -1707,8 +1712,6 @@ esw_chains_create(struct mlx5_eswitch *esw, struct mlx5_flow_table *miss_fdb)
 			goto level_1_err;
 	}
 
-	mlx5_chains_set_end_ft(chains, nf_ft);
-
 	return 0;
 
 level_1_err:

base-commit: cc7fe6e741730fef549e484379281736d32746f0
-- 
2.44.0

