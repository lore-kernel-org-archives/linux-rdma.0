Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.15
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795012660;
	b=EFuLqA6+jgoGnrFwRDfGi9cHIgenYLi9CENauGdsZdtfCi2MUQvhDyr/lSDAE9RcP1+0
	 CPnGsVMdMGTCtBDrpoWmnPpR8Cl/Zq4mdsNffVK/GfzPfAxm7H55TEPo2IMAxFsbaVeFw
	 jmcEKiaRYYuB1E/QP9GJMyVcfufFebIo7Q+v+16JxlTueJ7pLhiZ0I53bgtblkbbNSOAo
	 YV38Y29H/pZjcYfFg1tRYvBKrHtmODKxuAeVolgHNR+JifzLjoSwRIBz4+8TivPETFZ93
	 x0pRe1oNRFZFonm3UASRMpFLkGY99NVffRA+Sgq1fPL22uWDeHfnOixmnLipF6IFM+w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795012660;
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
	bh=5bsG/RtGS9kS4HBtPoWAiHbdfbFJc51cGIgl3mtPDIg=;
	b=k9/MfY79JNqQv//yOrw1bdfPB4IMba2pYEpHBXZkP16Jtc5Fspyv+HcmI1icJ+lO38MP
	 zF5bTF9uarp9uK7FqYIIzpxj7xfeAaXWn3DUrHI3kucBU67GeGtMTV2Ag6NecSbbtRf+E
	 32w+RxgEXamDECBig+Y/Q4P2zLWsI0tixFKmSCLxrsaCuG8AB8o7XJ8cbRPKFiAV6l263
	 JkJ5BMMgZ+m6ssNQP9jHc42KNPQHqRUXdRWRdOfwRbalLbzJwsEnr+gQvLdYweiC080mZ
	 rmG21iW8UtzrmijqDtM1PjFjGP5qtkJrEMLYpeA6No2ETQ1vyjCBSQEo2Zrr3k4zEzA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=tqtI8JaA;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.15
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012015.outbound.protection.outlook.com [52.101.43.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5869606A332;
	Wed, 18 Nov 2026 14:37:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B5869606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=tqtI8JaA
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mlpvojKMlfN5QyfmAyuXIHQdQTSLnQ4xfoq3y9mWtYgMika6adKzUL/jy/bZEBbKDuYJEKUJ2N1qRAc8HBw83soMtd/+qp3qkyGddP3Mwd3q6rG+/KY8UbLOeLnudkR9rNnwl580LKrWBctm89HcgC5nPPmyaJbZRTObEPXaoOMeCxDTg7ioSmkXvCSwoMXHzM43jp6odNabc2kUMjfZE63JURq8EjVWvTEIgqpZS1VPyaoOWj4znR62Eiw9XN3UKj7vDUVFLT3XNSs33yC6m5lcDTcSW/m34q93mAtozCoS+iM4FxrVOS4ThUzhrWvT5yXDdosM5ps1D6o9bnh32Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5bsG/RtGS9kS4HBtPoWAiHbdfbFJc51cGIgl3mtPDIg=;
 b=ospldwfFFN/eJlLVKY1v8n5c8GQHI0AeOdhp9dTogq0hWXXgxAWu6/elzzT0vXRviboMKE5XZrXwWbS0wz8lbjoFGnccFzV1kfWkSqC/8c7GPrk29cUZRGyYjeyCxCZTyL9zARpI2BvyHc7RWyk4wcbXPWA3QktZFpLQ0b5dP4coiKTo55bytPwPK4mTeUwQnD1zjJXzWALaHmhGwJHzINIPAZdPrVA38H//X2449Sk5LPDUCZYaPLBhjCIPuWBjTt7p2wixcxA+90jtrgTMj0x26MPhyc90wxQp5dXqNO3K5gJfh+0qNoDmmmH6P3LkZwEX3ng4K4IgIQWXdFLc7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5bsG/RtGS9kS4HBtPoWAiHbdfbFJc51cGIgl3mtPDIg=;
 b=tqtI8JaAObm+HMQPHFunzT5gsaA6DZL4rgyvfs97bop3N3pB4GO6fXrqQj6Rw1NBiVg/QmyYdJQ3ekD/nzIrwSRTcxyw1seVEDvfg2DXa8weDO6vApmoB8CtlbKoa2SjuAth9JMy1C9Cv2pSDhZSBX0TaH9JJruj8Xt2H+XU6L7b0XC28UKFAKEfzHC4I7cZypILrG+4LxmNWNfHX0SjEE2MEaBSig6K1uI6xUnnxku9UOZri9zAET+24HubGySWXdTA1jyQi8jjQboN5IQ2K3ukZ73kmeHM6N15G2ffuG0uT9RWl0c4jDB8DGPt7J9JRC4FApMl+dYXL/K6IEUbqg==
Received: from MW4PR03CA0289.namprd03.prod.outlook.com (2603:10b6:303:b5::24)
 by PH0PR12MB7816.namprd12.prod.outlook.com (2603:10b6:510:28c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 14:37:30 +0000
Received: from MWH0EPF000D8951.namprd05.prod.outlook.com
 (2603:10b6:303:b5:cafe::21) by MW4PR03CA0289.outlook.office365.com
 (2603:10b6:303:b5::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.13 via Frontend Transport; Wed,
 18 Nov 2026 14:37:29 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 MWH0EPF000D8951.mail.protection.outlook.com (10.167.249.217) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Wed, 18 Nov 2026 14:37:29 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 18 Nov
 2026 06:37:06 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Wed, 18 Nov 2026 06:37:06 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Wed, 18 Nov 2026 06:37:01 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Dmytro Linkin <dlinkin@nvidia.com>, Fernando Fernandez Mancera
	<fmancera@suse.de>, Gal Pressman <gal@nvidia.com>, Ido Schimmel
	<idosch@nvidia.com>, Jianbo Liu <jianbol@nvidia.com>, Kuniyuki Iwashima
	<kuniyu@google.com>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Nikolay Aleksandrov <razor@blackwall.org>, Roi Dayan
	<roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net] net/mlx5e: Release FIB event work flows before dropping RTNL
Date: Wed, 18 Nov 2026 16:36:53 +0200
Message-ID: <20261118143653.1915247-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000D8951:EE_|PH0PR12MB7816:EE_
X-MS-Office365-Filtering-Correlation-Id: 99596aa7-230c-4915-a527-08df45817916
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|36860700016|82310400026|261021123027099003|261022075727099003|11063799006|56012099006|10067099003|261021121427099003|261026121527099003|261102123227099003|261009223027099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	WBOsv76IIdP7TOZVPZLopfAXLQowlVT4VugmVqgxXsyb4HWpoPt6zXiU+zPTNdbgkjfBaQbY9Lrup9npNB6ZUIqmtTUH1BLKrDFWtAWuKtFIBufgIQV1FvUVHF7gnRBTq0LeNWVQ2E0SrprpjKrOQ+b/mBirrLxjjWVszNylFT4Z29B0IegkMHiqgxYj65xXuIlrhxkKFR+ii1J5yl9Rea9HCUbE28M8SsuZ6zFFTJDJjLVAtJKOR2SAyonx6rj44m/jZbb1NAI72iOeSWTEpkW7HrXW8LxTaX6PWo9xBZUcAO5A7QX9mLHb06ygVNxUsg43JLVnAa9Y6aEtBVK5M5osBrrBDIlv1AY4DhGxJqLY9m+gzR6W8Zvk2B2FVB8IW35UuLQeyDT+NOq6bz3Q6tMrbBrULpLA/JTuW1mAC0T04gdvL2OxlnFftMXxjPAd42QTwnknm2wPBLoJzBsGkms9Auj/MA1qMNEZifgeuVJt99FOJBy3LE6WBZOYgJkBPNCxsGgFv0qN4frSeyHXIkLiFDVPCU1E48o7iI1S60cj8aaugSWRJl7WA69m0iClKe/Pa1yR7w9Vk1m3e9reYFghB+7wbGjLsRK8M6lGRfNt0d2VlDjrTM64PtXvwoTPi1biqQYCEI5at4mpCriyLYNo6Oc9oba33zeGkl5IuPrwAN4EMfkKFlroXv7ZoPsA1IrEq9HB/egM7W4IoyMR2A==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(36860700016)(82310400026)(261021123027099003)(261022075727099003)(11063799006)(56012099006)(10067099003)(261021121427099003)(261026121527099003)(261102123227099003)(261009223027099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	zq6LXvgGHlondZhC4WLiJLfovSpBqaJUiNc4LL8fhRvYzVoE/z0pQm25jLz5wYNwVsp30bdugoeOAGBgMttN6vSqvms4X6IqbNHcQgw8Rz449J7YCHW8J0eNH+itxteQ64Zh0NGUEbQxZ0kO6ISSTbQ9X7jl0CS+MiZH8xhwI2XECMPuZKXtnDxlDjgPRo0zFw0CQ8bboUorT/Dg2x1c+1nRnGyQN1YjVdxCyk9QhY0DHbZ/qAt21IkFC8qPUEB08xmmW2OOrcqLakekUuiuwT0Xrw0w3HM+GZOTKn8F0FdyGdRJAQUVkQld95NDiSOkAHFHnTOPP1dyMadCSf/4s03tHigHljx/lQR5N9qDJbv/+zHWsMEHVwBizvzbH+ZRZceUoX+4HA6cssU2k8PMJU//YIM9P5LDvGZvcCA/yFLZ1wWKLrl56LeVMNLa+/4z
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 14:37:29.3430
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 99596aa7-230c-4915-a527-08df45817916
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000D8951.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7816

From: Gal Pressman <gal@nvidia.com>

The FIB event work, neigh update work and the neigh stats work all use
flow->tmp_list to hold the encap flows they work on, while RTNL is what
keeps them from using it at the same time.

mlx5e_tc_fib_event_work() drops RTNL before it is done with its list.
A neigh work can then take the same flows while the FIB work is still
walking them, and the two overwrite each other's list.

Release the flow list before dropping RTNL.

The issue was hit once in our regression testing (OVS connection
tracking with the VXLAN endpoint on a VF, KASAN build):
  BUG: KASAN: stack-out-of-bounds in mlx5e_flow_put+0x23/0x80 [mlx5_core]
  Write of size 4 at addr ffff8881226d7b20 by task kworker/u40:1/20171
  Workqueue: mlx5e mlx5e_tc_fib_event_work [mlx5_core]
  Call Trace:
   mlx5e_flow_put+0x23/0x80 [mlx5_core]
   mlx5e_put_flow_list+0x82/0xe0 [mlx5_core]
   mlx5e_tc_fib_event_work+0x704/0x1fb0 [mlx5_core]
   process_one_work+0x8df/0x1660

The race was also reproduced with an msleep() inserted between
rtnl_unlock() and mlx5e_put_flow_list() to widen the window, a VXLAN
encap rule whose endpoint IP is on a VF, and route churn on the endpoint
address.

Fixes: 8914add2c9e5 ("net/mlx5e: Handle FIB events to update tunnel endpoint device")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index 5e40107efa26..4f9f8beffbc8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -1718,9 +1718,9 @@ static void mlx5e_tc_fib_event_work(struct work_struct *work)
 		r->flags |= MLX5E_ROUTE_ENTRY_VALID;
 out:
 	mutex_unlock(&esw->offloads.encap_tbl_lock);
+	mlx5e_put_flow_list(priv, &flow_list);
 	rtnl_unlock();
 
-	mlx5e_put_flow_list(priv, &flow_list);
 	mlx5e_route_put(priv, event_data->r);
 	dev_put(event_data->ul_dev);
 	kfree(event_data);

base-commit: aa40afa831ebfe45e40a23721711059f2ac584d4
-- 
2.44.0

