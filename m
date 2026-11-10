Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.0
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794304499;
	b=HoGA6zsAdnz2YVK0bt77qU/mo/gW/XTBSZqCB5nCC+7xyjZHvqFWp700YeiocCmXxSUQ
	 GdesNVy/Lgjl1xdAwdMTM5rOcdCE+Bzb+hY+dr3P8njx2pNYVdqHP2HFjYWk1holtxL3U
	 Tcnh7DTOfUaxWQOJpMqH/zNusBCvEfeVP3IMU5PKqOWBHCu4vtWyZ2JjYcaV+SnE3lQVZ
	 QCUU7mY9GT56weLlSqGnzo0gFtOPPV4D5Zu4NGM3EjPluDVfafLKHzP+hAyyPBEHwrF0M
	 wVKEVHvdtZQIuVJNl7zDK33miwOS5PBKStfh5gzNJion5mC3O3TGEfbbNfHfosH4cDA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794304499;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Originating-IP:X-ClientProxiedBy:X-EOPAttributedMessage:
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
	bh=qD+lu3ycm76ZA8T3eI/x2TXXDrqDCJSntEr86m6dx1w=;
	b=bELSyCailkfzBkmCwB0JbwfswdFigqVtipHhuXl9kLSSXeZCPyWnn4NyipcjRvn2Z2Mq
	 pMeziggGxGAZfJAB8x4ICOxhVQNDwmJfI7pPff79p1jl4yS5rSM7b/emwwx3xzBsZyM8V
	 bDnp2rBtIEgzX2SdSTlb018CjmAY+EuXlLH275F29+Wr9PKtXotIMwHIBZDw6zO6L79+G
	 zxeiVBIuibK5hX8tXip1ZC+MLN1Am9joZ/YSFvdTdGxX7azbP2NjYDtN2bOAq+BvAoAwB
	 vm/wU1W3V3hbIkLg4pLDiiBPfVd5Ndr1xo/S4uh+ShO830XrAepZqYGwMXP0Ntd0XOw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ckeO5CbY;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.0
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012000.outbound.protection.outlook.com [40.93.195.0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712B4606A321;
	Tue, 10 Nov 2026 09:54:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 712B4606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ckeO5CbY
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xA4CtBZCDoYjOTGBMhnMvycyYo6HxOPDFA2NVlo4Kk1aSJKWE8ryPyjN2Xgq2buo8qIlGjUP6BCdi9jXMZRJpuJh2Wg9RBSNZjSC/hD5/pn0EPUQfoo9fdUq6M5mNYuLq+OajSvl10NcUJWFLcR33VESXNKBbVeJk/NbFDb27JaoztnSZkFlVI6q4kkOczGaRdZ2PapC+s/HyBqf58d8DdWw2tfTRmRtMeZhh6NDJYZsOUA4GDa5evMLprwdwCNpUdhdFTR1Yu2kSk0KjetVjV/vICwzHJX7h0xKCkjLtwsaXsgarppRj+8acDQCuKfTi1+YSK0W5Ngu5xSOXdi88A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qD+lu3ycm76ZA8T3eI/x2TXXDrqDCJSntEr86m6dx1w=;
 b=leTQiNjjeZqiW/KovCUhXdts3L9k4j1aM9u+rUMFv6svQj7Gf1PyXuRNs35a4ELl6BSuuqz+ScYF58tmVBZfpWFYHA3yE4ycjVANmepf04MA51dZYbuqQK2+K31xpiETGsbWWVIP0AECwPWHqpB6ClayGWvsPPj+GhSDNF83tPyOhWXDP3olbWOddM78KeDlqD2jX/Mdcf4i4IhD/zQs4l/MM5Fh5cdNc2RtRKfpCzckn70Q2fxPBswzON+tfOssbaW6DJ6mR3a+wOSSBRqKj3jFS/KTZ33Z1KUiI/Chp+kvL0BX7uVNqQitz8dWKNOjSm/LNQPHr5NHv50wRk5GJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qD+lu3ycm76ZA8T3eI/x2TXXDrqDCJSntEr86m6dx1w=;
 b=ckeO5CbYRMEwQ/O2qZlUgoCTjoDYyOgSdAZB9Y7LodmM+4owBwvhryKLh1Hu6op1Qc+LwgbAEn8haE1Rlm69bGAlhfZfDyGDD5bjbddpU599vhlmBz/IjVMVkZKAhGhNJd2KrrhKBEZ+8YL1l0PkHxq9S0KcredTpRE075yDQOaZlAMU+C9LeUfhEqy6ZkZELb9zaoc58PIuewzjjU83PK7/Au4+YUFcNP7dTZE90xe7wPmqH1vMT3vr8qzweBrs9vQibVlEmxzrzbkH+m7FHJ2Sio6SyLJ9eBgGj4Dcol90kRl9ko1UbsS96hzKauEww3sLaEzE3xZeuMeIFEV7eg==
Received: from DS1P222CA0009.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:454::15) by
 IA0PR12MB9047.namprd12.prod.outlook.com (2603:10b6:208:402::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.8; Tue, 10 Nov 2026 09:54:54 +0000
Received: from DM3PEPF000265C1.namprd03.prod.outlook.com
 (2603:10b6:8:454:cafe::3) by DS1P222CA0009.outlook.office365.com
 (2603:10b6:8:454::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Tue, 10
 Nov 2026 09:54:54 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM3PEPF000265C1.mail.protection.outlook.com (10.167.23.182) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 09:54:54 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 01:54:39 -0800
Received: from nps-server-23.mtl.nbulabs.nvidia.com (10.126.230.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 10 Nov 2026 01:54:33 -0800
From: Shay Drory <shayd@nvidia.com>
To: <tariqt@nvidia.com>
CC: <andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@kernel.org>,
	<kuba@kernel.org>, <netdev@vger.kernel.org>, <pabeni@redhat.com>,
	<agoldberger@nvidia.com>, <cjubran@nvidia.com>, <cratiu@nvidia.com>,
	<edwards@nvidia.com>, <gal@nvidia.com>, <leon@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
	<mbloch@nvidia.com>, <moshe@nvidia.com>, <ohartoov@nvidia.com>,
	<phaddad@nvidia.com>, <saeedm@nvidia.com>
Subject: Re: [PATCH net-next 14/15] net/mlx5e: Register eswitch-manager VF/SF self-port with switch-id
Date: Tue, 10 Nov 2026 11:54:25 +0200
Message-ID: <20261110095425.380215-1-shayd@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20261103171009.563034-15-tariqt@nvidia.com>
References: <20261103171009.563034-1-tariqt@nvidia.com> <20261103171009.563034-15-tariqt@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PEPF000265C1:EE_|IA0PR12MB9047:EE_
X-MS-Office365-Filtering-Correlation-Id: f1ed0833-15a7-46f5-59bc-08df3f10abba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|23010399003|376014|1800799024|4143699003|5023799004|11063799006|56012099006|22082099003|18002099003|6133799003|10067099003|261102123227099003|261022113327099003|261022105027099003|261022075727099003|261021135927099003|261021133027099003|261021130227099003|261021123027099003|261021121427099003|261022115727099003|261028144727099003|261026140227099003|261026130827099003|261026121527099003|261026135527099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	6JISZ2Q2k6OW3S+MftY08iH1yF6ef052wiXzXHW+833k1LUNFD9Do7N+W7AS+s7wuZ65IsX01n9qJCyYQfbVyPTzyoqfL2EqlSydG6Mh+zUcXEL+pcEEmt/1Bi+OzJPE1fyaREf1iwH9qXp5n1VaBkKFCz18myaXzP70SOaejqOUE6rGhzK1/HPpNbTtS1Xy3Rm2t1QmTLCxvxaRaOch55SmBqcXRQRUFdxzYzaBpj4fp4VxbnOhab5JFyhd+4p7876mXUnS5mnEJi+Hm0ZvLMBtyKMuEiLfH03MZczIRYG4l6ekctDeA4wl27wVna21lz7rNjNocUfh4H7Pwefi3dhBN4yVwAhp++59Y+0b5F8MzC6o2s1CYz11BA64L1RLdz9+olUvvd+xHvVfGG8Y7pkT/VySnU+6cUDvjay965Dik2rh0WA4UAloppBjRVis83DjibUYDwiWolIURxMCkO5TPJbixQDNAcgJ/nMgc52gYDIIOyuLCivAfQRkoG+4wxJToVYO0x8AIKeCNng1XhCMDiiw8TsmVJsGhnEB+kMPYxTewcYYOeJCRZhM1BYQvAT4smwPyLRol+m/8ufaOWWfT8Aq9mapD/vGOqaMzJ4W56XDfN8zbP7svX8S7SfJW+qzQfMUqrQq+cA3U9MjJqFw7DspdYfIRNE+xHI1osgH+C3QtHmMmhP8/zPbPIdtFLNjVN3TFeNchWdxjAMIpg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(23010399003)(376014)(1800799024)(4143699003)(5023799004)(11063799006)(56012099006)(22082099003)(18002099003)(6133799003)(10067099003)(261102123227099003)(261022113327099003)(261022105027099003)(261022075727099003)(261021135927099003)(261021133027099003)(261021130227099003)(261021123027099003)(261021121427099003)(261022115727099003)(261028144727099003)(261026140227099003)(261026130827099003)(261026121527099003)(261026135527099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	xAPgEVn7Cm3P+WSHkz22yVPLbjn3sKVFJ0qBg85DQr3pqq/Z5d6OTTI3rhNVYTyE+5xwJpPQq0ube/vmt7GbSaWUkBAqNX0KxJD8m2lOeNwYStOYRqE0JYycM5vEqSX+GXOeHWS82ZecqObRMV4hdLK+5LrH3SCnkRXCdin1XZ33L3n/K1KOidngBAKguIUHfuyVwteZFueijsbE5Z2Cyp+u9tEtOK1q9eZKrkpNN6nBn5MbEhTe4kZfUPY/CAov3VzD9MBi9EUwnxI+zj685hiv3EgGK2ZguvEny0DKEsfrtYwkHufvq2GX/3VYOpwurz7BCsF1xRAq6zXIDc2I7MIfs0v+vvO26k2Bxryosa/aTCU9x8z3a3dFDuMdHOVOu5uRlIkLVxwfM/q53aDOoVTq9wRJyny8Rx7wDW+qJTKETAoGqECTQqtpYk0z+okG
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 09:54:54.1679
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f1ed0833-15a7-46f5-59bc-08df3f10abba
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM3PEPF000265C1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB9047

On 03/11/2026 19:10, Tariq Toukan wrote:
> From: Shay Drory <shayd@nvidia.com>
>
> A non-PF function's self-port (its own uplink netdev) was always
> registered with DEVLINK_PORT_FLAVOUR_VIRTUAL, which doesn't carries
> switch_id. Consequently a function that acts as an eswitch manager - a
> VF (or SF) running its own nested eswitch - exposed no phys_switch_id on
> its uplink netdev, so it could not be grouped with the representors it
> manages.
>
> When the function is an eswitch manager, register its self-port with the
> switch_id taken from the system image guid. The uplink netdev is already
> bound to this devlink port, so phys_switch_id is derived by the core,
> and the managed representors - which stamp the same switch_id - group
> with it.
>
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
> index 8818f65d1fbc..79adb1ecc450 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
> @@ -63,6 +63,11 @@ int mlx5e_devlink_port_register(struct mlx5e_dev *mlx5e_dev,
>  		dl_port_index = mlx5_esw_vport_to_devlink_port_index(mdev,
>  								     MLX5_VPORT_UPLINK);
>  	} else {
> +		if (MLX5_ESWITCH_MANAGER(mdev)) {
> +			mlx5e_devlink_get_port_parent_id(mdev, &ppid);
> +			memcpy(attrs.switch_id.id, ppid.id, ppid.id_len);
> +			attrs.switch_id.id_len = ppid.id_len;
> +		}

answers to net-dev sashiko

Sashiko (Medium):
Can this give the VF/SF uplink netdev the same phys_switch_id as its
parent PF's switch?
The only condition here is MLX5_ESWITCH_MANAGER(mdev). However,
mlx5_query_nic_sw_system_image_guid() makes a VF/SF id differ from the
PF's only when virt-LAG is supported:
drivers/net/ethernet/mellanox/mlx5/core/vport.c:
static u8 mlx5_sw_guid_vf(const struct mlx5_core_dev *mdev)
{
    return mlx5_core_is_vf(mdev) && mlx5_virt_lag_is_supported(mdev);
}
It also trims zero discriminator bytes from the result:
    for (i = 0; i < ARRAY_SIZE(mlx5_sw_guid_fields); i++) {
        u8 val = mlx5_sw_guid_fields[i](mdev);
        buf[(*len)++] = val;
        if (val)
            trim_len = *len;
    }
    *len = trim_len;
mlx5_virt_lag_is_supported() needs multi_uplink_eswitch, lag_master and
num_lag_ports < 2. mlx5_eswitch_init() creates an eswitch for any
function with MLX5_VPORT_MANAGER or MLX5_ESWITCH_MANAGER and does not
check those caps.
Take a VF/SF eswitch manager without the virt-LAG caps, for example a VF
that reports num_lag_ports >= 2. Would its uplink netdev now report the
plain FW system image GUID? That is the same switch_id that the parent
PF's uplink and representors use.
This also seems to affect TC offload on the PF side. tc_act_parse_mirred()
in en/tc/act/mirred.c calls parse_mirred() only when:
    else if (netdev_port_same_parent_id(priv->netdev, out_dev))
        err = parse_mirred(parse_state, act, priv, attr);
Before this patch, that check always failed for the VF/SF self netdev,
because the port had no switch_id.
Suppose the VF's nested eswitch is in switchdev mode in the same host as
the PF reps. A mirred redirect from a PF rep to the VF uplink would now
reach mlx5e_is_valid_eswitch_fwd_dev(). There,
same_hw_reps()->mlx5_same_hw_devs() compares the same identical sw GUIDs.
If the PF is in LAG (is_lag_dev()) or MPESW (is_multiport_eligible()),
the forward is accepted.
parse_mirred() would then program a PF FDB destination with:
    esw_attr->dests[esw_attr->out_count].vport = rpriv->rep->vport;
    esw_attr->dests[esw_attr->out_count].mdev = out_priv->mdev;
That destination is MLX5_VPORT_UPLINK of the VF's mdev, which belongs to
a different, nested eswitch. Is that intended?
The nested eswitch representors already used this colliding id before
this patch, through mlx5_esw_get_port_parent_id() in esw/devlink_port.c.
This patch extends the collision to the self/uplink netdev.
The earlier change "net/mlx5: Distinguish VFs/SFs in the SW system image
GUID for LAG grouping" kept the PF key for non virt-LAG VFs/SFs on
purpose, so they still count as the same HW in mlx5_same_hw_devs(). That
reasoning does not seem to cover publishing the key as a switch identity.
The later patches in this series do not appear to change en/devlink.c,
vport.c, lag.h or esw/devlink_port.c.
The driver code alone can't tell us whether firmware ever grants
eswitch_manager to a VF/SF without the virt-LAG caps. Nothing in the
driver seems to rule it out, though.
Should this branch set the switch_id only when the resulting GUID differs
from the PF's?

[SD] A VF/SF eswitch manager without the virt LAG caps doesn't exist. New
FW will let a VF/SF be an eswitch manager only as a nested eswitch
manager, and such a function reports multi_uplink_eswitch, lag_master and
num_lag_ports < 2, so mlx5_query_nic_sw_system_image_guid() gives it the
VF/SF marker and its switch_id differs from its PF's.

>  		attrs.flavour = DEVLINK_PORT_FLAVOUR_VIRTUAL;
>  		dl_port_index = mlx5_esw_vport_to_devlink_port_index(mdev, 0);
>  	}
