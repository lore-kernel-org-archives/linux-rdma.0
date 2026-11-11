Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.145.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794358606;
	b=1rut8B1e4EFzE8vD/XHqn5u0VkgNhZsmfTCKVsIqE4fpnCKIfkTBUlNf6t6v5qlhHGKe
	 Mc3RaD9b+glSp/5Qit469qARMf7HFLR1IVZ2TBHyDk2rLqItOIlplTOkFdZgHsgL3Ox90
	 mSOwk0g8BChhuNG+wVDT9j4frOzkZXO7dDBHKSGUmYNNeaF5lg8Dh8Oh3PK8NqNM9ibEK
	 R+NYQa5v647CnKL8K9KuLYHNFI8HRHsrI3431bRtWsLuXmloJcnW6B6a06LRUYIQpahGO
	 bSgODUK06NL9CbgkH0gN6tw+xXxieB4Bq0xmthyRENOBhDxJm1dBDUHI25pSjB+9eSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794358606;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version;
	bh=/kGCPAH0Y8E1zwplZNXg7H39df1qd8xyG7qkeKFNx8k=;
	b=Tr4tQAfT51SH7xWTPr22fhsKgmbtiuIk9rki/SZ9JobNwDt8/S15EGVSy3au+tt7UxrV
	 CnirB6aWcHd5vPl5+5DhfGy8z/fWygP+4N9LmMYzEaA4gmnieCwpOBOTdRiuxVvF285++
	 KtxpIF8k5aZYQA1SgMl11uCV5SCKuYtIqOiefAyA4Z/9zrW9wXdinv+3zVpa5rVqPUOkx
	 paAbPnFoZH0DGQ4ICJdiQ0gRskrTdYr0tsf7LxYSRblbaznudcH2ggLWEQueqKz296Heq
	 SOFTQAL0TJ8SfGB3ZfNxucptLqPmGFQ56zin1mu1MPu1eMseonhSR3lNLYcQeCVDNnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=WX16WetU;
	arc=none smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F17FF60A5BE2;
	Wed, 11 Nov 2026 00:56:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F17FF60A5BE2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=WX16WetU
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AB0WPiZ3063914;
	Tue, 10 Nov 2026 16:56:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=/kGCPAH0Y8E1zwplZNXg7H39df1qd8xyG7qke
	KFNx8k=; b=WX16WetUR8nsegicMSHo9r2t9EPpk97QXS4aEQR3RskaDWTgNwuVg
	4WiQSoUMj2pFsB9dFx8OxthsmVA1KZ39ND+mtbMJVlou/qXK2b6GCSYFS//DY35h
	ZHriAvyk16D4cwGx0Awl/9eVhpTRUF+HS32NinqW1idP0y22mSWIq+f8LaPnUlpi
	Sw8Js56Yz1qLAkP1YVcJArRsixAskIHW1Ju5RBXBCBGPkPR31EyU7X1eJNrUPIci
	Rq5vv287fV4i16QOU+Yf0JWJibATl/Zp0fHfvs82cE/iKZ4b1n7qAUMJMbWz6HE7
	15Zd0ESqSE1OWhmKIHqRahtdRT/IJMLCA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4huqrpspmq-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 10 Nov 2026 16:56:14 -0800 (PST)
Received: from localhost (2620:10d:c0a8:1b::8e35) by mail.thefacebook.com
 (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Wed, 11 Nov
 2026 00:56:12 +0000
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
Subject: [PATCH net-next v1 13/15] selftests: tc-testing: run dependsOn probes outside the test namespace
Date: Tue, 10 Nov 2026 16:55:31 -0800
Message-ID: <20261111005533.6436-14-toddfreed@meta.com>
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
X-Authority-Analysis: v=2.4 cv=PapqFShd c=1 sm=1 tr=0 ts=6af3bd2e cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=tpM8CJlwf7uhpglF1g9U:22 a=VabnemYjAAAA:8 a=tt7R1iA7DJdqzKcfZHEA:9
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-GUID: 14CdkBhfSG7trnEVOsvdvtzVxN2ArQIh
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDAwMyBTYWx0ZWRfX3vUQ2GKoyd/3
 kZdJlg6Z5dxu0/hKKVT6173/J4WKAGd6w2f9+ayN12KyB/kBGgZVXBoBa0dPDitpieh4GeiI8Ez
 Mf2affEAnPO34BYYxJMyYLBkswsKySU=
X-Proofpoint-ORIG-GUID: 14CdkBhfSG7trnEVOsvdvtzVxN2ArQIh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDAwMyBTYWx0ZWRfX+grlAGNNNEUH
 03Ne0P5w6J7qbdIQPwQyIKj9vFF+mN3Cj8gXkqPse3sf4FxECk9aEQsO1NIkxjhvFh4pAs2T0M+
 bl3bbhVftLJxhXZgGOhTk7HQU5eT0Z3S5+1jNbVV4oVZDq37cXldWdDSBmyLnEtdajMN18SUucm
 4lDyGDe5hoLj21XnlX+QfX0yUD0KlfuotuljNtR//3e/ROCHn1bILtJv7gr4hSePeO2UHdOvwv3
 lTaG3P/OY3JMl95V9nCxdDxiQZvfwzdHNGLW2UwVQBP4mJ3AufmxcFt6JXpKW2ccdUhMhCUFgVi
 NWMqICgnQW2Xkt50rfo5j8rtwgQ7NCDLq0Otf7QPqm1iwFFEzQrmruy0EP/icWfZznashkLzc7V
 kaDGBcC11WpkVwIy92PHCV8jRB47lH6nxxSnoXghwYZVOgAxIqZu+yRlnd3GSVN3M8gZ437Jyiz
 txZUypuuE6oZmmwZTiw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-10_07,2026-11-06_01,2025-10-01_01

a test's dependsOn probe runs as an execute stage command, but is run
before the test's namespace is created. nsPlugin prefixes the command
with "ip netns exec tcut", which causes the command to fail. this makes
every test with a probe that requires nsPlugin skipped currently. for
example the mirred blockid tests and the tunnel_key nofrag test.

probes are meant to check what tc and the kernel supports, not anything
in the test's namespace. run them as their own stage ("probe"), which
makes them run in the base namespace.

Signed-off-by: Todd Freed <toddfreed@meta.com>
---
 tools/testing/selftests/tc-testing/tdc.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
2.53.0-Meta

