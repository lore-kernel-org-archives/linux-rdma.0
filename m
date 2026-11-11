Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.145.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794356353;
	b=0hqDAsfW13dGNhFbcyAUoCwsI3pJsGWQOHjPuuRbVhbsqRMnFDHpxIp/e4JdJV2OLxFj
	 7ftqCKF/kKy9YO2wrPeS9/3jny6vIAWvsHu947Y1lHgHHDjfVdK9XqeRLdFQBDMQJkjYk
	 I4wA1ATjSIsQ0EQ2NFk49w5p+lEUIYgKBnXD1YTog3a3iUuOi31MEH0Cvh/cpFiGO4RLe
	 mlBdoyTVWcMip3hYOxsfLVzcGFG1ZojUjnXjJg6KYvsYEOBQ3LshQAqQuOKJf6QkkSPei
	 iOTMCC73+jUlcwxDvGZCP6LNagjpIUtwsH0frHsa5PVLUQSPmAmJacsziKdBSa87Bbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794356353;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version;
	bh=ISqsUTGog03ABwLKZKBqbrbiqJpc93C6X/R8OcENsq0=;
	b=e345RcJdUs4RYAR8z+yO9a/e1oqDp3yZkRNQ8f3irVS8TpeQ3C1c+f3Nxsx5Kx5ltiKG
	 vq28J+ejBEKGDNBxROCtDBatcfeigXhWAZOqQkWuB6kIjkqSZpalQf7Z/zOkrl/VYbCF1
	 1fa53p8jjm4lTgyWrrJYQGqk5BBqeKCSS43OV8KJHqYXk9C8GGMqt3kWGlhCb8DBWRS05
	 SpNiawlcHc23oQNbAYeSDo0DK7V5DMSb9WCkg6+MEVkher7zYYQHn4vIAxl6BglBgU4zS
	 Ul4p2BwtQbtFNJTEvulrpgWWSmCdBMpeerxuVxAZBmPe956BlnPmSczV6K69x8TPK3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=c5PFRtFd;
	arc=none smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3705A606A339;
	Wed, 11 Nov 2026 00:19:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3705A606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=c5PFRtFd
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AAMK1C32810117;
	Tue, 10 Nov 2026 16:18:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=ISqsUTGog03ABwLKZKBqbrbiqJpc93C6X/R8O
	cENsq0=; b=c5PFRtFdVzPWaIIZU5Kqus7BKaUXMA2CjobGWgWIW6LYU7/aEBamm
	sebRXTp/PBol9TQur4gT77ETTw/wGJGlCLzPhrTm+3b9nsl6ieeiwJ+62Wp84MCQ
	lfV01WG9ffoMDUjLzrOsLLmbRTDLc9opN0vyXsoVGoeXEfaRtBUkcm9L1kFxKgVx
	ZdDU4qbTNB+SMw8fdXm/FVb3XnA9wMrNZpOxfx+2pkzPhdXiewjC9o/5vbGQi5NL
	XBIISMI6aR+KbjJkqCaSK5LV75uXhcmlTF1pA6BAp4MiDV+gbezWW3xNfAJ3jPdt
	xDMOO9PxjT6i53P2HfDnf6AStCA2MfNwA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4hv7vgk6bj-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 10 Nov 2026 16:18:59 -0800 (PST)
Received: from localhost (2620:10d:c0a8:1b::30) by mail.thefacebook.com
 (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Wed, 11 Nov
 2026 00:18:46 +0000
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
	<willemdebruijn.kernel@gmail.com>
Subject: [PATCH net v5 2/8] psp: don't encapsulate ipv6 packets with extension headers
Date: Tue, 10 Nov 2026 16:18:25 -0800
Message-ID: <20261111001831.3710881-3-toddfreed@meta.com>
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
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: _d7G2TRV-ugnt2JDh5a9c5mAtTPFsFnH
X-Proofpoint-ORIG-GUID: _d7G2TRV-ugnt2JDh5a9c5mAtTPFsFnH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDAwMCBTYWx0ZWRfX7NdSbmcFqOK2
 2xF3qyqUnt+maUGyllD85BEf/ueDLMEiFep1eSf1+hS0lc/LaRjC/GnVvB/aq177729ulfVqCjY
 HyaAtwY3zk0uxone/mbS+Jhd5u81Gh4PNM9P8fr5JTZLdINbe+n+ZOev1b23XimrCMorZyt3ZhU
 JOqJxuE3V1N6PKE8VXLurkE5DrLM0akmyCMGLxQcY5rXDvX8jMmpyA6Zpo503yFUqXG/j02Zj22
 sdkBpPlEB3Xnu5S4/QdaTvnMd9Nk66T7H4M76TCJJ49YBlHFL4jlB8Vqn7Q3GISBQpCfsImDhSA
 008hJKNEsCgJhQdqOK1HZgy0350jZeqG5SGP7603jztvtNno1JZZdm2R/6K650s6s0P3rY1RaLU
 qa+EkU7fi5b2DQ+Lc31ya6Fq9zVPb3RfyEORbWPQtYlsbU13nPIHazN9TB1xI09chqrpzZ5xPD5
 T5exPQLLtA0GRAPu39g==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDAwMCBTYWx0ZWRfX3WS9PGH10Wzq
 aZxndY7ve2S+F0OV8S+Tgn+l2jAnBB91M3VCNigWdTmbI0jcLfOXgLZOJN7z7wHi0BOL6MlOOzn
 /6/ZVBm+PmD6XKpoocsmy/fzlfnoqMY=
X-Authority-Analysis: v=2.4 cv=feA4WEQF c=1 sm=1 tr=0 ts=6af3b473 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=03ozwUkBphtHgyqjj1sw:22 a=VabnemYjAAAA:8 a=buWBFQgmpo4aVRCz9EcA:9
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-10_07,2026-11-06_01,2025-10-01_01

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
2.53.0-Meta

