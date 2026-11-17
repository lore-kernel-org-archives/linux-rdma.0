Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.153.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794947658;
	b=BypuLauodwSX201jeZnrOgJj/DJeEf2ZV1fxBiCPDfqhw+gaLl6/Hj3UHqwDDwqpkTNO
	 IaNYxIid2sdktNtOxTnEVrb7q/3D+/0X2cdcVSzSWPzphDOzeXz2NKlRYOODTEmkACioz
	 u/SEXPYe0WdWB39uT0XhWAhtUtMsGYzMt9xKmS9oZpVjc9Tq1cQlPA73/SpO5fu6YFT7r
	 wPgu9lCHc+Epn1xXO+rnZ5M3Hwe4DTYRc4k5S6kW+A5JQgs/ItzXFinL9cU8x5+/Cm16F
	 D+cXWX7CPCf2m9jWhMHvnN5NpLUZvfJodQP33lfasDRbZjoQe0eLSt2+xepqI8lXxKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794947658;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version;
	bh=GnaPEnTrZ6LnXFyTsP9dSJwfDLxwTyNeV/K9vh97/ME=;
	b=eckPosbtradWF8oAg3bv10ZrrWPRNPVXvALZIye4Evw3XVBe+q9u2y+NoOIm4lN8ul4K
	 RTC59Byh5sZB6C/oX35qzii6HNqdhyVDLuHdMUg90VoU/XICY6OL7EbB8QoQvgCbHQqX1
	 Q++mfzgzqginYuCHZnYqkvNpqoKohMBWZKbtG0RBzKhiJGS7uSTjQ9GLukL+8m7Ikb324
	 ut8Br1RHnGG2L6AjpiyIUJNqCIGlUeV2Xk9kPWX6aJCSvauWuVPlmSFzGUzMDSbF7gtpO
	 tXfJ7zi6ODbn0kdU+8OvFn5R0pTKU1AlIVhRGbbGTMZwhyqLU4fwlF5Xo1JVCT7uBjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=jecdw3zX;
	arc=none smtp.remote-ip=67.231.153.30
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2582A606A32F;
	Tue, 17 Nov 2026 20:34:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2582A606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=jecdw3zX
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6AHJ9ru73436107;
	Tue, 17 Nov 2026 12:34:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=GnaPEnTrZ6LnXFyTsP9dSJwfDLxwTyNeV/K9v
	h97/ME=; b=jecdw3zXV/TV1J0l019uOF8Vi8FYxNe1a9jTaJ5Ug4TcG6LZH9aEr
	YSsN5J88RyfQ9xwixiI3mkORxXH/coHg/obAPjHxJOA2hSgOChy85BCQ2WtkZAIJ
	ZIa5flrewXFBAk8EEbpXbFSCaqukPMpUV1yUR6Yf5qe7oYQI6c9ZDUb9+AaKtvq1
	GACF1EysROipbfYCqp3b6gDT7eEhYu5ksjgCaaalyN/TIGcLW6lOH9ZFBQyJIyFb
	M9fTWBJya1C0cijhBB+ccotTDtB8CqRZR6b7TiVcYt99E9/41Vm0sstjUWKYZp0H
	Cqau+YqOYQEyMOJ1Hl0bzzF+sCuxvTWEg==
Received: from mail.thefacebook.com ([163.114.134.16])
	by m0001303.ppops.net (PPS) with ESMTPS id 4j0pb2mypp-8
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 17 Nov 2026 12:34:02 -0800 (PST)
Received: from localhost (2620:10d:c085:208::f) by mail.thefacebook.com
 (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Tue, 17 Nov
 2026 20:31:44 +0000
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
Subject: [PATCH net v6 2/8] psp: don't encapsulate ipv6 packets with extension headers
Date: Tue, 17 Nov 2026 12:31:31 -0800
Message-ID: <20261117203137.804424-3-toddfreed@meta.com>
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
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: 4-g6YCJLAA5L_OXkxokpEipR0aaSsoXG
X-Proofpoint-ORIG-GUID: 4-g6YCJLAA5L_OXkxokpEipR0aaSsoXG
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE3MDA4MiBTYWx0ZWRfXzLEC42C8FwcJ
 /V4KU93EfMH9VfsqaDpDPgUzvOwQVC5xY059hLN+CTGmuJrDyN9ttLeOHMBdLNAAAgXuULDPQs5
 Qg7qJpAEn70+5KXbyEvBeY4ky11mQuU=
X-Authority-Analysis: v=2.4 cv=QfLzLcbv c=1 sm=1 tr=0 ts=6afcba3d cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=_78whYxrdx1mplLwxq1U:22 a=VwQbUJbxAAAA:8 a=VabnemYjAAAA:8
 a=buWBFQgmpo4aVRCz9EcA:9 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE3MDA4MiBTYWx0ZWRfX0GdWVee558mj
 ynikgt4J2XqsYLrewLEdgZfYlWsWIKOT4myXfqHLmpJGu/yU1VpmZ9EyOqbCRLIhztU3Z8micYm
 1Mgc1JCr3leeRdeOGaETUHyidSiTvgBGgt4jKV7ZrVCMzR08MUGP5CS1SPkQ6FRwDAZ5Yu3aQe7
 09G67w3iMTelpVNo+171/eeGXLazWNnX8Ia09daHgZpfEX6cJaLo3R86PMfkV796UImyfg+jl6J
 lNVVF0iGzqJsQ9XWHbenX1Nn27jQ80jHvK/RV0i9hObWFSVlI+Eve9uTZQR4WLYNB10RtG4bKNY
 Z2CV325n8U7HOLcXBNL1771A/2u1mcwluGs6BdCvP2Qz7Mzv0/NU+VMM/zImt6V6q1azRgn9h/i
 85uY4+cnB1laxlfhxz8tEH6zFwPxt4BqTOS37IVVo+TpXMS3/Bq0iyyfYBbt8sEa6AoDhaiq05U
 +lltZUUO3yWm3JnqmCQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-17_04,2026-11-16_01,2025-10-01_01

psp_dev_encapsulate() inserts the udp+psp headers at the transport
header, rewrites the protocol of the fixed ip header to udp, and writes
tcp as the psp next header. so tcp must directly follow the fixed
header.

if the packet is an ipv6 packet with extension headers, udp+psp is
placed after them, but the next header indicating the l4 protocol is on
the last extension header in the chain, not in the fixed header.
therefore this produces a malformed packet.

in addition to being malformed, with mlx5 this kind of packet goes out
unencrypted. since the tx association encodes intent to send encrypted
packets, drop such packets instead.

a psp tcp socket emits such packets if certain socket options are set on
it (e.g. IPV6_DSTOPTS). refusing the combination of such socket options
with psp association would be helpful but is not implemented here. since
extension headers can also come from a route the datapath check is
needed anyway.

the check also covers ipv4: the l4 protocol must be tcp, and the
transport header must follow the ip header and its options. packets of
a psp tcp socket always pass it.

Fixes: fc724515741a ("psp: provide encapsulation helper for drivers")
Cc: stable@vger.kernel.org
Signed-off-by: Todd Freed <toddfreed@meta.com>
---
 net/psp/psp_main.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/net/psp/psp_main.c b/net/psp/psp_main.c
index 273b010d2355..c071f507261b 100644
--- a/net/psp/psp_main.c
+++ b/net/psp/psp_main.c
@@ -245,6 +245,24 @@ static void psp_write_headers(struct net *net, struct sk_buff *skb, __be32 spi,
 	memset(&psph->iv, 0, sizeof(psph->iv));
 }
 
+/* UDP+PSP goes in at the transport header, the protocol of the fixed IP
+ * header becomes UDP, and TCP the PSP next header: TCP must directly follow
+ * the fixed header. It doesn't with IPv6 extension headers, whose last one
+ * holds the L4 protocol.
+ */
+static bool psp_dev_encap_ok(const struct sk_buff *skb)
+{
+	u32 network_len = skb_network_header_len(skb);
+
+	if (skb->protocol == htons(ETH_P_IP))
+		return ip_hdr(skb)->protocol == IPPROTO_TCP &&
+		       network_len == ip_hdrlen(skb);
+	if (skb->protocol == htons(ETH_P_IPV6))
+		return ipv6_hdr(skb)->nexthdr == IPPROTO_TCP &&
+		       network_len == sizeof(struct ipv6hdr);
+	return false;
+}
+
 /* Encapsulate a TCP packet with PSP by adding the UDP+PSP headers and filling
  * them in.
  */
@@ -255,8 +273,7 @@ bool psp_dev_encapsulate(struct net *net, struct sk_buff *skb, __be32 spi,
 	u32 ethr_len = skb_mac_header_len(skb);
 	u32 bufflen = ethr_len + network_len;
 
-	if (skb->protocol != htons(ETH_P_IP) &&
-	    skb->protocol != htons(ETH_P_IPV6))
+	if (!psp_dev_encap_ok(skb))
 		return false;
 
 	if (skb_cow_head(skb, PSP_ENCAP_HLEN))
-- 
2.53.1-Meta

