Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.8
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793729622;
	b=p1ezFjsIcwH8bu8DGmooq5mn4USWWe25HAg6xu+pJt85jH6geHVj6RMRSycClvp4T40o
	 5PLfGRS0iW/J14WZPNMIPnShkGCgTRG1I8JLC1JyNEl65ljIawO6vErrAlGMkGRdlM4NC
	 S5kYjoMsbLNW4Ljsz/fpepn9jAQShUhzzNK1CNTan0FXOqQMx2ZvnfI4hbd8PS4AkHEU+
	 BUX4cDrIo/Tuz+NAC5b/VnC/mmzMo0+SKTRbUzH2+h93X9Z1P5HydonbfOV25GHEUG/a3
	 RM5yCM43jnwEFt0LZtcm6ddDt3RvDa9qrUHV50Cjf+vq5DUVv4semh/8m6lh/sjrsMg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793729622;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding:X-NV-OnPremToCloud:X-EOPAttributedMessage:
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
	bh=1GvzldEDoUVjJTxx4yT6j1G/ZyyncMKIOYHKKj2tOcA=;
	b=xHkeEkGjQwLFG0ShezW5jbl6h99otgDnIt23xNzpRKQO+1PzWsTuQJugg01C5wpJP+4U
	 hbJ+SC2Kp4TXV0Mz6WVEmj/CQgg2QpgkJAg8k0DaedXhUybkCXDrrr0HmuFqJdiaiRH+Z
	 +AqQD8WqZ3NUadLcUlEZZIGECM43cczut99hG6zXSQopVY1WTT+0FdqxPEv07yLug5fy5
	 gl57sHxQxy0wjMN+x+h6Blalz7Wc7NLTu/HUubx52WQO7jcX8u2JT7r+fd7ZO7JULNWoy
	 IPxKFoH0fnfETGPfUni5/8FljGBO/ZFPD6Pw+yja3wIRHnZYu+usvPp5/Feu3gPJq2g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ilPf6PEP;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.8
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013008.outbound.protection.outlook.com [40.93.201.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8F0606A32C;
	Tue,  3 Nov 2026 18:13:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EE8F0606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ilPf6PEP
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dtBcPku9l87u9KKwU9dbUGHpOB6Oz/A2kOCN0O1TbrtDuzD7gKJlJZ7rTdjz5X7Dk4+RQbsl7p68GdK7OVT/zR06I6MLH7zr9T3j9x/8wY5gQCPcAoQcVvMXwSz0qAPUlI89j8trlbOmTtQSQKju64DgMRSRlU7ruWfg93ObUxa567vBPZO33DlbXnmeL6EyZ/se9JMe9Y2rkFj/t6oVJFG7keKULAsq1yrQ8WKpwxBIYVVPV65hA1W3E8I2ulQEYp93qtTLETetFvliNqPMRWQqXE5W7TSvKDhADrtZgX+FVeaCUIXBPDNtzC1V8PzPrF46VjloUZIkj42rWtOJNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1GvzldEDoUVjJTxx4yT6j1G/ZyyncMKIOYHKKj2tOcA=;
 b=s9ouzRPtq9Nj3RzDjWmehIXrJMXUHCQBivJQWHwDShDU/U/gkqY3H+Aewpj6j5k3vfgRe8bJzoW0Dch03bPaHBGgBXqB70PHeEXPeoMYa0Dzw3N6Doz9QPUyovpoW60pIetYCltjYV3gminMyq4yAKcp/CodNDHE177NDQUL2RpxTv0KGfXqGyvwnY7xvlOuo9OLxhCx5a/skKe7ULIGGhX43PPwh7viSCDTa8KgInwn1DasG4zphKPkPRwGl7uflidVdBE9BUfiL+1PJhP8urHAPBAqawmCeV6SBsejCl31ry/MIJeMZXxBeKnmysd+//WQatf4pF/3x85y6xibwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1GvzldEDoUVjJTxx4yT6j1G/ZyyncMKIOYHKKj2tOcA=;
 b=ilPf6PEPftW4/8lYWLhHlNFKy+231ZJjtYaLFB/0ZK8xDmPkO9AMu3czstT3G76VDRaU9B1Szerys6QIBs4XM3HQwmb6VQFA/LKFlZEfTNkV5qXfdOyHylZWuZONpq+kIdUude0zFD+uO2coaSt4QY2JP/AwrcsiGbzngE23rW5cTdRhVsxbESg8shEdaS2erAL8m9FdPnFAkseCAt59lr+JdLxVOTpsXoJ/5BkRat1HDdSfkg/g5ce+Y7Xo3aMe1sFB/4gEGL/2qZRuKHNefeQPfYfP+bX6xeVu3ZAW6NyBG0MP8kZhFgO/v5zGhuB2i1NMHldt8vOxd+k50kMQ8A==
Received: from CH5PR04CA0022.namprd04.prod.outlook.com (2603:10b6:610:1f4::19)
 by PH7PR12MB9065.namprd12.prod.outlook.com (2603:10b6:510:1f7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 18:13:33 +0000
Received: from DM3PEPF000265BD.namprd04.prod.outlook.com
 (2603:10b6:610:1f4:cafe::2c) by CH5PR04CA0022.outlook.office365.com
 (2603:10b6:610:1f4::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Tue, 3
 Nov 2026 18:13:33 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DM3PEPF000265BD.mail.protection.outlook.com (10.167.23.250) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 18:13:32 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 10:13:12 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 10:13:11 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Tue, 3 Nov 2026 10:13:07 -0800
From: Edward Srouji <edwards@nvidia.com>
To: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Andrew Lunn
	<andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas
	<yishaih@mellanox.com>
CC: Edward Srouji <edwards@nvidia.com>, <linux-rdma@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Mark Bloch
	<markb@mellanox.com>, Michael Gur <michaelgur@nvidia.com>, Patrisious Haddad
	<phaddad@nvidia.com>
Subject: [PATCH mlx5-next 3/5] net/mlx5: fs, refactor RDMA transport manager root namespace init/cleanup
Date: Tue, 3 Nov 2026 20:12:51 +0200
Message-ID: <20261103-rdma-rx-classifier-v1-3-1ad6c8cfe936@nvidia.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261103-rdma-rx-classifier-v1-0-1ad6c8cfe936@nvidia.com>
References: <20261103-rdma-rx-classifier-v1-0-1ad6c8cfe936@nvidia.com>
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
X-Mailer: b4 0.14.2
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PEPF000265BD:EE_|PH7PR12MB9065:EE_
X-MS-Office365-Filtering-Correlation-Id: 08d20358-474d-4fff-5626-08df39d62b9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|36860700016|376014|1800799024|23010399003|6133799003|22082099003|56012099006|261102123227099003|3023799007|261102130727099003|18002099003|10067099003|261009223027099003|921020|261021123027099003|261021121427099003|261022105027099003|261022075727099003|11063799006|261026121527099003|261028144727099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	hOQtgeDYt5F8QSpcPxYuAvFlJ1IAzZU9Z8oYaJhHQgKxhfm2Bs0JJunGzj5zRnBOUOMRgluUA9lwmfkeg7sbf3D4mDn9jwEZQiEHXLSVuIy714CiRX/z4hd4WrZRm4OpjA0bEWT/urDbAGiLwlIp8vRMKZHekzz+aCTojJACaUZtc4mYkue2U+bZ3feqQDsj/MYdGedJq9sV7wAygg0kZCFoQRffsu3wQXI2iwGTHM1ouSLiBh9NocV8GhxkwhHPS9RP1nlVoliu05Qc3VFdzat5AuHPV/6aO0Yy6o9awZ7gDqlGfSF1BQ9m+FUQQBuKySf/kvIFYz0QqAGSEtqm7pAEdIh12tZDanTZ83+KBd4UtPeWYixqcCcY4zoJEqWW6Archbp2J9H1SdLL2JpKU4zuItyqu9QHKxgTCufzkK3iItKpxsee7eZs+WxVzO4uo6Q/NPG4zgMZwxQovGB9EnKXpI8yiOP++ZmfHCcohsdNiksSttZCRzpyuXN3OvpNU+nAJf+tFJh9fVUhUCp79JssV+PLbMKNbh6wEqTsUsj1+Lpfqt4ys5DeGPwQcaCPyZN3kY3xXYT50knSuuy4Dyogzdwm1HAdjT9rc2XgEA0oHIWFyOvj/jg8pfMWAaLQJD/hz4XtT9wcEj5L4mrWko2ZBW1K2xXDJc32BlPpo2KZdgoqmyPiJPYbY0NG+3l2EPSJG8KdDhbc6AOBXOSSBoogePt/zuoM199GH+x+sxoM5YVOxovLrwMjSV00cdKT
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(36860700016)(376014)(1800799024)(23010399003)(6133799003)(22082099003)(56012099006)(261102123227099003)(3023799007)(261102130727099003)(18002099003)(10067099003)(261009223027099003)(921020)(261021123027099003)(261021121427099003)(261022105027099003)(261022075727099003)(11063799006)(261026121527099003)(261028144727099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	GXZ71D8NhD3SQALutlPOdwF1WVeibQx3aEDz6Wp/N1LSk3ENKFT0dJd2DNEdhThGFBb/Sv1U74UiZCslVqrwSdk8cVttqe5j5HyaN1YWKFAFqkBF1Fttf+rDdbl0I86D86cgYc9vBPzmbbT7NqWH531WTD4IVmWszpVcvkUz3jwrtx7W8+OtPI0KQbmabUwsnfIdQSjirSvkpDeLmca2MWfrxfcXCVAVZTIMA6PgHnfse6eHlSo/C23I8S0bWX8Cy6FtmWl1//TansAoGzbOLc1CQKclcSBwGqr+TAM3zthrsxvpkqV3j4a+WivZJOKl3D67UDGROcPbY5ogK8iCVrmbLLnoaNq51r5F+MYiczOZOMgsU4zL7Af9OdbT6zxOpvm9624kaZ2jjU9fpzzDmF3Q29/D/QtuZBIZY7du5g0EVVhV7oVV6eCbmdKQGkYy
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 18:13:32.5896
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 08d20358-474d-4fff-5626-08df39d62b9a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM3PEPF000265BD.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9065

From: Michael Gur <michaelgur@nvidia.com>

The rdma transport steering domains init, cleanup and helpers are
near-identical, merge them into single
init_transport_manager_root_ns()/_one() and
cleanup_transport_manager_root_ns() with parameters.

This is preparation for a new domain with the same per-vport root
namespace usage model, which will reuse these functions instead of
duplicating them a third time.
No functional change to RDMA_TRANSPORT_RX/TX.

Signed-off-by: Michael Gur <michaelgur@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Patrisious Haddad <phaddad@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 153 +++++++---------------
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h |  11 +-
 2 files changed, 53 insertions(+), 111 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 70545053f9c42d6f6ccf439852d14f9b9e16419f..033ea5a198ee0d5a7e77ce0770f38bb8ffe97812 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2817,20 +2817,20 @@ mlx5_get_flow_vport_namespace(struct mlx5_core_dev *dev,
 		else
 			return NULL;
 	case MLX5_FLOW_NAMESPACE_RDMA_TRANSPORT_RX:
-		if (vport_idx >= steering->rdma_transport_rx_vports)
+		if (vport_idx >= steering->rdma_transport_rx.vports)
 			return NULL;
-		if (steering->rdma_transport_rx_root_ns &&
-		    steering->rdma_transport_rx_root_ns[vport_idx])
-			return &steering->rdma_transport_rx_root_ns[vport_idx]->ns;
+		if (steering->rdma_transport_rx.root_ns &&
+		    steering->rdma_transport_rx.root_ns[vport_idx])
+			return &steering->rdma_transport_rx.root_ns[vport_idx]->ns;
 		else
 			return NULL;
 	case MLX5_FLOW_NAMESPACE_RDMA_TRANSPORT_TX:
-		if (vport_idx >= steering->rdma_transport_tx_vports)
+		if (vport_idx >= steering->rdma_transport_tx.vports)
 			return NULL;
 
-		if (steering->rdma_transport_tx_root_ns &&
-		    steering->rdma_transport_tx_root_ns[vport_idx])
-			return &steering->rdma_transport_tx_root_ns[vport_idx]->ns;
+		if (steering->rdma_transport_tx.root_ns &&
+		    steering->rdma_transport_tx.root_ns[vport_idx])
+			return &steering->rdma_transport_tx.root_ns[vport_idx]->ns;
 		else
 			return NULL;
 	default:
@@ -3244,7 +3244,9 @@ static int init_rdma_tx_root_ns(struct mlx5_flow_steering *steering)
 }
 
 static int
-init_rdma_transport_rx_root_ns_one(struct mlx5_flow_steering *steering,
+init_transport_manager_root_ns_one(struct mlx5_flow_steering *steering,
+				   struct mlx5_flow_root_namespace **root_ns_arr,
+				   enum fs_flow_table_type ft_type,
 				   int vport_idx)
 {
 	struct mlx5_flow_root_namespace *root_ns;
@@ -3252,43 +3254,11 @@ init_rdma_transport_rx_root_ns_one(struct mlx5_flow_steering *steering,
 	int ret;
 	int i;
 
-	steering->rdma_transport_rx_root_ns[vport_idx] =
-		create_root_ns(steering, FS_FT_RDMA_TRANSPORT_RX);
-	if (!steering->rdma_transport_rx_root_ns[vport_idx])
+	root_ns_arr[vport_idx] = create_root_ns(steering, ft_type);
+	if (!root_ns_arr[vport_idx])
 		return -ENOMEM;
 
-	root_ns = steering->rdma_transport_rx_root_ns[vport_idx];
-
-	for (i = 0; i < MLX5_RDMA_TRANSPORT_BYPASS_PRIO; i++) {
-		prio = fs_create_prio(&root_ns->ns, i, 1);
-		if (IS_ERR(prio)) {
-			ret = PTR_ERR(prio);
-			goto err;
-		}
-	}
-	set_prio_attrs(root_ns);
-	return 0;
-
-err:
-	cleanup_root_ns(root_ns);
-	return ret;
-}
-
-static int
-init_rdma_transport_tx_root_ns_one(struct mlx5_flow_steering *steering,
-				   int vport_idx)
-{
-	struct mlx5_flow_root_namespace *root_ns;
-	struct fs_prio *prio;
-	int ret;
-	int i;
-
-	steering->rdma_transport_tx_root_ns[vport_idx] =
-		create_root_ns(steering, FS_FT_RDMA_TRANSPORT_TX);
-	if (!steering->rdma_transport_tx_root_ns[vport_idx])
-		return -ENOMEM;
-
-	root_ns = steering->rdma_transport_tx_root_ns[vport_idx];
+	root_ns = root_ns_arr[vport_idx];
 
 	for (i = 0; i < MLX5_RDMA_TRANSPORT_BYPASS_PRIO; i++) {
 		prio = fs_create_prio(&root_ns->ns, i, 1);
@@ -3327,12 +3297,12 @@ int mlx5_fs_set_root_dev(struct mlx5_core_dev *dev,
 
 	switch (table_type) {
 	case FS_FT_RDMA_TRANSPORT_TX:
-		root = dev->priv.steering->rdma_transport_tx_root_ns;
-		total_vports = dev->priv.steering->rdma_transport_tx_vports;
+		root = dev->priv.steering->rdma_transport_tx.root_ns;
+		total_vports = dev->priv.steering->rdma_transport_tx.vports;
 		break;
 	case FS_FT_RDMA_TRANSPORT_RX:
-		root = dev->priv.steering->rdma_transport_rx_root_ns;
-		total_vports = dev->priv.steering->rdma_transport_rx_vports;
+		root = dev->priv.steering->rdma_transport_rx.root_ns;
+		total_vports = dev->priv.steering->rdma_transport_rx.vports;
 		break;
 	default:
 		WARN_ON_ONCE(true);
@@ -3361,39 +3331,10 @@ int mlx5_fs_set_root_dev(struct mlx5_core_dev *dev,
 }
 EXPORT_SYMBOL(mlx5_fs_set_root_dev);
 
-static int init_rdma_transport_rx_root_ns(struct mlx5_flow_steering *steering)
-{
-	struct mlx5_core_dev *dev = steering->dev;
-	int total_vports;
-	int err;
-	int i;
-
-	/* In case eswitch not supported and working in legacy mode */
-	total_vports = mlx5_eswitch_get_total_vports(dev) ?: 1;
-
-	steering->rdma_transport_rx_root_ns =
-			kzalloc_objs(*steering->rdma_transport_rx_root_ns,
-				     total_vports);
-	if (!steering->rdma_transport_rx_root_ns)
-		return -ENOMEM;
-
-	for (i = 0; i < total_vports; i++) {
-		err = init_rdma_transport_rx_root_ns_one(steering, i);
-		if (err)
-			goto cleanup_root_ns;
-	}
-	steering->rdma_transport_rx_vports = total_vports;
-	return 0;
-
-cleanup_root_ns:
-	while (i--)
-		cleanup_root_ns(steering->rdma_transport_rx_root_ns[i]);
-	kfree(steering->rdma_transport_rx_root_ns);
-	steering->rdma_transport_rx_root_ns = NULL;
-	return err;
-}
-
-static int init_rdma_transport_tx_root_ns(struct mlx5_flow_steering *steering)
+static int
+init_transport_manager_root_ns(struct mlx5_flow_steering *steering,
+			       struct mlx5_transport_manager_ns *tm,
+			       enum fs_flow_table_type ft_type)
 {
 	struct mlx5_core_dev *dev = steering->dev;
 	int total_vports;
@@ -3403,47 +3344,40 @@ static int init_rdma_transport_tx_root_ns(struct mlx5_flow_steering *steering)
 	/* In case eswitch not supported and working in legacy mode */
 	total_vports = mlx5_eswitch_get_total_vports(dev) ?: 1;
 
-	steering->rdma_transport_tx_root_ns =
-			kzalloc_objs(*steering->rdma_transport_tx_root_ns,
-				     total_vports);
-	if (!steering->rdma_transport_tx_root_ns)
+	tm->root_ns = kzalloc_objs(*tm->root_ns, total_vports);
+	if (!tm->root_ns)
 		return -ENOMEM;
 
 	for (i = 0; i < total_vports; i++) {
-		err = init_rdma_transport_tx_root_ns_one(steering, i);
+		err = init_transport_manager_root_ns_one(steering, tm->root_ns,
+							 ft_type, i);
 		if (err)
 			goto cleanup_root_ns;
 	}
-	steering->rdma_transport_tx_vports = total_vports;
+	tm->vports = total_vports;
 	return 0;
 
 cleanup_root_ns:
 	while (i--)
-		cleanup_root_ns(steering->rdma_transport_tx_root_ns[i]);
-	kfree(steering->rdma_transport_tx_root_ns);
-	steering->rdma_transport_tx_root_ns = NULL;
+		cleanup_root_ns(tm->root_ns[i]);
+	kfree(tm->root_ns);
+	tm->root_ns = NULL;
 	return err;
 }
 
-static void cleanup_rdma_transport_roots_ns(struct mlx5_flow_steering *steering)
+static void
+cleanup_transport_manager_root_ns(struct mlx5_transport_manager_ns *tm)
 {
 	int i;
 
-	if (steering->rdma_transport_rx_root_ns) {
-		for (i = 0; i < steering->rdma_transport_rx_vports; i++)
-			cleanup_root_ns(steering->rdma_transport_rx_root_ns[i]);
-
-		kfree(steering->rdma_transport_rx_root_ns);
-		steering->rdma_transport_rx_root_ns = NULL;
-	}
+	if (!tm->root_ns)
+		return;
 
-	if (steering->rdma_transport_tx_root_ns) {
-		for (i = 0; i < steering->rdma_transport_tx_vports; i++)
-			cleanup_root_ns(steering->rdma_transport_tx_root_ns[i]);
+	for (i = 0; i < tm->vports; i++)
+		cleanup_root_ns(tm->root_ns[i]);
 
-		kfree(steering->rdma_transport_tx_root_ns);
-		steering->rdma_transport_tx_root_ns = NULL;
-	}
+	kfree(tm->root_ns);
+	tm->root_ns = NULL;
 }
 
 /* FT and tc chains are stored in the same array so we can re-use the
@@ -3871,7 +3805,8 @@ void mlx5_fs_core_cleanup(struct mlx5_core_dev *dev)
 	cleanup_root_ns(steering->rdma_rx_root_ns);
 	cleanup_root_ns(steering->rdma_tx_root_ns);
 	cleanup_root_ns(steering->egress_root_ns);
-	cleanup_rdma_transport_roots_ns(steering);
+	cleanup_transport_manager_root_ns(&steering->rdma_transport_rx);
+	cleanup_transport_manager_root_ns(&steering->rdma_transport_tx);
 
 	devl_params_unregister(priv_to_devlink(dev), mlx5_fs_params,
 			       ARRAY_SIZE(mlx5_fs_params));
@@ -3942,13 +3877,17 @@ int mlx5_fs_core_init(struct mlx5_core_dev *dev)
 	}
 
 	if (MLX5_CAP_FLOWTABLE_RDMA_TRANSPORT_RX(dev, ft_support)) {
-		err = init_rdma_transport_rx_root_ns(steering);
+		err = init_transport_manager_root_ns(steering,
+						     &steering->rdma_transport_rx,
+						     FS_FT_RDMA_TRANSPORT_RX);
 		if (err)
 			goto err;
 	}
 
 	if (MLX5_CAP_FLOWTABLE_RDMA_TRANSPORT_TX(dev, ft_support)) {
-		err = init_rdma_transport_tx_root_ns(steering);
+		err = init_transport_manager_root_ns(steering,
+						     &steering->rdma_transport_tx,
+						     FS_FT_RDMA_TRANSPORT_TX);
 		if (err)
 			goto err;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
index 906584345a022d14aadd20d665ea41d2f287d719..e36735bea218c6909a6196305caa5c2aa5a83af6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
@@ -125,6 +125,11 @@ enum mlx5_flow_steering_capabilty {
 	MLX5_FLOW_STEERING_CAP_DUPLICATE_MATCH = 1UL << 3,
 };
 
+struct mlx5_transport_manager_ns {
+	struct mlx5_flow_root_namespace **root_ns;
+	int vports;
+};
+
 struct mlx5_flow_steering {
 	struct mlx5_core_dev *dev;
 	enum   mlx5_flow_steering_mode	mode;
@@ -141,10 +146,8 @@ struct mlx5_flow_steering {
 	struct mlx5_flow_root_namespace	*rdma_tx_root_ns;
 	struct mlx5_flow_root_namespace	*egress_root_ns;
 	struct mlx5_flow_root_namespace	*port_sel_root_ns;
-	struct mlx5_flow_root_namespace **rdma_transport_rx_root_ns;
-	struct mlx5_flow_root_namespace **rdma_transport_tx_root_ns;
-	int rdma_transport_rx_vports;
-	int rdma_transport_tx_vports;
+	struct mlx5_transport_manager_ns rdma_transport_rx;
+	struct mlx5_transport_manager_ns rdma_transport_tx;
 };
 
 struct fs_node {

-- 
2.49.0

