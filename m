Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795161740;
	b=w4KaTqj/yX7U10kj4jPwnwlmY9dcfnQdL7FJ/T4ZNLj8h7aVvXlLSey2yVMavnMvamQU
	 FXx23zAVdyTjE9gsXq1CTrqV7Qf5pBy0RzWLMnKy/HRZe6D5+3ZiaV+q0AzUOb0jUgeHo
	 6kwhiHV6h+/tGEt/WyWPKljqHLZAsESurDOUzSzwvF/6vHltOPHrvaSXRfcg1lVGPHn+A
	 L9uXAJ5Dgz5xJQdLxhmmgZ1AwUqbdliX7pnqMGOPVP1nsX8hVP70VKBKoFoCi37uen95k
	 YcquRX5e0FJy3mRdpx2H3RpzwfDQDoyBfnZI0rW8pj7zn4mXHkc2EXO/OioKe/8RBwA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795161740;
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
	bh=HyAoN7Wn/uYO8ET/z8SfTSPDpZE/guJ00oXU9cmcsmo=;
	b=gccVn3WIZEicYp6u7Qmf27M7gqeROM+YFdD5VmnjHgl+ihtrpm22aMuen5X5a9md1QCD
	 g8bXDQC1vkhZyzmJ7IfTe7FNISQEeKc8ca3mdvkREFaFyni4a4bKPkEMPzSMQGUp6+Y/v
	 6F87b09Xmzdlu7tk+GZmj4wVP39bKJspS4pAxDXDgYjYxVd7+pazhDYNLffw4luw2dsj8
	 nFiihf7y/PBuGrol0rJto95zXX3f/oroJXvKLWENavLzvFcjKG/Pvmfyo0nkKgBQAlqPL
	 cY5tEWvmHeY7nwMgv2NiRre+lotnLR06flRX7LsRJKeZ8R6CcOCaTLGSUGDGTaIrDvQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=k8Inq4DL;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.46
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011046.outbound.protection.outlook.com [52.101.52.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DF0606A33A;
	Fri, 20 Nov 2026 08:02:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 40DF0606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=k8Inq4DL
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=djbWBqQj1sF+Pl4PZgzZY6s1rV5+qya2iVMsAeZRY2if8Uph4GgPH4oXaHynpFe+Gsv8AZ7Ejw+BtgzBTe4xt1Iv+wZr4IbPMD/eK1+o+WtqrUQH5/AmOPqnEUwd2xd41xDPBsW+AVN+NPVJeUnRjMd6Ahr10w8fS5DawWfXyUczvVLixXTIlce8+12CfGoIuYKgzPFdyiAS2Cc/sCXMHDQPyJHd8RsBVm4zhUO7K9nTLi+BZUe3vDPKk/6xbRPxAebGOb9nU8Ny0shF4sHRY4o5qBnRC47AZOkSDiftBhxH7aJBgtNgTPReQ7ZGcMb1WCHU7ZouJoOMq0GzsIJ3bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HyAoN7Wn/uYO8ET/z8SfTSPDpZE/guJ00oXU9cmcsmo=;
 b=opBc2qogRTive1FWFB1kMg1gKxhDtMsaDZziaJC+ZV7qrbmmbpFx1lV6t6unKpP6Owj/PxvH243dZq8BUp96FInFiDK7rlat5jVaakgEnOb11EfcMw8EJkHYhg4H6Cagpz5sDqmhorSYh/rRxxJDQgoUm7EwjzFScP7QCW2Ij5R0d7gLsWT9SXAN2n0Wk2wsKUtJHAxA1suW1DeE4KiP3oKAjwqPjCXTtkiT9HFJnm51Zpob+YSxD4wj0e0OctusZdfQx2C08xjSMtng+Y4PHF4LLiEgjZm7StkvrSM1Y0LY3oq24Tz/5eRIhJjd1ap7wqpsvEVFyqvPrVdct6L5vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HyAoN7Wn/uYO8ET/z8SfTSPDpZE/guJ00oXU9cmcsmo=;
 b=k8Inq4DLH0tojdHxumDPpQsYl7GDyJdiZBFEqCZxI9NBWiIWwr8cPMDzwS+TiQOp1AltQhPBgbaGeImzMBT0MHiAgc7EdzywTJkr5RZdckejPM1XUQZWC5RAlS+cGGA0rxBzoAznTDNu5SZKvphUSFR3/UuDT271bHB0ZhSmkPsiHHiV1isWv3lS6kXmVcVPEh7oEb4GdvbgzgEg+LC5uy7I+NJoBsVuGHCX1wcnO6+Qq1iDFwUYMEhTCSkSryLkQpC7tbeU+gawJnQ3cHXfcl16aJTVkf9IquRPnTvVsurc228DKfhug6RcM0v163c2sPXnPCFITajv0EftAbPo8A==
Received: from CH0P223CA0028.NAMP223.PROD.OUTLOOK.COM (2603:10b6:610:116::25)
 by SJ2PR12MB8111.namprd12.prod.outlook.com (2603:10b6:a03:4fe::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Fri, 20 Nov
 2026 08:01:04 +0000
Received: from BN2PEPF0000A804.namprd02.prod.outlook.com
 (2603:10b6:610:116:cafe::53) by CH0P223CA0028.outlook.office365.com
 (2603:10b6:610:116::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.13 via Frontend Transport; Fri,
 20 Nov 2026 08:01:04 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN2PEPF0000A804.mail.protection.outlook.com (10.167.245.168) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Fri, 20 Nov 2026 08:01:04 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Fri, 20 Nov
 2026 00:00:41 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Fri, 20 Nov
 2026 00:00:40 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.57 via Frontend Transport; Fri, 20
 Nov 2026 00:00:35 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Gal Pressman <gal@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shay Drory <shayd@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net-next V2 4/5] net/mlx5e: Register eswitch-manager VF/SF self-port with switch-id
Date: Fri, 20 Nov 2026 09:59:57 +0200
Message-ID: <20261120075959.2533702-5-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261120075959.2533702-1-tariqt@nvidia.com>
References: <20261120075959.2533702-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF0000A804:EE_|SJ2PR12MB8111:EE_
X-MS-Office365-Filtering-Correlation-Id: aca36b6c-459b-42d2-70f3-08df46dc6cee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|82310400026|376014|23010399003|6133799003|22082099003|18002099003|261009223027099003|261026140227099003|261022075727099003|261028144727099003|261022115727099003|261022105027099003|261022113327099003|261021123027099003|261021121427099003|261026135527099003|261026121527099003|261026130827099003|261021130227099003|261021133027099003|261021135927099003|56012099006|10067099003|261102123227099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	fMhPpTLWsDo6cyIRfZLwWkyNnx36XPWkmlvCJ1LhGmRrw4Zt8xj9i0hvkhXMAsZ0sLsAtMt11grKiuHJl2EleSxvZxOxrKBdnrA1jDyjMsl6PddSkiGdYwlKxkpjs/zoBSxMtrQJN/faIqp/f2X2LQKrowkrETojr9ru4QvJ/gidSrZ1KE05sSHrxXWjcWcyeFBXN1zt4q5xCCaeKCyp3nZbEWML7wDbe7qUcfVClifq3b+/DqVH9pa1qgt3Dej8qYHDEc0p8GRe5gwKMxljWMnI+sgoacvEbAP0xpwlmhG7WuoNHu7SW13x59C6iIwMZouyyik90H/SfEKefT7TE7wVYlkHu1eu1kBEaRfGUNtW1ky4DDjEJtDE6AdcQqBM4wEj43r2AqQSbyg/ll5JFbHnaUadsKE3u8M2U5wfyyVzm3gLNrEeEkPO722xoS8h0scf+iFmGWYb7WDIFcDB7et+XSPreB+Kiz2ixsdp86tP66tgxMD3E7b32K54swRSVuAGqp+dzBox0w2YBkyNzVow4Od8wbmNMobK1nfcm5dUTpCIcAlGFnxRCnS3BGEcTc8ZGBAVzpuK9yrtuCBHSuFwSwCbCSK0yIEpsvDxGHLRpbNSnA8nJROaB2C6Nha+Kk59b25yh8/M0MNiVM14TfwNV8UAyffMlzisnT2gO0cIu8ccPyCZ8+kRin4ewqC5Vlqvq5bPUMA045xbDFxJXg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(82310400026)(376014)(23010399003)(6133799003)(22082099003)(18002099003)(261009223027099003)(261026140227099003)(261022075727099003)(261028144727099003)(261022115727099003)(261022105027099003)(261022113327099003)(261021123027099003)(261021121427099003)(261026135527099003)(261026121527099003)(261026130827099003)(261021130227099003)(261021133027099003)(261021135927099003)(56012099006)(10067099003)(261102123227099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	EMlJ+0c4i762eKQ8PCMMBrJkyq3jckiR7lOg4E9nZ2uLbnkuB1oqPwipPlniLY1BB7Q7njo8al+PImpylRE4FMhVxQ1JmXhNU+4Z5SbILXSvGM1o4zv6/qmupZGjU3zPsnTtXpbs5bF/ssdgETyeC7JSTvKrHpTbSUhmBGvaDDjBq5jhJ4JZSOJPP1iMQjG0fwoT2l/HEdQelWowHVtq+AjXvkfCzJcakzv0k5x1Z8noxDxawQuIMWf5dNymz1DRSGAeIRvXUmkVmBNmZACKJY4o1dyaziulBaF/mXPUK442lDgGRSRhqKSoHY98hkeJnTEcteAVb9flK4BF0lVt9CRuNIw5bNXCTJ+++oRAuBgHfitTvARh60WKQLOCGTSYkhqtCA0O5zpy8bpsckghf1Z7OVDDO2u+QCcTA01FuKTnQyVaIPBnQ3PQE+j3OQYe
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 08:01:04.2552
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aca36b6c-459b-42d2-70f3-08df46dc6cee
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000A804.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8111

From: Shay Drory <shayd@nvidia.com>

A non-PF function's self-port (its own uplink netdev) was always
registered with DEVLINK_PORT_FLAVOUR_VIRTUAL, which doesn't carries
switch_id. Consequently a function that acts as an eswitch manager - a
VF (or SF) running its own nested eswitch - exposed no phys_switch_id on
its uplink netdev, so it could not be grouped with the representors it
manages.

When the function is an eswitch manager, register its self-port with the
switch_id taken from the system image guid. The uplink netdev is already
bound to this devlink port, so phys_switch_id is derived by the core,
and the managed representors - which stamp the same switch_id - group
with it.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
index 8818f65d1fbc..79adb1ecc450 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
@@ -63,6 +63,11 @@ int mlx5e_devlink_port_register(struct mlx5e_dev *mlx5e_dev,
 		dl_port_index = mlx5_esw_vport_to_devlink_port_index(mdev,
 								     MLX5_VPORT_UPLINK);
 	} else {
+		if (MLX5_ESWITCH_MANAGER(mdev)) {
+			mlx5e_devlink_get_port_parent_id(mdev, &ppid);
+			memcpy(attrs.switch_id.id, ppid.id, ppid.id_len);
+			attrs.switch_id.id_len = ppid.id_len;
+		}
 		attrs.flavour = DEVLINK_PORT_FLAVOUR_VIRTUAL;
 		dl_port_index = mlx5_esw_vport_to_devlink_port_index(mdev, 0);
 	}
-- 
2.44.0

