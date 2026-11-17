Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.145.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794947599;
	b=3+f/VdGvdFARYwU1C2UleL/4RNrrnKQGBEjcw2FbZF+8XIdCRjHpgzhf4WXYLIih24UL
	 mFWrUv7yj44xzMmOdohW+CL3bRt/ac7LZU7O/HwMSa1h25pTt2HWLrm8uI5kUPcZfq1h5
	 jl2q4ww6ecQRhFm+lRsbm703A7ie77nrOPkkNn8ESpkrKHOXAh4fsR6EebJq1a3FbpCM5
	 f30oyJLBkX06I77h5GGCgwXlsvKFc7h2ONlVkii+3fvJovTUuS6gW//Jd1gaSNHfUNCUh
	 Q/W0wDViC1o+fMZdql4q17CjP4WaUEc2b6E2ML4u6GxqeJnpYECN5+V9QNg8OgqRfIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794947599;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version;
	bh=5/78jDEUgtr81fL9BtH+p2q+cwemGAA7sbcTsXFVgLU=;
	b=MYBq74qcqHc/8sIf0Jp7jBaj77ddPAu04mOVypQFC5oFH8cvPEDrrxQn5tSlQp8kdThQ
	 9u9KogwUmeftkPUcsd4hbx9SYm2ZjmPCo74XQ6nKjBGuUIW4aoUHZYZxHROF0vp//b75H
	 qLbt9OIjdofpsyfHYkByNrCOgdDDjVUxx+bk9Fu8Ft3YG9wt3QpZwVRKkc2z/lADugoFl
	 2GlrPrhKACpbp8PCk4bnf3Fc8GdOA1kNMbqsMQzSdLX9iGjuaMHM3Z3G7x4gEjyhlAO1v
	 BUWmzs3FSBypp3ncGodzTyqRswkkDw1xP4idKbgoU3toG0mkmMuPObhfi6mX0+2bACA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=cAsLQ0Lc;
	arc=none smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306C8606A32C;
	Tue, 17 Nov 2026 20:33:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 306C8606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=cAsLQ0Lc
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AHJ9ZgD3681297;
	Tue, 17 Nov 2026 12:33:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=5/78jDEUgtr81fL9BtH+p2q+cwemGAA7sbcTs
	XFVgLU=; b=cAsLQ0LcsBxky+CYeX/jo/ueggCopJZrkdilTsaDUEHK85l38Pxqt
	XCvxHvrofOqrMmpxDDDQssTKUm2PKSNfM1hYpUzgmpKwm3XANp4tLDXpXQFjnjta
	caZyavjLPykFYf/PM6g8+W9DGNBDXsFi76p1J4Xg2Id8fosLvBqKFGsVhiyW+o1J
	dopQoHlzeDLn/5cVGHTG24st4kb3ESsio0Fo1p4X8cowG+HgjJKiXZR1xouS3c9d
	WqLqUOItJfd48AmJlbnCQMcswC6Zq+NP4DgiLSJ3P1VCD9J0iS51ZMbWR0apHDBU
	5ddc+SITXC1BE3aIylE+RQl6ivgoWQl6A==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j0t1jbcmb-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 17 Nov 2026 12:33:03 -0800 (PST)
Received: from localhost (2620:10d:c0a8:1b::2d) by mail.thefacebook.com
 (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Tue, 17 Nov
 2026 20:31:47 +0000
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
        Sabrina
 Dubroca <sd@queasysnail.net>,
        Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan
	<shuah@kernel.org>,
        Simon Horman <horms@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>,
        Wei Wang <weiwan@google.com>,
        Willem de Bruijn
	<willemdebruijn.kernel@gmail.com>,
        <stable@vger.kernel.org>
Subject: [PATCH net v6 5/8] ipv6: icmpv6: don't quote decrypted payload in icmpv6 errors
Date: Tue, 17 Nov 2026 12:31:34 -0800
Message-ID: <20261117203137.804424-6-toddfreed@meta.com>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261117203137.804424-1-toddfreed@meta.com>
References: <20261117203137.804424-1-toddfreed@meta.com>
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
X-Authority-Analysis: v=2.4 cv=RsBQvymK c=1 sm=1 tr=0 ts=6afcba01 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=7x6HtfJdh03M6CCDgxCd:22 a=PAz_-FQ8hEVmOPYdF0yf:22 a=9R54UkLUAAAA:8
 a=VabnemYjAAAA:8 a=VwQbUJbxAAAA:8 a=wXpcRx1wJzam9gbBQjAA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=YTcpBFlVQWkNscrzJ_Dz:22 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE3MDA4MSBTYWx0ZWRfXwWp7zDZK8Ed6
 R/HrsSBWWUIy8O1aCbwSY1nX7IIHTkMTDsj4nIzs0DQlnM0VlsrrSK+Xg6NIU3iKr3Jgglx/Fgw
 U4OmFgzuScpyZ1Zb043Fgpqpuuql6Zg=
X-Proofpoint-ORIG-GUID: ox1tqVSAe5tHXZUdzalDiOEJpwvZGy_t
X-Proofpoint-GUID: ox1tqVSAe5tHXZUdzalDiOEJpwvZGy_t
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE3MDA4MSBTYWx0ZWRfX38vd/p1qN2sI
 MwP0fPuJsU3HEMV7FWUST7nxMiBquQxf8sHaNeto1329VJfMcn8ZCeKikAjHVj8qvjM2QorBCpC
 Y4MI+MuvINMKbQG0bE2c7BijZ0OrOM98Q+KQ+L70LbZ6Ww9LnxPIhbk6OnSgZPDLwG3qCcQFtHX
 Q0wabfoXlbr5Gt6p/E/C7/2PZyeMYb/7YNm08rKdrJRH4PYVg9Me8ZJ9mAibU8Vg3d6dq9JO1HJ
 TECsW1pBgsMrQN7NzSHyGr5bO2wzFpkkIxr6gPKgNQ1JgnHMAt1usmOJLJJNcfcuwR0dWso0qK/
 ENvjPqoRAJaRwxKobGBcCzKL2NBkka1ehVf4Swv2xhevv7ikKPMHa/C9u48CqvEgRGaicnzhtop
 UG8rbsFiPOZ0O+yb6O9NyM1wVXhi20CvCzwGk78d2ZPPFI+maLv8MwLIAdWvbDt1M0uRgeI9YlB
 Sjx92QiECsmdnHvaPBQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-17_04,2026-11-16_01,2025-10-01_01

an icmpv6 error quotes as much of the invoking packet as fits in the
minimum ipv6 mtu. if the device had decrypted the packet (as indicated
by skb->decrypted) then the icmpv6 error is sending part of it back out
onto the network in cleartext.

as in the previous patch for icmp, don't send an error about a received
decrypted skb at all: psp also encrypts the l4 header, and telling it
apart from ktls rx device offload would rely on SKB_EXT_PSP not being
lost on the way. linux receivers would drop an error whose quote stops
before the l4 header anyway (icmpv6_notify()). this covers ip6tables
REJECT and nft reject in the ip6 and inet families; the netdev and
bridge families are left to the nf-next patch, as for icmp.

on tx, skb->decrypted is also set. an error about a locally originated
skb (skb_iif is 0) is sent in full as before, if its route goes to a
local address (RTF_LOCAL), like RTCF_LOCAL in the previous patch.

an error about a received decrypted skb is dropped before the rate
limit, so that it doesn't use up the peer's and the global icmpv6
credit. the check of a locally originated skb needs the route of the
error, which is looked up after the rate limit.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261023234640.1459291-1-toddfreed%40meta.com
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Suggested-by: Björn Töpel <bjorn@kernel.org>
Fixes: 784abe24c903 ("net: Add decrypted field to skb")
Cc: stable@vger.kernel.org
Signed-off-by: Todd Freed <toddfreed@meta.com>
---
 net/ipv6/icmp.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index d8203ebad882..574a42d279e0 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -778,6 +778,15 @@ void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
 
 	np = inet6_sk(sk);
 
+	/* Don't send parts of a decrypted skb onto the network, see
+	 * __icmp_send(): no error about a received skb. Before the rate
+	 * limit, so that such an error costs no credit. The check of a
+	 * locally originated skb below needs the route of the error, which
+	 * is looked up after the rate limit.
+	 */
+	if (unlikely(skb_is_decrypted(skb) && skb->skb_iif))
+		goto out_unlock;
+
 	if (!icmpv6_xrlim_allow(sk, type, &fl6, apply_ratelimit))
 		goto out_unlock;
 
@@ -799,6 +808,15 @@ void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
 	if (IS_ERR(dst))
 		goto out_unlock;
 
+	/* An error about a locally originated decrypted skb is sent only if
+	 * it is routed to a local address.
+	 */
+	if (unlikely(skb_is_decrypted(skb)) &&
+	    !(dst_rt6_info(dst)->rt6i_flags & RTF_LOCAL)) {
+		dst_release(dst);
+		goto out_unlock;
+	}
+
 	ipc6.hlimit = ip6_sk_dst_hoplimit(np, &fl6, dst);
 
 	msg.skb = skb;
-- 
2.53.1-Meta

