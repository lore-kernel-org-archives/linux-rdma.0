Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.145.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051904;
	b=jhdnJD8iMeCEIXcXft7ruvikPJ2Z+ky6OwPR4mX7HVpt0jg6yRsQDsTDaoFjtCUftk+g
	 hrLcYIjl6S5ZvlFscUJvUCw+V99O/3KM3jn7fFqjpJxlRXxTD/jqpomFfS1GHbUMVb515
	 xnrNB9qYC2eWEi8UsyEv2e3jlmZyX9WqbeJUd4O2EU+pN5xPPkOsj4pDpW+umqFlROw9S
	 2344epyxOM+IZzXOmD7xYx1my20FGfLN/RuP2C/jeTdUMQa9eDzIWUVHJY1PGIuo+e3xC
	 BnKCoPMJ9eH4eFv1AMTCfSg2pgF9ReSbddLEWh7t/NGkhqMojr7n89l8yERzAprz1zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051904;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version;
	bh=+6h6s6//1V5/9+9ft7j4vW203tlWXUvDARmYS7jIwvg=;
	b=2kYjcmu5zqvwEvJfmvhg5+z/J8utuOrEOKONMakqIJTj98FaV8e1ov6II0XLh7OWoyHM
	 /vsx0iRBtGK9ngiKjCELK9E1/7My4bWdsAUiOP9Pnxu2NDIXBxSkeuRylLkYHGP1rg+mJ
	 kJtkZkUF7P4mu5LJtrzBlvanTX5uChpUQmjv+F8YWRxdBlBLPhbbmZV7QNoA5bovTyj3b
	 +YJVDofXA29hYPnS5ytwlzerOQvhYx0RwPG5kdWE1I22cLvrJgctSYXySTCCFxwtCNKvo
	 zUKpfgnCGAO5QQUa4uvHNtssncgd0M5bv8y3ImJWfuigpopKoejjng1ZO/lNGvc+pqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=OszjmT3q;
	arc=none smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED50606D68E;
	Thu, 19 Nov 2026 01:31:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CED50606D68E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=OszjmT3q
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AJ18qC34054251;
	Wed, 18 Nov 2026 17:31:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=+6h6s6//1V5/9+9ft7j4vW203tlWXUvDARmYS
	7jIwvg=; b=OszjmT3quz+UYcNp5FfzKJRhGT3LYAIpHWsd9A8BSC7z9S8VlA14L
	cpMwAQmJHPcFQZgxSZGzMB7i/Bh8Ze3YD5vsJqGOFT19C3pmZBy35gt5VBo73XiO
	Koew96xBl4JL+awgJxyLvzM9dAwbXD250S6Ozs9m26VPfOjvRgDtnZpZdtCvxaam
	KbgCmhqv9IEWBcbux2dkW6t4YatQg28tbBKfJzAxyq+XrixCkGvpoRr+1WM7kzUz
	bj1Pvg1NmrfGPMX3qdF3PxBSj83WXZDp+pntp4J8irUjZfqKW3qSbWJGgRXpFoo4
	+5dJPiTtKrQZ1ZQ8z8fi+U9FnVfH2LP/A==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j0yujb8ha-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 18 Nov 2026 17:31:30 -0800 (PST)
Received: from localhost (2620:10d:c0a8:1b::30) by mail.thefacebook.com
 (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Thu, 19 Nov
 2026 01:31:29 +0000
From: Todd Freed <toddfreed@meta.com>
To: <netdev@vger.kernel.org>
CC: "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn
	<andrew+netdev@lunn.ch>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?=
	<bjorn@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>, Cosmin Ratiu
	<cratiu@nvidia.com>,
        Daniel Zahka <daniel.zahka@gmail.com>,
        Donald Hunter
	<donald.hunter@gmail.com>,
        Dragos Tatulea <dtatulea@nvidia.com>,
        Eric Dumazet
	<edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim
	<jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        Leon Romanovsky
	<leon@kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>,
        Paolo Abeni
	<pabeni@redhat.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Saeed Mahameed
	<saeedm@nvidia.com>, Simon Horman <horms@kernel.org>,
        Tariq Toukan
	<tariqt@nvidia.com>, Wei Wang <weiwan@google.com>,
        Willem de Bruijn
	<willemdebruijn.kernel@gmail.com>
Subject: [PATCH net-next v2 11/12] selftests: tc-testing: add tests for the psp action
Date: Wed, 18 Nov 2026 17:31:02 -0800
Message-ID: <20261119013103.1092559-12-toddfreed@meta.com>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261119013103.1092559-1-toddfreed@meta.com>
References: <20261119013103.1092559-1-toddfreed@meta.com>
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
X-Authority-Analysis: v=2.4 cv=TasDJhQh c=1 sm=1 tr=0 ts=6afe5172 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=8elwO82fXORLTBIkMd32:22 a=VabnemYjAAAA:8 a=atrOkcuyvV3xl5QzYmoA:9
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE5MDAwNSBTYWx0ZWRfXyTQQ7cGrTaIJ
 UtpYlhDzvjks7PEpDd4Kp8LEJyyf9HPfktCnbdDlnVehi6rIjG+6jn42jh+uRjQUGo1Y0zN1ANc
 jJaWHYkULzJ62efu6vrx7SuqpaSw0kSqr5Vkj6KRyabxsMIKGLcYcSg8JsMvzxyciY3QTKuehsd
 pYov5u6yBEklZMaPzyBE52B/+4wWefWHnv+ANNkI3PQdCO6kMQwCYUZgDCLhIlSSuyvnRVKllm5
 glCgeP54Fz5k8WlogaR2nIg8my9vEdiO1XfYZ42qGJ8ZfLNbfoM6N9dmZ7ucgA9qngu8QJkS1cp
 3j3H8hKuMoJsQb89jH9rTcbPHRzAsIIP33NxVmXnJpxUcvGd8zJ8ClsjZTEIDnPazjN935WSuHf
 d37VL3sMMxNf2cYQ0H3/pbs1TAXfJb6CzvIUBCBq59rO0R6U8FQgzYR5TJ0XtZ1HJjYOAQqEtbi
 sfiKWPvTfcPIUqHz4Ew==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE5MDAwNSBTYWx0ZWRfX49k6rgFtqG+l
 Mq0SNK9+07EqTFQ4AWtMNChb+ttCaijJBsfqYgYW12syLBeBJDKMQhyXaFhCkYydvXuwzboXYAk
 cNLIE6j5ld0mG2TigaQgB77eeMVBLa8=
X-Proofpoint-ORIG-GUID: m7XCLYINGOdC-mn-rHq_D2_KsRt_nI_y
X-Proofpoint-GUID: m7XCLYINGOdC-mn-rHq_D2_KsRt_nI_y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-19_01,2026-11-16_01,2025-10-01_01

Add / replace / delete / flush psp decap actions, check that
associations which don't exist are rejected, and add flower filters
matching on psp_spi, psp_ver and psp_dev, out of range psp_ver and
psp_dev rejected.

The tests of rejected actions match the kernel's extack message, so
that they don't pass on tc's own argument checks. tc itself refuses
decap with an association, and encap without one, so those kernel
checks aren't covered here.

Creating associations takes the PSP netlink family and a PSP device;
the drv-net psp.py test covers actions using them.

The tests need a tc with the psp action and the flower psp_* keys; they
skip without it (dependsOn).

Signed-off-by: Todd Freed <toddfreed@meta.com>
---
 tools/testing/selftests/tc-testing/config     |   2 +
 .../tc-testing/tc-tests/actions/psp.json      | 403 ++++++++++++++++++
 tools/testing/selftests/tc-testing/tdc.sh     |   1 +
 3 files changed, 406 insertions(+)
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
index 000000000000..af5366caf5c7
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/psp.json
@@ -0,0 +1,403 @@
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
+        "cmdUnderTest": "$TC actions add action psp index 12 2>&1 | grep -q 'Missing PSP action, encap or decap'",
+        "expExitCode": "0",
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
+        "id": "a744",
+        "name": "Add flower psp_spi filter with psp decap",
+        "category": [
+            "actions",
+            "psp",
+            "filter"
+        ],
+        "dependsOn": "$TC filter add flower help 2>&1 | grep -q psp_spi && $TC actions add action psp help 2>&1 | grep -q decap",
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
+        "dependsOn": "$TC filter add flower help 2>&1 | grep -q psp_spi && $TC actions add action psp help 2>&1 | grep -q decap",
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
2.53.1-Meta

