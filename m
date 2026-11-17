Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.66
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794935495;
	b=VokISLYD8axxrsUFWNyDZM02UP7/32bAWeoHBkoqpMfTkQ1dm7DU1Tvdg87Msv9IsvRE
	 Gxqqcb+LzMqzHdwF2V2kEg1oD40aj85GDlVPJ6Rrvw32xQ4Uvjrwlm2kYoCsvLFbeTnkJ
	 MnToYPvCnHH3bvPBp3I5zje5i5a7g3uvxrA9Ch4OJ8VC++TNWV3ygb12KxQyB7XuL7erz
	 TPG92ukRUQXpZ7NTJMEWbpb7MuWNXQfR+vxJCrGoZnfgNo2FvERsv1OhcCBZYWdwwP24v
	 Ild+Tn6fzt+v/Tt2OscTmEZJbR8vc/wkr/fhUrgirhQo1rDqAM9+wZHT8HTjdvgKUew==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794935495;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-NV-OnPremToCloud:
	 X-EOPAttributedMessage:X-MS-PublicTrafficType:
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
	bh=0ALabRM5XXdZrfGgjDW6mqjuA+UqQEaJn7Huhb1EmCc=;
	b=eqzLDqnhczW890EoHcfwk7ZWr6rjuZpCP6MKbBBPBTqGpQeSvJ9ckNsh8GsVr51PesKA
	 ulLR3CO+jbajaV00X9ZKUTvGeBn3LG9rtT+9KYhIO/bbDy7oMtS4AwlrL02RExGa96mN0
	 b0cIDo+2E8MVtJ89D5DGpas66YvKG3WNT9N32ZWK334O+ur7eIH9GW5g/B+Gab+nXGuLu
	 UWBjsVQn0j2JjgwsEG2XjZJAI4c0Y8b9rlntDSKJlzc1kzeOIGKY1cyDHjrDud6nT47as
	 BB1WZOd2yWBokNAB9jMOlSsHYEfM2vDdtHimFJ8Ro4qk0cNG6PxWWb0hTiMU7LOKAzg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=QUPqpVkY;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.66
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013066.outbound.protection.outlook.com [40.107.201.66])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74309606A32C;
	Tue, 17 Nov 2026 17:11:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 74309606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=QUPqpVkY
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lh/8nEXTw8nX1O0+KlU1vuxB7t6/lvp9MNdztP/9/W5KMwvMifrBZOuWN7mI5EuFRWnPLP4C5BIzDKbsbT+EcC9LLxwGX9936n0AvFMmM/H8VYHpxwHg0iqiP8oK3qjCCB3wU/fHzop0mJKsQTLFl2GkZzNU4vPBnzEjHa0ZtbpNMGjo9/rmUFNpEtYBUvVNOhQkHC8YppFaflWsJYDjrKMNE0G1yKIsI9Jk/o+H2p16sNmfRm2jB/R94QbH51yqZIzXAdY2aPJ2tWCbd4SMBk6onKxgEde/WpeQOT5cDoOXWywlCJR/DOk1/Ck2gGX/qdS+CIni56dnKVNXR+LxeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ALabRM5XXdZrfGgjDW6mqjuA+UqQEaJn7Huhb1EmCc=;
 b=WHHrkANTVgGl6IMHQeba3ATzPkYxtBYcJi2YoTvuPB9uDHfl3SPK0c1W3YYZ1e9PluSYWCgkbS9rIQmVAEwwqB+TG8+uxkhGpKjrulxEqXEe+MAlYd7ZlyGPf93CSTNvEaAcYoa7TLIhZ44sXbjSwijQF1VxVlbBx38HxGYi1nuEiQfuB0SIEv0K2ZnwH26RjyEzSpr+eq5a063LtBz0KmH+Of0eU0M5FAM70OOFv1Xt/G+D3dqDRNJf8P8KdCVYcrpjoEhdk7BEoDn+pf6ZYPYtaXQpTbM/6TfYfcXyhixsga4YlugRgLsHJgjpK0uan4/O5cw7b2gitejmx86uOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ALabRM5XXdZrfGgjDW6mqjuA+UqQEaJn7Huhb1EmCc=;
 b=QUPqpVkYApO/pt9mHnjKMmHHNfj9GHX/DP21XeLBOTzU/wgoXwTn/UQ0b4R4KyghTeL66O/LAKVQ4GlpqI+L4ZgyIo1t1F+OcsYe8DqV2ydUxYbSRFlpAlJIP2gqTVkncfQF3h2kuaJpdDHcD4Gd1lRgFCh/mBsufIKWBwwHc3WahgW5TQL22eQPE6DcrXkZINgjvC3/qj2G/mAVPHzLStFyBIht2mlX+XrprosozKz8gwdHWZSBWJdT9MXSG/MNEILsJ7QwrPBSv250lFp63FC6jDGol6h1GnlsUKwLhdYavH8FGvc2cx5I+45lXOuPfgdAfN2fFyBvbKyc7KSm1A==
Received: from SJ0PR03CA0178.namprd03.prod.outlook.com (2603:10b6:a03:338::33)
 by IA1PR12MB6139.namprd12.prod.outlook.com (2603:10b6:208:3e9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 17:11:28 +0000
Received: from SJ1PEPF00002320.namprd03.prod.outlook.com
 (2603:10b6:a03:338:cafe::7e) by SJ0PR03CA0178.outlook.office365.com
 (2603:10b6:a03:338::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.569.11 via Frontend Transport; Tue,
 17 Nov 2026 17:11:28 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF00002320.mail.protection.outlook.com (10.167.242.86) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 17 Nov 2026 17:11:28 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 17 Nov
 2026 09:11:03 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Tue, 17 Nov 2026 09:11:03 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Tue, 17 Nov 2026 09:10:59 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V2 rdma-next 17/21] RDMA/mlx5: Validate firmware RQ/SQ state before sqrq_trans[] lookup
Date: Tue, 17 Nov 2026 19:09:10 +0200
Message-ID: <20261117170914.27410-18-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20261117170914.27410-1-yishaih@nvidia.com>
References: <20261117170914.27410-1-yishaih@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002320:EE_|IA1PR12MB6139:EE_
X-MS-Office365-Filtering-Correlation-Id: 293de354-eeea-4306-317e-08df44cdd17a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|82310400026|376014|36860700016|22082099003|18002099003|261009223027099003|11063799006|56012099006|261102123227099003|10067099003|261022105027099003|261026140227099003|261021121427099003|261021135927099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	A6epwfSrqnehAYCWEdII+KkrzBSWPytcXbuwbdzXj9ZmsxuLC9a2gTcCefIdsi8zbSL58sGT4B0+dVK7uLZjM7ROXIYbryuGwMPl3Pm9w9aR1Q9LUIVfFT9PyIJSvah6PRYzrPKJ1tYr+YJdoO7fKswz4z24OJ6q06IMqw5v/43W6sV8LgGP+FSs9SSEoP6svXDOAGPAlwPylZl2uPNS48cTBvjUhm1bTQxSJvW2BC6I4/9Fv8xOmNLawyWhKV9zUDXwVKey/RwFL+XuiEwH6MlAP/iW4ZWa1cDDBkXZ7rEKhtMFaExpae2vLPIQINjbRZnEPhBWcCcUEV8li47+K7u05FiYCRDVhbCsYa27ggw6DV3CY4SkbpddAZge5Z3B9PbrJY9VCP4fXItVzsQkxRNqJ5+TETqc/s47gxzT7QGr252ON7VN2ZFI0r2lZ1Mqfz6YQXFzavdxGrZvGhyqbyM0PV5gqn1DWTl4rclOUIZ+m30fY8jfO7vH4wPfI4HNemHXNe1Y3pTZTTj+O9P1lnFFLY0APhr5wDKFyrVQVgR8dvG7gadfyHuWZ5ohvU2jfJdk37GI/I3SG2WgnXSiSbrqPdtwRzFuNhrVq96/fJlnWsBN89vihw8WOVTp5FvwgbHegO/7izrY7pWTP0jTPZzP4iUe8gAYggXGXH0vH4ztp0kcOUzwKtw3IzKb1pyfTClsj2Nu/Ne4+KqoZ046Rg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(82310400026)(376014)(36860700016)(22082099003)(18002099003)(261009223027099003)(11063799006)(56012099006)(261102123227099003)(10067099003)(261022105027099003)(261026140227099003)(261021121427099003)(261021135927099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	rNs2e5AhBGjdPo2iWIGHMOWhFv2eB3fyh2VUmJEy5TDvnPc5Vsuc937sVri791jl2BjFxEuPiSqHJdw5tVphr4MXjLaJ2EQvHpPCzk6v6x5ehg4dSDpTK9hhECgx3JCfrpo45ySVClg1GgXrl7v8Phw8RhkDmlACJQxrOaxexkXV4mgKNL4mTT7iimzmFXcVknWU+YiUCLL4i89sxgAlGZG0M66Dtt2mQndIE0sMVepwNP7z89x1x8tbddeHdySyZ+UYG+j88SCsX4Sluu57mbq/umKa3Zysm6kLmBzltCZOPtoqKJamjovVhBezCE5hD85eCnD5ouhwCRw/3uhPo0oDg3duBWGHExcX5ie9sbi+iCqEEL57kxOof1eNh5gZknJ1V0F8SO7WI6H18p+2Xrul+UYFGOeXGAFTO7Oh1RclCMexv2BWGbfNjEAtuLVn
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 17:11:28.3039
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 293de354-eeea-4306-317e-08df44cdd17a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002320.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6139

sqrq_state_to_qp_state() indexes the 5x5 sqrq_trans[] table with the RQ
and SQ states returned by QUERY_RQ and QUERY_SQ. The state fields are 4
bits wide, so an untrusted NIC can return a state above 4 and the lookup
reads past the table.

Reject out of range states with -EIO before the lookup.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/mlx5/qp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 19cbf6b2b979..05e8e75d734f 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -5081,6 +5081,9 @@ static int sqrq_state_to_qp_state(u8 sq_state, u8 rq_state,
 		},
 	};
 
+	if (sq_state >= MLX5_SQ_NUM_STATE || rq_state >= MLX5_RQ_NUM_STATE)
+		return -EIO;
+
 	*qp_state = sqrq_trans[rq_state][sq_state];
 
 	if (*qp_state == MLX5_QP_STATE_BAD) {
-- 
2.18.1

