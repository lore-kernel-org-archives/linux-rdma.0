Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.11
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794405461;
	b=HY+DJF2beJ6TItKZsnecNqfEFKN7WJtD3oBRxqa02XHPSqshnHNysH46RLGj72u3vj3z
	 lyYRR6aK7pVXKkviiOWkTUQVpMNgHbBixYeijUT6SZvT8+PwRWbQtyZZoTWvn2Jl6/ozM
	 DkXR7/6CBZ+kpHBwQcircfo1VOkudg3T7dkI2NiQVVpkmYzXTQ7JeyrJte0Icp3tPqHzs
	 3CtPFGtzoMsI4kAsjn/fieLEReu1CbAbgegHkBpdIU7NYF2MyABOg/uHaREdMJ0hvYSYS
	 2AyPMaVhkOB3NeZ1W+ySdKMZFndKWb7o1U6TskRO7TVQO/PIGN4uvNcV52tug9Cijyw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794405461;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 CC:X-Mailer:X-Developer-Signature:X-Developer-Key:X-NV-OnPremToCloud:
	 X-EOPAttributedMessage:X-MS-PublicTrafficType:
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
	bh=DudYBxh0es0LYTMZrbVxvO/4StZJ01nIw/b5YGk33SE=;
	b=LpEcSecyghCXRLtdZ98l4S17uPL2IY71TyCmZlsC1NYTpLqN0vPZNkdgZg7ZbcsHRZVF
	 oDhK63n7mO2Wt7UDrif6DQVOooWdTsVAdDeYOgh30FVuVY6RnzbBkBVWirjbgCKEUwdtQ
	 DPvbZdAlwAwzry0ZtS3r0jmarbZrErK3tMoSkUNN5d3rLMxy41bMQ4oPjwYsGvlSWxhB7
	 SEN7WSYktDOZxvrguytrToDgwOK/KzomsRY73UNu8X8eGSNfa8jVRaIBckSAuYH0wvz4P
	 BqEpMlvWSzQOSbIInAZxXASeR3PurUPkmmxPCLowRp+XAsTkSkLBpyUtjz/tYTIpvOw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ck5UR04J;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.11
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010011.outbound.protection.outlook.com [40.93.198.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D74606A327;
	Wed, 11 Nov 2026 13:57:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 90D74606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ck5UR04J
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F/IUAlBg9PuVm1NJobNLDo/C69rw3aoV9MAwmm0gsgaBUEQQfIjSrPcCscn/f6I5saB4gpHHXkh+3s5yu7Gu7WksJhr+DCZzJhV+8P4gw7fE/BedUxRN7v1JsDAFh+eXNmkqTKiCOy3EuJqPkBpetEdjwPm+65crG8+smljxHfjIMb29L81J3hW6QSS0ILkzyvTFNqhYvA3cMfPLTbW5VMUb8ABOhFpCMAnPWfDIS4vs7Ebj+cpGT2Eh4mqdseaZ+/+iyp0Xzw5J1Fb1HwcEAGZ+7WKIotfJqmBgENNn69RHuW3f85Un4C56GlR8K3q0ZiCOPGogZQR7unvrWRu2tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DudYBxh0es0LYTMZrbVxvO/4StZJ01nIw/b5YGk33SE=;
 b=pVhduTSQV6wYSdf4k8Tly/m+TGkLNlg8vqcob9OjhTBZLqDt0Jpvjc/35bOwng2pVZ62MhQHbSxPUOjn1g4hgvc5pT1IPcOy59e5JjiH62N1LVx6sj6C/6mSMOa5xo5JZUPCBv1xF5AVlCEdCzzPLr0YZy64D5QawfPaH/yHdCOmLraqutlNZ7vfD+tCmTBqXB69REKRipNfOOFq4UHdLyLjojavOwNp/vbwiRv05v959m5j9JslFCLKVKlARy8LV9wCTrOQeAoRFgNOjIoq9pHLDIjSmpM7DdtOEvh6JaV4ZsQZDtohVZC0n7b4Z8AO2Ds/ocERQF++CjiNnk0WyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DudYBxh0es0LYTMZrbVxvO/4StZJ01nIw/b5YGk33SE=;
 b=ck5UR04Jl5k2TSQUJr6LeFPje8iezZbg/WmJGRYauAlQV4A72mPUNwksDuUYWdKe8VlYI8WsizP3gphQk7iHHmMgCEVITQqS8OUemq1IZ6bTln2IJMMd9W0X8fmI+bZ/HgCBvC30Pd3hnh9C/1mEpB6bcfsPG6OJWTpyUgRXyG2h65mc45R7rrzF3h4WnLKbDe064CCJULFQmvvpWWUfJNGWYzvWH3bCBpiUnp/3oKRDNFJVjKqq9pLlMmWb9SL+SORyAdR/GNgEAAxM8P252I7IB+WnfKEUmqewZEzd9qkJDC0aCpJ+nLJD22ROvLnY3fkx78/bnDdoS05RNPh4WA==
Received: from SJ0PR05CA0156.namprd05.prod.outlook.com (2603:10b6:a03:339::11)
 by CH3PR12MB7572.namprd12.prod.outlook.com (2603:10b6:610:144::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Wed, 11 Nov
 2026 13:57:34 +0000
Received: from MW1PEPF00018891.namprd03.prod.outlook.com
 (2603:10b6:a03:339:cafe::87) by SJ0PR05CA0156.outlook.office365.com
 (2603:10b6:a03:339::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Wed, 11
 Nov 2026 13:57:34 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MW1PEPF00018891.mail.protection.outlook.com (10.167.249.168) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Wed, 11 Nov 2026 13:57:33 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Wed, 11 Nov
 2026 05:57:15 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Wed, 11 Nov
 2026 05:57:14 -0800
Received: from [192.168.122.1] (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Wed, 11
 Nov 2026 05:57:11 -0800
From: Edward Srouji <edwards@nvidia.com>
Subject: [PATCH rdma-next v2 0/3] RDMA: Fix DEVX UMEM mailbox size overflow
Date: Wed, 11 Nov 2026 15:57:01 +0200
Message-ID: <20261111-devx-umem-mailbox-overflow-v2-0-1e7ca8237b58@nvidia.com>
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
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAC109GoC/42NTQ6CMBBGr0Jm7RhaEKIr72FY9GeQSSg1LdYaw
 t1tOIHLl+/LextECkwRbtUGgRJH9ksBearATGp5ErItDLKWnRD1FS2ljG9HDp3iWfuMPlEYZ/9
 B07dCm76xpFsoglegkfMhf0CwTuFCeYWhTBPH1YfvkU3iOPxTSAJrbFXXaKW0vFhzXxJbVmfjH
 Qz7vv8AK4GzktAAAAA=
X-Change-ID: 20261109-devx-umem-mailbox-overflow-c741bc73deb4
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, "Yishai
 Hadas" <yishaih@nvidia.com>, Yishai Hadas <yishaih@mellanox.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Edward
 Srouji" <edwards@nvidia.com>, Sashiko <sashiko-bot@kernel.org>, Uri Dar
	<udar@nvidia.com>, <stable@vger.kernel.org>, Michael Gur
	<michaelgur@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794405431; l=2365;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=a4IL+fBm0ivsLguA4Ylm3cJBIfVxHbmvFzra8uYeBQc=;
 b=bBHjHES1AlFL4zOMCN/f6gAqaomDOpj7Yp5E/C2sE6+B8evFMfVzeNWjA1pD1pns/mm/Qm05M
 ywLI4y44sMIC7wbbHxnf+TW3AQAaWo++tsYFalG23musdAEME66ZzUo
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW1PEPF00018891:EE_|CH3PR12MB7572:EE_
X-MS-Office365-Filtering-Correlation-Id: 31c7845c-4c58-4cfd-a58b-08df3ffbbc72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|23010399003|36860700016|6133799003|13003099007|261009223027099003|10067099003|261028144727099003|261026140227099003|261026121527099003|261021123027099003|261102123227099003|261022075727099003|261021121427099003|261022105027099003|5023799004|56012099006|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info:
	3xKdQISxlX4GoBBHQYrqQqfvON/8+ARa5FGcJK6hEY7ldWsuOxvgAOn3XwGcKfAyAi1PXrIJPbawmoZOQT9VyZHUtnM9jhX6scxBadXI5H94wdYHtQ4+IGrLBbGT5fxd1LzWSL0WeZ8zhiGR5uW+GSxveuFvRP1tjLvBFYtNbbZi8DPyz8T0ZyPJ3nDqa70PB8wGIp+g6FctEJ0nzLnBVQat0BXLkvQDbEAv6Z5n6IMfRJZb8dGZt4TCIbigF6zyDs6pyNn4FtbEoHEj6Ntip8arzBG9lUT1poTPfCPwr14thlzo5v077Evlwh+Ga49/HSMwRCvXDrw3gKvwmYEWagsobrruzag6tgMfja0qqOQ+HD+Yv4M1e4u2IoMCIB2oG7qBLNANb3kpO6C7lPinc8LgZZWNmeW1L42/JTExK0mlr+zOgy9XwA5B2XLpt4bOCIVnWOoHYG23amJa2qrfnQ5nQ0NpVHvGmIrvfXmyMig+Gjpm2iQGbK6GYXPQ0zOraGm5tR4LKxjUJhmdQH/0pxGriCxOzUJzzzTaw9HJXJVjMl7gueHujcn2OPRPZXJALMSLgsKcsZYGPbolPXll8mvwJxnjPo4Y5IqMOOGVNuflYhGPsbVvDaimkhgGRHAzjdXpCyhQPqr9stpvbhpPOxfou8SqeyeQJo0Zh7Ejwch4D/oIyP2yMVmzq/dHb3OZOV6B4xAiUOi5hMNe00SEBw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(23010399003)(36860700016)(6133799003)(13003099007)(261009223027099003)(10067099003)(261028144727099003)(261026140227099003)(261026121527099003)(261021123027099003)(261102123227099003)(261022075727099003)(261021121427099003)(261022105027099003)(5023799004)(56012099006)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	1Qp2fERvKsNAm4S+WBd08BXHdKNTNOV0t52mVKEQnTsSwJJ0y8RB2OmHjtMVnZ+oir/zk6K2MwGe4xCfvDIuzZd3198Ye8o4Rh/LPGUV3QDksKmpMap6wTWTbr8+BWd5D9UQlqKzltuk+biU49o2L6uQucshS9x+8Nf58vympHhxs3n9khhOa00JruXMxkTym926NpQcct0W4s1XIOvS9kYEYA7BVtVLoj4eUCR1sNRZ6XtuR5V1BfDxzECxzAfTTEd2UyntMsOKdvE+4Qsv0OLrORL1RF0P0cPCgFnfL/3sjo9hEh3o3cC2PpZMMEVbQgEXsOnRPed31uPZwv1OKKp98slLhIJ+70r/ESaLHpW1XgntxYAWObrUyeeRhVG+Tqn/VTf9rEA8kqtsNpPlAg+kiFe+MrVTOOcO7VMJJXwPv3nFlgE3zVxN4qxjfbSU
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2026 13:57:33.9875
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 31c7845c-4c58-4cfd-a58b-08df3ffbbc72
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MW1PEPF00018891.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7572

Registering a DEVX UMEM builds a CREATE_UMEM mailbox whose size grows
with the number of MTTs, i.e. with the user-supplied length and
pgsz_bitmap. The size is stored in a u32, so a UMEM of about 2TB with
4KB pages wraps it, the mailbox is under-allocated and
mlx5_ib_populate_pas() writes past its end.

Patch 1 fixes a pre-existing issue in the same path, reported by Sashiko
on v1: devx_umem_find_best_pgsize() can return a page size that is not
in the user's pgsz_bitmap.

Patch 2 computes the mailbox size with the saturating size_mul() and
size_add() helpers and rejects UMEMs whose mailbox exceeds INT_MAX, the
largest in_size mlx5_cmd_exec() accepts.

Patch 3 handles the remaining corner: _uverbs_alloc() adds a small
header to the request before calling kvmalloc(), so a mailbox just
under INT_MAX can still push kvmalloc() over its INT_MAX limit and
trigger a WARN. Since these sizes come from userspace, the allocation
now uses __GFP_NOWARN and fails with -ENOMEM.

Mailbox sizes within 512 bytes of INT_MAX also overflow the block count
in mlx5_calc_cmd_blocks(). That predates this series and fails safely
with -ENOMEM before the command reaches firmware, so it is left for a
separate mlx5_core change.

The overflow was found with an AI-assisted static analysis tool and
confirmed by code review.

Patch 2 relies on size_mul() and size_add(), so stable trees older than
5.18 will need a manual backport.

Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
Changes in v2:
- Keep cmd->inlen unsigned and bound the mailbox size explicitly
- Add patch 1 to respect pgsz_bitmap when reducing the page size
  (Sashiko)
- Link to v1: https://lore.kernel.org/r/20261109-devx-umem-mailbox-overflow-v1-0-4a63baab25dc@nvidia.com

---
Edward Srouji (1):
      RDMA/mlx5: Respect pgsz_bitmap when reducing the DEVX UMEM page size

Uri Dar (2):
      RDMA/mlx5: Fix DEVX UMEM mailbox size truncation
      RDMA/core: Don't warn on oversized bundle allocations

 drivers/infiniband/core/ib_core_uverbs.c |  2 +-
 drivers/infiniband/hw/mlx5/devx.c        | 23 ++++++++++++++++-------
 2 files changed, 17 insertions(+), 8 deletions(-)
---
base-commit: e50525a486300e5ff8014c9985b8477b2fca0368
change-id: 20261109-devx-umem-mailbox-overflow-c741bc73deb4

Best regards,
-- 
Edward Srouji <edwards@nvidia.com>

