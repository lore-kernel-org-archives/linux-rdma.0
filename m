Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795730270;
	b=A0xsAcikHKRmE8Elb1JOhmOuUB1HpDGF8RKjk4fxAaL2rfT6pbn99lxaM8UigO/E1GH7
	 7DVzq8bgHRcLALZnqYLsCv3NuYwWo/R4bMvh/9VmiS+ntZRlLuOHJArKXEEyWNweVJiTU
	 Wh+JVWfkw+GFNeNz7RAaCy418XXB2XLR79EdxW9ivNwrgKNtog/bJEBVJDfeTbJqYhJa3
	 XTtacZZHESF/XZOQtLKRF9gs0xMx8/K1Bwxg4qewEZSo/Xn7BRAOQI71GdC3sVXKVP5u4
	 a3z73pTqIHlPZwpSnbnXIFPvznboyGwxTebXG9Qf50D7FyoLdVNAztcJS7yKcfF4QlA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795730270;
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
	bh=7zXHTQLaa+h6yB5nFMvL1BEraxDIdcVYejfUVco+wZo=;
	b=w+Y9Hy/KZtnFOZ2y7seuCV9rOv2J7dGsd8ZBE4e5SHX6xuj70aPkCBMm+usa3IpplCnQ
	 rtmxQdL/Ux1sz2Xa2xa4HjdmHgEvlrXJ/jvVFvzU2oh8sL+w7YiViui+kBHSV+eGDpt2d
	 XyvoQjTIGYYJd73Du4+6lu+sQfBR/pzdKGsITjgraJjyqKezoVZYJNV49EDi8zZ6cNgP+
	 b6Vm/jitU6O8k3HrGFnFUEmS05SWKFhqS+frhwFUyBhDAswioR37XO/bEcBsRGIXJuy5g
	 roo/G3Zk1FNfHSIagS+ZzVB2JJFAKIkQQ+t3pZcdJ3/DYs4fInYump8Pd/fSsxEfWbQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=aejsAo9e;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.44
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010044.outbound.protection.outlook.com [52.101.61.44])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324CC606A699;
	Thu, 26 Nov 2026 21:57:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 324CC606A699
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=aejsAo9e
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rPyNO2Y+vARttGXrjQBKgSPRISKQNKDf9MuXSFotLWxairqXx5F+N+res5e+XQim4x1UqgI7csSbm0ByqXDtxYMMvAEjRAP1UWeIT/dsq12NMACxja0xWchKQOQNnUwIrYZzo0vsedoxVYKj9apMdk7uwiU4TG2uNJAeVt5bk7BSfPCsD5skDQAY28+eERdMExyFNjrqrL5jiDUW5/VAx/NGrvFsQhnRhL/DlZL+qoa8hOYfL/yWEfAx/VpVIYbCghg+3YLmNVFOepkaoUnLxIq9djILuoPYtqdHAVaxjN+elFmfbgeFaBMwibGG8612h83V0MvvugMEfmPSCmXNhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7zXHTQLaa+h6yB5nFMvL1BEraxDIdcVYejfUVco+wZo=;
 b=orj7kJl38SrRpLinINAWBv+PWC+17XIXma7rU0zPQZ0K59Vhf5ZQyFflfHOiZoTWckqkYEkm3egqz/LkjpCpDuoRf/n6qA1o6XSraT5+kWFmbQPIol0OrKfz3GhELbyawHtPdZD/0xHS2/stze7GCUvAXXfjtMrXTUfHmv6CK7c3dYHsV4VquhinSXpi2ly+Z/Vtk8icsRcnacZNFi/6l/6i1U8DsuhscCOjh0Vmu63t3ccDhUVE4ik/Pb2npwcOGzW1iYxVmMntiVd5s+pU7TrMUaV0NoOsCMILsUD3XnSUqLLfWzvRUqhAKlTcHLrPNhWuzH/vBkn0ySltFDrQ2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7zXHTQLaa+h6yB5nFMvL1BEraxDIdcVYejfUVco+wZo=;
 b=aejsAo9eITJHsUqS+Yw/0WNwVuaIeQFbMixe3hh71WCObi8RxITGPh57hod+A9b3diSSrdt20gdLJDpdzfbpoYdmOYUsu3/lTGsRgPp7jSovA4R3CRpG+W40qKIkSa94I03gB47ud0q3UOIy7C9KklekdqgxxCJ/9vQtT9b5OH7k/M6bs1aKkkiYP5y3MxUeDnWRvicOOTceK/3MzzKqPn8QJ+sh/O7r7rw/S6DVyWzbCNRztftOHCIsjF7OUKvZeUu8e45aNFdWEOCj6i6qf8Taqfz/YfoTx4hugkAdj/kl3+ndMy2HuoWS9BVKPgsHgqdb6knly+tmr4EqGeqJEg==
Received: from CH2PR16CA0012.namprd16.prod.outlook.com (2603:10b6:610:50::22)
 by SN7PR12MB7909.namprd12.prod.outlook.com (2603:10b6:806:340::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Thu, 26 Nov
 2026 21:57:38 +0000
Received: from CH2PEPF000166C0.namprd04.prod.outlook.com
 (2603:10b6:610:50:cafe::75) by CH2PR16CA0012.outlook.office365.com
 (2603:10b6:610:50::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.7 via Frontend Transport; Thu, 26
 Nov 2026 21:57:38 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH2PEPF000166C0.mail.protection.outlook.com (10.167.252.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.688.5 via Frontend Transport; Thu, 26 Nov 2026 21:57:38 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 26 Nov
 2026 13:57:27 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Thu, 26 Nov 2026 13:57:27 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Thu, 26 Nov 2026 13:57:21 -0800
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
Subject: [PATCH net 07/10] net/mlx5e: Copy back only replay_esn after an IPsec ESN update
Date: Thu, 26 Nov 2026 23:56:11 +0200
Message-ID: <20261126215614.792598-8-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF000166C0:EE_|SN7PR12MB7909:EE_
X-MS-Office365-Filtering-Correlation-Id: 59145eb3-20bb-41c6-0a6f-08df4c084938
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|23010399003|376014|7416014|1800799024|6133799003|261009223027099003|18002099003|22082099003|56012099006|10067099003|11063799006|261102123227099003|261021133027099003|261021123027099003|261026135527099003|261028144727099003|261026130827099003|261021130227099003|261021135927099003|261022113327099003|261022105027099003|261022115727099003|261022075727099003|261026140227099003|261026121527099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
	HNqwUzO3ySILkHinMDZ3HtjWgbzZUU5EhfmAfm83uK5UJ8aNndCnFi92fJXhSmJqN5IAiqzx7Cxct01FUCfH77CKy/cQI6UHlqNBPNXIfz8vUSckohGRy8AEdCKGSUD3tPRTWozuPxQ1vtWGQwhQUnMsUjDkFsUwdpZkXsQd1SdpZ7NxBBYPitjitxoAbocM1VoSo7mDiq6pVdf0opklONVqNCxRZjnk1MisosOdS/CTYisui+FG5JEOVNDT6MG9cteRaXQKF0WI/vuXx2cpoPv9ukB8JHzXdBMdhc1y78AeGa3Y6U6ayo7Y9HcuWsbG4gdo7TnZcgGHIXw9u3GSZX52cvhod/+TfgJoflDio0TtafN1M3gsW0crtqTb0AxxbOo/T/3FCer+iaIB/30KjVMVZKv4FhTO+KO3gmbptHCrDjMcqTTlqwsI5iJUhHPbRpx2FEuLW+JtavXRmYd2GmqWHThrgD1G4W14/ovf8ukRJZWH4Dmw7En3Q6xwld784T5yN4Z4hvjF33uNBhP36Nq3odYCjo4az/XoMUew+a/4ldWbDMkcCPaWQv1Otsv720TRuEjTalLvxDeZ8d5Ibr4huprBYYEgrJJ/3gNGpEz6iVbD31FJw3Vn/mv6dsoQOEtZtKkNn/j5KcqV037YCxIizxnxYV/27TeEIdfCvznalWvV3vFGJqBUSUiYPo0LCFocXvAXMzwZVYf41iphgw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(23010399003)(376014)(7416014)(1800799024)(6133799003)(261009223027099003)(18002099003)(22082099003)(56012099006)(10067099003)(11063799006)(261102123227099003)(261021133027099003)(261021123027099003)(261026135527099003)(261028144727099003)(261026130827099003)(261021130227099003)(261021135927099003)(261022113327099003)(261022105027099003)(261022115727099003)(261022075727099003)(261026140227099003)(261026121527099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	BN8sznr5pl9SwU+PDoqiw7wvWhdVq0CvpBeMwPjf3fbHF2vyxgv2MTshkeOi55WTK7+muURajgtF7+AkIpBNjouX4/WznKhDaC/vqzbZWFd7Dc2pdK09SnZnyYXEIW3niGAQ0N7S8lGHyinupxt4lDDZnx8gIdUQ+ZGZJnWRM9YWU/zCaNt1JIyPeCAg+VOd/19pQ2yRADgCkUQKzTHgtdL9UGRLAzBl6NFSGC+r6rMU/fu4n/W/oGpGHkZOa4RB7+r4sceBED8/OWMaO0vY/O7r21HQgSixl6XyQY4vkmWnaoak4eb24wvnJh7/mCunQiIA6lh/XS/iIcDmEIC1YlIFSKViJVCgss+UPLSQo5rwnJ5flTzqZpb0M9bMyA8b5YzbZAVLdclBppllFrLKA+OBBDodDTjhSkXlaMMVLXiOff4G8NAKIeZVl4PpQTO2
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 21:57:38.0309
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 59145eb3-20bb-41c6-0a6f-08df4c084938
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF000166C0.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7909

From: Jianbo Liu <jianbol@nvidia.com>

The ESN paths rebuild a full set of attrs from the xfrm state, and
mlx5_accel_esp_modify_xfrm() copies all of them over sa_entry->attrs
although the hardware modify changes only the ESN fields. The rebuilt
attrs do not carry what changed at run time, so an ESN update undoes:

- attrs.drop, set when the lifetime worker expires the SA;
- lft.soft_packet_limit, reset by mlx5e_ipsec_handle_limits();
- the MACs and the drop state programmed by the neighbour event
  worker, which runs on the same unbound workqueue and can also race
  the copy.

The software state then differs from the installed rules.

Copy back only replay_esn.

Discovered by code inspection in review of the next patch. Not
reproduced. The ESN update was tested on ConnectX-7 (fw 28.48.1000)
with SAs starting just below sequence number 2^31 and 2^32: no loss
across either boundary.

Fixes: b2f7b01d36a9 ("net/mlx5e: Simulate missing IPsec TX limits hardware functionality")
Fixes: d05971a413d3 ("net/mlx5e: Add SW implementation to support IPsec 64 bit soft and hard limits")
Fixes: 4c24272b4e2b ("net/mlx5e: Listen to ARP events to update IPsec L2 headers in tunnel mode")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c    | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index 1f03465762e0..5182a79b0e99 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -299,7 +299,7 @@ void mlx5_accel_esp_modify_xfrm(struct mlx5e_ipsec_sa_entry *sa_entry,
 	if (err)
 		return;
 
-	memcpy(&sa_entry->attrs, attrs, sizeof(sa_entry->attrs));
+	sa_entry->attrs.replay_esn = attrs->replay_esn;
 }
 
 static void mlx5e_ipsec_aso_update(struct mlx5e_ipsec_sa_entry *sa_entry,
-- 
2.44.0

