Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795730279;
	b=XMn0heWIULcgDgvPyv7N8sdSnVrnzMSUBvLMPx16fvPksnqZ2BYcGMKtx6j3yZrvNDms
	 r/+5Mw6Iom9nrSKRUR6Pl5wMxVJjFmu4zrBORvSOEMqQSM0RTGaDs3oRtkrZzowbwXxVZ
	 EIG6RwKvMyRvMiBj4EuuANYUKn94aJXQUovUVWlWcM5Tpt5Hlcg6lfUv5JGbLgJVXi5BN
	 twuYOylrKUilzVgbEy05A2e8DKZdgD5M66aN80cD4ifp16PwfQFrUtDstCUjnZIBYASDm
	 w/PnBB7TrSQMYAgwr8I9ERzRhtdcSOwGp9K7NV4H21lE6byW/vxuEkTrPMaoao1Pcgg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795730279;
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
	bh=9HXlr4f4Ox9AJPk/EuRJ8qOJ/ixhl9N5NbgODab4Q0E=;
	b=ZYAHdxSJTUP8l46r7/cV+r420M51/0sGI9g0SIu4rUzlElvRtwYUetPPmxpSfVSx52td
	 37RDqhKRm5VYLtLYKX4jSVg8v1e/oQNDSfJdyO/yHJYA7rE91vvpI/uHfcf+VzsOQkjIB
	 9Z1/3vTES/5z8hmn4SkpqzlI4X5OAHUmKBBM3VXh51sjFvxWTSxApMOUlu7A3sEMgyVh1
	 e/OTRkoALQLuXSGILjKOeGthcIIWyLSnbv7VbwZul94yTHaED6WmQBQdd7rgDM1q5WiS9
	 AhfcS/L0ccC5BxIhtz4mwF8ydFcqGJ0jJNa26ONg+jTIUMwOSmJe36zTmBdhrhO900g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=AqDkb3Z4;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.52
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010052.outbound.protection.outlook.com [40.93.198.52])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5317606A330;
	Thu, 26 Nov 2026 21:57:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5317606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=AqDkb3Z4
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X+C9oVYQvfDlxCv9MQKrVtOuY2FHUGvOeeAe7SFzUmpeX5aO7i79CENMpmTzOiB12xeQUcAzHfP17RiXF/3DewJKmeP3bkRrifNf2m6AZXc1gK8I5RaJHibB4GzRprnfsK9GaTy0UMAPZR52xFbe3MoSBZIhEKHs6wk7z2C+IF0X7H1kHxyZ25NDDj+MahIbCQSh8UII9Qs/OQ6wdDMrTwl16VuCFnoREAZJTIalgqAsX0U1N0YF+0kltVFxevO76HTn+m2vmrsZ4IkJuV5x6G22QiHpPHIiqRmzcJhx4iEQpQh1+E2lc4xWbPbWPOOCV+HBxlSr0bdvriJUFvfqew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9HXlr4f4Ox9AJPk/EuRJ8qOJ/ixhl9N5NbgODab4Q0E=;
 b=yfK4goNUEXPNQrX1LqVJgm5psqfS2MVcKnEJYB6BTI2kPPT934lKcE2elq+4cXxmVk1YLVO5HKR6Jic+RyYbHT2afoE+VCZUWHJdxpdHAwPfO6oCkZWnw/O3aYEzEKswI2R1qrbBVZ4NNBc3MKmYE4k0HzhmvukKgWM2oeFGiTRMdmMAiuqjpEChoWSVa43DauFW/Ahw3C1hqiOUMvcTOFPA46CXIq79jO2X/tHoNRaEcMth6iOwSIxLdnZc16Zs65KgeKnlTJXWQINefXj0BR3Rxw/f6qJYnnlRptVHDCluxraOZQziHDGW0By5l2FtYeMTi9nsL0rl51YACvYB/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9HXlr4f4Ox9AJPk/EuRJ8qOJ/ixhl9N5NbgODab4Q0E=;
 b=AqDkb3Z47i65Wla1nX1/Wx2LExygB1FvjvwHVHQo9/g3e3Uo4zgVdwfeYwKlQc1Hl54A3XoAr7kAXmEcylBoKPkkCDMjggIJJLiDg39ujrUJKVqmLmX8dQ53mqXsmKETzwhrt7meh+1Ghh3QALkAvBOMFhFaat6QQaf3Yjzs0sJdvD+vjgnqiHsioskBXF7YVF34xvvkxqdnkxvo23QedmdwvOlAnZnCcAtyZsNN0l2uHzyJMPoU1UZCvy+VFbr050eggaeXDDBsukzhRMgfkF26uhauYvdPPLP1yM3LO3bezP9ol6FTD6I8HQDJaUTdD7ZzBqZHq1b0c6efS/pMDw==
Received: from CH2PR18CA0044.namprd18.prod.outlook.com (2603:10b6:610:55::24)
 by SA1PR12MB999227.namprd12.prod.outlook.com (2603:10b6:806:4de::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Thu, 26 Nov
 2026 21:57:48 +0000
Received: from CH2PEPF000166BB.namprd04.prod.outlook.com
 (2603:10b6:610:55:cafe::9f) by CH2PR18CA0044.outlook.office365.com
 (2603:10b6:610:55::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.7 via Frontend Transport; Thu, 26
 Nov 2026 21:57:48 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH2PEPF000166BB.mail.protection.outlook.com (10.167.252.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.688.5 via Frontend Transport; Thu, 26 Nov 2026 21:57:48 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 26 Nov
 2026 13:57:46 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Thu, 26 Nov 2026 13:57:45 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Thu, 26 Nov 2026 13:57:40 -0800
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
Subject: [PATCH net 10/10] net/mlx5e: Create IPsec flow counters once per SA
Date: Thu, 26 Nov 2026 23:56:14 +0200
Message-ID: <20261126215614.792598-11-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF000166BB:EE_|SA1PR12MB999227:EE_
X-MS-Office365-Filtering-Correlation-Id: 24cb6d14-bbc2-45ea-4f44-08df4c084f31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|7416014|376014|36860700016|1800799024|6133799003|261009223027099003|261009223327099003|261009221727099003|261009221227099003|261009220027099003|22082099003|18002099003|3023799007|10067099003|11063799006|261026135527099003|261022105027099003|261022113327099003|261026130827099003|261022115727099003|261028144727099003|261022075727099003|56012099006|261026140227099003|261026121527099003|261021135927099003|261021121427099003|261021133027099003|261021130227099003|261021123027099003|261102123227099003;
X-Microsoft-Antispam-Message-Info:
	HAf4tifasSB4zZgD/hXomZiokrgHae1/Ef9amaUkk/PCPEqaE25XFkPuqcDp17JQbiI1LcxVGO9eCb51sSF3gdal0VBQKGO5Sv4RkT2a0LKEB/RCVyRlg1nn7KfHL4dvfBZ2mlqChBkcxq/2hLzjhV91NdY3/NyRkpLLkg1pD4Em3gUMdeJWPqsQVJrU7YZp2Nvbd+2TWKQ1geEEboKshuTzynrK8cFUlGKNqUtBz8gJeV3oHd5DgACbU2sNgPzwDN1QZ9iyYH6726ld7ixQOPb5TfpiW3CQ+2HlDtOtWVxEaCtowBmkLwpBCZbxTYBG95jaZkadyh1pMGMtSUixF4aSbHioacsFz37FSgiwJkCcb9eaeDJbWqwuPmrF6ApVOmJFqKEk+0mapVQs0bqunPjcG7iMJPMptEz4TELsG+44Z6cm7MyiEnQzdiAmyIkxrsueAeFrVMd90M+Z95Wvs40cFZhGw1iA1IGXfELCM2e80bokiwCknihImqnkp4IT5pMTcki3cF/HR6scjDTfstwWzhGXWVCUv5DBRYqQQ/J71jxqU65lo46gd3aFJy/gfgN2bT35cWh7Y+wQ4pgHIIdlzo9L5vZKd1XuxOUZ/r10r4NqB0HEXWBuu9LGXxctO+95SoxEJK62jp5IaGihYJyEU54/kJH7pdyQuqdGXefuwDSWmQ5FSFzrxb2rWODKcDrLgYkNDEmkaol18a+Dbg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(7416014)(376014)(36860700016)(1800799024)(6133799003)(261009223027099003)(261009223327099003)(261009221727099003)(261009221227099003)(261009220027099003)(22082099003)(18002099003)(3023799007)(10067099003)(11063799006)(261026135527099003)(261022105027099003)(261022113327099003)(261026130827099003)(261022115727099003)(261028144727099003)(261022075727099003)(56012099006)(261026140227099003)(261026121527099003)(261021135927099003)(261021121427099003)(261021133027099003)(261021130227099003)(261021123027099003)(261102123227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	stj27ByrOl63tJ/3WERwwfx549CCZV47EiNNM+CvQ1ZyvDI1OCcxoXW622UbHkS2rK9YpJ/4hxkLlPXQYnLN0PhlTEV4+Ida35MXTDOk/27qQbsP2o9VzFKTn2XW68bCRdzHpCXIwjJ5dLPppNsy4HUf9opWapg0DpXbHbYPQ+GL89O2MuY1vT42JIknaQlf5hQ2PzvJvUh1cAFQiF/DLvP2kUcA3unvDDOtB1HjsNauyKw/EG4NPBQFXKdzfkUMZwfybELQ6YAP0O8t+JFj+BfeB6QaDJ16POQsKUqKNNJADNkrVzLvaiGYMMwUc2L8xGeohkINdvhWoN03DvqQGYjYUW5CwjKtEAcHYvFl1Vm8pldst//PzoWs2/9UQS86ZpqBXbhGptnpqTu+Pc16klwQ8tQi/T/cZEEANxsv1/pEKBDWlEVVbYpikkDVH5e2
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 21:57:48.0508
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 24cb6d14-bbc2-45ea-4f44-08df4c084f31
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF000166BB.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB999227

From: Jianbo Liu <jianbol@nvidia.com>

IPsec counters are recreated on rule updates (e.g. due to a neighbour
update), which loses the previous counter values and may race with the
stats update itself.

Create the counters once when the SA is added and destroy them when it
is freed. Move the counters to the SA itself now that they're no longer
owned by the rule.

Triggered in CI testing. Reproduced on ConnectX-7 (fw 28.48.1000):
800 pings through tunnel mode SAs while about 3900 "ip neigh replace"
commands switch the peer neighbour between reachable, stale and delay
(same MAC). x->curlft.packets shows 180 on the TX SA and 88 on the RX
SA. With the fix both show 800.

Fixes: 4c24272b4e2b ("net/mlx5e: Listen to ARP events to update IPsec L2 headers in tunnel mode")
Fixes: dddb49b63d86 ("net/mlx5e: Add IPsec and ASO syndromes check in HW")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       |  20 ++-
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  12 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 135 +++++++++---------
 3 files changed, 92 insertions(+), 75 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 60f7dc3df355..d37c1deca307 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -900,12 +900,16 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 	if (err)
 		goto release_dwork;
 
-	err = mlx5e_accel_ipsec_fs_add_rule(sa_entry);
+	err = mlx5e_accel_ipsec_fs_alloc_counters(sa_entry);
 	if (err)
 		goto err_hw_ctx;
 
 	INIT_WORK(&sa_entry->event_work, mlx5e_ipsec_handle_event);
 
+	err = mlx5e_accel_ipsec_fs_add_rule(sa_entry);
+	if (err)
+		goto err_counters;
+
 	/* We use *_bh() variant because xfrm_timer_handler(), which runs
 	 * in softirq context, can reach our state delete logic and we need
 	 * xa_erase_bh() there.
@@ -938,6 +942,8 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 
 err_add_rule:
 	mlx5e_accel_ipsec_fs_del_rule(sa_entry);
+err_counters:
+	mlx5e_accel_ipsec_fs_free_counters(sa_entry);
 err_hw_ctx:
 	mlx5_ipsec_free_sa_ctx(sa_entry);
 release_dwork:
@@ -991,6 +997,7 @@ static void mlx5e_xfrm_free_state(struct net_device *dev, struct xfrm_state *x)
 		cancel_delayed_work_sync(&sa_entry->dwork->dwork);
 
 	mlx5e_accel_ipsec_fs_del_rule(sa_entry);
+	mlx5e_accel_ipsec_fs_free_counters(sa_entry);
 	mlx5_ipsec_free_sa_ctx(sa_entry);
 	kfree(sa_entry->dwork);
 	if (sa_entry->work)
@@ -1151,8 +1158,8 @@ static void mlx5e_xfrm_advance_esn_state(struct xfrm_state *x)
 static void mlx5e_xfrm_update_stats(struct xfrm_state *x)
 {
 	struct mlx5e_ipsec_sa_entry *sa_entry = to_ipsec_sa_entry(x);
-	struct mlx5e_ipsec_rule *ipsec_rule = &sa_entry->ipsec_rule;
 	struct net *net = dev_net(x->xso.dev);
+	struct mlx5_fc **fcs = sa_entry->fcs;
 	u64 trailer_packets = 0, trailer_bytes = 0;
 	u64 replay_packets = 0, replay_bytes = 0;
 	u64 auth_packets = 0, auth_bytes = 0;
@@ -1168,12 +1175,12 @@ static void mlx5e_xfrm_update_stats(struct xfrm_state *x)
 		return;
 
 	if (sa_entry->attrs.dir == XFRM_DEV_OFFLOAD_IN) {
-		mlx5_fc_query_cached(ipsec_rule->auth.fc, &auth_bytes,
+		mlx5_fc_query_cached(fcs[MLX5_IPSEC_FC_AUTH], &auth_bytes,
 				     &auth_packets, &lastuse);
 		x->stats.integrity_failed += auth_packets;
 		XFRM_ADD_STATS(net, LINUX_MIB_XFRMINSTATEPROTOERROR, auth_packets);
 
-		mlx5_fc_query_cached(ipsec_rule->trailer.fc, &trailer_bytes,
+		mlx5_fc_query_cached(fcs[MLX5_IPSEC_FC_TRAILER], &trailer_bytes,
 				     &trailer_packets, &lastuse);
 		XFRM_ADD_STATS(net, LINUX_MIB_XFRMINHDRERROR, trailer_packets);
 	}
@@ -1182,13 +1189,14 @@ static void mlx5e_xfrm_update_stats(struct xfrm_state *x)
 		return;
 
 	if (sa_entry->attrs.dir == XFRM_DEV_OFFLOAD_IN) {
-		mlx5_fc_query_cached(ipsec_rule->replay.fc, &replay_bytes,
+		mlx5_fc_query_cached(fcs[MLX5_IPSEC_FC_REPLAY], &replay_bytes,
 				     &replay_packets, &lastuse);
 		x->stats.replay += replay_packets;
 		XFRM_ADD_STATS(net, LINUX_MIB_XFRMINSTATESEQERROR, replay_packets);
 	}
 
-	mlx5_fc_query_cached(ipsec_rule->fc, &bytes, &packets, &lastuse);
+	mlx5_fc_query_cached(fcs[MLX5_IPSEC_FC_RULE], &bytes, &packets,
+			     &lastuse);
 	success_packets = packets - auth_packets - trailer_packets - replay_packets;
 	x->curlft.packets += success_packets;
 	/* NIC counts all bytes passed through flow steering and doesn't have
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index e70189f81ffb..2e8c6fc216de 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -216,13 +216,20 @@ struct mlx5e_ipsec_drop {
 	struct mlx5_fc *fc;
 };
 
+enum {
+	MLX5_IPSEC_FC_RULE,
+	MLX5_IPSEC_FC_REPLAY,
+	MLX5_IPSEC_FC_AUTH,
+	MLX5_IPSEC_FC_TRAILER,
+	MLX5_IPSEC_FC_NUM,
+};
+
 struct mlx5e_ipsec_rule {
 	struct mlx5_flow_handle *rule;
 	struct mlx5_flow_handle *status_pass;
 	struct mlx5_flow_handle *sa_sel;
 	struct mlx5_modify_hdr *modify_hdr;
 	struct mlx5_pkt_reformat *pkt_reformat;
-	struct mlx5_fc *fc;
 	struct mlx5e_ipsec_drop replay;
 	struct mlx5e_ipsec_drop auth;
 	struct mlx5e_ipsec_drop trailer;
@@ -295,6 +302,7 @@ struct mlx5e_ipsec_sa_entry {
 	u32 ipsec_obj_id;
 	u32 enc_key_id;
 	struct mlx5e_ipsec_rule ipsec_rule;
+	struct mlx5_fc *fcs[MLX5_IPSEC_FC_NUM];
 	struct mlx5e_ipsec_work *work;
 	struct mlx5e_ipsec_dwork *dwork;
 	struct work_struct event_work;
@@ -329,6 +337,8 @@ void mlx5e_accel_ipsec_fs_cleanup(struct mlx5e_ipsec *ipsec);
 int mlx5e_accel_ipsec_fs_init(struct mlx5e_ipsec *ipsec, struct mlx5_devcom_comp_dev **devcom);
 int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry);
 void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_ipsec_sa_entry *sa_entry);
+int mlx5e_accel_ipsec_fs_alloc_counters(struct mlx5e_ipsec_sa_entry *sa_entry);
+void mlx5e_accel_ipsec_fs_free_counters(struct mlx5e_ipsec_sa_entry *sa_entry);
 int mlx5e_accel_ipsec_fs_add_pol(struct mlx5e_ipsec_pol_entry *pol_entry);
 void mlx5e_accel_ipsec_fs_del_pol(struct mlx5e_ipsec_pol_entry *pol_entry);
 void mlx5e_accel_ipsec_fs_modify(struct mlx5e_ipsec_sa_entry *sa_entry);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index d0f738fdeff3..df90ae327f23 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -195,6 +195,39 @@ static void ipsec_rx_rule_add_match_obj(struct mlx5e_ipsec_sa_entry *sa_entry,
 	}
 }
 
+static const char * const fc_names[MLX5_IPSEC_FC_NUM] = {
+	[MLX5_IPSEC_FC_RULE] = "decrypt",
+	[MLX5_IPSEC_FC_REPLAY] = "replay drop",
+	[MLX5_IPSEC_FC_AUTH] = "auth drop",
+	[MLX5_IPSEC_FC_TRAILER] = "trailer drop",
+};
+
+static int rx_create_counters(struct mlx5e_ipsec_sa_entry *sa_entry)
+{
+	bool packet = sa_entry->attrs.type == XFRM_DEV_OFFLOAD_PACKET;
+	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
+	struct mlx5_fc *fc;
+	int i, err;
+
+	for (i = 0; i < MLX5_IPSEC_FC_NUM; i++) {
+		if (i == MLX5_IPSEC_FC_REPLAY && !packet)
+			continue;
+
+		fc = mlx5_fc_create(mdev, true);
+		if (IS_ERR(fc)) {
+			err = PTR_ERR(fc);
+			mlx5_core_err(mdev,
+				      "Failed to create ipsec rx %s counter, err=%d\n",
+				      fc_names[i], err);
+			mlx5e_accel_ipsec_fs_free_counters(sa_entry);
+			return err;
+		}
+		sa_entry->fcs[i] = fc;
+	}
+
+	return 0;
+}
+
 static int rx_add_rule_drop_auth_trailer(struct mlx5e_ipsec_sa_entry *sa_entry,
 					 struct mlx5e_ipsec_rx *rx)
 {
@@ -204,7 +237,6 @@ static int rx_add_rule_drop_auth_trailer(struct mlx5e_ipsec_sa_entry *sa_entry,
 	struct mlx5_flow_destination dest = {};
 	struct mlx5_flow_act flow_act = {};
 	struct mlx5_flow_handle *rule;
-	struct mlx5_fc *flow_counter;
 	struct mlx5_flow_spec *spec;
 	int err;
 
@@ -212,19 +244,10 @@ static int rx_add_rule_drop_auth_trailer(struct mlx5e_ipsec_sa_entry *sa_entry,
 	if (!spec)
 		return -ENOMEM;
 
-	flow_counter = mlx5_fc_create(mdev, true);
-	if (IS_ERR(flow_counter)) {
-		err = PTR_ERR(flow_counter);
-		mlx5_core_err(mdev,
-			      "Failed to add ipsec rx status drop rule counter, err=%d\n", err);
-		goto err_cnt;
-	}
-	sa_entry->ipsec_rule.auth.fc = flow_counter;
-
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_DROP | MLX5_FLOW_CONTEXT_ACTION_COUNT;
 	flow_act.flags = FLOW_ACT_NO_APPEND;
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
-	dest.counter = flow_counter;
+	dest.counter = sa_entry->fcs[MLX5_IPSEC_FC_AUTH];
 	if (rx == ipsec->rx_esw)
 		spec->flow_context.flow_source = MLX5_FLOW_CONTEXT_FLOW_SOURCE_UPLINK;
 
@@ -241,16 +264,7 @@ static int rx_add_rule_drop_auth_trailer(struct mlx5e_ipsec_sa_entry *sa_entry,
 	}
 	sa_entry->ipsec_rule.auth.rule = rule;
 
-	flow_counter = mlx5_fc_create(mdev, true);
-	if (IS_ERR(flow_counter)) {
-		err = PTR_ERR(flow_counter);
-		mlx5_core_err(mdev,
-			      "Failed to add ipsec rx status drop rule counter, err=%d\n", err);
-		goto err_cnt_2;
-	}
-	sa_entry->ipsec_rule.trailer.fc = flow_counter;
-
-	dest.counter = flow_counter;
+	dest.counter = sa_entry->fcs[MLX5_IPSEC_FC_TRAILER];
 	MLX5_SET(fte_match_param, spec->match_value, misc_parameters_2.ipsec_syndrome, 2);
 	rule = mlx5_add_flow_rules(ft, spec, &flow_act, &dest, 1);
 	if (IS_ERR(rule)) {
@@ -265,12 +279,8 @@ static int rx_add_rule_drop_auth_trailer(struct mlx5e_ipsec_sa_entry *sa_entry,
 	return 0;
 
 err_rule_2:
-	mlx5_fc_destroy(mdev, sa_entry->ipsec_rule.trailer.fc);
-err_cnt_2:
 	mlx5_del_flow_rules(sa_entry->ipsec_rule.auth.rule);
 err_rule:
-	mlx5_fc_destroy(mdev, sa_entry->ipsec_rule.auth.fc);
-err_cnt:
 	kvfree(spec);
 	return err;
 }
@@ -283,7 +293,6 @@ static int rx_add_rule_drop_replay(struct mlx5e_ipsec_sa_entry *sa_entry, struct
 	struct mlx5_flow_destination dest = {};
 	struct mlx5_flow_act flow_act = {};
 	struct mlx5_flow_handle *rule;
-	struct mlx5_fc *flow_counter;
 	struct mlx5_flow_spec *spec;
 	int err;
 
@@ -291,18 +300,10 @@ static int rx_add_rule_drop_replay(struct mlx5e_ipsec_sa_entry *sa_entry, struct
 	if (!spec)
 		return -ENOMEM;
 
-	flow_counter = mlx5_fc_create(mdev, true);
-	if (IS_ERR(flow_counter)) {
-		err = PTR_ERR(flow_counter);
-		mlx5_core_err(mdev,
-			      "Failed to add ipsec rx status drop rule counter, err=%d\n", err);
-		goto err_cnt;
-	}
-
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_DROP | MLX5_FLOW_CONTEXT_ACTION_COUNT;
 	flow_act.flags = FLOW_ACT_NO_APPEND;
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
-	dest.counter = flow_counter;
+	dest.counter = sa_entry->fcs[MLX5_IPSEC_FC_REPLAY];
 	if (rx == ipsec->rx_esw)
 		spec->flow_context.flow_source = MLX5_FLOW_CONTEXT_FLOW_SOURCE_UPLINK;
 
@@ -319,14 +320,11 @@ static int rx_add_rule_drop_replay(struct mlx5e_ipsec_sa_entry *sa_entry, struct
 	}
 
 	sa_entry->ipsec_rule.replay.rule = rule;
-	sa_entry->ipsec_rule.replay.fc = flow_counter;
 
 	kvfree(spec);
 	return 0;
 
 err_rule:
-	mlx5_fc_destroy(mdev, flow_counter);
-err_cnt:
 	kvfree(spec);
 	return err;
 }
@@ -2049,7 +2047,6 @@ static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 	struct mlx5_flow_handle *rule;
 	struct mlx5_flow_spec *spec;
 	struct mlx5e_ipsec_rx *rx;
-	struct mlx5_fc *counter;
 	int err = 0;
 
 	rx = rx_ft_get(mdev, ipsec, attrs->addrs.family, attrs->type);
@@ -2094,11 +2091,6 @@ static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 		break;
 	}
 
-	counter = mlx5_fc_create(mdev, true);
-	if (IS_ERR(counter)) {
-		err = PTR_ERR(counter);
-		goto err_add_cnt;
-	}
 	flow_act.crypto.type = MLX5_FLOW_CONTEXT_ENCRYPT_DECRYPT_TYPE_IPSEC;
 	flow_act.crypto.obj_id = sa_entry->ipsec_obj_id;
 	flow_act.flags |= FLOW_ACT_NO_APPEND;
@@ -2117,7 +2109,7 @@ static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 		dest[0].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 		dest[0].ft = rx->ft.status;
 		dest[1].type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
-		dest[1].counter = counter;
+		dest[1].counter = sa_entry->fcs[MLX5_IPSEC_FC_RULE];
 		rule = mlx5_add_flow_rules(rx->ft.sa, spec, &flow_act, dest, 2);
 	}
 	if (IS_ERR(rule)) {
@@ -2145,15 +2137,12 @@ static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 
 	sa_entry->ipsec_rule.rule = rule;
 	sa_entry->ipsec_rule.modify_hdr = flow_act.modify_hdr;
-	sa_entry->ipsec_rule.fc = counter;
 	sa_entry->ipsec_rule.pkt_reformat = flow_act.pkt_reformat;
 	return 0;
 
 err_drop_reason:
-	if (sa_entry->ipsec_rule.replay.rule) {
+	if (sa_entry->ipsec_rule.replay.rule)
 		mlx5_del_flow_rules(sa_entry->ipsec_rule.replay.rule);
-		mlx5_fc_destroy(mdev, sa_entry->ipsec_rule.replay.fc);
-	}
 err_add_replay:
 	if (sa_entry->ipsec_rule.sa_sel) {
 		mlx5_del_flow_rules(sa_entry->ipsec_rule.sa_sel);
@@ -2162,8 +2151,6 @@ static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 err_add_sa_sel:
 	mlx5_del_flow_rules(rule);
 err_add_flow:
-	mlx5_fc_destroy(mdev, counter);
-err_add_cnt:
 	if (flow_act.pkt_reformat)
 		mlx5_packet_reformat_dealloc(mdev, flow_act.pkt_reformat);
 err_pkt_reformat:
@@ -2186,7 +2173,6 @@ static int tx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 	struct mlx5_flow_handle *rule;
 	struct mlx5_flow_spec *spec;
 	struct mlx5e_ipsec_tx *tx;
-	struct mlx5_fc *counter;
 	int err;
 
 	tx = tx_ft_get(mdev, ipsec, attrs->type);
@@ -2222,12 +2208,6 @@ static int tx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 		break;
 	}
 
-	counter = mlx5_fc_create(mdev, true);
-	if (IS_ERR(counter)) {
-		err = PTR_ERR(counter);
-		goto err_add_cnt;
-	}
-
 	flow_act.crypto.type = MLX5_FLOW_CONTEXT_ENCRYPT_DECRYPT_TYPE_IPSEC;
 	flow_act.crypto.obj_id = sa_entry->ipsec_obj_id;
 	flow_act.flags |= FLOW_ACT_NO_APPEND;
@@ -2241,7 +2221,7 @@ static int tx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 	dest[0].ft = tx->ft.status;
 	dest[0].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	dest[1].type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
-	dest[1].counter = counter;
+	dest[1].counter = sa_entry->fcs[MLX5_IPSEC_FC_RULE];
 	rule = mlx5_add_flow_rules(tx->ft.sa, spec, &flow_act, dest, 2);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
@@ -2251,13 +2231,10 @@ static int tx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 
 	kvfree(spec);
 	sa_entry->ipsec_rule.rule = rule;
-	sa_entry->ipsec_rule.fc = counter;
 	sa_entry->ipsec_rule.pkt_reformat = flow_act.pkt_reformat;
 	return 0;
 
 err_add_flow:
-	mlx5_fc_destroy(mdev, counter);
-err_add_cnt:
 	if (flow_act.pkt_reformat)
 		mlx5_packet_reformat_dealloc(mdev, flow_act.pkt_reformat);
 err_pkt_reformat:
@@ -2645,7 +2622,6 @@ void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
 
 	mlx5_del_flow_rules(ipsec_rule->rule);
-	mlx5_fc_destroy(mdev, ipsec_rule->fc);
 	if (ipsec_rule->pkt_reformat)
 		mlx5_packet_reformat_dealloc(mdev, ipsec_rule->pkt_reformat);
 
@@ -2661,25 +2637,48 @@ void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 		mlx5_modify_header_dealloc(mdev, ipsec_rule->modify_hdr);
 
 	mlx5_del_flow_rules(ipsec_rule->trailer.rule);
-	mlx5_fc_destroy(mdev, ipsec_rule->trailer.fc);
 
 	mlx5_del_flow_rules(ipsec_rule->auth.rule);
-	mlx5_fc_destroy(mdev, ipsec_rule->auth.fc);
 
 	if (ipsec_rule->sa_sel) {
 		mlx5_del_flow_rules(ipsec_rule->sa_sel);
 		mlx5_del_flow_rules(ipsec_rule->status_pass);
 	}
 
-	if (ipsec_rule->replay.rule) {
+	if (ipsec_rule->replay.rule)
 		mlx5_del_flow_rules(ipsec_rule->replay.rule);
-		mlx5_fc_destroy(mdev, ipsec_rule->replay.fc);
-	}
 	mlx5_esw_ipsec_rx_id_mapping_remove(sa_entry);
 	rx_ft_put(sa_entry->ipsec, sa_entry->attrs.addrs.family,
 		  sa_entry->attrs.type);
 }
 
+int mlx5e_accel_ipsec_fs_alloc_counters(struct mlx5e_ipsec_sa_entry *sa_entry)
+{
+	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
+	struct mlx5_fc *fc;
+
+	if (sa_entry->attrs.dir == XFRM_DEV_OFFLOAD_IN)
+		return rx_create_counters(sa_entry);
+
+	fc = mlx5_fc_create(mdev, true);
+	if (IS_ERR(fc))
+		return PTR_ERR(fc);
+
+	sa_entry->fcs[MLX5_IPSEC_FC_RULE] = fc;
+	return 0;
+}
+
+void mlx5e_accel_ipsec_fs_free_counters(struct mlx5e_ipsec_sa_entry *sa_entry)
+{
+	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
+	int i;
+
+	for (i = 0; i < MLX5_IPSEC_FC_NUM; i++) {
+		mlx5_fc_destroy(mdev, sa_entry->fcs[i]);
+		sa_entry->fcs[i] = NULL;
+	}
+}
+
 int mlx5e_accel_ipsec_fs_add_pol(struct mlx5e_ipsec_pol_entry *pol_entry)
 {
 	int err;
-- 
2.44.0

