Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012005.outbound.protection.outlook.com [52.101.43.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8443B19A5;
	Wed,  2 Sep 2026 19:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788377783; cv=fail; b=RlsrmH+du1WDJbLtCOz/KL56sApQk/MT/vZ2AI4ZbQ1NXmdHnxJgEXIUpdSrcHaEtJUwmXPwMY9msYBK4X40yIdE/rH/O+LI3bcp74v61g3/QNunXvO2s9yUwPx4m/uJeToMrkCIWY5OtpRnZX0F4eoAl1b67OW5tbIgFYuoHGs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788377783; c=relaxed/simple;
	bh=j0Lr+EmiJLWnundebyXH2WOu/l6HB9rFRbgNwlexyvU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Ksj/aVtfjfTZi8vlqSiUt0KOx39fMS91z5/4osC7AE3jZIajZCW80vwWI2YiZMXmA9ErMcrsptRbQc6vSFfG4ibSSM/T0Ck75uD1GbK4GttUdIiVxSqm+Jy7H6iSCrk+8OZSeAmU/WRUbyvFGH7VOYp5AUv/gHCX0iP+dxkyAjA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KpYSuFPt; arc=fail smtp.client-ip=52.101.43.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KpYSuFPt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dn58rfhuxFAAJNMvbhKM+80Vi6zrSsvxnBEsWVo0g1pZhgmqsOne/V+x/92YkshwXeAs24A5gENxkz+eFHMup7HTPenqjpc2WTlYfSTdgWiPWqlvilmPM7bLDijSQdd39ZIdqy/3Ehf37b60OH3OJvpe6/TleGJW1pZ3e1boliE53J3eH3aHdn3ubZ9mLTYNTS+W3yqEYmmj4JUUSVVGFvO7tgf3KY4yXK2dJVp8UY6djtrlKsWbzgZRQpuX5tMZ0IqHOpeemwNke6+umXJ7tvsknVYYWkj3xbzGDcc/aA/DruUyAyYQmuB0fvactIgU9ATRlj74Y1MXWeFGvSXsoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Wqg06LZIr2+OUGulj7LlA27gi5PPNnnYE/ErE93t3I=;
 b=yXkHUs/2E0oU/26KzGM091x5l1klFYZ1dwVq3NTufbYkXKlQ5CYBQGjoM+htrTPSRaCeVlyG3u8AKN1rz5ww0tlOa2ui6Lx8b4wh44Z16do0JvMt3uiNRhh2fliLAiwP72BFke1qW985AgxQCu2bIoJq/NGmmuBCcPc05oBC9nO1AdTg13kU/47rDzGpKAsNGKtZr9Wi7KGRof7vbj8dJCNE1uSzL1G2CjJK1ASqsWSIGoA2t7ORcONvTBqDfk9PhRDDYSKqDdk3+dGn1yAewaWAwfh8x1MqOxhuVP/X81FEOayATgjvkk561EUz+xA+AEix8xbafipTQtpNPRFz3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Wqg06LZIr2+OUGulj7LlA27gi5PPNnnYE/ErE93t3I=;
 b=KpYSuFPtnRHRk2HmA9/6+rSdBsNXwEM2cYoWLb6aHBakXM6f1UrL8Hoo+/N4tk0Ep2jz/MU/vkoRTyfhloHjLfFLXSETCugQUi9wzgTKAyyp08FQB0gL5Ga+ADcoyhs9dJXuWOblHS7WhBqser38P6M66vsqRiS1pPht6s7kc0R6UKd0gTafvpcoVBUX4hCKApDgp2fD4IjEeCr3d0L841wEUr+4u9TuXMmTPtz3taM/mR3sWj15TjnuWjXfat7mgPakRHeEdigVIjWS7AQEje5oDi4QEuunpaoHOhSsmP9fYSrkb3VIjNOnBPeIZOtApzgb4k/po6Hro55nYBe7uw==
Received: from BN0PR04CA0045.namprd04.prod.outlook.com (2603:10b6:408:e8::20)
 by CH3PR12MB8075.namprd12.prod.outlook.com (2603:10b6:610:122::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Wed, 2 Sep
 2026 19:36:00 +0000
Received: from BN3PEPF0000B078.namprd04.prod.outlook.com (2603:10b6:408:e8::4)
 by BN0PR04CA0045.outlook.office365.com (2603:10b6:408:e8::20) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.11
 via Frontend Transport; Wed, 2 Sep 2026 19:36:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN3PEPF0000B078.mail.protection.outlook.com (10.167.243.123) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Wed, 2 Sep 2026 19:36:00 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 12:35:30 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 12:35:30 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Wed, 2 Sep
 2026 12:35:26 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Leon
 Romanovsky" <leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Yael Chemla
	<ychemla@nvidia.com>
Subject: [PATCH net] net/mlx5: E-Switch: fix use-after-free in mlx5_eswitch_termtbl_put
Date: Wed, 2 Sep 2026 22:35:14 +0300
Message-ID: <20260902193514.3668880-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B078:EE_|CH3PR12MB8075:EE_
X-MS-Office365-Filtering-Correlation-Id: 91a33959-2176-4f0c-4cc8-08df09296b08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|82310400026|36860700016|1800799024|11063799006|10067099003|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	yEzfLSFIy0l8rxuTGG6cFzQUAVRh6ojxUOckhr32jPlADCBhwEn4k9QcQsV2X82Rn3IClgEXQ37MNfgGIhjinHRswdv0OXlDOKwtk1oeBDJudD8A053/euwX+ow8tMV/lsCKY/fu7Jm8K8GkeooVsjKLJaZ5diAuo+ujajhDSZViNO/rSUpXFQN5j9EUqI+w8Vpr8enrXrB80Doa8V0z3bf3+EdMORf5u1B+ASobhs7LVl/z9fL6wZW5/gyU71Iikx8rjxvutTM6h8qKb9zADcgEZF4EbJ5+F7mz87Bshgi9WGv12FlMeVEU7xqIC0O0SLVNioe53CbzgCbGNq/lwmqwcHpoVBNSfkZTSaan56PVL4YfqGHhfDOobu6+trt2q8iA+dwo1jYE7G7cAytgyV4AI3AVlKqkGo9NYdoSPk+gQcKj2BwstTvgs80Cj4iyPR4V3PUIlpvPg9QHR5BA7A1iZJVUzl5D1t+2G73mcKM8ZT7rk8V/4/Pvflibvc7BuGLbiqXgBMeryLKIF6XGLY1iHpYO+I+KHIeUE3Hk/B5o3sf0VI8kHvMxzfN/Ow6QvT9ytObq9FyD3UbDkjuB+RzUFCJQ8n3izg5fQNzNoQo05DFizWt9m9UNBpzZMvtNvOqhDd7j2Qp8Shra5mKFGkOCQq1Ms+1n/TjR3zdWbFmwQ363LrtBH60D00im3oYVHH83lZBjp4etgwkS11vHng==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(23010399003)(82310400026)(36860700016)(1800799024)(11063799006)(10067099003)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	/J7HWxzigZugbt01Tc7u30TuLzd+MsRXjIaumYyfqIS7Sfx1b6HEaMaF8mF6dGqSytWIx4xoK+eCw6tHiwMZFT5SQr4i4jgPhIpSM8Yh1u+vDNMTyO162+WOiJO0ZGk9RdpZ0NEJaPsUuqDfPYbhfMHmoHOh/Rghbmj3bez3tPeODdL+MV2d09lsdXVZZ0Py8jflR8NW4aGqwKF7rUz9pNJZ/4h7sDICZbkdFpFGdyg8uwGC3/9ZQGOinF2kd9tgnbMNtm7hk+3VMYyswsYeJ4XwCWzaOzCagGa/UMk672yAO1lmyXJKwkVpIXdkn/o1OkD+QJm0IdpJEO+AwX53foLe8MZ+Koq9PVN2D+XtrQwtBqganz3OTPHAqYMGyZa4fa0xTk2d9tAExgMvfQZtFDPQd6K0JXhQycN1zZ3Ri0f4e+xSiXIPhdvpYZFwsWOy
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2026 19:36:00.2047
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 91a33959-2176-4f0c-4cc8-08df09296b08
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B078.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8075

From: Yael Chemla <ychemla@nvidia.com>

In mlx5_eswitch_termtbl_put(), the zero-ref cleanup check reads
tt->ref_count after termtbl_mutex has been released.  Two concurrent
callers on the same mlx5_termtbl_handle race: one decrements ref_count
to zero, removes the hash entry, and calls kfree(tt) while the other
has already dropped the mutex and is about to evaluate
if (!tt->ref_count), producing a use-after-free.

Fix this by capturing the result of the decrement into a stack-local
last variable before dropping the mutex.  The cleanup decision is now
made entirely under termtbl_mutex, and tt is not touched after
kfree.

Fixes: 10caabdaad5a ("net/mlx5e: Use termination table for VLAN push actions")
Signed-off-by: Yael Chemla <ychemla@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
index 19f65d4c4def..d43f07360159 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
@@ -163,12 +163,15 @@ void
 mlx5_eswitch_termtbl_put(struct mlx5_eswitch *esw,
 			 struct mlx5_termtbl_handle *tt)
 {
+	bool last;
+
 	mutex_lock(&esw->offloads.termtbl_mutex);
-	if (--tt->ref_count == 0)
+	last = (--tt->ref_count == 0);
+	if (last)
 		hash_del(&tt->termtbl_hlist);
 	mutex_unlock(&esw->offloads.termtbl_mutex);
 
-	if (!tt->ref_count) {
+	if (last) {
 		mlx5_del_flow_rules(tt->rule);
 		mlx5_destroy_flow_table(tt->termtbl);
 		kfree(tt);
-- 
2.44.0

