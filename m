Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.145.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795558761;
	b=Sl22Naj7555X21NCbhFXgVUeocFS1ddQMIayBJ1olffRzdS3Lh6FBa6wbZNl6aZaPEpm
	 wLEKG9ZJtLijj+H2SX1faR8bIb8pJf9i9+5jaYHBEAcuxMbTGbrIgZvt4JCUZKc+sZf3H
	 h491IgNC/2PGvXkldYyYphb+fqQB4CgZl23oR3wXhnJpp9wVr9jmmSDxA5Qw+kLL8ykMx
	 Q+bdetK619CB1Em7O00KLnhxyReFZQN3HN8AAQhHOjw+Xak7GxhXhuV6fy47KLBV0u325
	 3kI72U/bNWIcIMKpmoPQZ50sT5/zbcQf3MCrdfa4yalEOQpPtS2WC1hszEuPTWVomrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795558761;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version;
	bh=8Rv7EYRyjjNDGv/9kGL3HHPuWEghfC31P64R9HYBGmY=;
	b=ui/hPA2OOy0gaux2Qyk+PaKkBCz0SD5xTkFrgqA2W8lNqNUxxJxZKBE+dmaq/02iZpYv
	 gKPD4JJlfojnGY/Flf2L53XPUZnTYzAEXu9ptp3DrY7Lah1izgTUT7+Q8N3lcuAU5e6x2
	 XvuvdvZQpuJ9LZjc/7mdD9CrYjqrXaC1CoAtqqGtQxMt8L9gN+dEofTiTuSaLiP8/auZx
	 3GxZrOfylIvT78Cg0qt6kst1Yh+bjBDRZBOFz69CeTdHdLtCsBZH0zhtvbU4A6gfJEw7K
	 vJ6a2+rJe6sJcHvGmR+MKCaSXJVL+5Ahf3p+27Dhhhb0fPGCwXGfKudXDXTQbersEyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=PD01Jul9;
	arc=none smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2596960A2620;
	Tue, 24 Nov 2026 22:19:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2596960A2620
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=PD01Jul9
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AOMB2O31690773;
	Tue, 24 Nov 2026 14:18:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=8Rv7EYRyjjNDGv/9kGL3HHPuWEghfC31P64R9
	HYBGmY=; b=PD01Jul9FPS++OrOu8u3jbkAhPI5Pz2kFpTH3SVxcUi8lSPHnLyx5
	F72V0yje0p8RdCrtlxaZhx7ElieubqBI49hkPY1NC47nQeLLUSMHhobBsgA7dYt5
	WIASzXTw5YML5SSjiFbrs0+7cDngtc2bX9YUBjEIpq2XeFtlOTScCVHZ2QAOWVE1
	SuqaWV2OMBFa9Thwc8wIBlopLkNNbPF2cuoYompmRNmu08lKWwalzZc9/Zye3Zir
	2QBG0W/gupjAL8ZfkuXlGprjwJbYRT8T8Lhr5XHBGNOT+ykYQGKUz94VPhdHN8Pa
	2E+20pv1oNaG8InuISz37PhwJVY08k5pg==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j5d6wud22-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 24 Nov 2026 14:18:29 -0800 (PST)
Received: from localhost (2620:10d:c0a8:1c::11) by mail.thefacebook.com
 (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Tue, 24 Nov
 2026 22:18:28 +0000
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
	<willemdebruijn.kernel@gmail.com>,
        Kuniyuki Iwashima <kuniyu@google.com>, <bpf@vger.kernel.org>,
        =?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?=
	<ast@fiberby.net>,
        Qingfang Deng <qingfang.deng@linux.dev>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Shuah Khan
	<shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan
	<skhan@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthieu
 Baerts <matttbe@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        =?UTF-8?q?Jonas=20K=C3=B6ppeler?= <j.koeppeler@tu-berlin.de>,
        Hangbin Liu
	<hangbin.liu@linux.dev>
Subject: [PATCH net-next v3 11/12] selftests: tc-testing: add tests for the psp action
Date: Tue, 24 Nov 2026 14:17:57 -0800
Message-ID: <20261124221758.3230929-12-toddfreed@meta.com>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261124221758.3230929-1-toddfreed@meta.com>
References: <20261124221758.3230929-1-toddfreed@meta.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI0MDA4NyBTYWx0ZWRfX3pD0+6X2uyyW
 vGTjo+gAjNTAMq6a7mfj7NWzfrnTtXjJokB0pWcjWtu/WSnavlBuS5OYeDORlyfuSbx0shbQOwj
 YHYMTW8n+h3+SY+zv6vuaQ90WjY6WZA=
X-Proofpoint-ORIG-GUID: q_0jqp3HxsbxWPCHEvE1pX8w2Yls4VZs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI0MDA4NyBTYWx0ZWRfX4KdFvUcSUhz+
 gwoSjiDR2zfWxpdCMH8oBBTcP8KXaGpYHYHA4MQrmjfv8B53iqNhlhYQ5Wp5MzgV8cm/6AwD5kv
 em0B/wzHh1W/too1slW3lltXHpAbLbvj7iNsTFeOaLI3b6qOLsYQwsP1/rDBh9Xs4N3lypUqSCn
 uB1ZjRKUfYPxtGk5S7Z1UcpMi7FYUYt6qp0SedAWyt084GDVIINMj99o9gLh89Ra+CYQV0U330L
 w3zJ8msSYeauDXnO/Q7vP/uwL5AhMH383Y8O1mkm+4HTjXGBMeUzQDL/M5oWv96awoax45IPl4o
 kN3jsXjZnldjXDpOgIt5Yco75JxDHIzeBtc0kTFgC/FEFS417yWrQoxVUx+cz98sEEzo6PU+VDI
 HfWCqDNhni2ZTBcXvruLSaHyd3NHtFEjwlSYlcAcAooazH8/ea3gU7z9C2oZOhyI6AXX4OxQv2O
 J54V52n6mzp4aFTXzxQ==
X-Proofpoint-GUID: q_0jqp3HxsbxWPCHEvE1pX8w2Yls4VZs
X-Authority-Analysis: v=2.4 cv=f5rdl+yM c=1 sm=1 tr=0 ts=6b060d35 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=03ozwUkBphtHgyqjj1sw:22 a=VabnemYjAAAA:8 a=9j4IQkXZfjSUHsAYhOIA:9
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-24_06,2026-11-23_01,2025-10-01_01

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
 .../tc-testing/tc-tests/actions/psp.json      | 427 ++++++++++++++++++
 tools/testing/selftests/tc-testing/tdc.sh     |   1 +
 3 files changed, 430 insertions(+)
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
index 000000000000..e57f85810b12
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/psp.json
@@ -0,0 +1,427 @@
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
+        "cmdUnderTest": "$TC actions add action psp decap pass index 4 2>&1 | grep -q 'PSP action already exists'",
+        "expExitCode": "0",
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
+        "cmdUnderTest": "$TC actions add action psp encap assoc 4294967295 index 9 2>&1 | grep -q 'PSP association not found'",
+        "expExitCode": "0",
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
+    },
+    {
+        "id": "d0fe",
+        "name": "Add flower psp_dev filter with device 0",
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
+        "cmdUnderTest": "$TC filter add dev $DEV1 ingress protocol ip pref 1 flower psp_dev 0 action drop",
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

