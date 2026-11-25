Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.62
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795641681;
	b=TG4kKzjnYLpUe1qWC6NzZlAb2oF8b0mX1sIxSBLoQGwXwCTn0uXTvWdWN+ytmpClTtJF
	 6wowusEEo5JBHMJGNcOhIr5RAB4gfKvm4S/xyFUy0z9BgDwcCd/P/iLThnovhsxaxDZRk
	 T07dlpLkgrur90mFjs6vLp/uPyQ5kttcVugVGhNMWOJNZfKwKymrC7iwl/XdpSLCFZtZD
	 S4wpnSRRghI2hjvdNG8KEdR9BYoy8ChDmWfg+LRxhgzjNaaOj1OUawX3a+YrutV6YN+KW
	 cVY4PNhpm9UftNJEz3kPAHpDhZCzQ6G66UChxwpFE/B2YAkWCqv/JFt5kNVwjmTsLIQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795641681;
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
	bh=pl1pOro8wy79umyXawz1r+4/AbljvnhvaPGU2SJGrG0=;
	b=ADdBMkoZPivNcrWdUWuMb0sPXSoBMaFCuUAcOLd8+AAAYtR+Y4xSF25qUvaLxTb1YFJj
	 t3aotUXmuC4Cuns+YKS8eugWZBygh/kmGjS88AGCDjcVdskLmosrDMhWHSDbxQYBtCyj2
	 qyBwR7Ln05589brogBdZ3EaRTBCkXbONUN2eMN0MrIXkwhBo+qgRfK7Oejprmw4LHNT8P
	 egY2jqc71g1w9u1SnfmFYVwdwbnEtgX6wUXB1iShKVLtvaiWzYXCmCvSqvuXD9c/M5uWR
	 x+pX7GHYemAkME5z4UyXK53iX4xQJoAq8ZsUlxOWfvSB6srjwSMiSXiGYsFfZQFVFoQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=R64ftbog;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.62
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011062.outbound.protection.outlook.com [52.101.52.62])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B0B606A31E;
	Wed, 25 Nov 2026 21:21:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 26B0B606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=R64ftbog
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j1JocPKMHHDTmV0GjIqK5fzAcb3768vplrhKkjNh9uNUPZEhKTnh3638ubiv6/likEsNDBKXRbqF866wV/mOKq+b4Rp5HZp1+3j4wmHRHpTum7mb6Ni82KCUkbLx+APCnlbUl0adw3ApbPDRL5ngYJa4vRsr9l/L/A/GoQEmc/NdhlQU41mcrPvrh25irg/rGBoVw/1ZxEmp+DAlD3D8DyhrKkFH1EPJQETbB3LzSXjyb5/Go2MGD6kQkGijrIyoMP4GXeoy5f9BHXMMuA/B3uvnWnTEiwAmu5sRu0Z89wwBPn8OjiNL7xxMaVEdumtn1Q4vBCmEKdcUqyYQsWeWRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pl1pOro8wy79umyXawz1r+4/AbljvnhvaPGU2SJGrG0=;
 b=Yyi1KNCGiiz/J73LkJ8W3dACiVfRKyZcOtNshJ1AQ2an7I/uiwQa8OkPYgd9CTbCWOWlWFHt9cG6oJg1yfRG+sSVEBMCn5w6FxzJE8qqRJZgaRYpoPLH/2R8kKXTl3OFlUHH2izyb1EJZkGNGYt1CMJRKFaJ7FIAZrWxc6unbc7HT5qmyRq97Yt5lpQsvhCgiTpJafSQo0DBzjVOWGAxq0kdbgudhE4NcbdgYlOJ1MjsGnbfVNyR/eNxW224Xzd9fzTHWv3m3P6BCP3+yF31m8wAdqztxpikFroAEagL2EJrwQlT9xmbWq351a88csIWUjApsERZoXSCBxiIAX5OCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pl1pOro8wy79umyXawz1r+4/AbljvnhvaPGU2SJGrG0=;
 b=R64ftbogpXe/ShRynSEc98MSKWJPB9bOYEkAdTxg5TphHdIZUeypKYz+H96fFnlKzRZmIGlz65r0iKiipdLYr4JDsDTPtrObbjODN++oOYsu2Sv4nPlUmzRpetQ/j3CcBq50MpWhDpdMGMdNmbVGjjUt3O1CdLTzm7I5L6tSt1H1aqFC8hczp5Kos1ce3yMfh6EeFuqeT0Kl0rmbLivycvsx+YqBEmzd6LKmXGcN1gfM/dQBHO45cnXHVptdM8P4CKHw4+Qb6UhhDklpLyyNk9+6rhdQiwOPX8fp1YAELKTFRnOhXL+s8iVPZ3ZynrrV9yYON+r2hi6tMRfeeqUSKw==
Received: from BN1PR10CA0011.namprd10.prod.outlook.com (2603:10b6:408:e0::16)
 by CH8PR12MB9765.namprd12.prod.outlook.com (2603:10b6:610:264::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Wed, 25 Nov
 2026 21:21:12 +0000
Received: from BN3PEPF00022BDA.namprd03.prod.outlook.com
 (2603:10b6:408:e0:cafe::5f) by BN1PR10CA0011.outlook.office365.com
 (2603:10b6:408:e0::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.7 via Frontend Transport; Wed, 25
 Nov 2026 21:21:12 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN3PEPF00022BDA.mail.protection.outlook.com (10.167.248.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.3 via Frontend Transport; Wed, 25 Nov 2026 21:21:12 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 25 Nov
 2026 13:20:46 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 25 Nov
 2026 13:20:46 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.57 via Frontend Transport; Wed, 25
 Nov 2026 13:20:41 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Carolina Jubran <cjubran@nvidia.com>, Chris Mi <cmi@nvidia.com>, "Gal
 Pressman" <gal@nvidia.com>, Kees Cook <kees+treewide@kernel.org>, "Leon
 Romanovsky" <leon@kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Or Har-Toov
	<ohartoov@nvidia.com>, Parav Pandit <parav@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shay Drori <shayd@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net-next 1/2] net/mlx5: SF, Pass pfnum through the SF hardware-table allocation path
Date: Wed, 25 Nov 2026 23:20:31 +0200
Message-ID: <20261125212032.243064-2-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261125212032.243064-1-tariqt@nvidia.com>
References: <20261125212032.243064-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BDA:EE_|CH8PR12MB9765:EE_
X-MS-Office365-Filtering-Correlation-Id: 4bb39ab1-d87e-4f12-bfee-08df4b3a0819
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700016|23010399003|261009223027099003|18002099003|22082099003|261021121427099003|56012099006|11063799006|10067099003|261022105027099003|261028144727099003|261102123227099003|261026130827099003|261026135527099003|261022075727099003|261022113327099003|261021133027099003|261021130227099003|261021135927099003|261026121527099003|261022115727099003|261021123027099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	RL4COON98/LphAeQbZCOCvaCBKHEA+/RPqVzOj08/V3R0A5LkYWlfYi2K/9eI8Ei3LYEQRp2IEcbPj0n/rZa3aBPy4Vn1Gmb7T6TCMO2CAyTkCpeeuUaOvLf/3186Qso9BU0rgkBS4a329jJihaWwg/57tdEPOzmviwaCa8JcmiH3clsGZL3zU1oRcbQHx/ElpLiht16sxgp5CdEm9DSUeezutmMpc7b+Wskokk9MPKxnuX9hzb3QRoH07KITZYqCcRNZNClTkEe35INc9BIeSPVP3M6+i/WdksqKpgA/hnp68D4pZmTGwoAlR+gvFgZLhjjrrrpIdtPapnFwaBFN7r9TIsoLRwggnMisD2b2fBRvejS4IFiHA4FB/ENwVi+OWbLy1PFl7n8Mq0jUSN4LfAvjNfO1s6tas2l0Y2sLcwYp5e8nyUuk7FjNLd+70f6R4T8jtI8kvas2/klK1q15jUpLOqO4F5eO+zc48bZNYaBeRrKv/oA/OApWTcvJ1SIfgAOyFZPrmd1mLPxEKd2EIUqhhVf0hTnDvYwW1MxRBc74sPfPs4Lf8GcqVbMpALdBcY2IdXMqa1vaBYHFNvIZ4J48qRMWUCNO/2ioewmAgRkQ6WtXN6D8oi8lZ0SDuws9r5LyZ3A23FfO5lg/zHAyz221VzlSNTy3gdZXsif2k9WSo1MkAIfFkZQ7zN3UkWq4e971rmlf7wsQJXq8RtGcg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700016)(23010399003)(261009223027099003)(18002099003)(22082099003)(261021121427099003)(56012099006)(11063799006)(10067099003)(261022105027099003)(261028144727099003)(261102123227099003)(261026130827099003)(261026135527099003)(261022075727099003)(261022113327099003)(261021133027099003)(261021130227099003)(261021135927099003)(261026121527099003)(261022115727099003)(261021123027099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	3DIU48TpNPqT/yrqoUBLBrdDNVRAecbGa36dana1m9X/06ISaG4Egq4EViiEbpq9sxsG9csScTO3ERpNGamp89qaKs89g6XCmPZdmkwNYGBh0kmcf2mXQpFtMllg2Flo/2w0IVjx3n0tYlcaMh1H4RBg2PNoN1O7Jz9PycxT9Y69PxxQ2ll5uUK7TgVr9xfm8cRk4XhdlykysIvCrhkdNa44/C2y0am243Waobl+QFDX1nPwopEoS9SkG1w+nm9AajTCefw5LclvjNVJM6kpCHKGGGxOWtrENku5ZcVcrzIaI8xIt/WoupBydZFXbzlpf9yDe2bgaP+GMuYnrI0j5FIqaT11RyKEr+v2BGBMszc1A6OWkmj5zzNzksVDpedS4wTZkAB2kPLePeaXEYiYOPVtdVODFEUWn3EoJ5yT6LSP/SdhrsIrg/aG7A3/kE0a
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 21:21:12.3535
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bb39ab1-d87e-4f12-bfee-08df4b3a0819
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BDA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR12MB9765

From: Chris Mi <cmi@nvidia.com>

Add a pfnum parameter to the SF allocation/free call chain and store
it on struct mlx5_sf as pf_num, set alongside controller in
mlx5_sf_alloc(), so free/dealloc can resolve the same hwc table that
was used at allocation time.

This is plumbing only. pfnum isn't used for hwc selection yet, and
controller/pfnum validation is unchanged. It prepares the SF hw-table
code to distinguish SFs created on the self PF from SFs created on a
satellite PF sharing the same controller number, implemented in
"net/mlx5: Add controller number for SF and ECVF phys_port_name"
later in this series.

Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/esw/devlink_port.c     | 20 ++++++----
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  6 ++-
 .../net/ethernet/mellanox/mlx5/core/eswitch.h | 14 ++++---
 .../mellanox/mlx5/core/eswitch_offloads.c     |  9 +++--
 .../ethernet/mellanox/mlx5/core/sf/devlink.c  | 31 ++++++++++-----
 .../ethernet/mellanox/mlx5/core/sf/hw_table.c | 39 +++++++++++--------
 .../net/ethernet/mellanox/mlx5/core/sf/priv.h | 12 ++++--
 7 files changed, 82 insertions(+), 49 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
index fdc960ea5331..8b46634203b3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
@@ -148,16 +148,16 @@ static const struct devlink_port_ops mlx5_esw_pf_vf_dl_port_ops = {
 	.port_fn_max_io_eqs_set = mlx5_devlink_port_fn_max_io_eqs_set,
 };
 
-static void mlx5_esw_offloads_sf_devlink_port_attrs_set(struct mlx5_eswitch *esw,
-							struct devlink_port *dl_port,
-							u32 controller, u32 sfnum)
+static void
+mlx5_esw_offloads_sf_devlink_port_attrs_set(struct mlx5_eswitch *esw,
+					    struct devlink_port *dl_port,
+					    u32 controller, u32 pfnum,
+					    u32 sfnum)
 {
 	struct mlx5_core_dev *dev = esw->dev;
 	struct netdev_phys_item_id ppid = {};
 	u32 hpf_ctrl;
-	u16 pfnum;
 
-	pfnum = mlx5_esw_sf_controller_to_pfnum(dev, controller);
 	hpf_ctrl = mlx5_esw_get_hpf_host_number(dev) + 1;
 	mlx5_esw_get_port_parent_id(dev, &ppid);
 	memcpy(dl_port->attrs.switch_id.id, &ppid.id[0], ppid.id_len);
@@ -166,11 +166,15 @@ static void mlx5_esw_offloads_sf_devlink_port_attrs_set(struct mlx5_eswitch *esw
 				      controller == hpf_ctrl);
 }
 
-int mlx5_esw_offloads_sf_devlink_port_init(struct mlx5_eswitch *esw, struct mlx5_vport *vport,
+int mlx5_esw_offloads_sf_devlink_port_init(struct mlx5_eswitch *esw,
+					   struct mlx5_vport *vport,
 					   struct mlx5_devlink_port *dl_port,
-					   u32 controller, u32 sfnum)
+					   u32 controller, u32 pfnum,
+					   u32 sfnum)
 {
-	mlx5_esw_offloads_sf_devlink_port_attrs_set(esw, &dl_port->dl_port, controller, sfnum);
+	mlx5_esw_offloads_sf_devlink_port_attrs_set(esw, &dl_port->dl_port,
+						    controller, pfnum,
+						    sfnum);
 
 	vport->dl_port = dl_port;
 	mlx5_devlink_port_init(dl_port, vport);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 76f808e06a88..8c2c55ba5c35 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1370,7 +1370,8 @@ static void mlx5_eswitch_unload_pf_vf_vport(struct mlx5_eswitch *esw, u16 vport_
 
 int mlx5_eswitch_load_sf_vport(struct mlx5_eswitch *esw, u16 vport_num,
 			       enum mlx5_eswitch_vport_event enabled_events,
-			       struct mlx5_devlink_port *dl_port, u32 controller, u32 sfnum)
+			       struct mlx5_devlink_port *dl_port,
+			       u32 controller, u32 pfnum, u32 sfnum)
 {
 	struct mlx5_vport *vport;
 	int err;
@@ -1379,7 +1380,8 @@ int mlx5_eswitch_load_sf_vport(struct mlx5_eswitch *esw, u16 vport_num,
 	if (IS_ERR(vport))
 		return PTR_ERR(vport);
 
-	err = mlx5_esw_offloads_init_sf_rep(esw, vport, dl_port, controller, sfnum);
+	err = mlx5_esw_offloads_init_sf_rep(esw, vport, dl_port, controller,
+					    pfnum, sfnum);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 48eb6acc1e87..463855240032 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -872,9 +872,10 @@ void mlx5_esw_set_spec_source_port(struct mlx5_eswitch *esw,
 int mlx5_esw_offloads_init_pf_vf_rep(struct mlx5_eswitch *esw, struct mlx5_vport *vport);
 void mlx5_esw_offloads_cleanup_pf_vf_rep(struct mlx5_eswitch *esw, struct mlx5_vport *vport);
 
-int mlx5_esw_offloads_init_sf_rep(struct mlx5_eswitch *esw, struct mlx5_vport *vport,
+int mlx5_esw_offloads_init_sf_rep(struct mlx5_eswitch *esw,
+				  struct mlx5_vport *vport,
 				  struct mlx5_devlink_port *dl_port,
-				  u32 controller, u32 sfnum);
+				  u32 controller, u32 pfnum, u32 sfnum);
 void mlx5_esw_offloads_cleanup_sf_rep(struct mlx5_eswitch *esw, struct mlx5_vport *vport);
 
 int mlx5_esw_offloads_load_rep(struct mlx5_eswitch *esw, struct mlx5_vport *vport);
@@ -882,7 +883,8 @@ void mlx5_esw_offloads_unload_rep(struct mlx5_eswitch *esw, struct mlx5_vport *v
 
 int mlx5_eswitch_load_sf_vport(struct mlx5_eswitch *esw, u16 vport_num,
 			       enum mlx5_eswitch_vport_event enabled_events,
-			       struct mlx5_devlink_port *dl_port, u32 controller, u32 sfnum);
+			       struct mlx5_devlink_port *dl_port,
+			       u32 controller, u32 pfnum, u32 sfnum);
 void mlx5_eswitch_unload_sf_vport(struct mlx5_eswitch *esw, u16 vport_num);
 
 int mlx5_eswitch_load_vf_vports(struct mlx5_eswitch *esw, u16 num_vfs,
@@ -894,9 +896,11 @@ int mlx5_esw_offloads_pf_vf_devlink_port_init(struct mlx5_eswitch *esw,
 void mlx5_esw_offloads_pf_vf_devlink_port_cleanup(struct mlx5_eswitch *esw,
 						  struct mlx5_vport *vport);
 
-int mlx5_esw_offloads_sf_devlink_port_init(struct mlx5_eswitch *esw, struct mlx5_vport *vport,
+int mlx5_esw_offloads_sf_devlink_port_init(struct mlx5_eswitch *esw,
+					   struct mlx5_vport *vport,
 					   struct mlx5_devlink_port *dl_port,
-					   u32 controller, u32 sfnum);
+					   u32 controller, u32 pfnum,
+					   u32 sfnum);
 void mlx5_esw_offloads_sf_devlink_port_cleanup(struct mlx5_eswitch *esw, struct mlx5_vport *vport);
 
 int mlx5_esw_offloads_devlink_port_register(struct mlx5_eswitch *esw, struct mlx5_vport *vport);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 1323114ce7f9..3f182e6286d6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2915,11 +2915,14 @@ void mlx5_esw_offloads_cleanup_pf_vf_rep(struct mlx5_eswitch *esw, struct mlx5_v
 	mlx5_esw_offloads_pf_vf_devlink_port_cleanup(esw, vport);
 }
 
-int mlx5_esw_offloads_init_sf_rep(struct mlx5_eswitch *esw, struct mlx5_vport *vport,
+int mlx5_esw_offloads_init_sf_rep(struct mlx5_eswitch *esw,
+				  struct mlx5_vport *vport,
 				  struct mlx5_devlink_port *dl_port,
-				  u32 controller, u32 sfnum)
+				  u32 controller, u32 pfnum, u32 sfnum)
 {
-	return mlx5_esw_offloads_sf_devlink_port_init(esw, vport, dl_port, controller, sfnum);
+	return mlx5_esw_offloads_sf_devlink_port_init(esw, vport, dl_port,
+						      controller, pfnum,
+						      sfnum);
 }
 
 void mlx5_esw_offloads_cleanup_sf_rep(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
index 4564d460416b..2002b7f376ee 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
@@ -15,6 +15,7 @@ struct mlx5_sf {
 	struct mlx5_devlink_port dl_port;
 	unsigned int port_index;
 	u32 controller;
+	u32 pf_num;
 	u16 id;
 	u16 hw_fn_id;
 	u16 hw_state;
@@ -51,7 +52,8 @@ static void mlx5_sf_function_id_erase(struct mlx5_sf_table *table, struct mlx5_s
 
 static struct mlx5_sf *
 mlx5_sf_alloc(struct mlx5_sf_table *table, struct mlx5_eswitch *esw,
-	      u32 controller, u32 sfnum, struct netlink_ext_ack *extack)
+	      u32 controller, u32 pfnum, u32 sfnum,
+	      struct netlink_ext_ack *extack)
 {
 	unsigned int dl_port_index;
 	struct mlx5_sf *sf;
@@ -64,7 +66,8 @@ mlx5_sf_alloc(struct mlx5_sf_table *table, struct mlx5_eswitch *esw,
 		return ERR_PTR(-EINVAL);
 	}
 
-	id_err = mlx5_sf_hw_table_sf_alloc(table->dev, controller, sfnum);
+	id_err = mlx5_sf_hw_table_sf_alloc(table->dev, controller, pfnum,
+					   sfnum);
 	if (id_err < 0) {
 		err = id_err;
 		goto id_err;
@@ -76,12 +79,13 @@ mlx5_sf_alloc(struct mlx5_sf_table *table, struct mlx5_eswitch *esw,
 		goto alloc_err;
 	}
 	sf->id = id_err;
-	hw_fn_id = mlx5_sf_sw_to_hw_id(table->dev, controller, sf->id);
+	hw_fn_id = mlx5_sf_sw_to_hw_id(table->dev, controller, pfnum, sf->id);
 	dl_port_index = mlx5_esw_vport_to_devlink_port_index(table->dev, hw_fn_id);
 	sf->port_index = dl_port_index;
 	sf->hw_fn_id = hw_fn_id;
 	sf->hw_state = MLX5_VHCA_STATE_ALLOCATED;
 	sf->controller = controller;
+	sf->pf_num = pfnum;
 
 	err = mlx5_sf_function_id_insert(table, sf);
 	if (err)
@@ -92,7 +96,7 @@ mlx5_sf_alloc(struct mlx5_sf_table *table, struct mlx5_eswitch *esw,
 insert_err:
 	kfree(sf);
 alloc_err:
-	mlx5_sf_hw_table_sf_free(table->dev, controller, id_err);
+	mlx5_sf_hw_table_sf_free(table->dev, controller, pfnum, id_err);
 id_err:
 	if (err == -EEXIST)
 		NL_SET_ERR_MSG_MOD(extack, "SF already exist. Choose different sfnum");
@@ -101,7 +105,8 @@ mlx5_sf_alloc(struct mlx5_sf_table *table, struct mlx5_eswitch *esw,
 
 static void mlx5_sf_free(struct mlx5_sf_table *table, struct mlx5_sf *sf)
 {
-	mlx5_sf_hw_table_sf_free(table->dev, sf->controller, sf->id);
+	mlx5_sf_hw_table_sf_free(table->dev, sf->controller, sf->pf_num,
+				 sf->id);
 	trace_mlx5_sf_free(table->dev, sf->port_index, sf->controller, sf->hw_fn_id);
 	kfree(sf);
 }
@@ -241,13 +246,17 @@ static int mlx5_sf_add(struct mlx5_core_dev *dev, struct mlx5_sf_table *table,
 	struct mlx5_sf *sf;
 	int err;
 
-	sf = mlx5_sf_alloc(table, esw, new_attr->controller, new_attr->sfnum, extack);
+	sf = mlx5_sf_alloc(table, esw, new_attr->controller, new_attr->pfnum,
+			   new_attr->sfnum, extack);
 	if (IS_ERR(sf))
 		return PTR_ERR(sf);
 
 	mlx5_esw_reps_block(esw);
-	err = mlx5_eswitch_load_sf_vport(esw, sf->hw_fn_id, MLX5_VPORT_UC_ADDR_CHANGE,
-					 &sf->dl_port, new_attr->controller, new_attr->sfnum);
+	err = mlx5_eswitch_load_sf_vport(esw, sf->hw_fn_id,
+					 MLX5_VPORT_UC_ADDR_CHANGE,
+					 &sf->dl_port, new_attr->controller,
+					 new_attr->pfnum,
+					 new_attr->sfnum);
 	mlx5_esw_reps_unblock(esw);
 	if (err)
 		goto esw_err;
@@ -347,10 +356,12 @@ static void mlx5_sf_dealloc(struct mlx5_sf_table *table, struct mlx5_sf *sf)
 		 * firmware gives confirmation that it is detached by the driver.
 		 */
 		mlx5_cmd_sf_disable_hca(table->dev, sf->hw_fn_id);
-		mlx5_sf_hw_table_sf_deferred_free(table->dev, sf->controller, sf->id);
+		mlx5_sf_hw_table_sf_deferred_free(table->dev, sf->controller,
+						  sf->pf_num, sf->id);
 		kfree(sf);
 	} else {
-		mlx5_sf_hw_table_sf_deferred_free(table->dev, sf->controller, sf->id);
+		mlx5_sf_hw_table_sf_deferred_free(table->dev, sf->controller,
+						  sf->pf_num, sf->id);
 		kfree(sf);
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
index c36dbd7de877..d8d061683497 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
@@ -37,7 +37,7 @@ struct mlx5_sf_hw_table {
 };
 
 static struct mlx5_sf_hwc_table *
-mlx5_sf_controller_to_hwc(struct mlx5_core_dev *dev, u32 controller)
+mlx5_sf_controller_to_hwc(struct mlx5_core_dev *dev, u32 controller, u32 pfnum)
 {
 	struct mlx5_sf_hw_table *table = dev->priv.sf_hw_table;
 	int i;
@@ -50,11 +50,12 @@ mlx5_sf_controller_to_hwc(struct mlx5_core_dev *dev, u32 controller)
 	return &table->hwc[!!controller];
 }
 
-u16 mlx5_sf_sw_to_hw_id(struct mlx5_core_dev *dev, u32 controller, u16 sw_id)
+u16 mlx5_sf_sw_to_hw_id(struct mlx5_core_dev *dev, u32 controller, u32 pfnum,
+			u16 sw_id)
 {
 	struct mlx5_sf_hwc_table *hwc;
 
-	hwc = mlx5_sf_controller_to_hwc(dev, controller);
+	hwc = mlx5_sf_controller_to_hwc(dev, controller, pfnum);
 	return hwc->start_fn_id + sw_id;
 }
 
@@ -79,14 +80,14 @@ mlx5_sf_table_fn_to_hwc(struct mlx5_sf_hw_table *table, u16 fn_id)
 
 static int mlx5_sf_hw_table_id_alloc(struct mlx5_core_dev *dev,
 				     struct mlx5_sf_hw_table *table,
-				     u32 controller,
+				     u32 controller, u32 pfnum,
 				     u32 usr_sfnum)
 {
 	struct mlx5_sf_hwc_table *hwc;
 	int free_idx = -1;
 	int i;
 
-	hwc = mlx5_sf_controller_to_hwc(dev, controller);
+	hwc = mlx5_sf_controller_to_hwc(dev, controller, pfnum);
 	if (!hwc->sfs)
 		return -ENOSPC;
 
@@ -110,16 +111,17 @@ static int mlx5_sf_hw_table_id_alloc(struct mlx5_core_dev *dev,
 
 static void mlx5_sf_hw_table_id_free(struct mlx5_core_dev *dev,
 				     struct mlx5_sf_hw_table *table,
-				     u32 controller, int id)
+				     u32 controller, u32 pfnum, int id)
 {
 	struct mlx5_sf_hwc_table *hwc;
 
-	hwc = mlx5_sf_controller_to_hwc(dev, controller);
+	hwc = mlx5_sf_controller_to_hwc(dev, controller, pfnum);
 	hwc->sfs[id].allocated = false;
 	hwc->sfs[id].pending_delete = false;
 }
 
-int mlx5_sf_hw_table_sf_alloc(struct mlx5_core_dev *dev, u32 controller, u32 usr_sfnum)
+int mlx5_sf_hw_table_sf_alloc(struct mlx5_core_dev *dev, u32 controller,
+			      u32 pfnum, u32 usr_sfnum)
 {
 	struct mlx5_sf_hw_table *table = dev->priv.sf_hw_table;
 	u16 hw_fn_id;
@@ -130,13 +132,14 @@ int mlx5_sf_hw_table_sf_alloc(struct mlx5_core_dev *dev, u32 controller, u32 usr
 		return -EOPNOTSUPP;
 
 	mutex_lock(&table->table_lock);
-	sw_id = mlx5_sf_hw_table_id_alloc(dev, table, controller, usr_sfnum);
+	sw_id = mlx5_sf_hw_table_id_alloc(dev, table, controller, pfnum,
+					  usr_sfnum);
 	if (sw_id < 0) {
 		err = sw_id;
 		goto exist_err;
 	}
 
-	hw_fn_id = mlx5_sf_sw_to_hw_id(dev, controller, sw_id);
+	hw_fn_id = mlx5_sf_sw_to_hw_id(dev, controller, pfnum, sw_id);
 	err = mlx5_cmd_alloc_sf(dev, hw_fn_id);
 	if (err)
 		goto err;
@@ -161,21 +164,22 @@ int mlx5_sf_hw_table_sf_alloc(struct mlx5_core_dev *dev, u32 controller, u32 usr
 vhca_err:
 	mlx5_cmd_dealloc_sf(dev, hw_fn_id);
 err:
-	mlx5_sf_hw_table_id_free(dev, table, controller, sw_id);
+	mlx5_sf_hw_table_id_free(dev, table, controller, pfnum, sw_id);
 exist_err:
 	mutex_unlock(&table->table_lock);
 	return err;
 }
 
-void mlx5_sf_hw_table_sf_free(struct mlx5_core_dev *dev, u32 controller, u16 id)
+void mlx5_sf_hw_table_sf_free(struct mlx5_core_dev *dev, u32 controller,
+			      u32 pfnum, u16 id)
 {
 	struct mlx5_sf_hw_table *table = dev->priv.sf_hw_table;
 	u16 hw_fn_id;
 
 	mutex_lock(&table->table_lock);
-	hw_fn_id = mlx5_sf_sw_to_hw_id(dev, controller, id);
+	hw_fn_id = mlx5_sf_sw_to_hw_id(dev, controller, pfnum, id);
 	mlx5_cmd_dealloc_sf(dev, hw_fn_id);
-	mlx5_sf_hw_table_id_free(dev, table, controller, id);
+	mlx5_sf_hw_table_id_free(dev, table, controller, pfnum, id);
 	mutex_unlock(&table->table_lock);
 }
 
@@ -188,7 +192,8 @@ static void mlx5_sf_hw_table_hwc_sf_free(struct mlx5_core_dev *dev,
 	trace_mlx5_sf_hwc_free(dev, hwc->start_fn_id + idx);
 }
 
-void mlx5_sf_hw_table_sf_deferred_free(struct mlx5_core_dev *dev, u32 controller, u16 id)
+void mlx5_sf_hw_table_sf_deferred_free(struct mlx5_core_dev *dev,
+				       u32 controller, u32 pfnum, u16 id)
 {
 	struct mlx5_sf_hw_table *table = dev->priv.sf_hw_table;
 	u32 out[MLX5_ST_SZ_DW(query_vhca_state_out)] = {};
@@ -197,8 +202,8 @@ void mlx5_sf_hw_table_sf_deferred_free(struct mlx5_core_dev *dev, u32 controller
 	u8 state;
 	int err;
 
-	hw_fn_id = mlx5_sf_sw_to_hw_id(dev, controller, id);
-	hwc = mlx5_sf_controller_to_hwc(dev, controller);
+	hw_fn_id = mlx5_sf_sw_to_hw_id(dev, controller, pfnum, id);
+	hwc = mlx5_sf_controller_to_hwc(dev, controller, pfnum);
 	mutex_lock(&table->table_lock);
 	err = mlx5_cmd_query_vhca_state(dev, hw_fn_id, out, sizeof(out));
 	if (err)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/priv.h b/drivers/net/ethernet/mellanox/mlx5/core/sf/priv.h
index 7114f3fc335f..19fc3be82cd4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/priv.h
@@ -12,11 +12,15 @@ int mlx5_cmd_dealloc_sf(struct mlx5_core_dev *dev, u16 function_id);
 int mlx5_cmd_sf_enable_hca(struct mlx5_core_dev *dev, u16 func_id);
 int mlx5_cmd_sf_disable_hca(struct mlx5_core_dev *dev, u16 func_id);
 
-u16 mlx5_sf_sw_to_hw_id(struct mlx5_core_dev *dev, u32 controller, u16 sw_id);
+u16 mlx5_sf_sw_to_hw_id(struct mlx5_core_dev *dev, u32 controller, u32 pfnum,
+			u16 sw_id);
 
-int mlx5_sf_hw_table_sf_alloc(struct mlx5_core_dev *dev, u32 controller, u32 usr_sfnum);
-void mlx5_sf_hw_table_sf_free(struct mlx5_core_dev *dev, u32 controller, u16 id);
-void mlx5_sf_hw_table_sf_deferred_free(struct mlx5_core_dev *dev, u32 controller, u16 id);
+int mlx5_sf_hw_table_sf_alloc(struct mlx5_core_dev *dev, u32 controller,
+			      u32 pfnum, u32 usr_sfnum);
+void mlx5_sf_hw_table_sf_free(struct mlx5_core_dev *dev, u32 controller,
+			      u32 pfnum, u16 id);
+void mlx5_sf_hw_table_sf_deferred_free(struct mlx5_core_dev *dev,
+				       u32 controller, u32 pfnum, u16 id);
 bool mlx5_sf_hw_table_supported(const struct mlx5_core_dev *dev);
 
 #endif
-- 
2.44.0

