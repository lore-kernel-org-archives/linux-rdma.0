Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.153.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794358606;
	b=HsxkrgfI4U4AikXYuwu4lw0+4Ijilm3RKfPlSFsKmbznfs0wk1W2rMEVVvzZUyL6tFtt
	 jDI4FbETPMnZWc43aXQWkU0NVqFfFfXUlP53E23/5rKYzgQ/Vq3J17fYEw3S1W6qQQHQx
	 vpr54psdMqBe8bSUl87eTNhBotgz+VxN7ta8oCBM/vDHtEhJJSy8f0W3DvmZ/o1dWUxwA
	 UWY+A0JdhXPghRuMtveuTw9v3cZLkv23PB2Lc0BqifN7jznzCKXmQIAp2jlXtlbk/jNLH
	 2dQmqoIC1HIW/89L5FHOIFL99O54O4BYbeezhEkCGBYeYWyloCyR38ZHGESxGpBRNZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794358606;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version;
	bh=eZ1smrYvly6HKzEdZFaqtKQ7zbu04cnFcd6gPZfTV74=;
	b=hvPUa5KAER6PeR4YLD1BS5sej9ZAogjnGCkEaWbkWYMdsI0XLkjJLB67HrVYu7qJrRBN
	 G1wxpKHLyarIb0bNHjnpWhDbO1TRWqKcUf8/NuD2vKz+2IjcNsqj+089awm+lvfe+ehE+
	 LhSbTRQgnNmF/dkcBXEzrF05iVc+m7xHPujBpMnVzWIZ2fj8WUWvltIIrFyQEyX6YSGU+
	 vaXDNzAvbGuwJpoMBCi2q1BUs0fFE6qAWwG02yfaftR8cjUE1sSGptqZzlF6+yMG7jBX0
	 2zVfrTpRLRt9M+rs1TINb1961lX7TBGPDbqPS71IXV6z7PAiNxO6oYLrfHvu38dlrPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=jlVGgXa7;
	arc=none smtp.remote-ip=67.231.153.30
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08B260A5BE0;
	Wed, 11 Nov 2026 00:56:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B08B260A5BE0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=jlVGgXa7
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6AB0WLZ4556322;
	Tue, 10 Nov 2026 16:56:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=eZ1smrYvly6HKzEdZFaqtKQ7zbu04cnFcd6gP
	ZfTV74=; b=jlVGgXa78xffbwde8MAZS1zaAd0bUTyXh7blFPiDg95vHPHEjChPz
	kHKrs8TOAHwqkVAqktnutovd3U0Ifm5F/zLcZhfiAWJcFI+bpwd1wPBMZysxkELi
	kro7t7QcvdQyR4P474ot/PFXVyUUmfOWQJ579k5Os2sjACTHrIeZeoJgyEdVeowC
	zMSDpvqMr5GJZMJNj9G2LDyrLDZGZY5MV2KZkBG7qjnFthvC8MTOxo6fVwG6xMzd
	4HXdFIFuP8KCKK+3fGKXy0iB4JEsirbaPeWExT/qBQTNr+QHqHtkohoPkSBCm6FE
	IuFX31tOjNKr3+4fDbkZZ4jVjZhNskB9A==
Received: from mail.thefacebook.com ([163.114.134.16])
	by m0001303.ppops.net (PPS) with ESMTPS id 4hv72pkmxh-12
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 10 Nov 2026 16:56:17 -0800 (PST)
Received: from localhost (2620:10d:c085:108::150d) by mail.thefacebook.com
 (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Wed, 11 Nov
 2026 00:56:03 +0000
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
Subject: [PATCH net-next v1 03/15] psp: declare psp_assoc_set_tx() in psp.h
Date: Tue, 10 Nov 2026 16:55:21 -0800
Message-ID: <20261111005533.6436-4-toddfreed@meta.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDAwMyBTYWx0ZWRfX98u3etAH7J1G
 oSB24REvzXiTwpGWlUaahiC55+4gMaPnJkO5GVczNn2CFo92+BsLgDQ2nrf07+B6WUemmGDQl5H
 xtwRyLtLohVmWX/hydQSQhhw5wwQMWUVD5H+9oOw/9NfMuTf3Rou5O2pSNmUbJsNKN87YOA9hrg
 BTRLe5/Bsdd3UOY3UjHtvh16ndSCRbT/8IHLu9fHFCZGccDiVSayBAjDRVVpprzzFrN5gArafDP
 TvPfHVeF52QguSqzEnpiQXXG/I34ELioO4PtFljP5+JQ9soIkjh/pVOjI+xdjp0NZkXsD5P4L2P
 98Hp/rrRq9yiFnNMvxrMkeZpsE00mWTarZmUwqpGadcfbBtxdKjnXJo4f0WM+cK1sDarFnpMWbY
 0aoZwleKvYsECHrlKuEYS2cK/RmafdLxbJytqsNZea2uLwALDWciKTWPS34nM0zjUgNph2UqiU2
 8IV+mWhUieIgmSTmHMg==
X-Proofpoint-GUID: 4vuWb25DFuiBnUlJamJKm_6q2yAjDbUy
X-Authority-Analysis: v=2.4 cv=TtlzFzXh c=1 sm=1 tr=0 ts=6af3bd31 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=_78whYxrdx1mplLwxq1U:22 a=VabnemYjAAAA:8 a=Jom1O22K4AGhiC0wZ_8A:9
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-ORIG-GUID: 4vuWb25DFuiBnUlJamJKm_6q2yAjDbUy
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDAwMyBTYWx0ZWRfX1x4Z9qbw4yYw
 5Ov+zKwtowqOJdORSNSMb2M/Urc8bwd/T5+JD5sr3XWTc+qLhpJXaJjPMN2MB2tKon7940qvEU1
 6+076IpzNoPLUqjAowaJxfB7en1s92Q=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-10_07,2026-11-06_01,2025-10-01_01

socket-less psp associations will need to install a tx key the same way
sockets do.

make psp_assoc_set_tx() non-static, add a declaration within net/psp

Signed-off-by: Todd Freed <toddfreed@meta.com>
---
 net/psp/psp.h      |  3 +++
 net/psp/psp_sock.c | 15 ++++++++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/net/psp/psp.h b/net/psp/psp.h
index b123c2427905..de4be3320009 100644
--- a/net/psp/psp.h
+++ b/net/psp/psp.h
@@ -24,6 +24,9 @@ void psp_nl_notify_disassoc(struct psp_dev *psd, struct net *net);
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
index f2cba3fa3a23..d04146273bf2 100644
--- a/net/psp/psp_sock.c
+++ b/net/psp/psp_sock.c
@@ -185,9 +185,18 @@ int psp_sock_assoc_set_rx(struct sock *sk, struct psp_assoc *pas,
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
2.53.0-Meta

