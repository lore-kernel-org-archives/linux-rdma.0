Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794335958;
	b=tD6K+dhf8TySArSOeP4sboTBCs7/VeuCDGDlG3fSAn48IInLPF3wMZ+ZGeBIvJBamYZU
	 Zx+xTiGch2fFE+YZ/9gCmcBRv8nOSWrAfWhBLApUDvoQS7iW2nt1++j6gdBsY8gL+RzQv
	 ueE8bqy9p2WvfaI7Wkdd4odMzm9hGNtihPd1U/SZVViCWkPoZsBywQoYuyfGfZjujcSBW
	 W+TOZaol1Bv1fhz4sENQtRA0DtWHCifoV7/hWrzyOmsPBGF3HMCcbVVXFUO6PeNXGPIC0
	 qZgmEjJzc7O75Uv9RutebGej+ezkmC8fXY2Muyk24RnEuJ5rCMRu3e1yRw3DrCYhCuA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794335958;
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
	bh=CGly+eA60kgQxZwDDThc5EYBNudTiNiUo3j9g3pjFss=;
	b=XhzcDq8ZAGaadAT5Olt+xf2REgWkfw4lF+CmbLhDaiCGkblwTRD8T1n+NyWaIRwNX7xu
	 8qEz2prjMUk0mBZz5iRPrdt5C8M0MLWUmSrXke9q1GwmHHiIAuWNKRPbnQVQ4kUJ0vq5G
	 yg210oVJpDR24gph0btmAI0011harwLaVirNiU3t9cG/uLVjeyxob+Lyp5SaJQNKBerIF
	 cn2nj6BwdUVnEPvJ4onCf0WSTV0A+tV5gRHpjw15gqbl9f+u4jWdE59y/SlGWs/o2FO6a
	 vFbJ9+7ooOXHqKdrhvSJsvF5wZzTp1UAhzMP1qDDLK6ff2C+6Zb6QrjOSL96DnuyVTQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=KgdARZ4I;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.47
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013047.outbound.protection.outlook.com [40.107.201.47])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF3E606A338;
	Tue, 10 Nov 2026 18:39:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6AF3E606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=KgdARZ4I
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vSGJPivBn0b62H4xaA3Jg/FsOGw20uwJXoAqBx8UX+0zZqog9Cv4k2tHkDmB+OT32WmUVzNs0ecJuvj+uR4+6yUq6IYNqnxgMxxTKFwZ40YLjYHNk0ZvbR+Cbc5KFOQjzogoRIUkaUQGPv1LSYQYDaHjqhf2WQHQIKfLzGratxg8tdh4Bj/t2vZ2FWNBPPkFEMtt+jUN9T4oDe3/sXHiKKcdPeAAs14/oQE5YcKQpgdhF1SYI4skBNcJ+hk3N5gMwAvC8VgJW9CkDxRpj7NeKA41dCmbX/H2oUg6qDQt/vnN7tmzt3CNh9PlOZ1H2OPK8Tw5z+lO15psn1URTVxzTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CGly+eA60kgQxZwDDThc5EYBNudTiNiUo3j9g3pjFss=;
 b=tsFzVcD8ShWTKeka0aqxdfybPIAFkBfIGEssReLfSJJfDztWMzlFToOXlAI05EwuAmfJWUd+Qk9CVJYSKkkuSFHVViIHjiL1Jrrg9Z603lNmDtwxodQ7PpzAtw/MlJfaeVaN9VQumFIQm3ymhav8VBSNP3cesbpMbasi2bSNUs2tb5P5iOZ8+SaJkdoSnlsV7OOWdAt4A3Yc3PDHNi9OAByGEb8bX6o0FlzVLS17huwGcm58OgoitgAIDjKJFfrDBOm95a8aDlTmB5IkoLjzuu3b7il9PpcNJ2wQAzS73xAu71BBpyQaB7YADAPv1UlpRv5SEmUZLMlWphQZeXeIAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CGly+eA60kgQxZwDDThc5EYBNudTiNiUo3j9g3pjFss=;
 b=KgdARZ4IkYG+6pnZ8ltF3JYfeecXOgkIaHUCk74wlswJVWn5ObY5xZ2YkxN16ioeZppF75rILXIZlyqBTLLZSsdQVd6lwN9HVLOx8DkjIBlhzfns/NEx3dYblfMajEWeOmzjZ2/h9sQBer5nzk2mVPIr4OQNQLIXlar8M+PqIuTKAGjDaF1zzmmeyxvxxa8opF/aDuDHU/Tn3nfYx0nsQs7kJR+L/iTmvpX/+1G4VHyOGjZ/kqTKfFudhl2HsIJP1Qo1mDQmc/NGYQLbemqV8h6LrR/GlgjOL2z6S9etuU4k5iR6jCjnwUUJTk0I98sN4XM5jgExaH7cIOcurMUt5Q==
Received: from PH7P221CA0043.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:33c::31)
 by CH2PR12MB4245.namprd12.prod.outlook.com (2603:10b6:610:af::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 18:39:09 +0000
Received: from PH2PEPF00048914.namprd05.prod.outlook.com
 (2603:10b6:510:33c:cafe::50) by PH7P221CA0043.outlook.office365.com
 (2603:10b6:510:33c::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Tue, 10
 Nov 2026 18:39:08 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 PH2PEPF00048914.mail.protection.outlook.com (10.167.243.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 18:39:07 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 10:38:47 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 10:38:47 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 10
 Nov 2026 10:38:40 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Bobby Eshleman <bobbyeshleman@meta.com>, Carolina Jubran
	<cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, Daniel Borkmann
	<daniel@iogearbox.net>, David Wei <dw@davidwei.uk>, Dragos Tatulea
	<dtatulea@nvidia.com>, Erfan Sharafzadeh <erfansh@meta.com>, Gal Pressman
	<gal@nvidia.com>, Jacob Keller <Jacob.e.keller@intel.com>, Kaifeng Wang
	<kaifengw@google.com>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Matt Fleming <mfleming@cloudflare.com>, Mina Almasry
	<almasrymina@google.com>, Nikolay Aleksandrov <razor@blackwall.org>, "Saeed
 Mahameed" <saeedm@nvidia.com>, Simon Horman <horms@kernel.org>, "Stanislav
 Fomichev" <sdf@fomichev.me>, Stanislav Fomichev <sdf.kernel@gmail.com>,
	"Tariq Toukan" <tariqt@nvidia.com>, William Tu <witu@nvidia.com>
Subject: [PATCH net-next V2 00/13] net/mlx5e: Add netdev support for data direct
Date: Tue, 10 Nov 2026 20:38:13 +0200
Message-ID: <20261110183826.2927274-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: PH2PEPF00048914:EE_|CH2PR12MB4245:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d4c84a3-acb7-4ee6-effa-08df3f59e7a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|36860700016|7416014|82310400026|261009223027099003|10067099003|3023799007|261028144727099003|261102123227099003|261026121527099003|261026140227099003|261021123027099003|261021135927099003|261022075727099003|261022105027099003|261021121427099003|11063799006|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	4mUS01f9jYbdD93t9q0s3pqBY43Qre6uQz/7ESHFkuohtLu2NIFPiotwMN3bFgkhKrMk+IG5DP+raaLokn2yjxVsmqs1AGzkT3VstC2LyIehh21SKHNOQZHRomBS7POkhOyQL1KQ2QDdXvpOiVhQuSnZCVoXHB4zJtY4XKKJcSDTTxWSH+n0PWXBO9OykGFHZOXu0XDtoYZQFKs98+RKbZD/9/f+1uCgQclMX/uJAcg7zWbezALKnuFhqWYPjpxBKMLwGYsqqMlRYfq1uvjWiMgJ50QHPvjoalCC3ZW/JPbd6IJRLfzz8bWVUiIvXjGH3iR6vl35WJUu+gRNxi+cjJ2J5uryKsal89n4BXQX/jpK1PANlbsO2WAfaVQ06/w8+MwYydsg9VvLBH5+WKZleV3iFarCgPKJeW51s2+YHH9qqJI9AUeaxLBo6QH/N9QidOfuyyHDVzy2QWNyls0U4YrfLdBz/UPSToU28AZenRvKS6+doSyvzBTcOcdpNQBYoU+YvXBb6m+r7CqNxjEn277rskXKZn+9BvzRtrc6e3YfVx1We1ECVcBygBpuwWcDKJ50usfnEX7LOZpGDGvH9qsNT9Z8oA6v066AeduVm4aGnCWCro7nenY65PmrlhrwTMmrUO0P0WyT+JdM+uT/JkNw1S7V/0durIU5D1L9EZVOR0BNw5f2NRFLGqwqaxHjDI4LoqSexFXg3IxsgCMCBg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(36860700016)(7416014)(82310400026)(261009223027099003)(10067099003)(3023799007)(261028144727099003)(261102123227099003)(261026121527099003)(261026140227099003)(261021123027099003)(261021135927099003)(261022075727099003)(261022105027099003)(261021121427099003)(11063799006)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Mw0/tskPrec/ovTbxfCFlAB4nMa+vll+78AdYZQ5Tw4IDb5xJhjT9ZE9kbiHP9OjPW6BBUQ7VlL/LesS8ozRs3j39XWsXO3Ht7rCSJUvJTs5bBfTIvt+Xh30P060jD845shstGKz1USuodTHOqpz8CCmAsgc1wZsW/FndJeSX5dAOsMM7trNijMm2McD2j5SUJ3fyu9qK0E3O/FpAnz+68xT+IGBxF59RWvKxL6yo1XUlaW5+wFhFtCKbgE5z7sQ33BBVV8YVOVP/nCGBtthP05D1YCGFPHCoyGS7lcsK6I2/ceYW5MV+Ilm4PiKIw837rdq7GEeob1gf/Dsn+21CNFlk7Y5Tm5h9FtuI9jHDZAsE9ZfOmOr7L8kBFcuBfgp7karvRlOKDJX3iX/Ffo4tk4E/xBnopdFetqvm/Q8sR55yt0f1Pme2GsSjcjCD3XX
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 18:39:07.9945
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d4c84a3-acb7-4ee6-effa-08df3f59e7a4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	PH2PEPF00048914.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4245

Hi,

This patch series by Dragos adds data direct support for netdev devices,
allowing a mlx5 netdev to issue DMA commands through multiple paths.
This feature is critical for improving performance and reaching line
rate in certain environments where issuing PCI transactions over one
path may be significantly faster than over another. These differences
can arise from various PCI generations in the system or the specific
system topology.

Data direct for netdev will work with devmem by returning the data
direct DMA device instead of the DMA device of the NIC. Each PF netdev
registers its own data direct device and support for RX and TX datapath
is added.

The feature is enabled though a ethtool private flag. When this flag
is enabled, the driver will return the data direct device in the
ndo_queue_get_dma_dev op.

When the data direct device is unbound, the netdev is closed, the
memory providers and TX dmabuf bindings mapped against the device are
unmapped through the new netdev_unbind_dma_dev() core helper, the flag
is disabled and the netdev is reopened. The helper does not care which
memory provider is installed: devmem and io_uring zcrx are both
uninstalled through their mp_ops->uninstall callback, like on netdev
unregister.

Regards,
Tariq

V2:
- Patch 2 (new): Detach auxiliary devices on attach failure during load
  in mlx5_load_one_devl_locked().
- Patch 3: Move the data direct notifier unregister to after
  mlx5e_nic_set_rx_mode() in mlx5e_nic_disable(), alongside the other
  NIC-disable cleanups.
- Patch 4: Reword the commit message.
- Patch 6: Size the ICOSQ for the UMR mode of the RQ, since KSM UMR WQEs
  map half the pages of MTT ones.
- Patch 6: Initialize umr_mkey to avoid a maybe-uninitialized warning.
- Patch 7 (new): Use the page_pool DMA sync helper for SHAMPO SKB frags,
  as unreadable netmem is mapped against the data direct device rather
  than rq->pdev.
- Patch 8: Document why the data_direct private flag is not propagated
  to PTP SQs.
- Patch 9: Return the data direct device from ndo_queue_get_dma_dev and
  use it for the page_pool of data direct RQs. Fail with -ENODEV if the
  device is gone. Reject leased RX queues in data direct mode.
  Bound-check queue_index.
- Patch 10: Walk the bindings xarray and report only bindings that are
  still mapped, instead of tracking them on a separate list.
- Patch 11 (new): Add the netdev_unbind_dma_dev() core helper, which
  uninstalls the memory providers (devmem and io_uring zcrx) and unmaps
  TX bindings of the departing DMA device.
- Patch 12: Replace the channel re-creation on unbind with closing the
  netdev, calling netdev_unbind_dma_dev(), disabling the flag and
  reopening. Also release the providers on suspend. This addresses the
  dmabuf binding limitation noted in V1.
- Patch 13: Reject enabling data direct on uplink representors and in
  socket direct mode. Block flag changes while a memory provider is
  installed on an RX queue or RX queues are leased.
- Add Reviewed-by tags from Cosmin where applicable.
- Drop the "SHAMPO required" gap: only enable data direct on an RX queue
  with an unreadable memory provider when SHAMPO is active.

V1:
https://lore.kernel.org/all/20261008132815.654147-1-tariqt@nvidia.com/

Dragos Tatulea (13):
  net/mlx5: Log the data direct to PF device mapping
  net/mlx5: Detach auxiliary devices on attach failure during load
  net/mlx5e: Register supported netdevs as data direct users
  net/mlx5e: Pre-calculate UMR padding and entry size
  net/mlx5e: Add data direct ethtool private flag
  net/mlx5e: Add data direct RX infrastructure
  net/mlx5e: SHAMPO, Use page_pool DMA sync helper for SKB frags
  net/mlx5e: Add data direct TX infrastructure
  net/mlx5e: Use the correct DMA dev when data_direct is enabled
  net: devmem: add netdev_has_dmabuf_binding() helper
  net: add netdev_unbind_dma_dev() helper
  net/mlx5e: Disable data direct on data direct device unbind
  net/mlx5e: Enable the data direct netdev feature

 .../ethernet/mellanox/mlx5/core/data_direct.c |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  14 +
 .../ethernet/mellanox/mlx5/core/en/params.c   |  18 +-
 .../ethernet/mellanox/mlx5/core/en/params.h   |   2 +
 .../mellanox/mlx5/core/en/reporter_rx.c       |   1 +
 .../mellanox/mlx5/core/en/reporter_tx.c       |   1 +
 .../ethernet/mellanox/mlx5/core/en_common.c   |  38 ++-
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  67 +++++
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 253 +++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  33 +--
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   |   4 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    |   1 +
 include/linux/mlx5/driver.h                   |   1 +
 include/net/netdev_queues.h                   |   1 +
 include/net/netmem.h                          |  24 ++
 net/core/devmem.c                             |  85 ++++++
 net/core/devmem.h                             |   6 +
 net/core/netdev_queues.c                      |  51 ++++
 18 files changed, 573 insertions(+), 36 deletions(-)


base-commit: fa5196392691051963726787944db872420dfa75
-- 
2.44.0

