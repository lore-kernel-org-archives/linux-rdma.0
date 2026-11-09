Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.189.96
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794260553;
	b=wYs92iqnmyRman/gWhmg0OD1TDcMjoXbPLGYskMKM2YkbzqbWx+u23YTpY0xoO53jYa4
	 La+TwAZW0jF+hVLan/NO9kaTcZx5iOKTsFdOlZ8V7IV9vCLw2kbn5BYLNTde1Vqh/5ReZ
	 3yoMhHkMKoS8qnPAfIz5LkOeZK9+1HnWLaweYXHT3Wd9bv5tuQjastuiVimCTjFtrN7NT
	 pSTLjX2elWSfYhqe2s0AC7d67s5k9x/jjB/3TRgJkWQ86ld99fHllqH7TnfcvruQCyfvL
	 PE9WswZwZbMphCWNmMT2FRWBQNnfjllq4vQc9WGJyoXT/Kc2pwT6Y8qJamiBKmsGe+w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794260553;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=/R9yIC6xs9cXJRAkddIVWludOtKFaIwic82FIV0V/O8=;
	b=keZsBsMghQavqv9BJjFaTxkBcrss8W2FviMu+bgz8XCiQoZ23zJkIf+LUCS62BjjkWgN
	 1Ga5fEAuCcUueiepYpRt9JEC2zQg2JmtWs15g2+lHJ6nkDlrjqycx9Y4Eaz+mu4TGEiDj
	 VG/9N+2DFWQEg7AEept98+qHaxxaZVsAV13hP+vvBoTqmITHEmjDMgPYL+ZfwXgK1XsqQ
	 MQRaHPkmovQEe9PHH504Gb6+XO/bqiLoJmVfkRf2AHkzQdXMuq9S6CygofyfK6uyZ3y1y
	 bdam24fWRksWPn1BT3DeDmNrKsP3NKIbLxUokaNQs1+CIc9Kv8aWY+p7AcwzpxIRgoA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=raithlin.com;
	spf=pass smtp.mailfrom=raithlin.com;
	dkim=pass header.d=raithlin.onmicrosoft.com header.i=@raithlin.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-raithlin-onmicrosoft-com header.b=rd+zMGBR;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.189.96
Received: from YT3PR01CU008.outbound.protection.outlook.com (mail-canadacentralazon11020096.outbound.protection.outlook.com [52.101.189.96])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68FE1606A334
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 21:42:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 68FE1606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=raithlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raithlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=raithlin.onmicrosoft.com header.i=@raithlin.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-raithlin-onmicrosoft-com header.b=rd+zMGBR
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aJZVhCy/bFZHWOI0p+yuthAQsvXjpkedftqfkXxo8aXd7GsJZWruPFSTrQ+0EffGw448ucHM3emQA+lYBH+26kPWznzO7d11Om6C+ugxcSnS5ILVmrTWIVJnZFlJpEqfbTxkj50S857DUU53JoApqkz5/9i++pXt/6BYHq2B01MJlv944aGHSNU6mcdkizEeJi6NTo0/lQGjRxGkXsbGb44IzhbviWyYxZT0bCovU9Y0rPMo8/wwLoe7aIPtO861wyYSYd+3BvaApkSoKL+A7DZp7tBFxB/15Z20kw9zzP6cWowKIrjMcEfRPu/M5OE7o2sDlQNRJ9tn22A1vgiF4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/R9yIC6xs9cXJRAkddIVWludOtKFaIwic82FIV0V/O8=;
 b=BCJKzeDLPRmaYgzQr68SE9tRGEkOk1JqO1zW9mhLfWtoV2YwyCNa+/I1PeS069Y4ZRSdLE01HySy6mg9sqK5a+1j9zXDE5XBgqOkOKm/AW6NQXBqqthvRBnwT4ukEhVpEad698SyCsEwrxGnZifzP23SxqzF+HDn1sElLUrpN0JAyNYhxa4wc2Wep8D0i+hkb0+9IznaEWlV6jHfe3bqArHxDxgTKO4V/S1Zrjpt/AWysxKcjKIjeN9FEglRclPLNJqNUkNbNtwXRBvJnrsmu/HXzneoC/s7LpIKDaJ22vrTjF1WJdiUm6lRXdhQneRvUMTkKbOGaq80IL+QRZO0qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=raithlin.com; dmarc=pass action=none header.from=raithlin.com;
 dkim=pass header.d=raithlin.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=raithlin.onmicrosoft.com; s=selector2-raithlin-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/R9yIC6xs9cXJRAkddIVWludOtKFaIwic82FIV0V/O8=;
 b=rd+zMGBRw56d7H5acW5T/AkrJJmjO0FzOB2MJcsQ8HgiSRwKmq8CtTmSDml5ghJDTQcDK8yhXOFz1Epu/rNFpBUmJMl59iTQhPKRJVTuA/e4TprTtHWkTDb7bvMxddaQydMCbqsIymfFYb0AL0U6pCJb7xzXFwtjV6STOJYFzK0=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=raithlin.com;
Received: from YQXPR01MB6671.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:4c::19)
 by YT3PR01MB298025.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:10e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Mon, 9 Nov
 2026 21:42:32 +0000
Received: from YQXPR01MB6671.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::cb84:4e7b:86e6:f58]) by YQXPR01MB6671.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::cb84:4e7b:86e6:f58%4]) with mapi id 15.21.0569.010; Mon, 9 Nov 2026
 21:42:32 +0000
From: Stephen Bates <sbates@raithlin.com>
To: linux-rdma@vger.kernel.org
Cc: Stephen Bates <sbates@raithlin.com>,
	sshaul@nvidia.com,
	stephen.bates@amd.com,
	abhijit.gangurde@amd.com,
	nikhil.agarwal@amd.com
Subject: [PATCH v1 2/2] perftest: extend ROCm CI to compile device code per target arch
Date: Mon,  9 Nov 2026 15:42:14 -0600
Message-ID: <20261109214215.3152974-2-sbates@raithlin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261109214215.3152974-1-sbates@raithlin.com>
References: <20261109214215.3152974-1-sbates@raithlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0324.namprd04.prod.outlook.com
 (2603:10b6:303:82::29) To YQXPR01MB6671.CANPRD01.PROD.OUTLOOK.COM
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
X-MS-TrafficTypeDiagnostic: YQXPR01MB6671:EE_|YT3PR01MB298025:EE_
X-MS-Office365-Filtering-Correlation-Id: b2593a5d-5009-40e5-3a4b-08df3eaa5c05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|261021121427099003|261022105027099003|261026140227099003|56012099006|261021123027099003|261022115727099003|261026121527099003|261028144727099003|261009223027099003|261022075727099003|261102123227099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	vksQXUPyh33jqVwak+DIv5vbk/wNmuWwbAfRqtMdbaxdNgxppncrvjTJ556BzkKXsWJXRovKRgfFW9IQygPWR3VblqRUdrHJBMPaIXnFT9iMjA9q0grhUwna9S0rrXOvUIevIBAIEsq503sKFtFzGlu4Crav/w+c8rWxXQ4U/Qye3kEUtBAe2fqr0msoGOHbSUpLQyGArUkr6AVjhuW/o2pWPCy4QCmY+AsGtrh+hs7QQszyKZgEvPPGtOoTOUKFtVb1o0zrstFXUI6hs011BroK0ylUmgIYCuMGshWQbH6a9C8dIXXyYTzfyWbTQrHruVoA7i11PZxURTFzJR2VQKYfKPSzvBN3vFFuz3w2RZGI4+fkueOVxH47wa6153WbDVj+6Pr9Ke0g7EmDsaB9bC6ZIARQSIMLTLqeonVggUhCqT+3LtnC+6amR9NeGS2ayBbBbxIYkG2xriY74j+OzRWVXEbNa2KxvnToVQaX1m4VXX17tL/oKWlawNSrkamY8Njs4NuZx5Qi2ofxtuUkcrR62RXPzsbWdsM7OWo+7Uqs5CXJwQevnGE7iV4kSQdKO51m+BKTvgCuNfCGEJe81HlqNQtGks1JF9NC3FeNBtxKvt9mjS9ItuInxa1iEZx9TZV+okDj7UPh5BmGefr7NeDVMRLuEcoziwBCk4L55is=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YQXPR01MB6671.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(261021121427099003)(261022105027099003)(261026140227099003)(56012099006)(261021123027099003)(261022115727099003)(261026121527099003)(261028144727099003)(261009223027099003)(261022075727099003)(261102123227099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RvF8R1Y4XvpDVbram1gRMY/TmHBNvP20+/JU/aM5sajq4mxC57RENdcBJdwP?=
 =?us-ascii?Q?u0j/36VI1LF7jGQr+foBwTmlugIqR4gC+x9yAuarcWLUsLe5AYpG8bF5cJ7s?=
 =?us-ascii?Q?2KRc033LlP+XXbzHBR1jOphCf5ewRB0INpHJolKsLB4id8T7iT7YYmb1AQ9C?=
 =?us-ascii?Q?KpiYQt1i0AtuWcTwz18XpotfmYh8ZlWSpjhNugTgqf5pHsQfuf3D8UHkfM+C?=
 =?us-ascii?Q?rotvfRKGk+eFFCWdwm01vUPccxeh7fjrAkH1XsW7oRh9lnbFf+q8EJPkSqJq?=
 =?us-ascii?Q?Yg4Kl7NmgOclMu6U2e6b4AgxmVHidKHu7R12f/FKowGYEOk6okocWo9MJCOj?=
 =?us-ascii?Q?9iMAK7P2vUteOlXjE22J0qYJjd471BA+DKI/gb0yp8S4Sw8qSRTVFkNjtv7C?=
 =?us-ascii?Q?6NbzV9USX6Kj5j4T3eebcTmQAs3DFpyedG8AJL+JXQ/d7SHtyv1QKGuRoB5y?=
 =?us-ascii?Q?5G0V46CSFr4O2LHbmXOn6k4s8uf7JMrZLgq2Gp72zGf/xzylNlDze8WO5r88?=
 =?us-ascii?Q?AZMLdHhQWNxeM+DiZLjYl/0y7ygZW8Tg2MAWoY8yfB8KSiyWeqd1EWI7O3F2?=
 =?us-ascii?Q?FsxEUWrTAYGI/N6OVWwRSUIFwzIo0dnLmkHSXMwM7vAdf1At+U+pViznjmti?=
 =?us-ascii?Q?UBvGPJfS3gVjCnUaHls/QfgmotLxpfZUxKybKPKWeqNKFUx0ShWzUA1laFLp?=
 =?us-ascii?Q?eQGjQnt8cG9xgxqN5b0/IDAR+qJ6DGbdTNhKQPbRlV/M4/Mc5pTAw6N9+/MX?=
 =?us-ascii?Q?3SiUJSHxsOCpany+hsy8LN94Sy5Gjc3uKqTjzPyTxbl5s2w2gWKwhu05I9GK?=
 =?us-ascii?Q?MkWzNeYbrQAUp278qIqWbFyVW5i4fYdEwW+bwp+hY7fHEz938UtY2o44FYqv?=
 =?us-ascii?Q?tCw5qji/FX0zejCWFNaBwR6qLiaRoeB2mMuPerJaOidrX8RyR91zoVjgfqhX?=
 =?us-ascii?Q?O3xbI051UTFE92JS/VC1P6eolFHpoxSDcsosjTDHdQoqzwGAKszHoTaJaCXG?=
 =?us-ascii?Q?/GuMsRAtG7eZbTF3LolbeCEnCx6UZS3ItALOWcCZBr6hyC1cX33R2Hi0WELi?=
 =?us-ascii?Q?U9pk/Nb23kdppwh0kr8gvIInaQ0TpwVi9k8tHaZW6l3mXPy3Jlkja/Vs88B/?=
 =?us-ascii?Q?SgnX0rXltB6rzijJDyv4Jye5RUIbC3BamkjaJmLkkW5tteeNIkdxtfwibKji?=
 =?us-ascii?Q?ufZM1SVpOeEIH45cOE48HE3bH4hKlrzI3E87tJ2owPlVSqCp+EfS85zNgYHi?=
 =?us-ascii?Q?kUY7W3lFuYfCfHgPci5Uqp/EKW6KUpME6J/PesGKEaPW1X+XFPPFG/5cv4PY?=
 =?us-ascii?Q?FIDxPiulvYa531CG2b9x0i2CEotj1ob5LMBiShJbOHwzVXuCRn90qDOry4F9?=
 =?us-ascii?Q?tLjNafkIEWtB2bubSb+6q1g6I3ctPmfOiJ8Tq3FN+Gy139Y+iZJS/htlPa9U?=
 =?us-ascii?Q?Iuk9ML05G12pTI8+u0pmeBZuZ7GafWnM/dN4hdBVNDfFcjgtU4l+sNBsZlCG?=
 =?us-ascii?Q?cuTB53jRumZB+D7CnvKwN3eO4jiiDe5GHxEvjyqaVKEv4AltsSLKMzmh3FUv?=
 =?us-ascii?Q?LDHQgK5M3c2Fy8SK+gAf7hIYg3CRfAarv/CpUFY//u0Bz25jkLTN0tVYzXPn?=
 =?us-ascii?Q?Y3yCXvVhiBHMKAFceR7aR8eX5DUHrGkubaHQlu2KZAzplC5/8slKcCQFWVuX?=
 =?us-ascii?Q?o3YWR8cCycTvbMjJT/qQEurerknHoGGczid0FiHTOXnFVaLw2Flb1aevhRzz?=
 =?us-ascii?Q?7OEJJp85Mw=3D=3D?=
X-OriginatorOrg: raithlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2593a5d-5009-40e5-3a4b-08df3eaa5c05
X-MS-Exchange-CrossTenant-AuthSource: YQXPR01MB6671.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 21:42:32.0040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 18519031-7ff4-4cbb-bbcb-c3252d330f4b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dZAuvCX9y78R5N7iAznXsCC5AfxvHM0ieBc7BTJx2x5iSwJDqIf/sb6nDdJvOnwYPLgrbOECbq1xy5Kzytq3EQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB298025

The ROCm CI job added previously builds everything but passes no
--with-rocm-arch flag, so the hip kernel is compiled for the host
only. Now that --with-rocm-arch exists and the 7.2.4 slim image ships
device support for gfx950 and gfx1250, fan the job into one leg per
architecture.

fail-fast: false keeps both legs running so a device-specific failure
in one does not hide the other leg's result.

Signed-off-by: Stephen Bates <sbates@raithlin.com>
---
 .github/workflows/ubuntu24_04_rocm7_2.yaml | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/.github/workflows/ubuntu24_04_rocm7_2.yaml b/.github/workflows/ubuntu24_04_rocm7_2.yaml
index e8f3ea5..3a3ce03 100644
--- a/.github/workflows/ubuntu24_04_rocm7_2.yaml
+++ b/.github/workflows/ubuntu24_04_rocm7_2.yaml
@@ -15,11 +15,19 @@ jobs:
 
     # AMD's slim ROCm image. The -full and -complete tags carry the whole ML
     # stack -- Composable Kernel alone is over 2 GB -- which a compile check
-    # never touches. This one is about 1.1 GB and still ships hipcc and the
-    # HIP and HSA headers needed to compile the ROCm backend.
+    # never touches. This one is about 1.1 GB and still ships hipcc, the HIP
+    # and HSA headers, and device support for gfx950 and gfx1250.
     container: rocm/dev-ubuntu-24.04:7.2.4
 
-    name: ROCm
+    strategy:
+      # Report every architecture's result. A failure in generated device code
+      # is far more likely to be specific to one target than common to both,
+      # and cancelling the other leg hides exactly the comparison that matters.
+      fail-fast: false
+      matrix:
+        rocm_arch: [gfx950, gfx1250]
+
+    name: ROCm (${{ matrix.rocm_arch }})
 
     steps:
       - name: Checkout repository
@@ -63,7 +71,8 @@ jobs:
       - name: Configure the build
         run: |
           ./configure --enable-rocm --enable-rocm-dmabuf \
-                      --with-rocm="$ROCM_PATH"
+                      --with-rocm="$ROCM_PATH" \
+                      --with-rocm-arch=${{ matrix.rocm_arch }}
 
       - name: Build perftest
         run: make
-- 
2.53.0


