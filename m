Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012012.outbound.protection.outlook.com [40.107.200.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A134A204C;
	Wed, 23 Sep 2026 10:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790160098; cv=fail; b=kIzzN4Lyg/Tz1e4guP8QBU0LXflpL6mrO0eN5x8cThXcHQbLqiKRGVttg8x9L/zdXnAvgeTB/1e6GRPvOBGJIRayIAHxEXwi1n9KaCRLwDd09rlVckvmFfDBnuRU8OwL2c3a3wCqrI0DZ5KqvtG91eg+pm3eRiTwWRX4e7uqaRE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790160098; c=relaxed/simple;
	bh=gsAGYgMm3me8cp4r+rlCEeigx7XR4HyGZnZsYcF/H/o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QtQ4aOaeUMs7vYfoRj6+i1cv0V2GL1iwVBkp7M6opihudvVoypnmVhvdvrVfOy1Wjzi+a8/DjYiT6B/ryl9jFMG8hgAerWXGgF7RTci7QPqsXd9ai8DdewgN4tX6XG2uzzWhN8lWqCR2h1CdXzB6TCcDdIfxFhnb7nkUgqJnH14=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eNSfQFMU; arc=fail smtp.client-ip=40.107.200.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eNSfQFMU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FeTilCuIHG5yZM4la/hHtTTuzZrCtD4iUyUboiL/qynhS1CuXrwx4QK9I7PFJzjl00KAS1SUwHE/K/k5ALJW+U41BRDE4Qe2hbgRlMN4Ts7txXe2B4CA8/FNIvErCWL1WkU6e2JVgenN5iHVVc+E0yVanQLEFXKOyfKknhv6J3eqm1MG6rJ5lmA50ep92E0C2z8lttbzrYSyN1EXzGDu+NMXSnNXwFpeBNXBwXEEmgVDYsiqXSN5d/VeVv+yA+Do/2BjZD8+QoRPmh3DmLhe7qwp4PXRehG1SuaVrV3pm10cxw1MeDxYRKP5FXaD67NHYkN9haOpnx0lePWS0KnBlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iDLz62qDvvOnaOT5exBUQ/14gJnJr29B5fCG38gnrHM=;
 b=aQsL7ztqysVsK9tztOLFhmQNA4eEsuNEeJ21q4qxaateQZcupuFMCvBBXV8KEp6jHFUHC3JAVhmjT56rpeL45AWJpQM48at5l1sReUuE+U/Fwpr8/ddnYilxxknDFVHbxVoaUvXNxXrgsupW1rfveqHfjdW7OtZBfZI+NwIklqtPlz8B43tQgAvukj4VsNHDgkvlmblq/erJ9JVem8ay3LkIlSppyG1jeO8rg8YRk3qpwmV04ycy5jfuN2iCpN747/mg02QLC8tKJJ27+73GZ2pFL+7RqTp6YZaeRLnTrbgpN+ThUIqjQqTRsMwRtNyYpAT+xxzXwTMAm3V5Hq5rIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iDLz62qDvvOnaOT5exBUQ/14gJnJr29B5fCG38gnrHM=;
 b=eNSfQFMUzKXbdlVpJS8IqMeEvdwEan3fzDW3OD/dB61CGKKXFYMRAp4cIG0kNDmPDn7NQiapqAwKuhOIWmV2gStGQY9xKz9cobfpcUCQCelm+aCdOGPnei1kLZIVIJCgMBpM42b67ZhVVZuQK5Tqq8bZ1E1BXIauAu49un2SvCLOz5vBpoCQCIEVQ0CxI9FQAo7kKeXHcl/FufprxY5scGhWg+wjTiM1MZveVFnWvcx1DZ2UwJ0muNfCDEw8MbDxmHI6k6G2BShF/XJ+M4QDogwblx91rxlrBs6Ie5gnJykdheiPkq+F6V+aWxCiY1+KcX3jW2o9IvPZe/fWx8MxLg==
Received: from SJ0PR05CA0062.namprd05.prod.outlook.com (2603:10b6:a03:332::7)
 by DM4PR12MB9071.namprd12.prod.outlook.com (2603:10b6:8:bd::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.13; Wed, 23 Sep
 2026 10:41:22 +0000
Received: from SJ1PEPF000023D2.namprd02.prod.outlook.com
 (2603:10b6:a03:332:cafe::7a) by SJ0PR05CA0062.outlook.office365.com
 (2603:10b6:a03:332::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.6 via Frontend Transport; Wed, 23
 Sep 2026 10:41:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF000023D2.mail.protection.outlook.com (10.167.244.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Wed, 23 Sep 2026 10:41:21 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 23 Sep
 2026 03:40:59 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 23 Sep
 2026 03:40:59 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Wed, 23
 Sep 2026 03:40:54 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Cosmin Ratiu
	<cratiu@nvidia.com>, Gal Pressman <gal@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shay Drory <shayd@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net-next 13/13] net/mlx5: E-switch, disable host functions for a non PF e-switch manager
Date: Wed, 23 Sep 2026 13:38:30 +0300
Message-ID: <20260923103830.1183-14-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260923103830.1183-1-tariqt@nvidia.com>
References: <20260923103830.1183-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D2:EE_|DM4PR12MB9071:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a001753-030e-4423-096a-08df195f3586
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|82310400026|36860700016|1800799024|56012099006|11063799006|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	pIRydbJ54LnkO2X4RmzrUq4aFdwKXuHQuokMNVH8NL/6LBmKwOGwqkjjl5y9gHeGCq6+9k9xM6di0LyUzcq3uAO8udLDuNmlyfsaZkui39zZ8AxqaD5NpBU6ZKT3dCno+YojYMV9IMkmOun5PZouz4surKQDBUD4DaiLWpawebmHxytTBRL920ZBWFvm9bK8x1zdI6oTh5J1gZiDSMWbpGSG8dKk627JUMKkQowcx6HQ4SahHmbG/lFUFXkvTtsWvavqje7dMKVnjZgAbzAmekxOgwXRQDgzY8RYxet1jHXnV+FkKSPv8upoFgJsgOWMWwRa0igrRXl+ZfV+fZpOLWKVqgSXRly+XbTUOxk3MW2BZiAmuWdImP6Swsyc/mu8cbiXBNp8lZ/Vpp3QS2jLj7kaoPknaKNiYa1zUgfcbzbXbj3tM7gfRZmUNqXZWynibdaeRYFHLxEoeM12XVXokcL3OJVlf20oziX2+Mn7wl8KlBi7yeLYprkDNLAg964KCguiB8OQ2E9SfGPsv3+YWA3qgI8ixD8vv18IKjAJ3pVqnL9xDIcQhslxpDNKSXT+lEMtDBK0jc/m+bsi7D+TdEr42IcrSTEagcYLd9KQHKAkjJFlPMUl/BE5cexAoRAm5aSFjlF8aq6ncpYbFxv0xuSM7ahYZokubBRHM5MPlNL2o0Oa+dOsD2KnOHtVtj8/YTMlwe6guIAs6bBTJRfXog==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(23010399003)(82310400026)(36860700016)(1800799024)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	oAQgA0U0aEriguPi4s2BGav50tr+gXwqHMU+vxfIMCDIBLKmpORSWOHS/9dLYSvBRCXj/cNH/OLv5nOUZNIuw6tT4KFxioRIZcAQ0+8821Kiijkh3cGkmBj+Vs+zqwydq3Kqoa8uRw1yUAmGanz2nWA8KiLjcOF54RekS/TQjXZ7OCgxnq3Q87mGmMk1VbwYNrZI508Ls/dWfL1/AF/e5i1MlWf2XMnIckWLbwXdOe884MGFnhDR8lP11gy4WXZGwwu/fnFh/arhJSvi0dSpifNKHEETfnM9PNkfo73Wy8pH+2lzpzJZAdYPas+H32UGQWUQ0uk5uEMRwy9zIs1XFqDHGUlZdyKttIreZBqKEkFfbq7ab6ajegzq5wtyrF/tuDeTDv2N2tPzg6227vlRTijwotwCwATPwfZiPrIIAqGC5SH9w4EOzNmuO2UrEfzj
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2026 10:41:21.9182
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a001753-030e-4423-096a-08df195f3586
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB9071

From: Shay Drory <shayd@nvidia.com>

mlx5_esw_host_functions_enabled() only treated host functions as
disabled for an ECPF manager.

To support a non PF acting as an e-switch manager, add a check for a non
PF e-switch manager that treats host functions as disabled. This will
avoid allocating a host-PF vport in mlx5_esw_vports_init().

With host functions disabled for non PF, its e-switch is the expected
manager + uplink only.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Akiva Goldberger <agoldberger@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 6f3676c86d3d..2d289fb1353b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1241,6 +1241,11 @@ static int mlx5_esw_host_functions_enabled_query(struct mlx5_eswitch *esw)
 	struct mlx5_esw_pf_info host_pf_info;
 	const u32 *query_host_out;
 
+	if (!mlx5_core_is_pf(esw->dev)) {
+		esw->esw_funcs.host_funcs_disabled = true;
+		return 0;
+	}
+
 	if (!mlx5_core_is_ecpf_esw_manager(esw->dev))
 		return 0;
 
-- 
2.44.0

