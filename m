Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011037.outbound.protection.outlook.com [40.107.208.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC9A37A847;
	Wed,  2 Sep 2026 19:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788378073; cv=fail; b=KQUDH+ngiVdI1l3J2lSnCPJB4UJQeHDnEgZZ4g2Bc7/pi+h9WStMgfKllF34Q7zez2RbhOwqdu/IRVriFpI1es2gwFlegXWtuLjCIy2L69HodsmeJbP1KTnqjXF5e6+NeK0JmLU4Ql6JjmyfNFmBnGVkKyItcjGLQ1JvDilk3/g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788378073; c=relaxed/simple;
	bh=+gZwyzxc5skxzO6CLlrR8mGjtbKxIBoXc5mNjWIf0oY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=oPyqjUGIrM1NzlysFpNFbhuRpL4qtXGCs01J5HqEDLz3nQ97tvuJl9eJ8znlmpP2/4ZU3AjebLvi5VNHnSi++doauMWnftPheIfNyZGuCPQgm8+0ROa3lcMKhzB1cBEvM/5ceKJQbZdanbF0MZsYcqr77N0hc2+ihkmzUY0eFUE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=f4WI8Upy; arc=fail smtp.client-ip=40.107.208.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="f4WI8Upy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d7U5jUdctpXyiq6OD9myquhckOTGybO5snr9n5j563S/F2mr3sOeVp7jkhy5+evTZTQJTNW76HvmL5BzQ1vvLtL+gxj8cqaunAioQFQ+MVI5hd/gSkKZXLHn3dvcuxUH64pH14XNdLutrZfoAQ1ABUrWu/sWy3dyWMYfwUk++q07jiJMyGMwSwnm1ePaHtMvoF8PSpTwPH0mMZNgMnwVp4gL6qMeAwdhJ8V0YpIDdrRMQHAlL516YGYN/thJ78VeDovgHplmgchKfk3KJcboAAqg26HNf0+hUacaUA9G4b/BOzIiv5DQh1zE9px1dFhM/Sn8Y1iq993dURfXFmO4sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9yy9L+s+nggMa0cHpqzgZ2qv11i57VgdKpudk0ZPtpY=;
 b=FM5PQ/T7BTYQLE5stTJQ4nWzwCo6IyLP5w+Xcf4lD1zxIkpxX3ZJ5C2567Np7vOlXtoShcfar8RPd5nHk8SxA5jB3yM+VEI9t3svRAyAlTN0chthiPnRrYLxwuHLHlGa3MnpoIjelvRSGSHHp5Glmy5D61yaM74Nz0+/ndoe1KSdCh/TdvXq2d02TxzrLhqhMC3Z9Ho5Ga52A18S2hw18IPuofR1Yg4SK57OcN0OmfiH/TWt8V0EDXRCPhmIJLSP0N096vf+lGiR/kSQGrdc7wcPX0Ndbrb1Zg3EE2tCRVjOw6AdSeQvJTj5cCncJFk42TLNdQienZIT6DCeatcZ5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9yy9L+s+nggMa0cHpqzgZ2qv11i57VgdKpudk0ZPtpY=;
 b=f4WI8UpymLW+A6QJbJmN67IJzilgxcrpiCFyo/KILHstLyK6hmB3mejIYfpG8rfDJdoz+/uwE1LflBhJDPAJRE96qUTlqk6U6FM/rJOpAWEOvKP6hAV7IuZjWZJMvekl3Thh3LzEKImezOTqyR+GYF8tGNc5NopZrXxddyCZ38arwRutamrMrUtI+WsHm1aNj2JayioHIt0vzV/Pq7+NkHswwwcVqjmWnnVxBg+oNF7d8W2c+pGWlOUAJHRJuZ3RqEkEuM98dOt+CZKeNsPH8S6xUFKnETD/YVeYvBubszhe07pz6a+4wpDdyEkbVnzmLgtX7Gi7QrEtJWZySNHVfQ==
Received: from SJ0PR03CA0163.namprd03.prod.outlook.com (2603:10b6:a03:338::18)
 by DS0PR12MB6461.namprd12.prod.outlook.com (2603:10b6:8:c7::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Wed, 2 Sep
 2026 19:39:35 +0000
Received: from MWH0EPF000A6730.namprd04.prod.outlook.com
 (2603:10b6:a03:338:cafe::8d) by SJ0PR03CA0163.outlook.office365.com
 (2603:10b6:a03:338::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.10 via Frontend Transport; Wed, 2
 Sep 2026 19:39:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 MWH0EPF000A6730.mail.protection.outlook.com (10.167.249.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Wed, 2 Sep 2026 19:39:34 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 12:39:05 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 2 Sep 2026 12:39:04 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.46 via Frontend
 Transport; Wed, 2 Sep 2026 12:39:00 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Cosmin Ratiu <cratiu@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Lama
 Kayal" <lkayal@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Maor Dickman
	<maord@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net] net/mlx5: E-Switch, prevent mc_list repopulation during vport disable
Date: Wed, 2 Sep 2026 22:38:54 +0300
Message-ID: <20260902193854.3669035-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6730:EE_|DS0PR12MB6461:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c0ec54d-315a-4f28-68c3-08df0929eaae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|82310400026|36860700016|56012099006|10067099003|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info:
	njWPNbUSMwNoYawqY8SAuysfJBdyPVmu6fTIqT12PAR2UmxAFDwB86SWc3Hi/mym+ipyQ136HmDOKe57dlY+oPSCdcAv8iQ8+mJD7VFDNnPMuyS+CHgqtMdAeNXf5NBHZH2HS2n1E4wnvK9HUKwdSKORi0mX3CIg3etf+k08zIiIz5O1TWEzNatLSZOU7AhPivmDmeltyC1uSNX5omtE/UeyNeQeNipJnmx0XfkB+XnZc97lBpsicn3Am1kWbqmWJhIuYa1pYn0Ryvdk7/ZSErECIGf7IcZY0CvZRtfHqbwehSi0npK1Ao7z0/fID31rWYcWCuPPE9/Wwjn8W9zYM0J7hfEUD9OLSwbR+W83M6yyTyChrdqk2Us5oBM3rwjq/7OEtGbp/JM/W407QwEbytW7Em3BR2Ag6uBG1pfTV4L4BV7j/pOwOuXuMC836ww9J8nbm3kqFfpDAgqC7PGs9yawtXdjYbGN5QMyNB1kl0mwhMwliQJ2FAFjCWdWSUrNY/RYgJzn5G1ruiYapkTfKlBraxC178ul8+AKvQdsdFck9CI+4mi6DpxBeFewmKo9z8m5RWS7yjx1lq+WpLuYYf1jUNprYFwr+Gk4C7h7PT2Anx+zA0GhXhPVH8IHuu+Z/zj9Xx4u+JUJZuBIHYL+WYa4Xot0SmSumYxVh1GmnzwIcwv/Gc+tW6PwoLjg7X7Z
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(82310400026)(36860700016)(56012099006)(10067099003)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	fy71QtAQq7vV8KKi6R+OzWy9QudvnvFKA0BNvIixwxAuXPzfp1PeTZdKA3ojWgWp6TOeZA5MZe/9f3Qt/wRooMAlsf14CJcdv9+29ngsZe9Ji1BxP1m3EuvuxJxdONb2x/CRTQNoygFxEE9G4DPiiSuTw5tPmOA4bpb+MDwqLZxCMpi77354zYo6q2kt7TXgN31O6rg+BQDhyf1Y4O8fp9c/bGph7MVsc5f4OJA52I7xZnUmfK6K30MrvGpEGx8lzPruQLmHyWmj1VfjjGTL0xDeYqboSeE/4BJBoggHAUQ0Jp+DBt2dS0lnzQXfwOSYVXmXJU6XK5XFbXn9M9BiXt1JmXcDRMtvDMcIZoMVV1y4Sse9o24M//eUw0de2xgbIV5yzWYcDvQJNJnUy4y2XMU7A8ExZpX6ZfD8olVclBpsfxiqlf8cSgZZe+dMnaHc
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2026 19:39:34.4614
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c0ec54d-315a-4f28-68c3-08df0929eaae
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6730.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6461

From: Lama Kayal <lkayal@nvidia.com>

In mlx5_esw_vport_disable(), move esw_apply_vport_rx_mode() ahead
of esw_vport_change_handle_locked() so vport->allmulti_rule is
NULL before the change handler observes it.

During FW-fatal recovery the disable runs while dev->state ==
INTERNAL_ERROR. The promisc query inside esw_update_vport_rx_mode()
fails and returns early, leaving vport->allmulti_rule intact, so
esw_update_vport_mc_promisc() runs and adds MLX5_ACTION_ADD entries
to vport->mc_list whose flow rules are then installed in the FDB
by esw_add_mc_addr(). esw_destroy_legacy_table() tears down the
FDB with those refs still held, corrupting the sub-tree and
leaving dangling flow_rule pointers in vport->mc_list.

Two-stage failure on `echo 1 > /sys/bus/pci/devices/<bdf>/reset`:

  refcount_t: underflow; use-after-free.
   tree_put_node+0xef/0x110 [mlx5_core]
   clean_tree+0x44/0xd0 [mlx5_core] (x5)
   mlx5_fs_core_cleanup+0x57/0x1c0 [mlx5_core]
   mlx5_unload+0x65/0xd0 [mlx5_core]
   ... mlx5_health_try_recover

  BUG: unable to handle page fault for address: 0000000003000055
   down_write+0x1c/0x60
   mlx5_del_flow_rules+0x33/0x1f0 [mlx5_core]
   esw_del_mc_addr+0x7b/0x170 [mlx5_core]
   esw_apply_vport_addr_list+0x56/0xf0 [mlx5_core]
   esw_vport_change_handle_locked+0x28b/0x310 [mlx5_core]
   mlx5_esw_vport_enable+0x270/0x4a0 [mlx5_core]
   ... mlx5_load ... mlx5_health_try_recover

esw_apply_vport_rx_mode(false, false) clears vport->allmulti_rule
via its local state machine even when the FW del fails. With the
rule NULL the !IS_ERR_OR_NULL(allmulti_rule) gate in the change
handler closes, no rules are installed during disable, and the
reload starts with a clean mc_list.

Fixes: 922f56e9a795 ("net/mlx5: Fix steering rules cleanup")
Signed-off-by: Lama Kayal <lkayal@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index b6e2c153b4f7..4c7fa4a52b0e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1040,13 +1040,19 @@ void mlx5_esw_vport_disable(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
 	    (vport->info.ipsec_crypto_enabled || vport->info.ipsec_packet_enabled))
 		esw->enabled_ipsec_vf_count--;
 
+	/* Clear rx-mode before esw_vport_change_handle_locked(): on
+	 * MLX5_VPORT_PROMISC_CHANGE it calls esw_update_vport_mc_promisc()
+	 * when vport->allmulti_rule is set, repopulating mc_list with FDB
+	 * rules that dangle once the FDB is destroyed. NULL allmulti_rule
+	 * here skips that path.
+	 */
+	esw_apply_vport_rx_mode(esw, vport, false, false);
 	/* We don't assume VFs will cleanup after themselves.
 	 * Calling vport change handler while vport is disabled will cleanup
 	 * the vport resources.
 	 */
 	esw_vport_change_handle_locked(vport);
 	vport->enabled_events = 0;
-	esw_apply_vport_rx_mode(esw, vport, false, false);
 	esw_vport_cleanup(esw, vport);
 	esw->enabled_vports--;
 
-- 
2.44.0

