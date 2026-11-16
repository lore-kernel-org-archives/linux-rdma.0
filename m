Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794825090;
	b=zeOzVjTyp6Y8C289p73X5CXHMU2JyJAPbOPM5EMbwQxJU6HGFrxhnrMiQWYG/VHfZMZv
	 cMKweBgYe/+U2L8wVm5wBWPRWUCLfWSsLPcwW55xjge5iH+bsG+1tVqjC4RlEo/EFXEYv
	 Lm5K1fh1SEv7uaXaNF4oDvK3ZErfZAV3p65IXbRVv1Yfl1ZERUaVaLNdJdOYJ0+K31+IH
	 6BKGWyEO0fqOAtehO+0LicWJFivMkJ9ouAQ97L7rDZO3YRgmIWfYjudtpYLCL8T/DBjwl
	 Fo8RgyfmRLls13L9qDPdtyB2Ij2tD+yLwxuStfAia82WrU6/saD+V/RS8hTHvlqmJ/g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794825090;
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
	bh=1mcuVc0akubqV7HAqrIKjjdQmweyUGaE9u+wdsPcJjo=;
	b=pSLPRDEodSzRs0uka0hTw9j0ePfyGpDcxgPy7toGvfYtvkq+a6KzsBHAHYkFR/W295tt
	 ntb3Tv42Tugcsluxb9gTE2LHmjarQ4OZgSJeKLfRQFzLJVfTtHuOVdlUp8YHk1okzh8Xn
	 GoJWLpQ+HDWm2+jDBe0e8fJKOOmmaYw/wXi328BdgTReWw7Y4zRZPOKUVoMPyoyxfmNvx
	 L4qxMTyJcv5czcJekSLJX+cua43uIHti0ZZeZ9lwHpkBmMruVpFxmJi/vXm61ui6nsXfo
	 HESidgn/HlSxVWrZMdW5qhjr+E5yWaL81g/MeFVy9h1UW3u1Wq2/WpV30hyXe+CypAg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=LUFBAtgp;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.43
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013043.outbound.protection.outlook.com [40.107.201.43])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1124606A886;
	Mon, 16 Nov 2026 10:31:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D1124606A886
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=LUFBAtgp
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l8J55V6ajSLATzJfrqh0dak254l0SoF/ORtg6es46wjmwomSa+JNJ+Cloi0msU3JqWQFGfKddh/onOG2+ntHGQujb5vlBHgw/UkuNgHvcX+lCi1gVELz6U48Q+rUENvapbCpVMJ7FlXzTAWU9K8PRJMpQDeeAYsp56nYSmbf9GJwZsmRWD5Om0qkb+7Pd7O/vHOYMjicN8iAJouCa1jDX586LQe6RJYXy17nyFcJbKKV4ZmLYgVHwke+O/Awb5FetQPBYEp7oHw63lZaVfAJiFHSAvsUNcKzXSYIcMqZON/CVH8w0Z2Ak39WHoUOwO238oa6cMIzlZFuVNA9qEK8Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1mcuVc0akubqV7HAqrIKjjdQmweyUGaE9u+wdsPcJjo=;
 b=wN+V2HwFhp46pnIICRZcH+2eh6mUPKIDWtH0nxgh7LkFv1uLMjgI5dWESSdbGXBpO5ougAFhkieOi9Zgn3VdZ/+XcWRZXWJl6opr/qydZ65k4xCKa27vGa54NUSdGXJu7z0F920vyauwLcDCuRBUk5rrYXUFeYPU7VO5XwTeqTueaMVRPr/8aN1U6ESQWJ5ZNbxpHHLRF+II7Nw+S8dErf+tlevnSPTAFAiIsFjT9i7mCHfBaYel8HD0hQb275eausXp1khmxFh98SaH92gnfVWSqwpVVD9fttgyDC2YeUZZ21S35DW/7k4prD1UkXXtx2XnXDDsQX1TSPqvUi215g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1mcuVc0akubqV7HAqrIKjjdQmweyUGaE9u+wdsPcJjo=;
 b=LUFBAtgpMcSoMuvbTpGkZK82UBzLEheYyP7bDdYbrWd1ZNV0oKuN4/ZIBhYMhWQiRF8syio1zFOd93/c9Wkh6WfNO6MNK3k9CzQ3fVeop7WjO6zu/OA6ATkNtb1qVMPGFCGAtxgZNiObicXPHbQ5xuioGVkhp5T427ndZPv264mK7EiaREhF68A1q9poLoPtLDHbE+YIiR3nsQ+0HNQpOqAbF0DR/ksHHCsYLJsemK4ZrXRzGXcgnR53MAmDaU/4PrWsIXw1I5n9/oEopBjru893AJ3b0xBXM6/YYeYVG9mFhAfrDk6Z9u69lVBykAaKfDkpicsfvOQNYmf0OdLC/A==
Received: from PH7P221CA0029.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:32a::12)
 by DM4PR12MB6496.namprd12.prod.outlook.com (2603:10b6:8:bd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Mon, 16 Nov
 2026 10:31:24 +0000
Received: from CY8PEPF0000005B.namprd21.prod.outlook.com
 (2603:10b6:510:32a:cafe::26) by PH7P221CA0029.outlook.office365.com
 (2603:10b6:510:32a::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.13 via Frontend Transport; Mon,
 16 Nov 2026 10:31:23 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CY8PEPF0000005B.mail.protection.outlook.com (10.167.247.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.0 via Frontend Transport; Mon, 16 Nov 2026 10:31:23 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 16 Nov
 2026 02:31:08 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 16 Nov 2026 02:31:08 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Mon, 16 Nov 2026 02:31:03 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>,
	Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Or Har-Toov
	<ohartoov@nvidia.com>, Patrisious Haddad <phaddad@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shay Drory <shayd@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>, Uri Dar <udar@nvidia.com>
Subject: [PATCH net-next V2 05/10] net/mlx5: LAG, decouple iteration end-of-walk from MLX5_MAX_PORTS
Date: Mon, 16 Nov 2026 12:30:05 +0200
Message-ID: <20261116103010.1129666-6-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261116103010.1129666-1-tariqt@nvidia.com>
References: <20261116103010.1129666-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY8PEPF0000005B:EE_|DM4PR12MB6496:EE_
X-MS-Office365-Filtering-Correlation-Id: 9170c965-1692-483c-3a07-08df43ccc34e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|82310400026|376014|36860700016|10067099003|56012099006|11063799006|261026140227099003|261028144727099003|261021121427099003|261021123027099003|261022105027099003|261102123227099003|261009223027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	668IkWfThPKlVv14GULprRLmc0bT5tmX8oyieL4yt7dVwvxH6iWZ4MzuWy6HyuFRuS1ofIK65j3HH+w2WRyqmrW3yzBngDkEYvtJIGVCS6lxv2TDR+PnYM+Hjw3soqThAJPpfGgDNesUOKpUhBlo2h08HAFtETdG4rfqF6XGxbAbXkFlIp30yoMYJmRfe8Ly7utvl4hJ56ygtl47ukiQlj1ki3le3Q0ovyLDl7DykeZKpKHpG6SqrQNTjYtJt6GPbaGIQLbl/VmbAR8GDmGRZxisGhPjx3mFyWyYxASoTXzVlsnWph7ypoGXpVEf7LvIvQnl9IqZOCL4pB+Qx86a0w78WiAsvKOQiAcvaJpcZQKxjAwWwoMtDv40bmT75qOTeEWuPDJooULxrNtz6OaLu6gjw4JLTqMTjWW2HHcP55oHviglpNJQZYM6JWAKWGQXIJj5760AvYu6UR3rBmg0csM2rLL/m3mPwcIbvr2B5MAZRF8AGzNFX6EZtNEOG8j7q01DJeaNi7yJRe27X/5qqSs/bguT3PzwdqZW9t6qftBiv3YAoDDXqaJFUfgljBCbm6NGM61UMF50e0u+5BuIoNPAUH5Vjoql+/KT/beqF+qTwmYIIOspm0EPN/ZqLXm6fKSULDJktVYcZitHoQX0/gxwa/uN2s0L5zcV0eQ7xce+VWD0MgN8GbAbIJz/r/2BfHqbo6bQHjf9EHk1PcKJuQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(82310400026)(376014)(36860700016)(10067099003)(56012099006)(11063799006)(261026140227099003)(261028144727099003)(261021121427099003)(261021123027099003)(261022105027099003)(261102123227099003)(261009223027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	rSbEamaoEbGiXJ5+VMaahLYZnhc3Oqa08fIR2TfbKtOOjMnla+hKXpxlHNHbuDUQmrmjGNlLMwHR1kPCqO8RQX71xRUaXy2e98JABIwd/MSqKi+YxpD6G3JimbhaIN12jBAh8mUNxz4Gr3OCT3NBgmvtJziC2T93MlJnndV8R2F210rzifQ8zeREUmr2HFXW8ooWD7Xzh2u8AZCND8FXOUEkhUH2oUxBHLIFKbdNzvlr4BGLLorw2Ar5X/BTjwbaPaD2EMyM4mIt/O8oAQl0LPGUwZOCSKHdoI3bRNkiM1S10jbdWm5PkjxeghQhy2B06uQZZGc//2mD5k2g00VxVGMD5868/+z0HbaxqoIf4ZMx7tX1QO6mt7JbjPFFeaoiU+dnnh/WKLu4fwrz05IQ6mXLiqEZ5r6IIyVUQue7tFAeXnDENM1fkTVoePCvXfsT
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 10:31:23.7681
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9170c965-1692-483c-3a07-08df43ccc34e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY8PEPF0000005B.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6496

From: Shay Drory <shayd@nvidia.com>

The LAG xarray iterators returned MLX5_MAX_PORTS as their end-of-walk
sentinel, and the open-coded callers compared the current index against
MLX5_MAX_PORTS to detect the end of iteration. This ties iteration to a
compile-time maximum rather than to the actual number of LAG members.

Add ldev->max_funcs, and use it as the loop bound. Update the open-coded
callers accordingly. When a member is added at an xarray index >=
ldev->max_funcs, increase max_funcs.
In addition, remove the xa_alloc() limit of MLX5_MAX_PORTS.

No functional change; this only removes the dependency on
MLX5_MAX_PORTS.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 22 +++++++++++--------
 .../net/ethernet/mellanox/mlx5/core/lag/lag.h |  3 ++-
 .../ethernet/mellanox/mlx5/core/lag/mpesw.c   |  2 +-
 .../mellanox/mlx5/core/lag/shared_fdb.c       |  2 +-
 4 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 669b2167a82d..cbef6ab1e38a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -395,6 +395,7 @@ static struct mlx5_lag *mlx5_lag_dev_alloc(struct mlx5_core_dev *dev)
 		mlx5_core_err(dev, "Failed to init multipath lag err=%d\n",
 			      err);
 
+	ldev->max_funcs = ldev->ports;
 	return ldev;
 
 err_wq:
@@ -1283,7 +1284,7 @@ static void mlx5_lag_assert_locked_transition(struct mlx5_lag *ldev, u32 filter)
 	lockdep_assert_held(&ldev->lock);
 
 	i = mlx5_get_next_lag_func(ldev, 0, filter);
-	if (i < MLX5_MAX_PORTS) {
+	if (i < ldev->max_funcs) {
 		pf = mlx5_lag_pf(ldev, i);
 		if (filter == MLX5_LAG_FILTER_PORTS ||
 		    filter == MLX5_LAG_FILTER_ALL)
@@ -1830,7 +1831,7 @@ struct mlx5_devcom_comp_dev *mlx5_lag_get_devcom_comp(struct mlx5_lag *ldev)
 	filter = ldev->virt_lag ? MLX5_LAG_FILTER_ALL :
 		MLX5_LAG_FILTER_PORTS;
 	i = mlx5_get_next_lag_func(ldev, 0, filter);
-	if (i < MLX5_MAX_PORTS) {
+	if (i < ldev->max_funcs) {
 		pf = mlx5_lag_pf(ldev, i);
 		devcom = pf->dev->priv.hca_devcom_comp;
 	}
@@ -2094,7 +2095,7 @@ static int mlx5_handle_changeupper_event(struct mlx5_lag *ldev,
 				break;
 			}
 		}
-		if (i < MLX5_MAX_PORTS) {
+		if (i < ldev->ports) {
 			if (netif_is_bond_master(upper)) {
 				slave = bond_slave_get_rcu(ndev_tmp);
 				if (slave)
@@ -2359,13 +2360,16 @@ int mlx5_ldev_add_mdev(struct mlx5_lag *ldev,
 	if (!pf)
 		return -ENOMEM;
 
-	err = xa_alloc(&ldev->pfs, &idx, pf, XA_LIMIT(0, MLX5_MAX_PORTS - 1),
+	err = xa_alloc(&ldev->pfs, &idx, pf, XA_LIMIT(0, U8_MAX - 1),
 		       GFP_KERNEL);
 	if (err) {
 		kfree(pf);
 		return err;
 	}
 
+	/* max_funcs is the iteration ceiling; grow it, never shrink. */
+	if (idx >= ldev->max_funcs)
+		ldev->max_funcs = idx + 1;
 	pf->idx = idx;
 	pf->dev = dev;
 	pf->group_id = group_id;
@@ -2394,7 +2398,7 @@ void mlx5_ldev_remove_mdev(struct mlx5_lag *ldev,
 		if (pf->dev == dev)
 			break;
 	}
-	if (i >= MLX5_MAX_PORTS)
+	if (i >= ldev->max_funcs)
 		return;
 
 	if (pf->port_change_nb.nb.notifier_call)
@@ -2607,7 +2611,7 @@ int mlx5_get_next_lag_func(struct mlx5_lag *ldev, int start_idx, u32 filter)
 					 MLX5_LAG_XA_MARK_PORT, start_idx)
 			if (pf->dev)
 				return idx;
-		return MLX5_MAX_PORTS;
+		return ldev->max_funcs;
 	}
 
 	xa_for_each_start(&ldev->pfs, idx, pf, start_idx) {
@@ -2617,7 +2621,7 @@ int mlx5_get_next_lag_func(struct mlx5_lag *ldev, int start_idx, u32 filter)
 		    filter == pf->group_id)
 			return idx;
 	}
-	return MLX5_MAX_PORTS;
+	return ldev->max_funcs;
 }
 
 bool mlx5_lag_is_roce(struct mlx5_core_dev *dev)
@@ -2867,7 +2871,7 @@ struct mlx5_core_dev *mlx5_lag_get_next_peer_mdev(struct mlx5_core_dev *dev, int
 	if (!ldev)
 		goto unlock;
 
-	if (*i == MLX5_MAX_PORTS)
+	if (*i == ldev->max_funcs)
 		goto unlock;
 	mlx5_lag_for_each(idx, *i, ldev, mlx5_lag_get_filter(ldev, dev)) {
 		pf = mlx5_lag_pf(ldev, idx);
@@ -2875,7 +2879,7 @@ struct mlx5_core_dev *mlx5_lag_get_next_peer_mdev(struct mlx5_core_dev *dev, int
 			break;
 	}
 
-	if (idx == MLX5_MAX_PORTS) {
+	if (idx == ldev->max_funcs) {
 		*i = idx;
 		goto unlock;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
index 94e07870e506..1dcd0b87997f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
@@ -83,6 +83,7 @@ struct mlx5_lag {
 	unsigned long		  mode_flags;
 	unsigned long		  state_flags;
 	u8			  ports;
+	u8			  max_funcs;
 	u8			  buckets;
 	bool			  virt_lag;
 	int			  mode_changes_in_progress;
@@ -289,7 +290,7 @@ static inline bool mlx5_lag_is_supported(struct mlx5_core_dev *dev)
 #define mlx5_lag_for_each(i, start_index, ldev, filter) \
 	for (int tmp = start_index; \
 	     tmp = mlx5_get_next_lag_func(ldev, tmp, filter), \
-	     i = tmp, tmp < MLX5_MAX_PORTS; tmp++)
+	     i = tmp, tmp < (ldev)->max_funcs; tmp++)
 
 #define mlx5_lag_for_each_reverse(i, start_index, end_index, ldev, filter) \
 	for (int tmp = start_index, tmp1 = end_index; \
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
index fd70fbebb1de..45e92d71e62c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
@@ -223,7 +223,7 @@ void mlx5_mpesw_sd_devcoms_unlock(struct mlx5_lag *ldev)
 	struct mlx5_devcom_comp_dev *sd_devcom;
 	int i;
 
-	mlx5_ldev_for_each_reverse(i, MLX5_MAX_PORTS, 0, ldev) {
+	mlx5_ldev_for_each_reverse(i, ldev->max_funcs, 0, ldev) {
 		sd_devcom = mlx5_sd_get_devcom(mlx5_lag_pf(ldev, i)->dev);
 		if (sd_devcom)
 			mlx5_devcom_comp_unlock(sd_devcom);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
index 7c7e6c832a93..29048b0c2797 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
@@ -71,7 +71,7 @@ static int mlx5_lag_create_single_fdb_filter(struct mlx5_lag *ldev, u32 filter)
 
 		err = mlx5_eswitch_offloads_single_fdb_add_one(master_esw,
 							       slave_esw,
-							       ldev->ports);
+							       ldev->max_funcs);
 		if (err)
 			goto err;
 	}
-- 
2.44.0

