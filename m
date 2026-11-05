Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.60
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793913476;
	b=RPnYfFGQQlUmQG3GKKqrPGg6Kk2YHYEiREDLusuXYsrSUDwymi1L6CpWPzW2QEiK0lqU
	 S5MXVYl2P5h9raaxzmRDGAmQ6FpuYVqd8l6aZj31WrKNi6PsZBDwkDGqtVyAj+pfT4SZO
	 n7X4a3yeOwYg9KBYbXcLrTUTjKxHgIQwivtxi3kX/FpVk4TiQ8nIqwC3dCMWX/i3WUVgH
	 C4NaNy5d8hRFmkcd074YItmIh9WjiYqTv3VLWjlgzMygofgfgOImRZ/jifz2Crzc9/U8l
	 wgXxl3PDwQbEFp2nRNMQFNh1QE6C+TsWkz7SH50zzNRsHyiegJTpt3yb7uc3LHj3osQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793913476;
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
	bh=+BPv4c+wnnEK/HNJuhLBcqmU1/zmz99RGbwBa1Kw9fw=;
	b=TOj8oLuwHc3kl+Wt0bDbvASy4a8dnZMiHzYhV/uvFhOo9aQH2HpqmZN0iSI7xTPprlvv
	 p1kVuY3mLqOdIv6nckpg1j2JnA3OgBtNHTXiL7swKN7jdKG0THfcqwwDElquFntcfKTo1
	 SS7Moa2LeNcO4UUEWEYL6Q9VeS0LKMZaUzJjgF4qclTg6KRfwrC5+mTzQJBC0HjP9kUhj
	 jsBFjdgEO4JbLqFryAE4by2pxf0RI0x6KdTH7sLcgmcbxbydMoSxlwcIFG71ISs1pbTB2
	 ODS9C2b+oy2kw/T0LiHOSS4/w6hn8JN02QVD/hpAShboCVMVA538Cdd2ENig72KCCdA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=qBltdfR4;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.60
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011060.outbound.protection.outlook.com [52.101.57.60])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1ED1606EE80;
	Thu,  5 Nov 2026 21:17:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E1ED1606EE80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=qBltdfR4
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bdY9sBhtKOT0DM0Ag6yUusXsejxE1s6iVpgtPUNNevy7uV8jIVU1JEFVZGxHfRnEf77fIZuolxPWVMJgVa2kVqQ3Ygm4UZbZerEU85v+8a4FwpKLbxfr8/YO/P8M1em4xzH+eirNKBkT+Tx+tomr1oLe9jKOiLe/ltfBOET2J7EuFbWu7NgTNIATIu8K7jyL7fHMm3P2r2ZfwjUby9Z4ks9L0nPiVBgBztBvT7aZw2Ck5JrN6vFCym6u/PMFAqXdguGdyVjCwsa8MJ1V5lwTFKeHsCSBDjRDhfbhF2pC8zH+LU/2J4nki+lRM/jrmxsSHfRn5/kYgMTxg+s8ELfg4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+BPv4c+wnnEK/HNJuhLBcqmU1/zmz99RGbwBa1Kw9fw=;
 b=TXnciDqGidCjyn/fu2fD1Dl6MP1n5RUHhxBiUn/lmZNJM3TMI8lC2TvMjGKk1YPmj0b8opd7hyhtM9HvGLbh/vhNDQhQO2CdR6uW3DP92OMYhVhxrzZyW36e0Qx6D6Qmzx1am9ViRvvQoRvUs+MlT7KKv8tdUIdI2kEpUQB5a3anDELH7sa1xSj7ikuZIp30XAvPRMRH1qRwwam0vvh5CHWjj7asNV7ITSENF07zWzcWQ8k0cEsQhbmR+XLyQBoaplU4t+3dI+vMLpO4CnRbL2SOeOWNwFXY+U8qndwgXXfgDybab2zNKBXeYVpE/4DClnsJdqkr0TptllVyGbS0Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+BPv4c+wnnEK/HNJuhLBcqmU1/zmz99RGbwBa1Kw9fw=;
 b=qBltdfR4kryNZF37D3xfpaoof+0oRXYRM4UBvU7GggLL8MF4lib+xjeOerqG7QpkfC2mYgRivR4gcqHELYcNNJaz9SDgUOPYVhf/IpbiVrtHagj8J7WhQ2/LhvwoOtZIkagfK5uvHaVONtxYFrQ30We9wJimrTDvLD+HBZkRA9Ce2AE8qWwb9Znxw+G/xqV3Rpj02L2uud18nhbaBWUZVmhg/IOY4gpHvJyxMwF0K4I/kxYW5JCsYI6n0fQ19a/6AVdbmG73xzcVgudJ6DdpPTJvzXcbXiH2yr1v+0QVegJFCYj2hM5Az+3kmqKRzk5x+04cybSXkzwNHFuUfTwuaw==
Received: from CH5P223CA0017.NAMP223.PROD.OUTLOOK.COM (2603:10b6:610:1f3::13)
 by CY5PR12MB6154.namprd12.prod.outlook.com (2603:10b6:930:26::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Thu, 5 Nov 2026
 21:17:50 +0000
Received: from CH2PEPF000166BC.namprd04.prod.outlook.com
 (2603:10b6:610:1f3:cafe::2f) by CH5P223CA0017.outlook.office365.com
 (2603:10b6:610:1f3::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.10 via Frontend Transport; Thu, 5
 Nov 2026 21:17:49 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CH2PEPF000166BC.mail.protection.outlook.com (10.167.252.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Thu, 5 Nov 2026 21:17:49 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Thu, 5 Nov
 2026 13:17:29 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 5 Nov 2026 13:17:28 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Thu, 5 Nov 2026 13:17:22 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Andrea Parri <parri.andrea@gmail.com>, Boris Pismenny <borisp@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>, "Gal
 Pressman" <gal@nvidia.com>, Jeroen Massar <jmassar@nvidia.com>, Jianbo Liu
	<jianbol@nvidia.com>, Kuniyuki Iwashima <kuniyu@google.com>, Leon Romanovsky
	<leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, "Patrisious
 Haddad" <phaddad@nvidia.com>, Prathamesh Deshpande
	<prathameshdeshpande7@gmail.com>, Raed Salem <raeds@nvidia.com>, Roi Dayan
	<roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drory
	<shayd@nvidia.com>, Simon Horman <horms@kernel.org>, Steffen Klassert
	<steffen.klassert@secunet.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net V3 4/8] net/mlx5e: Fix E-Switch races in uplink unbind
Date: Thu, 5 Nov 2026 23:16:32 +0200
Message-ID: <20261105211637.1083978-5-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261105211637.1083978-1-tariqt@nvidia.com>
References: <20261105211637.1083978-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF000166BC:EE_|CY5PR12MB6154:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e7150ae-348f-41ea-5f99-08df3b823eb7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|1800799024|82310400026|36860700016|56012099006|261102123227099003|11063799006|261022075727099003|261021121427099003|261022105027099003|261009223027099003|261028144727099003|261021123027099003|261026121527099003|261026140227099003|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	blxorME+ARJevIkVcQkNxzPpYy58eYkSdsrZySqV9zOFrElVVAYWKhmLymDrQQqT95SnIPRBALJdpGDE+Nj0+/nFPdd7UIHfzAUzoFb51EXPY2irbYxCXnDhsBNacd4ueqmPltLWA8QqYQ4y+jMo1CLISzivoYq/RV2J25rlIdwLy4TtnCGhc0y90wG5Ps+mpXNuLklgii61iIiYqiKAgQJpYBqw0oipvvlhPCZYUgZlcHkpUiI1Yq/PY7HhIwqN00RfibRNSfdY/gzhtvyPBBdARTXupMow4I8+vf5ABqR50kMY/DR5qqrYW5Wm9WpRUMSzHFVXmp2dROHQ5GCcBzZQ2v3AD3jSqzsOjtVk2qWRb8ogaA5QL+DMi+9xiWiefLRcLkloLxWqXtmfltHv8FYcLcyCvVbSvCfZfoCqn80xUFX6EBNED4scPekapNaZKl5aMAbL+9V3SnYV5vdKAdfC0RzOgmqOC2eKezt8sDIR8d+vyWzkuV92hPUixi8j3OcIaXByFJtbmjr+yv2psudhatx856+TgWSzex6JtuFsBfwAZ/Xnnkvt/XYV2aX0PcIYRsULiJIFwwkn53It30WgGOvXHGy7PvunSWWhfsfHOgj5/S+rpSqns55QHHkh/ngAYsvgYP2ZLt2yHRylNs0B8kRoTaVL3OgfAEJeWKfP1/zH3z4fC/JjCHwybwZkQAbgUhyCYX0CzGiMDS0Muw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(1800799024)(82310400026)(36860700016)(56012099006)(261102123227099003)(11063799006)(261022075727099003)(261021121427099003)(261022105027099003)(261009223027099003)(261028144727099003)(261021123027099003)(261026121527099003)(261026140227099003)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	XnxuNJ0xq6gCrhJpzKP4oeMt2bKiGL+oEs1eTBzZGkgLtJ35/zkT5QW1IyoxD96xSXWKf0k34ikUafs5DrC0vwxheHm5S+cDl/3Iy7bmlAMx6uZ4TPl71J4FMk/XOF7o1O/tcADZ8/sZ8IK87hDknRMrZ5kNUy3rcA5OI+4iB6ilNNgT6qK8wivYVmxZ9cvKwK++5aj6wolvOsCKs/XGLQefg7kBU5d2XU1WU+cxVjzn6NonIQeI5MZYRPx+PRcY6ME2OpAhQb0KEKx83LIJfU9QrLDRsV62NaQ6VDsF9mEZqWjCzow9OfFIAF7sxOsqcXHrwUjIjN2vWZ8eCg+G4vTg8hQjAGhOTRLOYeCEFI2CJSJrruBkGrpiY34+fsj5Y45Ae9bUBS8Dl6emSUVvAv3SZX2Vd5HCw5LwE+6Fou1IE0GyiX9DdodRULf1RhdE
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 21:17:49.2268
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e7150ae-348f-41ea-5f99-08df3b823eb7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF000166BC.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6154

From: Cosmin Ratiu <cratiu@nvidia.com>

Unbinding the uplink Ethernet auxiliary driver in switchdev mode with
offloaded IPsec policies deadlocks on the esw->mode_lock semaphore:
mlx5_eswitch_safe_aux_devs_remove()
  mlx5_esw_hold()
    down_read_trylock(&esw->mode_lock)                 (*)
  mlx5_core_reps_aux_devs_remove()
    ...
    mlx5e_vport_uplink_rep_unload()
      unregister_netdev()
        xfrm_dev_unregister()
          xfrm_dev_policy_flush()
            xfrm_policy_kill()
              xfrm_dev_policy_delete()
                mlx5e_xfrm_del_policy()
                  mlx5e_accel_ipsec_fs_del_pol()
                    rx_ft_put_policy()
                      rx_put()
                        mlx5_eswitch_unblock_mode()
                          down_write(&esw->mode_lock)  (BOOM)

Another deadlock with IPsec states:
mlx5_eswitch_safe_aux_devs_remove()
  mlx5_esw_hold()
    down_read_trylock(&esw->mode_lock)                (*)
  mlx5_core_reps_aux_devs_remove()
    ...
    mlx5e_vport_uplink_rep_unload()
      unregister_netdev()
        xfrm_dev_unregister()
          xfrm_dev_state_flush()
            xfrm_dev_state_free()
              mlx5e_xfrm_free_state()
                mlx5e_accel_ipsec_fs_del_rule()
                  rx_ft_put()
                    rx_put()
                      rx_destroy()
                        mlx5_eswitch_unblock_encap()
                          down_write(&esw->mode_lock)  (BOOM)

To fix these, first refactor initiators of eswitch operations so they no
longer step on each other's toes.

The active/inactive toggle and setting the inline/encap mode now use the
new mlx5_esw_lock_wait(), which waits for an operation in progress to
finish. They all hold devl_lock, so the only operation they can find in
progress is an uplink unbind, which doesn't need devl_lock.
Setting the esw mode keeps using mlx5_esw_try_lock(), which also rejects
the change while eswitch users exist and bails out with -EBUSY.

mlx5_eswitch_safe_aux_devs_remove() now also waits for an operation in
progress with the same mlx5_esw_lock_wait() before initiating one,
dropping mode_lock and then removing representors.
The deadlocks are avoided.

Finishing an operation in progress now requires mlx5_esw_unlock() to
wake up any waiters instead of plain up_write(&mode_lock).

As a side effect, the timeout in mlx5_eswitch_safe_aux_devs_remove() is
gone, which fixes another scary corner case, of representor devs not
being removed on timeout but leaked instead. The timeout hid the SD
deadlock fixed in the previous patch. Now that that's gone, no reason
for the timeout to stay.

This was found by internal testing and reproduced on HW.
It was independently found by Sashiko during analysis of another patch
in this series.

Fixes: 2ae8c7edea87 ("net/mlx5: Fix Unbinding uplink-netdev in switchdev mode")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 24 +++++++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  1 +
 .../mellanox/mlx5/core/eswitch_offloads.c     | 50 +++++++++----------
 3 files changed, 48 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 2d289fb1353b..f50993cfcf7a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -3051,12 +3051,36 @@ int mlx5_esw_lock(struct mlx5_eswitch *esw)
 	return 0;
 }
 
+static void esw_mode_lock(struct mlx5_eswitch *esw)
+{
+	down_write(&esw->mode_lock);
+}
+
+static void esw_mode_unlock(struct mlx5_eswitch *esw)
+{
+	up_write(&esw->mode_lock);
+}
+
+/* Lock the eswitch and wait for an operation in progress to finish. */
+void mlx5_esw_lock_wait(struct mlx5_eswitch *esw)
+{
+	down_write(&esw->mode_lock);
+	wait_var_event_any_lock(&esw->eswitch_operation_in_progress,
+				!esw->eswitch_operation_in_progress,
+				esw, esw_mode, TASK_UNINTERRUPTIBLE);
+}
+
 /**
  * mlx5_esw_unlock() - Release write lock on esw mode lock
  * @esw: eswitch device.
+ *
+ * Also wakes up mlx5_esw_lock_wait() waiters, so it must be used to release
+ * mode_lock after clearing eswitch_operation_in_progress.
  */
 void mlx5_esw_unlock(struct mlx5_eswitch *esw)
 {
+	wake_up_var_locked(&esw->eswitch_operation_in_progress,
+			   &esw->mode_lock);
 	up_write(&esw->mode_lock);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 928b20e73d37..1fb67fc6d49a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -948,6 +948,7 @@ void mlx5_esw_get(struct mlx5_core_dev *dev);
 void mlx5_esw_put(struct mlx5_core_dev *dev);
 int mlx5_esw_try_lock(struct mlx5_eswitch *esw);
 int mlx5_esw_lock(struct mlx5_eswitch *esw);
+void mlx5_esw_lock_wait(struct mlx5_eswitch *esw);
 void mlx5_esw_unlock(struct mlx5_eswitch *esw);
 
 void esw_vport_change_handle_locked(struct mlx5_vport *vport);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 4939e10336c2..4da89fcf215b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -4441,7 +4441,7 @@ static bool mlx5_devlink_switchdev_active_mode_change(struct mlx5_eswitch *esw,
 	    !esw->offloads_inactive)
 		return false;
 
-	down_write(&esw->mode_lock);
+	mlx5_esw_lock_wait(esw);
 	esw->offloads_inactive = !esw->offloads_inactive;
 	esw->eswitch_operation_in_progress = true;
 	up_write(&esw->mode_lock);
@@ -4453,34 +4453,30 @@ static bool mlx5_devlink_switchdev_active_mode_change(struct mlx5_eswitch *esw,
 
 	down_write(&esw->mode_lock);
 	esw->eswitch_operation_in_progress = false;
-	up_write(&esw->mode_lock);
+	mlx5_esw_unlock(esw);
 	return true;
 }
 
-#define MLX5_ESW_HOLD_TIMEOUT_MS 7000
-#define MLX5_ESW_HOLD_RETRY_DELAY_MS 500
-
 void mlx5_eswitch_safe_aux_devs_remove(struct mlx5_core_dev *dev)
 {
-	unsigned long timeout;
-	bool hold_esw = true;
+	struct mlx5_eswitch *esw = dev->priv.eswitch;
 
-	/* Wait for any concurrent eswitch mode transition to complete. */
-	if (!mlx5_esw_hold(dev)) {
-		timeout = jiffies + msecs_to_jiffies(MLX5_ESW_HOLD_TIMEOUT_MS);
-		while (!mlx5_esw_hold(dev)) {
-			if (!time_before(jiffies, timeout)) {
-				hold_esw = false;
-				break;
-			}
-			msleep(MLX5_ESW_HOLD_RETRY_DELAY_MS);
-		}
-	}
-	if (hold_esw) {
-		if (mlx5_eswitch_mode(dev) == MLX5_ESWITCH_OFFLOADS)
-			mlx5_core_reps_aux_devs_remove(dev);
-		mlx5_esw_release(dev);
-	}
+	if (!mlx5_esw_allowed(esw))
+		return;
+
+	/* Wait for any concurrent eswitch mode transition to complete.
+	 * Deadlock risk if ever called from within an operation in progress.
+	 */
+	mlx5_esw_lock_wait(esw);
+	esw->eswitch_operation_in_progress = true;
+	up_write(&esw->mode_lock);
+
+	if (mlx5_eswitch_mode(dev) == MLX5_ESWITCH_OFFLOADS)
+		mlx5_core_reps_aux_devs_remove(dev);
+
+	down_write(&esw->mode_lock);
+	esw->eswitch_operation_in_progress = false;
+	mlx5_esw_unlock(esw);
 }
 
 int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
@@ -4656,7 +4652,7 @@ int mlx5_devlink_eswitch_inline_mode_set(struct devlink *devlink, u8 mode,
 	if (IS_ERR(esw))
 		return PTR_ERR(esw);
 
-	down_write(&esw->mode_lock);
+	mlx5_esw_lock_wait(esw);
 
 	switch (MLX5_CAP_ETH(dev, wqe_inline_mode)) {
 	case MLX5_CAP_INLINE_MODE_NOT_REQUIRED:
@@ -4694,7 +4690,7 @@ int mlx5_devlink_eswitch_inline_mode_set(struct devlink *devlink, u8 mode,
 
 	down_write(&esw->mode_lock);
 	esw->eswitch_operation_in_progress = false;
-	up_write(&esw->mode_lock);
+	mlx5_esw_unlock(esw);
 	return 0;
 
 out:
@@ -4764,7 +4760,7 @@ int mlx5_devlink_eswitch_encap_mode_set(struct devlink *devlink,
 	if (IS_ERR(esw))
 		return PTR_ERR(esw);
 
-	down_write(&esw->mode_lock);
+	mlx5_esw_lock_wait(esw);
 
 	if (encap != DEVLINK_ESWITCH_ENCAP_MODE_NONE &&
 	    (!MLX5_CAP_ESW_FLOWTABLE_FDB(dev, reformat) ||
@@ -4820,7 +4816,7 @@ int mlx5_devlink_eswitch_encap_mode_set(struct devlink *devlink,
 	esw->eswitch_operation_in_progress = false;
 
 unlock:
-	up_write(&esw->mode_lock);
+	mlx5_esw_unlock(esw);
 	return err;
 }
 
-- 
2.44.0

