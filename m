Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795730235;
	b=wn+LKpUFLYorJeDdsLzcFMOXng+9eHqpQpb6KvxH3wbgTLhhkpHOze6nkyB9sjDsDj0w
	 c/w34/JMuJK1QclAO+7byiMt3SP6zl2/KS0gRDrSQHJjbo+xTdpzlcDIyl1EEM+0e36/Z
	 Ce5qAeoHO3GXxJQmucmncPe6mnYScOTRtcXWHIAZ8IfmEPMG6YFQnQtzxVfobvMDDyX4+
	 YMZZbqfY4YGU20OCZfTq7qlKXqIJu6/SyA+bEbiWPI+CbiDSc3vVRAfMD7Da4h/OsrDvy
	 90WwAlKjT9jYzOGTobxQDhuoX5w71SyNxhQ105/Ttq1UivNQwTmaONo2fdRBvagdgUA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795730235;
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
	bh=hL7Nygmk+pBepx9GRapskbHQgyiB9fglHp+5hcwHTJc=;
	b=ACs5mj7yp7YJqH+Ruw8SnrF9iwc4F5EArTihjQkXxyGvtMO3BLWLaLTZZC2vmexu1NKt
	 lZRQlmJDVfJAajYoYxmN90qscywNEssPpq6qPUKbMDa51ocpfA2E1q8ekRzcEfn6rEL/C
	 I7ILaNCX4A0/3+f4HEGyhAg8HSa3TWVDhpFgqFL3vftF98Gd0gHCxDJY7CjU9qCQ/E/L0
	 cId7D7R0yqf/fcLMKvGgM5WKvXd6SSj4naSnsIr8BZSS5YrQzDoE+IWgB7F8R83cjaa4w
	 A1oTvA5uXdGnM3WmjcCBg3fiZZcByJl9i/k6+gEDmNKczYvf31kho/CVT806bOiY+sQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=HAiD37fc;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.41
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010041.outbound.protection.outlook.com [52.101.201.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1ED0606A687;
	Thu, 26 Nov 2026 21:57:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A1ED0606A687
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=HAiD37fc
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OoOxPEixoy5O8zgIDpi6uPgftQiMRwsHBTKwRKG5AQ21YzDRY7RADdkH2tLuTrMwEtSTHqCMhgWhmI5IhXYjD73zdytXqZIZTYTrqzlDA4FPYJ6gc+WM7oXRTJeVaKm7WXKcPlE2D/Ot/uaERSKiski1J7bJNxsUUa8eexhfHivhAT+CqNV6cm696lt+VUHaYxLOflQ54U4xUWSBwS8VBy71wJVFr15riX0oJnBmLm0NFJm9Asgv/bJ/z152PH47MdzQI67hKweLrKrogHWBTVNMqrqu4ToIJc9BJN97wXBU5uohHwi1Zj0bWweNhzCb2vw0hU7gSuJH13GRBp/agQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hL7Nygmk+pBepx9GRapskbHQgyiB9fglHp+5hcwHTJc=;
 b=Z7EL2ya8vhovgaYc0DythAkIqQRR12coc1J2l6uiKvmKdioIUe1fr8BX1gC+ND0T/6hM+chmIJmH+6gnTf0D5uEEwUHC+9EYte68kixglJ1ohS4hzgvuN2GJDtmPDP4NEnQ6kyfeb07uCH2t1Y84amlIkrtORh4oQm675hUlm1MZRPGW0T03uFSH3DUKkeQ4O38BJrw9Yxajj52QMuEmfm4AJVa0nMca8A9D/RvZb+t4jWrxOeyvtdovhMeuqmeIaDibhmcfI/jfwI/t0SbPuZUptMxXl70dnfABNz7OAhP2IkA8CBqp7oq9Ku74nkduVe3b2k8P9uwlhBwrMerCmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hL7Nygmk+pBepx9GRapskbHQgyiB9fglHp+5hcwHTJc=;
 b=HAiD37fcBm0OROyNYiH1lGFoTgoScN4T8d6NHp9lMWseIgxcSHspZcPI+1Tf3AlwxdztcT5D4NGrnQgm5y4xEAaFSbdpQXMkFnkp2XzSLZ0awHp26TDptALnAcSxGOdVkuJZe9cMu+ZVUTSOdF5V3+LEPgRSSHqDeu+lHsrOEnMSyWWJYSjzr8M+UXI4Y3THKFaCyjZzxVAjgDruyZtYbTRsEe5aQE1ns84nlrLKNg7vsPl93yXl0W6IU70cH8uCXDpri05qmStSj5EYR0sgdA9SNpQMMlCTCydpz4pBWWsqoic6kjeuPk/0/YkD7a5jTxcBDe+Ve4tz9fRtBo4qaQ==
Received: from CH2PR16CA0015.namprd16.prod.outlook.com (2603:10b6:610:50::25)
 by CY5PR12MB9053.namprd12.prod.outlook.com (2603:10b6:930:37::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Thu, 26 Nov
 2026 21:57:02 +0000
Received: from CH2PEPF000166C0.namprd04.prod.outlook.com
 (2603:10b6:610:50:cafe::5b) by CH2PR16CA0015.outlook.office365.com
 (2603:10b6:610:50::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.7 via Frontend Transport; Thu, 26
 Nov 2026 21:57:02 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH2PEPF000166C0.mail.protection.outlook.com (10.167.252.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.688.5 via Frontend Transport; Thu, 26 Nov 2026 21:57:01 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 26 Nov
 2026 13:56:57 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Thu, 26 Nov 2026 13:56:56 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Thu, 26 Nov 2026 13:56:51 -0800
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
Subject: [PATCH net 02/10] net/mlx5e: Stop counting packets dropped by IPsec RX SA rules
Date: Thu, 26 Nov 2026 23:56:06 +0200
Message-ID: <20261126215614.792598-3-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF000166C0:EE_|CY5PR12MB9053:EE_
X-MS-Office365-Filtering-Correlation-Id: c15983ad-3f98-4a6c-98b0-08df4c0833ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|1800799024|36860700016|7416014|376014|6133799003|22082099003|18002099003|261022115727099003|56012099006|11063799006|261022075727099003|261026140227099003|261026130827099003|261022105027099003|261026135527099003|261028144727099003|261021133027099003|261021121427099003|261009223027099003|261022113327099003|261102123227099003|261021123027099003|261021130227099003|261021135927099003|10067099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	n6fFjb8N2QrPMKm15cQlXlKaFbWrkOtjVPbSGIv7uh55Crt+Fe2R/q1o6iJlF9Mf6JdtiJ5MO0aDn0rw9waRUEPM47PdZHiFD2pnY8z4qnSaXeT5dygscwEQ7C8Rz67ILETexTCfACCtQQsP0VsPr3u6B3v+5lVL+93PVo4iL6kyoaW0OTujdJPsfEAGR+FzmMWgXiS8ujHQN5hXDr1Ok/5GFoz3H+6m+h7uXMJdpOW8kroXlM3cYljx75GEyKipAsBVBdCjQMNrhUtIw/dBcxTvfInQBSI6pyq9onDysI1BXgcd/RUqS83dO0V9rwETne9Fz8v45UfptdQJDrdOq9pi0RFACzSXn9wftqcWYU4lqnm7jpBaq4eojmB1s0iKo7w1qgaPTWnOrnBmuQJmcokPBu7N5ZwcjcY8XJI4AhGhziZlbA6cGcT4VIRawlWiSG8Or4VvWUmNp4SomBZK2IgvF4/s32grfrTku/FLhkeQuwcLDc2+PWMDPJR4aEzdp7EIPhs0+CDRrBkH50X9nXdsgiifow0hQ+TxfxkKUe0aaF0q9aMxL3P9ffBtEE3ycMCqQ3hl/6UFWShWRdTWVF+zr8huATpafo4qdp0WpsJJxpqjhQ63tgWQYG1dnXNt9FCFtfI1BI4ZVCj77F4U3l93j1BVR42WM5zr5a5TSsPJzcHI5pA2CJ5vv/9iIP7wiX+eB2KyxokhgB/9Ehlcrg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(1800799024)(36860700016)(7416014)(376014)(6133799003)(22082099003)(18002099003)(261022115727099003)(56012099006)(11063799006)(261022075727099003)(261026140227099003)(261026130827099003)(261022105027099003)(261026135527099003)(261028144727099003)(261021133027099003)(261021121427099003)(261009223027099003)(261022113327099003)(261102123227099003)(261021123027099003)(261021130227099003)(261021135927099003)(10067099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	jCyuRquhjvMzpGvp0RgoY6N+tSlC5qEtP7mliEogNVrE4smAzJK1fvjylR9WO+rkfJMDqsmUOLZOP95PRsd/gadpjRaU6ywr5GXWFOeIqXc9S+Yv0jDUZZ7zXvqTGQ0gaUbIMef3c+rPzJ5pHJzo3zqS+rZ9SKEaLbdWKoy7Q7j7K9DCjGKM+fI/QULK+4Bc/a8gSa8Fe/8b4/F1lzeL6xTOkQad5FegygXSUTzAyBBRK/x7THt3TzfGbRD9RZga8ccUlzu/IeOE9DAYJvreuX2/0qiFPOkL77kmTfOjc0ZSQd2InjFOJiALJMwybg7Ra/L7RkOJKbUmfW5DfvX3lcwr8bokLPN0mtiU9+AaE6FoHJgg3RLEw/4stgMInq9wpcy6QfTaqhiZ9+rFssUWKSWsBN3ds9GkgFscQJJltd9QmfFSayg7i/XTDduksfCx
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 21:57:01.9102
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c15983ad-3f98-4a6c-98b0-08df4c0833ad
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF000166C0.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB9053

From: Jianbo Liu <jianbol@nvidia.com>

x->curlft.packets differs between crypto offload and packet offload
for the same traffic because packet offload counts RX SA drops.

With crypto offload, XFRM updates x->curlft.packets in the software
receive path, so packets dropped in hardware are not counted. With
packet offload, mlx5e_xfrm_update_stats() derives the lifetime from
the SA flow counter. When attrs->drop is set, the RX SA rule drops
packets in hardware but still increments that counter.

Remove the count action and counter destination from the drop rule
so these dropped packets stay out of the lifetime, matching crypto
offload accounting.

Triggered during code development. Reproduced on ConnectX-7 (fw
28.48.1000): 1000 pings to a tunnel RX SA in the drop state (peer
neighbour not resolved) give x->curlft.packets = 1000. With the fix it
stays 0, and counts again once the SA forwards.

Fixes: b2f7b01d36a9 ("net/mlx5e: Simulate missing IPsec TX limits hardware functionality")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 28 +++++++++++--------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 502d89a18f9e..0facc5477155 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -2045,7 +2045,6 @@ static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 	struct mlx5_accel_esp_xfrm_attrs *attrs = &sa_entry->attrs;
 	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
 	struct mlx5e_ipsec *ipsec = sa_entry->ipsec;
-	struct mlx5_flow_destination dest[2];
 	struct mlx5_flow_act flow_act = {};
 	struct mlx5_flow_handle *rule;
 	struct mlx5_flow_spec *spec;
@@ -2103,17 +2102,24 @@ static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 	flow_act.crypto.type = MLX5_FLOW_CONTEXT_ENCRYPT_DECRYPT_TYPE_IPSEC;
 	flow_act.crypto.obj_id = sa_entry->ipsec_obj_id;
 	flow_act.flags |= FLOW_ACT_NO_APPEND;
-	flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_CRYPTO_DECRYPT |
-			   MLX5_FLOW_CONTEXT_ACTION_COUNT;
-	if (attrs->drop)
+	/* Keep decrypting packets even when dropped, to allow ESN state
+	 * updates.
+	 */
+	flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_CRYPTO_DECRYPT;
+	if (attrs->drop) {
 		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_DROP;
-	else
-		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
-	dest[0].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
-	dest[0].ft = rx->ft.status;
-	dest[1].type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
-	dest[1].counter = counter;
-	rule = mlx5_add_flow_rules(rx->ft.sa, spec, &flow_act, dest, 2);
+		rule = mlx5_add_flow_rules(rx->ft.sa, spec, &flow_act, NULL, 0);
+	} else {
+		struct mlx5_flow_destination dest[2];
+
+		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
+				   MLX5_FLOW_CONTEXT_ACTION_COUNT;
+		dest[0].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+		dest[0].ft = rx->ft.status;
+		dest[1].type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
+		dest[1].counter = counter;
+		rule = mlx5_add_flow_rules(rx->ft.sa, spec, &flow_act, dest, 2);
+	}
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
 		mlx5_core_err(mdev, "fail to add RX ipsec rule err=%d\n", err);
-- 
2.44.0

