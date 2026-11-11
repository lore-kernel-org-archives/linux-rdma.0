Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.145.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794356353;
	b=3x47KZYaXXU53bN8A/WryVOTNyUUyGsKCEO+we48hyH8gDWz0qvBCvHMITYa+xyYiBAK
	 6l8AQaC+2hnOqcwMNQ8n00bM0kOvlWL9INz1FBMXP8FWpo2nhz/+aM3ydGLqPrzMA+xkS
	 jWKTjqdT0LjTXlldzQAgPwSa7XxRsznSNfo38+XBaJ5zNXeM5r7QYChMy906kPyGN0huU
	 zJXWWVrn8fPwtGSqs8skU+H8RzxnUD11l2HhNunmhPcriqvVbzkvEjw68iy86yX40w3Bl
	 V61ivA1P/dDHuOvKE9ggQoqixtf8s/YU6o24pUCcj9ZBe52sVKA4U3F2kirZ0xF5pew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794356353;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version;
	bh=2owVI1JGNZ83EVadAp0oxncHcLXLy4gFsN28BCWX0s4=;
	b=5t/af0P0kKs7YF5V9/iAmbrzwMHK0Wwl27f0uhVFiLN7/R5vBpk8YDfMlHM2Mmc4k7vy
	 PvLoLi/GOvq7DWKqYg615vm41EDoH3+8wrnxIw99MMtkjMF4dkwxZpQabZsvwFq6+P15/
	 4RfwrCJO1xIG7Gcowov49rq2aNj1WzRSw8sFlPhAffJJ50WrDndXJY5paK4h7iuPuGCOf
	 zxumRet/ciFw8TuOcofn9hlxsL4WAm+NUxU/GLKjccV1bTQzGBy6OTUJn79SRNjT24Z8U
	 90a1jlKb5LphQi6SukgnaUK2nzr1k07XDfwUYf836Bt3dMIGoCyWfbjF2jJCyLQ5PRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=Y+Kal8ce;
	arc=none smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F08F606A326;
	Wed, 11 Nov 2026 00:19:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1F08F606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=Y+Kal8ce
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AAMK1C62810117;
	Tue, 10 Nov 2026 16:19:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=2owVI1JGNZ83EVadAp0oxncHcLXLy4gFsN28B
	CWX0s4=; b=Y+Kal8cepQuIHrpl05rkShkrZD1pklBQHyP7fPv1c8C5S/jm0PyMx
	RFcRTesG3Wfs8Ajl08hiGbqUW+1KpdZCUSEu+X5m8fSNwwvR4wjFBRH+/lJUaDR9
	xsPbMQkWJNv0fFZJuByNBP9lr/4r9NrzRAIqn1uJDfjffwkDaxkc6IU4JX0AoH8I
	hB9u9QCKQLHvjx6dFmC8w3G1UOwVDJGI6AwEmNqZ4ZkuYujEeAMit1zjxKX1uM8d
	8QJvlQXIqfPGc/OdD8bazM3Qmc7A31pGlyS+QGHWnS9MHm4vHl5ZcNe8sB6PP3js
	Op9mfxkkZkH7gD0io9QHXuRpBvOzZa0pw==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4hv7vgk6bj-7
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 10 Nov 2026 16:19:00 -0800 (PST)
Received: from localhost (2620:10d:c0a8:1b::30) by mail.thefacebook.com
 (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Wed, 11 Nov
 2026 00:18:47 +0000
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
Subject: [PATCH net v5 3/8] net: don't fragment decrypted skbs
Date: Tue, 10 Nov 2026 16:18:26 -0800
Message-ID: <20261111001831.3710881-4-toddfreed@meta.com>
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
X-Proofpoint-GUID: iJUowjGwHCZvL5Zkot3oNqpAMn2dP7NG
X-Proofpoint-ORIG-GUID: iJUowjGwHCZvL5Zkot3oNqpAMn2dP7NG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDAwMCBTYWx0ZWRfX8f9/2XofMHQC
 fL0tmmjYnfjc9+1MSbnMa3+s07pMxjZ25NNpGhezFQB08q1QJqdifZyHD0lUODX+iuUjc9efI90
 wVx2fOImqkmfK2KtlE5wD3NCkgX+vNNY48PKX/t51jmesulk6TItnlguOHWnGYce0Zd2BRJPyrO
 03LF9XtJiFj02aIgp2gW2+b1qWLSKhwnjUMXFxOTbnVn3IrYA40F56hfiRHTypve4JTYpJ4Jutr
 mgk3yNfK92UiC/bCgZl3KyDcOjj4bqnzkyoIXDFgbAKr/g8gp3i0RkiTRue97YOAIgVXokQiwEn
 QzmqmCyOK+cMlp4bAEIKRJwvh/NZyuql9FzDe6a5v7JThWiRiC9yFF+24Xnv87vARW9LM2r52rq
 AR5GinH9Nps0zTOl0pukWNeZx2uB56GOL6e5Xuv6+TKeMxd0CrV7dgdFh7iD1n2vsXELuV0HiMU
 5qTK5bOTiX9RPDH5pIA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDAwMCBTYWx0ZWRfX23sHq7JtqZxe
 Henid5YNSg5lZCvIU9zuqmTbvZHbooQzVEuVa+V/yxaVRSSaogxrjYZGav+W40dnrnBXm5ZeOLA
 s3ZjWHzNfHc2ezqgRdHb7a7MUZ+aa28=
X-Authority-Analysis: v=2.4 cv=feA4WEQF c=1 sm=1 tr=0 ts=6af3b475 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=03ozwUkBphtHgyqjj1sw:22 a=VabnemYjAAAA:8 a=4WmOrS_ozlDB0nbKRI0A:9
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-10_07,2026-11-06_01,2025-10-01_01

on transmit, skb->decrypted means the device must encrypt the skb.
if it can't do that, then the packet should be dropped, not transmitted
in the clear.

ip_do_fragment() and ip6_fragment() on a decrypted skb produce
fragments which have skb->decrypted unset, and can be sent out
unencrypted.

tx of individually encrypted fragments would not work anyway, because
encrypting needs the L4 header, which non-initial fragments do not have.

ktls could encrypt in sw before fragmenting. that would not work for psp
offload which does not have a software fallback path.

tcp sizes segments to the mtu, so psp and ktls socket packets normally
won't reach this path. an ipv4 tcp socket can be made to send fragments
by setting a route mtu above the device mtu and disabling pmtud on the
socket (IP_PMTUDISC_OMIT). the selftest later in the series does this.

emitting fragments from an ipv6 tcp socket requires more steps, but is
also possible. the test setup here uses ipvs, which sets ignore_df on
forwarded packets. in ip6_fragment(), check skb->decrypted after the
too-big checks, so that a local socket still gets PKT_TOOBIG for path
mtu discovery.

tested with tls tx offload on mlx5 (connectx-7), over ipv4. without
this patch some fragments after the first go out in cleartext, with it
they're dropped (IpFragFails) and the connection stalls.

tested over ipv6, with tls tx offload and psp on mlx5 (connectx-7),
through an ipvs dr service with a local client. without this patch,
fragments after the first go out in cleartext, and the peer reassembles
them; with it they're dropped (Ip6FragFails).

Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
Fixes: 659a2899a57d ("tcp: add datapath logic for PSP with inline key exchange")
Signed-off-by: Todd Freed <toddfreed@meta.com>
---
 net/ipv4/ip_output.c  | 8 ++++++++
 net/ipv6/ip6_output.c | 9 +++++++++
 2 files changed, 17 insertions(+)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index d42d776af273..94a40e7ed534 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -770,6 +770,14 @@ int ip_do_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 	struct ip_frag_state state;
 	int err = 0;
 
+	/* PSP and TLS offload need the packet's L4 header, which non-initial
+	 * fragments do not have.
+	 */
+	if (unlikely(skb_is_decrypted(skb))) {
+		err = -EMSGSIZE;
+		goto fail;
+	}
+
 	/* for offloaded checksums cleanup checksum before fragmentation */
 	if (skb->ip_summed == CHECKSUM_PARTIAL) {
 		err = ip_check_csum_start(skb);
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 25fe0ba98b1a..5f19d170ed29 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -929,6 +929,15 @@ int ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 			mtu = IPV6_MIN_MTU;
 	}
 
+	/* PSP and TLS offload need the packet's L4 header, which non-initial
+	 * fragments do not have. Checked after the too-big checks above,
+	 * so that PMTUD for a local socket works.
+	 */
+	if (unlikely(skb_is_decrypted(skb))) {
+		err = -EMSGSIZE;
+		goto fail;
+	}
+
 	if (np) {
 		u32 frag_size = READ_ONCE(np->frag_size);
 
-- 
2.53.0-Meta

