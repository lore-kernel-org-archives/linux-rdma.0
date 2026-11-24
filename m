Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.153.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795482433;
	b=28DOdV6FKSkTPDXHBI3n4HFKSJWpeKqn5+IqrD+8M5gHPHOw3yBf3wIgRZrA4x+Juk2t
	 l/MS695/5l1/x9WBiOvBJqtM//z1cHov4Tb22wbNCELfD2FrcQuDi1Xi/xbhlXqLlCng5
	 C9pSmq60oxFvxz25YJQZBCnO/X1Fnx/uf4eNwYsHrc62nrl+2ILuJcmtagpPR0Um5RZpe
	 XWETcXjp6oNe0f6xFDaY77PyC4Epqs9YhCGPvxfUg20Ik5EhTOU/A/CEM8KPs9m/sbH6+
	 kB9ySLK1RvH/GThmSIbKQTe4mP67UeYp7Am1XnM3r7B/D//p10yAdMcGcvOf6xsxWJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795482433;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version;
	bh=YeHV7Op7NZOhpz5xRkPrpsuWyQC4bgaI84CldFtQozc=;
	b=zdNbt/dZ6QEMuoQQ+Kgh2hsTs30h+T1g/bk68ssyx5ttafo07fsBX+9vvJe/RJ4DsTvm
	 LfuilTVF06Xn2iOh9+JLAjXFGM6jRbcjmKK3BBK3hKiyZS+RTOmZkDwwXLvJlkvC8gj/l
	 mWlP8Lot5NAoYjySPccPLauW9y3eUZzNDSU/qIybZJy8hE4MD03Wx7Gqthufm5YDiDQNo
	 m6NFfP+zCtALanIDV5k7O8BCaVwXA2k5xwGUF/QTVQ13UYvZZbwCdX8yKIxYPAyUeRVOH
	 RQ4djJWoXy80YYVUoO3O53T+zcqj4TFlA+UbNxJZCP4gv+XUYdMIz1h0LuEmrU+t1gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=PfvVOBda;
	arc=none smtp.remote-ip=67.231.153.30
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDFA606A335;
	Tue, 24 Nov 2026 01:07:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3BDFA606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=PfvVOBda
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6ANJw1ne519510;
	Mon, 23 Nov 2026 17:06:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=YeHV7Op7NZOhpz5xRkPrpsuWyQC4bgaI84Cld
	FtQozc=; b=PfvVOBdafI2UTXdVCukPpSv7cCHn+cg2Bk7cJGcHAf0Btw0huzxNU
	ZhFNeyr5cSNYvxvjWsWoE3lH1Ohtr7VNjjLv7Wdi/s1nzo0mzUNgq3OcA5g2xGhw
	3NrA5mI57lv5oWnzSayXBkQL2e4W3Xv9s9BolU/+V/4uOnjVXxK/u5w/QG8Cnx2s
	OI76Q2yqoH91YDA48cYSXeB7t72bRQBt/kV6YoWCQ7y3xtlcf0oFSlOLnt6vMuIv
	Yn4jRFLyXeLiQvJDQLp4CXraMXJAQVKVaZ2RIvFV1D+bc+jQTlGnSdN+AXIgAR3x
	CTR0chkS+tvViBnmoTTCOdW0zq/Y+abgA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by m0089730.ppops.net (PPS) with ESMTPS id 4j37nse9tb-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 23 Nov 2026 17:06:34 -0800 (PST)
Received: from localhost (2620:10d:c085:208::7cb7) by mail.thefacebook.com
 (2620:10d:c08b:78::c78f) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Tue, 24 Nov
 2026 01:06:32 +0000
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
Subject: [PATCH net v7 6/9] ipv6: don't send redirects for decrypted skbs
Date: Mon, 23 Nov 2026 17:05:58 -0800
Message-ID: <20261124010601.3995693-7-toddfreed@meta.com>
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
X-Authority-Analysis: v=2.4 cv=b9gncdGx c=1 sm=1 tr=0 ts=6b04e31a cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=855S8uPTkML1Oy45N9_h:22 a=9R54UkLUAAAA:8 a=VabnemYjAAAA:8 a=VwQbUJbxAAAA:8
 a=8wgS_IX-37W2Gv-HzOkA:9 a=YTcpBFlVQWkNscrzJ_Dz:22 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-ORIG-GUID: JeCyvsclCCevEFZfnW68YU0-CXk7TpQi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI0MDAwNCBTYWx0ZWRfX2RFJ16vjcOT9
 BEa94gg4+U6LsuuhAlCVFPvRNv7ZmoHdzcfPmnCr0ox3nCTpnYFHxH1pm/h98tuPYqLD0v5hSmJ
 R0buJNBarP9bIA/yC3N/Wp99Bz9+2j5ViSurSQrqyUsV7tGAnijrhC3F+LECNzarCf3yOoKSflG
 qvTGFM6OuEfiUh991dlRt7/rW/zKTGltCRKGOHQ+b2gWR21ZRhSDpy3Nlb9wZ45fR4B4v25Fku/
 lJhRDwqmKhHAexyNrKFQkjmeJUTMUwPym/vUK2nFlzhIh0FyU5OCoi3heIIc6UOYTnsU6l0Q1/G
 DP46VTF7FIBhlk2HsxwJDBxQut7kaeKbWa4Sc3I/YQnjs8GSD6BzbcZHydvI5rNL7hG3fhWGKl8
 xnPR/8eyPTGVF1v9QVWn8nrTLmdE4idjvGce2tnbn6F2hYKf0J7eBwf+PBPwwZ09VVOP/qsBaBF
 CoyMPRIQjh2xzQPmPjA==
X-Proofpoint-GUID: JeCyvsclCCevEFZfnW68YU0-CXk7TpQi
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI0MDAwNCBTYWx0ZWRfX6G1/pMMdGMDQ
 mleJI7kIleOim6rjqbxsJz1bzqflXwdKcFgO17qq+XFLXbx1LLneCvFMLaNnhwX5TjVD3IGNV67
 mC3FPXOvmxznHXPTo73B5pYitt5ornI=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-23_05,2026-11-23_01,2025-10-01_01

When ip6_forward() forwards a packet back out of the interface it came
in on, it sends an NDISC Redirect to the packet's source. The Redirected
Header option quotes as much of the invoking packet as fits in the
minimum IPv6 MTU. If the device had decrypted the packet (as indicated
by skb->decrypted), the redirect sends part of it back out onto the
network in cleartext.

The redirect is built by ndisc_send_redirect(), not icmp6_send(), so the
previous patch for ICMPv6 errors doesn't cover it. On IPv4 the redirect
goes through __icmp_send(), which the patch for ICMP errors covers.

Both PSP and kTLS RX device offload can get a decrypted skb forwarded:

 - mlx5 decrypts PSP packets whatever their destination address. A PSP
   packet encrypted with the server's key but addressed to another host
   on the link, and routed via the server, is decrypted and forwarded.
 - kTLS RX device offload keeps decrypting a connection's packets after
   its local address is removed. With TCP early demux disabled
   (net.ipv4.ip_early_demux=0), they are then forwarded. With early
   demux, ip6_forward() drops them, as early demux attached the socket.

Note that the forwarded packet itself is dropped by
sk_validate_xmit_skb() because of skb->decrypted.

Reproduced with mlx5 (ConnectX-7), with a client C, a server S and a
peer P on the same link. On S, forwarding is enabled on the interface
only:

  sysctl -w net.ipv6.conf.eth0.force_forwarding=1

PSP:

 - C routes P's address via S:
     ip -6 route add P/128 via S dev eth0
 - C connects to a TCP server on P, with PSP on its socket using S's
   key.
 - S's device decrypts the segments C sends, and ip6_forward() routes
   them back out of eth0 towards P. S sends the redirect.

kTLS:

kTLS RX device offload only decrypts the flows of local kTLS sockets, so
the packets have to belong to a connection to S that is no longer
delivered locally:

 - S has a second address S2 on the prefix. C opens a kTLS connection
   to S2, with kTLS RX device offload on S.
 - S disables TCP early demux (net.ipv4.ip_early_demux=0), then removes
   S2 while C keeps sending.
 - S's device keeps decrypting the connection's records, S forwards them
   back out of eth0, and sends C redirects quoting them in cleartext.

With this patch, no redirect is sent for the decrypted packets (in both
cases), and packets which weren't decrypted still get one.

Don't send redirects for decrypted skbs, as for skbs decapsulated from
IPsec.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261117203137.804424-1-toddfreed%40meta.com
Fixes: 784abe24c903 ("net: Add decrypted field to skb")
Cc: stable@vger.kernel.org
Signed-off-by: Todd Freed <toddfreed@meta.com>
---
 net/ipv6/ip6_output.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 5b19683f08e0..d8ffe3837874 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -619,9 +619,12 @@ int ip6_forward(struct sk_buff *skb)
 	/* IPv6 specs say nothing about it, but it is clear that we cannot
 	   send redirects to source routed frames.
 	   We don't send redirects to frames decapsulated from IPsec.
+	   Nor to frames decrypted by the device: the redirect would quote
+	   them in cleartext.
 	 */
 	if (IP6CB(skb)->iif == dev->ifindex &&
-	    opt->srcrt == 0 && !skb_sec_path(skb)) {
+	    opt->srcrt == 0 && !skb_sec_path(skb) &&
+	    !skb_is_decrypted(skb)) {
 		struct in6_addr *target = NULL;
 		struct inet_peer *peer;
 		struct rt6_info *rt;
-- 
2.53.1-Meta

