Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.153.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051887;
	b=vosNSMyvdGVAHdSzoFPbwZ+PklWcbDoax0w+BySFxKiekCEEj5gRLzu9Uv4v2Caj6bcP
	 DP+10tR6YlsqBRn6dPwM3elkAkSyw2kG/GhZHBr1HVEoldGx7sveUU3WZFLuqtFY0jZap
	 zurfYHo72REWSvKXNZNZoEnWpgJ2s7ZsOjZVh3bYbXEiY99N0IHo8Y4YE91Te7LraOUmU
	 7CD4m3A0W6hoDXtCEIMV7Kx9au+Xe5AJs+O37R0a46C44WA3LdFpmAyzwvciOQMn54d4H
	 Q3gMb+U5KwcwbGs0EbGkG5bQq9InQv8Nrr1PVz2v0DurdKuxmXEQwh3nOMsNPfEz9vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051887;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version;
	bh=4ruqJaIKIx953QIszUIJZzz8if5WmP4GcJyvcLsRn10=;
	b=UVi7maMAmaK+Kb34MSh6PTkuDLbFOp7rOJ59ykIg4WcHLi309fBocaAIkyV45mgEUMmQ
	 T2WbJ3Kgrk7nQobcnUBiDUVBZ1gOJTDuN4yv4HZZ+sM+oiBogizODptoNe79GmnhP7djX
	 q0mYg6z1ORA3fHRfdQnXhw4eC8viwxoGl4fK4uOvDtcugac04Ht/TeGkyqsoK4f9wp5vH
	 TTrIuqRwR74SpQ286oFLo124NI3vF1GdRGt9llLoNYL4MAOu1FrD/I+AJd+A7KtkqZi4e
	 dD0RVX9bsfUfdO9IRfzvEzqyvtY3x91unZZyv7BGIn5FHUqwzGG08q5nGBErJKEAtow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=Zq7TkutU;
	arc=none smtp.remote-ip=67.231.153.30
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F6F606A32C;
	Thu, 19 Nov 2026 01:31:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4F6F606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=Zq7TkutU
Received: from pps.filterd (m0528004.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AJ19S0C1375386;
	Wed, 18 Nov 2026 17:31:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=4ruqJaIKIx953QIszUIJZzz8if5WmP4GcJyvc
	LsRn10=; b=Zq7TkutURYKDhMRsy5afTKApI5dbEfcw0j4zHdw8tH0WBzaXPcYRl
	13PhjMDmBZGDWVU6AZTjiCTtRUSqn6h+PHltdyETWMkRzJdhmDS+iNp00G2IoI/E
	POH01LVuz4tbKDqZrED+CCW8cd11LFHrtnq7F1mGSpkO3RDpWlpDsDNA0U3DeAW1
	JE2ZMdcUMyfLws6+d6t8ICodVEhYodAcXlSW1qgqx/Wl8LlJk4dUTrM+VCuYKDwq
	Kqg+8RdCyolCX23HU020GL5DjyPzahlw52p4kY6MNoa1Ek9mK6QXsYPHuwUgyDip
	nCZ/ykHI1ORehR1Ob7gsNDeB9h3zE4ozg==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j0yu6b8r4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 18 Nov 2026 17:31:15 -0800 (PST)
Received: from localhost (2620:10d:c085:108::4) by mail.thefacebook.com
 (2620:10d:c08b:78::c78f) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Thu, 19 Nov
 2026 01:31:14 +0000
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
	<willemdebruijn.kernel@gmail.com>
Subject: [PATCH net-next v2 02/12] psp: take the psp nexthdr from the packet on encap
Date: Wed, 18 Nov 2026 17:30:53 -0800
Message-ID: <20261119013103.1092559-3-toddfreed@meta.com>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261119013103.1092559-1-toddfreed@meta.com>
References: <20261119013103.1092559-1-toddfreed@meta.com>
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
X-Proofpoint-GUID: NLK1mtGvCZEaPZ0KVbWp03G-70toJN-B
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE5MDAwNSBTYWx0ZWRfX4RMF3ZDj/zdZ
 iK7CpZHHNrloYBnrx6dVOYKf028T4u0xx4lpA9EAtrtn1bxiMxmPuCAhyx1SsxNi4jfutMaBTFE
 /23OOB8PFVdcyAfo+Fb+LR7lfHWkjB8wk8wfjoQ+s1ECoVMCOb/Zcbikfmu2AEFWmAuCHhF2Pb1
 yzwZRg6JpunU1YoqlhxFsD804EgX9PY3onfjEnU2AaWM48OGJQismmS8INJBxBMo+oaVrD1poQG
 JgGQswVPwHM6FPDbeqOfNObmxFlMOYt733ThcuaW0vYMKkfd1LBi8ZsYJYzP8ygMQwLP+mHOAFT
 2DjQfJIYLaoXhA2FWRWd3eyoETuqudWSl7PbRSfWCgLbPlUHqybM4wQzuzc0/izNEjZCWIpzMIR
 omQhTjJ9SEj/9ADBPlbmOz/N1S8Nwwo13vjhUxihbuAm+Z75s8EZ4mMXyqiuwrTxXxTn447vRR5
 ydeAdrghhfhBa4Vyl7Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE5MDAwNSBTYWx0ZWRfX8IXIn1ftscBq
 SuHNtE9ncSlMXBbJV/+BMeTyZcWKjRGYlRm2m9BJ5OWhhQS1BWVNhQZQ8f8v7GANyQ4KHCE4OqM
 hOfhdIWbdonizZcKauupZVGQHi9WnXQ=
X-Proofpoint-ORIG-GUID: NLK1mtGvCZEaPZ0KVbWp03G-70toJN-B
X-Authority-Analysis: v=2.4 cv=Mfz5KJ/f c=1 sm=1 tr=0 ts=6afe5163 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=GbPsI2Ihf5RTnMjR_gZv:22 a=VabnemYjAAAA:8 a=aObd4hDyPTaLV535L6AA:9
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-19_01,2026-11-16_01,2025-10-01_01

PSP socket support has thus far been limited to TCP, and
psp_dev_encapsulate() hardcodes IPPROTO_TCP as the PSP next header.

Socket-less PSP associations will also support UDP traffic. Populate the
PSP next header from the IP header of the original packet instead.

With the next header taken from the fixed header, psp_dev_encapsulate()
now refuses some cases which are unsupported:

 - IPv4 and IPv6 fragments. Non-initial fragments have no L4 header, so
   this cannot work. Not a behavior change for PSP sockets.
 - IPv6 extension headers. More generally, any packet whose transport
   header isn't right after the fixed IP header. Some of these could be
   supported in the future. Not a behavior change for PSP sockets.
 - Already encapsulated for a tunnel (skb->encapsulation). Their inner
   headers are already set up.

Both callers of psp_dev_encapsulate(), mlx5 and netdevsim, drop the
packet when it returns false.

mlx5e also fixes up the TCP checksum of GSO skbs for the device, which
is only valid for TCP. Have the stack segment other GSO skbs, e.g. UDP
from socket-less associations, in software. Likewise the device only
completes a TCP or UDP checksum behind the PSP header: have the stack
checksum the other CHECKSUM_PARTIAL skbs.

For the outer UDP source port, psp_write_headers() already branches to
use TCP ehash if the skb has a socket, with fallback to
udp_flow_src_port(). Previously, sk always meant TCP. Add an explicit
check on nexthdr, and on the socket being a TCP one (a raw or packet
socket can send TCP segments, and has no sk_hash), so that the fallback
branch is taken for other packets. udp_flow_src_port() hashes the flow
if the skb has no hash yet: compute it in psp_dev_encapsulate() before
the headers are moved and the IP protocol rewritten, so that it covers
the packet's own flow rather than the outer headers being written.

Signed-off-by: Todd Freed <toddfreed@meta.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 33 +++++++++++
 net/psp/psp_main.c                            | 56 +++++++++++++++----
 2 files changed, 79 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 2be8147fdb64..d6c32080634d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5139,6 +5139,23 @@ static netdev_features_t mlx5e_tunnel_features_check(struct mlx5e_priv *priv,
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
@@ -5147,6 +5164,22 @@ netdev_features_t mlx5e_features_check(struct sk_buff *skb,
 
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
index e09f6fec948d..4b48070fb9e5 100644
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
@@ -211,10 +212,11 @@ static void psp_write_headers(struct net *net, struct sk_buff *skb, __be32 spi,
 	 * This field is subject to reshuffling, thanks to
 	 * sk_rethink_txhash() calls in various TCP functions.
 	 *
-	 * Instead, use sk->sk_hash which is constant through
+	 * Instead, use sk->sk_hash for TCP which is constant through
 	 * the whole flow duration.
 	 */
-	if (likely(sk)) {
+	if (likely(sk && nexthdr == IPPROTO_TCP &&
+		   (!sk_fullsock(sk) || sk_is_tcp(sk)))) {
 		u32 hash = sk->sk_hash;
 		int min, max;
 
@@ -236,7 +238,7 @@ static void psp_write_headers(struct net *net, struct sk_buff *skb, __be32 spi,
 	uh->check = 0;
 	udp_set_len(uh, udp_len);
 
-	psph->nexthdr = IPPROTO_TCP;
+	psph->nexthdr = nexthdr;
 	psph->hdrlen = PSP_HDRLEN_NOOPT;
 	psph->crypt_offset = 0;
 	psph->verfl = FIELD_PREP(PSPHDR_VERFL_VERSION, ver) |
@@ -245,8 +247,32 @@ static void psp_write_headers(struct net *net, struct sk_buff *skb, __be32 spi,
 	memset(&psph->iv, 0, sizeof(psph->iv));
 }
 
-/* Encapsulate a TCP packet with PSP by adding the UDP+PSP headers and filling
- * them in.
+/* UDP+PSP goes in at the transport header, the protocol of the fixed IP
+ * header becomes UDP, and the PSP next header takes the protocol it had. The
+ * transport header must directly follow the fixed header.
+ */
+static bool psp_dev_encap_ok(const struct sk_buff *skb)
+{
+	u32 network_len = skb_network_header_len(skb);
+
+	/* inner headers already set up */
+	if (skb->encapsulation)
+		return false;
+	/* fragments not supported for transport mode */
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
+ * header, are refused, as are IP fragments and packets already
+ * encapsulated for a tunnel.
  */
 bool psp_dev_encapsulate(struct net *net, struct sk_buff *skb, __be32 spi,
 			 u8 ver, __be16 sport)
@@ -254,11 +280,21 @@ bool psp_dev_encapsulate(struct net *net, struct sk_buff *skb, __be32 spi,
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
+	/* udp_flow_src_port() may need to hash the flow: do it on the
+	 * original headers, before they are moved and rewritten
+	 */
+	skb_get_hash(skb);
+
 	if (skb_cow_head(skb, PSP_ENCAP_HLEN))
 		return false;
 
@@ -279,11 +315,11 @@ bool psp_dev_encapsulate(struct net *net, struct sk_buff *skb, __be32 spi,
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
2.53.1-Meta

