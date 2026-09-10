Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010002.outbound.protection.outlook.com [40.93.198.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CCC13D1CC3;
	Thu, 10 Sep 2026 10:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789035938; cv=fail; b=Cnb7eayKn6PpWIwszd1FVLDEzGgko3irU4c015rs9i/HsPOhvMn96J5VYbOwJe/whh5JekRQBUx9qUTHN36Tu1W3nKdyJwm82GRYueEbt84cIwgC5Ko4GhZ6E29NmEsgfcOD5Ar5nR73rUMD2IzU8+aGHu759J4XaElQGKner+Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789035938; c=relaxed/simple;
	bh=IP37fP4oD2tpK0bAqanpxhfVG1pLh600nl7LlbvRUdw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=b1dDvgJxHNpn6B5zxCXolSTGjFLJ74ZiR6QW2xBZg2ZLTEx0owR9+AmVcE0WIHit2yMPsbJf+trSwzd6aT5Qclw/DHP9HtYCHm2T0GI/IooW3KGH+opFtYGkoFFu8C/oJ3EaFlGHADMtwzkPuUQ38aK4pMlVe0wBDoETYzEAmlk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cfw18BXU; arc=fail smtp.client-ip=40.93.198.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cfw18BXU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lM+6RhC+RM/q0BYBeOpYq+FIcA98YAYeLr4DCBfaBAvWZ3vVAdQx7jIRRvgcMFVi2EdH9d5D+B7R3eEBl32F192+Nlg3jc0bT29ShEyPoJgOvb1wCfoWfs3Zlet5s4J4/jrWN7Hv0N3VyYmc9/MoXjkttzX3G+HH5g1ckmw3loE+vfI30pFF1VylLekgfbFe45Y5TGjbHiXHUfxSydZetJzVE4OZrM3Z4JTTgYJ3YJ7gtmi27v0nG2evUVVsrhTgr5vCFcxtnXq8KFZdkXC6RJymMh5mwIiuo2Y1pTmo8saGJZhBw+lPhrHnSe0yWKBZh9XRTQI7XzNPHkzAphXZ8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cU1YkSXL9umm/DSG1uN5z/XJ0eaD5YxJ+Uz6wNxJbQM=;
 b=FFarajv3GoAVekzPns1mVRJt86yyhmRF5indzVgPL/t1dKXezRxgsl5LWFtZPN/KjGnsUzbXXuqxEHm25UudQDKOYrLnSSkQYYanoXhcQsHACa4uckHw+S7aKpXpFGhqZbDATa6mPEhYPp3gRqCY4dfSL0+QrhEA+4bYVjpraISW8l0+F6X0sNAnMlPARJ6hi5SfiO8B93ArKs5xVtct52fBlKyFWpgkyKG4WgzWPStXNMw9nvxGKB6p8hNtGg3Qch/QelppW/KtkdVfYh0n1vmAIsEsAoI+U3L2AKmLdVPjrSxlz2XolKLu1wfYOxvah4oGN/YcQKulf+VUaZtKwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cU1YkSXL9umm/DSG1uN5z/XJ0eaD5YxJ+Uz6wNxJbQM=;
 b=cfw18BXUkFL31TcDXV7r6ogKnN2WXp5OlhFaTG1Ltyl5fBsvibrWVK7opUYWsnn3auPOEzKMDaswcKkPL8bIXDM4JVoFjkOYy5Yz1eqP4iFcTw068imiKIEr958tUoyxti3tFsM/gqFEuFS5EveJinbd/EGsXpbuEdNn9tmmWwEGV/r+N2gMx2w9rjJfhV8AZecmFTMpUvevN4tDOeMGyXLQeqBwhY1YD+iHDIDtdCg0BSGK/yMpV1nf8F0h1CUIiD9MUOEUc9Jh/VOQ+6Zk9sU+wIDS17WzOq+csyv9pm54V3rP4eyvClOiQJlb1lL3SQwxDGiQ+c/eoHMG829nYw==
Received: from BN9PR03CA0133.namprd03.prod.outlook.com (2603:10b6:408:fe::18)
 by SN7PR12MB8819.namprd12.prod.outlook.com (2603:10b6:806:32a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Thu, 10 Sep
 2026 10:25:24 +0000
Received: from BL6PEPF00022570.namprd02.prod.outlook.com
 (2603:10b6:408:fe:cafe::92) by BN9PR03CA0133.outlook.office365.com
 (2603:10b6:408:fe::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.8 via Frontend Transport; Thu, 10
 Sep 2026 10:25:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF00022570.mail.protection.outlook.com (10.167.249.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 10:25:23 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 10 Sep
 2026 03:25:08 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 10 Sep
 2026 03:25:08 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Thu, 10
 Sep 2026 03:25:03 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Edward Srouji <edwards@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Maher Sanalla
	<msanalla@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Or Har-Toov
	<ohartoov@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drori
	<shayd@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net 0/5] net/mlx5: fixes for LAG max_tx_speed update flow
Date: Thu, 10 Sep 2026 13:24:27 +0300
Message-ID: <20260910102432.3845360-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00022570:EE_|SN7PR12MB8819:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cbc31fc-913c-452a-69ea-08df0f25d2e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|7416014|376014|23010399003|82310400026|10067099003|56012099006|11063799006|6133799003|18002099003;
X-Microsoft-Antispam-Message-Info:
	goz8bELzuy5Lzi6cvyZPLOUL/uy9m5hG1Y5BMZO2kOLE0Hf6X9cEbH5Czq+YUZVjCQhqdfoujZOG78SGBXtnB5iG7Zq1t5Uct3n5qd6c5Q4NIDgsM+vsRgUZwQ+Yh+diJ9ANbekdj2/P010ltLhgCvXo8fGKlyL9tEi3+/XD17MDw8Z5yfbe5arCj4Bh7Cvno/qtob5GaYR0MPhKSjwha1yYb4nLN63owCzv2IbOO9fCFoL7FGRcYoTwL3J9E7dOAqXdjlv+Gv9TZ/CFK7bICYlrxfxFx7tB4qoyeuNJ245APoLVJ5YBAxZEvg7paLPlzHUiY8e4zROyKOFZrHluH1IFl+66x+p8ccFMVZrMsw4ZGnNowhkcADc4FdlysAIv27wN3g1jWfYATPXx5iUCpb+yUS2b6RWizFZuNd9qqKSmxmDPwTpUDVmiebNFwvHwhPj96bUa5UH41UH/E9LjfxGfkPeSh7IFQeJnylYUYlAwYd8gZ6xgyQfLjfUwYylTShnVYvNAdMrmGgQd7IwB4k+w1wObuD5fTKiaR3BEtiNvQR/VvEgQ8633lgFVy4A0xOg9XMkXA5TYuHwUgLtY/qbT/pyd7JLYZM5ON8WWFEevFOvyunp/D2IhRtFeFWXLYlj0fCwcdTJnlKEavHjd9mLVRzi6YpOgitPEpfuVH76r7mJnVxula6ZDVyh+6SdV
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(7416014)(376014)(23010399003)(82310400026)(10067099003)(56012099006)(11063799006)(6133799003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	3Gg1R48fW9ASBVjzELOfdBVce+VpSMx8sAb/ivUDvmniOWcLOTwv9ty3pPw8qZHWehIooGer50Gug3PIDVEz71unhFuovi7XOfwpL/zBjmQSZR4EZXxvUAQRQHA8Gb8MvKYyHnXEP0rwZZcLXTRyuxYEgz2uIhY5Nmbi2XyHqCo092pdXWf9EURNtdMeW/plo05n4dXiVucNz2VfXkDg2tFFDl2J2Glu9uUdnCBNKyQXyZuNHhPFmrFE6fwkfbVeUzPTYmbGvTsQAuUkcbfwQX1WeMwk4KOWUvdGXKqhyf9FvbSFmbJPkuZoRhw2ccavYvc0HswH4qpfCf3jn273+pE2jRpI+opoV60e8slyHCCwAV/wE6/9+FCvtBVegNIyqKdFj7EA8hRGGMI8+zEoDn8lDdbmnaKw1UOv3un/WqW70LRviBaU86vST8Sa3VqD
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 10:25:23.4279
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cbc31fc-913c-452a-69ea-08df0f25d2e1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022570.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8819

Hi,

Commit 50f1d188c580 ("net/mlx5: Propagate LAG effective max_tx_speed to
vports") added a mechanism that computes the aggregated LAG TX speed and
programs it into each vport's max_tx_speed via MODIFY_VPORT_STATE. This
series by Or fixes bugs found in that flow.

The bugs:

1. Down ports were counted into the effective aggregate speed.
   When a port goes down, PTYS eth_proto_oper is not necessary 0.

2. The aggregate was not limited by the NIC's PCIe bandwidth. It was
   taken from the bond speed, which is calculated from PTYS, and PTYS
   is not bounded by the PCI bandwidth of the NIC. FW initializes
   max_tx_speed to the minimum of the port speed and the PCIe
   bandwidth, so modifying it with a value computed by different rules
   changes the meaning of the field rather than updating it.

3. MPESW teardown never reset the vport speeds, leaving stale values
   after teardown.

4. RoCE LAG never told the RDMA layer about speed changes. The NIC is
   considered to be in a bare metal configuration, without a valid or
   enabled eswitch, so there are no VF, SF or PF rep vports to modify
   and no event of speed change was raised.

Patch #1 splits the LAG aggregate speed into an operative and a max
        helper, so that each can filter on port state on its own.

Patch #2 resets the vport speed on MPESW teardown.

Patch #3 caches the TX-enabled aggregate speed and programs that into
        the vports, instead of reading it back from the bond netdev.

Patch #4 limits the aggregated TX speed by the NIC's PCIe bandwidth.

Patch #5 notifies the RDMA layer of RoCE LAG speed changes via a new
        driver event.

Regards,
Tariq

Or Har-Toov (5):
  net/mlx5: Lag, split aggregate speed into oper and max helpers
  net/mlx5: Lag, reset vport speed on teardown
  {RDMA,net}/mlx5: cache and use TX-enabled aggregate speed for vports
  net/mlx5: Lag, limit aggregated TX speed by PCIe bandwidth
  {RDMA,net}/mlx5: notify RoCE LAG speed change via driver event

 drivers/infiniband/hw/mlx5/main.c             |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/dev.c |  20 +++
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 159 +++++++++++++++---
 .../net/ethernet/mellanox/mlx5/core/lag/lag.h |  16 +-
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   1 +
 include/linux/mlx5/device.h                   |   1 +
 include/linux/mlx5/driver.h                   |   1 +
 7 files changed, 181 insertions(+), 29 deletions(-)


base-commit: 00f9fbc12320253bfc576fb7539d860029c82d0f
-- 
2.44.0

