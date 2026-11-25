Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795641685;
	b=Rnj53ICyY7qcQEsR9n61KExBpHLABkomiJ6ByzL8jCY12y1p3D1ZIv/anAh/KV4TlWhL
	 ghSDFScVC3pne3sHvJECFC11ZzDIYtbOU3q0x9zpeh4xH9+4QvGXNELP5cBMitdLbtKFN
	 2L/V9FGm5cDj0WvZzFT6cgsIUcjAu/0GMBRjRDSahmvfT+tZygy0+mHrXAMeIjuiTcu+A
	 DpXr+yv/B8CeuCPqrhM8e4bn2lOYJtojHis1Am0csjvhsunyAfEZmZEM0dK0H94cGk2kc
	 AU6elrvQx4i7py9NAvmUSl/2g+HivLQq5TPRLgKdZU5UBP49G8rbOC+DVlCa3+8VaCQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795641685;
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
	bh=oyEI9cA5GboICjAuA4mLp5tuP+Gj1owyw7mmh3WNpwU=;
	b=2GF1FQFRG3AJPyLlKABfes5fVswzhrCNbS+/Tw9fAnEockaMHiNQx6VS3LJwuMKbXX6h
	 7fyjE9GfLFkukR6+nd2nRNx/uT2EXxzGILELdg/H6SiQ7W7jeBmuEg7SaDj3/uYNZZHAa
	 VyIjVWPSBCN4BCucaMD2sVVckQ4AMRsMCQWbMNsYNTcw+spQ6DzGsYSUHpYkc3f2fOd/k
	 vOJeNJMXOUE3/Y+jPG/jQjf95R2OWJc+hBuAF+XSOf6f+RiAobGSQIOB6NK6cskmscEAN
	 99LyZRxNhZn0p0PgMJwaLtxiSfYdB05aDyygQTyCjPlmP7TlNH89ECrWV+W1bix9DDg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=gBvTE2oY;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.50
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010050.outbound.protection.outlook.com [52.101.61.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06311606A326;
	Wed, 25 Nov 2026 21:21:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 06311606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=gBvTE2oY
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ykF9s5F4yI5mG0cBNeAlzXQ1ixxZYtqfkpjIGB3TzbzktY3C6rdiIQc+pP8tK+a7oMUZxJgIPO41Y/+e3ZMF+wyQCjsjU3lqRDt2FMA9XNcRv9pzJZEkKpXDxQ+98UwyEHJWWK88yu68mTfhvTp48D6culTRpwgu0Qz9gFGIC8PX+wuCREkmmHHAOObvSHz7nb6BN2egi3VkRf7wDBG/Pa/wBGNZThPQPsUBTukdxNmEp2jWPisR6o5NCryQTPqLBnH30Z0EdFrOWChMoLLjBqfrM6Y7YSx23rafpJwHHxQap1AWn0THn+DEnnaWkeO/3F9HvPmD9omWIip0quxlrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oyEI9cA5GboICjAuA4mLp5tuP+Gj1owyw7mmh3WNpwU=;
 b=kIjUPU+p9BzbjAgD6l35G8icvw+3BqKVAl30JpMVqRHdRUR40dVizfxQI+xWzC6p90pffXC2OO8fVI7mc0P4SBjGOEP6nI61smr5qt2rs8tpJkkaSA3nUTZ5UVWSvO56KChyC6xQ7u9QlDJaHOzwNwsXOV3lynVgXW0euCuslCZkppn1e2Ze9zQJVBTVVmqvNU8ubtVwArLYp487AxEpiZyDP6PiJd3QpZ5zz36FUjNyqIZ/rIYkrAisv+njmdQ2cJO8a6lmi3ZFVNT1YycNKwiEpLuqaOCFQBIgAsnWHNxotbcWyFKLGeSaDZCSunDxL75FC2NekRc442ZKkcv4aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oyEI9cA5GboICjAuA4mLp5tuP+Gj1owyw7mmh3WNpwU=;
 b=gBvTE2oYBTJQpK6t+YgVuOx6T5JkUbTEgO/U6UwJ7sjtHdEWSeqGb6sLXSyTJWBtD0NrmwbQhk15a+J6L316xfwVR04n2jRDTatsNyHTwuzSeMizX1Q5QYG31p8xWUG8KLA4MOZjKe6LYrrkGuQ/evgD7MbAKmOhFvpTkJFhhoSB3wvUYytk0OPW8o8JSUgU+ar6pxKjtN2iWCuEuWWLYuVlsBLhBq4QBp1s8rLDxk2K5jYtllwDDsE8mYttCH9PFu38ujFa6YTH7Zs47bePdX0Oy+XVS9azyfLVfgEBuJL1gV7SH3sw/eek/aPEYCbFydCHI+ca1oz2ZbU7V8Lmvg==
Received: from CY5PR13CA0128.namprd13.prod.outlook.com (2603:10b6:930:9::33)
 by SJ1PR12MB6123.namprd12.prod.outlook.com (2603:10b6:a03:45a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Wed, 25 Nov
 2026 21:21:14 +0000
Received: from SN1PEPF000397AE.namprd05.prod.outlook.com
 (2603:10b6:930:9:cafe::95) by CY5PR13CA0128.outlook.office365.com
 (2603:10b6:930:9::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.688.4 via Frontend Transport; Wed, 25
 Nov 2026 21:21:14 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF000397AE.mail.protection.outlook.com (10.167.248.52) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.3 via Frontend Transport; Wed, 25 Nov 2026 21:21:13 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 25 Nov
 2026 13:20:52 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 25 Nov
 2026 13:20:51 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.57 via Frontend Transport; Wed, 25
 Nov 2026 13:20:46 -0800
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
Subject: [PATCH net-next 2/2] net/mlx5: Add controller number for SF and ECVF phys_port_name
Date: Wed, 25 Nov 2026 23:20:32 +0200
Message-ID: <20261125212032.243064-3-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000397AE:EE_|SJ1PR12MB6123:EE_
X-MS-Office365-Filtering-Correlation-Id: fe69a52a-9cfe-44ef-8ce3-08df4b3a0891
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|23010399003|1800799024|82310400026|10067099003|56012099006|11063799006|261028144727099003|261021133027099003|261026135527099003|261022113327099003|261022105027099003|261021123027099003|261022115727099003|261022075727099003|261021135927099003|261021121427099003|261021130227099003|261026130827099003|261026121527099003|261026140227099003|261102123227099003|261009223027099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	LsDbnXgLB1JD9wJHVws+X3R+hZiBL2w2zKF9K/zENCNl7SYrf0hqxRwRLu7ZHauSdsr3ChpGXayofNccRfZOLdcyU5LgCSGHqXPTBoXpjwCKuE4n3aB6InzmlFMlVcxyBTkN56T42PRSuJB/CyYwR5w8AeP46BNfSSpdGty5VY71jHnx8z0fuwt/3bi8SRIXbGykR5yH3ADH0jKE9NqkSCGbutJnWrtInjPS6HWcpyhbKEdeTTwi9ZQ21N7UvCMTmxNp6f10n0smtKnN3RSwmnK1lfzY+RnpCXEPrJ2R8B9GEWdzzjd2oDQTAfceDyBZCv+9/gSr2EDazz6Jqd5wbDX0lBso2t/KMxg7TkN1xV9L2VPPh6ekxJ0fBcg2ej34wm2Te99LtjiYRnaZPLV3QZsChuRcxvUvAoTU7gsyRwBmiTmLL7opNpbrgr0qz4szcFh/nm3URGDvvORs3zR8bi8Mf6Aab5DlOx4gQJX+2kCf4qB63cvnp8EtCv5FWFFs5WWUmcXWAYNZj67uDafxbwr/gcwQo9lVJCMu5lqbv3M+Pr/DQdcSXgeRHY3PLTBRmO3yidjPz2aVhynPBh1ujWLd6j8y4mc1M7au4vDpO5cma83IftcZpLNIZdYhyriYR4weA/StQ9y43rhfznC8QQvAUzDaHMMa9LdwbueDMRILp9Nm4avANDafJwCi3Ylfl7KK8PC48k0tK08hdw9CZg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700016)(23010399003)(1800799024)(82310400026)(10067099003)(56012099006)(11063799006)(261028144727099003)(261021133027099003)(261026135527099003)(261022113327099003)(261022105027099003)(261021123027099003)(261022115727099003)(261022075727099003)(261021135927099003)(261021121427099003)(261021130227099003)(261026130827099003)(261026121527099003)(261026140227099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	QjkoUSb2PICqmkKk7I33u/Nkh5dHLIS7D4mS2AaRL/ArB9iXINom7YhcN3jWu1/eOuzgyP2tTXCkHAeYtkv3P3TBbkvGNjFdiqqWBf9r5n5Hc1IWgCsr+ocYaNYpmBjJP9FU9Q4fOXcfIjPZhSIpLvoHQ/VGclukTGu3Z9jcSFu0u9a2OU/Fk5lRtO4ZL9SE/xPB578QuN4zV1FAhvRCB04+g3kqo+dE5aTtZ262FEmjVGS+xwqOMV1NYacnRn+IEZ95ovPQxiFjGgcTTgtraH1ZR88ZM3LIWmT2iU1eJyMlJDmocDs0WAQ4YwnJ4YG4QCVXOfGzuK6IvV23rA22yv7t+R8V0rwXvPYdmLaO1cArHyCACpoq95F3dph1SSGd8MisbZdeoqLri76raYtyaL/ISa6v+Y57GpX6bIcy+hgOd3NR97x7iNwJ6W+xoHkq
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 21:21:13.2547
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fe69a52a-9cfe-44ef-8ce3-08df4b3a0891
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397AE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6123

From: Chris Mi <cmi@nvidia.com>

phys_port_name for the SF/VF representors is derived from the
devlink port attributes such as controller number, function
number (pf num) and the SF/VF number itself. However, if SF/VF
controller number is 0, the controller number is not added to
the phys_port_name.

In a BlueField-4 Socket-Direct topology [1], there are two PCI
links. Under single eswitch, there are duplicate function number
(pf num) and SF/VF number. The result is they share the same
phys_port_name [2]. Hence, annotate the non-master PCI link
with its own controller number so its SFs/VFs can be uniquely
identified. This streamlines the design so that all PCI links
which are not on the eswitch PF get their own unique controller
number.

Use the MLX5_PCI_PF_TYPE_QUERY_PF entry from QUERY_ESW_FUNCTIONS
to read the host_number for each PCI link. Controller number is
host_number + 1. The non-master PCI link devices get a non-zero
phys_port_cnum so their SFs/VFs display the controller prefix.

Since self PF and satellite PF share the same controller number,
use pfnum to locate the right hwc table.

For example, if the device controller number is 4, user can create
an SF like this:

$ devlink port add pci/0006:01:00.0 flavour pcisf pfnum 0 sfnum 0

or

$ devlink port add pci/0006:01:00.0 flavour pcisf pfnum 0 sfnum 0
  controller 4

But if user specifies other controller number, command fails.

[1]
PCI           NET
0002:01:00.0  net-B21c1pf0,net-p0,net-B21pf0sf0
0006:01:00.0  net-B61c1pf1,net-p1,net-B61pf0sf0
0002:01:00.1  net-B21c2pf0
0006:01:00.1  net-B61c2pf1

[2]
Before this enhancement:
$ cat /sys/class/net/B21pf0sf0/phys_port_name
pf0sf0
$ cat /sys/class/net/B61pf0sf0/phys_port_name
pf0sf0

[3]
After this enhancement:
$ cat /sys/class/net/B21pf0sf0/phys_port_name
pf0sf0
$ cat /sys/class/net/B61c4pf0sf0/phys_port_name
c4pf0sf0

$ devlink port show
pci/0002:01:00.0/360450: type eth netdev B21pf0sf0 flavour pcisf
	controller 0 pfnum 0 sfnum 0 external false splittable false
  function:
    hw_addr 00:00:00:00:00:00 state inactive opstate detached

pci/0006:01:00.0/491520: type eth netdev B61c4pf0sf0 flavour pcisf
	controller 4 pfnum 0 sfnum 0 external false splittable false
  function:
    hw_addr 00:00:00:00:00:00 state inactive opstate detached

Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/esw/devlink_port.c     |   4 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 111 ++++++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   8 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     |   7 +-
 .../mellanox/mlx5/core/lag/shared_fdb.c       |  58 +++++++++
 .../ethernet/mellanox/mlx5/core/sf/devlink.c  |  31 ++++-
 .../ethernet/mellanox/mlx5/core/sf/hw_table.c |  10 ++
 7 files changed, 215 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
index 8b46634203b3..fa07a571c1b9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
@@ -83,7 +83,9 @@ static void mlx5_esw_offloads_pf_vf_devlink_port_attrs_set(struct mlx5_eswitch *
 
 		memcpy(dl_port->attrs.switch_id.id, ppid.id, ppid.id_len);
 		dl_port->attrs.switch_id.id_len = ppid.id_len;
-		devlink_port_attrs_pci_vf_set(dl_port, 0, pfnum,
+		controller_num = mlx5_esw_get_self_pf_ctrl_num(esw);
+		pfnum = mlx5_esw_get_self_pf_pfnum(esw);
+		devlink_port_attrs_pci_vf_set(dl_port, controller_num, pfnum,
 					      vport_num - base_vport, false);
 	} else if (mlx5_esw_is_spf_vport(esw, vport_num)) {
 		int spf_idx = mlx5_esw_spf_vport_to_idx(esw, vport_num);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 8c2c55ba5c35..09a29280c48e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -2183,21 +2183,58 @@ u16 mlx5_esw_get_hpf_pf_num(struct mlx5_core_dev *dev)
 	return PCI_FUNC(dev->pdev->devfn);
 }
 
-u16 mlx5_esw_sf_controller_to_pfnum(struct mlx5_core_dev *dev, u32 controller)
+u32 mlx5_esw_get_self_pf_ctrl_num(struct mlx5_eswitch *esw)
+{
+	struct mlx5_esw_functions *esw_funcs = &esw->esw_funcs;
+
+	return esw_funcs->phys_port_cnum;
+}
+
+u16 mlx5_esw_get_self_pf_pfnum(struct mlx5_eswitch *esw)
+{
+	struct mlx5_core_dev *dev = esw->dev;
+
+	if (mlx5_core_is_ecpf_esw_manager(dev) &&
+	    MLX5_CAP_GEN(dev, query_host_net_function_v1))
+		return esw->esw_funcs.self_pf_pfnum;
+
+	return PCI_FUNC(dev->pdev->devfn);
+}
+
+bool mlx5_esw_sf_controller_to_pfnum_valid(struct mlx5_core_dev *dev,
+					   u32 controller, u32 pfnum)
 {
 	struct mlx5_eswitch *esw = dev->priv.eswitch;
 	struct mlx5_esw_functions *esw_funcs;
+	bool known_controller = false;
 	int i;
 
-	if (!controller)
-		return PCI_FUNC(dev->pdev->devfn);
+	if (!MLX5_CAP_GEN(dev, query_host_net_function_v1))
+		return pfnum == PCI_FUNC(dev->pdev->devfn);
 
 	esw_funcs = &esw->esw_funcs;
-	for (i = 0; i < esw_funcs->num_spfs; i++)
-		if (controller == esw_funcs->spfs[i].host_number + 1)
-			return esw_funcs->spfs[i].pf_num;
+	if (!controller || controller == esw_funcs->controller_num) {
+		known_controller = true;
+		if (mlx5_esw_get_self_pf_pfnum(esw) == pfnum)
+			return true;
+	}
 
-	return mlx5_esw_get_hpf_pf_num(dev);
+	for (i = 0; i < esw_funcs->num_spfs; i++) {
+		if (controller != esw_funcs->spfs[i].host_number + 1)
+			continue;
+		known_controller = true;
+		if (esw_funcs->spfs[i].pf_num == pfnum)
+			return true;
+	}
+
+	/* controller matched self pf or a satellite PF, but pfnum matched
+	 * neither. It's invalid, do not continue on to check the external
+	 * host PF.
+	 */
+	if (known_controller)
+		return false;
+
+	return mlx5_esw_get_hpf_pf_num(dev) == pfnum;
 }
 
 bool mlx5_esw_has_spf_sfs(struct mlx5_core_dev *dev)
@@ -2264,6 +2301,61 @@ void mlx5_esw_vport_free(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
 	kfree(vport);
 }
 
+static void mlx5_esw_self_pf_cleanup(struct mlx5_eswitch *esw)
+{
+	struct mlx5_esw_functions *esw_funcs = &esw->esw_funcs;
+
+	esw_funcs->controller_num = 0;
+	esw_funcs->phys_port_cnum = 0;
+	esw_funcs->self_pf_pfnum = 0;
+}
+
+static int mlx5_esw_self_pf_init(struct mlx5_eswitch *esw)
+{
+	struct mlx5_esw_functions *esw_funcs = &esw->esw_funcs;
+	struct mlx5_core_dev *dev = esw->dev;
+	int num_entries;
+	const u8 *entry;
+	const u32 *out;
+	int i;
+
+	esw_funcs->self_pf_pfnum = PCI_FUNC(dev->pdev->devfn);
+
+	if (!MLX5_CAP_GEN(dev, query_host_net_function_v1))
+		return 0;
+
+	out = mlx5_esw_query_functions(dev);
+	if (IS_ERR(out))
+		return PTR_ERR(out);
+
+	num_entries = MLX5_GET(query_esw_functions_out, out, net_function_num);
+	if (!num_entries)
+		goto out_free;
+
+	entry = MLX5_ADDR_OF(query_esw_functions_out, out, net_function_params);
+	for (i = 0; i < num_entries; i++) {
+		int pf_type;
+
+		pf_type = MLX5_GET(network_function_params, entry, pci_pf_type);
+		if (pf_type != MLX5_PCI_PF_TYPE_QUERY_PF) {
+			entry += MLX5_UN_SZ_BYTES(net_function_params);
+			continue;
+		}
+
+		esw_funcs->controller_num =
+			MLX5_GET(network_function_params,
+				 entry, host_number) + 1;
+		esw_funcs->self_pf_pfnum =
+			MLX5_GET(network_function_params,
+				 entry, pci_device_function);
+		break;
+	}
+
+out_free:
+	kvfree(out);
+	return 0;
+}
+
 static void mlx5_esw_spfs_cleanup(struct mlx5_eswitch *esw)
 {
 	struct mlx5_esw_functions *esw_funcs = &esw->esw_funcs;
@@ -2371,6 +2463,7 @@ static void mlx5_esw_vports_cleanup(struct mlx5_eswitch *esw)
 	mlx5_esw_for_each_vport(esw, i, vport)
 		mlx5_esw_vport_free(esw, vport);
 	xa_destroy(&esw->vports);
+	mlx5_esw_self_pf_cleanup(esw);
 }
 
 static int mlx5_esw_vports_init(struct mlx5_eswitch *esw)
@@ -2381,6 +2474,10 @@ static int mlx5_esw_vports_init(struct mlx5_eswitch *esw)
 	int err;
 	int i;
 
+	err = mlx5_esw_self_pf_init(esw);
+	if (err)
+		return err;
+
 	xa_init(&esw->vports);
 
 	err = mlx5_esw_hpf_info_init(esw);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 463855240032..b6b8c35f0289 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -370,6 +370,9 @@ struct mlx5_esw_functions {
 	bool			has_spf_sfs;
 	struct mlx5_esw_spf	*spfs;
 	int			num_spfs;
+	u32			controller_num;
+	u32			phys_port_cnum;
+	u32			self_pf_pfnum;
 };
 
 enum {
@@ -916,7 +919,10 @@ int mlx5_esw_spf_get_host_number(struct mlx5_core_dev *dev, int spf_idx,
 				 u16 *host_number);
 u16 mlx5_esw_get_hpf_host_number(struct mlx5_core_dev *dev);
 u16 mlx5_esw_get_hpf_pf_num(struct mlx5_core_dev *dev);
-u16 mlx5_esw_sf_controller_to_pfnum(struct mlx5_core_dev *dev, u32 controller);
+u32 mlx5_esw_get_self_pf_ctrl_num(struct mlx5_eswitch *esw);
+u16 mlx5_esw_get_self_pf_pfnum(struct mlx5_eswitch *esw);
+bool mlx5_esw_sf_controller_to_pfnum_valid(struct mlx5_core_dev *dev,
+					   u32 controller, u32 pfnum);
 bool mlx5_esw_has_spf_sfs(struct mlx5_core_dev *dev);
 
 int mlx5_esw_vport_vhca_id_map(struct mlx5_eswitch *esw,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 3f182e6286d6..ff689b10635f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -4141,6 +4141,12 @@ bool mlx5_esw_offloads_controller_valid(const struct mlx5_eswitch *esw, u32 cont
 	const struct mlx5_esw_functions *esw_funcs;
 	int i;
 
+	/* User specifies correct non-zero self PF controller number */
+	esw_funcs = &esw->esw_funcs;
+	if (esw_funcs->phys_port_cnum &&
+	    controller == esw_funcs->phys_port_cnum)
+		return true;
+
 	/* Local controller is always valid */
 	if (controller == 0)
 		return true;
@@ -4152,7 +4158,6 @@ bool mlx5_esw_offloads_controller_valid(const struct mlx5_eswitch *esw, u32 cont
 	if (controller == mlx5_esw_get_hpf_host_number(esw->dev) + 1)
 		return true;
 
-	esw_funcs = &esw->esw_funcs;
 	for (i = 0; i < esw_funcs->num_spfs; i++) {
 		if (controller == esw_funcs->spfs[i].host_number + 1)
 			return true;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
index 404278a15ef7..fb96e9c3a5d8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
@@ -190,6 +190,44 @@ void mlx5_lag_destroy_single_fdb(struct mlx5_lag *ldev)
 	mlx5_lag_destroy_single_fdb_filter(ldev, MLX5_LAG_FILTER_ALL);
 }
 
+static void mlx5_self_controller_set(struct mlx5_lag *ldev, u32 filter)
+{
+	struct mlx5_core_dev *dev, *master_dev = NULL;
+	struct mlx5_esw_functions *esw_funcs;
+	struct mlx5_eswitch *esw;
+	int i;
+
+	mlx5_lag_for_each(i, 0, ldev, filter) {
+		dev = mlx5_lag_fn(ldev, i)->dev;
+		esw = dev->priv.eswitch;
+		esw_funcs = &esw->esw_funcs;
+		if (!mlx5_lag_is_master(dev))
+			esw_funcs->phys_port_cnum = esw_funcs->controller_num;
+		else
+			master_dev = dev;
+	}
+
+	if (!master_dev)
+		return;
+
+	mlx5_lag_for_each(i, 0, ldev, filter) {
+		struct mlx5_esw_functions *master_esw_funcs;
+		u32 host_ctrl_num, master_host_ctrl_num;
+		struct mlx5_eswitch *master_esw;
+
+		dev = mlx5_lag_fn(ldev, i)->dev;
+		esw = dev->priv.eswitch;
+		esw_funcs = &esw->esw_funcs;
+		host_ctrl_num = esw_funcs->controller_num;
+
+		master_esw = master_dev->priv.eswitch;
+		master_esw_funcs = &master_esw->esw_funcs;
+		master_host_ctrl_num = master_esw_funcs->controller_num;
+		if (host_ctrl_num == master_host_ctrl_num)
+			esw_funcs->phys_port_cnum = 0;
+	}
+}
+
 /**
  * mlx5_lag_shared_fdb_create - Create shared FDB LAG
  * @ldev: LAG device
@@ -257,6 +295,9 @@ int mlx5_lag_shared_fdb_create(struct mlx5_lag *ldev,
 
 	if (filter == MLX5_LAG_FILTER_PORTS || filter == MLX5_LAG_FILTER_ALL)
 		mlx5_lag_set_vports_agg_speed(ldev);
+
+	mlx5_self_controller_set(ldev, filter);
+
 	return 0;
 
 err_rescan_drivers:
@@ -277,6 +318,21 @@ int mlx5_lag_shared_fdb_create(struct mlx5_lag *ldev,
 	return err;
 }
 
+static void mlx5_self_controller_reset(struct mlx5_lag *ldev, u32 filter)
+{
+	struct mlx5_esw_functions *esw_funcs;
+	struct mlx5_core_dev *dev;
+	struct mlx5_eswitch *esw;
+	int i;
+
+	mlx5_lag_for_each(i, 0, ldev, filter) {
+		dev = mlx5_lag_fn(ldev, i)->dev;
+		esw = dev->priv.eswitch;
+		esw_funcs = &esw->esw_funcs;
+		esw_funcs->phys_port_cnum = 0;
+	}
+}
+
 void mlx5_lag_shared_fdb_destroy(struct mlx5_lag *ldev, u32 group_id)
 {
 	u32 filter = group_id ? group_id : MLX5_LAG_FILTER_ALL;
@@ -284,6 +340,8 @@ void mlx5_lag_shared_fdb_destroy(struct mlx5_lag *ldev, u32 group_id)
 	int err;
 	int i;
 
+	mlx5_self_controller_reset(ldev, filter);
+
 	mlx5_lag_remove_devices_filter(ldev, filter);
 
 	if (filter == MLX5_LAG_FILTER_PORTS || filter == MLX5_LAG_FILTER_ALL) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
index 2002b7f376ee..c8aa1b0b9319 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
@@ -237,6 +237,18 @@ int mlx5_devlink_sf_port_fn_state_set(struct devlink_port *dl_port,
 	return mlx5_sf_state_set(dev, table, sf, state, extack);
 }
 
+static u32
+mlx5_sf_get_self_controller(struct mlx5_eswitch *esw,
+			    const struct devlink_port_new_attrs *new_attr)
+{
+	struct mlx5_esw_functions *esw_funcs = &esw->esw_funcs;
+
+	if (!new_attr->controller_valid && esw_funcs->phys_port_cnum)
+		return esw_funcs->phys_port_cnum;
+
+	return new_attr->controller;
+}
+
 static int mlx5_sf_add(struct mlx5_core_dev *dev, struct mlx5_sf_table *table,
 		       const struct devlink_port_new_attrs *new_attr,
 		       struct netlink_ext_ack *extack,
@@ -244,9 +256,11 @@ static int mlx5_sf_add(struct mlx5_core_dev *dev, struct mlx5_sf_table *table,
 {
 	struct mlx5_eswitch *esw = dev->priv.eswitch;
 	struct mlx5_sf *sf;
+	u32 controller;
 	int err;
 
-	sf = mlx5_sf_alloc(table, esw, new_attr->controller, new_attr->pfnum,
+	controller = mlx5_sf_get_self_controller(esw, new_attr);
+	sf = mlx5_sf_alloc(table, esw, controller, new_attr->pfnum,
 			   new_attr->sfnum, extack);
 	if (IS_ERR(sf))
 		return PTR_ERR(sf);
@@ -254,7 +268,7 @@ static int mlx5_sf_add(struct mlx5_core_dev *dev, struct mlx5_sf_table *table,
 	mlx5_esw_reps_block(esw);
 	err = mlx5_eswitch_load_sf_vport(esw, sf->hw_fn_id,
 					 MLX5_VPORT_UC_ADDR_CHANGE,
-					 &sf->dl_port, new_attr->controller,
+					 &sf->dl_port, controller,
 					 new_attr->pfnum,
 					 new_attr->sfnum);
 	mlx5_esw_reps_unblock(esw);
@@ -274,6 +288,8 @@ static int
 mlx5_sf_new_check_attr(struct mlx5_core_dev *dev, const struct devlink_port_new_attrs *new_attr,
 		       struct netlink_ext_ack *extack)
 {
+	struct mlx5_esw_functions *esw_funcs;
+	struct mlx5_eswitch *esw;
 	u32 controller;
 
 	if (new_attr->flavour != DEVLINK_PORT_FLAVOUR_PCI_SF) {
@@ -295,9 +311,16 @@ mlx5_sf_new_check_attr(struct mlx5_core_dev *dev, const struct devlink_port_new_
 		NL_SET_ERR_MSG_MOD(extack, "External controller is unsupported");
 		return -EOPNOTSUPP;
 	}
+	esw = dev->priv.eswitch;
+	esw_funcs = &esw->esw_funcs;
+	if (new_attr->controller_valid && !new_attr->controller &&
+	    esw_funcs->phys_port_cnum) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid controller supplied");
+		return -EOPNOTSUPP;
+	}
 	controller = new_attr->controller_valid ? new_attr->controller : 0;
-	if (new_attr->pfnum !=
-	    mlx5_esw_sf_controller_to_pfnum(dev, controller)) {
+	if (!mlx5_esw_sf_controller_to_pfnum_valid(dev, controller,
+						   new_attr->pfnum)) {
 		NL_SET_ERR_MSG_MOD(extack, "Invalid pfnum supplied");
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
index d8d061683497..b7e8a8d7cc64 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
@@ -40,8 +40,18 @@ static struct mlx5_sf_hwc_table *
 mlx5_sf_controller_to_hwc(struct mlx5_core_dev *dev, u32 controller, u32 pfnum)
 {
 	struct mlx5_sf_hw_table *table = dev->priv.sf_hw_table;
+	struct mlx5_eswitch *esw = dev->priv.eswitch;
+	struct mlx5_esw_functions *esw_funcs;
 	int i;
 
+	/* If shared fdb is destroyed, phys_port_cnum is reset to 0.
+	 * So use controller_num directly which is read from firmware.
+	 */
+	esw_funcs = &esw->esw_funcs;
+	if (controller == esw_funcs->controller_num &&
+	    pfnum == mlx5_esw_get_self_pf_pfnum(esw))
+		return &table->hwc[MLX5_SF_HWC_LOCAL];
+
 	for (i = MLX5_SF_HWC_FIRST_SPF; i < table->num_hwc; i++) {
 		if (table->hwc[i].controller == controller)
 			return &table->hwc[i];
-- 
2.44.0

