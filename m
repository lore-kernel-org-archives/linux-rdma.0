Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.145.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795558750;
	b=ZeG2n8zWM13nCR96tjarYhMqfs+PVPJz7kRFOy1x/G+C9I5/i40pFAXnWFzXR6kRJ8G4
	 ngmfQoNsfeIZCBvTCjIHalIGWuM+XMqa+tBM4Xf7zFm6Ov43hHVQL3Xnc0jSTwneWgnHh
	 4V7QKTwwg2RUvCx4XVr2OkHz4CZ8FJU4v6gK396f+z/Cnmz4t5E3KYimM6l6rw64+I+UC
	 d72eqPX+1YZVjn39FYk84dvUp7krDVere+iJZBJsrzdRxNQYYy6nLW6m74tI+A+lVdOA3
	 VqdVA9sGgB6rr9mdsPyFcfw1hb36DnZnVQPXZyNx3QXGJvgK/kcMe2cYwZX1nanXIPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795558750;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-GUID:X-Proofpoint-Virus-Version;
	bh=l+IGb2MMhDSd7RH1hGgNIF+8P8G05Ajw57zNdAkQ70E=;
	b=k/tYKWEYAJCj3PoQ1zauctKhGa+e6v0WuAX4LmTotgb/Xxs50cSRhcA/4hMrk/mUeFng
	 wNJoG+iF6PVGHQSUsTiSBFNDlpDFeg+kruhvX97Tm+98XvLphZRgUoqk+qy+eYs9E6rhj
	 gQXXmI6gMTO+it3e/Mp3y1UGNqwV2ED6NureFfRwujBGk/yvGGVGIKm9uEe4QlSSLvirv
	 Lxg0fQYLug/LQ9JOcrhxlyp+p7ceeEpdWEK3Y329ZquOl8jWaKid0kPCjnEYvJIcu+dZJ
	 qDE0if04SPvXX9ZWtcoM47wwBWDgJyo8vIHM0LaCpCHN11BUOAFveeNvVd6yRIOCwHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=OqmFmAWU;
	arc=none smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B30606A6B0;
	Tue, 24 Nov 2026 22:19:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 57B30606A6B0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=OqmFmAWU
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AOMBXjs1791243;
	Tue, 24 Nov 2026 14:18:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=l+IGb2MMhDSd7RH1hGgNIF+8P8G05Ajw57zNd
	AkQ70E=; b=OqmFmAWU9VfcxgV5bclW02/K4uCVM7iCzay2Qom4avTIBNhIKPjJa
	oszv4qta0Fh0/zLRS3ZNgRfZPRUJE32Fos56Ku+ZCesF1RpxEEpypJUX3+hBnKuO
	q/bJ1mftDHYCS+TboyZq1IXWFOznMt2H26zGE80MfqGijEQvv9fvFj9Q3Kfov+QL
	+CQc3aBAmDxUepgAHHG/2/ztPmFac4w0XVTAKyJbeI+LCar0bq57XBvIfpvPny6M
	IFXoeB+NMOESHQ3xBHImp1tmZWRuDe9az0veLHWe1OcBRjY7waa+2/zC0Yfi/dev
	IJliX/X4yLdTtQkFN8eOrt2QkzFJ2b7Iw==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j5fmw9v6y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 24 Nov 2026 14:18:15 -0800 (PST)
Received: from localhost (2620:10d:c0a8:1c::1b) by mail.thefacebook.com
 (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Tue, 24 Nov
 2026 22:18:14 +0000
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
	<willemdebruijn.kernel@gmail.com>,
        Kuniyuki Iwashima <kuniyu@google.com>, <bpf@vger.kernel.org>,
        =?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?=
	<ast@fiberby.net>,
        Qingfang Deng <qingfang.deng@linux.dev>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Shuah Khan
	<shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan
	<skhan@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthieu
 Baerts <matttbe@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        =?UTF-8?q?Jonas=20K=C3=B6ppeler?= <j.koeppeler@tu-berlin.de>,
        Hangbin Liu
	<hangbin.liu@linux.dev>
Subject: [PATCH net-next v3 02/12] psp: take the psp nexthdr from the packet on encap
Date: Tue, 24 Nov 2026 14:17:48 -0800
Message-ID: <20261124221758.3230929-3-toddfreed@meta.com>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261124221758.3230929-1-toddfreed@meta.com>
References: <20261124221758.3230929-1-toddfreed@meta.com>
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
X-Proofpoint-ORIG-GUID: F2SDich1z0MTqvYm28XNgtUi0TFc0qXW
X-Authority-Analysis: v=2.4 cv=MPn1C8Zl c=1 sm=1 tr=0 ts=6b060d27 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=tpM8CJlwf7uhpglF1g9U:22 a=VabnemYjAAAA:8 a=ZRZWA7VBFQUiA7_YxpgA:9
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI0MDA4NyBTYWx0ZWRfX06ZlynsxrHk5
 rQ7OO6eVy4f1LVG6LK6BzZASyv1A9UDeKYmFNUgvfJtc3lfO5wuAbQoNCbOcY8dvNbZmpQbdbtq
 k5a6J1D5JQSINbVD8bSChmlUYAMTl+zIPZctkq4b1RKmJ3AWkdh9DfjqPlHvgFylRoIqzzNaPe6
 dTRqVpyd+4zd1XTymznMXB1sN8cg1AImlB9VF4xlfb5cLhb9wnlGrqAGxSchsnqvKOE6fjRZ1++
 dXy6955+KDI0kqDmOXK18CQ1hBdC7aSBeBZbLr+ZWVDJsxRDj9z1C7Ieie9/AinEjTSCnTViqSt
 S2yCjsuMp96V0NV00KGlboqpv2oi0zW9X2iadnVaeImx1h8Y0ETQOYICNZ/YZhrIiXVBG+PsfdV
 FojeiFLpvVv5USbl5hjPJRy0iGUzcYs4QEEmiy17f/Vor83cFyxXwCSf2Bp121/024QsIgJf83b
 dw38f0E7wndNuJ3b5Tg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI0MDA4NyBTYWx0ZWRfXy65O63BRbaXi
 XxXbQx3hZTz4YVHgd1Fnlk3S5WIH/WGuvbnMeTDNSU8eMqfWswTlB/Gipu76BA5tG4sVR+q1NVP
 aLNyse6+mb2d0fuPZ/Yd/FrpRGpeYJ8=
X-Proofpoint-GUID: F2SDich1z0MTqvYm28XNgtUi0TFc0qXW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-24_06,2026-11-23_01,2025-10-01_01

PSP socket support has thus far been limited to TCP, and
psp_dev_encapsulate() hardcodes IPPROTO_TCP as the PSP next header.

Socket-less PSP associations will also support UDP traffic. Populate the
PSP next header from the IP header of the original packet instead.

With the next header taken from the fixed header, psp_dev_encapsulate()
now refuses some cases which are unsupported:

 - IPv4 and IPv6 fragments. Non-initial fragments have no L4 header, so
   this cannot work. Not a behavior change for PSP sockets.
 - IPv6 extension headers. More generally, any packet whose transport
   header isn't right after the IP header (IPv4 options are fine). Some
   of these could be supported in the future. Not a behavior change for
   PSP sockets.
 - Already encapsulated for a tunnel (skb->encapsulation). Their inner
   headers are already set up.
 - A checksum to complete (CHECKSUM_PARTIAL) for a next header other than
   TCP or UDP, which the device can't complete behind the PSP header.
   Software GSO of a tunnel with an outer checksum, e.g. GRE with csum,
   clears skb->encapsulation on the segments but leaves the outer checksum
   to the device.

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
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 33 +++++++++
 net/psp/psp_main.c                            | 67 ++++++++++++++++---
 2 files changed, 90 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 54f4f5a097c8..0fac06651e5b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5248,6 +5248,23 @@ static netdev_features_t mlx5e_tunnel_features_check(struct mlx5e_priv *priv,
 	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
 }
 
+/* The L4 protocol right after the IP header (and its IPv4 options), which
+ * the PSP Tx path requires, is one the device can complete the checksum of
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
@@ -5256,6 +5273,22 @@ netdev_features_t mlx5e_features_check(struct sk_buff *skb,
 
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
index 964749a865b1..dc6144469647 100644
--- a/net/psp/psp_main.c
+++ b/net/psp/psp_main.c
@@ -214,7 +214,8 @@ unsigned int psp_key_size(u32 version)
 EXPORT_SYMBOL(psp_key_size);
 
 static void psp_write_headers(struct net *net, struct sk_buff *skb, __be32 spi,
-			      u8 ver, unsigned int udp_len, __be16 sport)
+			      u8 ver, u8 nexthdr, unsigned int udp_len,
+			      __be16 sport)
 {
 	struct udphdr *uh = udp_hdr(skb);
 	struct psphdr *psph = (struct psphdr *)(uh + 1);
@@ -236,10 +237,11 @@ static void psp_write_headers(struct net *net, struct sk_buff *skb, __be32 spi,
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
 
@@ -261,7 +263,7 @@ static void psp_write_headers(struct net *net, struct sk_buff *skb, __be32 spi,
 	uh->check = 0;
 	udp_set_len(uh, udp_len);
 
-	psph->nexthdr = IPPROTO_TCP;
+	psph->nexthdr = nexthdr;
 	psph->hdrlen = PSP_HDRLEN_NOOPT;
 	psph->crypt_offset = 0;
 	psph->verfl = FIELD_PREP(PSPHDR_VERFL_VERSION, ver) |
@@ -270,8 +272,34 @@ static void psp_write_headers(struct net *net, struct sk_buff *skb, __be32 spi,
 	memset(&psph->iv, 0, sizeof(psph->iv));
 }
 
-/* Encapsulate a TCP packet with PSP by adding the UDP+PSP headers and filling
- * them in.
+/* UDP+PSP goes in at the transport header, the protocol of the IP header
+ * becomes UDP, and the PSP next header takes the protocol it had. The
+ * transport header must directly follow the IP header: IPv4 options are fine,
+ * IPv6 extension headers aren't.
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
+ * header, are refused, as are IP fragments, packets already encapsulated
+ * for a tunnel, and packets with a checksum to complete for a protocol other
+ * than TCP or UDP.
  */
 bool psp_dev_encapsulate(struct net *net, struct sk_buff *skb, __be32 spi,
 			 u8 ver, __be16 sport)
@@ -279,11 +307,30 @@ bool psp_dev_encapsulate(struct net *net, struct sk_buff *skb, __be32 spi,
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
+	/* Devices complete only a TCP or UDP checksum behind the PSP header.
+	 * Software GSO of a tunnel with an outer checksum, e.g. GRE, leaves
+	 * the segments here with encapsulation cleared and CHECKSUM_PARTIAL
+	 * at the tunnel header.
+	 */
+	if (skb->ip_summed == CHECKSUM_PARTIAL &&
+	    nexthdr != IPPROTO_TCP && nexthdr != IPPROTO_UDP)
+		return false;
+
+	/* udp_flow_src_port() may need to hash the flow: do it on the
+	 * original headers, before they are moved and rewritten
+	 */
+	skb_get_hash(skb);
+
 	if (skb_cow_head(skb, PSP_ENCAP_HLEN))
 		return false;
 
@@ -304,11 +351,11 @@ bool psp_dev_encapsulate(struct net *net, struct sk_buff *skb, __be32 spi,
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

