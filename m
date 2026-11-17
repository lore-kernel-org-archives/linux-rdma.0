Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.153.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794947575;
	b=W9vZJxwfVll+RI9+OgY9KYZ++Ng1ERAk5qEtZCN30JXLN6u1IbFBCascnlMzYwJVRiqx
	 WR3JQjuoJDSbxDUWRYqTr1DpFx6DJMbmrX6IqPt4NaUKJ0nQAjgLEw45v7NbhQ/2FqJPB
	 CTvmmFh3rdvonAtjPgVBnrk4AfW8nGQG4LrJuTUFr8AdhZoaAO8OSXNsuJiyngzvVW7xt
	 rH7piCJtkf/c7W0zYxwBr1L4TZiKpjlNADfzsb6SXvwthVU8/Tw/Wj59qO9j62sHbZ5cV
	 fUGKDHKi0o0aaTfi0a9A3rqFP6FbhLWNb5s+XZ5fcOrxw4DV3+mkKKWp/5UtyeFHpAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794947575;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version;
	bh=UTEMOblH/VihvxNhVSH4vDNOlT/5rl5B3v1mDwWjQNc=;
	b=0oaxqkHW7rVPMgxzXqEzDDJ8n60YUIOnDM5e8o37acRQxTL9JAMMTHU1pvLcX474hnow
	 QUAQRhLjVYAN+6RIhlJPKSuMWjg4HO1y0Xldkibx715UkxQMv9LlPkaDF7cTWEbmd5rTk
	 p7lrKL/iBl66POkttml2iKpxELFpZ4E311PDrjY1bvokllznlNR/wRYTtC2xVNcMQJ0V3
	 wHFey2RkUkMNcW/1Dt1+1KdmOeHyWEYT/suczXfq37vRaEd0b96sw9eYAG4fvBRHhCKII
	 XutAywn+ekpTZT9Zw1E6Nk5fAVjIR3WaUMQDC2OFAYjPxQrOZCv7D1VmiujmfxsY4sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=jcnmHeeG;
	arc=none smtp.remote-ip=67.231.153.30
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A53606A31C;
	Tue, 17 Nov 2026 20:32:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 34A53606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=jcnmHeeG
Received: from pps.filterd (m0528004.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AHJKYQf1701724;
	Tue, 17 Nov 2026 12:32:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=UTEMOblH/VihvxNhVSH4vDNOlT/5rl5B3v1mD
	wWjQNc=; b=jcnmHeeGBVKHKhpHpxJ4RvZBbiwMnoYmavRCvIl+BllCT0CirvQRp
	sizMtW8meF+KwBU7AAWNExkjIwuBWXW+ITQtgZwv8UggMyrPCZA1AhuxJVSVv5Wm
	HOiCqHmqTqDZopF9LvEKabAnbAnA0CSzgCpW2ZpCqNdhu8A/lB35CMdpt999LiVY
	QRfGPQA+/ZhFC6dMADtZeRptJ8OvsS9Gh0qXt876RZdRMaRUwm+7KqD3PR7V56Ni
	ia1v6skPTprajLTqCnNdtEcvjTjsOQ+ongQRdSnB7FsihlmPl8qYMs2+YpQ62OHb
	NpRhcgg3/XTpOyulKQtSX4rPEKYFqDe8Q==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j0w0brvgh-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 17 Nov 2026 12:32:40 -0800 (PST)
Received: from localhost (2620:10d:c0a8:1c::1b) by mail.thefacebook.com
 (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Tue, 17 Nov
 2026 20:31:51 +0000
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
Subject: [PATCH net v6 8/8] net/mlx5e: psp: tso: replace only the length in checksum seed
Date: Tue, 17 Nov 2026 12:31:37 -0800
Message-ID: <20261117203137.804424-9-toddfreed@meta.com>
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
X-Proofpoint-GUID: aTw-mv_vEeF9n33yYOnNLmCaSJuB8HJK
X-Proofpoint-ORIG-GUID: aTw-mv_vEeF9n33yYOnNLmCaSJuB8HJK
X-Authority-Analysis: v=2.4 cv=NM1AaE6g c=1 sm=1 tr=0 ts=6afcb9e9 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=GbPsI2Ihf5RTnMjR_gZv:22 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=VabnemYjAAAA:8
 a=nThHfc4DiEoPSTtPicgA:9 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE3MDA4MSBTYWx0ZWRfX24GpxoqCJlI4
 /EY4M8A6hfunbHQDsj3xYURMwl/HyKt5yztK2CIoDytswzQhT8PHaiTZ//izey5JYAKxSsjtYd+
 GvOeE7bP7QqE5lx07cGki4ZJw3NbC70=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE3MDA4MSBTYWx0ZWRfX8+61FN2XdG53
 VPerl7sT2TJT8w1WppfTmtgiuVIw6EeNa/DlNf/tqFI8ihNNR/DYdRGCtIqMFuUpy86s5pmTyBL
 9nK/LjpYXhwa7fn2F8p9symlZ8NCKQYJ9vRhWxtGdE5ZrsEC0myhFZ1yUFe428Uz8atdlt2kpDa
 5/caL3Vbd+MmFa6u4NHyPUTaYX8aulY7oNRvU6fDCWCaxL5Nr9gAccUJ0p9dBa1z0nQAdIaSIRa
 KCu7kGwdYxq5wJfdHh8lSqjcOnRKZrojjOk8MA83dlBxNvNMcxf8uMc97mdCX0N8+XaJ6orJVgx
 TX72/VXcGbAzq+Xa8xj6FOaroD2wNQp0NTf81oWVJMqXUy7iAR3QmraCZ1ZSuCV8n0ayEzUaQnm
 hc3FbGoYY+Hdmy88Ntnx4DiqQ13qB2ofLbuW9n8LqQ/j1D6Pahl4/5e2cLAaHnlVI/z6qNsZbEq
 pBZW4Kytss/YeMRu2SQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-17_04,2026-11-16_01,2025-10-01_01

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

