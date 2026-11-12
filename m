Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.58
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794583292;
	b=zf9fUHWJbRd1WTGsuax+AEVO1Oc8mw0eb6hRs8D9WiyYch7/e9fyZpZQ1/J5NR+FQud3
	 diPV0+/AdwY1ku5OPF7T/TCFMuwZzAPRTeX4JPG37Kq0ZmB0LgPS2wqfZ87nc+lJppQNj
	 ItxJJdeQxGikqWDMx/FOS3Zf8baEn3y5+BFRpaw8/qXfM2Wr5x2mBKF1gPzK1O4k5ttIc
	 jyK2W2BrGEfph2vPNSM1bmcRuUjc5z02p2Dn6fSBGiuEzdj0XrLaHA9G7Nr2KFCbrSxFz
	 L7UiTJfBos6xiD26qJZsp4HluyK7tk4mHUl5GnYXRCh1ujRbGiv/3+ynapRh7YnDw5A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794583292;
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
	bh=GR7i1aZF6ZRmVPAkBM4FUG+yKRirS5pP6HwmY/3eAOQ=;
	b=phe8M7EwqWesFh1dReKasU0CAPfFTeb31C4CPN1MFz+5j9G1EkIeg3leFeyQ+eNmJ6Up
	 yO5GA4BTvu8ac6sPYbB1AFVjSzXmtHkntvkILmBh9tYdgtRoUaCY/pcahssPXYHY46Tc6
	 rcU9lTakAjUXL/9Di6lXt9NkMWi/3/4PXguV7E8TGcbIPNHnNy63ifX1gqdyuALya7que
	 Y+H0yWmyQtFJ6lBzyMnc8FtL1XYzbvYA5DFe9sdybmt1r2sIFN112jIgrGVSuGJ/WuEDq
	 5/WU+COeNebvC0kT9sj9SzDuLQjQI/cO+detSRoclalN5XlDMLu79TiGuwa+rZd/qeA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=uqBINAzn;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.58
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010058.outbound.protection.outlook.com [52.101.193.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E776606A323;
	Fri, 13 Nov 2026 15:21:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4E776606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=uqBINAzn
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F/aZEQ7O46v5HUTaRaFjiZVuVW9Ll69lcgyN3EkPHGHOVPK1t/MvdZVLZ6ybJDbvQp7X7oYCV9xagOhywqdlUUXjfUTT6ft0cI0V/JOkDa3JS1tVwCvfCkEZJmfVZ5BaHwqtOEq2RDa/MzaAkbBVpYqBbne6mU2uVd/fcfeebemUx8+X24hHJFybwMmaWzLYza3/Wzd9H90pj7N3DZIE+PdWo1cfSW13bESn6GLScAmaR4WVExB4XB8Iy9lLurZu1nSSas/v28BjpMD8dV4PQRqmsk9OkLYAoh5brGF5hUSVy9meA+yFUmY3Saz8HnaVEnc+lTJCxQpsAo2y9zD7og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GR7i1aZF6ZRmVPAkBM4FUG+yKRirS5pP6HwmY/3eAOQ=;
 b=anQmYFcOacjl6asfk4JA8qwUpZj/3ho0vgXKLQOgbQUgkME7OMxjOQnu6kWmxQauZWilPFmUYMPVbbLXSP5LamD9FYz3DYq7HZi31ghAsXOvgG0MIH+TldODpz/VSTOQMcUsKegs6mvMEgK40U4Zl1SzrnsS8IcGZIDweDnEltxyRbyfxoV2wbEATBvVy8V9Ug0T5yRmPJetJWOFwDrmwWLpNfxgpdaT84DGQs73sEG+w+mWDuKRqVqhspEA1TT+p3Czp9qFVCPtW1OBF7V7UT4lk3ugApC6xDuVLNFtAv6a9lXXb+tlbiUxJ2FE0D80xNNKEBpwRfIBcZBLQ1RSmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GR7i1aZF6ZRmVPAkBM4FUG+yKRirS5pP6HwmY/3eAOQ=;
 b=uqBINAznoWJh2P/5rIvxDbVJU4uYWZmJDrtCIZ16RVWtX7URvqZ0E5SU2w4ejD7/rRoJO5kkVKVHHTOshVj6C8uNdT/Dzju35XPhcSIgYkne+VTznpIzZ4fbVKvveZTQfO99f2giB9I+ffzJj7DIDneaHmNJHMoR5/6gaiuUhBZzWhm2Ezg+uBXFSJ2EjKptQoPAkAACLD62+6jniTlqr+UBR9dCqdoAvuKRnlyjASnHTKA/Yc528somhFUqNw/BwJ7AXVxCy48ELpJISsvSaDaF+5y0YMC2s8q/gaNEUVnQ5klWOUEGQeKcERaNf8oiA2ZPuQId6YH9z804bbrVtg==
Received: from PH7PR17CA0050.namprd17.prod.outlook.com (2603:10b6:510:325::22)
 by MW4PR12MB7430.namprd12.prod.outlook.com (2603:10b6:303:224::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Fri, 13 Nov
 2026 15:21:20 +0000
Received: from PH1PEPF00062F25.namprd02.prod.outlook.com
 (2603:10b6:510:325:cafe::79) by PH7PR17CA0050.outlook.office365.com
 (2603:10b6:510:325::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.10 via Frontend Transport; Fri,
 13 Nov 2026 15:21:20 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 PH1PEPF00062F25.mail.protection.outlook.com (10.167.243.54) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Fri, 13 Nov 2026 15:21:19 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Thu, 12 Nov
 2026 10:24:15 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Thu, 12 Nov
 2026 10:24:14 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Thu, 12
 Nov 2026 10:24:10 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>, "open
 list" <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, "Mark
 Bloch" <mbloch@nvidia.com>, Mark Zhang <markzhang@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drory
	<shayd@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net V2] net/mlx5e: rep, Fix races between devcom PAIR event and uplink close
Date: Thu, 12 Nov 2026 20:24:03 +0200
Message-ID: <20261112182403.3646298-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: PH1PEPF00062F25:EE_|MW4PR12MB7430:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d8d012f-715b-40c3-ff01-08df4199c4fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|376014|1800799024|82310400026|261009223027099003|10067099003|261026140227099003|11063799006|261021121427099003|56012099006|261021123027099003|261022105027099003|261102123227099003|261026121527099003|261028144727099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	XCPm6mkzSuR3H+QHlFa50y8d92OVI4899BvuIrzHVNz0l+SbRkJulKM9Qqd/mIr+rVjnHCOIWhUGsFXdBtfUj2/SOaZiRX9HYu54RXt5cH9i56hn3Zmn8stxxyeYFvj26bAYFPSxALvbRtJIVokKtXOoMdw9RB1HMXvX6yHmiDlxsX0XV5YUGQGkoMjRdv34C9SdPoZdBgfKdPAukgN3gHSzCreWzmpb6Ch6NvK/58CNCn9DQ+plDqSdSt97w3MUZfzF6KPWC3gESDeZOc08KSahG9/ZlqtDP1il6MorDd6jsMwzE+Lsi+Ccv6rj/QG7xJ7VZu99miA+FhDk+VU7JZ2YgYZ8HiNC+te8tUnX2b4EWoqdpbifiTLzcrN3MzjHUQDwzRqGPqKXddMLJyD21AFLCJhCJxjl84HNZTR6FjIVroMcsnWPDM3wix+dyS3xGoH/wnVyyqFZyr0He9/5WM70mNOkhuPV0ZxvGeiwFNXLh4IE/8ZodClJn8qDVQ+Z1lbWIxQfdOwxNM+gcqeBXvexf9+ZcD0vcsVCH95wwqYSKlWMfXXAGY7Csu6H7eh6ROVa3XztTq79mq79DyaI0LP/eUc+HRsLfhQcgmKT/q89QncJI/nSfEZc02ZK/goPInVcU4oScq61E/A/+3EFTtZFs1E7DVdOFoS2VqojVcVDXsvz+zEmVAR1Ja4XVqfeXIaPLRDDhzxR0trCA+qnZA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(376014)(1800799024)(82310400026)(261009223027099003)(10067099003)(261026140227099003)(11063799006)(261021121427099003)(56012099006)(261021123027099003)(261022105027099003)(261102123227099003)(261026121527099003)(261028144727099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	iFA3JB8oa8Y49ECymv7whJnGxe7erf+LE0BcAmSnpOhGCd2IXcF+HxWY7tC0aX3km5Jm4bdMimvCrfmfqKtrsgX0mIcsUFzTkQ8MwmCeSwkJoU4GNNSWBW5P3ittAdtfQ6o4K66OOzpXJoWzM3atoDpQhrTVRskYvZ0McceIf4b51M4pBVkt4jfFQquTD8rZ9UR17IIVnJbDv17ypn8meBWvsVYBBZmdtHGcl4ibLRBNVf+8PFslT1Fo/gd2IRQAiKIDqzlql1sPY2aGwr5sF2DVIdfAWKUg7pM7z+vm3hpk66XKG0iVSne6CvUk+mYPb5pASGXN3lsPkY9JlBWUk6fmYt18e6l0e4PAHOTjqhZzMSJn3hukrXvy2R4CUtOKGyBdRQN5p3068usK0HsSpbmAJWC1zn0LgFlacrsTdt76GFPUmOhxEk1QpcTpDgx7
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 15:21:19.9435
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d8d012f-715b-40c3-ff01-08df4199c4fa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	PH1PEPF00062F25.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7430

From: Shay Drory <shayd@nvidia.com>

mlx5e_sqs2vport_stop() frees each rep_sq and its per-peer send-to-vport
rules (rep_sq->sq_peer) while holding only the uplink's priv->state_lock
(it runs from the ndo_stop -> mlx5e_deactivate_priv_channels ->
mlx5e_rep_deactivate_channels path).

The same rep_sq->sq_peer entries are inserted and erased by the devcom
ESW_OFFLOADS PAIR/UNPAIR handler (mlx5e_vport_rep_event_pair/unpair),
which runs under the devcom component write semaphore and takes no
state_lock. The two lock sets are disjoint, so closing the uplink of one
eswitch can run concurrently with a pairing/unpairing event driven by
the peer eswitch, both mutating the same rep's vport_sqs_list / sq_peer.
This is a use-after-free: one side frees rep_sq / sq_peer while the
other walks the list or inserts/erases the xarray.

The add side (mlx5e_sqs2vport_start) is not safe either. It takes the
devcom read semaphore only via mlx5_devcom_for_each_peer_begin(), which
is gated on comp->ready. The PAIR handler does all of its rep work
before setting ready, so a first-time PAIR runs with ready == false and
start can list_add() into vport_sqs_list while the handler walks it.

Add mlx5_devcom_comp_read_lock/unlock(), which take the component
semaphore for read regardless of ready, and hold it across both
mlx5e_sqs2vport_start() and mlx5e_sqs2vport_stop(). Start still adds
peer rules only when the component is ready, now checked under the
lock.

Lock ordering is preserved: start already took state_lock -> comp->sem
(read); stop now does the same. The event handler takes comp->sem and
never state_lock, so there is no inversion.

Fixes: 898b07861565 ("net/mlx5: Add send to vport rules on paired device")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 21 ++++++++++---------
 .../ethernet/mellanox/mlx5/core/lib/devcom.c  | 14 +++++++++++++
 .../ethernet/mellanox/mlx5/core/lib/devcom.h  |  2 ++
 3 files changed, 27 insertions(+), 10 deletions(-)

V2:
- Add mlx5_devcom_comp_read_lock/unlock() and use them instead of the
  ready-gated mlx5_devcom_for_each_peer_begin/end(), so the PAIR handler
  is excluded even while comp->ready is false.
- Apply the same locking to mlx5e_sqs2vport_start(), whose list_add()
  could race a first-time PAIR.
- Read esw->devcom once so lock and unlock use the same pointer.
- Update the Fixes tag to 898b07861565.

answer to Sashiko comment:
The esw->devcom lifetime race with mlx5_esw_offloads_devcom_cleanup() is
pre-existing and not specific to the close path: mlx5e_sqs2vport_start()
and other users (en_tc, esw bridge, shared_fdb) dereference esw->devcom
the same way without serializing against devcom cleanup. It needs its own
fix and is out of scope for this patch.

V1:
https://lore.kernel.org/all/20261015085744.1109107-1-tariqt@nvidia.com/

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index a50a42581528..962c70b9b566 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -506,10 +506,11 @@ static int mlx5e_sqs2vport_start(struct mlx5_eswitch *esw,
 				 struct mlx5_eswitch_rep *rep,
 				 u32 *sqns_array, int sqns_num)
 {
+	struct mlx5_devcom_comp_dev *devcom = esw->devcom;
 	struct mlx5_flow_handle *flow_rule;
 	struct mlx5e_rep_priv *rpriv;
 	struct mlx5e_rep_sq *rep_sq;
-	bool devcom_locked = false;
+	bool peers_ready;
 	int err;
 	int i;
 
@@ -518,9 +519,8 @@ static int mlx5e_sqs2vport_start(struct mlx5_eswitch *esw,
 
 	rpriv = mlx5e_rep_to_rep_priv(rep);
 
-	if (mlx5_devcom_comp_is_ready(esw->devcom) &&
-	    mlx5_devcom_for_each_peer_begin(esw->devcom))
-		devcom_locked = true;
+	mlx5_devcom_comp_read_lock(devcom);
+	peers_ready = mlx5_devcom_comp_is_ready(devcom);
 
 	for (i = 0; i < sqns_num; i++) {
 		rep_sq = kzalloc_obj(*rep_sq);
@@ -541,7 +541,7 @@ static int mlx5e_sqs2vport_start(struct mlx5_eswitch *esw,
 		rep_sq->sqn = sqns_array[i];
 
 		xa_init(&rep_sq->sq_peer);
-		if (devcom_locked) {
+		if (peers_ready) {
 			err = mlx5e_sqs2vport_add_peers_rules(esw, rep, rep_sq, i);
 			if (err) {
 				mlx5_eswitch_del_send_to_vport_rule(rep_sq->send_to_vport_rule);
@@ -554,16 +554,13 @@ static int mlx5e_sqs2vport_start(struct mlx5_eswitch *esw,
 		list_add(&rep_sq->list, &rpriv->vport_sqs_list);
 	}
 
-	if (devcom_locked)
-		mlx5_devcom_for_each_peer_end(esw->devcom);
+	mlx5_devcom_comp_read_unlock(devcom);
 
 	return 0;
 
 out_err:
 	mlx5e_sqs2vport_stop(esw, rep);
-
-	if (devcom_locked)
-		mlx5_devcom_for_each_peer_end(esw->devcom);
+	mlx5_devcom_comp_read_unlock(devcom);
 
 	return err;
 }
@@ -630,8 +627,12 @@ mlx5e_remove_sqs_fwd_rules(struct mlx5e_priv *priv)
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct mlx5e_rep_priv *rpriv = priv->ppriv;
 	struct mlx5_eswitch_rep *rep = rpriv->rep;
+	struct mlx5_devcom_comp_dev *devcom;
 
+	devcom = esw->devcom;
+	mlx5_devcom_comp_read_lock(devcom);
 	mlx5e_sqs2vport_stop(esw, rep);
+	mlx5_devcom_comp_read_unlock(devcom);
 }
 
 static int
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c
index 75855481522b..aed9e2a74162 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c
@@ -456,6 +456,20 @@ void mlx5_devcom_comp_unlock(struct mlx5_devcom_comp_dev *devcom)
 	up_write(&devcom->comp->sem);
 }
 
+void mlx5_devcom_comp_read_lock(struct mlx5_devcom_comp_dev *devcom)
+{
+	if (!devcom)
+		return;
+	down_read(&devcom->comp->sem);
+}
+
+void mlx5_devcom_comp_read_unlock(struct mlx5_devcom_comp_dev *devcom)
+{
+	if (!devcom)
+		return;
+	up_read(&devcom->comp->sem);
+}
+
 int mlx5_devcom_comp_trylock(struct mlx5_devcom_comp_dev *devcom)
 {
 	if (!devcom)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.h
index 7a704fafdbd3..94b0fe20cc26 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.h
@@ -79,6 +79,8 @@ void *mlx5_devcom_get_next_peer_data_rcu(struct mlx5_devcom_comp_dev *devcom,
 
 void mlx5_devcom_comp_lock(struct mlx5_devcom_comp_dev *devcom);
 void mlx5_devcom_comp_unlock(struct mlx5_devcom_comp_dev *devcom);
+void mlx5_devcom_comp_read_lock(struct mlx5_devcom_comp_dev *devcom);
+void mlx5_devcom_comp_read_unlock(struct mlx5_devcom_comp_dev *devcom);
 int mlx5_devcom_comp_trylock(struct mlx5_devcom_comp_dev *devcom);
 void mlx5_devcom_comp_assert_locked(struct mlx5_devcom_comp_dev *devcom);
 

base-commit: b71c101bbb9814d163c00234d43c41f0a17907d4
-- 
2.44.0

