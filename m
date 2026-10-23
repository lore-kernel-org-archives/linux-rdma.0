Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.153.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792799260;
	b=IKdewoyHqnXOiFIykjgZIg/3m5JDRvvaxmc4OXwg4863MxGes5FT6Fl6zLVs11T00T9d
	 CkLQcH1VwrZsttyanjak3Do+l2JkHmfPCWpBVn11VxqiwlDanrEgsXNzfLBTGkH/Q2mrA
	 UB1eoA1w4/QJlQZgVz3/8DUbwDs/7fIvT9YfaMUorEAF23IGKCcqo/gmZWunGE0kd0CAS
	 UR/TfNFKdMxdC7sqa68B9G9OReQHnB20hiFA3O2gkS1fVXMbw9K9s0QZoGfMqci2vbDt6
	 HMK/d9Eycd8L6lhwJ/iihX6nlecoQrq7clBLjoAN88pLFVbv29528jVxYyKP19qsViA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792799260;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version;
	bh=nTJPl627ch8t9aT0tW3Xj+7EnAYznk35syK+m0yp0bA=;
	b=PZsawCPn4VieEPGgaEDUs/vUUGmzVm3m3zq8QLixO6Fiki3wztB3RUGu4w8Lg8E9xvgw
	 lL1uSIj/VdrdS6hGK30uR54VgzotrSCvz/gX3uh3+ef2H2qIdNBEVwZ/kXkDghkm3aPUi
	 FwSU2RjCukEvGoJQZFAYF7+z7D0hfmGJnrYbNidgheg3pP7/SNWtgf6HgIuI0UXt11Fj6
	 o9jy3/TatFLZTovaIZCBKd29B6EsHhOvAtNs2zzYqlEtoEfHNYZjvyV8+fP4ZRPuWaKl0
	 ZhyWpSW+z1R1ePho5TpNKAOtoE8uU6sL3nTUP8DzBjB1Q8seTT6ozG2Buxtji4dGTVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=PS7bvOvx;
	arc=none smtp.remote-ip=67.231.153.30
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4569606A31B;
	Fri, 23 Oct 2026 23:47:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4569606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=PS7bvOvx
Received: from pps.filterd (m0528004.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69NLwXPj1271164;
	Fri, 23 Oct 2026 16:47:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=nTJPl627ch8t9aT0tW3Xj+7EnAYznk35syK+m
	0yp0bA=; b=PS7bvOvxYDxSlnQsvysNE3HX6hGiEw+KKW69Etu+/b4JPtJNLkqex
	JEN1bZsdzwy9X3rdufErCTRw4WVj9FAiWIjT6W78DPlkQLNHv7olggfptFwH1RxC
	XEwhg3KyUjX9mteboCR6QW/Z503Q46GiwSuwHJ50sNfM5N9M4nwc6LMJCdjbgJOf
	SO9y+p8qn+jpTeOZ8haCPGq+6J/TqN35AxKJFwQuoZ+5ertiw2f6rflTxEipQyKL
	/TmCTVLD3YCa8rQFkHhakzMGbF5NUl0t9iqwNf92janZ/s977GOlH/k4fsP2hwqF
	sXN1AXIO65Gy/pBSBBSS+ozu7+t4ZL2Yg==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4hfjf5vpdt-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Fri, 23 Oct 2026 16:47:30 -0700 (PDT)
Received: from localhost (2620:10d:c085:208::f) by mail.thefacebook.com
 (2620:10d:c08b:78::c78f) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Fri, 23 Oct
 2026 23:47:28 +0000
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
Subject: [PATCH net v3 1/4] net/mlx5e: psp: tso: replace only the length in checksum seed
Date: Fri, 23 Oct 2026 16:46:37 -0700
Message-ID: <20261023234640.1459291-2-toddfreed@meta.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDA5MyBTYWx0ZWRfX8ALj3kzCwkt8
 K8Sw98KT79HGmHV9snftKryMH8xmNYZeMNne9Nat5tlqD3XA+aTL78BgEHKEri+cP0dA4CUVUa7
 9LvFAYVCTCUZYG1oZr4FkmDMIDNBidijEk0Kba0EdUQM8bsbrKoMKV6JJMQ2hzUX2GUs4T2P9lg
 czFgRXshW5wMDxrfIWelSwsqckNiCEjENSkareZwbcaIVbLw/0J6DRRLdLVRNR8vQMEWNQ0+1sF
 riOwrMc621nygLkzp0VpETR+bWzJHR+BPfV1vgPGuLQLCv+aiiVIT7GEJcu0V6MZQw9tcRCh4sr
 0YaQzUUS+KkzCUQGULLnxVqSSWmXZc4zaB6ZgzBEFHb9jx5fHm+h2McbYmrziwsxH9yYzdYNSHE
 m1goVBMub8hw8YCoAW6JQl4lBKS9bUPwRHRR92v4y/f/Gq1ZXQxXEju11wDzzeRhbeQkFFU6U+V
 nDZ4WAkKb3wJ4EZsiSg==
X-Authority-Analysis: v=2.4 cv=fNisTpae c=1 sm=1 tr=0 ts=6adbf212 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=GbPsI2Ihf5RTnMjR_gZv:22 a=VabnemYjAAAA:8 a=nThHfc4DiEoPSTtPicgA:9
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDA5MyBTYWx0ZWRfX8yaQ3Pm3Me8M
 Z0DmcAbvsLNiuGM7STHAXtsisi0gu3bwY3qXgNQ97YOix5PEVjBQ2dxpvYReAnr1APQV6o/FkHE
 ybCuIY+LqGdUpWPVSOVj3T4vNrk7Y94=
X-Proofpoint-ORIG-GUID: y2O7U3Y5eZ5n9ORmpfCoslgCUZorZ1AY
X-Proofpoint-GUID: y2O7U3Y5eZ5n9ORmpfCoslgCUZorZ1AY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_06,2026-10-21_02,2025-10-01_01

for psp tcp with tso,

 - __tcp_transmit_skb() -> tcp_v6_send_check() or tcp_v4_send_check()
   computes the checksum seed using the addresses on the socket and the
   total length, then

 - mlx5e_psp_handle_tx_skb() recomputes the checksum seed using
   addresses from the packet's l3 header, and the length of one segment

the length difference is expected by the device. however, the
difference in addresses is incorrect in cases where the l3 header daddr
is an intermediate hop (e.g. IPV6_RTHDR). this causes every segment of
the tso packet to go out with a bad tcp checksum, in this case.

the fix is to replace only the length in the seed which tcp had already
computed. this is also what tcp_gso_segment() does.

tested on connectx-7 with the rest of this series applied, with a psp
tcp socket whose segment routing header's first hop isn't the final
destination, and the peer checking tcp checksums in software.

Fixes: e5a1861a298e ("net/mlx5e: Implement PSP Tx data path")
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

