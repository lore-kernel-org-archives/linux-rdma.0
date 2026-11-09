Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794235390;
	b=0cK6GOmdtkLJTecfpm8iqTRx6SiX6mnVX5CGeNcTzcAYF3N340j4s7qTJk5usyS9S0u+
	 9dGLZMHcfQZVPra/Rjk0/UG5OlVgiqWGwPNdg3n2/tkuJrCszexH5ku6EPamPv1hk3Xww
	 VzLkUgDE0Mqj/6MiqO4yHZ1MWcDgoZafddlz6GPNkYrr/MTlAgdaaRocipwOhpRifQqRv
	 6JBBbpSor9MMwgRJlF6A/q8I0c2JzjSWsG1zp/9exvcxp8TfgLCA1kXUpjJCQ7j+oB4C1
	 t4dwtMLYQ1hAssLvBX8sIh0J1LQVbnGwP9i4Ohpfa6BayHhIOZMdDXjH3HnTRl6V9NA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794235390;
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
	bh=+feadaHUJWCWBZdG0UVWHmd3rE0Ov5SazUdYjKyyBkw=;
	b=G1XVNDwsnWZzmGfyzOGcvZQU9eQJPdvSjmYjH5ZnPb86OSioGH7WSn+zd5fYFF2ioJgu
	 LbLcRK8uRfSjxPkiBGvdcV4b3ZFANOyZe3twNIw2ztl2VeZQoRuLVgVvaIz9XH89La4kC
	 HSJ4ufu5XPUEfHGlDLv54e0y3rNl7IkqgDgtu71iJKZFr+g6S6WqhV8jLbAUsOghQqQzH
	 nYkgWbP5OsIxz+OK8BXQ0pJBBTDUeQx8n0VhOARbOd6YtByCJ46mBg7ipLBiZFyUeUEjX
	 HjQHVDJRk9GUhOVyHmbTyy+NjxGFCCoqMBO23CxHBf4c6cSAVHI/HuQKXQAFCxFiFvg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="oEyQ/nSA";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.44
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012044.outbound.protection.outlook.com [52.101.48.44])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B225606A31C;
	Mon,  9 Nov 2026 14:43:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3B225606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=oEyQ/nSA
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=McxaiP+SWUttH0ksvu9oxSttNHxtJSyR1x1nQXYc42025be4m/0H/JZ5oz1Fr7uPNJejuWk6VtmzSmTrP/0gBvZYMMsr7qsr1OassqBCs7t9JRFJKrnFGZe7f4/ht1yyaNfJyL4mmdCWc1SrYyfz1zhSB7jcavYRqu/H2v7I56FTXf4c/11aD4CW1iYRevPdgxIfFEhjt1xaU2nPCo7V/2Al5Fe8efxWxCRz4kIaheX514mD3XL97ppLKHHXWYO0Hgkt5oq/E31YGadTP48jsGdxKS+/gsQRhpO7s9uAHlfZrE522h+mQJZ/LKAR8ak/Al9TvcBwW6P8v9BxBZcUng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+feadaHUJWCWBZdG0UVWHmd3rE0Ov5SazUdYjKyyBkw=;
 b=OAR3K1hKifMO2rVVjc5XDF6Y6tC6nqI7yLLxAYdFrBqtjsnKexzS+/cNyeHvzTiRnmMoh78RMLafJx2uCW5sEF2nQvlfiVIp/oYNYuXFWRjk4/M1HwZiVFVOQ2C/WQKBtSlMWvlCXCHQVVJTRkb/sInmS5cinoH5e6vEuFUJDaE+jQ2X4cszTqXJsKlNsPhLP7pPmtScfsI5glh5053Vqf+rwIpQgaMxL53j7ylzUp01MIqK5EO8GcSyc+82SD42NhFuRa/SlOA8XzaNtlOPPamo/vY67rnubzR2BIB0xJ4D11f35CsKpncA2tvdZnZtzxHmUC1THZE1kjg+gmo4IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+feadaHUJWCWBZdG0UVWHmd3rE0Ov5SazUdYjKyyBkw=;
 b=oEyQ/nSAnEFy8Wvwq5x6sI72lIVgqY3VJrF232lzX4dBzXLB/8eR5etfPHyGbCOF/VnM4ziaNj3iuWX9LgfM9WW92LxiIIcIbooNgmOxDRjYy0ncysawx9CsIRGiNtxSL7IzCG4sDX+SUejs1KOnkbbBGpBYb/1NCIliwpgaYBtAhsIqnZaVJvPMg9akIwFJu/JoKNU4gSFy5jskNTcs8e+MjLRrAvp1kyrL+zruaP+A7lUuMDys4GEPAVyLYZpuzxczBmrEYAxXUwnTuJigUrRKdT2TE26GGr/yMmX6JrZlcr3c71BfMQOYKhzPOckwIOSlXifl1MJghl2TzFxRsw==
Received: from BN9PR03CA0379.namprd03.prod.outlook.com (2603:10b6:408:f7::24)
 by SA1PR12MB9513.namprd12.prod.outlook.com (2603:10b6:806:45c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.12; Mon, 9 Nov
 2026 14:43:06 +0000
Received: from BN3PEPF00022BD9.namprd03.prod.outlook.com
 (2603:10b6:408:f7:cafe::94) by BN9PR03CA0379.outlook.office365.com
 (2603:10b6:408:f7::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.13 via Frontend Transport; Mon, 9
 Nov 2026 14:43:06 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN3PEPF00022BD9.mail.protection.outlook.com (10.167.248.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Mon, 9 Nov 2026 14:43:06 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 06:42:43 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 06:42:43 -0800
Received: from [192.168.122.1] (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Mon, 9 Nov
 2026 06:42:40 -0800
From: Edward Srouji <edwards@nvidia.com>
Subject: [PATCH rdma-next 0/2] RDMA: Fix DEVX UMEM mailbox size overflow
Date: Mon, 9 Nov 2026 16:42:31 +0200
Message-ID: <20261109-devx-umem-mailbox-overflow-v1-0-4a63baab25dc@nvidia.com>
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
X-B4-Tracking: v=1; b=H4sIANfb8WoC/x3MTQqDMBAG0KvIrDtgrCjtVUoX+flsB0xSEpsGx
 Ls3uHybt1NGEmS6dzslFMkSQ4O6dGTfOrzA4ppp6IdJqf7GDqXy18Oz17KaWDkWpGWNP7bzqIy
 drw5mpBZ8EhapZ/6g5LzmgLrR8zj+VL+gOHcAAAA=
X-Change-ID: 20261109-devx-umem-mailbox-overflow-c741bc73deb4
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, "Yishai
 Hadas" <yishaih@nvidia.com>, Yishai Hadas <yishaih@mellanox.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Edward
 Srouji" <edwards@nvidia.com>, Uri Dar <udar@nvidia.com>,
	<stable@vger.kernel.org>, Michael Gur <michaelgur@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794235360; l=1772;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=1gHTjh19/N0as3EB03F6ti/tCsxW1cxg/EUh8sj3QyI=;
 b=BCFpkg/kwyWiye97VOAEfgpcd/nnAKlvYPnnFY4FE+JcZdxy6kcQ+Tn5smeR/lkLEGsNEOAV0
 mV8wi/33KurBUMLrP3HLv2oASgfiShjryOgJUNN2wPWJyit5u6cQxvx
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BD9:EE_|SA1PR12MB9513:EE_
X-MS-Office365-Filtering-Correlation-Id: 704c5792-a2ee-47ba-7368-08df3e6fc445
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|82310400026|36860700016|5023799004|11063799006|56012099006|261021123027099003|261021121427099003|261022105027099003|261009223027099003|261026140227099003|261026121527099003|261028144727099003|261102123227099003|10067099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	a/33EsNQeV56ID1XD+XE0OWJcCCSh2jNw7xHITAfgnxKv0tot47aJMhvlYHd04I1EBaKl2Ao+H249wdOIRDQzZvXtDV0jykOcPzhGGG+lCwjadzi2/YkAuH/BIyXfP/3wLLpI5xXGGnhj/O7fHXDLhZZZBgVBVR0QD0B8nbicNTFiZWkvzXIEcbQXLl7ex5KzUTyXcjg+70NK2bDRRB2+jLNRCarsVfxFuJ5jbJpeTsemaJp9Qa9nTyxo6m7zOlF7TKyuYECHglsB8Ds7zxGj/dMUOxjN4La70CidtNoeBwzMZtzFquqcSCQ5/T0Du0oNocMsSnREJE+TFUeiVsahO6sRFeIF1qVvhG3LVxCW7SHWo3ZzjMCN0Os94ov69B1ObKhyyXpip5/shy9C4sOGs3ZY2PwIKyKy75xfYZup63nApOPct0TeMrVp8gnz6m0h7ZpBMPwJcxBEj7sdUgj3ft2u6803UZs066qcc2AtQ6VM7aDD/xjlc7fy6hRst1T98DIlQDOfOssntthJpYgfmj70I55YQ1Nr9ET6G1DSfrkM7G2gXPUtVHmtZW76RiDOU0heFjKRwQMr78gmCM9b4veBo1OQkLKMPlLyQGohzsrSjMJHadVjMpqEiB3QcRIJzWKxpQN7EtIUbVQugHJF1GlwqOUEoSUCnvXkOauVE5j00b+Sr0X5JTSr0gKmDtwXl9w7IJP+BWVCR5u/t69UQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(82310400026)(36860700016)(5023799004)(11063799006)(56012099006)(261021123027099003)(261021121427099003)(261022105027099003)(261009223027099003)(261026140227099003)(261026121527099003)(261028144727099003)(261102123227099003)(10067099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	DCZLZGUc+wLQzm+PlwG7hXgp01C1ZxFYKB53AHEe1OwNxabG8upXz1/APzAkxAoW5KWWr8p3NKb+//awKvqKzRjYhfSZijNymD65DaxU5UxYU+DfbYfAqzB+fKEMDck70uQh7e62zE6pFxhJ81Z5Jcw6y9RMhSTWeMHJf/Tswhd8nePQNCWEX0bCbqo63apcRiABfrsLQk6rdFzLeaYekR9UX776NXofSYE1KzrGVwc1tk4eopgOg2B2kksfX8pmGJKYSYdnWpQlN8K87Ts3LRsIS3KA7Gtf0eUo6pFg5JfdxnYBpJBt8X7yGlukLgV2ZCZp78AHcsfMuX/G2ep6Bp4juCLkFB0yNceAt+zIB6PJv+eN+cchngeCSnHtUgV7yaiEoUBqIK3O1gowZb5TEKVj0kIC3Mc79j7twngGf4Xe4iZR2jEBxMhFv3P7fe87
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 14:43:06.2861
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 704c5792-a2ee-47ba-7368-08df3e6fc445
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BD9.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB9513

Registering a DEVX UMEM builds a CREATE_UMEM mailbox whose size grows
with the number of MTTs, i.e. with the user-supplied length and
pgsz_bitmap. The size is stored in a u32, so a UMEM of about 2TB with
4KB pages wraps it, the mailbox is under-allocated and
mlx5_ib_populate_pas() writes past its end.

Patch 1 computes the size with overflow checks into an int, the in_size
type of mlx5_cmd_exec(), and rejects UMEMs whose mailbox does not fit.

Patch 2 handles the remaining corner: _uverbs_alloc() adds a small
header to the request before calling kvmalloc(), so a mailbox just
under INT_MAX can still push kvmalloc() over its INT_MAX limit and
trigger a WARN. Since these sizes come from userspace, the allocation
now uses __GFP_NOWARN and fails with -ENOMEM.

Sizes just below INT_MAX also overflow the block count in
mlx5_calc_cmd_blocks(). That predates this series and fails safely
with -ENOMEM before the command reaches firmware, so it is left for a
separate mlx5_core change.

The overflow was found with an AI-assisted static analysis tool and
confirmed by code review.

Patch 1 relies on size_mul() and mixed-type check_add_overflow(), so
stable trees older than 6.1 will need a manual backport.

Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
Uri Dar (2):
      RDMA/mlx5: Fix DEVX UMEM mailbox size truncation
      RDMA/core: Don't warn on oversized bundle allocations

 drivers/infiniband/core/ib_core_uverbs.c |  2 +-
 drivers/infiniband/hw/mlx5/devx.c        | 15 +++++++++------
 2 files changed, 10 insertions(+), 7 deletions(-)
---
base-commit: e50525a486300e5ff8014c9985b8477b2fca0368
change-id: 20261109-devx-umem-mailbox-overflow-c741bc73deb4

Best regards,
-- 
Edward Srouji <edwards@nvidia.com>

