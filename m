Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.145.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794358601;
	b=mNebdypAcoWOTl96wjs8TSC5a2n2YlkoeIvxGS8Vm5HdnpX/w93iSiNBTn4WvcGNbLF1
	 5WjQIy1pyCHiiQ2+ddDxIQ3WPb8cdbgvn5RBQTMo/fqSx9+nPY8esqh1SO+derdlxdDMq
	 94npa14dlYO21tuZZJCKVOry3AVexrkEqb7rhBPs61PX4KdLZVy+zid8p/xlIWI45xVim
	 0deBCPzXdDn1nOUah4viRMtJNxreFyV0sDrOy6o0GgvQ11Ph+NP/2lnuylvccqHMnKEcm
	 EgJ4/IKXBpJuiWNfAv37g+RUCRWLnOAiEuplOG4ABKGQEv4AiRYfE8ypI7OvQ1Jo1iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794358601;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version;
	bh=rT22Rm/uIR28P3gbZMcL0k+koNnSZkau7OEvE8VzyP8=;
	b=dkOmdWIPFhuzh/BZUb8XAvpsD5dTpWhKrdzIps3JB3rPWypRQ+fONuntba0VmAoARLH8
	 T8r8nV1B0ElbmDsl46xOiXbfeRxeIjaQg/BkEWWmtOGHWDj/cFisGqJekaoMZpPHsA1g7
	 v7jlSrEzWXyAtZmtzJV3X1mToXjwPpWqyiDs8FlrCfcIzwblR7PafvrU1WzhcoXm9zysp
	 JXLGi6JbMSRUJfk2KmWYprD9RGx6VZAzr6DeMt4xqsSAakcJL2kMJC7a8IxWIJVLCRPPt
	 L5dVA5WHvKgG9ujsgL+USGlhNeEKkl+S61MN60yQ9YYjXHQl5qSKDnOyxlGu/PSGucA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=e9UvczYE;
	arc=none smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2235060A2608;
	Wed, 11 Nov 2026 00:56:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2235060A2608
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=e9UvczYE
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AB0WNhR3063874;
	Tue, 10 Nov 2026 16:56:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=rT22Rm/uIR28P3gbZMcL0k+koNnSZkau7OEvE
	8VzyP8=; b=e9UvczYEfAggeuxUzPNbRQZZ7oX+kw6en0pAcObFpnDS05uUfhSW6
	aXwZrTaSzQ2rKAx+hzD6hXk71zyQkxfIFhdHCTnjTrzFuWB0dlqgz4Bwd+jMc3rF
	dNQsaGh8/jPlAyOR/2Vv6z2BWLgBksisjhkKR3bs8ALqWCkEQt/pfwJK8bEhSeyD
	wLkxXiADHra28QvDZmSw82rA6w9m85mjpvJkME+b+ek5daDCHqWE1dJId4EtAN/1
	W+z2JC3M1k5Uis7rTdqYL70UQy6FLuKl4lcUBtef+1G/TgOJ3ILdID7JnbhrAYbz
	fz/cddEXc88IMSwRnj1672BIaiKwTGyVw==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4huqrpspky-13
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 10 Nov 2026 16:56:12 -0800 (PST)
Received: from localhost (2620:10d:c0a8:1b::8e35) by mail.thefacebook.com
 (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Wed, 11 Nov
 2026 00:56:06 +0000
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
Subject: [PATCH net-next v1 07/15] bpf: don't redirect decrypted skbs from egress to ingress
Date: Tue, 10 Nov 2026 16:55:25 -0800
Message-ID: <20261111005533.6436-8-toddfreed@meta.com>
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
X-Authority-Analysis: v=2.4 cv=PapqFShd c=1 sm=1 tr=0 ts=6af3bd2c cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=tpM8CJlwf7uhpglF1g9U:22 a=VabnemYjAAAA:8 a=RzO4eXly--hUAB-rYrEA:9
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-GUID: pG8C1eOj8Ed89JUAEJaU7b9fkMhKX3l7
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDAwMyBTYWx0ZWRfX8yrcexBDXfBf
 59Gfuq71IC2Eyq6Ibn3ge50lSJvfNuCBdmejZYYDctgTU7DUgHDK/fu3roWcqNZNM+1t7xenZqk
 5kqQziDEg3pn77qo8Zk3e2VR2tmKGKE=
X-Proofpoint-ORIG-GUID: pG8C1eOj8Ed89JUAEJaU7b9fkMhKX3l7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDAwMyBTYWx0ZWRfX9sqthL1PagRI
 aJZ3IJZ1wo9nj0aVXxma9+Q6aKYsgh/qpcfnrDMVz0OwvYlCBwWsNw8uSpYOOAa5noicqb2pBHT
 uP64gU2lH6wnn9QQ43yWxD2zmN0kxL1ypniEl8+r3kmenBW/3a6k4d6GqekbexNZDCMSvF3H3Cf
 7j9yZQ2OtUwir/jSdB8PehhWjHWOzmSWeVo/KCRqMw8DIxdil4KHyqqtPtuJGGL5rXbOPPYYOQn
 sbvgt2T4knIN79qFa6PpzFYZRpqqmW4/5479meqm57zgwzmbEFqqiFLpZf7md/KBgDYrqBYupr2
 nwGTJuHOng+1cWJAutnmc3JUF+7DKtk5OeVdk3gKTvrCY+1Hx9GuaHzFhmjBhuHS4JFlSkdDRhD
 xoZlFCkm7Oa5uFONScRHwcX4CDti54EBPOViEGHZBaK4QpRLpqGve2uHNq/vBgNdVTL1xiDwKIK
 HU0tRi0skkzCgSXHhFg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-10_07,2026-11-06_01,2025-10-01_01

on transmit, skb->decrypted means the device must encrypt the packet.
For example, a packet of a ktls or psp offload socket, or, with the tc
psp action added later in this series, one which psp encap attached a
tx association to.

on receive, skb->decrypted means the device decrypted the packet.

bpf_redirect() and bpf_clone_redirect() with BPF_F_INGRESS send the
packet to a device's receive path with the bit still set, where it
indicates the packet was decrypted by the device.

this is less of a problem with socket offloads, whose packets are by
definition generated locally; more of a problem with socket-less psp,
which can also apply to forwarded traffic.

in addition, the redirect drops the dst (skb_scrub_packet()), which for
socket-less psp carries the tx association.

drop decrypted skbs which bpf redirects from egress to ingress. this
matches the behavior of mirred, since the previous patch.

Signed-off-by: Todd Freed <toddfreed@meta.com>
---
 net/core/filter.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index aca8160b26a1..a178a9dd3007 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2226,6 +2226,15 @@ static int __bpf_redirect_common(struct sk_buff *skb, struct net_device *dev,
 static int __bpf_redirect(struct sk_buff *skb, struct net_device *dev,
 			  u32 flags)
 {
+	/* On transmit, decrypted asks the device to encrypt the packet. Sent
+	 * to ingress, the packet would read as decrypted by the device.
+	 */
+	if (unlikely((flags & BPF_F_INGRESS) && !skb_at_tc_ingress(skb) &&
+		     skb_is_decrypted(skb))) {
+		kfree_skb(skb);
+		return -EINVAL;
+	}
+
 	if (dev_is_mac_header_xmit(dev))
 		return __bpf_redirect_common(skb, dev, flags);
 	else
-- 
2.53.0-Meta

