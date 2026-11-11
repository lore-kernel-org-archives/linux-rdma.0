Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.153.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794356355;
	b=4eNvUUStl2vnZKWOdxv2Cpn09qUJB5fBAhyy8QRxrnOUB5zooxm2i2aYJj0IqmWbxm8n
	 Xzw2SR95lFg+7UJKTzUXJzgGhayssvSPmN/esH78jIPb6t5SpfKsP8hj8Jf8DS9uZGiHy
	 19vjImcC982Poju6wzASc5BovLicmhAFBxyXFFeVHSUW/KTT/Kruut6niHpbQn98kpZbj
	 lX78WRzlkS4t8djGcFqmnSxYJnj7okwaLAfBK78x3G2Vy4LeAKeS70o8GJeujoS3kZfNP
	 vN7WidrARVympJ5dOP0e/TuFPDLyc4URCEO7LvwVFVZNJgc8TajZid8ECjhXpCosenw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794356355;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version;
	bh=g+MWHMRxcXzv7wOFHOUfT5Dnfi1frvr4zOpXqitHGao=;
	b=d+Gy3IyuHPLcvM608IHDT9XE0iE07s7iVkqU2GbULa8HMEpX3wLZ5zS5QesIBxehcPck
	 WPSFYkYguG2UvqWkTSmnjdCPjtRbde5Gh3fF2GcYhKdztL4kP+TCccZCx0L5bRjjPsoiM
	 IO1eF1tY4krWLtaY66CbBS61jArR00tM6C2EMfw+DMYSxIhc6D3kbz/n13GEM29TJjUVZ
	 oJcGMal2okqGMzuZUn5Bgk7yX5ZKdpgkJsMXpgte00WZlh+i7+XliXGXJnOJIWVvuc1sz
	 9IJQcr4NSDFNb/kly+TE9svU91/luXx9hDEXQtHGY6ZbnyyPEsXGpnTwOxhi3VxXYaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=LX1l5zIW;
	arc=none smtp.remote-ip=67.231.153.30
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B460360A5BC7;
	Wed, 11 Nov 2026 00:19:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B460360A5BC7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=LX1l5zIW
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6AAMKVMR721830;
	Tue, 10 Nov 2026 16:18:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=g+MWHMRxcXzv7wOFHOUfT5Dnfi1frvr4zOpXq
	itHGao=; b=LX1l5zIW1WYpEufX0TfXpRymDuA9Vs1/DhdMtC0qOPqAEXaTbSm8J
	DtwdU+nkjj6nb46JwSvURPZNdd9sbcDAuQ79rLQaxRHGl5WEsl/1Mjk0ESTz9qs+
	C/O5gvmJgs/qt8Ry0pKBt42W9b55k2Rv2Tl7blxLBUojv1QvLEdctYWkUIMIKKZS
	xjJ0Mhy3ccpq38q0itBck3EgrBwmkLFJ8gOSWeA0nvmWEjmYO7gbQutNcJakEiFI
	oQb86IOYw6D/BIsvsvOzGeAOrBBAa9zhNfuZLe4DdefWNwXLkVkQxBtZkpSZBpgt
	xGSxVPMQqp7Y5TH69TWiaEvRJLoG1+hng==
Received: from mail.thefacebook.com ([163.114.134.16])
	by m0089730.ppops.net (PPS) with ESMTPS id 4huqmr91ns-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 10 Nov 2026 16:18:53 -0800 (PST)
Received: from localhost (2620:10d:c085:108::150d) by mail.thefacebook.com
 (2620:10d:c08b:78::c78f) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Wed, 11 Nov
 2026 00:18:52 +0000
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
Subject: [PATCH net v5 8/8] net/mlx5e: psp: tso: replace only the length in checksum seed
Date: Tue, 10 Nov 2026 16:18:31 -0800
Message-ID: <20261111001831.3710881-9-toddfreed@meta.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDAwMCBTYWx0ZWRfX2HCcR9d6eIVs
 nVAzJ551tICZpjoKBil307UsTQ5wv8wNWqkRDOcbBJKKMAqlvHUXGw2pm0rNtcrIcKBlsjZHT9G
 fdbTrVWgcOp3d0f91WYsaJ81E0rkuMg=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDAwMCBTYWx0ZWRfX/pNWHGRB5aNK
 i/lJq/hOg1HG40zTSjYlbX6EsJsapDZpyvLj1VIm10SZNn2sygkiQoNBhkOpnfCs7xlwGnUBYjB
 PiwhE9tYZr4hiyWNm5EgaNLzAcrYKn65B34xLgjhsdWRnIknsQ+B5yvztNvUXK1WRSaAKD1VrBR
 e3v+UM4uQZcXkIPHJaAsns/ETCJuVBS908M1pkJ6wE/cXjcZObzInLdtl/T0Mp/1FF7RJg9Mxmu
 ZMearJZLpaysNNMbMxknkdlFj3bB/T8P63L9RgrgMJ/e/VeEnF35IGI6bsTVokHZVNCniobJsmR
 VDBqo0wnpuHOIFPkXgptLVK5qlfZX54/XNGD/mwOYRtTwCndz/N76fJTvk1/cp/j3XtOde7QMSz
 T8404b+rakj1Ao0AcKFwEou7SaS36Jn34zf7RPeciemhPwMzmopvOsjU59u4Bjp/myCHI139Nhp
 fIqOJnqfkEnL+ETSzuQ==
X-Authority-Analysis: v=2.4 cv=YIgKWhGx c=1 sm=1 tr=0 ts=6af3b46d cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=855S8uPTkML1Oy45N9_h:22 a=pGLkceISAAAA:8 a=VabnemYjAAAA:8
 a=nThHfc4DiEoPSTtPicgA:9 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-GUID: X8TguCogmc0mmwFmypAnbm425qiR5iGT
X-Proofpoint-ORIG-GUID: X8TguCogmc0mmwFmypAnbm425qiR5iGT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-10_07,2026-11-06_01,2025-10-01_01

for psp tcp with tso,

 - __tcp_transmit_skb() -> tcp_v6_send_check() or tcp_v4_send_check()
   computes the checksum seed using the addresses on the socket and the
   total length, then

 - mlx5e_psp_handle_tx_skb() recomputes the checksum seed using
   addresses from the packet's l3 header, and the length of one segment

the length difference is expected by the device. however, the difference
in addresses is incorrect in cases where the l3 header daddr is an
intermediate hop, for example,

 - ipv4 source route option (IP_OPTIONS with lsrr or ssrr)
 - ipv6 IPV6_RTHDR header (conceptually ; ipv6 extension headers are not
   properly supported on this path yet)

in these cases every segment of the tso packet to go out with a bad tcp
checksum

the fix is to replace only the length in the seed which tcp had already
computed. this is also what tcp_gso_segment() does.

tested on connectx-7, with a psp tcp socket whose ipv4 loose source
route's first hop isn't the final destination, and the peer checking
tcp checksums in software.

Fixes: e5a1861a298e ("net/mlx5e: Implement PSP Tx data path")
Acked-by: Daniel Zahka <daniel.zahka@gmail.com>
Signed-off-by: Todd Freed <toddfreed@meta.com>
---
 .../mellanox/mlx5/core/en_accel/psp_rxtx.c    | 21 ++++++++-----------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.c
index 348fd7a96261..d9c2742b3c24 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.c
@@ -177,18 +177,15 @@ bool mlx5e_psp_handle_tx_skb(struct net_device *netdev,
 		return false;
 	}
 	if (skb_is_gso(skb)) {
-		int len = skb_shinfo(skb)->gso_size + inner_tcp_hdrlen(skb);
-		struct tcphdr *th = inner_tcp_hdr(skb);
-
-		if (skb->protocol == htons(ETH_P_IP)) {
-			const struct iphdr *ip = ip_hdr(skb);
-
-			th->check = ~tcp_v4_check(len, ip->saddr, ip->daddr, 0);
-		} else {
-			const struct ipv6hdr *ip6 = ipv6_hdr(skb);
-
-			th->check = ~tcp_v6_check(len, &ip6->saddr, &ip6->daddr, 0);
-		}
+		u32 seg_len = skb_shinfo(skb)->gso_size + inner_tcp_hdrlen(skb);
+		u32 len = skb->len - skb_inner_transport_offset(skb);
+
+		/* update just the length component of the checksum seed
+		 * tcp computed the seed with the total length, but mlx5
+		 * devices are expecting the segment length
+		 */
+		inet_proto_csum_replace4(&inner_tcp_hdr(skb)->check, skb,
+					 htonl(len), htonl(seg_len), true);
 	}
 
 	return true;
-- 
2.53.0-Meta

