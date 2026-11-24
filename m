Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.153.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795482428;
	b=wXEupjajEU77F1dYZIfY8BjpvQR95j2CBQsMkifUYHYOy/BLBlelUTY0EaJfYBM+KPUx
	 tueG9U2wONKqQM0M73efFyC7flCDmWaE99M/XVzAOVw8Z3FAaAOK0EGDNd5ihAjp8Tq1u
	 bqgoBNnYIiPNmGbajk2cDK4/XkmdhlXHub1fociT+J0gqe4GReYIZIpkfY44X7i5UcFso
	 7yZFzPlO6QvIKxSAHGNnKurdiewUY0Z7hdMQFtf3CFmkjbJ5pQOJBK1/wph5jLfw0Ae3T
	 quLyUTmUujX73QTzYVstnLyIO45ZhAk8/vesWOT8lNZEif637SWeYt9ncUA4RnpBBOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795482428;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version;
	bh=btl6OGLnZ1Xmv755a03IlB7DQcardbFxR+NdLFEalZg=;
	b=jKuJFY40f2zAys3BvuYt/AGX38m8UoiTgdZGU4nX9n+y7nNzau4m4uPnU7J1wzoe+omO
	 G/1mmej9BEqW86x6NTaSQJhIqPZxYpCGsCADhJe+Lzt0ko8kM2w6VVUj98s6nU2eYt2an
	 9PF8ondlww6qOkxh3tUrlcPde+2iYIrpSAZ42ema4WxoQsZ3U15vggXOGaY1PQ1e29xYB
	 B2AQG0NgmEvFe3gKCg7v9cGyLtB+x8osNla+IdrM6CVv6qeGovn863ly+0YJeYw8J1TmR
	 pLJ4G32Uw4OHBlKGh8X/owwiXgVcobM9Aee3XtW9Xm1WSZENXz5u6CrxyZTUIJ0+fEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=WyHDguyt;
	arc=none smtp.remote-ip=67.231.153.30
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DF5606A32C;
	Tue, 24 Nov 2026 01:07:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 85DF5606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=WyHDguyt
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6ANJw1nd519510;
	Mon, 23 Nov 2026 17:06:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=btl6OGLnZ1Xmv755a03IlB7DQcardbFxR+NdL
	FEalZg=; b=WyHDguyt76BBMP97jpU1q0lP9WglxSitFy4h87x/BL1psT/laFLEO
	BOcARW1y+YIDRNnvZY1Pz6t3+lEUe7Z1zoia0Pxl+7ANYW0dl3vRwY/BFQxvnSDg
	dwkj7OVbZWvUpJHeoUcklmYNqWmUQpETpCqyRx0gavaMINJrE+XmvzJYsOXk+/yC
	Y9jbgQuoxZr0vs/34aUTg13NNtI3NTh0KUT82y44XD8avRxhj/Deii1s5DaBgfC7
	ZkVEe/LGy1B3HG2KPePbumbQ8LEN5+TRjvEASiX9VwxhgvhKgz3MbyJh4iVlZOnY
	Q+alIVb/rW76WapOqUw3OsCZy4h+PP+6Q==
Received: from mail.thefacebook.com ([163.114.134.16])
	by m0089730.ppops.net (PPS) with ESMTPS id 4j37nse9tb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 23 Nov 2026 17:06:33 -0800 (PST)
Received: from localhost (2620:10d:c085:108::4) by mail.thefacebook.com
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
Subject: [PATCH net v7 5/9] ipv6: icmpv6: don't quote decrypted payload in icmpv6 errors
Date: Mon, 23 Nov 2026 17:05:57 -0800
Message-ID: <20261124010601.3995693-6-toddfreed@meta.com>
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
X-Authority-Analysis: v=2.4 cv=b9gncdGx c=1 sm=1 tr=0 ts=6b04e319 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=7x6HtfJdh03M6CCDgxCd:22 a=855S8uPTkML1Oy45N9_h:22 a=9R54UkLUAAAA:8
 a=VabnemYjAAAA:8 a=VwQbUJbxAAAA:8 a=XpATb4ERoM9YABf7QbUA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=YTcpBFlVQWkNscrzJ_Dz:22 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-ORIG-GUID: DlMp8ZS77nIOB3SKP2hX9wjfuzIuw1hd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI0MDAwNCBTYWx0ZWRfX+qcsw/oRauKi
 bc/DmUHPJ3/A6b7qIC3UaU9+vbMf3Fgzn1vGZl9T+2EkuLTRcby9q3/lubbD5TlE6A7ggEi9fRP
 4SXSwn4N9xhYU8qHRfjsmDrHrdyzGfjIZCAsFWTgqFV5InmNEXSUuCWQT5IhJa7hdzVl7RukXBE
 tZagoK5pe16cMAygprd1VJYXFz9OvD9o9Q3+cLP6CsnnHGQaFTNwXIpanKg9wliLywFKTZMrZMa
 OG1diw1RoQgWhYaaDBCwDyc6nx5jRxl0nAW56cxbZI6qoONirHNF72yR9VcrWmW4kd2QV25N8YS
 RHaxFdta+QH+CL2M/BJj5ZSmFYBlcbUMeI7b5B7LyBQKpFHHmjwTivNp1F9+PgCXqHDyvcb1SOo
 z2jUrAchGnGEKFxmUQ116mMffxJk1F8CyICRMyZLQrv60IxhZcJLLt2RlmNb49Q4R80c5gs2Dvz
 M2E2aVDp7UIaHdfEMrA==
X-Proofpoint-GUID: DlMp8ZS77nIOB3SKP2hX9wjfuzIuw1hd
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI0MDAwNCBTYWx0ZWRfX8UV2vPfIZjwk
 70gFpe010hjQR/yvxPBKb5fqptkkJp2v/tikyFm2q8Fx8fJ/tYCQpYlwk0amWaTKykPf5Cviuo8
 RT/nVPC7OROXh+575IFztxeNef5H7lk=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-23_05,2026-11-23_01,2025-10-01_01

An ICMPv6 error quotes as much of the invoking packet as fits in the
minimum IPv6 MTU. If the device had decrypted the packet (as indicated
by skb->decrypted), then the ICMPv6 error is sending part of it back out
onto the network in cleartext.

As in the previous patch for ICMP, don't send an error about a received
decrypted skb at all: PSP also encrypts the L4 header, and telling it
apart from kTLS Rx device offload would rely on SKB_EXT_PSP not being
lost on the way. Linux receivers would drop an error whose quote stops
before the L4 header anyway (icmpv6_notify()). This covers ip6tables
REJECT and nft reject in the ip6 and inet families; the netdev and
bridge families are left to the nf patch, as for ICMP.

On Tx, skb->decrypted is also set. An error about a locally originated
skb (skb_iif is 0) is sent in full as before, if its route goes to a
local address (RTF_LOCAL), like RTCF_LOCAL in the previous patch.

An error about a received decrypted skb is dropped before the rate
limit, so that it doesn't use up the peer's and the global ICMPv6
credit. The check of a locally originated skb needs the route of the
error, which is looked up after the rate limit.

Like the other cases where icmp6_send() doesn't reply, log the drop with
net_dbg_ratelimited().

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261023234640.1459291-1-toddfreed%40meta.com
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Suggested-by: Björn Töpel <bjorn@kernel.org>
Fixes: 784abe24c903 ("net: Add decrypted field to skb")
Cc: stable@vger.kernel.org
Signed-off-by: Todd Freed <toddfreed@meta.com>
---
 net/ipv6/icmp.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index d8203ebad882..9fe95a4774fc 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -778,6 +778,18 @@ void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
 
 	np = inet6_sk(sk);
 
+	/* Don't send parts of a decrypted skb onto the network, see
+	 * __icmp_send(): no error about a received skb. Before the rate
+	 * limit, so that such an error costs no credit. The check of a
+	 * locally originated skb below needs the route of the error, which
+	 * is looked up after the rate limit.
+	 */
+	if (unlikely(skb_is_decrypted(skb) && skb->skb_iif)) {
+		net_dbg_ratelimited("%s: no reply to received decrypted packet [%pI6c > %pI6c]\n",
+				    __func__, &hdr->saddr, &hdr->daddr);
+		goto out_unlock;
+	}
+
 	if (!icmpv6_xrlim_allow(sk, type, &fl6, apply_ratelimit))
 		goto out_unlock;
 
@@ -799,6 +811,17 @@ void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
 	if (IS_ERR(dst))
 		goto out_unlock;
 
+	/* An error about a locally originated decrypted skb is sent only if
+	 * it is routed to a local address.
+	 */
+	if (unlikely(skb_is_decrypted(skb)) &&
+	    !(dst_rt6_info(dst)->rt6i_flags & RTF_LOCAL)) {
+		net_dbg_ratelimited("%s: no reply to locally originated decrypted packet [%pI6c > %pI6c]\n",
+				    __func__, &hdr->saddr, &hdr->daddr);
+		dst_release(dst);
+		goto out_unlock;
+	}
+
 	ipc6.hlimit = ip6_sk_dst_hoplimit(np, &fl6, dst);
 
 	msg.skb = skb;
-- 
2.53.1-Meta

