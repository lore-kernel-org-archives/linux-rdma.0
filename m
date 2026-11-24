Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.153.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795482433;
	b=BWlQHGqHtkqBGHeDH3NUDqrK7We13Qhz9Vu0JNN7Mj4j1gVbwRM0LG0SHZm0aH5N/C4U
	 9qz7n63vsoB17Ar6q7wHSfBlu9kEuyqEpwmzh1cnCzadOyPUEkFN6gglxcuhBf0aecr92
	 yd9VXWpsSD4v4u/E7fScxX3Jqjpn6Uen2s+n3Y3w575w3BAwD8rU48GZIRBW/LtPkCxaY
	 8uSsDj5SIiAZJvEY9vj4XdFo4I+7qkJSwfh6Sr3NDSGDnouhNq0gd1vV4/jBE9alaI5iN
	 KHLt7HY48ck9qcPIQTefE4gFWtUJ+MyfjRN26+MwpPeiU4hFnZyD7wZdma0cQdedmlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795482433;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version;
	bh=Rzaxe58yZwTymWc+eCu0Ph4sVWiuVqRd+k5I4OkUVPY=;
	b=4dKlO9MenoyMQR9vP3zkbCpJ0jWFzaJy/dcCN/br7v8nB86tp1OSbfVdKkAGMvp65vKx
	 oyEUfv29WOKoN1jGAQrB6DpdM4BAEvFxUjYOPLcC+lqYLmjtjlrkthqDi6WGieBo9PfBf
	 jc5Z/+CeREJC8n2yEF+OMPVEu4uO6WqtXtjVkZJ9WL1pPN4yFwVPZ478iBbtnAcwR6EZO
	 YrjKYc8nTPZcfL8fB71x/CHTbxu5JnM5F1un0wmld1qngUjMMXVaNPY7xpUfLYqPM4Z8f
	 GMMPqIFZNiSJJDe701nieMtsv7etCtjMKYig1lAibXLMp8kfoNpVnGNk6Xh0WGcLI2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=Oxzn75su;
	arc=none smtp.remote-ip=67.231.153.30
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AECE2606A338;
	Tue, 24 Nov 2026 01:07:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AECE2606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=Oxzn75su
Received: from pps.filterd (m0528005.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ANJw5WB1624682;
	Mon, 23 Nov 2026 17:06:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=Rzaxe58yZwTymWc+eCu0Ph4sVWiuVqRd+k5I4
	OkUVPY=; b=Oxzn75suDwdnCmfowKZCpGManyM3FF1zpWn6Fjf0sQJ0BRtQh0UEy
	N8gMOYSmCtjYt9QZ/G/FMVCnvQCMbpGNvF33sWsQPzi0zDAjyP+wXiuh31QPRoc8
	tmpjRe+4MiMFgXwMf/qLdD+J35f7Li4n5hywaujz99S+slzUnTTmKg7X3l/iZBPX
	tldb40F7M9VmGSwfj39u9MWJhO2Y3ScgpM4EwGEpE0WyZBLrRoIDS9RRBN4SGEgV
	ux7H1+GWv2HGAOK1AYfXtCf92lZkxPrUpj7pqpvwvYMJw6rTwYAPouEOGxcF5I8g
	J5LbEiuC6+TnPsdbCteB++6MNrCk8DHuA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j3wrnjhyf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 23 Nov 2026 17:06:41 -0800 (PST)
Received: from localhost (2620:10d:c085:108::150d) by mail.thefacebook.com
 (2620:10d:c08b:78::c78f) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Tue, 24 Nov
 2026 01:06:40 +0000
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
Subject: [PATCH net v7 9/9] net/mlx5e: psp: tso: replace only the length in checksum seed
Date: Mon, 23 Nov 2026 17:06:01 -0800
Message-ID: <20261124010601.3995693-10-toddfreed@meta.com>
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
X-Proofpoint-GUID: 5kSimBlrXbr7rrcgF3ZTqiaVAHzewlmY
X-Proofpoint-ORIG-GUID: 5kSimBlrXbr7rrcgF3ZTqiaVAHzewlmY
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI0MDAwNCBTYWx0ZWRfX4k7GSbn4lgSa
 cI5xHvawTs5FLGnwwvn9y3MAXz2g1NtEIsk1PAxRHlHPxzoFLDfccyf9YOrNRM2nJAtsiDD/w8E
 xB10tc79wGDtHlm2LBvZp2iElqdnOTY=
X-Authority-Analysis: v=2.4 cv=U+4Hnuru c=1 sm=1 tr=0 ts=6b04e321 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=jCddH8ec0KUNCymVuxII:22 a=pGLkceISAAAA:8 a=Ikd4Dj_1AAAA:8 a=VwQbUJbxAAAA:8
 a=VabnemYjAAAA:8 a=7k8tMiApcetw5dAMLJwA:9 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI0MDAwNCBTYWx0ZWRfX4KK00GlolJDN
 nZnCaxlHYwStl4gn1Vi2vGhJImIE82Oit+SBheojVru5YvSXoZqts+fvpcbgQsrTbhKtLbIwF3l
 BrwF6ercsgHk5itrptgpCqrhg7J1QVNExcY0zaAHiQYNasHF/jOkXViKdU5SWzPyDpmbi0IwXjb
 FNoYWaLQjduFqgvXXiY7v4pVpCsUgNIi4K06Zz05RyKtXvR+CCI8yixHiZA4RQvB4w4656WzoCM
 YrNCEkUmqSMBdDq20odzesI41yn6Hhp3jv7N2km3TbDdM/e+sYbUW9vVXypo9msYHqqeA5Ag1Js
 ss+F/hvVQqIUkN2qi/vzLPhPMRqyarBJ6pA72QqJZZNGsSsyy7yV9fUs/UZQkNeGObLrlJjFJfB
 LqF0lli5F4vAMowIplXH2rreR2TpQPpRvPmgehmZLQl7bWNJVm1Utvm8Yhnitt/a2tfxmKf++5O
 2YhScX/fqQWBUhwuA7Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-23_05,2026-11-23_01,2025-10-01_01

For PSP TCP with TSO:

 - __tcp_transmit_skb() -> tcp_v6_send_check() or tcp_v4_send_check()
   computes the checksum seed using the addresses on the socket and the
   total length, then

 - mlx5e_psp_handle_tx_skb() recomputes the checksum seed using
   addresses from the packet's L3 header, and the length of one segment.

The length difference is expected by the device. However, the difference
in addresses is incorrect in cases where the L3 header daddr is an
intermediate hop, for example:

 - IPv4 source route option (IP_OPTIONS with LSRR or SSRR)
 - IPv6 IPV6_RTHDR header (conceptually; IPv6 extension headers are not
   properly supported on this path yet)

In these cases every segment of the TSO packet goes out with a bad TCP
checksum.

The fix is to replace only the length in the seed which TCP had already
computed. This is also what tcp_gso_segment() does.

Tested on ConnectX-7, with a PSP TCP socket whose IPv4 loose source
route's first hop isn't the final destination, and the peer checking
TCP checksums in software.

Fixes: e5a1861a298e ("net/mlx5e: Implement PSP Tx data path")
Acked-by: Daniel Zahka <daniel.zahka@gmail.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Cc: stable@vger.kernel.org
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
2.53.1-Meta

