Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.153.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794358606;
	b=RKhD/y+wfSlc7JkjV2nonKERS0TiA/BUSH89A/7YtAEk8yTn8zdimD/h/JlAH15Tb6Xu
	 HE828JQd0X6HoeNhrQnLkXRQmuryt5kMNmrlXOjzCpLnen7op+xFE4gs4BJi+ZF0mEFjX
	 RThqr1AwBN98FsG+mn6IRzwJumoOc09sJnbfHVcB9uaXI9rWK1qeHb7+mk3qHNNCHFHEq
	 N1f6zJHoFCgFYODc4k/zcYKb8+nTuNlmHuLjtIsFRgLJDpBHB8l6FdOzn0KfxkcjF9ro5
	 ycwXRR/NINjqJcvJk+GclqIQYAEyDDic7krj4tM8qYrs/dC3Ne2cwMOwEjVM8BF6MLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794358606;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version;
	bh=6YoJj1jqI/xItPxpzPPJoCPNrLRceZsBTadFtJIfps0=;
	b=nzedz2zN3QlmG4GTq6zW1mTqHrGzwwkxEshTHnDc88Fy1S6VaqW3yLQTAItV0YIh/X6v
	 NKL4unNLkAASj7mQoR/StP1NK5rgqmeXDOHfYHwKF2J2CClryDemZkHTWk8yx/FENWze3
	 Ie3lkpZyEs9qj+FulmJNVwGkjiGz9Jvc6Vfi8HacMdBClLUno9po/JhFnSEDHfuO5BFQb
	 yYkk6SAc9LGEplci+IQQhVWV4LOPMFcgPxnxEIM+AxC+6LXQVoUSEIzsRzt+hXBisJDWH
	 D4YDUv/Mzcaj40my7M5DL609kXJePdKdo8R50XvaF7GX98aP6WYjx+siZ/DuFMJZeLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=mq+xKE8J;
	arc=none smtp.remote-ip=67.231.153.30
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70FD760A5BDC;
	Wed, 11 Nov 2026 00:56:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 70FD760A5BDC
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=mq+xKE8J
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6AB0WLZ2556322;
	Tue, 10 Nov 2026 16:56:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=6YoJj1jqI/xItPxpzPPJoCPNrLRceZsBTadFt
	JIfps0=; b=mq+xKE8JcY7RVAQrUjsGQfLSpGNMEyvfRRlmbNMT+WvXnIZFFWDBO
	wM1NVFQOO8EqebO37sZcd3g2Un99lMPf+jjW6mAd4ib3CJx2E8xBPOVdmIJDIGKR
	XU3TSHgpAq2CiHwvklTvII2DhBTAkBW8QbC5cx/53wkRwkSYXyw/x3kqEiAoQFJ4
	5k7aIPXP+Ur/bqsITaHApT2aCXyStce9eK3/ui2XE67x0waheLM8HgPXWWOQ9Fz5
	h5Li9LR61Iiy0KbCZessOn+kyQC1V5VWQM2egDPTL7yhREn0klBmwbTig04sYZhz
	IOCUDVQLx0f5oHfiJ7Wbu8V1UlyRPVEWg==
Received: from mail.thefacebook.com ([163.114.134.16])
	by m0001303.ppops.net (PPS) with ESMTPS id 4hv72pkmxh-10
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 10 Nov 2026 16:56:14 -0800 (PST)
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
Subject: [PATCH net-next v1 02/15] psp: take the psp nexthdr from the packet on encap
Date: Tue, 10 Nov 2026 16:55:20 -0800
Message-ID: <20261111005533.6436-3-toddfreed@meta.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDAwMyBTYWx0ZWRfX6F07LX0ZeWid
 4qc85pHeTmRbfUGsZFXIxL254FfnXXQv4viIJabIu79lRbbrInetUX7ZJ7XbfkS6Ogj5VwCiRsu
 Q4KElbqM/JrAeoOx+/37Ot+n4/Sz5o8BRHWroQsmNzP/u/puUCHDGQD7lgiMrJWpEQOwlX0sFEj
 pWjUchxmOkfnHHE5cDn1dGvdKM8ZSURAhvJ8sY8CaR14JB/JpWqkKH5zpznL/AX4CPnFOgQ3+Kx
 16OjrHrdLCk11+bkqO0d9hbpRKvPv2rcCFM9vZcxUM0cLx3DvyszihKLk5PzJNINiyUFpZXV8Kx
 XCr31E6StnZ5IY6bTYD9gFgKwv32E+MfMb20+T7+8qSHLcVTTJMfvjt5JWQDIadzwvEuDQCULYt
 6J0Hy+d6YaRQfuEBEJxJmyVS5QWDUSZiyaKTb7/Uf8NNPSnJkED5oPZZhXfGyh1lPQ8YXFPkbTW
 d45CC9pSfuvA2pbZ5nQ==
X-Proofpoint-GUID: gSX9WAyU0GY39zwzFZvimDeffjF86pr9
X-Authority-Analysis: v=2.4 cv=TtlzFzXh c=1 sm=1 tr=0 ts=6af3bd2e cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=_78whYxrdx1mplLwxq1U:22 a=VabnemYjAAAA:8 a=BvWioDDIc4x0Qm76E3sA:9
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-ORIG-GUID: gSX9WAyU0GY39zwzFZvimDeffjF86pr9
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDAwMyBTYWx0ZWRfXw074nlL3e7kC
 QjNQCJr8w0gbSpdFZbhEK4jgFk5Sa/l+sENevsCyjapki3Eu85WxYgSmOsR1ovq7zfgvzJKCZCu
 PJpOq52gN8fLkzOmYWcAy5jMuSGvgVA=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-10_07,2026-11-06_01,2025-10-01_01

psp sockets support has thus far been limited to tcp, and
psp_dev_encapsulate() hardcodes IPPROTO_TCP as the psp nexthdr

socket-less psp associations will also support udp traffic. populate the
psp nexthdr from the ip header of the original packet instead.

with the psp nexthdr taken from the fixed header, psp_dev_encapsulate()
indicates some cases which are unsupported,

 - ipv6 extension headers present. more generally, any packet whose
   transport header isn't right after the fixed ip header. some of these
   could be supported in the future. not a behavior change for psp
   sockets.
 - ipv4 fragments. non-initial fragments have no l4 header, so this
   cannot work. not a behavior change for psp sockets.
 - already encapsulated for a tunnel (skb->encapsulation). their inner
   headers are already set up.

both callers of psp_dev_encapsulate(), mlx5 and netdevsim, drop the packet
when it returns false.

mlx5e also fixes up the tcp checksum of gso skbs for the device, which
is only valid for tcp. have the stack segment other gso skbs, e.g. udp
from socket-less associations, in software. likewise the device only
completes a tcp or udp checksum behind the psp header: have the stack
checksum the other CHECKSUM_PARTIAL skbs.

Signed-off-by: Todd Freed <toddfreed@meta.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 33 ++++++++++++
 net/psp/psp_main.c                            | 50 ++++++++++++++++---
 2 files changed, 75 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index c3c2c5720c6f..d091de1a5992 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5132,6 +5132,23 @@ static netdev_features_t mlx5e_tunnel_features_check(struct mlx5e_priv *priv,
 	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
 }
 
+/* The L4 protocol right after the fixed IP header, which the PSP Tx path
+ * requires, is one the device can complete the checksum of
+ */
+static bool mlx5e_psp_l4_csum_ok(const struct sk_buff *skb)
+{
+	u8 proto;
+
+	if (skb->protocol == htons(ETH_P_IP))
+		proto = ip_hdr(skb)->protocol;
+	else if (skb->protocol == htons(ETH_P_IPV6))
+		proto = ipv6_hdr(skb)->nexthdr;
+	else
+		return false;
+
+	return proto == IPPROTO_TCP || proto == IPPROTO_UDP;
+}
+
 netdev_features_t mlx5e_features_check(struct sk_buff *skb,
 				       struct net_device *netdev,
 				       netdev_features_t features)
@@ -5140,6 +5157,22 @@ netdev_features_t mlx5e_features_check(struct sk_buff *skb,
 
 	features = vlan_features_check(skb, features);
 
+	/* The PSP tx path fixes up the TCP checksum of a GSO skb for the
+	 * device, which is only valid for TCP, and the device only completes
+	 * a TCP or UDP checksum behind the PSP header. Have the stack segment
+	 * and checksum other skbs.
+	 */
+	if ((skb_is_gso(skb) || skb->ip_summed == CHECKSUM_PARTIAL) &&
+	    mlx5e_psp_is_offload(skb, netdev)) {
+		if (skb_is_gso(skb) &&
+		    !(skb_shinfo(skb)->gso_type &
+		      (SKB_GSO_TCPV4 | SKB_GSO_TCPV6)))
+			features &= ~NETIF_F_GSO_MASK;
+		if (skb->ip_summed == CHECKSUM_PARTIAL &&
+		    !mlx5e_psp_l4_csum_ok(skb))
+			features &= ~NETIF_F_CSUM_MASK;
+	}
+
 	/* Validate if the tunneled packet is being offloaded by HW */
 	if (skb->encapsulation &&
 	    (features & NETIF_F_CSUM_MASK || features & NETIF_F_GSO_MASK))
diff --git a/net/psp/psp_main.c b/net/psp/psp_main.c
index e09f6fec948d..1eb1617aaf2b 100644
--- a/net/psp/psp_main.c
+++ b/net/psp/psp_main.c
@@ -189,7 +189,8 @@ unsigned int psp_key_size(u32 version)
 EXPORT_SYMBOL(psp_key_size);
 
 static void psp_write_headers(struct net *net, struct sk_buff *skb, __be32 spi,
-			      u8 ver, unsigned int udp_len, __be16 sport)
+			      u8 ver, u8 nexthdr, unsigned int udp_len,
+			      __be16 sport)
 {
 	struct udphdr *uh = udp_hdr(skb);
 	struct psphdr *psph = (struct psphdr *)(uh + 1);
@@ -236,7 +237,7 @@ static void psp_write_headers(struct net *net, struct sk_buff *skb, __be32 spi,
 	uh->check = 0;
 	udp_set_len(uh, udp_len);
 
-	psph->nexthdr = IPPROTO_TCP;
+	psph->nexthdr = nexthdr;
 	psph->hdrlen = PSP_HDRLEN_NOOPT;
 	psph->crypt_offset = 0;
 	psph->verfl = FIELD_PREP(PSPHDR_VERFL_VERSION, ver) |
@@ -245,8 +246,36 @@ static void psp_write_headers(struct net *net, struct sk_buff *skb, __be32 spi,
 	memset(&psph->iv, 0, sizeof(psph->iv));
 }
 
-/* Encapsulate a TCP packet with PSP by adding the UDP+PSP headers and filling
- * them in.
+/* udp+psp goes in at the transport header, the protocol of the fixed ip
+ * header becomes udp, and the psp next header takes the protocol it had: the
+ * transport header must directly follow the fixed header. it doesn't with
+ * ipv6 extension headers, whose last one holds the l4 protocol. for ipv6,
+ * check the next header too, not only the network header length: the seg6,
+ * rpl and ioam6 lwtunnels point the transport header at the extension header
+ * they insert. a packet already encapsulated for a tunnel has its inner
+ * headers set up for the tunnel, and an ipv4 fragment (e.g. refragmented
+ * after tc encap) has no l4 header, or not all of it.
+ */
+static bool psp_dev_encap_ok(const struct sk_buff *skb)
+{
+	u32 network_len = skb_network_header_len(skb);
+
+	if (skb->encapsulation)
+		return false;
+	if (skb->protocol == htons(ETH_P_IP))
+		return network_len == ip_hdrlen(skb) &&
+		       !ip_is_fragment(ip_hdr(skb));
+	if (skb->protocol == htons(ETH_P_IPV6))
+		return !ipv6_ext_hdr(ipv6_hdr(skb)->nexthdr) &&
+		       network_len == sizeof(struct ipv6hdr);
+	return false;
+}
+
+/* Encapsulate a packet with PSP by adding the UDP+PSP headers and filling
+ * them in. The PSP next header is taken from the IP header: packets with
+ * IPv6 extension headers, or whose transport header isn't right after the IP
+ * header, are refused, as are IPv4 fragments and packets already
+ * encapsulated for a tunnel.
  */
 bool psp_dev_encapsulate(struct net *net, struct sk_buff *skb, __be32 spi,
 			 u8 ver, __be16 sport)
@@ -254,11 +283,16 @@ bool psp_dev_encapsulate(struct net *net, struct sk_buff *skb, __be32 spi,
 	u32 network_len = skb_network_header_len(skb);
 	u32 ethr_len = skb_mac_header_len(skb);
 	u32 bufflen = ethr_len + network_len;
+	u8 nexthdr;
 
-	if (skb->protocol != htons(ETH_P_IP) &&
-	    skb->protocol != htons(ETH_P_IPV6))
+	if (!psp_dev_encap_ok(skb))
 		return false;
 
+	if (skb->protocol == htons(ETH_P_IP))
+		nexthdr = ip_hdr(skb)->protocol;
+	else
+		nexthdr = ipv6_hdr(skb)->nexthdr;
+
 	if (skb_cow_head(skb, PSP_ENCAP_HLEN))
 		return false;
 
@@ -279,11 +313,11 @@ bool psp_dev_encapsulate(struct net *net, struct sk_buff *skb, __be32 spi,
 		be16_add_cpu(&ipv6_hdr(skb)->payload_len, PSP_ENCAP_HLEN);
 	}
 
-	skb_set_inner_ipproto(skb, IPPROTO_TCP);
+	skb_set_inner_ipproto(skb, nexthdr);
 	skb_set_inner_transport_header(skb, skb_transport_offset(skb) +
 						    PSP_ENCAP_HLEN);
 	skb->encapsulation = 1;
-	psp_write_headers(net, skb, spi, ver,
+	psp_write_headers(net, skb, spi, ver, nexthdr,
 			  skb->len - skb_transport_offset(skb), sport);
 
 	return true;
-- 
2.53.0-Meta

