Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.153.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051900;
	b=DFHbw8GOIBenzMqXbgNy4pS8Jd4YQgCdS7eJxyy21K8vW5ThDpLG7YhmK4XhJnAc+Cui
	 izm0X4R2VNHztNgd015pD4dPHeEJ4vsXT6ivbWse6BHYZ5w8Q6eukM39vn5xtkOr+52Cm
	 zQwIgkoCtmV04U+N7p8FwMGpqNFBzdGCV88qkZTPZkJ8romOyDaIGyzk8sVIYCX1skgna
	 iBC8a+6q6sLo/UxPqYJ6ODBzCI/SK4ggAqu3ISoRcziZf1PV/jT9Y7Z75qovFa0qq//Xr
	 aqiaj5no+tWuHCTcx80UmkQZZk5QlvR6PJoTN2ftnMdaN6nJocOJRqkKj2i3Z6JGcBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051900;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version;
	bh=pNrcFkQV1C/8zLJHTThB2eiTETmGNutp7bQGWFNStJQ=;
	b=OokWj30DRHKCLn42xdbLXaspzPcu7QARoaFRmWOQysQ4Slz3uQuspxnDMn5hbKkraKhL
	 g3GDJKk0F+qTtTuNE2fn4Pkf8ljYA4uUAcSUm3VK3KZpaVxU0GtR7uJ4P3sBZIPC2tqeu
	 1sKW91iolJ45kTWoq8jeF4mIbZk4XqlDNO3E23QqfhKZmICkoDH7XSmeYCQpWt6jWjhBn
	 pNJA/b5g3xIuThaqYYh9AcZVkOuPm8E1mqyGyQWzzNI6VHGwnmrlcs7BmjLhELNJRCl3h
	 kotDcWyGFFpR4+EfneLbglJ3x6ad/59LLntaI60q93z4Md9rYDJjzp0u/W6xpSm/72g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=Q7CG8iVe;
	arc=none smtp.remote-ip=67.231.153.30
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634A5606A33D;
	Thu, 19 Nov 2026 01:31:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 634A5606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=Q7CG8iVe
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AJ192L01041963;
	Wed, 18 Nov 2026 17:31:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=pNrcFkQV1C/8zLJHTThB2eiTETmGNutp7bQGW
	FNStJQ=; b=Q7CG8iVezvuNmYxpWeK1kHwSxzVupBwHD4p9/7Ub/NOJmsOU5nc2/
	rlx6XnrQ3RnmS28CYwuCAT/nZQS2eSzfLaLLJ9VGQS8/ZMI8rdRghVTQYPHVP31R
	ccyG0DCTr/tmCj7vt4XMA8QMZ+5RfzqciMj6OSdVnwlyBnEnq1g8ixTdEwsl6A07
	7uwlMMvTZrcmJUQu/OuEEBcbZH7wtIwWjrufutPfWWk+lTgvNkjVldFxM58sZ98p
	xPmt3IdWTyoL1zCSUdEop6efc3rpmLUvOPs0VKf/9UfYF1Y5b8F/KoFOp5hjfTeC
	NnzgNxIY2FpptupQEe+KNczyie8QrK5ow==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j0yu8k791-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 18 Nov 2026 17:31:29 -0800 (PST)
Received: from localhost (2620:10d:c085:208::7cb7) by mail.thefacebook.com
 (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Thu, 19 Nov
 2026 01:31:28 +0000
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
Subject: [PATCH net-next v2 10/12] selftests: tc-testing: run dependsOn probes outside the test namespace
Date: Wed, 18 Nov 2026 17:31:01 -0800
Message-ID: <20261119013103.1092559-11-toddfreed@meta.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE5MDAwNSBTYWx0ZWRfX9P0Rz4Cxf053
 Awq9xL7Ge239l5w9dozWVmSTx/o+0PTSa6n8bltXUo+sFiMQFWe9FvWDxFOonfMTY5Znq0arkEX
 3n7NdmR6bwJQIlgCBaHjYynTY+wq/aI=
X-Proofpoint-GUID: cHGZ10vn5774juy0JmjaG8VwY7VcIh1l
X-Authority-Analysis: v=2.4 cv=aLRlOr9m c=1 sm=1 tr=0 ts=6afe5171 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=JnKecZnUtZousrUlYMGU:22 a=VabnemYjAAAA:8 a=bVv6ZBUfH5OyOozUiAoA:9
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-ORIG-GUID: cHGZ10vn5774juy0JmjaG8VwY7VcIh1l
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE5MDAwNSBTYWx0ZWRfXxl960wczq5Cr
 xXag8IhBQpTS+n19e5ERCPqq/WEgjK4ldA1BLQemBHKNu/13NHZ5bwrI9BNn9NM2yLNdOzuBCbi
 37gZmU3yyaUnCp1urQJ4nWPvvV/maWsaDEGfWH/rJydER37N3KPYYX6hf+c8X6gLdcFsftFgZp1
 NPa9YqjscM+Y9XqTj9yg5tm02+XTKI+3r17Aq2pL+WASNXlWEo/kCAvYepJqhYgOcYIX3/4f0D8
 u9dJaeFaXz9Ucd9NoyHeHpAdzJc2RHeoFHp7Xr5MU4l//XUoobFiRbLBEdveX99wq7olj3uuZTo
 Wl+INHMYX2JOCKuXxNjKIJd+LIQMvWHfiiwPI5nUNj94pZ6g0UWQNcxei+7plVzthbwvucgQ10u
 jlz0HH0JjS1iSqox5rA/b0CNO3a2wbEVyucy3P1Sb53WazxcBwpeL0W0ksKl11elHTOcvUUWDKT
 RVaGl32Gn16pRZ61HVQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-19_01,2026-11-16_01,2025-10-01_01

A test's dependsOn probe runs as an execute stage command, but before
the test's namespace is created. nsPlugin prefixes the command with
"ip netns exec tcut", which makes it fail. Every test with a probe
that requires nsPlugin is therefore skipped currently, for example the
mirred blockid tests and the tunnel_key nofrag test.

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

