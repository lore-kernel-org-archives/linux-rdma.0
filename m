Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793726016;
	b=M0wqTiwMInSjmOPVLxmYawL2nUSiQArJdrF5Eb+QP8CMF9WciBYaMH7RFNx+6ztKnIx0
	 ZBOocZjG4Sl3Z55/VWTG1kX2dahr6hOGmFObsnQmUScO07XH9LW7nbxAgoC26MPBEv6qE
	 oI36Y8gE+2qwDtflszECATBjDgQJ8Y8vADv4L/3UpiRdozUZX1SzQOMCp8aegpvcaJwfA
	 NIcPJ1PMfD+yv9GKGx3GM0clGisfkJr7pPAGRxTzNsS2RkiofKxC5dqxmp17Ccsr7yfUr
	 hFCk2boDBNRtzbhhzvXWhSsXiIJomKHEA8sxnbEF5U5UaIqt0Jab+a/VwbaQbBaq6GQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793726016;
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
	b=Ve268/HVKFqpCVg5WN48W71xEnsLdOWdUbs837H7tvkA6YgJPFlQtvROCkogovSIgwOQ
	 BR4qQgQxCvb9GIKPBM1s5b9IKNeiZVdzZJXTH0DZfmn2vV/jnLq4PvF27NT3BNjS8+L/r
	 IPpiB1Ub1qOWGR/OLzo3KNebEz6m51kOaX/cGqXAa15AedhyVLHqE8q6Ij43n79igZMrF
	 nvl+5S9R0zmD5L+HA/EhDRxB4fYmqA+joG6IE7C608l91puTT6jISFLDDEfAQUmmxLK18
	 EezHUQntcbb7AQyh0dT77a1B9ePJKoWhMFo5tkgRi2K++gg+QdQoWLYIoGAUjXeGDVQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=NIWRPeLO;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.18
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012018.outbound.protection.outlook.com [52.101.53.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC4FC606D816;
	Tue,  3 Nov 2026 17:13:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC4FC606D816
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=NIWRPeLO
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wxEb4fE6DayQvCteV6tFKtsNh2nEXX+DAnk3b1uDtShXHZ3psJIYZW8WMPlt6qjtdzJk2vojHfTVx2FbfBOY78smFxoQpZfyDd+q+mj2qENxBDC2PUxOGniauDS3pNElwZ8oYph++7CL3phhE7/r9fy4KiZAQXyfsuXFxjaBdE0CFECFQRh+t6vxvMQsFFRCiXiF5YLqQny0ICLVXWeBBbwjPYTc/bqYkfBsGM0aLWDA7RdlN/afgJuaSJ4Wv/GQm8jppGi36XY6NMCJenSltTuoss/EcJBILXTLDcfOfqkeMd+Tm1VlALj2EXykc7cdWXcG+0WqTMAu2KOkVaRxwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HyAoN7Wn/uYO8ET/z8SfTSPDpZE/guJ00oXU9cmcsmo=;
 b=fGVhKIVJP2Ua2apV+KiXFM74cZvDAzR/P9e1ASukal/1+QqSU9olu86hkWNuxmGhXYrHDgagr91L+ToTTSrLAvXwlgTjK/U4EUpYb6OmwjhYPzCy+Ft1YRQFzfxiykiZxrF1mFHyM1H68RVGiLBYFA2dlexu235rLMEYI/nxtxljPVILKNpfT/TaSkRxhlNHGghk4DeNKBFYvl45fFadYwTy4M6lONMDKXJFv1RU49TPWk0j+q/frw2EnntAtczFFe+5pANojWIoedi9k7JePCMsmIbhiVp2duxNywuoYUdcaqu6e//no++ZQf7G3nwgdR/Z5J+j1iKYoEjhCCFwaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HyAoN7Wn/uYO8ET/z8SfTSPDpZE/guJ00oXU9cmcsmo=;
 b=NIWRPeLO4XrvMd+yndspoh4X1TQrpmW/Wya+xvx5T15Va4glVWdy1cYJ8cINf4X/3cixZNCbwlEPfLCj6YgbR4O4ToTmYIHB0kEkWo7uLtgr9BddkgXSb3zglc0KxGtTNlC2/PyHSVpWcRFUtoX34tgzD4l2mpI7nzaJc8I6GqYYbJnzli4SJX7TGhaGzvv3f4JxycKR9RUffORP+DnNHQLUYcQ0jf6DzBlkWbBOLsNZAqxsubhiFP8kpxVSSICRIALf/BnswDAx35YnjskHsn0HEvrLuROWUKy3qmgJ5TeME4ptZwhm/Xre1Sykv5Av413Br3cjCE3vaCuwK7j4ag==
Received: from MN0P223CA0009.NAMP223.PROD.OUTLOOK.COM (2603:10b6:208:52b::7)
 by BL1PR12MB5756.namprd12.prod.outlook.com (2603:10b6:208:393::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 17:13:30 +0000
Received: from LV8PEPF0000006B.namprd03.prod.outlook.com
 (2603:10b6:208:52b:cafe::35) by MN0P223CA0009.outlook.office365.com
 (2603:10b6:208:52b::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Tue, 3
 Nov 2026 17:13:30 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 LV8PEPF0000006B.mail.protection.outlook.com (10.167.248.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 17:13:30 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 09:13:01 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 09:13:01 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Tue, 3 Nov 2026 09:12:56 -0800
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
Subject: [PATCH net-next 14/15] net/mlx5e: Register eswitch-manager VF/SF self-port with switch-id
Date: Tue, 3 Nov 2026 19:10:08 +0200
Message-ID: <20261103171009.563034-15-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: LV8PEPF0000006B:EE_|BL1PR12MB5756:EE_
X-MS-Office365-Filtering-Correlation-Id: dbb8ea2c-9877-41a4-e7b0-08df39cdc8af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|36860700016|82310400026|261102123227099003|56012099006|261021121427099003|261021135927099003|261022105027099003|11063799006|261021133027099003|261028144727099003|261022115727099003|261009223027099003|261026135527099003|261021130227099003|261026130827099003|261026121527099003|261021123027099003|261022113327099003|261022075727099003|261026140227099003|22082099003|18002099003|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	gBYkoivKIowDoWmEkohigCnvyKBRV6/iAyMNFhwUT+uUt/YD7zV24Bpl0hU69HgWPEwM94sa59RFGLVwFFwQpCY3uEbdg4LWUkRBWJA3cdLH7Lk0iEBq56JP5hCunPqRvsodvXOu6UDfWFZD+aFwjvXMAzfacjKkBzKjCZoYCJqBESpm+f/EnC/ZV1dN55cwD54YC2FthpRIIILIxgjZPWg0v4tEqx1O5JcLvK17sJNFeaC5H1XhR5SnwMN9VITtNgstNTE9rx1wmC1kLjrYQ6LSCuL6cbKml0kYm1X2l6so953NoNySKgzUyGvZrkMcwxhy7qEfvRLd1wdLXzegR5L+lz2hSdgFyuj9VsoUk29hh8nbvXwR2/h9wvNFvoOsGsTacTYXe4EKwxGkf1aL3a9KtceokO7hzybqVr09FOruIHH3BLRfsxAqamZjh7lbqJoVhdq32jt0GyPLnjyggYYXWi7o0E1c+VmTuXKRAgiKxqhNw/XdHilLi9fyTRJxlf5EwbgydAPcn5vv8L4dklosULno3La4LzQdwwFTyRomWSBEwNkcRR9+OucROVsQWOBvolHDY29J2xe6XccotNY/6pLe2qh9z6IxZWMntaVwdiT+xypAu9G7UEglrNaCCiSdgbfT91wBCG/Hh4dVbnrVfOzkeNdECW/psKJLjiiisiBCg5UNQKP2qOwW+Tf+wXqq5t3fDaBwP3Mdy/6w1g==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(36860700016)(82310400026)(261102123227099003)(56012099006)(261021121427099003)(261021135927099003)(261022105027099003)(11063799006)(261021133027099003)(261028144727099003)(261022115727099003)(261009223027099003)(261026135527099003)(261021130227099003)(261026130827099003)(261026121527099003)(261021123027099003)(261022113327099003)(261022075727099003)(261026140227099003)(22082099003)(18002099003)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	h0hnWRh1N66T14JUkUOxCwi0gidvzh/r0OkOYfl6FU1nIC0uvYFWU3LkaQ2pNyacIdMIYX6P01uZ5DsdQY8QR3sZojBQSRW8MXFoDjbX+g4AoaSYXqgUhPYzZmPMsEhYeKcIwPgiwlDZ5a93iWNAdy3rd+1Wj4XPtS14mflbWnGi25X/Ph1ze57+fxUu+DeXJb8aR1eGGHl5p/2Q6Bptru8OeiSeKrQwe3cw2FvpbU4xBZ8mWgiiZbPFsTrSis5b+IR3+wfJUIPwm+KVdnl1VgCDkPfqrql7qVLLzH5PUQL3xervviAoL+LFW+Y66yNqZuKX6N3mMAUzLQNDiL/wbJ4I2D0gn7XvSbqD9rQy1cZiSDnTHRBj3tr0m8QDZiK52UEYcS7tcQGp6m7q7oCB3g7WkALjRxYVkLatS0fAdu7jvJKqz+hQsXj+5vTivFc7
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 17:13:30.6048
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dbb8ea2c-9877-41a4-e7b0-08df39cdc8af
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	LV8PEPF0000006B.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5756

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

