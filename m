Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.58
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795870970;
	b=zdUYnBHl/gHB+DyGn6uAvz4DmEIn9Bg+xwWYG8eJZdlzdCPBaYpUuiasO6Z7O2YWMYh5
	 ivbRX4qMCCIdqjzMgZrjOvj0aus+8AhtrP6WwDbxomXGjiIQDAC7OT9vGfDmIi3HHDXIN
	 wZUcZLNLaWshAuKxVyTNnt+2wG9ctG6DRbGvNQOJrbSQoX+qhOg+eHqXNiceBo5JSG3AF
	 XbuROGCbMAwkG4oJ3amtYO/3zfEySHnavbA7gJd79UhE9FA2Oo6fUPB2HgysI85TZRGwe
	 0mr71SXDQFXIXdp5D2tXf5jwfu7yCvr7F3N+/SBt0T8tBzszIl3cOLl+ojyO4/Ldq9Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795870970;
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
	bh=zzg9GkeHFBg7cxDT3Ha8k+LMxmnPMh29JmjnqSqiTXY=;
	b=W/MMaBji4cMzvQAO6YbMKJjZ21aE5pSnjkibOn+UY/lDRkxEjdKDRzI2VsHyjv+BsCgS
	 phEchvVI8mwY4AyUSGkICm6VwVF4b9WYbsB85E0CP4QGIaEaAMbRpfgj98D1Di1A+tg5l
	 acdn8sklXPwCW65TdWF1kzL+orzzPDjIqxcX+nsC0UoTD9+CwlhIRVlMUntczBONXtHSC
	 kSb9ZyKwOyAj+ccbuQNBQZU7dg9JxtU2LPUcOBmq5mcp4ZlkqqrUsUSsvQeX+c/1FGCEx
	 cnAxPaDXNR6xhJ8Dhud+20Q7U+7sdL9DmLvJ7iuOKS8pQiA654LhTcE7mUI8X5ObTkA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=lib+vcLI;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.58
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012058.outbound.protection.outlook.com [40.107.209.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735BF606A31C;
	Sat, 28 Nov 2026 13:02:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 735BF606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=lib+vcLI
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wM9GqXH0wVKMSFsP12PMYl1hOsKU6Xw7y6v+dkb1wb6XSTJCtTxsEISqsG1U+OQm+9Pb4yYgOFMBPmewnVUtJAblKuobtw2yfog/IhFbSlaSX/q4RIlgoNpXxLZtGntcxJbX5nUaAcM1z8eRk6g05NEEBBNRyTEbTo4Qf56+7mNIiHI+Ni7cJCSbhqbDB9P0gLoMz6T2t5Rrdi9mE/57pcr6V2nT5cZaYELFh6D/9ZYwHoPVc3x1nwi/rZoFc4g6E5PIpvGQPS/Q7H/8nB+vrq8jJHwGL8ZbrbKe1t6G5lrqzQtnG6hHMA7g6HNEZyWqRKtWmEtXYp888xwFe2LLkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zzg9GkeHFBg7cxDT3Ha8k+LMxmnPMh29JmjnqSqiTXY=;
 b=Juussvv3jX8IrRhh46h5e9O6Dl1eEB7UE9X6J1NYOg6xBHghoRXboKF3b9B8YEz+J9jcfDTV1ocr7IV8CkStH0w1M0pXsYcwiD2oDo+ZjFAGmkGBB23MzvjoFdAzag3KsWjbeVXR62CYGE7QNCqAIcYsw+3V6kruCr7klxT3+1reYGEMCpeQUssKD7eHlPZjf5Dindr0p7pNplNDB40T6LLfo7bvtKcJedHl1JJhgfhqX9V2gpJILSt7SSha17yMW/OMihruNyYnkvdKpaeLSwZ9b+JCTmbOVYOq+PV2qIoWrkXI6Eq1mlMqI+Ul53ZGPIY7SvFzWLwFgqx5V8nHjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zzg9GkeHFBg7cxDT3Ha8k+LMxmnPMh29JmjnqSqiTXY=;
 b=lib+vcLIC3Tus3n2sFStFrhypMPbIv01Rmrxk0MhGDOmKf3ZEUktERbzAKAaawMBETD1hKBIXer9Q7d3Q3pf0sr1ZAqRczqhTvv9lETO1468BiF091wJZQHoCJQR9iBhiKoz4ndAnWNEhwqNkeNNhqL8dMSG2jAenSEgO0+m6o/ATTUGGU1E0BHy0r3A7C25Q8FC1+KvydgDIV23zl0zSit5aYOFpT4ZQDsLTez0aI989lnNS7ln4oCSZAtbbq9McIRFH7g1u8s6gF5Ikb2/D748oQvoMop8q7joSWC7dCG7/m45MoxA56J9GvHOEQkYnQmmh/KiquvXSRkFH9Dymg==
Received: from BN9P223CA0007.NAMP223.PROD.OUTLOOK.COM (2603:10b6:408:10b::12)
 by MN2PR12MB4374.namprd12.prod.outlook.com (2603:10b6:208:266::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.11; Sat, 28 Nov
 2026 13:01:35 +0000
Received: from BN6PEPF00000071.namprd03.prod.outlook.com
 (2603:10b6:408:10b:cafe::a6) by BN9P223CA0007.outlook.office365.com
 (2603:10b6:408:10b::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.11 via Frontend Transport; Sat,
 28 Nov 2026 13:01:34 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN6PEPF00000071.mail.protection.outlook.com (10.167.248.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.688.5 via Frontend Transport; Sat, 28 Nov 2026 13:01:34 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Sat, 28 Nov
 2026 05:01:21 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Sat, 28 Nov 2026 05:01:21 -0800
Received: from [192.168.122.1] (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Sat, 28 Nov 2026 05:01:19 -0800
From: Edward Srouji <edwards@nvidia.com>
Subject: [PATCH rdma-next v2 00/11] RDMA/mlx5: Preparation for SD support
Date: Sat, 28 Nov 2026 15:01:13 +0200
Message-ID: <20261128-mlx5-sd-prep-v2-0-751878123711@nvidia.com>
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
X-B4-Tracking: v=1; b=H4sIAJnQCmsC/22NTQ6CMBCFr0Jm7RimUgFX3sOwaNpBJpFCWtJgS
 O9uw9rl+/veAZGDcIRHdUDgJFEWX4S6VGAn49+M4ooGVas7EbU4f3aN0eEaeEXdUtPXhkbjblA
 mxRxlP3EvCG426HnfYCjRJHFbwvc8SnQW/jMTYY0dj45UY9uu10+fxIm52mWGIef8A40PxTi0A
 AAA
X-Change-ID: 20261117-mlx5-sd-prep-571490a1fad3
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Edward
 Srouji" <edwards@nvidia.com>, Akiva Goldberger <agoldberger@nvidia.com>,
	Michael Gur <michaelgur@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795870878; l=4565;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=zLzGkQmDLjkXhyurAHloocuz26B6/t8xbOdumY6QwkE=;
 b=LsCbsSqso4PdgUSH0+w4yjK6cAp0tx3zbxmyBL/j6iwNWJ4nirQ9YCmqS7Jg6HTTBIJijeZmC
 G/dn8nEnTmaC/pia8RLzTKwr895jdseKpbcGO9o8XPKzk2p8gv1fKDp
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN6PEPF00000071:EE_|MN2PR12MB4374:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e7296a5-9d80-4685-a9aa-08df4d4fbb47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|36860700016|376014|82310400026|23010399003|18002099003|261009223327099003|261009223027099003|261009221727099003|261009221227099003|261009220027099003|10067099003|3023799007|261026140227099003|261021123027099003|261102123227099003|261028144727099003|261021135927099003|261021121427099003|261022105027099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
 qMTb4AR0TCTQowv0E1NzPSC/3Qae5NPTiFaHJFlO6TrChV5zu0xeUjaPCrnQM5rkSY2J5IekGM36O2LcTNVrly2HXBvfAGGKRrv3ZN860JaCq9lsgukxuSXAui7oVL9kub4verDsB6SrEeL42EPx+NepqFo5ujvFOGOcNHOFvOEVZPCilIDaGgNM+j3Xu83+Jxj6/8PP8osRbTaReWGWLNMpsaDL0PWGZgE5pk8zvzNYMBB7sBeycEdXfKJCrgi5uhA8nUEZQx2VJDLSuT6uKunmch3NmWMTK7Ank3NY8GuFiYKcIpSfppLWUSIC4BZdbbRm+6NQfEbbG7VrQ9B2vqz6CtSVxIqIKGD12DxAjsVX9Xkm6DXwT06QAI4E7++zS/tluq1KQnvRe8NhbtWfBoMH75X1KhIv8zGntjS4b0uDzF4MWRqvF4qC8GAl/ABTt6vkTnz2YU5FV5wYk4swiD+N6uu4UXFFVtQPDaCUZHYGbtCyxuGqFVVS7ArxjyB4mWChUFig8kV5dQbwjPmnZGRC1tc2urEunN/Dny548rQsJXJRPd6GJFKo2cnd6Yhgrpg9ivxQZCobvK+NoBw8I+w7OrE7j5mdFU3Z41PYAh1HwDki8ycJMk0d3Wj2wSqELj10R/6OnM0l/72zDnr9S/om2kSX4L/bwowxsDDTY8xF2YuIYeoiYllcd95SohIzucAncvExsI/w+Eg85NE9kw==
X-Forefront-Antispam-Report:
 CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(376014)(82310400026)(23010399003)(18002099003)(261009223327099003)(261009223027099003)(261009221727099003)(261009221227099003)(261009220027099003)(10067099003)(3023799007)(261026140227099003)(261021123027099003)(261102123227099003)(261028144727099003)(261021135927099003)(261021121427099003)(261022105027099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 TvEqblut+QAsq/Bdh7RGNZhB0T0Lglm3MMCDX8+OFsPheegUUbnyZTf9M1ykLaBNuaOwFaVc4vNMiyi1ZN/6tVOVN6EcyUeA02q6BlWCuzXjM2IwegIadxlbkh9JMKkaFsM3QabGx6tqRxPVuy/mDjmUl0ZNPxgeGgypyS1OZMnHEk7IBMfiZIC46po6L5jKFmmoMfkYlLMxbWai22uDJb2MNNoFawozzOKz2TlVroYiYpA53WDsuU+AI5PP+9LbKCnSHSQT6QUO6LEdCQl6w3Sji5fXPsnC6ZfmKrgpSRH9V6ca1YBwD5UQyImk80jMwbW8xHWR9ImSiF2e+N0LOdvnDKWSUDu7ErGcuIOpW6OubdB3iwDVHtnFKp9d5EnC69+xH2jzMZ0Q/qVy9BDkuatx1hnEy0pXTPNnfFKS3UfE78QIWLO5s138SPN2+pq3
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2026 13:01:34.7431
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e7296a5-9d80-4685-a9aa-08df4d4fbb47
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
 BN6PEPF00000071.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4374

This series prepares mlx5_ib for Socket Direct (SD), where one IB device
spans several core devices, one per PCIe function. Today the driver
assumes a single core device per IB device and reaches it through
dev->mdev all over the code.

Instead, each call site now finds its core device through the resource
it works on: QPs, SRQs, AHs and MWs through their PD, and DEVX objects,
UARs and mmaps through their ucontext. A CQ and an MR store the core
device they were created on, since they cannot always reach their owner
when they need it. The SD series can then change where a resource lives
in the resolvers, without touching the call sites.

The resolvers follow one naming scheme: <resource>_to_mdev() returns a
core device and <resource>_to_dev() an IB device. Where several resource
types are accepted, a _Generic() dispatches to per-type helpers, which
are prefixed with '__' and are not meant to be called directly.

State kept once per IB device, such as the ODP page-fault EQ, delay drop
and local loopback, stays on dev->mdev. The SD series decides how each
of them works across core devices.

This series only changes how each call site finds its core device. With
one core device per IB device every resolver returns dev->mdev, so the
behaviour is unchanged. Pre-existing issues in the touched code are
intentionally left alone so that each patch stays a mechanical
conversion.

Patches 1-2:  name device pointers consistently, dev for the IB device
              and mdev for the core device.
Patches 3-7:  resolve the core device through the PD.
Patches 8-11: resolve the core device through the ucontext, and keep it
              on the CQ.

Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
Changes in v2:
- Rebase onto wip/leon-for-next, no functional change.
- Link to v1: https://lore.kernel.org/r/20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com

---
Akiva Goldberger (11):
      RDMA/mlx5: Enforce dev/mdev naming for device pointers
      RDMA/mlx5: Rename to_mdev() helpers that return an IB device
      RDMA/mlx5: Select the PD and SRQ core device through the PD
      RDMA/mlx5: Select the core device through PD for QP commands
      RDMA/mlx5: Cache the MR core device and resolve the MW's via its PD
      RDMA/mlx5: Select the AH core device through their PD
      RDMA/mlx5: Select the QP core device through its PD
      RDMA/mlx5: Resolve core device from ucontext for DEVX resources
      RDMA/mlx5: Cache the CQ core device and resolve it via cq_to_mdev()
      RDMA/mlx5: Resolve the bfreg UAR-index core device from the ucontext
      RDMA/mlx5: Resolve UAR and mmap core devices via the ucontext

 drivers/infiniband/hw/mlx5/ah.c        |  20 +-
 drivers/infiniband/hw/mlx5/cmd.c       |  52 +--
 drivers/infiniband/hw/mlx5/cmd.h       |  26 +-
 drivers/infiniband/hw/mlx5/counters.c  |  32 +-
 drivers/infiniband/hw/mlx5/cq.c        | 105 +++---
 drivers/infiniband/hw/mlx5/devx.c      | 159 ++++-----
 drivers/infiniband/hw/mlx5/devx.h      |  10 +-
 drivers/infiniband/hw/mlx5/dm.c        |  74 +++--
 drivers/infiniband/hw/mlx5/dmah.c      |  10 +-
 drivers/infiniband/hw/mlx5/fs.c        |  32 +-
 drivers/infiniband/hw/mlx5/gsi.c       |  27 +-
 drivers/infiniband/hw/mlx5/ib_rep.c    |  48 +--
 drivers/infiniband/hw/mlx5/ib_virt.c   |  12 +-
 drivers/infiniband/hw/mlx5/macsec.c    |  10 +-
 drivers/infiniband/hw/mlx5/mad.c       |  18 +-
 drivers/infiniband/hw/mlx5/main.c      | 270 +++++++--------
 drivers/infiniband/hw/mlx5/mlx5_ib.h   | 151 +++++++--
 drivers/infiniband/hw/mlx5/mr.c        | 208 +++++++-----
 drivers/infiniband/hw/mlx5/odp.c       |  67 ++--
 drivers/infiniband/hw/mlx5/qos.c       |  13 +-
 drivers/infiniband/hw/mlx5/qp.c        | 580 +++++++++++++++++----------------
 drivers/infiniband/hw/mlx5/qp.h        |  34 +-
 drivers/infiniband/hw/mlx5/qpc.c       | 109 ++++---
 drivers/infiniband/hw/mlx5/restrack.c  |  15 +-
 drivers/infiniband/hw/mlx5/srq.c       |  50 +--
 drivers/infiniband/hw/mlx5/srq.h       |   4 +-
 drivers/infiniband/hw/mlx5/srq_cmd.c   | 124 ++++---
 drivers/infiniband/hw/mlx5/std_types.c |  10 +-
 drivers/infiniband/hw/mlx5/umr.c       | 131 ++++----
 drivers/infiniband/hw/mlx5/umr.h       |  26 +-
 drivers/infiniband/hw/mlx5/wr.c        |  15 +-
 31 files changed, 1315 insertions(+), 1127 deletions(-)
---
base-commit: 211a4cfd857ddc9fb0e5bb7dd21988d7d490fc11
change-id: 20261117-mlx5-sd-prep-571490a1fad3

Best regards,
-- 
Edward Srouji <edwards@nvidia.com>

