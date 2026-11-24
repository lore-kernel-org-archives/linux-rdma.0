Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.145.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795482414;
	b=pEhqAC8KgNE9lZDPyXhy9+ryWl5Hz90D4b1KN/MNspBMmIxNWAlCQlLHoBE+GySXpHV8
	 YgmORocRnGRyj2LDwnTPhkVww5BGaxeIiXDdAgmC4cNAfnPhZVGynhFgo3XC3othli21l
	 UTZIUhVD0LMUGigtaINXD+fVhaqIqyyzY3IsZPvQ5/NOypoWxv+CSd8Rnl0xY3LQQ717x
	 ryA9VYv93NsP8ZZqrckYkG0IDCXpH/4TysBJuHf6zhVpSJwUbCyuPTuGFHsGbsyQo7YXM
	 bwJE4kjFbwRRIx8olwWci1qlTBcN9BGLoFz8usPO4fIZZvcR5Bk1PwHD1GpnsSS36Hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795482414;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version;
	bh=S8SOytfhv3bDOHQqYrJymyWLPGJnx0o/1uLG/eVfQ5A=;
	b=cwp8XU0QZdsGzVxL6JbpY1GyFDo9b3xQGNK/IecH0q4bJhTEpaTYmzyi4juEWtWEiCpo
	 +WOqquErJolTTHbfe65XE0LSwdCQtU6Typc47aqDSd3we4XZXTsYDsS5BomZVMugjT6C5
	 sf7EAnYctXRJS7gXeo/VdMVpQch+9P47TMLfefIXD9K6atLR6eCFfbMs0kk8qTEmKiapp
	 BhTY1Vl05tytmxM8RxYK/iILqR2OmWvz5Kzdeh+KGTzHe5dGvtoXtKjlf1fKQQz3/dKzb
	 TnHV3WsTFuRCAtjbKl247yAclOrRAVQpJG+nQRsgvFWyzT1nJ4dM81YpJXqBqpVixsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=THs2F5SL;
	arc=none smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECDC7606A332;
	Tue, 24 Nov 2026 01:06:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ECDC7606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=THs2F5SL
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ANJwZsK251234;
	Mon, 23 Nov 2026 17:06:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=S8SOytfhv3bDOHQqYrJymyWLPGJnx0o/1uLG/
	eVfQ5A=; b=THs2F5SLweRbpOrY7/q5g7+XGYmZKGViLLMdkw85X71V2TwlPNcug
	G4Q2rY7ngToFoALjBewcrvd8ZFUr68DPr0Uh+U/WNc13LJK4Pb3is9dLGxpQWmJH
	ztWpK+vdaYECjkbKC4aOOkWmTQAZhIT4HLPmO8eHG3GoMaC54QI8I1u62Z+QogpN
	kXMBWKOiovlxL4LQanQ+zD+5F2Qq6qvVDJqDvOfdppYEWGqJlZqDIYeGn2nmqaaY
	NdGirXB1/viQ+gwPpa6TTaT8soUD2PSD6/XCUmqNGbpsE60WDnMoQOHkyY6jXbCT
	XplWohPXk+S+JB5cjZmZdyQo7RDEf4I1g==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j39v3dtk3-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 23 Nov 2026 17:06:31 -0800 (PST)
Received: from localhost (2620:10d:c0a8:fe::f072) by mail.thefacebook.com
 (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Tue, 24 Nov
 2026 01:06:30 +0000
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
Subject: [PATCH net v7 2/9] psp: don't encapsulate ipv6 packets with extension headers
Date: Mon, 23 Nov 2026 17:05:54 -0800
Message-ID: <20261124010601.3995693-3-toddfreed@meta.com>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261124010601.3995693-1-toddfreed@meta.com>
References: <20261124010601.3995693-1-toddfreed@meta.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI0MDAwNCBTYWx0ZWRfXwqxsQfVKR550
 iH4OAihoYawcfIB1ihmgb5EFvVm8MLPPcKUot2pZzM3qjWh8krRm7rgmU/PMg2FbohuCjXZIFWU
 Ra1mlQbOx/wf2Q9pCUx3MMUMdEsAUXw=
X-Proofpoint-ORIG-GUID: j2VPB6KxE0bVGb33qRUekrm2hC0AIJ4f
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI0MDAwNCBTYWx0ZWRfX5QN9ohuHvFUf
 Z5c8mFyHK9HojE4Laidg1swHGHTSigf2Wx6FiW0qoTSbgk5DYX+OtIifJPm5D1ZVU2BF0SZO6mh
 GSy6CvK1QH3h5B0sFTyqg2mQqlevMs5qjBBmt7cArmUN+4/XCppxE3EOwTpu0TPTm0tW0891q6q
 lB6C9oPw5cOxkkyw0ddDoIWFKBKyT4KvucxmYM2fKx6AIVE/3+UVk7Gw51SZctpFdxdpeoXYRmg
 ckvxVX7xo7pgeBZUm7eOvO7BlWBAoMWTYbpo+D8BeUi3a+jLD7+k7I1MyhBi4Z6dZW0pUnrdk9s
 OHosooSQBKDZo3RMq8G/JfKRy2o5M4LgAcTKUcYLMHU418VhnepJgIr/1T8/X2zXZ4t1emtL2R9
 YBxS6Od2iqFQwZFJ1+l4cCYwF5xBK9j8rdAaUMR7ykowuGu1z4RBVds6+yePRTMi77+vK2aC5kW
 nI0yUhXMOuDjyy3n3Pg==
X-Proofpoint-GUID: j2VPB6KxE0bVGb33qRUekrm2hC0AIJ4f
X-Authority-Analysis: v=2.4 cv=a+mlZkSF c=1 sm=1 tr=0 ts=6b04e317 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=PAz_-FQ8hEVmOPYdF0yf:22 a=VwQbUJbxAAAA:8 a=VabnemYjAAAA:8
 a=IIHd1SC46VqhS9DrjhMA:9 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-23_05,2026-11-23_01,2025-10-01_01

psp_dev_encapsulate() inserts the UDP+PSP headers at the transport
header, rewrites the protocol of the fixed IP header to UDP, and writes
TCP as the PSP next header. So TCP must directly follow the fixed
header.

If the packet is an IPv6 packet with extension headers, UDP+PSP is
placed after them, but the next header indicating the L4 protocol is on
the last extension header in the chain, not in the fixed header.
Therefore this produces a malformed packet.

In addition to being malformed, with mlx5 this kind of packet goes out
unencrypted. Since the Tx association encodes intent to send encrypted
packets, drop such packets instead.

A PSP TCP socket emits such packets if certain socket options are set on
it (e.g. IPV6_DSTOPTS). Refusing the combination of such socket options
with a PSP association would be helpful but is not implemented here.
Since extension headers can also come from a route, the datapath check
is needed anyway.

The check also covers IPv4: the L4 protocol must be TCP, and the
transport header must follow the IP header and its options. Packets of
a PSP TCP socket always pass it.

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

