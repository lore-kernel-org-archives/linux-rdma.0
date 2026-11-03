Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.55
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793729612;
	b=nxxcw1kWwY65nTkQ3QgEeAjdKcu0HIOX5BG+xTOjO1jnPytNH4m0Hr061meI3Xjoj9Cg
	 H6IpPMg/mAuwSYVN1LIsp03JFujg2NINH85D+2NGtuARgkr1yaLYWssvjd8+IUkRmJIBY
	 zyUI2d6gCgRQX3amCH6R9MlZcmG+HyWm+TX9TTzi+iTIEvPLwFWjDX2J5OH5mvQXqgX58
	 VnY43MtfQk7PKrCUGsVtV1ySxBy9bYdeLeaqBFsUyvGNPvtVf1KPkwFDMHBTGh4GzDpCg
	 sBaQ77QWLUebgdUFZbJzwYv3m9F7LreitqbQI+mmSPo70uiEisy1FmTLxaA8niVIXUg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793729612;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Type:X-Change-ID:X-Mailer:
	 Content-Transfer-Encoding:X-NV-OnPremToCloud:X-EOPAttributedMessage:
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
	bh=IC4/gNIEAmBLq0deMV5szyZa2hGNSc6ewYLO/L4F8lE=;
	b=Ks6+Fb9aHfkyDtSvIc+4m3stSoGDszTXGcaC/MYSmVsjTHoe8sZ5qmVCEq5tZpA91sAz
	 4Ls9Q24C8H4vRVjLOc8DnbE5uBHOB1GpIr0C+qcsjMg00ZDRaCh5daQpDbEx6mj276sbe
	 /zZQVnnoaG2En2pO6mB50ii+iS+EwHB3A81Wlf+nLbNr1r4tsWqg2kDyqMxPYB7nwoMnh
	 ZZ9dOzNAzOxMQeM4x31S66p7uIzKBYerLWnycR/a1tFLEouk7kulgDVyJ6QBvVyphGfXJ
	 xUTVYVPrzbVEZ25qyv6Isj0JP0AsYpeZaZKWXeYNJ8MS3kDXJFAf01oyhf/LsjtiGeQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=GHs7lmsb;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.55
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011055.outbound.protection.outlook.com [52.101.57.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C81A606A324;
	Tue,  3 Nov 2026 18:13:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6C81A606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=GHs7lmsb
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ycE6HToRdCk+pU0SCqZB82R/Yy52GgKfYqhg1rA35voYjc24lnI3ySCWBcS6h54TPR1ma1ouufp7AMV6SyyxcRYpEquwDkl48EWq1VuZKmJwfgXLloEArQHLvXKE8yTzMHSXA0GyBjmTlLAdUYeJ7C3H5XEEwAjlVeSfwNWgD0PBGn1kuO5EKRNzTlDCShmWXt3XDuUA+PtfT89mJYXB0DFpvXZUw9Cad380mLhQafm/3uFqi/OiYSvKbjo9ytgrWIJpPK9wfAmPFCkXCyh3GvcTmAd91/tIWlPeZM/N3amxvr62t31Mi2kyglNu2sabtM/4RfbovBTzyJVwK2KNTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IC4/gNIEAmBLq0deMV5szyZa2hGNSc6ewYLO/L4F8lE=;
 b=I7SDQeG0fDV0j5e3tOuof4JYeGnbo670Ww2+wCCtKKSuKdh5S2K3ZCgMzdyffqIbAFKoTHhn6oWI4lUVjcEpAX1+8CDkvFiEpb91otgPcarrenwjwXpVhemx4kd5nDnFKbz7niwMtkcv6M/VYDjB7SmMW+/oZ6pD7DdA5CiiNNkcZXXqPpo5nioBE5i1NjxCKTf9uBBy9so5ewlthOSTXo/YR7UnHbZJmqZy5YgMlkI6255LYeB/NsGBwRz3JJYCTKFBo7O4TFf5XbqPoSzcuhn5TSYHQeKV373tA5o1jUezhT4euNnOLiVtCgJiokOBhacOTbGPewyU2UUTIjPZaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IC4/gNIEAmBLq0deMV5szyZa2hGNSc6ewYLO/L4F8lE=;
 b=GHs7lmsbjM6lSurST1eBNrlRo4wHtNS5L0g9w6K94BBGJU8kR0CfrPKpN8UUj8VC6BLZ5rxzV6DvRkZIYcFp5/A6CbQ3Vgcw9ru/VaiP3it+p7ArG8J2QkohNeogogirWB+Q7c/stdN9HSWCHhWUDECKLM3dd1pS4rJfhk/yVocd3RoNghbFM4FBbZ1wclFjxB8RlWFl04+vn2KWjqqk6WLQD62op6KPgNnztU7kDGC9CpzGWn42TzXtZpwSVxLzZoT6lBS+es4ooMuM10kYV8vaQelV7DaTPZ1t39TOoHCJeeUa/6nRtbHwopyyiRc0L0alLW9aq9nstoG4Tll7DQ==
Received: from MW4PR04CA0140.namprd04.prod.outlook.com (2603:10b6:303:84::25)
 by DS6PR12MB646826.namprd12.prod.outlook.com (2603:10b6:8:4b7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Tue, 3 Nov 2026
 18:13:27 +0000
Received: from SJ1PEPF000037B5.namprd05.prod.outlook.com
 (2603:10b6:303:84:cafe::30) by MW4PR04CA0140.outlook.office365.com
 (2603:10b6:303:84::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Tue, 3
 Nov 2026 18:13:26 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF000037B5.mail.protection.outlook.com (10.167.244.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 18:13:25 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 10:13:03 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 10:12:58 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Tue, 3 Nov 2026 10:12:54 -0800
From: Edward Srouji <edwards@nvidia.com>
To: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Andrew Lunn
	<andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas
	<yishaih@mellanox.com>
CC: Edward Srouji <edwards@nvidia.com>, <linux-rdma@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Mark Bloch
	<markb@mellanox.com>, Michael Gur <michaelgur@nvidia.com>, Patrisious Haddad
	<phaddad@nvidia.com>
Subject: [PATCH rdma-next 0/5] RDMA/mlx5: Add NIC_RX_CLASS steering domain for RDMA classification
Date: Tue, 3 Nov 2026 20:12:48 +0200
Message-ID: <20261103-rdma-rx-classifier-v1-0-1ad6c8cfe936@nvidia.com>
X-Mailer: git-send-email 2.49.0
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20261103-rdma-rx-classifier-866946b90d6a
X-Mailer: b4 0.14.2
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000037B5:EE_|DS6PR12MB646826:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d40f1ff-d28e-4eca-a24b-08df39d6279b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|36860700016|376014|7416014|82310400026|18002099003|921020|11063799006|56012099006|261009223027099003|261026140227099003|261028144727099003|261026121527099003|261102123227099003|261022105027099003|261021121427099003|261021135927099003|261021123027099003|10067099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	aZXb1jatrE4rFlKNFxxCVUaM+AXZ6BqLdFUyZw/oYaubvCM//cfRc2NXj0+bwswseA0zxUKLh/PfwgkKN4Bt+NNnkbx5ZlxOdpuhaM6ULUuEkVsgWjT0TMGzyeD5L3M10TFJsSbERsiJjZDhIf37qIxEZ2NOreahnHlP4OlkPoDFE4VPNfZU8j93UanTlrKT5sDRqxaHK0lCX40O36iyTFMmxA4zDAj4JQ8J6mQvWk5Vj2EhEEuKRDY410NGLKn3fb0TMlhjgi7XxwITWSfPBWUGkn7k+0wK0fa8lCj4W6zsKsECrWPIdXoui6XV6vGOry6EcqKmfRyY8DwixBUQYUsLuhWgdKMUMedEvDqaiDR9L+OIBXqSqhhpVwGuhz1i1k7b1U55OAF2x8h0PoQJd1ZLWl0zwmD2natf90x/QgeWh49qUUBpTHWtt3YLY+rPyN2O1YYWXNbaqa45lPqlYVK5IMvDdxbCD5ojq0erdFbaCwLLD4E8GAzPqaTBI/PQsGcgSp7E6YsAa+mQ+clCgDsBgY2OkDCsZAACCmPlV/7HVsf0Dgis47rlEi4Dq52J3IWe+FNxlLDau3QuloWiMfdfAcHQwnQFIkTscXOj+c5Rgsl6z+RW4kCLXBxEUIRZYSY8q8TbWZm1e2VYSEYEbSKtfjYM0MZ5TLGPU1IoUeejtRaV2KozcOAEUq1ckPLjm2kIKL86brgkv58X5r4GwFpcXPt9i0b4VlD1vIO8JV/uqkcqPoBXfv4QNyDy9sfg
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(36860700016)(376014)(7416014)(82310400026)(18002099003)(921020)(11063799006)(56012099006)(261009223027099003)(261026140227099003)(261028144727099003)(261026121527099003)(261102123227099003)(261022105027099003)(261021121427099003)(261021135927099003)(261021123027099003)(10067099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ikJNf61Iw+D2puvwtjix6JiwYJGfE+vw+Tz/ySYjaOD24w1EtbHwvyHwVlGgcMZd3QS1V2bckr2L01D3cOXCKjguSMOPGywT0DSC2nnZLnWDrQzYUwwjcWJepmUKsOCaiIiZ3TNmLv/ufFyIePC62WVESv3iS9Nff5oITwZXBwgtjnJGQhLIZV48bfVdtiP679fAxoTZnR6k8o9dVdQnkHFwnwiuNonjnO/gA4swj2YxPYXoJEOmV6XhOKH2xkIuNrmD/GgxVPRdKJFjq+b32wKP0IsQw+RPXx87CaHoSNN79cTVFsQPaIqVixA4gOuk2TG6Wwyx7oeXSytbaEOFeIHHfYx6LQB8/P30mq22gEnZJtx5HSKTl4f+S66gI5th0W7UyrYj12ETNtXw9ZnuTiR+FKUVqSmv59OfrVYPoY0mZaepjWoGRS/X37ZwKxCZ
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 18:13:25.9948
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d40f1ff-d28e-4eca-a24b-08df39d6279b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000037B5.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS6PR12MB646826

mlx5 devices recognise RDMA traffic on receive with a fixed classifier: UDP
destination port 4791. Packets that match are handed to the RDMA receive path
(NIC_RX_RDMA); everything else continues down the normal NIC RX path.

RDMA transports that identify their packet differently don't reach the
RDMA receive path as they use a different packet format entirely.

This series adds NIC_RX_CLASS, a new per-vport receive steering domain placed
ahead of NIC_RX/NIC_RX_RDMA. It gives a privileged RDMA transport manager a
programmable classification stage that supports matching on arbitrary header
fields and marking the packet as RDMA.

NIC_RX_CLASS reuses the model used by RDMA_TRANSPORT_RX/TX domains:
- one root namespace per vport, owned by the eswitch manager;
- targeted from userspace by `ib_port`, as with the existing per-vport
  domains;
- gated by `rdma_transport_manager`, and by
  `rdma_transport_manager_other_eswitch` for the cross-eswitch (LAG /
  socket-direct) case;
- restricted to callers holding the same UCAP that per-port matchers already
  require, so an unprivileged process cannot program another vport's
  classification.

A rule in this domain takes no destination: it matches, attaches a
modify-header action to mark the packet as RDMA and explicitly allows it
onward. ALLOW is the only terminal action the domain accepts; a flow counter
may be attached alongside it.

Patch 1 adds the IFC bits, patch 2 fixes ALLOW handling in the FTE merge
logic, patch 3 unifies the per-vport root namespace init/cleanup helpers,
and patch 4 adds the NIC_RX_CLASS domain itself. Patch 5 exposes the new
domain and the ALLOW action to userspace.

Patches 1-4 are mlx5_core changes and are targeted at the shared mlx5-next
branch, prefixed accordingly; patch 5 depends on them and is targeted at
rdma-next.

Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
Michael Gur (5):
      net/mlx5: Add NIC_RX_CLASS IFC bits
      net/mlx5: fs, treat ALLOW as a conflicting action upon merge
      net/mlx5: fs, refactor RDMA transport manager root namespace init/cleanup
      net/mlx5: fs, add NIC_RX_CLASS steering domain support
      RDMA/mlx5: Expose NIC_RX_CLASS flow table type to userspace

 drivers/infiniband/hw/mlx5/fs.c                   |  59 ++++++-
 drivers/infiniband/hw/mlx5/fs.h                   |   2 +
 drivers/infiniband/hw/mlx5/ib_rep.c               |  25 ++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h              |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c  |   5 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 178 +++++++++-------------
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h |  15 +-
 include/linux/mlx5/device.h                       |   3 +
 include/linux/mlx5/fs.h                           |   4 +-
 include/linux/mlx5/mlx5_ifc.h                     |   9 +-
 include/uapi/rdma/mlx5_user_ioctl_cmds.h          |   1 +
 include/uapi/rdma/mlx5_user_ioctl_verbs.h         |   1 +
 12 files changed, 173 insertions(+), 130 deletions(-)
---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20261103-rdma-rx-classifier-866946b90d6a

Best regards,
-- 
Edward Srouji <edwards@nvidia.com>

