Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.145.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795558757;
	b=tFESLBXiDAMOpXhj1C/fNv1lVxr7SSgcxD8bkB//m7vPDGABrRtV+HVPgmk2lWXrL8pm
	 RdfzbiUBETfR4h3BPAUhyEK1u8MzNdHt//wlVbOiWWzQevbtoOGhN7x9+c+YYD29VFQK1
	 watbkMW5HKenbMyVxvLdiX63YEKOEr4C52S7lT7d5Zx0bY8YLYagLbyVv5oiQLtGgPwEX
	 LA/9N66FpjIlKYRo/qtNN8z5eYSvYlrbBfmWqgcfrDAmtlFkWMT1lWHqMBk6X9d/t209o
	 1dDmmM+ZDlzkGYKtwgj5T3Jyle7L+yLiQj9iw7qgimHByxxim47oqXZHZJ1jqVYq4Qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795558757;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version;
	bh=go7N4p6TZywoCd1ciY5XKnYSEFOeqnaj5J6isfljnCQ=;
	b=J67UwEdqA9o/8gHo3piDOZ4nt02QBor4voGwGNra2ZitrjbkEP6xHsXd7Hwjd/g7A8aV
	 EhRbLQpgEllIYof/iy5RW7zWhY9mSLVAVtaAHX+L6N74CJ+IfxP6L1ksABvt4KJb00Vgi
	 xoJLjNyJKDqinCfo66ZSyqv6I6TDO6BseLN4ueeoO0d+p59rfXOQfc2oaYgSmDR0tdVRp
	 ClEiuu9Cw2/jwGW1OSOGCmtMLELvE8ZbYgaMsHydLjrMTrfHfbBsTh9l3y732yWghvnCh
	 HtHNjpm9DKEksRro358K0tXxNWbFU6lxcM2/AglJjsUtl7vzgWUVkXS8fVhUbLq3ayQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=h5ll4ffY;
	arc=none smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F697606A6B8;
	Tue, 24 Nov 2026 22:19:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5F697606A6B8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=h5ll4ffY
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AOMB2O21690773;
	Tue, 24 Nov 2026 14:18:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=go7N4p6TZywoCd1ciY5XKnYSEFOeqnaj5J6is
	fljnCQ=; b=h5ll4ffYEMJok+NaKBU+OC+Z9GPU6GyCtOfss69pxAmKFJSC+VONW
	I0l4O9B5JsJjDDUn5/YTEzgFM7t/cmv8MdBM9Ms4bUjxYsaCpLpUVwd3TsqBZ2X4
	7YWfHoiZieXtNHjCoSnRep9q2cQNDNwbpKsPgRuwNzYgM8pwWBX28JdLMzx7im/2
	yxQy1O5XR7m+VxorCtUMFl6RHvw4kRDds0SA6WLTrM5+dDMGCdKLIWvgxZ+ivEPc
	Jil9QkQb88xsw0kKtxLEEEMXxoO6zPuXVa9G0VlspD/8ZzdhhZLeeBX8kkzFVPeW
	vDU+DrOTAZU59nq2LZHoGggBfJIc7hS7g==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j5d6wud22-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 24 Nov 2026 14:18:28 -0800 (PST)
Received: from localhost (2620:10d:c0a8:1b::2d) by mail.thefacebook.com
 (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Tue, 24 Nov
 2026 22:18:27 +0000
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
Subject: [PATCH net-next v3 10/12] selftests: tc-testing: run dependsOn probes outside the test namespace
Date: Tue, 24 Nov 2026 14:17:56 -0800
Message-ID: <20261124221758.3230929-11-toddfreed@meta.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI0MDA4NyBTYWx0ZWRfXxufgjlArykGy
 oStT7HsYdpJhW+Z1DoM1l8vKWilVB85dlyN35kbi+eBJfdZNxsVcb/M5EW2x7p22kYMzF4eL191
 S2Gc9AO9WO/FFhrYISap9TZ90JnxA9I=
X-Proofpoint-ORIG-GUID: XSEg7jBOzDVXhy8zhFJK73DOjpZ4RMkw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI0MDA4NyBTYWx0ZWRfX8DqaTZUs1aCC
 za6k8CrkBNga/+hsEGBdQkHlg5QLr45Gr2gQqQTfon5bGlgjIJdgleq+wom21d25mnRtdN++gc9
 JkR2AVhzTmU775POn9HOL38caV25SzVP8UdozxBrYq3kqL5IQoxGqsGbw40wYokED3Dfnh19Hua
 J+y5xcaNqiK+2ivmbY38v+qDDHY/PcMBlu/EBg7C6aRCIrUixjHlsLK+vdPhEOdi2U7nlb78sk9
 s6OWNwBMlFJxvWXIWTsLTZ+R+RM912GmIwWVL2JrveLzwkyBOjJmX+xprgTX/bBavZhMHMvQIxH
 lNznjPSvpfxQQJ790ib/aCZ91ILUsWd4e8ZcIBmv/tFNLUZydFJIT1iDZe+YX4hDzbiPBmtTB1m
 CG21TRuWWsRWdqeH8fkzCSTWkcjAJV7PhpUpcD7wfUurCBW6VJ8PLn+UXGyZboUYUFgyi9JhMNg
 Uzao9WMuXE9JG3yqmqw==
X-Proofpoint-GUID: XSEg7jBOzDVXhy8zhFJK73DOjpZ4RMkw
X-Authority-Analysis: v=2.4 cv=f5rdl+yM c=1 sm=1 tr=0 ts=6b060d34 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=03ozwUkBphtHgyqjj1sw:22 a=VabnemYjAAAA:8 a=bVv6ZBUfH5OyOozUiAoA:9
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-24_06,2026-11-23_01,2025-10-01_01

A test's dependsOn probe runs as an execute stage command, but before
the test's namespace is created. nsPlugin prefixes the command with
"ip netns exec tcut", which makes it fail. The tests which require
nsPlugin and probe tc's help output are therefore skipped currently:
the mirred blockid tests and the tunnel_key nofrag test.

Probes are meant to check what tc and the kernel support, not anything
in the test's namespace. Run them as their own stage ("probe"), which
makes them run in the base namespace. Add the stage to the README, and
say in AddingTestCases.txt that dependsOn runs in the base namespace.

Fixes: 98cfbe4234a4 ("selftests/tc-testing: localize test resources")
Signed-off-by: Todd Freed <toddfreed@meta.com>
---
 tools/testing/selftests/tc-testing/README                     | 1 +
 .../tc-testing/creating-testcases/AddingTestCases.txt         | 4 +++-
 tools/testing/selftests/tc-testing/tdc.py                     | 2 +-
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/tc-testing/README b/tools/testing/selftests/tc-testing/README
index fc8e858ff119..430ac0bf68ab 100644
--- a/tools/testing/selftests/tc-testing/README
+++ b/tools/testing/selftests/tc-testing/README
@@ -168,6 +168,7 @@ of the command.
 The stages are identified by the following strings:
 
   - pre  (pre-suite)
+  - probe (dependsOn, before setup)
   - setup
   - command
   - verify
diff --git a/tools/testing/selftests/tc-testing/creating-testcases/AddingTestCases.txt b/tools/testing/selftests/tc-testing/creating-testcases/AddingTestCases.txt
index ff956d8c99c5..c61f2e2020e0 100644
--- a/tools/testing/selftests/tc-testing/creating-testcases/AddingTestCases.txt
+++ b/tools/testing/selftests/tc-testing/creating-testcases/AddingTestCases.txt
@@ -39,7 +39,9 @@ skip:         A completely optional key, if the corresponding value is "yes"
               marked as skipped. This key can be placed anywhere inside the
               test case at the top level.
 dependsOn:    Same as 'skip', but the value is executed as a command. The test
-              is skipped when the command returns non-zero.
+              is skipped when the command returns non-zero. The command runs
+              in the base namespace, before setup, so it can't use the test's
+              devices.
 category:     A list of single-word descriptions covering what the command
               under test is testing. Example: filter, actions, u32, gact, etc.
 setup:        The list of commands required to ensure the command under test
diff --git a/tools/testing/selftests/tc-testing/tdc.py b/tools/testing/selftests/tc-testing/tdc.py
index 511d66c36a2a..541caf984519 100755
--- a/tools/testing/selftests/tc-testing/tdc.py
+++ b/tools/testing/selftests/tc-testing/tdc.py
@@ -399,7 +399,7 @@ def run_one_test(pm, args, index, tidx):
     if 'dependsOn' in tidx:
         if (args.verbose > 0):
             print('probe command for test skip')
-        (p, procout) = exec_cmd(tidx, args, pm, 'execute', tidx['dependsOn'])
+        (p, procout) = exec_cmd(tidx, args, pm, 'probe', tidx['dependsOn'])
         if p:
             if (p.returncode != 0):
                 res = TestResult(tidx['id'], tidx['name'])
-- 
2.53.1-Meta

