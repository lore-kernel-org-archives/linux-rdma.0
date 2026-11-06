Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.192.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794005316;
	b=pW7k3tOAMwIEZ+mAPsS9rtxdzJeUXLrvtckDfSdlh1RJULqO1UPH7LXjqQLJBt++fYXr
	 93gPB6jU1iDloI0Nj3kL1xmpEGMA3UOLDW6k9daZcjndvJVUEEGvDdRwWjk1RyO1CWrEo
	 EU6wk4UaRI/VvJqq0XH7L945rwfx0FqDJodF7OK7R+IA/RMkWz/JR8rIXjQ3wxFy/kCiC
	 1kwVz+5BRaINnPu5CLo4xon7HSrVWeo6lJqbQ8gZAT/Dp3qdQwjn3xgVp6bkASBLKDeSi
	 SV8LzyEwZxZT7elHxvXlsI7/x1xDMni7INCLwvZLoVKKEEpJPUIrrr3/7G5u/R0zW2w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794005316;
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
	bh=eC0iyeEueDPA6kAZAi7dhkJsDhbRMLsVJEKl2yDz70Y=;
	b=ZJYK187DtaqBkHIU6B/0RJQI3JtJrP4eVhq4var/f/wg2pvP6RSUwa9GTsVrysG/U25o
	 GD4B7wOYxD6A0MAIJ2/FkPC95o02x01ZkDSeR9x2wCanb46IkPocHGkbygWqe+OxYeYsL
	 L0uV/sAU6aVqNKbnlQD8+fR0kZRKBte7b4n7rd6Mat44cR6WZkBluCwjIxv4bjT9ac2AA
	 rDVLAJjB6Cv9u9tZ/1mWX2da2wf0p3DAqSQ2vTWG54cvtoZN64jVYN/bdkw58ouAK8X0c
	 vWK6c4Hk/MlnAVR6yXtQdCj3Xa0u+4aYgSMMO5v7aag6lYOLjKh0BowbbPdO/YFwDfw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=raithlin.com;
	spf=pass smtp.mailfrom=raithlin.com;
	dkim=pass header.d=raithlin.onmicrosoft.com header.i=@raithlin.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-raithlin-onmicrosoft-com header.b=ranakhwk;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.192.141
Received: from YT5PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11021141.outbound.protection.outlook.com [40.107.192.141])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25721606A326
	for <linux-rdma@vger.kernel.org>; Fri,  6 Nov 2026 22:48:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 25721606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=raithlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raithlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=raithlin.onmicrosoft.com header.i=@raithlin.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-raithlin-onmicrosoft-com header.b=ranakhwk
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wfcqc/qpJWZQOC6s1nJtzpGx3484ZwGH0eQHbeMxhXNThSli6VFTwsVa0NIxwfhfrYXfiqvbtmAxNEDnECjyl/zeXbb7xFUwIRHTQcizVWQm00L/4csFwIq6wGKK/WC/oZI/eY0uQPObr9LzWb0yC3DKHO8atH9lJfAuhvtCcBI6mpivhno2xyD3JpCViIkkjXXIMA31DgrPv6Qd/kH29GtMTFyIRNIr2pF7FBlH5u/aetu6PM4h1ofiiUMbILVLFCqLrRxfDJJQA9C9NLYeM2VeLPJAbPfCvPr3bamu/o69YeHrbrlBG1wFpeh91trBLM/ZHPfsHttAZ/F3ZB1SDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eC0iyeEueDPA6kAZAi7dhkJsDhbRMLsVJEKl2yDz70Y=;
 b=bgPu5TFwJGEuuP3E3dHAa0nO2Cx54ZUAPJEOdtzt6tWEK7aEDWLEHOOw2f4WA9X5hTfQriLkkRnPnqqaW6Bf/gRCSsoPvvCQwIYUOvBko4sN9L5edw8L4TboeFrRCukTMWwsRr+gMiztmZRQ7C4NYyHTcdpBYZt0eLtGuP/n1Q5iiJv0Ri/ZVBk8YII+0Ui34XVahA50HYXNMq+J0Mdl9m1jDMD7J3rijMssgelj8PXfVdnlXYq5OVaZimdjKIoGZkZMoqkr7coBzUGNHTUVxQX3klcTTxyJOcyMHKwIbcEnyHw7isZ3ifEbPosKLjvGuuSZBed+42U+1WBu/LKQSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=raithlin.com; dmarc=pass action=none header.from=raithlin.com;
 dkim=pass header.d=raithlin.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=raithlin.onmicrosoft.com; s=selector2-raithlin-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eC0iyeEueDPA6kAZAi7dhkJsDhbRMLsVJEKl2yDz70Y=;
 b=ranakhwkaa41zp0iV3PIwQ1HSSvYwCs1Zc1aRIm+4AXM38Xp1nbdg2hTZPaOrlrvKGuEWvI6xE+ODbhP/b6UqC5+FUp/b3kpcNpJuKQxxKRyPl298ltgtdsvM6E5MKailAFwV2EOAzL1qAa0S2IzzgBIxjv4WDGHxofb2bbHc3w=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=raithlin.com;
Received: from YQXPR01MB6671.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:4c::19)
 by YT2PR01MB672076.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:1cb::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Fri, 6 Nov
 2026 22:48:33 +0000
Received: from YQXPR01MB6671.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::cb84:4e7b:86e6:f58]) by YQXPR01MB6671.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::cb84:4e7b:86e6:f58%4]) with mapi id 15.21.0569.010; Fri, 6 Nov 2026
 22:48:32 +0000
From: Stephen Bates <sbates@raithlin.com>
To: linux-rdma@vger.kernel.org
Cc: Stephen Bates <sbates@raithlin.com>,
	sshaul@nvidia.com,
	stephen.bates@amd.com,
	abhijit.gangurde@amd.com,
	nikhil.agarwal@amd.com,
	Claude <noreply@anthropic.com>
Subject: [PATCH v3] perftest: add a ROCm build to CI
Date: Fri,  6 Nov 2026 16:48:21 -0600
Message-ID: <20261106224821.126399-1-sbates@raithlin.com>
X-Mailer: git-send-email 2.53.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0025.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:86::29) To YQXPR01MB6671.CANPRD01.PROD.OUTLOOK.COM
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
X-MS-TrafficTypeDiagnostic: YQXPR01MB6671:EE_|YT2PR01MB672076:EE_
X-MS-Office365-Filtering-Correlation-Id: 842c3d31-3c8a-4327-a7e8-08df3c581562
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|18002099003|6133799003|10067099003|56012099006|6123799006|5023799004|261026121527099003|261026140227099003|261102123227099003|261102130727099003|261028144727099003|261022115727099003|261022105027099003|261021121427099003|261022075727099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	ehNJBj9Jvak899WqmQxDbnnq0aUUlVFChTpWYUv/xwhPIcCrVrQk69rrc2FrQmaR4L8DRdQboxjL2P3c9xo1t8N3gGRbZ1NdAYgIq7we6xqy/UjctDdpD3cF9t2TsJWG+f0FPQjzoG6DoQyhx86igmLk7RprCBai6QsJ7tZP4OtnAI0HYc2GhHstCRqMiq3nF7dx/LikH/3jTyKgOLawyfiqNnFpvWTNT+iGPsvfW5vW+fGEq14CipwvEn2kObvfn9Dan6Ab12M7nWzYLumV6/Pl1bCjeZw6ZFf91cDzw93V6e7+7x1oGbS8qLV/hpcWQPmMQ/1StDAyT9yGibjeMt4S544gSkFdGxR3tSA1XbJvlvc3A1Tg9Et2qegy1k3vxT6mpNqV4a28oOeqa2OeDrjg9PxwbiLC/ZbX0jEBRfplwgg0z3onE8yRRFuu/PoOiVb44dOOySbPw5KZnt8AI9VCJFuY9wATnOI/wL3G0eBW3vN53nnf6PTwuflcZ7+xkZ/49BJ5qqw5ZQErZVJb1f/caynGM5nvmLPVvlO7T8EcfJ18nCIQfXsyVw1tkzt4XosL1HB5PYFSCVve62rnbKAujtYk8E+Kn4LWTJphNoCAMbcxRL9928EZ1CNP3PZ0u9/MZN+TyBCXmDLmhoOY7U7A5WJS4TjzH5SefYT6hXQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YQXPR01MB6671.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(18002099003)(6133799003)(10067099003)(56012099006)(6123799006)(5023799004)(261026121527099003)(261026140227099003)(261102123227099003)(261102130727099003)(261028144727099003)(261022115727099003)(261022105027099003)(261021121427099003)(261022075727099003)(261009223027099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ldlnyFI4mMmkCUSD5c5aCnxtg7vg8ewNci/p4+Q/9ApuBZFEEHTqF/U+z7cR?=
 =?us-ascii?Q?JHqkCnAM408MOwfmum6MPbbrZee2MZyz0VMZ1HOD756Fo6Cj1QNdBVAAZ2MQ?=
 =?us-ascii?Q?SP8mAUh0fduWBD+ZcyowPZ6+xFSv8npyNq7BAGeMKKuQ7C7BopcO9PYlXnDj?=
 =?us-ascii?Q?pM0gvF+cNeYIsbce2YQhH2KsJbcVcQigGKcYwTVgsE3p8LPjIoNavx2BZeDh?=
 =?us-ascii?Q?z5bbFsLpCOquNDS45rV6Fp1q1duZD62xmwrd7spk2sjPZ558EB0gp/T4wJuv?=
 =?us-ascii?Q?Q7nvUgeP4gOzZcpHNOnS2xCthc1gO4e+HlEGX3x5f1RWnUclEhxHGvsGa3NG?=
 =?us-ascii?Q?4vsCvKxhN1ia6husw8cxquFOfLVhEyhcyOc33jtKf/a6p17RgCWaIJ3MJ85B?=
 =?us-ascii?Q?ZNGaSh58iN8R/6TmNPmwqA+/4vXtt8FUW4Rr7SBzvY7dyu7x5v99Mcg3XM08?=
 =?us-ascii?Q?0zXqKm8FuNEDqCYTtu1mug/doUxRmgK+L1Kp1QEYAEE9MO0v1kXJzPCHIGPQ?=
 =?us-ascii?Q?VHxvnpQaUESTN3MNDEkyd2Cd6vB9GP2XziE0Ye5gq2Bzo5UaQ0nEh9HGeDCF?=
 =?us-ascii?Q?y7xz2mzLGpjNtB1Vmb5m45HoeiP/VAvCf12sQorFJK7dSqom4EjXoS9PwmTY?=
 =?us-ascii?Q?cNPFGZ/phSeJCJNBMGdeiiuD4/CKsx4aqt3QqIciw0LrBSVGr8L5SLlDz7zE?=
 =?us-ascii?Q?DxNEEeKxbxmWiDNDu9X7fP+swiYnOI6rwAPsO8HXXl9ZGSnzuWilA96Vz2/f?=
 =?us-ascii?Q?wLoUox/VU6rqFZwCWUBTM+9eMsbLIoJ8iUkHsh97RYcpyaeOIAq2Cy9m57bs?=
 =?us-ascii?Q?9MAsonnxP9Z4rZOjWZDjY2+EJfY6QFYygtKxjDXFifjzAghKKzMiSvbMOEzW?=
 =?us-ascii?Q?bnQi9PHF/7pwcvKc9Ff1CUkcQfMKoJ6cP4jqgqf57ZaxzV1HFLdW0qR5SpQX?=
 =?us-ascii?Q?9Fvfb9GySaY1pFCn02isTuDBFuDSGKE8+WRcQ/8qzx4iifZIQa42UnNF8E8k?=
 =?us-ascii?Q?HH5y4MBaUr1FzApUAUVE9CYDyM/b9m/KUo1Cho0GQEAdpwmxxBSSUIse9iuZ?=
 =?us-ascii?Q?RzMZdCmexUv/rTTDudVlmK0NLL1HsOEyTjaAiX409GL46uPxpNqqg8l/xptA?=
 =?us-ascii?Q?i8Tp5679vjolZqlCjPXYIN9oeX6o1zO+DDSTdvEN/ZU8eWsyHYI1Efn/hXd5?=
 =?us-ascii?Q?6gHpwXAhqSMUC0LOX/Y1Urxcx+g9IbcbTnX8AC9TvWv9nfyHE0A9391UgrIs?=
 =?us-ascii?Q?4R83bN7ye2qo90hQLTswlOKKO/S3VVPqT8QG7mI9y+Hdhfboyr8koakh6bvZ?=
 =?us-ascii?Q?qclEnC7l81M9o68h4NV/t7gk0QzN48VxHi62+Ysr/dzF9GLCyx9y14UbLyFf?=
 =?us-ascii?Q?him5+KY+0ABcQ+Kz0AEO4nRAaoMbg1RYMoUtTq4StqbHOAGiCCfVPAJfgU4h?=
 =?us-ascii?Q?SLgfABYym+akxpUVRThrDVKhJrEqBJ6Pv2NcWAJJ/2xFlSYv/xcwUPEHRVFc?=
 =?us-ascii?Q?gmnQeV+NTMv4E4Bbo8pGPLfbBQ79ZC/KE9s8emj+xRCJkACCOUvwMookyli7?=
 =?us-ascii?Q?9l4N09f1OWXgvYaauWFOwmKgcin7WbOrywx7igG4V2PWW78/6HlpCi+/urS3?=
 =?us-ascii?Q?YTqM969x50H3VTmscyw2o3PlRSYNidCOtuxdthv2lnjMWCO7takuvUR2TtoB?=
 =?us-ascii?Q?RPF19Yki63yob6tdMAsQ/hyXBhP3uxkNpGqrTyH6CI0ES7m6mF6yge956EZR?=
 =?us-ascii?Q?9whp7SEcBg=3D=3D?=
X-OriginatorOrg: raithlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 842c3d31-3c8a-4327-a7e8-08df3c581562
X-MS-Exchange-CrossTenant-AuthSource: YQXPR01MB6671.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2026 22:48:32.5444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 18519031-7ff4-4cbb-bbcb-c3252d330f4b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 386/0w8rOaxAijiq2Ua8GhrzrXOtavtyAdzrOchER4OZGKuPSfjT0wZPD/RK+fRwP329tWldIMEvONF5B8907g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB672076

CI builds only the CUDA configuration. The two existing workflows pass no
--enable-rocm, so src/rocm_memory.c and everything behind HAVE_ROCM and
HAVE_ROCM_DMABUF is never compiled on a pull request, and a change that
breaks the ROCm backend goes green.

Add an Ubuntu 24.04 job building --enable-rocm --enable-rocm-dmabuf,
alongside the two CUDA jobs and triggered the same way. It runs in AMD's
slim ROCm image rather than installing ROCm on the runner. The -full and
-complete tags, and an apt install of the amdrocm-core metapackages, all
pull the whole ML stack: Composable Kernel alone is over 2 GB, before
rocSHMEM, MIOpen and the BLAS and FFT libraries. A compile check touches
none of it. rocm/dev-ubuntu-24.04:7.2.4 is about 1.1 GB against 8.3 GB
for the smallest 10.1 image, and still ships hipcc and the HIP and HSA
headers needed to compile the ROCm backend.

7.2.4 rather than 10.1 because AMD publishes slim tags only through 7.2.x;
every 10.x tag is -full. What this job needs is a toolchain that compiles
the sources, which that image provides. Moving to a newer ROCm is a
one-line change to the container tag if a slim 10.x image appears, or if
something here starts depending on a newer HIP API.

This is a single host-only build; there are no HIP kernel sources in the
project yet, so there is nothing to compile for a specific device target.
When device code and --with-rocm-arch support are introduced this job can
gain an architecture matrix at that point.

Like the CUDA jobs this builds and installs only. There is no RDMA device
in a runner, and the project has no test suite.

Verified by running this workflow in a fork of the repository. The job
passed: configure accepts every option, and make and make install succeed
warning-free.

Link: https://github.com/linux-rdma/perftest/pull/418

Co-Authored-By: Claude <noreply@anthropic.com>
Signed-off-by: Stephen Bates <sbates@raithlin.com>
---

Changes since v2:
  Drop the architecture matrix; collapse to a single host-only build job.
  Update the commit message to match what the workflow actually does.
  An architecture matrix will be added when HIP kernel sources and
  --with-rocm-arch support are introduced.
 .github/workflows/ubuntu24_04_rocm7_2.yaml | 72 ++++++++++++++++++++++
 1 file changed, 72 insertions(+)
 create mode 100644 .github/workflows/ubuntu24_04_rocm7_2.yaml

diff --git a/.github/workflows/ubuntu24_04_rocm7_2.yaml b/.github/workflows/ubuntu24_04_rocm7_2.yaml
new file mode 100644
index 0000000..e8f3ea5
--- /dev/null
+++ b/.github/workflows/ubuntu24_04_rocm7_2.yaml
@@ -0,0 +1,72 @@
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
+    # never touches. This one is about 1.1 GB and still ships hipcc and the
+    # HIP and HSA headers needed to compile the ROCm backend.
+    container: rocm/dev-ubuntu-24.04:7.2.4
+
+    name: ROCm
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
+      - name: Locate ROCm
+        run: |
+          # The image ships /opt/rocm as a symlink to a versioned prefix.
+          # configure needs the include path, so resolve it rather than
+          # assuming either spelling.
+          ROCM_PATH=$(ls -d /opt/rocm* 2>/dev/null | sort -V | tail -1)
+          if [ -z "$ROCM_PATH" ]; then
+            echo "No ROCm installation found under /opt" >&2
+            ls -la /opt || true
+            exit 1
+          fi
+          echo "Using ROCm at $ROCM_PATH"
+          "$ROCM_PATH/bin/hipcc" --version | head -2 || hipcc --version | head -2
+          echo "ROCM_PATH=$ROCM_PATH" >> $GITHUB_ENV
+          echo "$ROCM_PATH/bin" >> $GITHUB_PATH
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


