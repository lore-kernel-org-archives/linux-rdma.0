Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.145.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795482418;
	b=AWu2kW1cKpyJGJd2cYkUMSPoD+bTr+B8OCywOulBgfu5kCpoJFL5EemP3R8NC+b7eX+u
	 96E/RKQGGmZUVI3L/qW6b8/8fvhK8sNfCyAnOOTELfi8YFjQruS+Ta6uPXgdl051yWZ5q
	 1EVoC4UYHGbUHF4VXLqWacYuwGjrqM5HgqO2jqS6ncRffULEcA5EracaD9UyRVo3iI0HU
	 LsNfn9QcWCkIEwAvZIEzpUCs1Bf1zPUMzeIXe3A7uRe+70vhBYS1LvJY42oHzBTAAJQok
	 H7KZU+IFeRXwGA2eyaZOfwE1BapbcQwkr8rHGWqOJVdq2t3uKVqlHiAf7o7skxWQhVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795482418;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version;
	bh=QHT0rvmcC9qCUpBpkxlzKkUjqaxaycX+hrp/rS/83Dc=;
	b=UIpayodVL83S8DZuT2lYLX8RlyUGsPztpTCNoaGAf7DSo9px1zoHCfUYFHInv8hclwDS
	 HXp4gFKs02BNAzFvv4kF81fhuk+DVQSd9uji0TvnxdKabW0x/HODvlkWmg1mgIzhgCzYx
	 AMD9x1M5E9pqyBBDVV35VtmavMlf5yfdtvk0r4zfIyq9cgQkyJzP+vQZ+BB7CpcZTuzQh
	 kR+kzRnHIJstAlKvyIYgIDFlR8Pnj3tHbVkGoty81sKFpFIxB+60QBbHi0yny4NCzzOxu
	 N5Fbo3zTszUT5OJ7ntCH+fKeAd70BmBn/Swi2DcteeZ/vlKpYsShi9J0JluN8SppInA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=lWnSZPKb;
	arc=none smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DA0606A32E;
	Tue, 24 Nov 2026 01:06:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 85DA0606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=lWnSZPKb
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ANMgw4j1868308;
	Mon, 23 Nov 2026 17:06:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=QHT0rvmcC9qCUpBpkxlzKkUjqaxaycX+hrp/r
	S/83Dc=; b=lWnSZPKbIAeHkM7aQP5LFHaic6o/DgLxj3FwMb5LqqNsT1Vv9V3Uv
	4R5XjRMAnTJtRIJsKsqIBbvM9wQ1Jpwj7JG2u0lIEhjEp5IkyAVR+m2eIOya8p8P
	Ky0D9Ai6PNRBYeZF7IX/QqZH5Ayi4j/w4MGyam34z3YRol4jANnj7jHZBrCJKr2X
	s+WI5JObGAhlob2IlqBBxVw/a8n7/wlZ8di1dsYU6LPeadhPGQyZ5FFBIATcGFKG
	EaTs965eGwoW7rti0ViwVvlFgrppS9thgPFQFasndYTigqaWZPtGQmj5L+/Gr2yv
	u/5OFdMjLBiSDAxdQiozC8Kp6E2PDp2ZQ==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j4eurqfrg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 23 Nov 2026 17:06:33 -0800 (PST)
Received: from localhost (2620:10d:c0a8:1b::2d) by mail.thefacebook.com
 (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Tue, 24 Nov
 2026 01:06:31 +0000
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
Subject: [PATCH net v7 4/9] ipv4: icmp: don't quote decrypted payload in icmp errors
Date: Mon, 23 Nov 2026 17:05:56 -0800
Message-ID: <20261124010601.3995693-5-toddfreed@meta.com>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI0MDAwNCBTYWx0ZWRfX8xTH7Pv7Lbl5
 FScw3tFCBw7bbKz6zs+IROdBWekBD466sVXBvquZdRXkdEfoaDKoa2nz0vi+4ZxlHPcf9F9a5Bt
 1aSBWf+wbGcFD0NiHJ52l9o/okrQa8VnnNjyP2ttVIRKkyYUy7RaHIakRF+3ReRWjemQtWIuLmN
 B89l0xyDx4cZy8RiRdvh1HkiSobV4Bjkyr2oQ/g3HFtxKvMCDyB+RNHoC1HQtLBeLuzOX5q97cz
 uRg3bvRsAVScTKVKpdTpu+E7n00b2qi5aWwIkzzXz5tolFIxVkpuO4lgi4P5Qfil8h3dQTPzCAy
 VDp/ZIpbz71U4z74Xu5P18AyjUddkLxQinbbGBgemEVeQJCWvmrZFOSY7Ie9sUu+ccg2gxa4IUW
 zpC00kRKYhxcyEv8aD3NPhbvE3M1acezkzQVmDyE6bsLrexFnMY7DjSzy5hjlE/WvFfCxc5/2wQ
 xBoib6NbXVRe2O8xxlA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI0MDAwNCBTYWx0ZWRfX5ritZ4iT1Up9
 N1sOWVmRG06sM/YnfDrZGJakynQULA92lgHl30cE8y36YYhe4qD/bzjqtSW1xe/Sln0cDZM7Q0j
 EGocsFRPUY539o0dst6pemOG3Jm70OY=
X-Proofpoint-ORIG-GUID: EbKGcpFvvs2SX8bGz8RsO8uIFDa274nR
X-Authority-Analysis: v=2.4 cv=APB/c4rM c=1 sm=1 tr=0 ts=6b04e319 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=7x6HtfJdh03M6CCDgxCd:22 a=8elwO82fXORLTBIkMd32:22 a=9R54UkLUAAAA:8
 a=VabnemYjAAAA:8 a=VwQbUJbxAAAA:8 a=XpATb4ERoM9YABf7QbUA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=YTcpBFlVQWkNscrzJ_Dz:22 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-GUID: EbKGcpFvvs2SX8bGz8RsO8uIFDa274nR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-23_05,2026-11-23_01,2025-10-01_01

An ICMP error quotes as much of the invoking packet as fits in 576
bytes. If the device had decrypted the packet (as indicated by
skb->decrypted), then the ICMP error is sending part of it back out onto
the network in cleartext.

The two offloads encrypt different parts of the packet:

- kTLS encrypts the TCP payload. The TCP header is in the clear on the
  wire, so a quote of the IP header and the TCP header, without the
  payload, would be fine.

- PSP encryption also covers the TCP header. The quote could include
  just the IP header, but then that's not really useful. Linux receivers
  want to look at the L4 layer on the quoted packet to look up the
  related flow, so such a truncated ICMP error packet is just dropped
  (icmp_socket_deliver()).

A decrypted PSP skb carries SKB_EXT_PSP, so the two could be told apart,
and an error about a kTLS skb could still quote up to the TCP header.
But then whether the TCP header of a PSP packet goes out in cleartext
would depend on the extension not being lost anywhere between the
device and here, while skb->decrypted is what the device itself set. So
don't send an error about a received decrypted skb at all.

On Tx, skb->decrypted is also set. An error about a locally originated
skb (skb_iif is 0) is sent in full as before, if it is routed to a local
address (RTCF_LOCAL on the route to the packet's source address).

iptables REJECT, and nft reject in the ip and inet families, send their
ICMP error with icmp_send(), through nf_send_unreach(). So now, a
received packet which the device decrypted, and which hits such a reject
rule in the PREROUTING, INPUT or FORWARD chain, or in an inet ingress
chain, is dropped without a reply, like a drop rule. nft reject in the
netdev and bridge families builds its own error
(nf_reject_skb_v4_unreach()); a separate nf patch applies the same rule
there.

Packets which weren't decrypted are rejected as before, and so are
locally originated ones in the OUTPUT chain, if the error goes to a
local address as above.

The next patch does the same for ICMPv6.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261023234640.1459291-1-toddfreed%40meta.com
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Suggested-by: Björn Töpel <bjorn@kernel.org>
Fixes: 784abe24c903 ("net: Add decrypted field to skb")
Cc: stable@vger.kernel.org
Signed-off-by: Todd Freed <toddfreed@meta.com>
---
 net/ipv4/icmp.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 90c0e22c29be..e11008aa4cec 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -979,6 +979,18 @@ void __icmp_send(struct sk_buff *skb_in, int type, int code, __be32 info,
 	if (rt->rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))
 		goto ende;
 
+	/* Don't send parts of a decrypted skb onto the network. A received skb
+	 * was decrypted by the device, and the transport header may have been
+	 * encrypted. The different offloads can't be distinguished in all cases
+	 * so simply don't send the error.
+	 *
+	 * A locally originated skb to be encrypted may be quoted if its source
+	 * address (target of the error) is local.
+	 */
+	if (unlikely(skb_is_decrypted(skb_in)) &&
+	    (skb_in->skb_iif || !(rt->rt_flags & RTCF_LOCAL)))
+		goto ende;
+
 	/* peer icmp_ratelimit */
 	if (!icmpv4_xrlim_allow(net, rt, &fl4, type, code, apply_ratelimit))
 		goto ende;
-- 
2.53.1-Meta

