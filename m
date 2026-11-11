Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.145.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794358610;
	b=mw0qLHFCN2qgYvw3/9rtpLkLH++Jl9yg6B6aT9FHNWgbQX3PQHSRGqa6v2qp4aOf+PfW
	 4N2CIHleaKklx43LBQAqwAiQDuwtwACwkpBROq5J4SepauicjpsuJQkun+rfz/SoKdx9q
	 Phs1Y4+vsb7y07vl6nSWLmv0mhkxsl0ebKOd5SIU7pXTyxIaIrnmOowlocMp1Id/xqOzb
	 1Ift7OJqDFDXXbtgW1zU3ROB+O76tsnQ1zKvo1kOf10nfIGWJMueicZ0N3FF8V/MeWFnQ
	 f4ciBgumGFJ6HymkQdr59y1sCMurgrovU54jBlg92eTZzkw28eia9v4POW1av/X9itw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794358610;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version;
	bh=fe/3ZzWyMTm9YIRz1HSgSxtZ46qPtlw2KRJRQ2hdvFM=;
	b=PTWIB65R8Z+PQQnNT5R+4C1mtXC345OKSbRU7YDHFfbHDzXjR/uqapOY3vV/q/gUfzhc
	 NjmmuSfXeu+MkotMx41F12samjtdelm1qh2eoTf5I1Vu1jb9BrqfcwdKi/flz3SftssMB
	 Xt5RCA6wq76xdPy0XqqjnuvCtUFpV5Ml+6SkVK7/huVm+6ZdHyK8MVJD4WqxX6duXnMur
	 vRsN3Fa45ZOJaiSzY9/yakO84Edain47DhBamPuxGFnoM7YOPZpBPp14syVVq52GgfWLM
	 DOEWCY1T9q6CTI9C3OLbg7vtbd4nxX3XeVarr2MR6RS+ip7Yq+TFyLn32501+jQmZRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=Ntxa8gDe;
	arc=none smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6327606AA16;
	Wed, 11 Nov 2026 00:56:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C6327606AA16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=Ntxa8gDe
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AB0WPid3063914;
	Tue, 10 Nov 2026 16:56:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=fe/3ZzWyMTm9YIRz1HSgSxtZ46qPtlw2KRJRQ
	2hdvFM=; b=Ntxa8gDed7SBllRXgRfxFl+R1KwwT9yE4wKQAQGfheOIlJYXWLSkg
	hgCMrqSlhwKg95WZ754NUzbCm1jgxpKSgQuBbnV7y32A9phDSrendOjS2RGg9C55
	y9bzVGARH5NXLSl9+wrVqC+dnY7+69lyAHXDNAhiOGz82T+WstfXq6//oxOd1Sfe
	037TUvDSJsG33TiNGcRfXRzBVLEfYEcLjNFOkmMNGSqb/vuhc0gPEF5cVd1d2pp/
	FvvW8kkZjOkBiieKlkt/GcetUQdO14ootss+HZzluZJibbTE9cZ0RfjH6RoZuXxF
	WqtZApdsayKDpC0uHCbUZi13xUiychSmQ==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4huqrpspmq-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 10 Nov 2026 16:56:16 -0800 (PST)
Received: from localhost (2620:10d:c0a8:1b::2d) by mail.thefacebook.com
 (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Wed, 11 Nov
 2026 00:56:13 +0000
From: Todd Freed <toddfreed@meta.com>
To: <netdev@vger.kernel.org>, <toddfreed@meta.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn
	<andrew+netdev@lunn.ch>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?=
	<bjorn@kernel.org>,
        <bpf@vger.kernel.org>, Daniel Borkmann
	<daniel@iogearbox.net>,
        Daniel Zahka <daniel.zahka@gmail.com>,
        Donald Hunter
	<donald.hunter@gmail.com>,
        Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko
	<jiri@resnulli.us>,
        John Fastabend <john.fastabend@gmail.com>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>,
        "Martin
 KaFai Lau" <martin.lau@linux.dev>,
        Paolo Abeni <pabeni@redhat.com>, Saeed
 Mahameed <saeedm@nvidia.com>,
        Simon Horman <horms@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>,
        Wei Wang <weiwan@google.com>,
        Willem de Bruijn
	<willemdebruijn.kernel@gmail.com>
Subject: [PATCH net-next v1 14/15] selftests: tc-testing: add tests for the psp action
Date: Tue, 10 Nov 2026 16:55:32 -0800
Message-ID: <20261111005533.6436-15-toddfreed@meta.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261111005533.6436-1-toddfreed@meta.com>
References: <20261111005533.6436-1-toddfreed@meta.com>
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
X-Authority-Analysis: v=2.4 cv=PapqFShd c=1 sm=1 tr=0 ts=6af3bd30 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=tpM8CJlwf7uhpglF1g9U:22 a=VabnemYjAAAA:8 a=HMdNEJOxOCjlhTofXdEA:9
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-GUID: DoLNlsY-Bh1k9nVE8ajU8J4GNffGjODP
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDAwMyBTYWx0ZWRfXxEHWoec5vg9A
 6NpXtmyK7F99zoGIX8Ip2HJc4uBeFBWpWZBnTjBE5F5vbLssI9l+rCpUoAXUR8vxNcG38tDPA/N
 mXkPxbHz4SNKG1+8UoUE6okXYF7hQMw=
X-Proofpoint-ORIG-GUID: DoLNlsY-Bh1k9nVE8ajU8J4GNffGjODP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDAwMyBTYWx0ZWRfXyAvSZ0bLBebA
 NetXwZjRYrndfrs4mRH+X0TaWw2SnsqtteRh3XXVo5GlBhG7f5gjyYdnTh6fwWGM1gRmWsjp5S4
 ubkCnwmT+QSHqYO26gfpI3LttGypBVgs04DQkDq8PX07mXvJIPgi12FZN4Obr9PUB5vuiqdaVHI
 lekMDzqVi1uaF6FW92WudHAo5iZRaGkQ6GCun6uJI2x7swLcrFAfPa9P7M0m9EOy4RSweyNlIeR
 LsEgDOu3a3F3o1TYIncDDXJlQArLM+oVS/iFuU20AoX+OwUjxq7n0bOgOryiyyr3TwEDE+U7Dwd
 +kozmBWtsMu19SCEGnTrBgM6ytS9V+kfR8upYg0HPoR0LTQWhKvFOxyiFh1JrPMzD6Hfdkx6WMI
 bIk90P9iq7rir9s6BpDSTmYE2p9AZufDtBnSR/XC4n09H51fgOnWakD3vY3ys4pgSbTFt6KVKRO
 7sgG/lyZW+8ZXA1lqrg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-10_07,2026-11-06_01,2025-10-01_01

Add / replace / delete / flush psp decap actions, check that encap
without an association, associations which don't exist, and decap with
an association are rejected, and add flower filters matching on
psp_spi, psp_ver and psp_dev, out of range psp_ver and psp_dev
rejected.

Creating associations takes the PSP netlink family and a PSP device,
the drv-net psp.py test covers actions using them.

The tests need a tc with the psp action and the flower psp_* keys; they
skip without it (dependsOn).

Signed-off-by: Todd Freed <toddfreed@meta.com>
---
 tools/testing/selftests/tc-testing/config     |   2 +
 .../tc-testing/tc-tests/actions/psp.json      | 459 ++++++++++++++++++
 tools/testing/selftests/tc-testing/tdc.sh     |   1 +
 3 files changed, 462 insertions(+)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/actions/psp.json

diff --git a/tools/testing/selftests/tc-testing/config b/tools/testing/selftests/tc-testing/config
index 0e5618be0335..7828161cc3c8 100644
--- a/tools/testing/selftests/tc-testing/config
+++ b/tools/testing/selftests/tc-testing/config
@@ -101,6 +101,8 @@ CONFIG_NET_ACT_TUNNEL_KEY=m
 CONFIG_NET_ACT_CT=m
 CONFIG_NET_ACT_MPLS=m
 CONFIG_NET_ACT_GATE=m
+CONFIG_INET_PSP=y
+CONFIG_NET_ACT_PSP=m
 CONFIG_NET_IFE_SKBMARK=m
 CONFIG_NET_IFE_SKBPRIO=m
 CONFIG_NET_IFE_SKBTCINDEX=m
diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/psp.json b/tools/testing/selftests/tc-testing/tc-tests/actions/psp.json
new file mode 100644
index 000000000000..990e8bd1ce9a
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/psp.json
@@ -0,0 +1,459 @@
+[
+    {
+        "id": "8357",
+        "name": "Add psp decap action",
+        "category": [
+            "actions",
+            "psp"
+        ],
+        "dependsOn": "$TC actions add action psp help 2>&1 | grep -q decap",
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            [
+                "$TC actions flush action psp",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action psp decap index 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions get action psp index 1",
+        "matchPattern": "action order [0-9]+: psp decap pipe.*index 1 ref",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action psp"
+        ]
+    },
+    {
+        "id": "7676",
+        "name": "Add psp decap action with drop control",
+        "category": [
+            "actions",
+            "psp"
+        ],
+        "dependsOn": "$TC actions add action psp help 2>&1 | grep -q decap",
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            [
+                "$TC actions flush action psp",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action psp decap drop index 2",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions get action psp index 2",
+        "matchPattern": "action order [0-9]+: psp decap drop.*index 2 ref",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action psp"
+        ]
+    },
+    {
+        "id": "9a26",
+        "name": "Add psp decap action without index",
+        "category": [
+            "actions",
+            "psp"
+        ],
+        "dependsOn": "$TC actions add action psp help 2>&1 | grep -q decap",
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            [
+                "$TC actions flush action psp",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action psp decap",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action psp",
+        "matchPattern": "action order [0-9]+: psp decap pipe",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action psp"
+        ]
+    },
+    {
+        "id": "156e",
+        "name": "Replace psp decap action",
+        "category": [
+            "actions",
+            "psp"
+        ],
+        "dependsOn": "$TC actions add action psp help 2>&1 | grep -q decap",
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            [
+                "$TC actions flush action psp",
+                0,
+                1,
+                255
+            ],
+            "$TC actions add action psp decap index 3"
+        ],
+        "cmdUnderTest": "$TC actions replace action psp decap pass index 3",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions get action psp index 3",
+        "matchPattern": "action order [0-9]+: psp decap pass.*index 3 ref",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action psp"
+        ]
+    },
+    {
+        "id": "006b",
+        "name": "Add psp action with an existing index",
+        "category": [
+            "actions",
+            "psp"
+        ],
+        "dependsOn": "$TC actions add action psp help 2>&1 | grep -q decap",
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            [
+                "$TC actions flush action psp",
+                0,
+                1,
+                255
+            ],
+            "$TC actions add action psp decap index 4"
+        ],
+        "cmdUnderTest": "$TC actions add action psp decap pass index 4",
+        "expExitCode": "255",
+        "verifyCmd": "$TC actions get action psp index 4",
+        "matchPattern": "action order [0-9]+: psp decap pipe.*index 4 ref",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action psp"
+        ]
+    },
+    {
+        "id": "3f41",
+        "name": "Delete psp action",
+        "category": [
+            "actions",
+            "psp"
+        ],
+        "dependsOn": "$TC actions add action psp help 2>&1 | grep -q decap",
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            [
+                "$TC actions flush action psp",
+                0,
+                1,
+                255
+            ],
+            "$TC actions add action psp decap index 5"
+        ],
+        "cmdUnderTest": "$TC actions del action psp index 5",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action psp",
+        "matchPattern": "action order [0-9]+: psp",
+        "matchCount": "0",
+        "teardown": [
+            "$TC actions flush action psp"
+        ]
+    },
+    {
+        "id": "2b21",
+        "name": "Flush psp actions",
+        "category": [
+            "actions",
+            "psp"
+        ],
+        "dependsOn": "$TC actions add action psp help 2>&1 | grep -q decap",
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            [
+                "$TC actions flush action psp",
+                0,
+                1,
+                255
+            ],
+            "$TC actions add action psp decap index 6",
+            "$TC actions add action psp decap drop index 7"
+        ],
+        "cmdUnderTest": "$TC actions flush action psp",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action psp",
+        "matchPattern": "action order [0-9]+: psp",
+        "matchCount": "0",
+        "teardown": [
+            "$TC actions flush action psp"
+        ]
+    },
+    {
+        "id": "2d50",
+        "name": "Add psp action without encap or decap",
+        "category": [
+            "actions",
+            "psp"
+        ],
+        "dependsOn": "$TC actions add action psp help 2>&1 | grep -q decap",
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            [
+                "$TC actions flush action psp",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action psp index 12",
+        "expExitCode": "255",
+        "verifyCmd": "$TC actions list action psp",
+        "matchPattern": "action order [0-9]+: psp",
+        "matchCount": "0",
+        "teardown": [
+            "$TC actions flush action psp"
+        ]
+    },
+    {
+        "id": "cab5",
+        "name": "Add psp encap action without assoc, with index",
+        "category": [
+            "actions",
+            "psp"
+        ],
+        "dependsOn": "$TC actions add action psp help 2>&1 | grep -q decap",
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            [
+                "$TC actions flush action psp",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action psp encap index 8",
+        "expExitCode": "255",
+        "verifyCmd": "$TC actions list action psp",
+        "matchPattern": "action order [0-9]+: psp",
+        "matchCount": "0",
+        "teardown": [
+            "$TC actions flush action psp"
+        ]
+    },
+    {
+        "id": "3203",
+        "name": "Add psp encap action with an unknown assoc",
+        "category": [
+            "actions",
+            "psp"
+        ],
+        "dependsOn": "$TC actions add action psp help 2>&1 | grep -q decap",
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            [
+                "$TC actions flush action psp",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action psp encap assoc 4294967295 index 9",
+        "expExitCode": "255",
+        "verifyCmd": "$TC actions list action psp",
+        "matchPattern": "action order [0-9]+: psp",
+        "matchCount": "0",
+        "teardown": [
+            "$TC actions flush action psp"
+        ]
+    },
+    {
+        "id": "0c17",
+        "name": "Reject psp decap action with an assoc",
+        "category": [
+            "actions",
+            "psp"
+        ],
+        "dependsOn": "$TC actions add action psp help 2>&1 | grep -q decap",
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            [
+                "$TC actions flush action psp",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action psp decap assoc 1 index 10",
+        "expExitCode": "255",
+        "verifyCmd": "$TC actions list action psp",
+        "matchPattern": "action order [0-9]+: psp",
+        "matchCount": "0",
+        "teardown": [
+            "$TC actions flush action psp"
+        ]
+    },
+    {
+        "id": "a744",
+        "name": "Add flower psp_spi filter with psp decap",
+        "category": [
+            "actions",
+            "psp",
+            "filter"
+        ],
+        "dependsOn": "$TC filter add flower help 2>&1 | grep -q psp_spi",
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 ingress protocol ip pref 1 flower psp_spi 0x1234 action psp decap",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 ingress",
+        "matchPattern": "psp_spi 0x1234.*psp decap pipe",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "be4e",
+        "name": "Add flower psp_spi filter with mask",
+        "category": [
+            "actions",
+            "psp",
+            "filter"
+        ],
+        "dependsOn": "$TC filter add flower help 2>&1 | grep -q psp_spi",
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 ingress protocol ipv6 pref 1 flower psp_spi 0x80001234/0x8000ffff action drop",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 ingress",
+        "matchPattern": "psp_spi 0x80001234/0x8000ffff",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "4e1f",
+        "name": "Add flower psp_spi, psp_ver and psp_dev filter with psp decap",
+        "category": [
+            "actions",
+            "psp",
+            "filter"
+        ],
+        "dependsOn": "$TC filter add flower help 2>&1 | grep -q psp_spi",
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 ingress protocol ip pref 1 flower psp_spi 0x1234 psp_ver 1 psp_dev 7 action psp decap",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 ingress",
+        "matchPattern": "psp_spi 0x1234.*psp_ver 1.*psp_dev 7.*psp decap pipe",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "7c3a",
+        "name": "Add flower psp_ver 0 filter",
+        "category": [
+            "actions",
+            "psp",
+            "filter"
+        ],
+        "dependsOn": "$TC filter add flower help 2>&1 | grep -q psp_spi",
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 ingress protocol ipv6 pref 1 flower psp_ver 0 action drop",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 ingress",
+        "matchPattern": "psp_ver 0",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "b58d",
+        "name": "Add flower psp_ver filter with an invalid version",
+        "category": [
+            "actions",
+            "psp",
+            "filter"
+        ],
+        "dependsOn": "$TC filter add flower help 2>&1 | grep -q psp_spi",
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 ingress protocol ip pref 1 flower psp_ver 16 action drop",
+        "expExitCode": "2",
+        "verifyCmd": "$TC filter show dev $DEV1 ingress",
+        "matchPattern": "psp_ver",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "2f96",
+        "name": "Add flower psp_dev filter with an invalid device",
+        "category": [
+            "actions",
+            "psp",
+            "filter"
+        ],
+        "dependsOn": "$TC filter add flower help 2>&1 | grep -q psp_spi",
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 ingress protocol ip pref 1 flower psp_dev 65536 action drop",
+        "expExitCode": "2",
+        "verifyCmd": "$TC filter show dev $DEV1 ingress",
+        "matchPattern": "psp_dev",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    }
+]
diff --git a/tools/testing/selftests/tc-testing/tdc.sh b/tools/testing/selftests/tc-testing/tdc.sh
index 25cdc256287d..433af92364ac 100755
--- a/tools/testing/selftests/tc-testing/tdc.sh
+++ b/tools/testing/selftests/tc-testing/tdc.sh
@@ -24,6 +24,7 @@ try_modprobe act_mpls
 try_modprobe act_nat
 try_modprobe act_pedit
 try_modprobe act_police
+try_modprobe act_psp
 try_modprobe act_sample
 try_modprobe act_simple
 try_modprobe act_skbedit
-- 
2.53.0-Meta

