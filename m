Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.153.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795558755;
	b=EDurnQAM0HMjRlYLVf5YIUdRZw7uHE4vzMqCN9ajMGhMYpXOuvBvSDCg5BXyfxdHGy/u
	 4sMoyG/d8tsxqkNoObSmiBi9HsB03I3riJbt/ERd5jWcr4bZYnPJCTHkunVEevE18yJNt
	 oa7U64sRFhFYXGuKzukMtTxkYesz8OalHyLQ0tWpvRVHjSbgmtLTGiRfs9FDUYi0L4Nyt
	 XDGm4m0qHuMZD5uDOKHMWqv5zpwEBtYBmzH+9IeuaUDDXgo747tYBdz5cwNUKT174slBH
	 NujO60In1etihNdDza5QTjKhm85IykjjbMHjEwAGxaCBAvd6MFFavazQQl8DjoyWoGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795558755;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version;
	bh=YAHCZUgnfeBFCQI/0u4VqhkbcBqVIRCYZm3WLdGmi4U=;
	b=BIeW/paQ5XuMRyg46VU44IUzOk4TsMX1Cw/Rux10n3fQgMVpj5IIJMXj2FGA63NnebRX
	 BWvHcimitaU22Tt4JLs8AUX5nUIWVt/clHpjCaSjOgLTcXBA6Cljsp5seAEZrseNy0WYw
	 sRy/4a2r2PqT2e+BLdp6VPt7wyr1IUf5nj62VNtSMTVpqSb3LLmAxZd2nv+CcgpF9Ysrc
	 VbzTtszqJnoU7zzQf/WEMVl0KfSHQ1cWcnPATIBw+sQ8uG4WJ8uwIx+ZWDjMco4TjQaQO
	 bMGFYI0AJMiLg3f3+niUCu/JVgmeYAX/6Dm5NKrMRXOpwVWbb/1FPlBjtTwBONmaiWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b="Ho/MDujY";
	arc=none smtp.remote-ip=67.231.153.30
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D39606A686;
	Tue, 24 Nov 2026 22:19:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F1D39606A686
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=Ho/MDujY
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6AOMB9Dd3241123;
	Tue, 24 Nov 2026 14:18:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=YAHCZUgnfeBFCQI/0u4VqhkbcBqVIRCYZm3WL
	dGmi4U=; b=Ho/MDujYoS1lp51Cbdu2BCKbkt53586StkV+ZYFAuSmYcD4Eqznye
	A1XQwUJjGvcawJyoWGLTmnoS7X5WVbWbyGg3eobOb+oOxG47aX3joyIUavnopG5Y
	APgdg7v/rMd95IkaAZq7IGQPa5Exdzw3q9oRta5yePjcoAM+f6ot1a/5Zna/e1zf
	zG8PywGLV8Pn1BnlPWfiuEE0shzTMRmul9FCdjt5o6SuhGhHBdrmt7ZAMCNt8f5O
	S+g6iergiuMiIvJfPV0xff7VfHdVpWCCs80ZxO+U+KUMU2Q1tZUjAxiDkOWOcXHA
	aITORG307MDMSiIPpRLF/+gmYfNJ+sZ6g==
Received: from mail.thefacebook.com ([163.114.134.16])
	by m0001303.ppops.net (PPS) with ESMTPS id 4j5f3ga5wn-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 24 Nov 2026 14:18:16 -0800 (PST)
Received: from localhost (2620:10d:c085:108::150d) by mail.thefacebook.com
 (2620:10d:c08b:78::c78f) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Tue, 24 Nov
 2026 22:18:14 +0000
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
Subject: [PATCH net-next v3 03/12] psp: declare psp_assoc_set_tx() in psp.h
Date: Tue, 24 Nov 2026 14:17:49 -0800
Message-ID: <20261124221758.3230929-4-toddfreed@meta.com>
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
X-Proofpoint-ORIG-GUID: 2OOHgFCE_uR7gC2OjG6JS-3RxIeRoA3S
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI0MDA4NyBTYWx0ZWRfX+KEQppgU7KEy
 R/xWgN00rerULabL6NZN61ENApCyKfQ1iqRhpouhdbHTq7dbHJXAKXesnpGHzJfjklSg3HH7Puw
 FImUbrXrhtelre/snujoQk9M0tlC6GbIPAW8Yk6ftBgWI+uO8FlyFv4DLB3TgCefCZYRPIm9KNo
 448gGiWz/t5yfL07KeuCWuIKEC8F9X5BNd2eNTXWb68LXFNEK2jVCt+wIhaVX+rSbjPSVJgw8Yt
 qatVMl7eVEwg6YLd4jRWPh3VXdXbAuLW9BZSLLkR5EAzE3kK+IkK7cWK5sQv7xdmVdOXY7PFatm
 dcy8/nNwA4h2+KIIu/C8lYYeqgoxUaodQ6R4fL8cNQ5df/2qkKpYvGh3HT+HBIPi9brTa0A8tU3
 Wtl/auoz4gXaEOp1eGOqJFasm7L2rxb5NY12onEn7q3vgBdG+HZCWM60w0M5POKRROHqDbj/CRL
 MVdqBSaxLmg/x0KKGlw==
X-Proofpoint-GUID: 2OOHgFCE_uR7gC2OjG6JS-3RxIeRoA3S
X-Authority-Analysis: v=2.4 cv=VZNir1p9 c=1 sm=1 tr=0 ts=6b060d28 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=_78whYxrdx1mplLwxq1U:22 a=VabnemYjAAAA:8 a=FmbL48aYcJvIc3pBxYIA:9
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI0MDA4NyBTYWx0ZWRfX2od66cJqew2Q
 RrIe/D9BF0JyKhkcpW+vNL/7EiYGTuic9l9vkCElQ2i4CHyT73RTAJuFsJBNDuAFseVC9SoF4xk
 CAe1KJHFSGfK42Sf8XpLi5IzpOP7KCg=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-24_06,2026-11-23_01,2025-10-01_01

Socket-less PSP associations will need to install a Tx key the same way
sockets do.

Make psp_assoc_set_tx() non-static, and declare it in net/psp/psp.h.

Signed-off-by: Todd Freed <toddfreed@meta.com>
---
 net/psp/psp.h      |  3 +++
 net/psp/psp_sock.c | 15 ++++++++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/net/psp/psp.h b/net/psp/psp.h
index 0cfc82c6c711..687bedde5ea9 100644
--- a/net/psp/psp.h
+++ b/net/psp/psp.h
@@ -29,6 +29,9 @@ void psp_nl_notify_disassoc(struct psp_dev *psd, struct net *net);
 struct psp_assoc *psp_assoc_create(struct psp_dev *psd);
 struct psp_dev *psp_dev_get_for_sock(struct sock *sk);
 void psp_dev_tx_key_del(struct psp_dev *psd, struct psp_assoc *pas);
+int psp_assoc_set_tx(struct psp_dev *psd, struct psp_assoc *pas,
+		     struct psp_key_parsed *key,
+		     struct netlink_ext_ack *extack);
 int psp_sock_assoc_set_rx(struct sock *sk, struct psp_assoc *pas,
 			  struct psp_key_parsed *key,
 			  struct netlink_ext_ack *extack);
diff --git a/net/psp/psp_sock.c b/net/psp/psp_sock.c
index cba1b85336ff..89d97e5ff37c 100644
--- a/net/psp/psp_sock.c
+++ b/net/psp/psp_sock.c
@@ -231,9 +231,18 @@ int psp_sock_assoc_set_rx(struct sock *sk, struct psp_assoc *pas,
 	return err;
 }
 
-static int psp_assoc_set_tx(struct psp_dev *psd, struct psp_assoc *pas,
-			    struct psp_key_parsed *key,
-			    struct netlink_ext_ack *extack)
+/**
+ * psp_assoc_set_tx() - install a Tx key for an association
+ * @psd:	PSP device, must be locked
+ * @pas:	association, must belong to @psd and not have a Tx key yet
+ * @key:	Tx SPI and key
+ * @extack:	netlink extended ack
+ *
+ * Return: 0 on success, negative errno otherwise.
+ */
+int psp_assoc_set_tx(struct psp_dev *psd, struct psp_assoc *pas,
+		     struct psp_key_parsed *key,
+		     struct netlink_ext_ack *extack)
 {
 	int err;
 
-- 
2.53.1-Meta

