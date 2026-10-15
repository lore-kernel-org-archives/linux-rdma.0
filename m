Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010023.outbound.protection.outlook.com [52.101.85.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1243EF67D;
	Thu, 15 Oct 2026 09:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792056896; cv=fail; b=tZE0Or6oNfMzpL393OTIHILhvhs3qlUszP3RPLL8yvWeiFOKm3u/VV+uGeNniKLIHm0iOZ0Alx7YAs9ab0eKl2TUFyoRbGLA771Vi/4Bg/eQ82o8WL7w9MM7EagZmTrcf8MlS+uQ+IxsritEiJbCZgNTyOoYJcp/+BgE0Z4vD9Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792056896; c=relaxed/simple;
	bh=fP05W5VMlZ/8Vr+3B/3G0LdzAiBQadP2HPf0u3JB2Pg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XdmdzmGFjPbUMCHCIf8RSQ02e0TGzmIVMj2vgRRdV8vfCU3/81wKJStcR5bBIYhyJOK2SPtJfT9puVoZGxyIqQprBZfwIIw8doiH1DNlujleK9p5tJfqQxXVwnHSh3KyGMfIMSLY+yoLiD0z744gL7h4b2F5+OKiIIk7ag8iYro=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lO1lQyOd; arc=fail smtp.client-ip=52.101.85.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lO1lQyOd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qISlT7rpiNRXlo/szoycHfLiEZjqPOc9aLR2gnk6jNkAVUDCXg3S4zqxAVmC8Py2QGJrT/0l7o6aDcXxIGD+nyW7gMH6DNOULLSshWTdu1YSnW5KlJjXAIs87/LUJV0Lj4esXNkmdnpqWiG+pW1ztSn1lSZd0y/hqQLa2gUP7FkCqYQzL1n4oDT7Oe7t4TplNKwrzhMhkhlmV3T8V2ypoR/biAgfjt78rqFqIc0VD9Vn3Sz5FQbzByILIOE3gYGPpJTeXSFALAsdA6553QNtoWteXPxjlXxq1UGHWJYutZd5OVtervWPOp5IzsGyeI6zqdcAiALC7eDn7AWL13CW2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t37iR2kftL/51UvrsFwJg3WW0ux8UcVmjN0rHGF2XwQ=;
 b=DZiysWzQlOKbUoq7YMc290JWYRh/GHg/ncTDkWZ3QKbPGOUa4dhPyoTlo5HiFf4M+xKNjg00244hCreMHsc5kYB5XbRT0OWTAo4lUFDvcIRblVVMkztvBKTrWxUoBxG+2s1rn+HEv4LiApoBzDXyMWNli5RfuIWkKP+m2gSwgk2WJXFPi/U6s7ZksagQUzoO8wZ2YkdwnnpNmK/cPe+ob5Ubd8VPIs+qbM9PjXl3pbwSFxYhaad7COaCsXhQiBzFKnd4ZFpPN+wVwo0eFOvSZA39ARBlwV3K45ZfmgfAtI4Gp5CQ4naKs/kpUylP7xh1Ji6fjTwqnoV8mWqyj8Obbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t37iR2kftL/51UvrsFwJg3WW0ux8UcVmjN0rHGF2XwQ=;
 b=lO1lQyOdhfce5SnLUA7JgpMEWpwsDf9nXJmBaibSMoLNzRBSJ/3mgePoJBdUHUEzrJA+xAsEPaxTiMJJzQLCKfHRq5T+mxIoy0NpfFhEDwu4pBVmZCuHyUSaaLHwZnSVZTG4+Vcff7g5OjK6Vkar+4lvhWz+r8VoRhCR69DLZ15scerkWTA13mXi7hWiOjG28kJdYk7YX+0rrmNGnZfIUoe7PCBcmatXOeT2/HcBjCHZ0csgQu+3Wi95FIbiVRSxbblKRQMk1b2LxIIW3elYfL31jXoxVQSlA6+aZQGDteEbWdKlcX7t5L9DJSekzD1rC26/zTPUKaeTkG2TjJISQA==
Received: from BN9P221CA0027.NAMP221.PROD.OUTLOOK.COM (2603:10b6:408:10a::21)
 by CHBPR12MB319464.namprd12.prod.outlook.com (2603:10b6:610:409::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.14; Thu, 15 Oct
 2026 09:34:49 +0000
Received: from BN1PEPF00018547.namprd05.prod.outlook.com
 (2603:10b6:408:10a:cafe::20) by BN9P221CA0027.outlook.office365.com
 (2603:10b6:408:10a::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Thu, 15
 Oct 2026 09:34:49 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN1PEPF00018547.mail.protection.outlook.com (10.167.248.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Thu, 15 Oct 2026 09:34:49 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 15 Oct
 2026 02:34:31 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 15 Oct 2026 02:34:31 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Thu, 15 Oct 2026 02:34:27 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Gal Pressman <gal@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shay Drory <shayd@nvidia.com>, Simon Horman
	<horms@kernel.org>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net] net/mlx5: Fix lock dependency cycle on uplink unbind in switchdev mode
Date: Thu, 15 Oct 2026 12:34:19 +0300
Message-ID: <20261015093419.1150837-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00018547:EE_|CHBPR12MB319464:EE_
X-MS-Office365-Filtering-Correlation-Id: d7b912b4-4ea3-496c-72e6-08df2a9f8ebf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|36860700016|82310400026|23010399003|56012099006|11063799006|261009223327099003|261009221227099003|261009220027099003|261009221727099003|261009223027099003|10067099003|18002099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	gypq4oSG3A3FFQl9ipI9c4EDMfkYMgs4CmDLzJkbcje9FCm8LIVfIqAE5OVYsaM/QqEBshWVf7+oQrW4d9daxVH62Z+2rmoqo66vuJbyFUNBQKSteQ6dMLUZHSvcvwNgEz8/eb0aMiArixwKauWSJb/G2W1j7q04mOaYzBJfXGeODeHVcs5JPvZdDrZfcfOX6ycdz+Ywp5CgVoElCXbIs4UIWy1mbDZXIeOIc5voSdc0mQRHqVnzyu+vw+OQ1TkLk4OtJf4DQizaq3DO5pyLs8hYRcEEVAaPv8GrhOeR/n5GT3yKuSKLemp1SW/iBaL8ydJk8xwnvNO/YlLH+ZJH9ZPhtkr4XaKnKa/O7aINVNAhmx1G51BGutM77oHJs69JNxXzf0y5LKYDzgRCQkDkcfrrFc09vw63Q8CMbTljLZX6N+UWfgw/gV6rxWg/PJnaRyNzciGabXCChksIbfS6kk+Rq3I2ZhJx7vGt40A6VZtzJia82VBTpRG5fBbEFSHYBFCBavldDLZC86ajeeWVNwzUb5JC5Yv2hjnuPqQlUoJkIhL3nw2YGlsEhk00/9Gtf22NFWT6efECOK/9IigsmhPC2SM4ILzw1U2O5ydfN2HlDf1XZU8JxrZSO3mB4ux/i7sM2Kgnphz4q1b5LNOV2qd3Cb2ya/QuBJYmEzyC92ftHHHKPlXyvH5VQ7Z9TE63/MCZHu9PzBsRLrr8Y88iaA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(36860700016)(82310400026)(23010399003)(56012099006)(11063799006)(261009223327099003)(261009221227099003)(261009220027099003)(261009221727099003)(261009223027099003)(10067099003)(18002099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	RhGnl9X1ATg6bb54JQ/owK/y53gFZjjSPTCgzKec8IderJm4NPDc770zUgTPp6YELi07/SEBc5EqLeXciwe31CetpAflKelKpi+0hO8X2PdbgYCbl9Ui3yypdgZErqLiisRnN66nGYaWDBrZMggbH/eGSfbnUVLqMRorFvVvsdVKB24ZcIU/Sr/rPttzbrzyZ2/x5nGzYF3hYrlxwXPCT5CYfdJHEVXLmiTwVddUHHHATIDoKiAb0ehFdtuRpLMZinNwZyS7Bj+ySwNNYshZBLJE9h1R4M61n9RMC8D+Q6IfDXDcchq6LT2MmIFil46Pn0yEIwq++g5kTNeGgwXmWOh2wfS5BSIyWUnWzoeoBQ93L2PkHacKPvSJC40zH41fYrwm2/2/0jgQS2opaMlT6nTMhUjpCEOOcnbaco1f8eOXahWM7oB6fSxV3uqVUTYI
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 09:34:49.1033
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d7b912b4-4ea3-496c-72e6-08df2a9f8ebf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00018547.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CHBPR12MB319464

From: Shay Drory <shayd@nvidia.com>

mlx5_eswitch_safe_aux_devs_remove() holds esw->mode_lock for read across
mlx5_core_reps_aux_devs_remove(), which unregisters the REPs auxiliary
devices and therefore takes esw->offloads.reps_lock. This nests
mode_lock outside reps_lock, the exact nesting
mlx5_devlink_eswitch_mode_set() goes out of its way to avoid: there the
eswitch_operation_in_progress flag is raised, mode_lock is dropped, and
only then is reps_lock taken.

With that nesting in place lockdep reports a cycle [1]. IPsec packet
offload takes mode_lock under ipsec->tx_esw->ft.mutex, through
mlx5_eswitch_block_encap() in tx_get(); the mode change path takes
rtnl_mutex under reps_lock, through the netns immutable set; and
unregistering a REP netdev takes ft.mutex, through the xfrm policy
flush, under the netdev instance lock which is itself nested under
rtnl_mutex:

  &ipsec->tx_esw->ft.mutex -> &esw->mode_lock -> &esw->offloads.reps_lock
    -> rtnl_mutex -> &dev_instance_lock_key -> &ipsec->tx_esw->ft.mutex

Reproduced by unbinding the uplink ETH driver with an IPsec packet
offload policy configured in switchdev mode:

  devlink dev eswitch set pci/0000:08:00.0 mode switchdev
  echo 2 > /sys/class/net/eth2/device/sriov_numvfs
  ip addr add 193.237.171.21/16 dev eth2
  ip link set eth2 up
  ip xfrm policy add src 193.237.171.21 dst 193.237.172.22 \
     offload packet dev eth2 dir out \
     tmpl src 193.237.171.21/16 dst 193.237.172.22/16 \
     proto esp reqid 0xdcd95f7b mode transport priority 21
  echo mlx5_core.eth.0 > /sys/bus/auxiliary/drivers/mlx5_core.eth/unbind

Keep mode_lock and reps_lock unnested here as well: take mode_lock for
write, raise eswitch_operation_in_progress, drop mode_lock, remove the
REPs auxiliary devices, then retake mode_lock and clear the flag. The
flag keeps excluding concurrent mode transitions and mode users while
mode_lock is not held.

Acquiring mode_lock for write can't go through mlx5_esw_try_lock(),
which also refuses the lock while esw->user_count is non zero: that
count is held for the lifetime of every offloaded TC flow, and those
flows are only flushed by the REP netdev unregister this function is
about to perform.
Use a local trylock helper that attempts to acquire mode_lock and only
bails if the operation flag is set. Bail out early when the device has
no eswitch, which mlx5_esw_hold() used to cover.

[1]
 WARNING: possible circular locking dependency detected
 7.2.0-rc2+ #2 Tainted: G        W
 ------------------------------------------------------
 run.sh/7007 is trying to acquire lock:
 (&ipsec->tx_esw->ft.mutex){+.+.}-{4:4}, at: tx_ft_put_policy+0x81/0x130 [mlx5_core]

 but task is already holding lock:
 (&dev_instance_lock_key#9){+.+.}-{4:4}, at: unregister_netdevice_many_notify+0x3eb/0x2140

 which lock already depends on the new lock.
 [...]
 Chain exists of:
   &ipsec->tx_esw->ft.mutex --> rtnl_mutex --> &dev_instance_lock_key#9

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(&dev_instance_lock_key#9);
                                lock(rtnl_mutex);
                                lock(&dev_instance_lock_key#9);
   lock(&ipsec->tx_esw->ft.mutex);

  *** DEADLOCK ***

 8 locks held by run.sh/7007:
  [...]
  #3: (&esw->mode_lock){++++}-{4:4}, at: mlx5_esw_hold+0xcc/0x150 [mlx5_core]
  #4: (&dev->mutex){....}-{4:4}, at: device_release_driver_internal+0xa5/0x560
  #5: (&esw->offloads.reps_lock){+.+.}-{4:4}, at: mlx5_eswitch_unregister_vport_reps+0x1f/0x40 [mlx5_core]
  #6: (rtnl_mutex){+.+.}-{4:4}, at: rtnl_net_dev_lock+0xde/0x260
  #7: (&dev_instance_lock_key#9){+.+.}-{4:4}, at: unregister_netdevice_many_notify+0x3eb/0x2140

 Call Trace:
  <TASK>
  tx_ft_put_policy+0x81/0x130 [mlx5_core]
  mlx5e_xfrm_del_policy+0x36/0x90 [mlx5_core]
  xfrm_policy_kill+0xc3/0x410
  xfrm_dev_policy_flush+0x258/0x360
  xfrm_dev_event+0x2a3/0x3b0
  notifier_call_chain+0x97/0x2b0
  netif_close_many+0x367/0x710
  netif_close_many_and_unlock+0x1d/0x240
  unregister_netdevice_many_notify+0x567/0x2140
  unregister_netdevice_queue+0x29a/0x350
  unregister_netdev+0x18/0x60
  mlx5e_vport_rep_unload+0x20b/0x2b0 [mlx5_core]
  mlx5_eswitch_unregister_vport_reps_blocked+0xb0/0x230 [mlx5_core]
  mlx5_eswitch_unregister_vport_reps+0x2a/0x40 [mlx5_core]
  device_release_driver_internal+0x3b2/0x560
  bus_remove_device+0x2a9/0x510
  device_del+0x3b9/0x990
  mlx5_core_reps_aux_devs_remove+0x135/0x200 [mlx5_core]
  mlx5_eswitch_safe_aux_devs_remove+0xa5/0xd0 [mlx5_core]
  mlx5e_remove+0x10d/0x370 [mlx5_core]
  device_release_driver_internal+0x3b2/0x560
  unbind_store+0xce/0xf0
  kernfs_fop_write_iter+0x3c6/0x5d0
  vfs_write+0x4d9/0xf70
  ksys_write+0xec/0x1c0
  do_syscall_64+0xaf/0x5c0
  entry_SYSCALL_64_after_hwframe+0x4b/0x53
  </TASK>

Fixes: 2ae8c7edea87 ("net/mlx5: Fix Unbinding uplink-netdev in switchdev mode")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Akiva Goldberger <agoldberger@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/eswitch_offloads.c     | 37 +++++++++++++++++--
 1 file changed, 34 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index eb74b6260168..f934cb2b26b0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -4438,15 +4438,36 @@ static bool mlx5_devlink_switchdev_active_mode_change(struct mlx5_eswitch *esw,
 #define MLX5_ESW_HOLD_TIMEOUT_MS 7000
 #define MLX5_ESW_HOLD_RETRY_DELAY_MS 500
 
+/* Unlike mlx5_esw_try_lock(), don't refuse the lock over eswitch users.
+ * Teardown must run even with TC flows still offloaded, as those are only
+ * flushed once the REPs are removed.
+ */
+static bool esw_try_lock_ignore_users(struct mlx5_eswitch *esw)
+{
+	if (!down_write_trylock(&esw->mode_lock))
+		return false;
+
+	if (esw->eswitch_operation_in_progress) {
+		up_write(&esw->mode_lock);
+		return false;
+	}
+
+	return true;
+}
+
 void mlx5_eswitch_safe_aux_devs_remove(struct mlx5_core_dev *dev)
 {
+	struct mlx5_eswitch *esw = dev->priv.eswitch;
 	unsigned long timeout;
 	bool hold_esw = true;
 
+	if (!mlx5_esw_allowed(esw))
+		return;
+
 	/* Wait for any concurrent eswitch mode transition to complete. */
-	if (!mlx5_esw_hold(dev)) {
+	if (!esw_try_lock_ignore_users(esw)) {
 		timeout = jiffies + msecs_to_jiffies(MLX5_ESW_HOLD_TIMEOUT_MS);
-		while (!mlx5_esw_hold(dev)) {
+		while (!esw_try_lock_ignore_users(esw)) {
 			if (!time_before(jiffies, timeout)) {
 				hold_esw = false;
 				break;
@@ -4455,9 +4476,19 @@ void mlx5_eswitch_safe_aux_devs_remove(struct mlx5_core_dev *dev)
 		}
 	}
 	if (hold_esw) {
+		/* Keep mode_lock and reps_lock unnested. The operation flag
+		 * excludes mode users while mode_lock is dropped before the
+		 * REPs removal takes reps_lock.
+		 */
+		esw->eswitch_operation_in_progress = true;
+		mlx5_esw_unlock(esw);
+
 		if (mlx5_eswitch_mode(dev) == MLX5_ESWITCH_OFFLOADS)
 			mlx5_core_reps_aux_devs_remove(dev);
-		mlx5_esw_release(dev);
+
+		down_write(&esw->mode_lock);
+		esw->eswitch_operation_in_progress = false;
+		mlx5_esw_unlock(esw);
 	}
 }
 

base-commit: 513444cc62e231a11c9b15ea88de0890da9b2b4f
-- 
2.44.0

