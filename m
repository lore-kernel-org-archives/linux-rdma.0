Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.6
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794924131;
	b=G6rf7fe9ZR+S1A7+8ZCGA+vrWXKHXEcVNYsC1yAx08COMy95HDfkQErwqgRSswHyCwet
	 l38R6Dquf7VQmrNxBjawRPeR9abD5YFwaL0tVbGW1qLt94uVS5ziN5tFmRRl+AORNU+Jw
	 POLqpa43MT+xios5rFzlakQg3wrqbCQCt5aNNblbgz3OhnSZIRzzeoVh2ijBymudX7+9M
	 TMzi06kTo5oSam1pUWbLnoOQFclfdCsWPpbX3drvYUylMhf2fTXAhHzBpbQE6uQJN/8/p
	 fQeqTRVus74NkwqGm6dHISjB1Wi/qNwEhAOLeoro1phNy17jioXXS8C77EP2vozn3+Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794924131;
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
	bh=z5vG4tt7jdd+MBx9O/gp4/TqqJsZ/DdJR1+ylGMJgT0=;
	b=PrYJ+vBT9M+MYWbp0DofMiTOB1yrNwajrhILYim5UJ51w/k1EtlX3xQRPwHBdSIg+aUv
	 eb10S9Vy0oHUAJaNo0MQlCpsA6LHS09uLnrf2d4A4gn/acc5yYl9/5DmzalzAb0O+X5eK
	 VbX57RGubYiKvJ9oitCsQw3dHd+2eHDI/40ambJ6vMVS//Syaw+/SI09etFF6B6rsn3Wt
	 5maGfD2dvgDXg2YRJfD6ugZ6+JV8INQjrWDO91LYmQ9jEJm2VUCkc1+J9sbYqVV2vQtGp
	 TvMqbZuTDkmZo0fNa3bbdKFvusaPeolDIhQLJptOlfOflArZc1toQyyLyGwhZ42+OMw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ZH6lwSIk;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.6
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012006.outbound.protection.outlook.com [40.107.209.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A191606A32C;
	Tue, 17 Nov 2026 14:02:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9A191606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ZH6lwSIk
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z4qtPYlDFupu3/r2Zxoa2MYmApjKPwHbxuJ9aIByoqH8/8iF9VOxEG9nnIXdI48D1OxXw99S7gShltcCXEY4u5cLojy9g8G2IlFGFqUv19LFoG/dZhEpYjpaZ0CDF9uwlWIHFJ637nXgGOUgF5htXyhJZLXywfZnO6b/stTRpd108hb4JsacRdWPsi0/D3JLy9FC2n+4PBwWHd3INq0pJuZerP9a6ZDHS5UwGicZ2n6wDcuFwe8QoifEZSJSswGf97aaRsDxENWCbjtM7uRuqr3XJ82f5CcVO/IxfKqoq0hpvYjr1WqE2MHTOFx1YEPWTulalhF9KjW0jfpYBugYzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z5vG4tt7jdd+MBx9O/gp4/TqqJsZ/DdJR1+ylGMJgT0=;
 b=i5SLSixcEXjubZCvBnGT6ItrFOBaNKd/d2ZAxdmmkj34t6T4MstVDyYPdmZaVAvTE6yT5fDjCw66YA94OXq1Da+HUd2LZkbTUKuxoxyFcVVxaQIvUraP40xczhZJoe0j4hu0f3TfDu/+FO2t6+96d3zXEI/MLKGdYtx5rTcFFFEaQGHOaCzn11ZQZvkFD9cw9B0YLwy8KXnqLrEC60joAlHEm3pddZGlLrkSMw+uzY9ekv759Pzb4afVNMAc/Sa6q4Kff4tzYK8m1JIFm7023PJIGs8mjMFtepVy0u+j9VFPt09RgBpfcRw4vOHO08S/JV186jxrYjWjxnmEtpTi0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z5vG4tt7jdd+MBx9O/gp4/TqqJsZ/DdJR1+ylGMJgT0=;
 b=ZH6lwSIk3IskVZC21d/WPsiDSu149mNYUzF2qK3iWbNOv1pDP1hiZ/HAPK/HHD9QLDVGf9JVDR9xnbv/2I1UrXMiznWmLkhOhnQ/vgQ25vxmIe7vWk+r6Q38/y9ZjLEhplq6CZyMLjLsA/BQqWcPwKM/WcnV0bbEBXNtOmUYHuotNdAs7SLqUFrRfLWtLHfGfd1MdV96Ugr+fFo9XzkaKNbbSNm8gMy6G0wHBjAFuzW3+7tbC/lEYYX7n1IGfjwBpIl2GcWjgfJOYG3x8DJAcc6uNk4lse5aZvbhFVs5/Hb2HVe/zmbbhGxZWeED9NpvBiYagH7ZPoIVPGobnjrZiw==
Received: from PH7PR13CA0001.namprd13.prod.outlook.com (2603:10b6:510:174::7)
 by IA1PR12MB8286.namprd12.prod.outlook.com (2603:10b6:208:3f8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Tue, 17 Nov
 2026 14:01:55 +0000
Received: from MW2PEPF00014673.namprd04.prod.outlook.com
 (2603:10b6:510:174:cafe::a7) by PH7PR13CA0001.outlook.office365.com
 (2603:10b6:510:174::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.639.4 via Frontend Transport; Tue, 17
 Nov 2026 14:01:55 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MW2PEPF00014673.mail.protection.outlook.com (10.167.249.180) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 17 Nov 2026 14:01:54 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 17 Nov
 2026 06:01:19 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 17 Nov
 2026 06:01:19 -0800
Received: from [192.168.122.1] (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 17
 Nov 2026 06:01:16 -0800
From: Edward Srouji <edwards@nvidia.com>
Subject: [PATCH rdma-next 00/11] RDMA/mlx5: Preparation for SD support
Date: Tue, 17 Nov 2026 16:01:11 +0200
Message-ID: <20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com>
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
X-B4-Tracking: v=1; b=H4sIACde/GoC/x2MWwqAIBAAryL73ULbk7pK9CG51UKZaIQg3T3pc
 wZmEgT2wgFGlcDzI0Eum4EKBcuu7cYoJjNUZdURUY/nEVsMBp1nh21PzVBqWrWpISdZrhL/3QT
 enBotxxvm9/0AgAUCjGkAAAA=
X-Change-ID: 20261117-mlx5-sd-prep-571490a1fad3
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	"Sabrina Dubroca" <sd@queasysnail.net>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<netdev@vger.kernel.org>, Edward Srouji <edwards@nvidia.com>, "Akiva
 Goldberger" <agoldberger@nvidia.com>, Michael Gur <michaelgur@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794924076; l=4396;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=so171kDDT+Q7A+V8FUGylGELkyuU5oNbrxZYAP7gZhc=;
 b=sGMR8qloNFVzgYsKy9qpIpcbud+J6/TNJ7P3rxoUw7KjMOttlsfifUDpaeC4JLUfYtzaDEdOw
 w216+fIlferCdpd1ynAtpENhc2/rpsIosvjWBvdhTMcg+sRrRLNYfTP
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW2PEPF00014673:EE_|IA1PR12MB8286:EE_
X-MS-Office365-Filtering-Correlation-Id: 9bb92842-d75b-4e45-8c59-08df44b3566f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|376014|23010399003|18002099003|3023799007|11063799006|56012099006|10067099003|261022105027099003|261026140227099003|261028144727099003|261021123027099003|261021121427099003|261021135927099003|261009223027099003|261102123227099003;
X-Microsoft-Antispam-Message-Info:
	3O1K2rYWxIUc99s41jw+zwW6BkxldFDaggTxwTO9hWen5ByHs4lsUa3VAI66PaPDL172IIMdfow5nUGv6M9YJF0QhQWD8YsmoNegTNb83sJH2WUwWDbGABNZMQ/p8lp/Xiz7orG4Osq41BmpnSZYK4ITQ/9lH8LUv1RrU10AbXrggmLMt2oVW52k+WHlvfcXrQGN/kj1GaYWj77PqJhyTuanSnE47DVJqqTG284g7MblJ8tpM9FxMFmvusLwjv7N+oIAxthLv2XWW+m6HjMbe5CqtQ3xfV0gJcVBbY7QaThf/sME0J/L/Ecw3Am/eNg8qg8OXiTaxSHoid/biHHiMLxa3B8nqOqlk4/yb9QvS0uXmyVJLPVsTSye7jTdC+Q+0o5Erfv2Uo4aAWhfH6fSODTDz5lRfmzUEWexaGnlMKdr6yV7epr1CdHRdbQeFfZngSQVMOuv3Fgc0PqDvK0UyoyRaTDF5vCoS1EfICtE1HID1RVjMXHN4w4wqt4ToMDNgkyWr0kiU5l6wNyAQTSC/9W4FHom4l6q0S/qTkskyPIniDqM9qo0Oa8wrhTmOMjmcSCLgDq83D836B5sZuahNdaDIct1pAOBnUM7jOMdrbt2VuSsarU0hT/hYJzsaM8mg8oBUtVgLdkahr8RQoVxzJytUnogemHgvt6BPKKSDa2iplG5gLKXBTi0Ju3INzbaXhj0uiGNORfngoI3kQbrZA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(376014)(23010399003)(18002099003)(3023799007)(11063799006)(56012099006)(10067099003)(261022105027099003)(261026140227099003)(261028144727099003)(261021123027099003)(261021121427099003)(261021135927099003)(261009223027099003)(261102123227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	AP7/4e/Jhvorx/GzcmVqzh8FKAbhVWcX8h71sWKzdJQcbpxIpOQdHLJT6hdntMYe++5Kdk56qh3+w2c5zDZJ4hz0UoTfVjEh7tFEHymEzvl+D4BpKRruuCEe2fGw/Wh5gJAYrTKD6ZE5ef353SakYlSCQa9WKnoK5hce2OxcXz1vbHtdwVpuTQz15ScjaIsL2UbTENsbeHAICf6YNDyP2zy2vt1xUMRNr4AipHmSOQyYe+DtNtolYtcqVh0EH6sNBrgYXXdsdhajak7jzALTEQO3O2Z7a7uaFuRFPQNiwfoo0mVKJoq1jaXqKj3LokmLLuPFHyDYytxyuHw0tU8fLQUqGNYa3jkZBvCenqnFx4TW7nax/nSasU5h+MwwmA2QLZo0MkiM2c/RtrQyhEnQBnGh3WnjGPyEOkur0vqKAd/fymPajbrIVvx8Tb9cfk3h
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 14:01:54.8889
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bb92842-d75b-4e45-8c59-08df44b3566f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MW2PEPF00014673.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8286

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
 drivers/infiniband/hw/mlx5/cq.c        | 120 +++----
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
 drivers/infiniband/hw/mlx5/mr.c        | 228 +++++++------
 drivers/infiniband/hw/mlx5/odp.c       |  64 ++--
 drivers/infiniband/hw/mlx5/qos.c       |  13 +-
 drivers/infiniband/hw/mlx5/qp.c        | 580 +++++++++++++++++----------------
 drivers/infiniband/hw/mlx5/qp.h        |  34 +-
 drivers/infiniband/hw/mlx5/qpc.c       | 109 ++++---
 drivers/infiniband/hw/mlx5/restrack.c  |  15 +-
 drivers/infiniband/hw/mlx5/srq.c       |  50 +--
 drivers/infiniband/hw/mlx5/srq.h       |   4 +-
 drivers/infiniband/hw/mlx5/srq_cmd.c   | 124 ++++---
 drivers/infiniband/hw/mlx5/std_types.c |  10 +-
 drivers/infiniband/hw/mlx5/umr.c       | 133 ++++----
 drivers/infiniband/hw/mlx5/umr.h       |  22 +-
 drivers/infiniband/hw/mlx5/wr.c        |  15 +-
 31 files changed, 1330 insertions(+), 1142 deletions(-)
---
base-commit: 36d1eca030a37baa00a56bf34962f36263181918
change-id: 20261117-mlx5-sd-prep-571490a1fad3

Best regards,
-- 
Edward Srouji <edwards@nvidia.com>

