Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.153.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794358609;
	b=rQWtGbPpfk/aalk2mFBA9BFSG17ZTWh9rC9AARBefZppbFO4oobO7scNd/uGeHkP7pih
	 36xqamZ1exn64SJIxJhNc1J7gc8z1HJpSfdhoyl9dyDTZZqwPr4lC/UYn+ClBh1h/dkyd
	 ZyHHbVRsPAKsW8kvGXpGhgQvLrJqkDowBPrtbiq38kLopqTdLBt3XaSxsyQS2c1dx2DWT
	 raFkmf2ELE23f6wt2wmArDKdCK2JY+7mbPyQB9nppD+yDUOcarP+jsucRqq9M3cpmYQUl
	 WqP9MkYssMW5LrffNbXI17gNlWy5B9YP318vMGCs1duM1Ii2J1hPj8GS8Yel9SrL7bQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794358609;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version;
	bh=PzyQ/gASD//AABFo6VM26ZGMWjx8JRjORXdtw2haNAM=;
	b=dZI70xsfttxWlSkSWzgasTh3qvkztf6/EXOFKfeq54q8XjU5euw8egQ09yzO6AFczmu7
	 TV1puQDEZoQsvURms5TsWEvwPVCEa2wdNCLn2Mz5ip41vPNjfU4bC0Xgtjb8cnxEjqiEs
	 AEY9PyZwvsLjgbLFZYpW2HpBZx9oOzLXGa+i9TvFDw13Uk9iaLG6xKBEy+oYkfuVSCtbd
	 7S4pEAjP9lKFNDXM2z4MYuo1HFB0YReS8HX9CEfMXe6KISTx5Vw+/V/OS3vkGb2+l8cuU
	 7xNsvjjDGTGeSRmFLi5iLhNVeAjovW5ymRklPTLPDPqycPRJzO07iUIpVJe4Nel4few==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=V2J8AUbo;
	arc=none smtp.remote-ip=67.231.153.30
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63745606BA3B;
	Wed, 11 Nov 2026 00:56:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 63745606BA3B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=V2J8AUbo
Received: from pps.filterd (m0528004.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AB0WXqK2947202;
	Tue, 10 Nov 2026 16:56:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=PzyQ/gASD//AABFo6VM26ZGMWjx8JRjORXdtw
	2haNAM=; b=V2J8AUbohtJI7jIAusI8VHcvDZWX1dEWGSNLfs/voBXSbTWsHpqe1
	1zTkmCPu3NINfUbtvJm6fMy/S21CqqNEzs1Wuej4q3Se1NBB9hzsm03wFKfrNtip
	oOIhVVeQne1Ic/59CaDA7DOdHByZUhtFFzUinN2iZKihsSrwSG9a1ghH47eTmAlW
	o2Iv4qCLj1VgGazaaHoJzIzgyvO42lC5+huFy8Oo2BR1kjPwImIJIy0rA5ZZMMry
	XT0llxEb+JNk6y/gVABQMNBt61gP4N4+9jgg2+FKkYAnLIvTgvQiwmJoAStxoZcW
	xwDOZfBihuC5jrj4Bts351QQrlqkKcioQ==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4hvaej9r92-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 10 Nov 2026 16:56:15 -0800 (PST)
Received: from localhost (2620:10d:c085:108::4) by mail.thefacebook.com
 (2620:10d:c08b:78::c78f) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Wed, 11 Nov
 2026 00:56:07 +0000
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
Subject: [PATCH net-next v1 08/15] psp: only give time-wait sockets of psp connections a validator
Date: Tue, 10 Nov 2026 16:55:26 -0800
Message-ID: <20261111005533.6436-9-toddfreed@meta.com>
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
X-Authority-Analysis: v=2.4 cv=LZipeTfi c=1 sm=1 tr=0 ts=6af3bd2f cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=GbPsI2Ihf5RTnMjR_gZv:22 a=VabnemYjAAAA:8 a=gBco4JKoYuVYL6v11kUA:9
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-GUID: ANAX4kiDYt28gen5RMNKVK6nqspocjzz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDAwMyBTYWx0ZWRfX9NWFCI7oEtGf
 YqfTIls0ScjBtOn9mn/jIwvcMsBU5iufeT5o0iM9+/pS0furlJoO8IiaKxqlenbBTYoxOOziCrx
 aOzNoBd8vPY8AMRwZ5BtiR6fceoNaa2fREjIakp5ueyC0/gsHTNOBqWpWksLf/R/B/IZXB2dc70
 Vfwd2erFr2u4K0KquCXNT+eaYKXUGDymTCxqZv1ialZ31NXz4uJrZGbUgkUXr1FPL7Gvg7Gim0O
 /yMqvhSLGIuXg9vXl+oM7iuKo6r/QYrH6mciandSJYhPpmM+6XDoL4O6OM7te2wu91t0F+IoF3j
 pJ9eMtZQVrONK2KFoXVQh8eyT1HNwovfRV1WZEoqNH/6khg6bXsrP2e/FjggT0pnfpgMIvkI6yr
 BM4rCCgBFfNanzuy8+A5dnURitkIa2aA3XJTVgZkYiHIVHmd8fMBHiTumNT07/1j3yArp+OLMmQ
 0WXkpWZwVrLCrsshE2A==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDAwMyBTYWx0ZWRfX3gXXb9Ct81hr
 J8RFCmO46ff75165SNZ8NDKnMiLfV9vRrgi/idNiCIJ4u+uq8otVMDe02HIZ5LJLiKDX4fEMPP9
 4Itzf7Iegxzu9rLltFE0vsXXtefl1Yo=
X-Proofpoint-ORIG-GUID: ANAX4kiDYt28gen5RMNKVK6nqspocjzz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-10_07,2026-11-06_01,2025-10-01_01

psp_twsk_init() sets tw_validate_xmit_skb on tcp time-wait sockets.
today, that becomes set whether or not the socket has psp offload, which
is not needed but is harmless. psp_validate_xmit() passes such packets.

but a validator makes a socket look like it has an encryption offload of
its own, and the tc psp action, added in the next patch, relies on that:
encap refuses the packets of such a socket, and sk_validate_xmit_skb()
drops a packet with a psp association whose socket has a validator.

set the validator only when the socket has a psp association.

Signed-off-by: Todd Freed <toddfreed@meta.com>
---
 net/psp/psp_sock.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/psp/psp_sock.c b/net/psp/psp_sock.c
index 609b06c7af65..664955bfb4fd 100644
--- a/net/psp/psp_sock.c
+++ b/net/psp/psp_sock.c
@@ -330,10 +330,14 @@ void psp_twsk_init(struct inet_timewait_sock *tw, const struct sock *sk)
 {
 	struct psp_assoc *pas = psp_sk_assoc(sk);
 
-	if (pas)
+	if (pas) {
 		refcount_inc(&pas->refcnt);
+		/* Only for PSP connections: a validator makes the socket
+		 * look like it has an encryption offload of its own
+		 */
+		tw->tw_validate_xmit_skb = psp_validate_xmit;
+	}
 	rcu_assign_pointer(tw->psp_assoc, pas);
-	tw->tw_validate_xmit_skb = psp_validate_xmit;
 }
 
 void psp_twsk_assoc_free(struct inet_timewait_sock *tw)
-- 
2.53.0-Meta

