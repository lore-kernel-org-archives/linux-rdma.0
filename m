Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.40
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793913470;
	b=KR0v4Xfs4BN6NWHMsNZEl/5JxqQSwKVlYdOZ+ddIfLXE9ZuVrSl//s4G6QH5Tit5HTki
	 2oOjkpoAUdu7QN5Q43Rf2eJbNnmtDTYl1zd9Q2fJQFMZu4TUOQuoXFV+nALly6FsiqRVO
	 sp3qMubHL6V3jyKxwBWdSKdvVCpS629BS/OV1TvR2FTGXQvcyEHwq4nbI4gM9qWzfzy7m
	 lzs3TJHBPuMugl2OQBTe0yPzeBvrGs7tnUvaYGQEMFLz0atEgNlX1Oos5f8j6sxD9uuHw
	 iKVXl/mABZS0RgZj0appOgJB9eI0eN5PCr6UL0B/VWvwY+CdOHQU0FESylPV6bKbdIQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793913470;
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
	bh=6TOni624zyu4mtn/IFxxmOT553h99qY6ALsScRbzXUE=;
	b=jSguZhP+N6fyPlE2p9ptnN4/qsgTozW0TKF4QRKuA0AZdJnhBESdv0PQzg75/XnnNnK1
	 NURYBHOKXrT7bqULqWdF0yK2b4h5HarR4DGkNZVksYMx7SQ6ZYl3/b2Q1Zm9zyWIcCy/4
	 Qf3sNgBUjse9VBJKMEM321NdShc0vLd2wV7S4/Cez7BxqRBxJBUobNTv5c7cPXViZ464b
	 qW06ofqraBzdoGJzvLqiqpESC77rI38hZ3gTgCs3KJ5UvOYVPNxzRQGO4MICn2ijpAI1L
	 nyZ531n7ALP6C3Xvmdg6TIOojg+mwdNVFJmoJcHUAqwb9blrxHiyEoMMuSkIJ06ICXQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=h+0CcRAP;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.40
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010040.outbound.protection.outlook.com [52.101.85.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2BA606A337;
	Thu,  5 Nov 2026 21:17:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB2BA606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=h+0CcRAP
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CCZFhrPlEcTgKSYF3zCUW9tQC08SvvaWdVCNB+gbpcmvBokuHLfPMM5vbjku8LpxUQCVr0kkVeCWgTRL3ZP3qY85MSwWwiVRw1+LpZxyZ+dFwiqpzpHMlOVsGN8k1B2KMVSGy+eIXxSmEAhJNjnvSwIbZXmo6Ldfoh11A3Qkaw4g/sSAEB7Dz+uo1Mcux15CG7ya2la5SwwuDBOCS3qVH7opH10uBN3g3XFMmGNQL7/4lvEhOPK0aKQc2kOzKxYIS7OlHxPEZf9REGKUQVziC9UKT62egJq/KVDMgG/rPRLRzBNmt73E/Ii58yftaoeq95UUZ7gZZSUlInQSM9DmYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6TOni624zyu4mtn/IFxxmOT553h99qY6ALsScRbzXUE=;
 b=Q3lqNhywRx7JZ6OFHvUYrLJv+zmpJE1x7P7WyzKrtio+0n/fI+ZKG/RP5IeXCmJ6hQ5blRi4yVIZGJWkZFYAUTfZmlpkeAsvhNiWMbzH8z5rBpIKdDs7JPSjslWVl9fxKUWaUI5rc7wUQanDYXPpeT9AbY9MDfA+BlEbENS4+1TdmTwot9AIoB+CFNtuPgRjUGM+vnNwk5IlnXE/JRdQYA5jPaaTiOwrWrHSe2eGZx6IS3IqbITzqKgc8/kGsOIbzL46SNI+3lwut6VSnWBrvDlBag2t5MHSY0fdxEIhklQlljVOcJNJIP+i9lmSkbM7afNxxFrw0/OQkt13sA8DHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6TOni624zyu4mtn/IFxxmOT553h99qY6ALsScRbzXUE=;
 b=h+0CcRAPQ2seRMJutO6QB8Cw5GghhCJYcNujDSYFesbx5nfIigk+gb3iFDPjyCLl1Sm8ctruhlTAaUA1ahFazc6PEpxorMCTAz3Rsw9npSez/VX/kRxYYBvjp36oQNHbApyNJz/UlAeXv0Zj5kqyZ+v+DaPCMXedJIo3jYG2+D/bQdlgCud+nMO4IJXEwQPCAluwdgeqD4l4WnRfiDx3EW4znHUsEyLNUZDMkkQ1PzqM94QQUi51CzgJv6TsVKMkjxkgZxbZELduFeLJ41I81kfLJrJw5nrXNc+KwoM8yIlwstmrBlkPf2/dXgJlDSQDSVFrgrjUPzkut7LExjfMIw==
Received: from BN9PR03CA0232.namprd03.prod.outlook.com (2603:10b6:408:f8::27)
 by LY0PR12MB639115.namprd12.prod.outlook.com (2603:10b6:404:216::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 5 Nov
 2026 21:17:44 +0000
Received: from BN3PEPF00022BD6.namprd03.prod.outlook.com
 (2603:10b6:408:f8:cafe::67) by BN9PR03CA0232.outlook.office365.com
 (2603:10b6:408:f8::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.10 via Frontend Transport; Thu, 5
 Nov 2026 21:17:44 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN3PEPF00022BD6.mail.protection.outlook.com (10.167.248.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Thu, 5 Nov 2026 21:17:43 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Thu, 5 Nov
 2026 13:17:22 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 5 Nov 2026 13:17:22 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Thu, 5 Nov 2026 13:17:16 -0800
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
Subject: [PATCH net V3 3/8] net/mlx5e: Take HCA devcom lock before esw->mode_lock
Date: Thu, 5 Nov 2026 23:16:31 +0200
Message-ID: <20261105211637.1083978-4-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BD6:EE_|LY0PR12MB639115:EE_
X-MS-Office365-Filtering-Correlation-Id: 6468432c-9012-4215-14b2-08df3b823b89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|1800799024|376014|7416014|23010399003|56012099006|11063799006|5023799004|261009223027099003|261021123027099003|261102123227099003|261021121427099003|261022075727099003|261026140227099003|261026121527099003|261022105027099003|261028144727099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	siW6+msFsoIrafVjXA1oqP9zZDiaqaRDQVxZlJMeyTaaeqIBXmuRH2NjkXBvVcYuLUrB+jYRkmCO3WUx1VfhlC8apEtSqY2JQsP/NG3hqLCoCLtz4OLyZQI6BbEFWwd7IfTa1k8xbbK8UOWFNbt/moArVgGIU+Nm7iPS3wd3HQjdjrZ34rh8Xucc9Ff5YfX88BhaFKMplEVlAwxIR6zD3peni4DzvVfQ7B11IuLHDRjCQng7/NTnEIohELB+ArtXrnPuMZcjyiUizlkNOqnc1bKHYPvfxQTnDIZANVWZ1nOu88X+aPsd73DjbTumGAPSt5bCwjzicsk62Vqfum34VI7ldQHiz7m59KCwh8yyM1tdSbsZvbQkx7/7wNiqshMrazh1gcTdVYYQCDnxnr2C9+9r1toyKbzIGpBEQiOQFSOnhnwjDnJXGSBNPmH+Q+uHw4+0UwYGSg3FnCQm3DyNu2orx6FcYsvCk09i0eUUTL2B3WSJz+/gbKr+AZn4eO71MUEn14TNoAe6qY9vZRLqGotQDaCvok97PIk6V1qYpT0rhXoibxO3WVuhBnkEiu8Uvt6xze4j4yIf5Q1OLjCYlNd9WNeERfSTUVNvIYQGCLTpFRHn/6EtpEGYP00/XOK3amNqzB131Vl58Ti7alYhT3R/GBaIUa5VK0jAUUsb0Tj4jGg04BOXLF24TclB94rbR+WVfJdzuvJN3r8ngzeCCg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(1800799024)(376014)(7416014)(23010399003)(56012099006)(11063799006)(5023799004)(261009223027099003)(261021123027099003)(261102123227099003)(261021121427099003)(261022075727099003)(261026140227099003)(261026121527099003)(261022105027099003)(261028144727099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	uwC8rO+6js0ulqWnBtEd4aZtgl92oPynknwv6jnOyAjRuV42hX0/xOrlBVMFTKIJFXjOXmGVIuXX3m9eMZMeyA6uI6bXBsHdHzYH5VYQRsH1IW6kY4P/T5KXhSgm4SEdchESXP/qfC+o/RHatpZQYslW817Ev3gGmIOVo/R6MVH4x36WnE72J3dMSupNpV6ehx8r5Dm6hDmgLQXh+eu0LBqqqv7RLUGsF1h+JJuCXGFl6xVr5tX6v8Jtfgji6or6ReaRg/itW1sjI2Twl36BpK89Bnvpoq76gq7mhY1BrHZhAgr8I7tP4eZvCFpd/QPjpeNJAGPEuxzRFt9UwkUARiK6kSnxlA7SfEJSP8gmUzakHbIwqh1b+4jqZpPT8rq8bu6tStnW+5JOrKjUB/32QJn1mc6wMWUsi/1LCbaWhaY7iWpHvH0wSF4UyEWlrBXs
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 21:17:43.8638
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6468432c-9012-4215-14b2-08df3b823b89
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BD6.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LY0PR12MB639115

From: Cosmin Ratiu <cratiu@nvidia.com>

Uplink ETH driver removal waits for any eswitch operation in progress
before removing REPs. Removal through mlx5_unregister_device() or
mlx5_detach_device() does this while holding the HCA devcom lock, which
is used by peer devices in the same group.

An E-Switch mode change can therefore race with a Socket Direct
secondary device removal:

T1: primary mode set             T2: SD secondary dev removal
mlx5_devlink_eswitch_mode_set()
  sets operation in progress
                                 mlx5_unregister_device()
                                   mlx5_devcom_comp_lock(hca)
                                   ...
                                   mlx5e_remove()
                                     mlx5_sd_get_adev() -> T1 dev
                                     mlx5_eswitch_safe_aux_devs_remove()
                                       waits for T1's operation
  esw_offloads_start()
    esw_mode_change()
      mlx5_devcom_comp_lock(hca)
        waits for T2's lock

The timeout in mlx5_eswitch_safe_aux_devs_remove() makes this not a
deadlock, but representor removal is skipped in that case which is
incorrect.

This bug was found by Sashiko inspecting the next patch in the series,
which removes the timeout. It wasn't reproduced but the scenario seems
plausible, albeit unlikely. This was undetectable by lockdep because the
down_read_trylock() in mlx5_esw_hold() doesn't register as a lock edge,
and also because it can't see the wait on the flag as a lock edge.

Fix the lock order so the HCA devcom lock is taken in
mlx5_devlink_eswitch_mode_set() before esw->mode_lock and held for the
duration of the mode change.
Expanding the HCA devcom lock critical section implies new lock edges
being added, but this is safe:
- mlx5_devlink_netdev_netns_immutable_set() adds HCA devcom -> RTNL, but
  there's already a HCA devcom -> RTNL dependency in
  mlx5_register_device() -..-> register_netdev()
- esw_offloads_disable/enable() -> esw devcom cleanup/init: adds HCA
  devcom -> esw devcom. Nothing takes the HCA devcom lock while holding
  the esw devcom lock.

Fixes: 2ae8c7edea87 ("net/mlx5: Fix Unbinding uplink-netdev in switchdev mode")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads.c   | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 7a0131e26ff0..4939e10336c2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2457,8 +2457,8 @@ void mlx5_esw_reps_unblock(struct mlx5_eswitch *esw)
 
 static void esw_mode_change(struct mlx5_eswitch *esw, u16 mode)
 {
+	mlx5_devcom_comp_assert_locked(esw->dev->priv.hca_devcom_comp);
 	mlx5_esw_reps_unblock(esw);
-	mlx5_devcom_comp_lock(esw->dev->priv.hca_devcom_comp);
 	if (esw->dev->priv.flags & MLX5_PRIV_FLAGS_DISABLE_IB_ADEV ||
 	    mlx5_core_mp_enabled(esw->dev)) {
 		esw->mode = mode;
@@ -2471,7 +2471,6 @@ static void esw_mode_change(struct mlx5_eswitch *esw, u16 mode)
 	esw->dev->priv.flags &= ~MLX5_PRIV_FLAGS_DISABLE_IB_ADEV;
 out:
 	mlx5_rescan_drivers_locked(esw->dev);
-	mlx5_devcom_comp_unlock(esw->dev->priv.hca_devcom_comp);
 	mlx5_esw_reps_block(esw);
 }
 
@@ -4508,10 +4507,11 @@ int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 		return 0;
 
 	mlx5_lag_disable_change(esw->dev);
+	mlx5_devcom_comp_lock(esw->dev->priv.hca_devcom_comp);
 	err = mlx5_esw_try_lock(esw);
 	if (err < 0) {
 		NL_SET_ERR_MSG_MOD(extack, "Can't change mode, E-Switch is busy");
-		goto enable_lag;
+		goto unlock_hca;
 	}
 	cur_mlx5_mode = err;
 	err = 0;
@@ -4574,7 +4574,8 @@ int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 	esw->eswitch_operation_in_progress = false;
 unlock:
 	mlx5_esw_unlock(esw);
-enable_lag:
+unlock_hca:
+	mlx5_devcom_comp_unlock(esw->dev->priv.hca_devcom_comp);
 	mlx5_lag_enable_change(esw->dev);
 	/* Shared FDB activation is creating LAG which is changing reps. */
 	if (!err)
-- 
2.44.0

