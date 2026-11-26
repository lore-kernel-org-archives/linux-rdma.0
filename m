Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795730249;
	b=b6Uucu1yLWeiMkkYXisUGH9XeMvcc542ekwqHgz1HWkcL0YoiZYZFar/9aYbuEvW4kXO
	 mAkMF5S2GLCX+WaYmGNcXgNWuTjKRNNCAJ+wdATvf2DvryrrZe4uOmUFMTOWUctE135lw
	 MrwAFN2ERj8hUJwJ0mEHvvzOfWl2/xGL3uqOH6ltvr+2LalUXb9qbzKPz9kCRIEWMmNwz
	 3wUSXEJB/Cw4GPoSkdzcUuJQeajg8U3OpxOBXkZkGnpIHe3FVKVEfL9enQ28mmSJWibB6
	 AgC9tOc4Cn6GoKzekA1wsnEa9OwSmEQBm7eQMN5/EH5Nz6dtleajk42KvEDmdILsWsQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795730249;
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
	bh=roN8t1VNV6P86hkMTVMYJrcGzNreWqEx1R3M86eNpCg=;
	b=HbDjzqu6qMl2H9gMpqJ9JiDsJZAY+802CvKEPef8fPkzMG/YKQUokueFKimprjwcoxLW
	 9x/0grVdJke8SJEdiDC3uu6uEXKV8CGtQgZHmyDrJxvsDfieDcYih1SPAAqKcF6lyyQWI
	 cVBqZ3EygOYVv5BnpyDVwM0G4gYxYiELjocWwyVU5K3cbY8V501igifYT78VZVNI+wpsX
	 vlcOtB9vWZHjSrHgnPw/CCs5qp8kGL9hH6JXoxzBGlq3VhgSGOzjexy8MjOsZptZ9o1CD
	 phU1FWJiiT4hce/POI5zMRG60go3CzJx7wdEy2yh5dRW//KnbfiHgShnfQ6+x8NCNjg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=mHB2bhLS;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.42
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010042.outbound.protection.outlook.com [40.93.198.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A571606A338;
	Thu, 26 Nov 2026 21:57:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A571606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=mHB2bhLS
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K7/l5Wqrvo+b41S4X/9TymAqtshUHW0o1+ZOe/TbLvzUEVtLPZXEXAgvoAR6yGtPrHOMegaD+tvYGrgbpErfPOxSDkmGWmwRHLdJ6iCC9VbDYSqLOH3+xwEZZNT3K13aGO16CXo935LAGXkF4Usv7ZnBgpo+z+RDtUTegEwZXItyFLtUdek+FLCg18LBkpFa7rxl5JpVwxBayUKpN8Z7BAIFPhSBpevIfgu5vCI5NGuCldJJucBslNuA6/j2WzA+QRS13IPO28d0xs1DYMQxSAOCE+BKvL7q9+tJgIp//n3/uTCHUVdbEotqt3oXmexWKPZHtkVp0N0hpK7GuCAp6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=roN8t1VNV6P86hkMTVMYJrcGzNreWqEx1R3M86eNpCg=;
 b=tacNQtcz3fc3b7jFD3JhZjdV+RMXeK0GkyCTyuNSNmWf6ZzxwMo3AJPnysGfeIGPNQwXdhv23Sx8c5TjNiYxko3JRnFvI2m14dfgt0sxs3C5mundI+ik6yzvlCS5WZeRD/jy51wjDX4m81jSv8Ns8xYjWu9Kfpe/6FfhsTdiQLNB/hpvk7NBhlRu+HBpTDopAmCdHBcpuIJzE+vh73tjPArx2G63RAar4xVztwenZbNPt+t782uqt4iHvvlALHkAYO1odMAg/V/ybe62rafENya4hSCcraYgRUy8Tqtl4BOwyqgDyyeoygkizPraNP7Eky3WTBeAFlEbCzLP2eZJew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=roN8t1VNV6P86hkMTVMYJrcGzNreWqEx1R3M86eNpCg=;
 b=mHB2bhLSSG6brS4Rhbtn4FDS2RyVDUO/hIM6LaGa8V/37JkxXeAL8VXdJjyd+T6aGlO0OunMPxxJOKER6+nB+OVz871kZ8GyIC22qwfoF7IjfZ5o54geD90iBGdn8QNlis5VuIn/3nlRmCCyHyw0INzLEZD85mucPTCeZPV7CRi0SV7tEITaa37pJdulEF4D61XhJo6ZRfwkx3w+XvirFfCH3W3UdQMSzL+t3j5CvixukO5cp4gpq62q5hKkU/ZgCiAx/oasAClkBU97ogWtHakxi3j083XFKOrPMmZiSRhD2J3yqN86D8sXedyp6/lYryVrItBPxPggH73CmTe1sQ==
Received: from CH2PR16CA0005.namprd16.prod.outlook.com (2603:10b6:610:50::15)
 by MW3PR12MB4490.namprd12.prod.outlook.com (2603:10b6:303:2f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Thu, 26 Nov
 2026 21:57:23 +0000
Received: from CH2PEPF000166C0.namprd04.prod.outlook.com
 (2603:10b6:610:50:cafe::28) by CH2PR16CA0005.outlook.office365.com
 (2603:10b6:610:50::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.7 via Frontend Transport; Thu, 26
 Nov 2026 21:57:23 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH2PEPF000166C0.mail.protection.outlook.com (10.167.252.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.688.5 via Frontend Transport; Thu, 26 Nov 2026 21:57:23 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 26 Nov
 2026 13:57:15 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Thu, 26 Nov 2026 13:57:15 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Thu, 26 Nov 2026 13:57:09 -0800
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
Subject: [PATCH net 05/10] net/mlx5e: Drop IPsec tunnel traffic if the neigh cannot be created
Date: Thu, 26 Nov 2026 23:56:09 +0200
Message-ID: <20261126215614.792598-6-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF000166C0:EE_|MW3PR12MB4490:EE_
X-MS-Office365-Filtering-Correlation-Id: 4099f844-6a0b-4779-9ed9-08df4c08409f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|1800799024|36860700016|376014|7416014|6133799003|18002099003|22082099003|56012099006|11063799006|261022075727099003|261102123227099003|261021123027099003|261022105027099003|261021121427099003|261026140227099003|261028144727099003|261009223027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	QqfyZoK/ULV2t0ffajmWWZs5IvhD4ThzjZfOLXYXXgZRXNMVtu2bG7N+sTjugQuAK8YAnpSaFRML98shlLlVVm1Nto8AlYHdgzZBPG3bXOvPDj8ll1szXpfzstqNJPBqGvy5HFEKY/TcsWDIbEAxhjwRuXCyaWXK931WXRxxOV6c+H6RPYsPbTLzrpQJf4syyU4dTrqgzhInLBtJaDUbkO3+YVS4f42EebyTuLDBQTjjcKZ+zB6wvbvHjIqP5QrbXMhzb9++JNphVdbXrQghtsj9DaRfdRVMdTAmsznGPs4xxzPpGaISB2U00VJVYRJEYawxA4zkaRhTpzHkMSov+/Ms6sYGbBAokWeVD8aqGjk1/dj+JTXN+ZORVVq9FcZ7UPnQVJwYkghEgIWSTwaD7+jFybjea03rZQgxwmG6bHnidW5ACtA1tRAq5/XGZv7SCQxQNxEOblLSrv/FyS2FYDhblMui6v7okJjPCTKa6DhxgHYfnisw1Bgp2CrBII1fqs7F5vvwsdnhkrdiwEa0Zctba86aZPedXnPwE6CvAylLvFIBo2EzgHtZvjUNoMitdZWponAFFBPs9V1VSeMozvzdUilUEXgRE7kIsWXfbsw31hJruZAcbHyc9n5KCxaXUxrI+USSDzYT04IEQwsxsgBxEc07RhwTd3I453s+VP/snmcJnr6zxX+0hk7oKnsi
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(1800799024)(36860700016)(376014)(7416014)(6133799003)(18002099003)(22082099003)(56012099006)(11063799006)(261022075727099003)(261102123227099003)(261021123027099003)(261022105027099003)(261021121427099003)(261026140227099003)(261028144727099003)(261009223027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	V24TsBHjWcB9y/MGD5SLtxNFp0uEPTjMkmK/PSg4guz1PgpMtGEQFuHd4iCJb6doACnUGU6TEZMVN9l+YO/Wr2w44uO8zwh0nfO+Xv2HP7H7sxWMiAkQ52X95bKtUVLKvPMa5ZnHxaLu59mLEGbW7nitQ3tGtU9Z+fyiZHSTAPd/1fdGjl9gJVyJIc/6y97RR2A6urRoV8Bs9Loj/EafsA6CyeoTi8/0TMe/KBobPp58x5/7TtndIRNPUw2iLFgUoMGRlRc/OVa2mQ4sSLEpPAOKDF5UtOlCtiMJkNV147HU+1OYX7QdjticYRxtxNqSyJRuSjwIKHJcWPPcFoG7BLH8OtEsZdW7i1XbP4Xt2Uwo5jBOJ3a9im0yvUiOmrYdnCcfOzQg2xKcuCIcWqrbzHniPbw4/mlDPcrEkVEEtVGX3A9cB2zEJoKYwHQb7Y2k
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 21:57:23.6018
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4099f844-6a0b-4779-9ed9-08df4c08409f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF000166C0.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4490

From: Jianbo Liu <jianbol@nvidia.com>

When no route resolves the peer, mlx5e_ipsec_init_macs() creates a
neigh for it. If that fails the SA is installed with an all-zero
destination MAC and forwarding enabled. Drop instead, as for a created
but still unresolved neigh.

Triggered during code development. Reproduced on ConnectX-7 (fw
28.48.1000): add the TX SA while the ARP table is full (gc_thresh1-3 =
0), then forward packets through it. All of them leave with
destination MAC 00:00:00:00:00:00. With the fix none leave until the
neigh resolves.

Fixes: 4c24272b4e2b ("net/mlx5e: Listen to ARP events to update IPsec L2 headers in tunnel mode")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index ea7a1ae2056f..4daad648460f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -368,10 +368,10 @@ static void mlx5e_ipsec_init_macs(struct mlx5e_ipsec_sa_entry *sa_entry,
 	n = ipv4_neigh_lookup(netdev, pkey);
 	if (!n) {
 		n = ipv4_neigh_create(netdev, pkey);
+		attrs->drop = true;
 		if (IS_ERR(n))
 			return;
 		neigh_event_send(n, NULL);
-		attrs->drop = true;
 	} else {
 		neigh_ha_snapshot(addr, n, netdev);
 		ether_addr_copy(dst, addr);
-- 
2.44.0

