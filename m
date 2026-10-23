Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.153.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792799272;
	b=PwuZ0FFwNkhYLekd4MvZ4MHv6wEP31brCpI54p1RYgYaEaP8sOvzGv+i4pbH+MDcPY86
	 pHQOvzedka8dkBKHUOA7V/OWYOeCB+5lgbbxTElT/13MmIMwIFbe0p438ncZd3hV59YmF
	 vVvJzx9zik9EEdX03uFIFd5l4xcscTVWWmcye9tS05bBnWoieekE4DRQqxwNFZwzVllJS
	 WhiUUSwjMWge4+r7ILqMEbtcGQo6/HKhOgtYKjah/4sS86OBGzNT2qCMARmmCOvAluk88
	 tAnoydi7LZCI5NHFJN1FhHPlygG77zUggLu15w6T2DhaSu+oCjfPNJjlgOtWISOOKmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792799272;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version;
	bh=0GSxJK8oPTlXqB8yBUEbT/3uub6nPbzIlsCyAHPY3SM=;
	b=PRZOglhYjjiLj16gZaVmGRmCeTxjaYpWkTtnEmCCHucd6kCNuQsiHfdK9JVaD0IJ3z8X
	 t7NmF7eEo+zYgkkhu/IWmti/za1m+P5ExR+/xFxtG+wXs5L7t7F/mnWydGPof0HIwHQGS
	 CdGVQ7eMuyI1NkjyEGdBEIDkRzMeR8Dqty4TgUTUTgHv6Vq2TydGWrWXnVu3/Nd4CKBsD
	 kigl4PFpaiF9p70JgzbTwYJds0S9txxh5Jpz8nPCUFWYvTB8b3q4gFz2pVCH/dWkHnLRK
	 IEnLMiixrTCRghogUTpa+6e1IdUEhA5GcxmZ6ZtrFqoiAyzAIfNz/SeK2/mYpO2a8tQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=R2slAh4v;
	arc=none smtp.remote-ip=67.231.153.30
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018E7606A320;
	Fri, 23 Oct 2026 23:47:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 018E7606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=R2slAh4v
Received: from pps.filterd (m0528005.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69NLwaIo363340;
	Fri, 23 Oct 2026 16:47:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=0GSxJK8oPTlXqB8yBUEbT/3uub6nPbzIlsCyA
	HPY3SM=; b=R2slAh4vTMndpuEO5+dCU9Y9kuBG6G/Yg7ZNyGSKFXTXNaq4oab2X
	gFqqLb1mlTKYB8Tc8eI3+b29M0cYqJNzAi6RE+EKTe4IC77RthcoEHFmj4Cfn4bc
	LOKm0b72IzEWfF4bU97KruGM2usSjWCcx3gwjMzO7B3+z3CNwMbLeGcRBjzgxGil
	PcCEgPlfFRgjoOhpuRfWZbt5K33OLrHuxFz3bXFnux2JCALO1HkcpkGsAihS+g2K
	2KQkTAaP899/DYDxybWkat8UczdF9Elgbrin8xU8OtgK/DhoJ3CFI4o+sY/YkhLk
	E+piQ9QfBIj0QIT9a/iASecHttila1D9w==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4hfjf6mnvs-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Fri, 23 Oct 2026 16:47:43 -0700 (PDT)
Received: from localhost (2620:10d:c085:108::4) by mail.thefacebook.com
 (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Fri, 23 Oct
 2026 23:47:41 +0000
From: Todd Freed <toddfreed@meta.com>
To: <netdev@vger.kernel.org>, <toddfreed@meta.com>
CC: Boris Pismenny <borisp@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
        "Mark
 Bloch" <mbloch@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
        "David S.
 Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@kernel.org>,
        "Jakub
 Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Daniel Zahka
	<daniel.zahka@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Simon Horman <horms@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Cosmin Ratiu
	<cratiu@nvidia.com>, Raed Salem <raeds@nvidia.com>,
        Rahul Rameshbabu
	<rrameshbabu@nvidia.com>,
        <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Dragos Tatulea
	<dtatulea@nvidia.com>
Subject: [PATCH net v3 3/4] psp: support ipv6 extension headers in psp_dev_encapsulate()
Date: Fri, 23 Oct 2026 16:46:39 -0700
Message-ID: <20261023234640.1459291-4-toddfreed@meta.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261023234640.1459291-1-toddfreed@meta.com>
References: <20261023234640.1459291-1-toddfreed@meta.com>
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
X-Proofpoint-GUID: Geex3j2j3HomATM1XAbs2YSxZTrlywT4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDA5MyBTYWx0ZWRfX2KmZzDku2Aft
 EDseJgcG80KTeA9jRLEvkD3dkO8sDVLNWWXFN21kIeUSGRbgjB8A/N9dRF5inM+INhCjZDJi+v/
 4hfj+dUkP9MoYq0qEV7lEnf2fMtbx+XrHyyxL5NQg0JpVNoYVzSAul2UQDt5howZSJy8qM53l2F
 lyXzX0MDs8k4oOnr6vtImXxzYdLbw4hnc229ub1EKC9OLHcL+uEhWZEZZ+Jjdqt5v0SoU9u2R46
 1vE4QznlZ0Ev8+TuWxRZwE+Is5cg/JwVSPxa4jQtuOIrHq1JCIr6IJwRyXGURyXEhVkVj6NxO08
 C8GxXrCn4D+z82yDB9juaZ3q9Hhjle4VKjqT5NUa2O57Xe3qtoNPT0u23IsDcMwPkG9YhguIzVA
 H3rET1KYX2lwA9XE96/j4q/UrAsVfjL243aDw4cgATXepr4wjTNnp2DpUHFs/I4ST35YrGdI5Td
 bZfBxImkyTHobpEObCw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDA5MyBTYWx0ZWRfXxT37z53SimK1
 LwrmGs4f5tpalSCB24CNRJdEo2pRGXDjvEtGEygFjlywMCNWdl3rb7G2ooo5+PyiNvObAZ5LHTF
 BOE0FmZXNDNrM/1dRG4KswM+y8IcB5w=
X-Authority-Analysis: v=2.4 cv=PNaaavqC c=1 sm=1 tr=0 ts=6adbf21f cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=jCddH8ec0KUNCymVuxII:22 a=pGLkceISAAAA:8 a=VabnemYjAAAA:8
 a=4Lo5AxHxfJizHQ_NNXkA:9 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-ORIG-GUID: Geex3j2j3HomATM1XAbs2YSxZTrlywT4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_06,2026-10-21_02,2025-10-01_01

psp_dev_encapsulate() inserts the udp and psp headers and rewrites the
l3 next header to udp.

if the packet is an ipv6 packet with extension headers, the transport
header comes after them, so rewriting the next header of the ipv6 fixed
header produces a malformed packet.

a psp tcp socket emits such packets if certain socket options are set on
it (e.g. IPV6_DSTOPTS). with mlx5, these packets also go out
unencrypted.

fix by walking the extension header chain to rewrite the nexthdr on the
last one in the chain instead. the walk also rejects packets with
extension headers that aren't supported in transport mode,

- NEXTHDR_FRAGMENT. this could work, but udp+psp would need to come
  before it, which is different than how the other option types are
  handled. for now, keep fragments unsupported for transport mode.

- NEXTHDR_AUTH. changing what follows would break the AH ICV. Also, AH
  adds little incremental value when used with psp, whose ICV already
  authenticates the payload. AH remains unsupported for psp transport
  mode.

note that the stack doesn't fragment ipv6 tcp packets, so a psp socket
won't be able to exercise the tx fragment path.

Suggested-by: Daniel Zahka <daniel.zahka@gmail.com>
Fixes: fc724515741a ("psp: provide encapsulation helper for drivers")
Signed-off-by: Todd Freed <toddfreed@meta.com>
---
 net/psp/psp_main.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/psp/psp_main.c b/net/psp/psp_main.c
index 946047440ed3..e6d2136cb9a7 100644
--- a/net/psp/psp_main.c
+++ b/net/psp/psp_main.c
@@ -277,7 +277,7 @@ static void psp_write_headers(struct net *net, struct sk_buff *skb, __be32 spi,
 }
 
 /* Encapsulate a TCP packet with PSP by adding the UDP+PSP headers and filling
- * them in.
+ * them in. With IPv6, they go after any extension headers.
  */
 bool psp_dev_encapsulate(struct net *net, struct sk_buff *skb, __be32 spi,
 			 u8 ver, __be16 sport)
@@ -285,10 +285,17 @@ bool psp_dev_encapsulate(struct net *net, struct sk_buff *skb, __be32 spi,
 	u32 network_len = skb_network_header_len(skb);
 	u32 ethr_len = skb_mac_header_len(skb);
 	u32 bufflen = ethr_len + network_len;
+	int nh_off = 0;
 
-	if (skb->protocol != htons(ETH_P_IP) &&
-	    skb->protocol != htons(ETH_P_IPV6))
+	if (skb->protocol == htons(ETH_P_IPV6)) {
+		/* UDP + PSP after the extension headers, if any */
+		nh_off = psp_ipv6_nexthdr_off(skb_network_header(skb),
+					      network_len);
+		if (nh_off < 0)
+			return false;
+	} else if (skb->protocol != htons(ETH_P_IP)) {
 		return false;
+	}
 
 	if (skb_cow_head(skb, PSP_ENCAP_HLEN))
 		return false;
@@ -306,7 +313,7 @@ bool psp_dev_encapsulate(struct net *net, struct sk_buff *skb, __be32 spi,
 		ip_hdr(skb)->check =
 			ip_fast_csum((u8 *)ip_hdr(skb), ip_hdr(skb)->ihl);
 	} else {
-		ipv6_hdr(skb)->nexthdr = IPPROTO_UDP;
+		skb_network_header(skb)[nh_off] = IPPROTO_UDP;
 		be16_add_cpu(&ipv6_hdr(skb)->payload_len, PSP_ENCAP_HLEN);
 	}
 
-- 
2.53.0-Meta

