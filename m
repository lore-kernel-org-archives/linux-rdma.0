Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.26
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792697529;
	b=AK9gyhfPQTG4LJihxsBSamm/F+TwzNUcgZD0F5ecZ+X5YMrf6FGnfP2xmhWnceYSYrrs
	 KY68zRuj7F3YeUC7xbt1SHAEtabwfu/88EGspL5TFENL+PynL9DEw675KeagyXE4/ddVx
	 TxU/tn0dmJRa/AGHDDfm+44l+zlHTeyogr0eXZTHmMqcoQxxw0n/Ld9E3aLe7a6UE4gvs
	 raCVPJra+AaIfdIbAWXMjtf8+ITzTSNKReVo6DzH2pN2ACVfErv5bZpSawqRK9LBhr9ma
	 lzcFDFal5NnzPevOD5ElpN2Rbq9cILgEg5SlXi4sxxKEUx78LFeZWTSt4qLXHjw7JLw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792697529;
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
	bh=4Zflp7t0IdD5USXv7J5d95yvWNC37f5KqZlKKVut02U=;
	b=bj8phDuBtN5YBSDPIXY1pOmKKA0iBRSKoF6nqE57Z8/Xi/19+ImkBZWxGKFbOf1dvgrk
	 4rOm4ZK2ZIbFrtQYZHEkdYt2NTodg5zkegS3sexAVMDZln2gN4lbZyywlZum5AMQzyE8G
	 YYPJNr1Rb+uKml7+PoZY8Nn/FG5QXdaFKnVmtipYrBx3Ur6mL84em+1lwRsrGCAeQlubC
	 kOBNCLbVbwr9f6yPuqPXMtCOuFPAro/RiBIddU2dfMHqEw2P5xWns9iM53plBfrGS5s1F
	 ZqLOgNKO+YcbDSLeMW1aBpe7zQBGyZB08pAKTY6hIaVO7BNH1WZd4/fD33Sdpes80fQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=TQjJW1Zv;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.26
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012026.outbound.protection.outlook.com [40.107.209.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA1B60A2619;
	Thu, 22 Oct 2026 19:32:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7EA1B60A2619
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=TQjJW1Zv
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xea58HTCkY0vWimgoVl5xLMARzqLOj0wNNZQf75iHa0RUFSr9YHmjS9ptUaKySWoD/9J/JUfIJhaiPPrjyG+/1AMx2dLxzxBilCYxUEQUce6ef5qoPHU2ku91gUYMpTF/7WUh1ddg7ILt+mwDs8D+lGPPPUaSEJqK1vRF1kHVGdOaRe9ak5ySKUMvjDxd7s7nkZyTxILpTQ7zre3tKtZYyuGv/wBUmbGV4dIKBPL/0mB1Q2N4M2zZhAtCCRq6AIBk4q6k6+Zi7hlvXt0gf0QtJ2x477L8TD9uulb5o960VwFhhUFWkyct/j6qAcziqZmQW9kGP7nr9fcWTB9ku2WZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Zflp7t0IdD5USXv7J5d95yvWNC37f5KqZlKKVut02U=;
 b=wxfTkaRUKTtte6/5czh+47gvOLv0WanNeMIce8ZZAed/IBU0XIlqyDwzzC2+LQpul6TXMao/Jsrvy7RNgAjTvth5vYBKL992htodPd1TiSBSuyRFoZV1iF8jphOeCnXF0s/t1yj7KsgaQ8uty2qJfAb5cQeoxxWaUnoz/05ek6j1mrqXGNFs4EwsGVMzj0FX/ccWwMRRMyDJGDk35EHNQrKPL9XSo8sYMyqWXWO9wsBvNTDFDUPXFJ/EIAEFwd3Q3X917gdRU/dfkrsMHLNjGLscTu9pMEO3FY4vwKQu4du4s5t9lXefQJ351KoNZWhQQ5WpMIdza7RPcE+rVvJZ+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Zflp7t0IdD5USXv7J5d95yvWNC37f5KqZlKKVut02U=;
 b=TQjJW1ZvKE54ArohwEhcqM13zk/Q7/IpGssAmK5sMadyNhcWMe1dpZcIbIXzpZPZteMStKFQT+YFHskpAmf27T9rsU102KxxQksUnw75WxZ83CRbc1HvnaJ5ym2x+OVJRIkX4+iQHmiO9DckdeqcQC1e8QgDcUXC0okMTWqVWRMmvJTkmljLNjgYu3xYF/LpDJC2QQeIYqS1u6q//C2Ckpr+41/hWMakVsqdvKSRFJ2Bun8Xiv6jtF5T2L7jA00/TiSoj3D4Iwvvghapqeod5XWzsLU3mifVZVh3apd+JE8jGwQpfu+27ciHs/OVMVJrjy+b/01I+a92gTKn4cI7bw==
Received: from PH7PR03CA0020.namprd03.prod.outlook.com (2603:10b6:510:339::29)
 by PH7PR12MB9075.namprd12.prod.outlook.com (2603:10b6:510:2f0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Thu, 22 Oct
 2026 19:31:58 +0000
Received: from PH7PEPF00000008.namprd04.prod.outlook.com
 (2603:10b6:510:339:cafe::6) by PH7PR03CA0020.outlook.office365.com
 (2603:10b6:510:339::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.546.17 via Frontend Transport; Thu,
 22 Oct 2026 19:31:58 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 PH7PEPF00000008.mail.protection.outlook.com (10.167.243.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.546.15 via Frontend Transport; Thu, 22 Oct 2026 19:31:58 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Thu, 22 Oct
 2026 12:31:37 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 22 Oct 2026 12:31:36 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Thu, 22 Oct 2026 12:31:31 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, Carolina Jubran <cjubran@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>, Edward Srouji <edwards@nvidia.com>, "Gal
 Pressman" <gal@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Kees Cook
	<kees@kernel.org>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Maher Sanalla <msanalla@nvidia.com>, Mark Bloch
	<mbloch@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shay Drori <shayd@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net V2 4/4] net/mlx5: Lag, save and restore vport max_tx_speed across LAG
Date: Thu, 22 Oct 2026 22:30:53 +0300
Message-ID: <20261022193053.3815866-5-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261022193053.3815866-1-tariqt@nvidia.com>
References: <20261022193053.3815866-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: PH7PEPF00000008:EE_|PH7PR12MB9075:EE_
X-MS-Office365-Filtering-Correlation-Id: 03e23519-1faa-4df6-cc88-08df30732376
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|23010399003|376014|82310400026|1800799024|36860700016|13003099007|261021121427099003|11063799006|261021123027099003|56012099006|261009223027099003|10067099003|18002099003|261022105027099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	k5ktK6KXEK26Bm5Jv01Sw34Bw6ThW3xPDyx4ax08nd7Ix07OeEZ8tPzJuBX1eJ0qwvDwNPE+ewBT+gDjWVVUCvp9o4dfWzkwZP4Ym1rLXWnAA1VEYmxAGAC1SIo87Rh/RWw05xsLtcMjn6ew9YiGsMyksVphh7+sC3xRUzgD6UQ8GOMV5G2c/jMeYEiuBcqWSUaXNrOWueLr2g+7wMtotngsSlE5pq5urcQhjzAg1ZUr94UgCmr1Vhd6xUAAGh2twU3wiXD9FcUdWSoHX/vVnA+mwDsKNMhPsm5256ZnUvUhpYtVjspCCIt9/LZkG2TphPjlSZpyEYWjioBw4W7OoTy5XLKXkvEJyMkbrdUNVBIbIbuNZozBLP8kVTD4nfmqw3nQQ7zKbIzANxU0zvcuP029VKAANW3IGOtWkvGA8eV0+iab5D15QalCmtor1EjNqDwpXEaWRYuTOPRHUEHNiFOcgOzVdQNw+Tf72YPXpTxGQvaVmyyEKGUMThpURYTrQQBbX7tkAVMpIuFnFECa1a/lzrVKd8kArTheMtcCObILodGL8nR6JNzfggft8DbXZIdYCqdHWOjkQR7GUopXqWpRGtkxUjHuua566bqFGM0Zto2IcTnofljihzfXQVlmK4WvpS/mUPHkP2k86u6QfqVFaO31FvaEoiUSVY8TlCKm4z+q6cnXVFFX9JKmAvBE1Q7Vgr/YO6yr8I00gkCIuA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(376014)(82310400026)(1800799024)(36860700016)(13003099007)(261021121427099003)(11063799006)(261021123027099003)(56012099006)(261009223027099003)(10067099003)(18002099003)(261022105027099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	kUZ+QsQxbu8seF8IwStOen3x3ocf8I3NzVndPLvGfIB0oLrnDxLQztyagUHnIXQeaUZikc/77KaXmEJ4mYAnLgh6ta1paAltZ3T/17R79Not3f5DqqIkDXpDoakLSk6bRTiBz/CJy1fbvtjJp0bp6zHnBYgS2k8S0uSIABZZh9Q8L8WYMTmb3GOVTo4GFGPNELj4TQ6nbS2ZkAVgP2aWvXa643PpYizZZUKlaNk72KMcJJSEzNuKj3B/zSRfZ+2cnriwRoGmC7ZiUpwBlge3aNsAuwfq+zsfwYygx6qUg4BoabewKeTWMjw3/WxmvIojEDah36dgdG7+0jrX0jx7Njne5EtqobhYovHmXTUSuzZYUgphQ+LH5aqxOxKtmCINL0klJlEMH8wfMFREEmFrxA6ksseoNMed58strXhlQXAvJbm1e2fmDqK7oYk+M9Ex
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2026 19:31:58.3354
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 03e23519-1faa-4df6-cc88-08df30732376
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	PH7PEPF00000008.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9075

From: Or Har-Toov <ohartoov@nvidia.com>

mlx5_lag_reset_vports_speed() queries the oper link speed at LAG
teardown and writes it back to each vport. When the link is down at
that moment, mlx5_port_oper_linkspeed() returns 0, which FW treats as
"not provided" and ignores, leaving the aggregate rate limit on the
vports after teardown.

Save each vport's max_tx_speed when the vport is enabled, before the
LAG aggregate or a deferred aggregate replay can overwrite it. While a
LAG is active, only a vport with a pending aggregate is saved, as FW
may already hold the aggregate for any other vport. Restore the saved
value per vport at teardown instead of querying the oper speed, and
update agg_max_tx_speed to the pre-LAG value so disabled vports replay
the correct rate when they are later enabled. A vport keeps its
saved value after teardown, as it is the baseline for the next LAG, and
for a disabled vport it is also the pending restore value.

If the max_tx_speed of a vport could not be saved, it stays zero and
mlx5_lag_get_restore_speed() falls back to a link-derived speed at
teardown. The aggregate is still applied to such a vport.

This also covers the case where the oper speed query fails and the PF
is skipped entirely, leaving the aggregate in FW and in
agg_max_tx_speed, as raised in the AI review of v1 of "net/mlx5: Lag,
reset vport speed on teardown". It is unrelated to that patch, so it is
fixed here separately.

Firmware never returns zero as a configured max_tx_speed; zero means
"not supported", so using it as a sentinel for "not yet saved" is safe.

A vport disabled for the entire LAG period was never assigned a
per-vport rate limit, so no original speed exists to restore; deferring
through agg_max_tx_speed on re-enable is correct.

Fixes: 50f1d188c580 ("net/mlx5: Propagate LAG effective max_tx_speed to vports")
Link: https://lore.kernel.org/all/20260915015118.875210-1-kuba@kernel.org/
Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 22 ++++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  1 +
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 68 ++++++++++++++++---
 3 files changed, 81 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index fc197d1dc9df..7cf9c15ec65d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -935,6 +935,27 @@ static void esw_vport_cleanup(struct mlx5_eswitch *esw, struct mlx5_vport *vport
 	esw_vport_cleanup_acl(esw, vport);
 }
 
+static void mlx5_esw_vport_save_max_tx_speed(struct mlx5_eswitch *esw,
+					     struct mlx5_vport *vport)
+{
+	u16 op_mod = MLX5_VPORT_STATE_OP_MOD_ESW_VPORT;
+	int ret;
+
+	if (!MLX5_CAP_ESW(esw->dev, esw_vport_state_max_tx_speed) ||
+	    vport->vport == MLX5_VPORT_UPLINK || vport->max_tx_speed)
+		return;
+
+	if (mlx5_lag_is_active(esw->dev) && !vport->agg_max_tx_speed)
+		return;
+
+	ret = mlx5_query_vport_max_tx_speed(esw->dev, op_mod, vport->vport,
+					    true, &vport->max_tx_speed, NULL);
+	if (ret)
+		mlx5_core_dbg(esw->dev,
+			      "Failed to save vport %d max tx speed, err=%d\n",
+			      vport->vport, ret);
+}
+
 static void mlx5_esw_vport_set_max_tx_speed(struct mlx5_eswitch *esw,
 					    struct mlx5_vport *vport)
 {
@@ -999,6 +1020,7 @@ int mlx5_esw_vport_enable(struct mlx5_eswitch *esw, struct mlx5_vport *vport,
 	esw->enabled_vports++;
 	esw_debug(esw->dev, "Enabled VPORT(%d)\n", vport_num);
 
+	mlx5_esw_vport_save_max_tx_speed(esw, vport);
 	if (vport->agg_max_tx_speed)
 		mlx5_esw_vport_set_max_tx_speed(esw, vport);
 done:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 8b1f93b13ea9..3717fb6de0b6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -261,6 +261,7 @@ struct mlx5_vport {
 	int index;
 	struct mlx5_devlink_port *dl_port;
 	u32 agg_max_tx_speed;
+	u32 max_tx_speed;
 };
 
 struct mlx5_esw_indir_table;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index afe0b9909f2d..3e623c96b2a1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -1712,11 +1712,37 @@ void mlx5_lag_set_vports_agg_speed(struct mlx5_lag *ldev)
 	}
 }
 
+static int mlx5_lag_get_restore_speed(struct mlx5_core_dev *mdev,
+				      struct mlx5_vport *vport, u32 *speed)
+{
+	u32 pci_bw;
+
+	if (vport->max_tx_speed) {
+		*speed = vport->max_tx_speed;
+		return 0;
+	}
+
+	*speed = 0;
+	mlx5_port_oper_linkspeed(mdev, speed);
+	if (!*speed && mlx5_port_max_linkspeed(mdev, speed))
+		return -ENODATA;
+
+	pci_bw = pcie_bandwidth_mbps(mdev->pdev);
+	if (pci_bw)
+		*speed = min(*speed, pci_bw);
+	*speed /= MLX5_MAX_TX_SPEED_UNIT;
+	return 0;
+}
+
 void mlx5_lag_reset_vports_speed(struct mlx5_lag *ldev)
 {
+	u16 op_mod = MLX5_VPORT_STATE_OP_MOD_ESW_VPORT;
 	struct mlx5_core_dev *mdev;
+	struct mlx5_eswitch *esw;
+	struct mlx5_vport *vport;
 	struct lag_func *pf;
-	u32 speed;
+	u32 restore_speed;
+	unsigned long i;
 	int pf_idx;
 	int ret;
 
@@ -1728,17 +1754,39 @@ void mlx5_lag_reset_vports_speed(struct mlx5_lag *ldev)
 		mdev = pf->dev;
 		if (!mdev)
 			continue;
-
-		ret = mlx5_port_oper_linkspeed(mdev, &speed);
-		if (ret) {
-			mlx5_core_dbg(mdev,
-				      "Failed to reset vports speed for device %s. Oper speed is not available (err=%d)\n",
-				      dev_name(mdev->device), ret);
+		esw = mdev->priv.eswitch;
+		if (!esw || !MLX5_CAP_ESW(mdev, esw_vport_state_max_tx_speed))
 			continue;
-		}
 
-		speed = speed / MLX5_MAX_TX_SPEED_UNIT;
-		mlx5_lag_modify_device_vports_speed(mdev, speed);
+		mutex_lock(&esw->state_lock);
+		mlx5_esw_for_each_vport(esw, i, vport) {
+			if (!vport || vport->vport == MLX5_VPORT_UPLINK)
+				continue;
+
+			if (!vport->enabled) {
+				vport->agg_max_tx_speed = vport->max_tx_speed;
+				continue;
+			}
+
+			if (mlx5_lag_get_restore_speed(mdev, vport,
+						       &restore_speed)) {
+				vport->agg_max_tx_speed = 0;
+				continue;
+			}
+
+			ret = mlx5_modify_vport_max_tx_speed(mdev, op_mod,
+							     vport->vport,
+							     true,
+							     restore_speed);
+			if (ret) {
+				mlx5_core_dbg(mdev,
+					      "Failed to restore vport %d max tx speed, err=%d\n",
+					      vport->vport, ret);
+				continue;
+			}
+			vport->agg_max_tx_speed = 0;
+		}
+		mutex_unlock(&esw->state_lock);
 	}
 }
 #endif
-- 
2.44.0

