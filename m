Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.37
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793818144;
	b=ihU2pABqPCmiVmTn8hle+Y4Rftwew29a6ZOR6kfnA+8sF6dd7n9bbZXmsUFjF1vkZ+df
	 OQ+9aupTejSXuOpzcD+8ioID0DnDSaX1qpb37vexnzAjH3+Uxz/waJshyr47eCcVSn+1e
	 Me8QnsUyhbc8CBm2KBm1v47/eY83C0ffs/KFo/nTYrXRvgrxKOuJjaolnpl2wOWh/J15L
	 sukAes2KPs6lUXWxc0acu5kW+0WP8/4qoNPQroKt7uG+Ds0TiKCo23WgMT/1CBdbisKxO
	 p9Us4fo2mTRFAaHYf+Jtpb1Z4G44mtm9oss5HIxndGFzipYbyelFX5WgDTwIViGVtLw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793818144;
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
	bh=a5gbFSyoFRK0guk69IMyXpdI0RO3UIBCLkofjUx0efI=;
	b=Y+CXSGUAmxfpilmV9Rf8cm3sL+LRdMcJVWqsoRTucPYL+Fazp8QZiQLBB68Ry5SfZfN8
	 nHPrCiIYOS/U1YSIrCRfzMgUWVMCoxcBCP+9+LRr20/AUHLTF3uzjeozd5hiJiw3F/uCg
	 t2ztsELgmW/iSjafLr7GLOl9FEsPs0Dn/VmJQPCb/tFM7Qbf8UynSmQ8jWA8B0Taom06X
	 /GBlNN8qKXftzYIbKxt5y7OPbIbESaAoH3al2kXNe4N6n9UNCiClgHkICFJO6eABp50o3
	 YlAPf5vi3vP29FwmZidZWBMcRLXC2n0ZML+GGMFKKEzEbkrKFodlCFWlcPavhDozqZA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=OKuZCkv7;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.37
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011037.outbound.protection.outlook.com [40.93.194.37])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69AB5606A329;
	Wed,  4 Nov 2026 18:49:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 69AB5606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=OKuZCkv7
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CWZlILJb1zutWD5vH2Ua16fBw1dsXVS0RLu1mDUB+74V8YVqsrnlzFDo19boQ2xRVNpk9Y3fguAPm3pY3a69SqhMFCGwmiQ5ulZKzF0CTPI5qQb8KozyYx1wAQQ/WKDdkRVbGM/zN7xVUziKWdlbwii6ZDRKb8Rj8cM0mldOrz7da4/XKaqowTXkNCs+T8Xg+zKo4bW3BDQibKGud4sXOZYfOdbv4miUDzy4gIqoId+1h0akKx0rzzV6zT1lLNjPvFPYwc9JoQGmtbYOpypfuwOLVQQODVaZg0v4C/xsrWKqr1g7r71JYHoZc9Og7YEKgONWb3i7Eud8PnX7vXKDtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a5gbFSyoFRK0guk69IMyXpdI0RO3UIBCLkofjUx0efI=;
 b=hF39abDB3uuR3zw7TD7mboKR+opTCp07boq4V5157luttbSAX/omdkTRDFwuAdBed7ojDyykrzFGwYkYD4ClWmLR1qcMSbBqRcQwNo0NOqvs/v6lZ7X/KHb/q/TUUChSs+VQ6ddh76IJeO6G0Cal/9htS4C2zJGK2yu2+jogGPkdV/uZa0YU9FzZroLvCzqe8Z7Np1H2G/6Ay+eS6nRQZtDWvH9CX3yRh4fWAq9oFgsDivLBY9bc10kLglv6KTFhDv/yJEmUl5k3/jNryOV37Avo9oesCiVUz5JMFU5ok144IUIefWL0ri52PQGqVPE579XBlU0vob+8y0wHUpFi6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a5gbFSyoFRK0guk69IMyXpdI0RO3UIBCLkofjUx0efI=;
 b=OKuZCkv7mT/ZlTwHM/YULLnAyyuyxBKwA9l9n/3lg+s0Z7J6+qX+5zKJ9oH0ErgIqqt4WLgY4gWA1aWWVMaG1fdfeFbHmpOolIKo5G9RmVATPg90puMlF0dJblGKYqk2RpagJYq0vzjA2Sxaofbh8eYl0wMfyPP3KQEvu+nFJoZMLoYbtK2uhvr3vvSgrjWo39sEFQkcKmFteFgtcdKVu6LH7ZKKkuc30z+tx5+pmfI4a+WmA7iVYRwL5ulbuKzs30KZOssavnZ8Y8adEfEH7CWYHM6cd2F5ChSnZ6O2P4+vHhTa127IW6RMv551Uj87bKz807Fy0IZMzCyb12tAvA==
Received: from SJ0PR03CA0066.namprd03.prod.outlook.com (2603:10b6:a03:331::11)
 by CH2PR12MB4167.namprd12.prod.outlook.com (2603:10b6:610:7a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Wed, 4 Nov
 2026 18:48:57 +0000
Received: from MW1PEPF00018893.namprd03.prod.outlook.com
 (2603:10b6:a03:331:cafe::4b) by SJ0PR03CA0066.outlook.office365.com
 (2603:10b6:a03:331::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Wed, 4
 Nov 2026 18:48:57 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MW1PEPF00018893.mail.protection.outlook.com (10.167.249.170) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Wed, 4 Nov 2026 18:48:56 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Wed, 4 Nov
 2026 10:48:32 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Wed, 4 Nov
 2026 10:48:31 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Wed, 4 Nov
 2026 10:48:27 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>, "open
 list" <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark
 Bloch <mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Parav Pandit
	<parav@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drory
	<shayd@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net] net/mlx5: E-switch, Restore host PF enable for ECPF that isn't E-switch manager
Date: Wed, 4 Nov 2026 20:47:56 +0200
Message-ID: <20261104184756.773910-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MW1PEPF00018893:EE_|CH2PR12MB4167:EE_
X-MS-Office365-Filtering-Correlation-Id: 72c84c2b-4ae4-4c12-1e93-08df3aa44825
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|36860700016|82310400026|261026140227099003|56012099006|261022105027099003|11063799006|261028144727099003|261009223027099003|261021121427099003|261021123027099003|10067099003|18002099003|261102123227099003;
X-Microsoft-Antispam-Message-Info:
	B2TNSmLTccf3gP6rliElgYbq7uUclRP/UqW9k4JwDAtB8sQpvtoMHf+RqJMsQ7gs3TzHGTt5HMRAK0e1XtIVp4iOU9oRFzhTVTZSCf93lqNaW8UBDO4sSAhrSlL3JL53yq5uWr+yuKExEi3ZvanynX2A2WPFe0xAgUiZbFEDeKdjksJ8kxHr0mfJqZxhAU+BhJKCOeQORGYuCQ3kyX3PdNZh3q7vVjqrypqxrdo4fG/x2Cpro0yUndPkEQfLMzE1R7Qmf/HkSfwlas6m1xhYRSlBHhG/wLbyo/IdbVGFVBqOE0CgIkn0ciTWGy002GZITBJRsIZSDEvj89qTP9mmSH8LDGfNeQjQKk0Otmf0FmXg5AC/eaPyHQfd2nMCVTsgmA4HACiPGefHqhf43IrI27Teik0L5z3mhmOT997mOa/jxMpusnYIm/nG/y1UuQYUjodeVSc6i4/2AEssujmxfaGQw57NkRx7XgNpf4lTvE5a2uYGudiRT7F2x3OvOHnZpbVCtJAM8KRCAIlJEjnfREbcs+w+S4hDTlbW0us1GDnQ2OgP8od/7qBLGR98lRrxAFEAgZU2rtdSjXqyw7m7sMPXiFeJ/yiW3XcfHzw83BfdznhOKaGyuxkKfXRJHWg+Rs2zNZhvfBOREGYmY0QO+4+3ek0h9G8AnehO7n9BIXXpeHuwpv09rBv9GpUMg8lYU2Ok8NDZg0qqRJVDmS+CcA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(36860700016)(82310400026)(261026140227099003)(56012099006)(261022105027099003)(11063799006)(261028144727099003)(261009223027099003)(261021121427099003)(261021123027099003)(10067099003)(18002099003)(261102123227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	V4WcnZLdeamixGCXOMMZu3BYVEX7tv2IezNYJEfF+lERPacw4mMVG2LQ/sooFQ7+LK33tjAiL8YP8VCHb2JsO8cXKXTbwaPVNZSKTtWf5IMUsrNa4FRgpQvfcCUryO2S4xkXsO+DGNzOvJbQEPLZV08QyKSjWCOHbecS5w4b2w4dMPSdd4aU3yELog2BYxU1stUv5B8zXdqaoczCFn90Prr5X+va6md9ezXy5QxrStzDCq6nrn+DAUMJ+cI7ZJZjfnDaw6EsRj9yjXRQOGUUrbNQZaLtX91t7QHwMO2FTlCywxpApQSVUm9+q+9eUaU3mj8tRamhgP1nkwezfAbqqDhrCR8oU3ylH3J1sMjghCFNifWZIXex2LeNR1Lwa+ozmeL9mtocCNcTHx2cgtQE32d4cJ7KTlVz/oCIiA5LVsqnORDxLG5QllzrRa28PS81
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 18:48:56.8410
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 72c84c2b-4ae4-4c12-1e93-08df3aa44825
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MW1PEPF00018893.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4167

From: Shay Drory <shayd@nvidia.com>

The cited commit breaks host PF enable_hca when the ECPF isn't E-switch
manager. For example, when the link layer is infiniband, the ECPF isn't
E-switch manager, so after the cited commit enable_hca is never issued
for the host PF, it stays in initializing state and fails to probe.

Fix it by checking esw_allowed() only for vport bookkeeping

Fixes: 0e6c95c98829 ("net/mlx5: Support devlink port state for host PF")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 24 +++++++++----------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 2d289fb1353b..dd7e33a20ab0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1514,13 +1514,9 @@ int mlx5_esw_pf_enable_hca(struct mlx5_core_dev *dev, u16 vport_num)
 	struct mlx5_vport *vport;
 	int err;
 
-	if (!mlx5_core_is_ecpf(dev) || !mlx5_esw_allowed(esw))
+	if (!mlx5_core_is_ecpf(dev))
 		return 0;
 
-	vport = mlx5_eswitch_get_vport(esw, vport_num);
-	if (IS_ERR(vport))
-		return PTR_ERR(vport);
-
 	/* Once vport and representor are ready, take the PF out of
 	 * initializing state. Enabling HCA clears the iser->initializing
 	 * bit and PF driver loading can progress.
@@ -1529,7 +1525,11 @@ int mlx5_esw_pf_enable_hca(struct mlx5_core_dev *dev, u16 vport_num)
 	if (err)
 		return err;
 
-	vport->pf_activated = true;
+	if (mlx5_esw_allowed(esw)) {
+		vport = mlx5_eswitch_get_vport(esw, vport_num);
+		if (!IS_ERR(vport))
+			vport->pf_activated = true;
+	}
 
 	return 0;
 }
@@ -1540,18 +1540,18 @@ int mlx5_esw_pf_disable_hca(struct mlx5_core_dev *dev, u16 vport_num)
 	struct mlx5_vport *vport;
 	int err;
 
-	if (!mlx5_core_is_ecpf(dev) || !mlx5_esw_allowed(esw))
+	if (!mlx5_core_is_ecpf(dev))
 		return 0;
 
-	vport = mlx5_eswitch_get_vport(esw, vport_num);
-	if (IS_ERR(vport))
-		return PTR_ERR(vport);
-
 	err = mlx5_cmd_pf_disable_hca(dev, vport_num);
 	if (err)
 		return err;
 
-	vport->pf_activated = false;
+	if (mlx5_esw_allowed(esw)) {
+		vport = mlx5_eswitch_get_vport(esw, vport_num);
+		if (!IS_ERR(vport))
+			vport->pf_activated = false;
+	}
 
 	return 0;
 }

base-commit: 647b81ddefc6364290e67bf33c89d54971f8995e
-- 
2.44.0

