Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.193.131
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793807437;
	b=U0JZNyRmMP2JbOD/HoVjNVUim+MNuloNvU/KIZweuRAV1fxoaIxdXQQyTFMp2UZ6nJ6i
	 HjMwDZW4yfSC5S+Y+wfrocJsIvDztUicWZu80phSFQwkVRSVfJRrYTs7r8FxvngvfyggO
	 vo+Irzufzwm+MpJYfcpog0PXRGy/J9VoQpg8vbseBddIjhRjzE9rN1R4BXAE6G5P3uIDj
	 G2FvID6Zi2Smw5rg/eTdISgR7uQxdZjb2dx0Y4V8N8fxKUBQKMGbAbGCIWNeMQw4px6en
	 73kcdQ0hAXAD4vZDqNsF606WhhQ1oJgA9mOaiNKIMkHkrc69aZ3UHdTvDs+hdXcJFeQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793807437;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:Content-Transfer-Encoding:Content-Type:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=rVvbmxfCCw6lk1cV9f/AzDSEzJ9fP+Bxoa+g1slbFMk=;
	b=k//iIstHqkzpWCFnXf0r7bUaKQ2jKKwNjgXty2L8dgJe6PsYFjR0oc8N3J4uaLjnTXZT
	 fKWS6U7WQZljrmRRpRHbjvenLGhjEyzSsVPLdaEjb0Umbd0s7V1rUiNDkr+QyAyDiHIiB
	 P3AW/vHbPZmRqDJ7QQZJ8MsrTYsTidjZ6Elute3o8AH00RLOxiMDMFgI4hRRPGHMsM/sh
	 pIKaTaVgBfPSzgzef3RR/N+cP0EOdY3ExmitR5QgPSICO/jAXDMVDDcjaYfmPzNcAbFHA
	 +1/lpOZXobk21dXcSpTK/kU2praE9KKli4o+WJ+m10hUnOkp/zYshhZWFN/UxyJSXhQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=raithlin.com;
	spf=pass smtp.mailfrom=raithlin.com;
	dkim=pass header.d=raithlin.onmicrosoft.com header.i=@raithlin.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-raithlin-onmicrosoft-com header.b=TgRNeaVJ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.193.131
Received: from YT6PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11022131.outbound.protection.outlook.com [40.107.193.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5D3606A326
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 15:50:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF5D3606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=raithlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raithlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=raithlin.onmicrosoft.com header.i=@raithlin.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-raithlin-onmicrosoft-com header.b=TgRNeaVJ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kB8wKd1rrVPrFSiQwQpt67Zek7NyCEQkGjk/VMZHZ3lrkJoyRU/V1u4u4x5IHFHbFU7Z5BORcCIbRFwqYiorSoX4+HpAFtCdfalcfqZKFPz7yTfx9ppnRx/B3FHk1FrJkEhDvFlLggLrHlvjFyAHidX8zw9j/rJxM7Jx42xk7DLn5GmuYcXypw1/3rgeVYnpNZfL17LGfyu2dyEaO+VjcWc7UJNaSZ5EVcav8pvqz/T8wrBqu5TmK0doNesIfY4xtNp9lXAo1qZX+iE9+xGW0IIZtZwt13mXfnJmJ/EypacPVSclFxaTVzMMmvdpA7pl2PQU2WQQDc6pLIgW0Di6hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rVvbmxfCCw6lk1cV9f/AzDSEzJ9fP+Bxoa+g1slbFMk=;
 b=MIHeN246ZX+j3D8xPKYNy0x3cWQ07IYuN+uRNybtcUzlnDpfMXkrQr0ALEfnaTDjZeBKmyH0IBpFFfh7Et1rE9+mDWSvrt18Qo0PjsgiL0CmlBMB/9Ynd/ta3QMSfPdP8Y6715+2Pnpt7FEXrvV9XpMZ34zFo7UpjbemX+CMpXKWHSH1+by2MIZAIHgnGNcp1pu271IAxyOVqvs7LmsKL7bB3OXpqSoMKMDOiKEqqKhWNYG+LwxQ5ruEpqtmGxm5d5blzsDXqfYKA4tQBOpMrNyywD+36815BgfnhDMyDrHzGJ5J3P3e3Cvs3JbkgcBYi8P29EZDfdfmLyFgt9QN/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=raithlin.com; dmarc=pass action=none header.from=raithlin.com;
 dkim=pass header.d=raithlin.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=raithlin.onmicrosoft.com; s=selector2-raithlin-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rVvbmxfCCw6lk1cV9f/AzDSEzJ9fP+Bxoa+g1slbFMk=;
 b=TgRNeaVJw9sBB58bHT+OVuHJf1ak8IX6lkWxQc5mriI+Kd1n043eL8ASHCNwVkrDbCjZgirv6UowQLeL8LyNYHbBTolB//ROWE4G8gRFzaAHAXGGrrNhgMNxNLsMBoRihLJtJOJ8Sxu0ljnqQC4QUb5wmAqFuVOpG0s1UNUprjE=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=raithlin.com;
Received: from YQXPR01MB6671.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:4c::19)
 by YT3PR01MB5230.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:62::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Wed, 4 Nov
 2026 15:50:31 +0000
Received: from YQXPR01MB6671.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::cb84:4e7b:86e6:f58]) by YQXPR01MB6671.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::cb84:4e7b:86e6:f58%4]) with mapi id 15.21.0569.010; Wed, 4 Nov 2026
 15:50:31 +0000
From: Stephen Bates <sbates@raithlin.com>
To: linux-rdma@vger.kernel.org
Cc: Stephen Bates <sbates@raithlin.com>,
	sshaul@nvidia.com,
	stephen.bates@amd.com
Subject: [PATCH] perftest: add a ROCm build to CI
Date: Wed,  4 Nov 2026 09:50:23 -0600
Message-ID: <20261104155023.250706-1-sbates@raithlin.com>
X-Mailer: git-send-email 2.53.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0317.namprd03.prod.outlook.com
 (2603:10b6:303:dd::22) To YQXPR01MB6671.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:4c::19)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YQXPR01MB6671:EE_|YT3PR01MB5230:EE_
X-MS-Office365-Filtering-Correlation-Id: 124e78ca-d2cc-4ef5-6ace-08df3a8b5af8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|261021130227099003|261009223027099003|56012099006|261021133027099003|261021123027099003|261021121427099003|261021135927099003|261009221227099003|261028144727099003|261022105027099003|261022075727099003|261102130727099003|261026130827099003|261026140227099003|261026121527099003|261026135527099003|261022115727099003|261102123227099003|261022113327099003|10067099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	PDG/R9B4wzWZ1vY2a+rwRdenV+PYA9cKWRYi1kDDclrJd/KevQ07NymTjYXRzN27u1Yb9qDPt/C9zL1uerhBtg6R2r0Vd0VwG5+vsBDy6kPawYghTbCTLnmnCPAkSpE3a1Puuywy1QUuY+xU1Egx9VxQzPzPkVW/5pddiKDiZgUHxsifBKOCYBG3XOYsQ3Sj8QugUqh43KTI5Du9gn4KfG+83P+PG9XVbAffCjaDkFJRHub4XyIwfSBtLyp3XYsEKhxXAocjKBWOF/1yeVIMOp3ErTOwLXw1srisMgxwSKjA/px15RsHHnrEfi9ulU13Apzifb7BmfO8hop/Y94XwF0umh2f5V2KTChKgx3NdIukAZskSqaCCp7HWnnVogMvJ0BPNP36AnpKGTq6kjRW4Lj0akho1Dzctzub7UJtjc9indBCSGWtdvCL/lfINqkgUsApSJ1iZaKTREbY83/T8rVRCsRR6uhSTfP9ED8s516EN0NXZRd1tclPW72p2HY0R5jnCA4LYWoDMK+r3MGFtfzO2wMotE6Az+vnweOR8EB14Lancj7Hm+36Az4+0xQsVg8YRT/aZaR6CpvN0Vk/JHYR+oldDQjmfQmDTjV6T3L49YlP5cuvvgm6g/U6fZCn7JW35W+IEVFDlQLSXkvBl8RVbELzWrBIEnqC2aehpLk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YQXPR01MB6671.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(261021130227099003)(261009223027099003)(56012099006)(261021133027099003)(261021123027099003)(261021121427099003)(261021135927099003)(261009221227099003)(261028144727099003)(261022105027099003)(261022075727099003)(261102130727099003)(261026130827099003)(261026140227099003)(261026121527099003)(261026135527099003)(261022115727099003)(261102123227099003)(261022113327099003)(10067099003)(18002099003)(6133799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bR6eESEKvZvNqpnoo1hn9rEMrdgn98Pkcpf2HIG+9ZayCIrNy0zMf0OdeyVt?=
 =?us-ascii?Q?uv5+ZxaMhkHZLlDAUL0nXKC2mwlkvXpxteh2vVDIyBRbxOQJ9HPPh/FfykEg?=
 =?us-ascii?Q?YxIYQiN/WBhrurVB3lNojNoyE6xleUUnLBPMFMk+U4+iTvFZLe/8Tkk63xqn?=
 =?us-ascii?Q?TMX6CUhetxXRTYWi80YARJXPxSKGbknxXaCV3b2+jgq/q980HqVPrKbr981L?=
 =?us-ascii?Q?s5CJJj4KEKwnlo1G+yYNOGaL7JnVuRy7zzd8FtnWincXYNfgfvGqgmuGfH5x?=
 =?us-ascii?Q?JllVhrT+iFgPlVZonfreOw1TK9qShJFUWHHVeCAwvZE7Bm4IvvEcgUz5BfQJ?=
 =?us-ascii?Q?Nd815DD50sOGmVy8gxvpl9I8iySe6YtjIln7tZ7fcCNzuwGF3fTyNKaRUfuv?=
 =?us-ascii?Q?MiIRkuv8R1YFJ+pMvwgikvRFphFFQhgtAFNkJLCrKWneAALpk1TUlchFqMLd?=
 =?us-ascii?Q?sFTzXQe2PWKJX01jHBXDM8xBIG+R8WpdcXNIV73JW4A3Q0uRjJR/2NNvDDxl?=
 =?us-ascii?Q?ZIyrBmezQkaiPCIA7wzX6Yho3z5uEL0Ao4nn6o8DhnBvGLLz/f58I5LSBGrH?=
 =?us-ascii?Q?kyyss+b0iIf6xabuQOoyBzLoRRsHgfPAWwUB6oGH/XGnGLPuSOO6K9TAok4w?=
 =?us-ascii?Q?VV5XOHikGbebNxkw6uLhtAnlV0atNDDz5x9sVnkHKxNdJ2b/PsKY0V6MVeLK?=
 =?us-ascii?Q?UrDtLw8y5hcgU666fbFb80OGY+Gg5pvg8Bx0yju4MvnYH1Mupwv2yV6sibAn?=
 =?us-ascii?Q?wWVnb1nrwRnyva7l35RwIbkYF5JMv/Werq3OVw9PZZ/OxbEUOD84tAvDzY0w?=
 =?us-ascii?Q?Otq7bRddyznuRBFwo/SLyaGsyXBt5Gauz1786ip+6j4BHZeLWSvyCE+1mm1h?=
 =?us-ascii?Q?wlFH/Cd/mUztzyic5Vec0LNG5Mt5ui3yHX526RerEieKkwV+w1GQFybz5F1n?=
 =?us-ascii?Q?ywNVQEkZ0sZpFLSY0+mHnBQ3+5n/C/3r94sJkzSqbD+b2M+qoXJyEDJN6Bte?=
 =?us-ascii?Q?V1XChgsBxnlubl4lpc4xUrtCnlU8Qz2GzIw6XhfrKRelV/HTSNYyjYZoCql+?=
 =?us-ascii?Q?kbSKu06AwA02ModU+zGu+YxJJ2XqTZHjesq0nSQytuj763M4Mwccf3VdMIP8?=
 =?us-ascii?Q?IZy/wCdni0alTfVfKDh88sZPKq4wldYIp+gbqRmyRwvLUKjxjokvB5RXuNlt?=
 =?us-ascii?Q?xf8rxpRMhZOm+bBOaySv6raaqgRf+rA6yXGX1Shjp7xSSb4KxElEapa1K/nW?=
 =?us-ascii?Q?8PZavuvApX6WlHTYN0ffLvFc1AMW9DzcPyObOENQHwTgPInZjg6OyDuWfkmb?=
 =?us-ascii?Q?Rtyoc2fK0FGOsN0pP/ApYYGC66opPMdadtiYoGw6vfZtbbHI9UXrfqJJBYvj?=
 =?us-ascii?Q?tEbDC1Sd/oyYfSjzsqMBLmzn2Oygnh+kLU12qRxPfsKP/sJBs9ufbhC5slyv?=
 =?us-ascii?Q?pyi5DAZnKZd0Np0Yi4s6BRQ3HPriIHIoKnlwfvi+QXTf/fCYjXmfQLs1Mv8J?=
 =?us-ascii?Q?PsnWmlIbMf5yE/HpUJFoACj29GZ3Pss4s4SlshvtqX1HiHI4ihD2n/WiAxST?=
 =?us-ascii?Q?/6OhdMl6DJt2p0arfZ+qZ5MM5UHI0ERtbuP0SAIFYgcVU79qIEYkGDldWRIv?=
 =?us-ascii?Q?fmbp1B5l0PZCdA+2yR4PbrCw8dy2YaHHjAOoWXuHN/6PIfzEuFSy+ToDbxi/?=
 =?us-ascii?Q?YTo/4S+cUOXuCymVMIcKsHGU7pv1TCCrNK5UJRdloelHa/frSHDOHiC6z3nz?=
 =?us-ascii?Q?+Re4SqR0RA=3D=3D?=
X-OriginatorOrg: raithlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 124e78ca-d2cc-4ef5-6ace-08df3a8b5af8
X-MS-Exchange-CrossTenant-AuthSource: YQXPR01MB6671.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 15:50:31.2566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 18519031-7ff4-4cbb-bbcb-c3252d330f4b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5IedmxJv5OZRvuJlfahdwyxOOu9opxVjmGqA3pyxQuG9X5wskI1S1qC1gEAYfhUluwuF+EAZtT0uucLkZipsUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB5230

CI builds only the CUDA configuration. The two existing workflows pass no
--enable-rocm, so src/rocm_memory.c and everything behind HAVE_ROCM and
HAVE_ROCM_DMABUF is never compiled on a pull request, and a change that
breaks the ROCm backend goes green.

Add an Ubuntu 24.04 job building --enable-rocm --enable-rocm-dmabuf,
alongside the two CUDA jobs and triggered the same way, as a matrix over
gfx950 (Instinct MI355X, CDNA4) and gfx1250 (Instinct MI455X, CDNA5). Those
two were picked to cover consecutive Instinct generations: HIP sources that
compile correctly for one generation may have microarchitecture-specific issues
on the next, and testing both catches that. fail-fast is off: a failure is far
more likely to be specific to one generation than common to both, and cancelling
the other leg hides exactly the comparison that would say so.

It runs in AMD's slim ROCm image rather than installing ROCm on the runner.
The -full and -complete tags, and an apt install of the amdrocm-core
metapackages, all pull the whole ML stack: Composable Kernel alone is over
2 GB, before rocSHMEM, MIOpen and the BLAS and FFT libraries. A compile check
touches none of it. rocm/dev-ubuntu-24.04:7.2.4 is about 1.1 GB against 8.3 GB
for the smallest 10.1 image, and still ships hipcc, the HIP and HSA headers,
and device support for both matrix targets -- llc -mcpu=help lists gfx950 and
gfx1250, and both compile.

7.2.4 rather than 10.1 because AMD publishes slim tags only through 7.2.x;
every 10.x tag is -full. What this job needs is a toolchain that compiles the
sources for the targets in the matrix, which that image provides. Moving to a
newer ROCm is a one-line change to the container tag if a slim 10.x image
appears, or if something here starts depending on a newer HIP API.

Like the CUDA jobs this builds and installs only. There is no RDMA device in
a runner, and the project has no test suite.

Verified by running this workflow in a fork of the repository across both
matrix architectures. Both legs passed: configure accepts every option, and
make and make install succeed warning-free.

Link: https://github.com/linux-rdma/perftest/pull/418
Signed-off-by: Stephen Bates <sbates@raithlin.com>
---
 .github/workflows/ubuntu24_04_rocm7_2.yaml | 66 ++++++++++++++++++++++
 1 file changed, 66 insertions(+)
 create mode 100644 .github/workflows/ubuntu24_04_rocm7_2.yaml

diff --git a/.github/workflows/ubuntu24_04_rocm7_2.yaml b/.github/workflows/ubuntu24_04_rocm7_2.yaml
new file mode 100644
index 0000000..0a4c706
--- /dev/null
+++ b/.github/workflows/ubuntu24_04_rocm7_2.yaml
@@ -0,0 +1,66 @@
+name: Build and Test perftest on Ubuntu 24.04 with ROCm
+
+on:
+  push:
+    branches:
+      - master
+  pull_request:
+    branches:
+      - master
+  workflow_dispatch:
+
+jobs:
+  build:
+    runs-on: ubuntu-24.04
+
+    # AMD's slim ROCm image. The -full and -complete tags carry the whole ML
+    # stack -- Composable Kernel alone is over 2 GB -- which a compile check
+    # never touches. This one is about 1.1 GB and still ships hipcc, the HIP
+    # and HSA headers, and device support for every target below.
+    container: rocm/dev-ubuntu-24.04:7.2.4
+
+    strategy:
+      fail-fast: false
+      matrix:
+        rocm_arch: [gfx950, gfx1250]
+
+    name: ROCm (${{ matrix.rocm_arch }})
+
+    steps:
+      - name: Checkout repository
+        uses: actions/checkout@v4
+
+      # The job runs as root inside the container, so no sudo here.
+      - name: Install build dependencies
+        run: |
+          export DEBIAN_FRONTEND=noninteractive
+          apt-get update
+          apt-get install -y \
+            build-essential \
+            autoconf \
+            automake \
+            libtool \
+            pkg-config \
+            libibverbs-dev \
+            librdmacm-dev \
+            libibumad-dev \
+            libpci-dev
+
+      - name: Set up ROCm environment
+        run: |
+          echo "ROCM_PATH=/opt/rocm" >> $GITHUB_ENV
+          echo "/opt/rocm/bin" >> $GITHUB_PATH
+
+      - name: Run autogen.sh
+        run: ./autogen.sh
+
+      - name: Configure the build
+        run: |
+          ./configure --enable-rocm --enable-rocm-dmabuf \
+                      --with-rocm="$ROCM_PATH"
+
+      - name: Build perftest
+        run: make
+
+      - name: Install perftest
+        run: make install
-- 
2.53.0


