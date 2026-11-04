Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.191.92
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793824393;
	b=s4bL//Tfml6bmwagGxm77kVtPw83E3ue6qmzY1omqsq3rQcfHYVVtBuYijElVnmoR0Jv
	 rPygtDpQYUE3ns/J13/bfuYLW+DYau0Z8mjDO6DT181v2QwGghVaQwCmGbMzQwhByEpo0
	 qnrANM8fNTfklLsE31QcJuL09Cm5pElSGhA/jf01M3qp1rZbz6rv9yQmasDg36lWGkOwC
	 IlYVveMEK/hlCCaxNXJl2a+LAY1X3gJ/oTau9q2RJyNBajIVk36c9+NiMr0iI6ktfG0Id
	 3u/WyQqe64k1/XjOP+gE+1wPsSguHNA2IZ53TjNJ6cc23K0FYzvG20K81MSQWgSsi/A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793824393;
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
	bh=wJWOLMIO7xtgh8ic9BGmLthvCL237lrfhB4QnxezwWo=;
	b=KCwIDOMY1faKuWUn7SHUd633fG9n3r9JIh0CQEz64a9g+PCShqWOCdROJGSU/Aa+8xfI
	 pXdwr1ZGq2TRy+ajc0X1zHBoLX0mF8KLInhIDYYkSmT/THesSzl+tjR3Pzxje4T8d+chm
	 2kdsrS6+LrE7Eebdds5eP+sjGRN+SzX61zje/jmq5sHggRaYjjLLQBq6ay4lfheB/IEq4
	 Ob6rPDluiguw6vH2iAT9yRLaXSm5L9TkMUcydkMaLAytxDyNFC3xzNv95fDz2e2bdBlMm
	 RpjILgr2eUrpVICP5kI9tXHOE+Z7jBa6XFH0lcXuudVTA6tkAuWSdGyZokj+2FcDymA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=raithlin.com;
	spf=pass smtp.mailfrom=raithlin.com;
	dkim=pass header.d=raithlin.onmicrosoft.com header.i=@raithlin.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-raithlin-onmicrosoft-com header.b=kOCu+NP3;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.191.92
Received: from YQZPR01CU011.outbound.protection.outlook.com (mail-canadaeastazon11020092.outbound.protection.outlook.com [52.101.191.92])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A4C606A84E
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 20:33:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 77A4C606A84E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=raithlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raithlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=raithlin.onmicrosoft.com header.i=@raithlin.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-raithlin-onmicrosoft-com header.b=kOCu+NP3
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nRDY5e0I+QruzzswwR8GuXBXoa0aWbCAYk6yf2BRxE8qxjlHfwTscPsQKWFVXeMVaTffmS6wF8NGDzcDlwMI5ChiJR70paWotqvk7Xwtqa/qTclDYWK1Dd3Bpfn3q55GQ7vn72BlAbxOhr5kA5ymFtWYpkCqGlCobpGKAGmW4A0yEjqzbTB0Ai/UeOD6YWcqs+1+G997JQzPBkulukpj9Shq3Yfv6Jl1E/roeJxSiqfd/Un8uhywBj+//JgmtbIL0As2twkJVBEMH1SNoXRpAjRJfFJpoqaOtjd5qV1KYfWjBEqFbmW2fSuv8kFIR/fhG9DJn7P1D1a3UdHuerVzJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wJWOLMIO7xtgh8ic9BGmLthvCL237lrfhB4QnxezwWo=;
 b=AG2Wggrf4BuwuVS7ilVZidVvV4xA9FYJNeT2eq6Mybf9stfOrQbuu8h3Fia3rTvyOduro/ZTX5cORln4GT/SyR7L0+eUANFjEhjj6jmWR+7QnfCGGpGAxuyUtgqOQ/6Hv6TKQQYMcaxCXXAYgdeQIER2EDRj2+VyPb+zh3sQHDXojuN/g632mWklZv20IKB/cTVRdGQ0lrIrgI+IYqJmoGoRRuHVLVCRcsXFKnUQRkPtLdBQLYPIqsul972nNvYnQO8RuoJMw04P4D+CBbUzY+WuSEzi6nMhIJonjXnWQXr95F7FoUUQ5HbgFh24N4rObglAR21btJfXJbGo2H4Puw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=raithlin.com; dmarc=pass action=none header.from=raithlin.com;
 dkim=pass header.d=raithlin.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=raithlin.onmicrosoft.com; s=selector2-raithlin-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wJWOLMIO7xtgh8ic9BGmLthvCL237lrfhB4QnxezwWo=;
 b=kOCu+NP3W47gVKlMx59WMkOtV8IPVThkQMA1/B9hAfmD5zZfzaumcJS3X7LnRuoW3JiTmR03ucn9EIqXg+fhHOLPrDYls38KLjsIUChktiMy3PWLVSGrQzC4prIoHW75gSZE/a9Zs1gntIyOjCgW9iPJluuSKTI2HSaiS5zMfZ8=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=raithlin.com;
Received: from YQXPR01MB6671.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:4c::19)
 by YT6PR01MB272326.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:1ba::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Wed, 4 Nov
 2026 20:33:09 +0000
Received: from YQXPR01MB6671.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::cb84:4e7b:86e6:f58]) by YQXPR01MB6671.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::cb84:4e7b:86e6:f58%4]) with mapi id 15.21.0569.010; Wed, 4 Nov 2026
 20:33:09 +0000
From: Stephen Bates <sbates@raithlin.com>
To: linux-rdma@vger.kernel.org
Cc: Stephen Bates <sbates@raithlin.com>,
	sshaul@nvidia.com,
	stephen.bates@amd.com,
	abhijit.gangurde@amd.com,
	nikhil.agarwal@amd.com
Subject: [PATCH v2] perftest: add a ROCm build to CI
Date: Wed,  4 Nov 2026 14:33:01 -0600
Message-ID: <20261104203301.1677350-1-sbates@raithlin.com>
X-Mailer: git-send-email 2.53.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0268.namprd04.prod.outlook.com
 (2603:10b6:303:88::33) To YQXPR01MB6671.CANPRD01.PROD.OUTLOOK.COM
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
X-MS-TrafficTypeDiagnostic: YQXPR01MB6671:EE_|YT6PR01MB272326:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d032756-7204-4c2a-c9db-08df3ab2d686
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|261022075727099003|261026121527099003|56012099006|261021121427099003|261021123027099003|261021135927099003|261009221227099003|261021133027099003|261009223027099003|261021130227099003|261102123227099003|261102130727099003|261028144727099003|261026135527099003|261026140227099003|261022113327099003|261022115727099003|261026130827099003|261022105027099003|10067099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	1vGtO8dA/IElkKPU3fjVcgr/3J6QcCpmCf6v5s5BzvWQ+BkUU41Yfs6O+3+dM/jdmAQZNKGml3u1u8gnSnHixyoFrr3XNuGQC3VtoL5TG23m6/Iw6LO11r6JcuDtQbF1cuUnkz580Ouk5qVGqQS9HkfPfY/ncGUxRtlCNOuJgDCv+jKa+c9V8Hfez3vF76jWrRgLtLT5dmL4/vSGMAXnjAZHrttnTLn6ZlIwB07Ds8gEXW2yR5y3sXL3ZsaTbYdTxLVOGZRHYiRixb26XXR/U+hverBBaqMqTBSSJt8T/7YSJomdO9/vktg2x+CE7Sw/OyWYaXW85soYfC1loVWn+xrSheiwHTbeWVtxSSqSXtIAs/a1LnALkZXjkCHHFKFcYj5Em7MYlZYIfEAUk5y8kAxPXOUZYpO+clqfa6qQqj/zOoq1lwpNNswlTpvFYsRttIla3rddlCyrCi6SFpaHPu06IDCsLNTkd8aciWdXuEMV/viWG2q2mtd2SDmBpLQO+EJ/hEIlA6pask6UxuxD269EKWtwskzztJbCrJxqXWm8PZpvK5mn/hWAw6ZcoIS4pBHRFg7jT2CwXSTnuPkmJfnXmXh/Ayc01eGZi98RwehCi2OGT4dsC4KezxgAJAD9dxOAvaNfk7QzFfSMgySqUPxDK+WW77pV/qcpPJYPFrY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YQXPR01MB6671.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(261022075727099003)(261026121527099003)(56012099006)(261021121427099003)(261021123027099003)(261021135927099003)(261009221227099003)(261021133027099003)(261009223027099003)(261021130227099003)(261102123227099003)(261102130727099003)(261028144727099003)(261026135527099003)(261026140227099003)(261022113327099003)(261022115727099003)(261026130827099003)(261022105027099003)(10067099003)(18002099003)(6133799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oFTIoLysaOuhj1d5jJrq9ewTrDs7bnv7dxDaaleF8ZfxvZFyBr0mi/YJzwEA?=
 =?us-ascii?Q?dfCSqx/t6kduBgDvaXY8DNR9hGZTPMkzBk7aZF4XjZ0hQdiHpvK9q46Pfw94?=
 =?us-ascii?Q?NUh3hkM6IiuNDcxhsVUQgiBRHfie8GjMD9/R7rDZLIov4nfrzvwyIaIbpEJG?=
 =?us-ascii?Q?qTro5VoQfqk2WlPzSLRzUzv4zytF0ulvRuHO23qs8SrH2TPYobQ14i7Rsqjg?=
 =?us-ascii?Q?uiOdAWi8vzFHiK8ntk69JWIRyTHF6g/ry5fR5cIbLyDNTNuVl8mdJ6yaKOsr?=
 =?us-ascii?Q?NR+mx5tIILmBeToyD++iXfHFg5yE4xV8ylDhrBIntTIoVdZjRkOmmNiLzO3I?=
 =?us-ascii?Q?lk429LASajbO0802oThWazdbOVdrVajmyOcTi872Clu0qeFuh/45xvrqooYv?=
 =?us-ascii?Q?m5Xyrt4ZsrPNwYnUllx4EC8rcYY5k45ANcXOhykCNk5ZfdS426VF9ZTKwrVc?=
 =?us-ascii?Q?bg9F/6jLhsKrRac95V3Ygwjy+QA4PC/E3SmQPtpC7VqWgQcOP6LMtZZ49ned?=
 =?us-ascii?Q?gKwRG6+kl5cYa+2hcBZ91kggNf1IyRgkMa4BCdaIVky6xcoAranS5RrORtBU?=
 =?us-ascii?Q?reB9RGqy+UpOZtqBSr8pnQmxwV8RAdkL21ie1qDGCzDJcbzN3sUufEG2Qxpr?=
 =?us-ascii?Q?UvxLuzCYNqS7MFBQnD7FaYL31zBHygGWyDQUSMoK37/A4ChMUX4CRj/srxFa?=
 =?us-ascii?Q?cxnIQeOEbsLVx7rfw318t2/d9uR/bOkz8lKrUy2DVss8rFlSYWcq0UJUo63w?=
 =?us-ascii?Q?0nLoOFI1KF9qFXV8yUlXUeLHo+zl4qBeUXNEJ/TsfveNYUdud6TxzuW76Oxc?=
 =?us-ascii?Q?qawP4okySzrUZtFFVl3SsQmDakQfNWkilbDbLY0ENbo8KfvqL5+UuFijJt+c?=
 =?us-ascii?Q?iUZOoWeDwZ0LJasxSsU8ujDZiNY7EyhKenqacezZSRYnEOmZwBctLCm7nkpx?=
 =?us-ascii?Q?w9G7ZsGpjVn8TLzeIP1ig4tRLQu6Deeejo8Ldj7isqS9Ocp1ZLt1FeLNtOJe?=
 =?us-ascii?Q?HocUwdB/6fWtSKtejmtiYgb1d5te3vyqv79eFepj7z9diC10MoqHWM/Z3gid?=
 =?us-ascii?Q?svg6+yZZpcUiZxIp/wbiZJyKtXww5ySI4J8/kHQ71QqRYF/wl3P6i2fEYiLQ?=
 =?us-ascii?Q?bTj+415Qk3jtH+CXsMPVoC46/Vysvd3pqEo/sOGdDBo7uoBWWQo/X9DqNnMP?=
 =?us-ascii?Q?AdsytRyxh0fzxxiO1kAXSBGuViyMyHmhEgE3DcAk4+SS4GTqIeLJ2WZv+A3z?=
 =?us-ascii?Q?CxiE7h6RL+TNzdPo4wE9UTnx2xAyp7CW3iy5Jx6yZKNep5fPmNTCEcq1QWY2?=
 =?us-ascii?Q?x8toEb2VqWphrU78JPmfNTEtEJkugTauehPBKGzo3qnXs3n0tarOph5TPzRK?=
 =?us-ascii?Q?lwHA98EMXwq7Nbi1+rEuCiSEDIHhTiTA51bqtClP1WWDAJ5soGlowUUwVWrv?=
 =?us-ascii?Q?g4P7CZ75q6PRMd0cUv8OVruUT1WnueTaszm0FYzVK6JiTP2aFuVkAXs1yGvo?=
 =?us-ascii?Q?SHXE9ZXXPuqf1m6EqZmIjLbwWgdpEsDcOibEoifUZZ3E6iYopqhnzWNND7DD?=
 =?us-ascii?Q?lkvlMzfnWVgm0Vkug5E3jiPUJYi4qKjcl4n92+jVv9mP/GVE7j5Ylg8UOBZ0?=
 =?us-ascii?Q?A5qxFjcqqVKRfbTRUcEEbNTZwCA5prjblk6s6ITa18/omHfAgCiqebQw+5tJ?=
 =?us-ascii?Q?mVbjzS02Gg+S4oXEBjNw2gB30voCtUCrzQF3MAam2UYb3WjwFiE6rliothUF?=
 =?us-ascii?Q?0rf487AxyA=3D=3D?=
X-OriginatorOrg: raithlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d032756-7204-4c2a-c9db-08df3ab2d686
X-MS-Exchange-CrossTenant-AuthSource: YQXPR01MB6671.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 20:33:09.0060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 18519031-7ff4-4cbb-bbcb-c3252d330f4b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XsiZtzyemgKHIJNqemhfIP99D6WvulypXsCI68N07N385O8BjwhUueRgPzURuHSwt2e7Q7bFjNNyIgkZbYBhLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT6PR01MB272326

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

Changes since v1:
- Add a comment on the matrix explaining that rocm_arch is not yet passed to
  configure; --with-rocm-arch only exists once HIP kernel sources are added.
 .github/workflows/ubuntu24_04_rocm7_2.yaml | 70 ++++++++++++++++++++++
 1 file changed, 70 insertions(+)
 create mode 100644 .github/workflows/ubuntu24_04_rocm7_2.yaml

diff --git a/.github/workflows/ubuntu24_04_rocm7_2.yaml b/.github/workflows/ubuntu24_04_rocm7_2.yaml
new file mode 100644
index 0000000..7079037
--- /dev/null
+++ b/.github/workflows/ubuntu24_04_rocm7_2.yaml
@@ -0,0 +1,70 @@
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
+        # rocm_arch is not yet passed to configure: --with-rocm-arch only
+        # exists once HIP kernel sources are added. Both legs build identically
+        # until then; the matrix is in place so the workflow does not need
+        # amending when device code arrives.
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


