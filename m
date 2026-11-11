Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.145.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794356343;
	b=xDYzRblvJw99d3FddUAjeoMKKczf9WNfG8tJyacWs6PZvsqoqaLNVjJsm4/P1oYh90F7
	 cRd+faZL9zNaTGCPaZieiVED+x8fVTCf/vSpRHoT/b83ObOY1R+NoI9Cl/sGLI26DXJ23
	 8mwOk6u7Oghra//o1o8lArXjVEY80y2keq1mC9esTPdnCAOBeDkz7+sex+7Uqzp2FS06o
	 CRl210jP22vZFUQDV1NNA4JAv4ZwJ7AvLOUyLvKi7vS4xflDTv4bN1UN0ZIOhsCiopKGA
	 zZSPIdNYjPXZJ265JUqtIc5Ceq6L49vr1dt52TqQzZFYAkS3h3C7QvF1GbSQk2mnWxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794356343;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version;
	bh=P+LfQGtV3bg0MkkcSVNybJ4aA0Mq3pz422ChNlBe6RA=;
	b=LyDrlo1W6/1ec6Ofk94InnLLRaqTESUeE9XGd5hrRgHdXUU+JCRpPoimWGKpafVMpxdH
	 qxRY8SyjRxmancvszE9XoiXbDWQcn63Ocr1PHdfz2kiIyEyDkBp83U/gi6C8BKQx2yMIw
	 PvdGNUCIB2LpHFHn8lg3xTHyz+NtBEB7KHlQHyyzT36PJtMTmBhnaamzFLk/mKJ8R5Kab
	 SPq58Qi/faQANYSnOayUraVAYDvRnSAaKN/LNBegsLiuBdfHQyy2wm96MWQhQyBLaIVQ3
	 zmlG4VQszBZtgB8YmYoqPdBbyOqPrcwzr5VV1m7F2PTSf+IpXnxOa/kulqUMzOXerrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=UQuVaFXD;
	arc=none smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C76C606A339;
	Wed, 11 Nov 2026 00:19:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3C76C606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=UQuVaFXD
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AAMKcx6602412;
	Tue, 10 Nov 2026 16:18:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=P+LfQGtV3bg0MkkcSVNybJ4aA0Mq3pz422ChN
	lBe6RA=; b=UQuVaFXD7V32XONHQ61VzIF5Jx4tgiDPRbAb86Va5k8TIwso6b8Sz
	0FrlaWvoF3L56XPm8AWF0gUC+oztFIm1bZx80iZpRKsAZJ4q4RIH6x/bmxbkvaR4
	2TkOHUhRKxZqEUZfabSmxSXRFii9uYUnDroewP5H29b4izbHz1Wiq3MGldMrrkte
	pcNYkFkk3dbf+E9MGkfUdPio3jUY6VuQ3nQtN3K8IQeB6gFwNJKSbgEUZn6KgH1Y
	Y/jLaCwJISV84cQ2rJ05P0XIeVRdcKkKL7f2gxznymaCN3pgGw49RYa7SVgU1+pa
	JmD75uQ74Z6DWswTRXPw1doOuHdcmis2w==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4hv75dujyr-6
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 10 Nov 2026 16:18:50 -0800 (PST)
Received: from localhost (2620:10d:c0a8:1b::8e35) by mail.thefacebook.com
 (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Wed, 11 Nov
 2026 00:18:48 +0000
From: Todd Freed <toddfreed@meta.com>
To: <netdev@vger.kernel.org>, <toddfreed@meta.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn
	<andrew+netdev@lunn.ch>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?=
	<bjorn@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>, Cosmin Ratiu
	<cratiu@nvidia.com>,
        Daniel Zahka <daniel.zahka@gmail.com>,
        David Ahern
	<dsahern@kernel.org>,
        Dragos Tatulea <dtatulea@nvidia.com>,
        Eric Dumazet
	<edumazet@kernel.org>, Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski
	<kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Leon Romanovsky
	<leon@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        Mark Bloch
	<mbloch@nvidia.com>, Paolo Abeni <pabeni@redhat.com>,
        Raed Salem
	<raeds@nvidia.com>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        "Sabrina
 Dubroca" <sd@queasysnail.net>,
        Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan
	<shuah@kernel.org>,
        Simon Horman <horms@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>,
        Wei Wang <weiwan@google.com>,
        Willem de Bruijn
	<willemdebruijn.kernel@gmail.com>,
        Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH net v5 4/8] ipv4: icmp: don't quote decrypted payload in icmp errors
Date: Tue, 10 Nov 2026 16:18:27 -0800
Message-ID: <20261111001831.3710881-5-toddfreed@meta.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261111001831.3710881-1-toddfreed@meta.com>
References: <20261111001831.3710881-1-toddfreed@meta.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=RthQvymK c=1 sm=1 tr=0 ts=6af3b46a cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=7x6HtfJdh03M6CCDgxCd:22 a=PAz_-FQ8hEVmOPYdF0yf:22 a=9R54UkLUAAAA:8
 a=VabnemYjAAAA:8 a=VwQbUJbxAAAA:8 a=m6_e1FgjUZzRcuQcUo8A:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=YTcpBFlVQWkNscrzJ_Dz:22 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDAwMCBTYWx0ZWRfX57UsCSFR8sNe
 M67tDxFBawgxJUX2oXKKoYqHgMV4H01BU31g/EyyeeeVbb07MQ5g61B0dc9QZO53clgZFJdAG9h
 QGUHDCptiHyTz5utYMrOvOoKzrZRBGNOZmZZtoTqRWMCaSzYg5cKVQshJhXXA0/9cWsLIhBTCM6
 TR9zkfDrvY5wL0BFD/AYu8ZBTqsFlOVQihxi5fHjoqCQqMIHx7ml3v82O1u0Dv4B2UwJKPhjdgN
 IvkjXF5iOsgND3CH/uDTJ7EyHhM9H1f4r/qe5c3s8rlVYbLF28N3v4Ub+ajhUgvldhZxRqDuGQa
 hI+pdQ2zM2Btw+1sHnXu5JT2k/AV3Fknko45KeXarq3qFxiQB79PWc8WSmiTcuv0F6ajjnhWggq
 NIMQNkCQ/lrG7o+xFGKRvFcZt+lcYvnJi3mTTuPbrU03a1HMqrR2z9VV7a5Jw4dQWw6vPxXwcRP
 r/VxvGqzkZKo+ws9Q8w==
X-Proofpoint-ORIG-GUID: 3G-dvBevH1BA9rhKplwaM1CAR5TR4BOF
X-Proofpoint-GUID: 3G-dvBevH1BA9rhKplwaM1CAR5TR4BOF
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDAwMCBTYWx0ZWRfX5BdXlvmnyuke
 ijC9Mf/y9XDnah0WuHFXk4/6dPEeQNJf7OnocWKOp/vtWwG9Zg26xoeXgf3oiappm15qdXg+6Cl
 t+ponxO2daPOqkP+/XsBR3mQMBZPN4M=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-10_07,2026-11-06_01,2025-10-01_01

an icmp error quotes as much of the invoking packet as fits in 576
bytes. if the device had decrypted the packet (as indicated by
skb->decrypted) then the icmp error is sending part of it back out onto
the network in cleartext.

the two offloads encrypt different parts of the packet:

- ktls encrypts the tcp payload. the tcp header is in the clear on the
  wire, so a quote of the ip header and the tcp header, without the
  payload, would be fine.

- psp encryption also covers the tcp header. the quote could include
  just the ip header, but then that's not really useful. linux receivers
  want to look at the l4 layer on the quoted packet to look up the
  related flow, so such a truncated icmp error packet is just dropped
  (icmp_socket_deliver()).

the two offloads can't be told apart reliably. a decrypted psp skb has
SKB_EXT_PSP, but some paths drop it and keep skb->decrypted
(skb_scrub_packet(), e.g. on bpf redirects and tunnel decap). so don't
send an error about a received decrypted skb at all.

on tx, skb->decrypted is also set. an error about a locally originated
skb (skb_iif is 0) is sent in full as before, if it is routed to a local
address (RTCF_LOCAL on the route to the packet's source address).

a reject rule (iptables REJECT, nft reject) sends its icmp error with
icmp_send(), through nf_send_unreach(). so now, a received packet which
the device decrypted, and which hits a reject rule in the INPUT or
FORWARD chain, is now dropped without a reply, like a drop rule.

packets which weren't decrypted are rejected as before, and so are
locally originated ones in the OUTPUT chain, if the error goes to a
local address as above.

the next patch does the same for icmpv6.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261023234640.1459291-1-toddfreed%40meta.com
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Suggested-by: Björn Töpel <bjorn@kernel.org>
Fixes: 784abe24c903 ("net: Add decrypted field to skb")
Signed-off-by: Todd Freed <toddfreed@meta.com>
---
 net/ipv4/icmp.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 90c0e22c29be..e11008aa4cec 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -979,6 +979,18 @@ void __icmp_send(struct sk_buff *skb_in, int type, int code, __be32 info,
 	if (rt->rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))
 		goto ende;
 
+	/* Don't send parts of a decrypted skb onto the network. A received skb
+	 * was decrypted by the device, and the transport header may have been
+	 * encrypted. The different offloads can't be distinguished in all cases
+	 * so simply don't send the error.
+	 *
+	 * A locally originated skb to be encrypted may be quoted if its source
+	 * address (target of the error) is local.
+	 */
+	if (unlikely(skb_is_decrypted(skb_in)) &&
+	    (skb_in->skb_iif || !(rt->rt_flags & RTCF_LOCAL)))
+		goto ende;
+
 	/* peer icmp_ratelimit */
 	if (!icmpv4_xrlim_allow(net, rt, &fl4, type, code, apply_ratelimit))
 		goto ende;
-- 
2.53.0-Meta

