Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.145.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794356345;
	b=1AwvvM5DiKnfbkREjFENU2tS36Ru57dbYt3X6N+T97HPvUpMnTqyGmayKYnYuf1efJUm
	 PsSABCmZe0b6qYiuWMuMzRB50MlU3Sw5eBbxEl7UJBLAV8BOvpuPZCdyYSu+UfurKbCTU
	 qDHrcYsMCgrNlxJkqQYpFG2TeId2Q6zcyU9RsN25PlWcmLjsXXGOyovjR4Q/DFGi59LmQ
	 YruQqYvxtXC9vNZ3HcykO76nU3fCvhK6kYYg0u787uVcmS8/YSgso2hzvJcGAPybgnYNy
	 m2gagKhWFunzhqI2wkO9oeO802tZeNd3dSpGxLX2eFkMyQv7c23OIHqFY02ceAPbaRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794356345;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version;
	bh=Qf3gvKGL/Wt2G3I75f6VpEfIvMUhVj+jtpc7e96xAQk=;
	b=FBuId47+uo3ILQ1Y1YEu1Fl4tXPvYS3x9vvmfgBl/6O8DkJYBTlGOldn5Xnx7AkkaS/3
	 LyoGWrH3JX6c5IyRweUDs/twl1oAtbGjo2/08jowf2j0oOtBISQYTl/QgOsgTBtAgTLXH
	 MDupZuks+3OBgyHo8UvswNJ2AkcHlu/L6C0Mn0NUQGvCWz3+cf16Rvoy97lmzb6MVRQRv
	 Z6pd97gfuysf5Zjthd524oxXYaLPdPMfEfuPZ8IW4lFgKJkYk9Ry7dFkzM0hFmV9lef7C
	 se34TX9mP9lmxEEH2qKxx+yNKUP/T7mrSbVZwBhZHDU5tZFgIx+vpreTqyGvUKyM39Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=i9vNYOwG;
	arc=none smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5C360A2615;
	Wed, 11 Nov 2026 00:19:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6B5C360A2615
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=i9vNYOwG
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AAMKcx8602412;
	Tue, 10 Nov 2026 16:18:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=Qf3gvKGL/Wt2G3I75f6VpEfIvMUhVj+jtpc7e
	96xAQk=; b=i9vNYOwGMMrXVGpfAMzgAqxgmigujRDTBhpq3WfTqLxMy1axvaOCV
	Sn3x8FB3xZG5wRT6BP2Bd0ad/MO6JZs1klIC3NyfjIDK37dP5XvZmwhqC2H+KLvS
	XgmXuKjcAyFtGmZVgVf939GvVjwbhGh7+GnmaCfldQw6ggzNvjP9Bw5pd04utDP/
	Yd9QNZJVBzTXN5VpVWE9P71GG/i8H6rbv+3Hhq2Ttw5rbi8S4rju2bHPsadRtCCI
	N42bA7+lCuxZihR+JQWwvdWUPF1RwpTQGzO1ux+j8eBbP6U3tg2JnGoEm/pM68ke
	4ZzsS1g3gVSgGmftOQp8DevXZFwOCAvGw==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4hv75dujyr-8
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 10 Nov 2026 16:18:51 -0800 (PST)
Received: from localhost (2620:10d:c0a8:1b::2d) by mail.thefacebook.com
 (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Wed, 11 Nov
 2026 00:18:49 +0000
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
Subject: [PATCH net v5 5/8] ipv6: icmpv6: don't quote decrypted payload in icmpv6 errors
Date: Tue, 10 Nov 2026 16:18:28 -0800
Message-ID: <20261111001831.3710881-6-toddfreed@meta.com>
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
X-Authority-Analysis: v=2.4 cv=RthQvymK c=1 sm=1 tr=0 ts=6af3b46b cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=7x6HtfJdh03M6CCDgxCd:22 a=PAz_-FQ8hEVmOPYdF0yf:22 a=9R54UkLUAAAA:8
 a=VabnemYjAAAA:8 a=VwQbUJbxAAAA:8 a=SjbIXyxL3abUfL5CBMIA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=YTcpBFlVQWkNscrzJ_Dz:22 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDAwMCBTYWx0ZWRfX2Q6XzzKn8ytn
 UY4bClf05E+aCkyhndY44HuljpilAr3NeQ0BB6BDQGp1e1HVDHsGjotD1TfhMYPPRf1o1epKoBV
 GEIPOkZk2M3VP4xohxCAAMKZBDch6sa6jUln/9KSLcEvrbm1hC1fJG9llPLhGitWJ8wjoRXsjfr
 Fj8aJO5AE7RtzYm0YDLtjmbZ2oO0ppiMW5SnhduO5aonB0am4YjXmngd6GmyKNGOvq1omVakZN+
 H/AwHA87N6/BNlVeHd2CqgjeBOIlKbMC/foANoc2EvcVSWcForLmgJtSEJQNY5UVka0OM63EIw/
 g++gT0RPQgvAB9V+sag8xcQs8jWZdJogDtP9YFAtIDBDBRZrXeoreIHWJ8xYnMUkuhmIxyL9+9w
 AGFhBGjrAgzzCPVxoltPd/3gKa/tx8meQpP9dpS/YqqgnlrHUdOu8o8cA0fWdI9TDR1P2k1Cx/E
 RG80OiNab7yLVvqFLGw==
X-Proofpoint-ORIG-GUID: mI9y3GVU93lenaJkq1otk35TK9d6sUhc
X-Proofpoint-GUID: mI9y3GVU93lenaJkq1otk35TK9d6sUhc
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDAwMCBTYWx0ZWRfXzNYd1yS0v5Td
 wwRlOOns03cTFkRy/Al+Yo4qFwabQBgAoExbpTqGnUsSfY6iCyzWGa9vZXzZB4tp1rcz6AVeGNz
 7P4hHHNujZfnZD+MZ0PJu1DUVJUomNM=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-10_07,2026-11-06_01,2025-10-01_01

an icmpv6 error quotes as much of the invoking packet as fits in the
minimum ipv6 mtu. if the device had decrypted the packet (as indicated
by skb->decrypted) then the icmpv6 error is sending part of it back out
onto the network in cleartext.

as in the previous patch for icmp: ktls rx device offload and psp can't
be told apart reliably, and psp also encrypts the l4 header, so don't
send an error about a received decrypted skb at all. linux receivers
would drop an error whose quote stops before the l4 header anyway
(icmpv6_notify()).

on tx, skb->decrypted is also set. an error about a locally originated
skb (skb_iif is 0) is sent in full as before, if its route goes to a
local address (RTF_LOCAL), like RTCF_LOCAL in the previous patch.

an error about a received decrypted skb is dropped before the rate
limit, so that it doesn't use up the peer's and the global icmpv6
credit.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261023234640.1459291-1-toddfreed%40meta.com
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Suggested-by: Björn Töpel <bjorn@kernel.org>
Fixes: 784abe24c903 ("net: Add decrypted field to skb")
Signed-off-by: Todd Freed <toddfreed@meta.com>
---
 net/ipv6/icmp.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index d8203ebad882..949025d83e15 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -778,6 +778,13 @@ void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
 
 	np = inet6_sk(sk);
 
+	/* Don't send parts of a decrypted skb onto the network, see
+	 * __icmp_send(): no error about a received skb. Before the rate
+	 * limit, so that a suppressed error costs no credit.
+	 */
+	if (unlikely(skb_is_decrypted(skb) && skb->skb_iif))
+		goto out_unlock;
+
 	if (!icmpv6_xrlim_allow(sk, type, &fl6, apply_ratelimit))
 		goto out_unlock;
 
@@ -799,6 +806,15 @@ void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
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
2.53.0-Meta

