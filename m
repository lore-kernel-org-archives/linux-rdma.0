Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.153.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792799271;
	b=EbHGo/lCrimO+O3LYdnm5IP6gszgQlvI7kP5m9HPPu/BqxdXFEwrzl7nWBneOvemxUqg
	 VRRs2SMhGV2DQwi7CO8lAkv4Cc5lADRx1q3FRkbNn1GoI31mbv+3ekcfH8MaH7RbBrGiB
	 b75cXP+eoUJ/aO75QgroF+okb4Nh7g74kCFGWOVXmoBEpGN6O1mxlyGueMX9zNMIDiuB7
	 nOVS9Ill0xkA5GUNJqGWGSytZUoOSiAy6BXbzbCi/Ik/4s0vraZZFt+QsCR6DOUQr2WM8
	 M+FX4U4FgNWw2ji9rtdhyzCcvMaG7A7+VJnLb/YrNj1oEw/nfT4YV+MCesgyfRmdZPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792799271;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version;
	bh=VS7ZSu95Brvkr7KlUm4QnFOFoetJjTj9I3QrWEH2gyY=;
	b=2dkQmFjqI+MfCjMdVfiR8Fo79fHJl7liCCRxb4viNeWbPRgmdjmpb4NX61XCFgEk7PhG
	 QPkcGWmuT9mrHZ/1xAPOiravXP/ut5cQkQwSIZ8MeQ1QdJWl7oz7XfN4s7lAgYShNhSfS
	 cYV01HWJjYERMl5uLAE4FSDUxXnlzTnHv4hhbUSx1aVeIL50SrPfhbQSJVjveGSQ1rD9d
	 zoPDcL12xjdELZkZbSam34qwEgV/rQ8DEuW5WEzJl2gumy8TseZtGtK+w4o5oAp9HupmT
	 z9iHcpr+GHmDNQEFoeFJvpHI+rm33gMiUJVyfL1KRJpsYos2h55nd41u2akMOPD+HqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=i4P5n3wC;
	arc=none smtp.remote-ip=67.231.153.30
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10A8606A31B;
	Fri, 23 Oct 2026 23:47:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E10A8606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=i4P5n3wC
Received: from pps.filterd (m0528005.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69NLwhuj363368;
	Fri, 23 Oct 2026 16:47:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=VS7ZSu95Brvkr7KlUm4QnFOFoetJjTj9I3QrW
	EH2gyY=; b=i4P5n3wCPY8pd1zq8Y8VSAv6AUSwjOBv0IEQLgjIixLnjT+Y54H8q
	Onmw8Fq5aLCMq9MgZO7QR23Wn8B8Vh72E1LX0RT5hjrs5L+U6XxyZDMU/sFPktvz
	QiUYtix/fR76oqdmtnusiEbSvDRagQIubTlRSJAhtryfTZ/dJej6hz9NCjHz3XZp
	w0mpaKlohCQPHEP8ADKODizT/Ra1SGcnRenCX/C1HQVaBLY5tkO+oP9shglVSgbF
	WQ0Ey3Wm5axWcES/pAcGrcZnU3I6Xj/k/4arUaadJVacF42UmMwIl60aq1xA5V6u
	cqKcusX3MLL1zjrA++dDbS3DCBzeXrDpA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4hfjf6mnvf-10
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Fri, 23 Oct 2026 16:47:41 -0700 (PDT)
Received: from localhost (2620:10d:c085:208::f) by mail.thefacebook.com
 (2620:10d:c08b:78::c78f) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Fri, 23 Oct
 2026 23:47:38 +0000
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
Subject: [PATCH net v3 2/4] psp: support ipv6 extension headers in psp_dev_rcv() decap
Date: Fri, 23 Oct 2026 16:46:38 -0700
Message-ID: <20261023234640.1459291-3-toddfreed@meta.com>
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
X-Proofpoint-GUID: EiGruBbnQHv969mdkfyDcQ0CyO0yZ_ms
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDA5MyBTYWx0ZWRfX6R1n1BuKUSvh
 Ly5jzcS4aGKGWaq6FAcsMrGl8vi5yJ7QspwNnSUvECfEwRd7E9VMm/aZ2EXQ5RTgZWuO8CRREj8
 xCfyshZRRcjPEJMfjh1fAHPn0gwBhj1jZwJnkunzTmFJi0bL88oqibTXXUFBIcRFJcceijzEt3b
 v4Ad2MPtlpL7s9Pbp1tGiyDAoe25qyPgAaYYvEBIuvgla5z3FAYDHY9Utlw4aLBfB868B4JsAFt
 itvFZ63pzflVMAtV0NnONweiWKocLhn2xmQex2Odna8CM+7CxRWtd9xJMYs9KI1EQp7Lp5ABp/V
 Xy4rgQj0U4S8b3gC3O9Sqex2oJ5byb8O/LxfHvZg2wQUOs1KeDtwCzRLhKHC3h34Xz2T6qBgLpM
 Y2+iS9PiP1w4Mq8mIWLPh8V1S28uXU7ZCunEuu5lJUSeR5NFDuacr27HbAqJUTlu5zLI+5s0feW
 WzKx2HjHBwYFtXpCuZA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDA5MyBTYWx0ZWRfX7M6vYs7MjVZ3
 1DxXTj7tcI0IK0Rjbf2pM/QFhX+7HngUEnjPC7T19RgMAFL3SmlNlH00aXeDYY2WknIcW4mQJTY
 YSikv7Zy6ssXK2+6YGWPm+HzvT9WBJs=
X-Authority-Analysis: v=2.4 cv=PNaaavqC c=1 sm=1 tr=0 ts=6adbf21d cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=jCddH8ec0KUNCymVuxII:22 a=VabnemYjAAAA:8 a=JLEcny8RLRInaEHcxJoA:9
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-ORIG-GUID: EiGruBbnQHv969mdkfyDcQ0CyO0yZ_ms
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_06,2026-10-21_02,2025-10-01_01

psp_dev_rcv() expects the udp header to immediately follow the fixed
ipv6 header, so packets with ipv6 extension headers are dropped by the
is_udp check. additionally, on decap it writes the inner nexthdr into
the fixed header instead of into the last extension header.

fix by skipping the extension headers to find the udp header, and on
decap, setting the inner nexthdr on the last one.

fragment and authentication headers (ah) are not supported in psp
transport mode, so such packets are dropped.

Fixes: 0eddb8023cee ("psp: provide decapsulation and receive helper for drivers")
Signed-off-by: Todd Freed <toddfreed@meta.com>
---
 net/psp/psp_main.c | 62 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 59 insertions(+), 3 deletions(-)

diff --git a/net/psp/psp_main.c b/net/psp/psp_main.c
index c9c1a8826b7f..946047440ed3 100644
--- a/net/psp/psp_main.c
+++ b/net/psp/psp_main.c
@@ -4,6 +4,7 @@
 #include <linux/list.h>
 #include <linux/netdevice.h>
 #include <linux/xarray.h>
+#include <net/ipv6.h>
 #include <net/net_namespace.h>
 #include <net/psp.h>
 #include <net/udp.h>
@@ -185,6 +186,39 @@ unsigned int psp_key_size(u32 version)
 }
 EXPORT_SYMBOL(psp_key_size);
 
+/**
+ * psp_ipv6_nexthdr_off() - find the offset to the l4 proto nexthdr
+ * @hdr:	ipv6 fixed header
+ * @len:	l3 header total length
+ *
+ * Return: offset from @hdr, or a negative value to drop the packet
+ */
+static int psp_ipv6_nexthdr_off(const u8 *hdr, unsigned int len)
+{
+	unsigned int nh = offsetof(struct ipv6hdr, nexthdr);
+	unsigned int off = sizeof(struct ipv6hdr);
+	const struct ipv6_opt_hdr *eh;
+	unsigned int rem;
+	u8 type;
+
+	while (off < len) {
+		eh = (const void *)(hdr + off);
+		type = hdr[nh];
+
+		if (!ipv6_ext_hdr(type) || type == NEXTHDR_NONE ||
+		    type == NEXTHDR_FRAGMENT || type == NEXTHDR_AUTH)
+			return -EINVAL;
+		rem = len - off;
+		if (rem < sizeof(*eh))
+			return -EINVAL;
+
+		nh = off + offsetof(struct ipv6_opt_hdr, nexthdr);
+		off += ipv6_optlen(eh);
+	}
+
+	return off == len ? nh : -EINVAL;
+}
+
 static void psp_write_headers(struct net *net, struct sk_buff *skb, __be32 spi,
 			      u8 ver, unsigned int udp_len, __be16 sport)
 {
@@ -303,6 +337,7 @@ int psp_dev_rcv(struct sk_buff *skb, u16 dev_id, u8 generation, bool strip_icv)
 	struct psphdr *psph;
 	struct ethhdr *eth;
 	struct udphdr *uh;
+	int nh_off = 0;
 	__be16 proto;
 	bool is_udp;
 
@@ -331,8 +366,28 @@ int psp_dev_rcv(struct sk_buff *skb, u16 dev_id, u8 generation, bool strip_icv)
 			return -EINVAL;
 	} else {
 		struct ipv6hdr *ipv6h = (struct ipv6hdr *)(skb->data + l2_hlen);
+		u8 nexthdr = ipv6h->nexthdr;
+		__be16 frag_off;
+		int off;
+
+		/* UDP + PSP come after any extension headers */
+		off = ipv6_skip_exthdr(skb, l2_hlen + sizeof(*ipv6h), &nexthdr,
+				       &frag_off);
+		if (unlikely(off < 0))
+			return -EINVAL;
+
+		is_udp = nexthdr == IPPROTO_UDP;
+		l3_hlen = off - l2_hlen;
+		if (l3_hlen != sizeof(struct ipv6hdr) &&
+		    !pskb_may_pull(skb, l2_hlen + l3_hlen + PSP_ENCAP_HLEN))
+			return -EINVAL;
 
-		is_udp = ipv6h->nexthdr == IPPROTO_UDP;
+		/* fragment and authentication headers are not supported in
+		 * transport mode
+		 */
+		nh_off = psp_ipv6_nexthdr_off(skb->data + l2_hlen, l3_hlen);
+		if (unlikely(nh_off < 0))
+			return -EINVAL;
 	}
 
 	if (unlikely(!is_udp))
@@ -387,10 +442,11 @@ int psp_dev_rcv(struct sk_buff *skb, u16 dev_id, u8 generation, bool strip_icv)
 	} else {
 		struct ipv6hdr *ipv6h = (struct ipv6hdr *)(skb->data + l2_hlen);
 
-		if (unlikely(ntohs(ipv6h->payload_len) < encap))
+		if (unlikely(ntohs(ipv6h->payload_len) <
+			     l3_hlen - sizeof(*ipv6h) + encap))
 			return -EINVAL;
 
-		ipv6h->nexthdr = psph->nexthdr;
+		((u8 *)ipv6h)[nh_off] = psph->nexthdr;
 		ipv6h->payload_len = htons(ntohs(ipv6h->payload_len) - encap);
 	}
 
-- 
2.53.0-Meta

