Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013064.outbound.protection.outlook.com [40.93.201.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953C9493632;
	Wed, 23 Sep 2026 10:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790160031; cv=fail; b=l0ytx1xo0k9Q22SuhphL/aboSfAy0s+9DYUsyKSgM+13EFdm/8g4mq0no4pgQJOEmfv4IKz2mI/Sn6T+ppYAr7LYRzdo8hKaG9v1hgeQKgB3OHW/jsvuWJPjP5BIxrbf4gTdoajRwyXxwSAXuf4Y+TM/0C4YCtO7biXgT2eo4io=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790160031; c=relaxed/simple;
	bh=8FyR5c7nnd+QrgQYQOdAN9c/imZH09FU84EeTraz/uY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MdweZ4Qj+sDA4BIsaqMtOzrpGVyKELNdw92OKy42HnHE0lBqnM2IvogRCV+uK1ZRRXNnf1TphgkSDducWXjI+vt5rjpm2kBtON6qV3COS1uGkG4LFNWBeRFSeJr8a40F+R+dCILlClCvvOPJpLY8kAM0kI895EWH/Qj9MHmWpE4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BkY5CaYe; arc=fail smtp.client-ip=40.93.201.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BkY5CaYe"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lj2Os3GOB9bJboOKIBwX7/YhH54e8OZU1V5X7vldwzwHhknEYoq2ntRYXKDQT+57l7EDXt6uCx0ytsDNLXgBKhCyWg4SgxvkpqbLNMeSr9ueCXzNrfZMwjnouvrxfi3UHEZI42TMTQ/4kWMWF5njYZZ0td3VB7u6nYFWg14EGuo75mJOOLsPKVcwia4LnzzRLYvm16nIK+x08BtA7voBaoOAPDDdzH/pD8f5fjueC4yUPznlol773cIry1OxcRbO4qeo/9qJVFpS60Ss8kgCcDHkf0lv8UdbVaCU49SbKzLWJJYiDBRRqZHZFwAiv0RNLrhZngQ0GZzmXwIF56IKPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+gqv7When62TYC31i1HCr0uxJKkqDy/9I7Kd2tka0Kw=;
 b=WS2XAKGCs+t7vsH+8uUKSKuZZi8czYGIrOeNECgytk8ncP2E8NivTzmTPDJ2pQ9Hf1WPXEls88QU1cF6llKbdZ8D0jHnNCT3m7agdB4vnr7HwVNESD+bK20TvSd+D6hwm2957CkGVNfDKgdVwg0JHFosGXefxSFX4OoQmn4oBIREog3t748xnaA1VChbssR2D1a3rnGx8MTys8abOIgr4vg+8g+BY+xy1FPHaSaDPnd8W+g0Gwqe8/h0ZjoR2BRcWPZrk8eQYJWD9FzFxc8F4CLiBo2lOlxbvdy+PxDfrXh5D5ZqnaVGq5rWEukffKgopCNb9UThsLU81NBhjDB8Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+gqv7When62TYC31i1HCr0uxJKkqDy/9I7Kd2tka0Kw=;
 b=BkY5CaYedH5tqf8knDYwCeolhWrDwrwWYLzX4GoODHca/Lfe4Cxta/GJ5NIuCozYxTr3VdcCF6bKBB2GQWxBluyKUMeBgVaFpug7neZumsz9z/Z6owM3VRfWCgnPelGa0a7Kydyoasi2jh8PsCbIRe8SfnjTmSG3/8mIlPgq8ZeRW+epAGzh2HjAhEwjHYulQPaUCNr0tvINVjR2/7XOutrjdRUGI283PNTwZ2BlfNqn0yqYXLZm0Qrexsom8ymQ7BmM5+aBSxAU4tKDaV8e/L/RJ4bzccIqCWYEBi0bfbjtFWeqxE+RT8E7WsHeluHQo3u5uRT2dqac2HVq0vio5A==
Received: from BN0PR03CA0023.namprd03.prod.outlook.com (2603:10b6:408:e6::28)
 by CY1PR12MB9697.namprd12.prod.outlook.com (2603:10b6:930:107::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.16; Wed, 23 Sep
 2026 10:40:11 +0000
Received: from BN3PEPF00022BC3.namprd05.prod.outlook.com
 (2603:10b6:408:e6:cafe::15) by BN0PR03CA0023.outlook.office365.com
 (2603:10b6:408:e6::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.17 via Frontend Transport; Wed,
 23 Sep 2026 10:40:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN3PEPF00022BC3.mail.protection.outlook.com (10.167.248.215) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Wed, 23 Sep 2026 10:40:10 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 23 Sep
 2026 03:39:54 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 23 Sep
 2026 03:39:53 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Wed, 23
 Sep 2026 03:39:49 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Cosmin Ratiu
	<cratiu@nvidia.com>, Gal Pressman <gal@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shay Drory <shayd@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net-next 00/13] net/mlx5: Preparations for nested E-switch
Date: Wed, 23 Sep 2026 13:38:17 +0300
Message-ID: <20260923103830.1183-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BC3:EE_|CY1PR12MB9697:EE_
X-MS-Office365-Filtering-Correlation-Id: 497d672f-cfc9-42da-5320-08df195f0b1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|82310400026|36860700016|376014|10067099003|11063799006|56012099006|6133799003|18002099003;
X-Microsoft-Antispam-Message-Info:
	VdsPq0H39UvFJgcP26Bffg0Db04vnMeypmBphs0YUpZmYNa1Y5gXWWjZH/oV8Z1stNDntPipMSW2lmrRlH6S10KlWHfd1GRwoocMJhs0I8btf+8D+ANdcUP6kbrQBqsrdPICs+ICvT7g1XrIjc5wzjAh4Tb6yb8sQSMJNrtqP8cY+DQEdWlIlhLTdd78S2El/mEjRDyTK6onQKi6VOCLWAuXFf6RnCILz6t2z4ly377xb7es8ufgw32d7qRGP0tyOWGEZm3VHbkUc1OOJ3TA+FNtPTA1hW9E7zm4BkHqtk8lxGSbn1dly/gKrX6J/wb7VwUVnPqZyFeIOrI8ByomabiIEjiOe4iChKUSrswwIYqHXTUdIarRzs4RXKtB2jaumCuUyO8ctsjMuB6HHYCctMdae6D3i9sa6/Zc/kABjT9l/bQPYZw+I66tp8pjRKaSEB4Oby1zqltaHTQdwkznwlM3aoktqFxdDYSLZxEYAAwrsfjPTPqeICzpOIOVeuSRvezqdQRlbC41Nq2kuTG97UcZUN0ipqONXtvvXPydPANZ7WgkmWniSuchSPSj4B8H7QVU9olCYw7QBp8SW471lY0t5+ObpxHGUpola/k2TdDz6XgtiJA+A/WS9hb1DnWqNqGoa6gBNcvBaSY72P4Hcw3BxeQFfTAK/kSoZ/V+HKZHGRX+1j/V218qlNA5kIX3Ch8foc+EjM18pBHzaIQwnA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(82310400026)(36860700016)(376014)(10067099003)(11063799006)(56012099006)(6133799003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	qWqJ4lvW/H4kleM5BoqlKjNDqALewGpgYEcfb1Ems2PlawFTe1u3OKKNPw/OShJuSrRdQtv6dfb5/ERdFPLAjFA4W4YrVIvLYJgylnWPMAhVHmD/YwrVvK/YxDXdCEMmJQvaCjG1AUsMM9vzDBqXTFM44nHb6/7X/p3+hD8OC/q91rPYr3aIJZVj8ZdMBCZBhcUmZfKRJOZTkCCM6wHn8EntwVzbjx7rzBFoZspLCbV07b/X+WBdzoHPF37Fra5d5Ytu8lXraBpvdA9Kmk/TN6pRasHPsXwduHPR6Rsu5FfSGRUKPKKBtebNa4z+Cuhb/JLavkgUYSpyPcK0jXM6ugFDMHu6rYjFqkicecXXl3k8+wahMgWB/8qFOuYHmEJyhBG9s/YUu7v4fPiWMdpInCGr2WvpfTXxA9b8DU7L8xvX0qZsh6ibkyv5H0eACaQi
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2026 10:40:10.7031
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 497d672f-cfc9-42da-5320-08df195f0b1b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BC3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR12MB9697

Hi,

This series by Shay has two intertwined goals. The first is to remove
the compile-time MLX5_MAX_PORTS sizing from the LAG and eswitch/TC
datapaths so that structures scale with the actual number of ports/peers
rather than a fixed maximum. The second is a set of small,
self-contained fixes that prepare the eswitch and LAG code for a VF/SF
acting as a nested e-switch manager - a mode new FW will allow, where a
VF/SF has its own eswitch and the VFs/SFs can be grouped by MPESW.

No functional change is intended for existing configurations.

General fixes, patches 1-2
  - assign a random MAC to any netdev with a zero MAC address, dropping
    the vport-group-manager exception that left a manager with an
    invalid all-zero address.
  - do not leave an unpaired devcom component registered when the
    initial PAIR event fails.

LAG - drop MLX5_MAX_PORTS-sized storage, patches 3-6
  - allocate v2p_map dynamically: the fixed MLX5_MAX_PORTS *
    MLX5_LAG_MAX_HASH_BUCKETS array embedded in struct mlx5_lag becomes
    a pointer sized by ldev->ports.
  - allocate the port-indexed scratch buffers in print_mapping() and
    infer_tx_affinity_mapping() with kcalloc(ldev->ports, ...).
  - drop the per-port scratch arrays in drop-rule setup by walking the
    tracker state inline.
  - size the mapping debugfs buffer by the actual port count.

E-switch/TC peer flows - lift the MLX5_MAX_PORTS peer cap, patches 7-8
  - anchor the peer-flow reverse index on the duplicated flow (a single
    node) instead of a per-peer array on the origin flow.
  - replace the fixed peer_flows[] array with an xarray keyed by peer
    vhca_id, so the number of peers is bounded only by distinct vhca_ids
    rather than MLX5_MAX_PORTS.

Nested e-switch manager / LAG-of-VFs preparation, patches 9-13
  - derive the e-switch manager vport from esw_manager_vport_number
    instead of hardcoding ECPF/host-PF, so the manager vport can be a
    VF.
  - don't print the LAG virtual-to-physical port mapping to debugfs in
    MPESW mode, where the LAG does not own that mapping.
  - drop the stale esw_shared_ingress_acl gate from the shared-FDB
    check.
  - reword the mlx5_esw_allowed() comments to describe the actual
    condition (not an e-switch manager), since a nested-eswitch VF
    passes that check.
  - disable host functions for a non-PF e-switch manager.

Regards,
Tariq

---

Answers to internal sashiko comments:

commit cd4c9a171200573172eac1ad28feb11543a64f1c
Author: Shay Drory <shayd@nvidia.com>
net/mlx5: E-switch, do not leave an unpaired devcom registered

If the initial PAIR event fails, the eswitch offloads devcom component
stays registered until eswitch teardown even though no peer was ever
paired. devcom is optional, so this is not a functional bug - but a
registered component that reflects no actual pairing is incorrect state
to keep around. Release it when the initial pairing fails.
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> index 907ee83a722d..955ca6e9c7cf 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
[ ... ]
> @@ -3568,10 +3569,12 @@ void mlx5_esw_offloads_devcom_init(struct mlx5_eswitch *esw,
>  	if (!esw->devcom)
>  		return;
>
> -	mlx5_devcom_send_event(esw->devcom,
> -			       ESW_OFFLOADS_DEVCOM_PAIR,
> -			       ESW_OFFLOADS_DEVCOM_UNPAIR,
> -			       esw);
> +	err = mlx5_devcom_send_event(esw->devcom,
> +				     ESW_OFFLOADS_DEVCOM_PAIR,
> +				     ESW_OFFLOADS_DEVCOM_UNPAIR,
> +				     esw);
> +	if (err)
> +		mlx5_esw_offloads_devcom_cleanup(esw);
Does this code introduce a potential NULL pointer dereference in
mlx5e_tc_query_route_vport()?
If the initial pairing fails and we call mlx5_esw_offloads_devcom_cleanup(),
esw->devcom is set to NULL while the device continues to operate. Later, when
TC queries the route vport, mlx5e_tc_query_route_vport() calls:
drivers/net/ethernet/mellanox/mlx5/core/en_tc.c:mlx5e_tc_query_route_vport() {
    ...
    mlx5_devcom_for_each_peer_entry_rcu(esw->devcom, esw, pos) {
    ...
}
This macro unconditionally passes esw->devcom to
mlx5_devcom_get_next_peer_data_rcu(), which dereferences devcom->comp:
drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c:mlx5_devcom_get_next_peer_data_rcu() {
    struct mlx5_devcom_comp *comp = devcom->comp;
    ...
}
Could this cause a panic when processing traffic on the active path?

[SD] no, this mlx5_devcom_for_each_peer_entry_rcu() is protected by lag_is_active. and LAG can be active only if devcom is alive.

commit d891405a6936cb189f66ab2b70a5f8cfc042235e
Author: Shay Drory <shayd@nvidia.com>
net/mlx5: LAG, allocate v2p_map dynamically

This commit converts the fixed-size v2p_map array in struct mlx5_lag to a
dynamically allocated pointer based on the actual port count. It also makes
a similar conversion for the scratch buffer in mlx5_modify_lag() to remove
the dependency on MLX5_MAX_PORTS.
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> index 28d16fdc3f06..3af484fd924b 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> @@ -328,11 +329,16 @@ static struct mlx5_lag *mlx5_lag_dev_alloc(struct mlx5_core_dev *dev)
>  	if (!ldev)
>  		return NULL;
>
> +	ldev->ports = MLX5_CAP_GEN(dev, num_lag_ports);
> +	ldev->buckets = 1;
> +	ldev->v2p_map = kcalloc(ldev->ports * MLX5_LAG_MAX_HASH_BUCKETS,
> +				sizeof(*ldev->v2p_map), GFP_KERNEL);
Could this allocation be too small when Socket Direct (SD) is enabled?
When iterating with mlx5_ldev_for_each(), the index i comes from the sparse
xarray ldev->pfs. With SD enabled, primary and secondary devices are
interleaved, which means i can exceed ldev->ports - 1.
For example, on a 4-port device, the fourth primary device might get an
index of 6. Would sizing this buffer strictly to ldev->ports result in
out-of-bounds accesses during iteration?

[SD] LAG of devices that support SD don't use v2p_map, so the failure above cannot happens.

commit d9d5074e46326236672c6cf3d7fea9d8d6680a60
Author: Shay Drory <shayd@nvidia.com>
net/mlx5: LAG, allocate port-indexed scratch buffers dynamically

The commit dynamically allocates per-port scratch buffers in
mlx5_lag_print_mapping() and mlx5_infer_tx_affinity_mapping() using kcalloc()
instead of relying on fixed-size stack arrays bounded by MLX5_MAX_PORTS.
This removes the dependency on MLX5_MAX_PORTS for these buffers.

> @@ -699,10 +712,18 @@ static void mlx5_infer_tx_affinity_mapping(struct lag_tracker *tracker,
>  		}
>  	}
>
> +	mlx5_ldev_for_each(i, 0, ldev) {
> +		if (tracker->netdev_state[i].tx_enabled &&
> +		    tracker->netdev_state[i].link_up)
> +			enabled[enabled_ports_num++] = i;
> +		else
> +			disabled[disabled_ports_num++] = i;
> +	}
> +
Can this write out-of-bounds of the newly allocated arrays?

[SD] no, LAG of devices that support SD can only be MPESW, so this code is not reachable.

    net/mlx5: LAG, drop per-port scratch arrays in active-port and drop-rule setup

    lag_active_port_bits() and mlx5_lag_drop_rule_setup() each only walk the
    per-port tracker state, but did so through a per-port scratch array:
    lag_active_port_bits() collected the enabled ports to fold into a bitmask,
    and mlx5_lag_drop_rule_setup() collected the disabled ports to create a
    per-port drop rule.

    Walk the tracker state inline in both - the enabled ports
    (tx_enabled && link_up), or the disabled ones - so neither needs a scratch
    array, removing their MLX5_MAX_PORTS dependency.
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> index de515fe3b57a..806c09b2d080 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
[ ... ]
While reviewing this patch series' transition from xarrays to static arrays,
I noticed a regression in the related TC code.
drivers/net/ethernet/mellanox/mlx5/core/en_tc.c:mlx5e_tc_add_fdb_peer_flow() {
    ...
	int i = mlx5_lag_get_dev_seq(peer_esw->dev);
    ...
	mutex_lock(&esw->offloads.peer_mutex);
	list_add_tail(&flow->peer[i], &esw->offloads.peer_flows[i]);
	set_bit(i, flow->peer_used);
	mutex_unlock(&esw->offloads.peer_mutex);
    ...
}
If mlx5_lag_get_dev_seq() returns -ENOENT (-2), i is used directly as an
array index. This causes out-of-bounds access during list and bit operations
like list_add_tail() and set_bit().
This can occur when adding a TC rule via mlx5e_tc_add_fdb_flow(), which loops
over devcom peer entries for ESW_OFFLOADS and calls this function. A device
can be paired in ESW_OFFLOADS while not being part of a LAG, or before the LAG
master is elected, causing mlx5_lag_get_dev_seq() to return -ENOENT.
Does this code overflow flow->peer[] and esw->offloads.peer_flows[] under
these conditions?

[SD] this code is run under is_peer_flow_needed, which is true only if LAG is active.
Hence, i always returns valid value.

net/mlx5: LAG, size debugfs buffers by port count

This commit modifies the debugfs mapping_show() function to dynamically
allocate the ports array based on the actual number of ports, rather than
using the constant MLX5_MAX_PORTS.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c
> index e9b8d79d2d21..44296789d656 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c
> @@ -101,14 +101,18 @@ static int mapping_show(struct seq_file *file, void *priv)
>  static int mapping_show(struct seq_file *file, void *priv)
>  {
>  	struct mlx5_core_dev *dev = file->private;
> -	u8 ports[MLX5_MAX_PORTS] = {};
>  	struct mlx5_lag *ldev;
>  	bool hash = false;
>  	bool lag_active;
>  	int i, idx = 0;
>  	int num_ports;
> +	u8 *ports;
>
>  	ldev = mlx5_lag_dev(dev);
> +	ports = kcalloc(ldev->ports, sizeof(*ports), GFP_KERNEL);
> +	if (!ports)
> +		return -ENOMEM;
> +
Does this code overflow the newly allocated ports array?
In this function, the array is populated either by mlx5_infer_tx_enabled()
or a direct loop:
	mlx5_ldev_for_each(i, 0, ldev)
		ports[idx++] = ldev->v2p_map[i];
Since mlx5_ldev_for_each() iterates over an xarray whose capacity might
allow more elements than ldev->ports, idx could exceed the allocated size.
The same applies to mlx5_infer_tx_enabled(), which writes to
ports[(*num_enabled)++] = i. If the number of active primary devices exceeds
ldev->ports, won't this write past the end of the buffer?

[SD] number of active primary devices can never exceeds ldev->ports

net/mlx5e: TC, track peer flows in a vhca_id xarray

The per-peer reverse index lived in a fixed esw->offloads.peer_flows[]
array of list heads indexed by the peer's LAG sequence number, capping a
shared FDB at MLX5_MAX_PORTS members.

commit 5fe510c74051ae4d7a1240882d23a3bbd0d738a5
Author: Shay Drory <shayd@nvidia.com>

net/mlx5: LAG, don't print port mapping to debugfs in MPESW mode

This commit treats MPESW mode as if LAG is inactive. It stops printing
the LAG virtual-to-physical port mapping to debugfs since port selection
is driven by user steering rules in this mode.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c
> index 44296789d656..dd93abc90c14 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c
> @@ -109,12 +109,14 @@ static int mapping_show(struct seq_file *file, void *priv)
>  	u8 *ports;
>
>  	ldev = mlx5_lag_dev(dev);
> +
>  	ports = kcalloc(ldev->ports, sizeof(*ports), GFP_KERNEL);
This isn't a bug introduced by this patch, but while reviewing the LAG code
related to ldev->ports, I noticed a potential NULL pointer dereference in
mlx5_lag_query_cong_counters() in
drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c.
If a LAG device is removed (e.g., dynamically unbinding a PF from the bond
interface), mlx5_lag_remove_mdev() removes the device from the LAG's
internal xarray asynchronously to the actual LAG state deactivation.
During this window, __mlx5_lag_is_active() still returns true, but
mlx5_ldev_for_each() populates fewer than ldev->ports devices into the
mdev array:

[SD] when mlx5_lag_remove_mdev() is called, the LAG is already destroied.
so the race don't exists.

Shay Drory (13):
  net/mlx5e: Assign a random MAC to any netdev with a zero MAC address
  net/mlx5: E-switch, do not leave an unpaired devcom registered
  net/mlx5: LAG, allocate v2p_map dynamically
  net/mlx5: LAG, allocate port-indexed scratch buffers dynamically
  net/mlx5: LAG, drop per-port scratch array in drop-rule setup
  net/mlx5: LAG, size debugfs buffers by port count
  net/mlx5e: TC, anchor peer-flow reverse index on the duplicated flow
  net/mlx5e: TC, track peer flows in a vhca_id xarray
  net/mlx5: E-switch, derive manager vport from device capability
  net/mlx5: LAG, don't print port mapping to debugfs in MPESW mode
  net/mlx5: LAG, drop stale esw_shared_ingress_acl gate from shared FDB
  net/mlx5: E-switch, correct stale VF/PF wording in esw-allowed
    comments
  net/mlx5: E-switch, disable host functions for a non PF e-switch
    manager

 .../ethernet/mellanox/mlx5/core/en/tc_priv.h  |  14 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   3 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  75 ++++-----
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  20 ++-
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   2 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     |  37 ++++-
 .../ethernet/mellanox/mlx5/core/lag/debugfs.c |  14 +-
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 154 +++++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/lag/lag.h |   2 +-
 .../mellanox/mlx5/core/lag/shared_fdb.c       |   3 +-
 include/linux/mlx5/eswitch.h                  |   3 +
 11 files changed, 215 insertions(+), 112 deletions(-)


base-commit: 944ae66642b726bd6b25ae71b1e9ff88a0e0bdb0
-- 
2.44.0

