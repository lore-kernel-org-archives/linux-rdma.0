Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.153.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794947577;
	b=GqB10nmv4rl0sbFlDgH9lHlcE7Qf3z6P4IdMek586TuGtkvwcLSR8fiGimJe3w0SKN7L
	 4JK2YfYowngx+jtf0vPJpoaIZGa1bDXlFQelnoG1AYwaz8XGXucMTUaKmKKgtAdPCs13p
	 UuoUzKrF+W36jHXqoDD82cCqXZ0inCJIpMY43qJK8nTVchTIrzXOPVPJREJN7JT8ODgRN
	 6b9OAd7148Tvwbbb7JuQsLMKVgBUejxhS8In4VoIcW+sZCRgFXrFkuEu7shFDLUbfE63N
	 g4n7HR2TPCnw3zeBuYp23km04/oOypwi01rHLs06qHbOQGc6YotLk5LJQBrOorEmR1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794947577;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version;
	bh=6SIudtgs2YGlgqJ+6vDOGyxYkGKGGmjE6b0tm7x7mzc=;
	b=beeOyn57pzL1NJYPxXfuG+qHpvDn3Gx4HUQTnr8hBO48PQXIGPvDJQDyyaDxV6oa0+hS
	 AtSyLoll8850l39lId4/MarRCprwONwB9fR7miEiaCntzOAysa+iNKvsAoNEgCGo4xdD+
	 X67XIbyDyjzRJmsWVTEjh4KfxhwatMQWIUmUGDmyNOH7r1y4BkRPmTYAsFlGk1OZRha9g
	 K9whmEv8F8bwZHPvrfTg8kH748APFMhlX45U7v9gW4x9mZx0P0g2gw+2+mbE0FRtt6sro
	 wM0mbPZ/GAK7tsFIwY9kY4S6VCRmP0iO9N2eKp1/1zPslTsrbi2YvHnwe9INkbJtE0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=WnfDsgPY;
	arc=none smtp.remote-ip=67.231.153.30
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9479606A339;
	Tue, 17 Nov 2026 20:32:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E9479606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=WnfDsgPY
Received: from pps.filterd (m0528006.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AHJ9Xdb740655;
	Tue, 17 Nov 2026 12:32:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=6SIudtgs2YGlgqJ+6vDOGyxYkGKGGmjE6b0tm
	7x7mzc=; b=WnfDsgPYdtNn4XnhntZOzN7oHcf4UF9ssAyGytWxc7iubO6wWZcdn
	jsSiMzvrcMjcJUDF4R56SOh7r6dyHPA2y/vt0ednzT19YApsBifvcozU46TLJBv8
	fHClv9/lh7kbzNqnJFkAn2niytAYlbOYX3DwPj1/uaVEAmhpQAH3PR1bx/N75x1A
	oWwcbCv+S4Kw7cxHwI624CzCjj39MXUQv9qyhD5C4XEyZQUivDDuLaUonM9PIeHt
	OpeWwDClN8gASdTNS43bGXATpeH6dbBK27pZexghOvQO8cZ9HiOcrE7KognhgXRl
	e+qdzLT4nX1E7gyPqrzFHOW+aqGQw7nDg==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j0r2u4dy0-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 17 Nov 2026 12:32:34 -0800 (PST)
Received: from localhost (2620:10d:c0a8:1c::11) by mail.thefacebook.com
 (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Tue, 17 Nov
 2026 20:31:46 +0000
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
Subject: [PATCH net v6 4/8] ipv4: icmp: don't quote decrypted payload in icmp errors
Date: Tue, 17 Nov 2026 12:31:33 -0800
Message-ID: <20261117203137.804424-5-toddfreed@meta.com>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=fuhJ914f c=1 sm=1 tr=0 ts=6afcb9e5 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=7x6HtfJdh03M6CCDgxCd:22 a=kkcUborcUVj0H7zxAXTl:22 a=9R54UkLUAAAA:8
 a=VabnemYjAAAA:8 a=VwQbUJbxAAAA:8 a=XpATb4ERoM9YABf7QbUA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=YTcpBFlVQWkNscrzJ_Dz:22 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-GUID: 24byZMD_LLqqBxO-wXJqwZ4rqOuGcwGh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE3MDA4MSBTYWx0ZWRfX4ZVexaVWpby/
 qIHOPaXlaiW7+Lk01bbME1hH1tUuTbzqyguijK4ymO4/eEuGqNm6YZHx/PdyZDFPupMYPw3EEH+
 qmpunjnabu1lU7Prq5ACTlIB0tV3b04uegVfmgGTjvcLbhPv3T0B1q7tzo8WX7NeVvePsCaNQHB
 EohpooM7W7FtrTWEXfadRUSYrimfJ6M0lHegvbDVLTrf5dPUMzRAQXSvE9/82lGvEWEBwFgxhud
 bdBrv9R+eYrjMoxQ3LaUmAJzk2XGEGyHYbpnnTo6uZC83ri/obvU91fAocT3AFJoz8Dug9K563y
 rh1VwZJD4XbmI2Ofmop0gLPJUte6tJ3MweHtKB8J4XIOVRGYcKDDrakx9y1guRJ3fN+mC3chTqV
 bBMh0BO1Xnr3+azldWhDcmjzG5A7/WpGreMoJCzLvmnNSGS4LZD1jSguckPk1vJf77b+x3foNMg
 CzgI4mZ2lBMuAb5arrw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE3MDA4MSBTYWx0ZWRfXyHpeeapDItKN
 80mJR+dkgqOBhFAHL3R2RJRIKAYJr5MX+gE8QYvkJiTt9lgZpFu6FgO9NlTe4TB4e6rdvSx83Cr
 XptBpEjmh8TRjbZ5egAIPs73km9X5C8=
X-Proofpoint-ORIG-GUID: 24byZMD_LLqqBxO-wXJqwZ4rqOuGcwGh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-17_04,2026-11-16_01,2025-10-01_01

an icmp error quotes as much of the invoking packet as fits in 576
bytes. if the device had decrypted the packet (as indicated by
skb->decrypted) then the icmp error is sending part of it back out onto
the network in cleartext.

the two offloads encrypt different parts of the packet:

- ktls encrypts the tcp payload. the tcp header is in the clear on the
  wire, so a quote of the ip header and the tcp header, without the
  payload, would be fine.

- psp encryption also covers the tcp header. the quote could include
  just the ip header, but then that's not really useful. linux receivers
  want to look at the l4 layer on the quoted packet to look up the
  related flow, so such a truncated icmp error packet is just dropped
  (icmp_socket_deliver()).

a decrypted psp skb carries SKB_EXT_PSP, so the two could be told apart,
and an error about a ktls skb could still quote up to the tcp header.
but then whether the tcp header of a psp packet goes out in cleartext
would depend on the extension not being lost anywhere between the
device and here, while skb->decrypted is what the device itself set. so
don't send an error about a received decrypted skb at all.

on tx, skb->decrypted is also set. an error about a locally originated
skb (skb_iif is 0) is sent in full as before, if it is routed to a local
address (RTCF_LOCAL on the route to the packet's source address).

iptables REJECT, and nft reject in the ip and inet families, send their
icmp error with icmp_send(), through nf_send_unreach(). so now, a
received packet which the device decrypted, and which hits such a reject
rule in the INPUT or FORWARD chain, is dropped without a reply, like a
drop rule. nft reject in the netdev and bridge families builds its own
error (nf_reject_skb_v4_unreach()); a separate nf-next patch applies the
same rule there.

packets which weren't decrypted are rejected as before, and so are
locally originated ones in the OUTPUT chain, if the error goes to a
local address as above.

the next patch does the same for icmpv6.

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

