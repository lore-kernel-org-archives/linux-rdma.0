Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793725954;
	b=egKomRlg0VZ6L7jx4H2IAa1cxzHe3QyvZPlprwOhqHDmC5njmdQHeaI+r0d60zWRufgH
	 eZyKPWEOYlzR+6xY79qjHLNGn9LxVOuWMlCiHeuCDCnHcSZ3lwZNrmvEzBsFOw7obiVqZ
	 II+Y0IChckPPOMHhVuN+6wini+WrC3usJUcuDeQzX80/9qRBStVboxkFqw4PbXCk1EdTJ
	 PXTUznwOSg0fDU/RFeDO7vrBXbTGUhcT3AchO3hbmrte8mLF7fcS2KFWdZxu7K1aKTVMW
	 3HjiXV6yif03KetQE3C8VGlTuyO7jbZtL1Vd8036bQDBMuLfwLMq07OfSOE5XYX52iA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793725954;
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
	bh=IcqtSRvjZhSuoQFAsIyy3+cJvd904JAStSig0sB1hms=;
	b=o6/11sPQ19ynvO7UsobedwBJasqFthL9PI4evnvqDYz7CMsU2gV4iaWOpPYpuzHDYl7j
	 +AcMnTs02qn3eF6hQCjwOlcowJGZlvLL6kEzk7hDsacRDdkKMOlGF2cfcVL47SczBt6+I
	 RFlhiXxOYUMAXcfpZrjes0HTXGPlQVJsRiq6K9f4xcYugYGbjL11oYpP7JD97RKBv7M0Q
	 4NwInLgshZ8sHFVvZMgTCBiRGJK5FbTg82Vc7AvdCkPvFfN1wGkOB1HJhw7zTT5xL5KAl
	 T6VoAAswqCAb96HS3cxGHPpoc6j5qZSrT+i59bg3mE98zPNILW1heXNav2t5rC8xl9g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=meleKQel;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.18
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011018.outbound.protection.outlook.com [40.93.194.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBFC9606A32D;
	Tue,  3 Nov 2026 17:12:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BBFC9606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=meleKQel
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rh+QO1Z4jo+sYGVALfJzXr9UE4YUr6yzdAhmC8kHGoXCEQhK+a4HTgwbBwyAzMSjBi+nmxi6qAbddbATvV8ytJMKeIepyrU7/uVifz9zmaj+8duhaNKDbkIdWpzgFwnTv9DxTvtq+9uJMSaLvJQfz4DuzEmk4x2723oNoHdcA25BXXHx1e4i5m0I/X7RuwTCVNiSeFAK5rZls5YHIcTiYmYeL/23+tpuh4nDbNbrs2SuF0DI1dID7E1NHSzHhK4eFnXCa6w5DEqGkbxGvUnq1cDnqnOiCI0b8qjMkg+SGZ0VWrb62vbJEjDGSbkg9+8M6+1QB6XCXyE58opvq6SMWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IcqtSRvjZhSuoQFAsIyy3+cJvd904JAStSig0sB1hms=;
 b=cKofs5yiJjJPlF81US1l869JSxKrTTpbi4NUugmAoSOCBArnBDmuLjghVFgDbxFM9kJexDCDe1Hhk+P3zsrE/nd3Hkcts/AL3sYiPILI2+Y0Y8Ahe2Nmu8zhCfS+WlB9z26NhlsttK7lT8fxz84GO4vcusJHrjB8UZuFdyirf7pP2YrrT5p9EgDBg7CbGLQ1M8rEeREDtqLOl8FtJzrJ6dhZRelQsHRWn8LZC67V4xqy9vh7UpzyZiiMdihtKFXo8Rc2n6Lad2e6WsQ7/5qW3pSQd+7J8k+pFp7UNzABaAcCQ6j7SXGBC4ylA7cPvkHpULF3u/NAC5CR41ZbtFugWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IcqtSRvjZhSuoQFAsIyy3+cJvd904JAStSig0sB1hms=;
 b=meleKQelq+uqAlR8+htx6Luu97ePFMmYnHWiwvikbSWIPz90RQ9l8IL74s1wzvBm53obP4O9QdMrZ3byjYJjP/9bsoFnN63GJooBbO8ogSdn+Ky/slw32iSSTatWyc7MTHASJXMHYla/Do5h7vx5RvEXF6kYYxemaDeBIKDaIgHzLeyRYM3DObff28DGF76n/ExlvBfha+nxtY4HnQQ0Qj6FQE+hi+0LOs63WVEr+j6XoDpNVRt3qK/EB8K3/9MovCso/JjbBAP88y/KWqvMhuLlihnH/ZtEVpKHUkE9QZ/SZo3/OQybOLM+28qAYcWHaPw5k+nPR9ZEccfK00a0JQ==
Received: from CH2PR04CA0024.namprd04.prod.outlook.com (2603:10b6:610:52::34)
 by SJ1PR12MB6145.namprd12.prod.outlook.com (2603:10b6:a03:45c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Tue, 3 Nov 2026
 17:12:28 +0000
Received: from BN3PEPF0000B36E.namprd21.prod.outlook.com
 (2603:10b6:610:52:cafe::30) by CH2PR04CA0024.outlook.office365.com
 (2603:10b6:610:52::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Tue, 3
 Nov 2026 17:12:28 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN3PEPF0000B36E.mail.protection.outlook.com (10.167.243.165) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.569.0 via Frontend Transport; Tue, 3 Nov 2026 17:12:27 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 09:12:06 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 09:10:50 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Tue, 3 Nov 2026 09:10:45 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Carolina Jubran
	<cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, Edward Srouji
	<edwards@nvidia.com>, Gal Pressman <gal@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, Patrisious Haddad
	<phaddad@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drory
	<shayd@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 03/15] net/mlx5: LAG, skip phys LAG prerequisites for a virt LAG
Date: Tue, 3 Nov 2026 19:09:57 +0200
Message-ID: <20261103171009.563034-4-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261103171009.563034-1-tariqt@nvidia.com>
References: <20261103171009.563034-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B36E:EE_|SJ1PR12MB6145:EE_
X-MS-Office365-Filtering-Correlation-Id: a4632d97-2554-4010-5a61-08df39cda34f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|82310400026|36860700016|11063799006|56012099006|261009223027099003|261021123027099003|261102123227099003|261021121427099003|261026121527099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ktYH2fVQpefZT94JXYJcPI5++35H/50ObVMQqIAzte/N46/CvVHLyRWKId5hpMn2INpQuGylKZMPXN6wOlnFLNvhznODPyYSrTMMAMkhCU+nEW4n9km06BPSb+K+rhbt2qBY4r6yQy/QrbkSGFqdUk0LLxrrZmEYRlbTeXiyBLuZ9WeqYqgHQzbI0c4Y3MBj/ndJORiB4TmfcOgK4dpeQ3N/8tUO5yODPlIyqoOR6/7r1/JcZMdAilGFvrvOPhH8o6o4DhLPXMpbCcwghGRkXdwMWMTA6ZFlT/mY7ajBwfz+gMDJJ/WLBQnc8nG+yILvwLKYLxzRBvTn8CID1R6EY2rZBMy5wGcx3C9C00uMiZDshv3bx/6I0RpqACdFUezhi160miBDozCg2RfbV1kwU2ZOpnvTopkuANDtdS+dn1cWMy8aS6NdWklc5SJwdEI6aFhgMTH98CjjD7MFbsRndKQzBXePDPHKXTsZSBvQlCZeRFV847C+o2KXl+/zbC1M6AhcK7cpznt6ubilD00nkzlrfuTOl7s9y1NR6I9b1mMaVXmBZb6ogg9wf2KjyarM5OvCodWyHLNLwftRpBNDRZ61G6NsCTRAKF9Mla369avE6Zb4JBXpLj7oj5VsUb2knz6CWusKoXSapIzxH734ES/vIIz79SsTLsKY5T6rt7oVaXsadV9TiWcMjLrOSGZCW2pdf54gJRmOm+ayTaAd9w==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(82310400026)(36860700016)(11063799006)(56012099006)(261009223027099003)(261021123027099003)(261102123227099003)(261021121427099003)(261026121527099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	yBMrVnX2xGOlzYSoM4rOnu+Vnq1wZgWzlFAqTE4uy6I/mjeNA4kpk0VdUNr3ypKCKEYtHvSVq72A2xZsXwyPXYaJmzTZ8ivScPEEHzFsf+a4FQsrNIIMg2oc99hKfpErCSt+/BRH54H/O6Ccvqv+ylhuHxknVdANagG32lzpd0ZQkbt1E1mYSecv4TDxr3ivU780kv6E/yjdRBcnzVUHhJ5FW2CYamzAFww2Nm3Z4XgBIK3QAOdKk/RX8ol9Fm+59g/VrjrPrZfmWpTzbkR/y+ORIg2sZjX14ghjmtb08ZwlrBkMyWVo0NAxS20xnOPSiTEMufggHqRmg10+F28Mh8CJgc1N9fylMDUo66sg65UexVzog4yWmWgGOr5o6OFw5lhMp5gCbh8fIz83ezL+JTAnYnI9wSaxhMjG9T+zN14QdNWJm+F2U+gJF0FL5Rb6
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 17:12:27.8961
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a4632d97-2554-4010-5a61-08df39cda34f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B36E.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6145

From: Shay Drory <shayd@nvidia.com>

mlx5_lag_enable_mpesw() gates on port_select_flow_table and
create_lag_when_not_master_up, and on mlx5_lag_check_prereq(). Those
describe the phys LAG: the port-selection flow table and the
physical-LAG prerequisites (e.g. member count equal to the physical port
count).

A LAG of VFs/SFs is a software-only shared-FDB MPESW LAG, so these
checks do not apply and would reject it outright. Require them only when
it is a phys LAG; a LAG of VFs/SFs instead requires port_select_eswitch.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/lag/mpesw.c   | 31 ++++++++++++++++---
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
index cdaf72cb0595..b65ad9a26f71 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
@@ -107,9 +107,32 @@ static bool mlx5_lag_has_sd_group(struct mlx5_lag *ldev)
 	return false;
 }
 
+static bool mlx5_phys_mpesw_validate(struct mlx5_lag *ldev,
+				     struct mlx5_core_dev *dev0)
+{
+	if (mlx5_eswitch_mode(dev0) != MLX5_ESWITCH_OFFLOADS ||
+	    !MLX5_CAP_PORT_SELECTION(dev0, port_select_flow_table) ||
+	    !MLX5_CAP_GEN(dev0, create_lag_when_not_master_up) ||
+	    !mlx5_lag_check_prereq(ldev) ||
+	    !mlx5_lag_shared_fdb_supported_filter(ldev, MLX5_LAG_FILTER_ALL))
+		return false;
+	return true;
+}
+
+static bool mlx5_virt_mpesw_validate(struct mlx5_lag *ldev,
+				     struct mlx5_core_dev *dev0)
+{
+	if (mlx5_eswitch_mode(dev0) != MLX5_ESWITCH_OFFLOADS ||
+	    !MLX5_CAP_PORT_SELECTION(dev0, port_select_eswitch) ||
+	    !mlx5_lag_shared_fdb_supported_filter(ldev, MLX5_LAG_FILTER_ALL))
+		return false;
+	return true;
+}
+
 static int mlx5_lag_enable_mpesw(struct mlx5_lag *ldev)
 {
 	struct mlx5_core_dev *dev0;
+	bool valid;
 	int idx;
 	int err;
 
@@ -133,11 +156,9 @@ static int mlx5_lag_enable_mpesw(struct mlx5_lag *ldev)
 	}
 
 	dev0 = mlx5_lag_pf(ldev, idx)->dev;
-	if (mlx5_eswitch_mode(dev0) != MLX5_ESWITCH_OFFLOADS ||
-	    !MLX5_CAP_PORT_SELECTION(dev0, port_select_flow_table) ||
-	    !MLX5_CAP_GEN(dev0, create_lag_when_not_master_up) ||
-	    !mlx5_lag_check_prereq(ldev) ||
-	    !mlx5_lag_shared_fdb_supported_filter(ldev, MLX5_LAG_FILTER_ALL)) {
+	valid = ldev->virt_lag ? mlx5_virt_mpesw_validate(ldev, dev0) :
+		mlx5_phys_mpesw_validate(ldev, dev0);
+	if (!valid) {
 		err = -EOPNOTSUPP;
 		goto err_clear_master;
 	}
-- 
2.44.0

