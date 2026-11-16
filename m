Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794825384;
	b=aMSGRA0aOAjOLYHJW2gz659LKX5coBwmkeJ17kAoHrRuQIH4mJEZ4jUG102NsG978AqQ
	 6Djp4pFY2D/eAw8rYh0r8oOkOhRYDAL273B3CWl8TtSaAQONqn0ijozOdc8XJ+tFVEpLU
	 S/FZYCB5fm/ZmlMtUy0hixzsZiIKeXD8sVEQUH+t8+JIRub1A7fPNtxLymqO0Z/fnAFWO
	 40Ue4BPBbqcCM53Amyi3Iq8x5TKjbZQrybQq85Oio1x5jEuX9KeVte0+cj8LjqfyH1hwT
	 HYyFypo2txGUWcSXEOksIFgzo290zLrfp9gxpiy3ZYeh7BmzulAp+qwRw7i4+9s4IfA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794825384;
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
	bh=Za6O4X7J5fNVLv/73jtoK2D8kZKD/QlY2JkiuBv+Lds=;
	b=X/abE1x0KB33B8LeLJWKFqSuUxYK0nWolt/ybHPIOiMBOSXRetaZVGVCSxzgn2+apGAm
	 GumlSd0KWARbgYRL6pTyp5Zf/9bi2gNKBAuovkhFqNaRgiCxfo5D7b+CenjW3jGLZBMBv
	 anRo8wJKzLt17Dl6GddSuTb+uschFo9A6++ZW0EZrlnjgpjW8F8Rd+AWc5DnUiWBWKrdH
	 5PaJ6ul8VDFATAJKqOSKrIJL4S2V4vYpfa7GSHBgoIAjkTY7RcET9I2YUvzRRtUYLkSy2
	 7e7xAITMNkaAOIAtfqobT0sLZ8/fbP6Xn9DAS4fhAnuR5/LqfRT5xUJrQSDPmbfMnRQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=WsXnWhq0;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.41
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011041.outbound.protection.outlook.com [40.93.194.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691AF606A329;
	Mon, 16 Nov 2026 10:36:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 691AF606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=WsXnWhq0
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dECeBwpFDfqLryUAuURccuZ0I1B8vU9X/sQKNXA0u8VtT4C4U340mydR0A37Pf8c8T5UGT9aF1+pQ/tEhKhIQuX2TQNWpGNu9e4JGBO+Kt5QSqY8wJmc3jQ2fKacKhWtBOEmGipzcChKVjnP+w1w7OyqRCxdBC7eFJ55DvoHOXJPc9/RodzNebNGxfi3G4HqUeeqZWQsK+nWb9kGbLajbXys2kecLfCJh690RZFcvTthSDdw5x4oVObmDEZxjGqHjJ926/RDDD5DnDkytuMfJaLcdqrH0et61PZx91RsmMxK8SuRjQZ9JAVPI0SpE3VFXQzDV8d1WZhJEMwccS2R3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Za6O4X7J5fNVLv/73jtoK2D8kZKD/QlY2JkiuBv+Lds=;
 b=HBo3LBM+9NbevAq0lqon2SYcK/34TlJDuELgsB6K/dQCO4DXAzubzgiFukEOr1bmzkUoV6b23d8NIhdM0TzhltQ9zUD0JbeiM0UuqU4mnbIvtrXD31D0d/Sq9nyXgq306oyyiUV0/QexBweXNw2SZGzfVlWiqy2hEmyP6OqcRURRW05PvzlxcoGnsQII7lnnCMjtfga03gWBGmUUmx8bEnKrrnK1PAqNAifj2J86a0K4AjIFVuBqLpD0AD7NBvJ4ILSLSAq8oLPgOe5/aO3kUtV7LovuU1s9XVipJvAX23BuHlPlQ1JTQgSv7nia0EuiIfhwddphdhA/tZj3FqEFUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Za6O4X7J5fNVLv/73jtoK2D8kZKD/QlY2JkiuBv+Lds=;
 b=WsXnWhq0u74b0yZBDymC6a30lMlKuprOI60Y0OdUry4kn1+84nNtrui9jjEK9EQt4SzNjV67+LUmbr7EGUTW1zv4vCF9/xoEf4isWjKj1+AZIrRX3Wy+gGTx6k2NqaDg5ZKCCI0szflVRm1ZVC1g6wJil8izRuBvAazBo5E7Qi09Bk7QQHpWblIc1reyHJTr4uQ2JPYy7KqSOiVB/EpbOAnKddbdc5ARI9yEt84zVIRofDaqnA+5ej2OFQiGHs5Heoc4qZaL3IYpwXt8HBxqIlV7TZ3OPM6u1AKdaACFTSl+8WM0BaxH/z6eO+iIATT3GwKTjb9MUI4chg0Z/Ml+Sg==
Received: from DS7P220CA0062.NAMP220.PROD.OUTLOOK.COM (2603:10b6:8:224::34) by
 CH3PR12MB8754.namprd12.prod.outlook.com (2603:10b6:610:170::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Mon, 16 Nov
 2026 10:31:13 +0000
Received: from CY8PEPF0000005A.namprd21.prod.outlook.com
 (2603:10b6:8:224:cafe::85) by DS7P220CA0062.outlook.office365.com
 (2603:10b6:8:224::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.13 via Frontend Transport; Mon,
 16 Nov 2026 10:31:13 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CY8PEPF0000005A.mail.protection.outlook.com (10.167.247.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.0 via Frontend Transport; Mon, 16 Nov 2026 10:31:12 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 16 Nov
 2026 02:30:53 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Mon, 16 Nov 2026 02:30:52 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Mon, 16 Nov 2026 02:30:48 -0800
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
Subject: [PATCH net-next V2 02/10] net/mlx5: LAG, select the MPESW master from the live member snapshot
Date: Mon, 16 Nov 2026 12:30:02 +0200
Message-ID: <20261116103010.1129666-3-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY8PEPF0000005A:EE_|CH3PR12MB8754:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ccd97b5-389d-4853-d966-08df43ccbcd4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|1800799024|23010399003|82310400026|10067099003|11063799006|56012099006|261021121427099003|261021123027099003|261026140227099003|261009223027099003|261102123227099003|261022105027099003|261026121527099003|261028144727099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	kbvnDvntUMHYo6m9F4nYXSQWXrRsMbmSCSWRNiFpTXuiWjRTkJnnXtOFurWvSeMSTSFQcCwx8EH//0W6lc2d4ax2e4XkpVJMYg5+wg+nXY3MpMdK1lj6QK8SQ0s/IRjIk10E8SD+PdTNfVTvUIPBlFknJbT1GmBk4795wOSVSVjdTBJDP7i2owVkyK5CiKOYMAvxstegZMKSNhFgUE8kY3BvMPlnsK/LjV/vh6WbJtlVDscW46k3zdammH+ObR8JQollk9pGF9pEceW6D+XxVNuVUdPZu0IxQ5rExzz6qvOvwoAlOV1wBqOqlihjRqA+viRh4j2u0bq6gpOMIpjuW89vbg5yclaYuCckKDaDffIjwN5shoNw81t2adu/1uRGrEpyI5w+SD2iPoCtzHkeyJOatD1yqSXVGLtMBf+iR/eNeqHL01xVW+NdRHdBkpzsctAk454wmJ8ULaBY1FEU39QwZvaf4ptdSQ6F/HEtoH7QWlYqoO1xtQwZZmEzJoW3oD3cJsLoazIu3wUgy8CxcXrZfV+7QaDzbdJ3WyQlCh+W0VrcurJH8PZUlC1+Hk0lyWHCsFQChuxveHccSx0KIGNe8jAg62ndm181/adUtaTQcx5HDsh+O4ddgw+3576V+hXg7D73JeUMimRTy+/e7reQUIKswv0fn10KmBM8V6syxPp78h51f2Vn9/N2lU14tRIPHMgAA0uwedQmNJg0nQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700016)(1800799024)(23010399003)(82310400026)(10067099003)(11063799006)(56012099006)(261021121427099003)(261021123027099003)(261026140227099003)(261009223027099003)(261102123227099003)(261022105027099003)(261026121527099003)(261028144727099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	b1DMygwCHbUbLPhegg2WLfJXO80ZwwnW1QVE61H2MVuXe4t4ENG+/rNJlC30T0DiJCHexbs07QkF0lv8aWaXBm87Ok/oDZg5bdQPJaf2SmopNLe3jajZdXF1Xpjnwe6ciV6eUOIYDsrzRidqBQgArXyr4BtHF/qG0OsQagGY/RWp9xQwmszcTck4omBh1zefAZQUAWyVxgLHSqz5dgXeee+qdRhPHsFY+t8wbA+N9wIB2kTJ7nvP9u3ftuP36tw+Si/1/jRCcfLut2v+gonth6z/+tj6EqzBdagY69KDY6X65G+HXQdj5JOnEjwxUCZGfmm7t+ILLZg0N+BPaupNfBUxoZ7itIwMrLlh/i8KBC4Ey+I7+t9NtIlB+OOCQd4WTOXII9Y9l6EMFOzmeg1zaIdG3Xlp4O32xGF/obxq8nNfkQ1NORNyjF2Iu5tWqNaw
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 10:31:12.9009
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ccd97b5-389d-4853-d966-08df43ccbcd4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY8PEPF0000005A.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8754

From: Shay Drory <shayd@nvidia.com>

The LAG master is marked by the devcom PAIR event when all physical
ports have registered (mlx5_lag_num_devs() == ldev->ports). That does
not work for a virtual LAG of VFs/SFs: those functions are unrelated to
the physical port count.

Select the master from the current membership snapshot in
mlx5_lag_enable_mpesw() via mlx5_virt_lag_mark_master(), and clear it in
mlx5_lag_disable_mpesw(). Unlike the regular path, it walks all LAG
members.
mlx5_get_dev_index() is identical for a PF and all its VFs/SFs, so
tie-break by a stable per-member key is used - PCI BDF for VFs, sfnum
for SFs.

This is gated by a new ldev->virt_lag bit identifying this type of LAG.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 46 +++++++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/lag/lag.h |  3 ++
 .../ethernet/mellanox/mlx5/core/lag/mpesw.c   | 42 +++++++++++++----
 .../ethernet/mellanox/mlx5/core/sf/dev/dev.h  | 12 +++++
 4 files changed, 90 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 9330aab24c02..c7ece82fd457 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -39,6 +39,7 @@
 #include "lib/mlx5.h"
 #include "lib/devcom.h"
 #include "mlx5_core.h"
+#include "sf/dev/dev.h"
 #include "eswitch.h"
 #include "esw/acl/ofld.h"
 #include "lag.h"
@@ -598,7 +599,43 @@ static void mlx5_lag_mark_master(struct mlx5_lag *ldev)
 		xa_set_mark(&ldev->pfs, master_xa_idx, MLX5_LAG_XA_MARK_MASTER);
 }
 
-static void mlx5_lag_clear_master(struct mlx5_lag *ldev)
+static u64 mlx5_lag_member_tiebreak(struct mlx5_core_dev *dev)
+{
+	struct pci_dev *pdev = dev->pdev;
+
+	if (mlx5_core_is_sf(dev))
+		return mlx5_sf_coredev_sfnum(dev);
+
+	return ((u64)pci_domain_nr(pdev->bus) << 16) | pci_dev_id(pdev);
+}
+
+void mlx5_virt_lag_mark_master(struct mlx5_lag *ldev)
+{
+	u64 lowest_tiebreak = U64_MAX;
+	int lowest_dev_idx = INT_MAX;
+	int master_xa_idx = -1;
+	struct lag_func *pf;
+	u64 tiebreak;
+	int dev_idx;
+	int i;
+
+	mlx5_lag_for_each(i, 0, ldev, MLX5_LAG_FILTER_ALL) {
+		pf = mlx5_lag_pf(ldev, i);
+		dev_idx = mlx5_get_dev_index(pf->dev);
+		tiebreak = mlx5_lag_member_tiebreak(pf->dev);
+		if (dev_idx < lowest_dev_idx ||
+		    (dev_idx == lowest_dev_idx && tiebreak < lowest_tiebreak)) {
+			lowest_dev_idx = dev_idx;
+			lowest_tiebreak = tiebreak;
+			master_xa_idx = i;
+		}
+	}
+
+	if (master_xa_idx >= 0)
+		xa_set_mark(&ldev->pfs, master_xa_idx, MLX5_LAG_XA_MARK_MASTER);
+}
+
+void mlx5_lag_clear_master(struct mlx5_lag *ldev)
 {
 	unsigned long idx = 0;
 	void *entry;
@@ -618,7 +655,7 @@ static int mlx5_lag_devcom_event(int event, void *my_data, void *event_data)
 	int idx;
 
 	ldev = mlx5_lag_dev(dev);
-	if (!ldev)
+	if (!ldev || ldev->virt_lag)
 		return 0;
 
 	mutex_lock(&ldev->lock);
@@ -1784,10 +1821,13 @@ struct mlx5_devcom_comp_dev *mlx5_lag_get_devcom_comp(struct mlx5_lag *ldev)
 {
 	struct mlx5_devcom_comp_dev *devcom = NULL;
 	struct lag_func *pf;
+	u32 filter;
 	int i;
 
 	mutex_lock(&ldev->lock);
-	i = mlx5_get_next_lag_func(ldev, 0, MLX5_LAG_FILTER_PORTS);
+	filter = ldev->virt_lag ? MLX5_LAG_FILTER_ALL :
+		MLX5_LAG_FILTER_PORTS;
+	i = mlx5_get_next_lag_func(ldev, 0, filter);
 	if (i < MLX5_MAX_PORTS) {
 		pf = mlx5_lag_pf(ldev, i);
 		devcom = pf->dev->priv.hca_devcom_comp;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
index 8552792b9035..21c83f51fcb5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
@@ -84,6 +84,7 @@ struct mlx5_lag {
 	unsigned long		  state_flags;
 	u8			  ports;
 	u8			  buckets;
+	bool			  virt_lag;
 	int			  mode_changes_in_progress;
 	u8			  *v2p_map;
 	struct kref               ref;
@@ -225,6 +226,8 @@ static inline bool mlx5_lag_shared_fdb_supported(struct mlx5_lag *ldev)
 }
 #endif
 bool mlx5_lag_check_prereq(struct mlx5_lag *ldev);
+void mlx5_virt_lag_mark_master(struct mlx5_lag *ldev);
+void mlx5_lag_clear_master(struct mlx5_lag *ldev);
 bool mlx5_lag_is_sd(struct mlx5_core_dev *dev);
 int mlx5_lag_demux_init(struct mlx5_core_dev *dev,
 			struct mlx5_flow_table_attr *ft_attr);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
index 549d31812c2f..0bf5b4754a44 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
@@ -109,8 +109,8 @@ static bool mlx5_lag_has_sd_group(struct mlx5_lag *ldev)
 
 static int mlx5_lag_enable_mpesw(struct mlx5_lag *ldev)
 {
-	int idx = mlx5_lag_get_dev_index_by_seq(ldev, MLX5_LAG_P1);
 	struct mlx5_core_dev *dev0;
+	int idx;
 	int err;
 
 	if (ldev->mode == MLX5_LAG_MODE_MPESW)
@@ -119,20 +119,32 @@ static int mlx5_lag_enable_mpesw(struct mlx5_lag *ldev)
 	if (ldev->mode != MLX5_LAG_MODE_NONE)
 		return -EINVAL;
 
-	if (idx < 0)
-		return -EINVAL;
+	/* VFs/SFs (nested LAG) are not marked by the LAG devcom PAIR event;
+	 * select the master from the current snapshot before resolving it via
+	 * mlx5_lag_get_dev_index_by_seq().
+	 */
+	if (ldev->virt_lag)
+		mlx5_virt_lag_mark_master(ldev);
+
+	idx = mlx5_lag_get_dev_index_by_seq(ldev, MLX5_LAG_P1);
+	if (idx < 0) {
+		err = -EINVAL;
+		goto err_clear_master;
+	}
 
 	dev0 = mlx5_lag_pf(ldev, idx)->dev;
 	if (mlx5_eswitch_mode(dev0) != MLX5_ESWITCH_OFFLOADS ||
 	    !MLX5_CAP_PORT_SELECTION(dev0, port_select_flow_table) ||
 	    !MLX5_CAP_GEN(dev0, create_lag_when_not_master_up) ||
 	    !mlx5_lag_check_prereq(ldev) ||
-	    !mlx5_lag_shared_fdb_supported_filter(ldev, MLX5_LAG_FILTER_ALL))
-		return -EOPNOTSUPP;
+	    !mlx5_lag_shared_fdb_supported_filter(ldev, MLX5_LAG_FILTER_ALL)) {
+		err = -EOPNOTSUPP;
+		goto err_clear_master;
+	}
 
 	err = mlx5_mpesw_metadata_set(ldev);
 	if (err)
-		return err;
+		goto err_clear_master;
 
 	if (mlx5_lag_has_sd_group(ldev))
 		mlx5_mpesw_teardown_sd_fdb(ldev);
@@ -143,13 +155,19 @@ static int mlx5_lag_enable_mpesw(struct mlx5_lag *ldev)
 		mlx5_core_warn(dev0,
 			       "Failed to create LAG in MPESW mode (%d)\n",
 			       err);
-		if (mlx5_lag_has_sd_group(ldev))
-			mlx5_mpesw_restore_sd_fdb(ldev);
-		mlx5_mpesw_metadata_cleanup(ldev);
-		return err;
+		goto err_restore;
 	}
 
 	return 0;
+
+err_restore:
+	if (mlx5_lag_has_sd_group(ldev))
+		mlx5_mpesw_restore_sd_fdb(ldev);
+	mlx5_mpesw_metadata_cleanup(ldev);
+err_clear_master:
+	if (ldev->virt_lag)
+		mlx5_lag_clear_master(ldev);
+	return err;
 }
 
 void mlx5_lag_disable_mpesw(struct mlx5_lag *ldev)
@@ -161,6 +179,10 @@ void mlx5_lag_disable_mpesw(struct mlx5_lag *ldev)
 	mlx5_lag_shared_fdb_destroy(ldev, MLX5_LAG_FILTER_ALL);
 	if (mlx5_lag_has_sd_group(ldev))
 		mlx5_mpesw_restore_sd_fdb(ldev);
+
+	/* Pair with the master mark taken at MPESW create for VFs. */
+	if (ldev->virt_lag)
+		mlx5_lag_clear_master(ldev);
 }
 
 void mlx5_mpesw_sd_devcoms_lock(struct mlx5_lag *ldev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.h b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.h
index 3ab0449c770c..382162baabdb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.h
@@ -19,6 +19,13 @@ struct mlx5_sf_dev {
 	u16 fn_id;
 };
 
+static inline u32 mlx5_sf_coredev_sfnum(struct mlx5_core_dev *mdev)
+{
+	struct auxiliary_device *adev = mlx5_sf_coredev_to_adev(mdev);
+
+	return container_of(adev, struct mlx5_sf_dev, adev)->sfnum;
+}
+
 struct mlx5_sf_peer_devlink_event_ctx {
 	u16 fn_id;
 	struct devlink *devlink;
@@ -68,6 +75,11 @@ static inline bool mlx5_sf_dev_allocated(const struct mlx5_core_dev *dev)
 	return false;
 }
 
+static inline u32 mlx5_sf_coredev_sfnum(struct mlx5_core_dev *mdev)
+{
+	return 0;
+}
+
 #endif
 
 #endif
-- 
2.44.0

