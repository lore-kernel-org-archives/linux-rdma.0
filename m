Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.153.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795558749;
	b=0IZEyMafoNwY+kF3ZWCCVTR5A0Sbp/nWkUSCtvm+gusXCQPUvgmE1wDp1ZSsMid0smL8
	 G65E/DuafSqKpZle59GN2yRhbvnHMQElWbto8e/UA7bfGViu3xqzrArDyyv+LaGpfsy8D
	 6fXjXgPRGeT2fJxMyc0u/gD07fashM6FUDHeWohGppyy5cFSMauH0YcP/LLPZYAiiECnp
	 BpKCmYFZcFwaE2Cwm0g/hEsBFC37TK29vE+C/3RLNVCqoie3UWEce063kbvcOq604uXNm
	 piQIFtV4JcY5hlpeppyPZkp7Cfd9KTRwvIU4nlRifMmAgWi5ve8UuuRyK4JMg7EtcrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795558749;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version;
	bh=yn22ytT6a6XPk+qUmbVsJkBQU4xiBupUlNY2KKuRP7o=;
	b=jbEMPCOf/JkC2ufCJqMwzsTY2JrGDbiHp8gX8gdooM4hozZSU60y8MzzSfYXwY8QEYhj
	 BQi+RRx6QHBANAhoVLjMS34mwGUErPSZGoAexmcsiBRcmfyL21rJs/u8Oz1ZjsFj7m7vK
	 hzt6ER1twOheesSreNAGnk00E6EVJNSLAogMhRNRK2UFFHl49B9kA/7Eet7XxvilUuc83
	 0OrT2XSdQ8BUWeGRZrzyNr7Apk1zO7ozOlM2e9eSaOcH1s3Lr9zyjNpmME7hR7X9mpg57
	 Iw1Y1sLcvYP0ps11Gaf6j87iK3YO4FWYey994jNyA2w3hB6TEILHWe6MdO01nCMwg3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=NuKf0YDT;
	arc=none smtp.remote-ip=67.231.153.30
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2EE606A31E;
	Tue, 24 Nov 2026 22:19:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C2EE606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=NuKf0YDT
Received: from pps.filterd (m0528006.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AOMB6Vj559138;
	Tue, 24 Nov 2026 14:18:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=yn22ytT6a6XPk+qUmbVsJkBQU4xiBupUlNY2K
	KuRP7o=; b=NuKf0YDT0DMmy0s+pDvnPf1ZuxR26RfwHp6+lzLiG0kd20X4rPZU0
	6hsjGuUC7epaqd2f0YZEwbAQahlqOIraDO/HhoV2IJYn3i/e1ZZmjnDf6L+fIbhW
	oJw24y6JqkawpTap6Tmgte0TxAvGWnCOEKu805XUIJb0zUXyVqe1BzlnmKuuW+lZ
	oCRg5uHWNz+lR2hUIjPHrAa5dD/Dm47QzEE7SP7uRln92lbPZj4yDDHSGbCXhuCF
	bfWr8+IhIMVEHDRDdMO7q8KVOseuLcZ5z2t70335bqSQz8QOOsNHghQrStmm/xHv
	5NvLg4pCobQ0ZDJhNawbkUh9W4LPC5gKA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j5h4590hv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 24 Nov 2026 14:18:17 -0800 (PST)
Received: from localhost (2620:10d:c0a8:1c::11) by mail.thefacebook.com
 (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Tue, 24 Nov
 2026 22:18:16 +0000
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
        Donald Hunter
	<donald.hunter@gmail.com>,
        Dragos Tatulea <dtatulea@nvidia.com>,
        Eric Dumazet
	<edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim
	<jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        Leon Romanovsky
	<leon@kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>,
        Paolo Abeni
	<pabeni@redhat.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Saeed Mahameed
	<saeedm@nvidia.com>, Simon Horman <horms@kernel.org>,
        Tariq Toukan
	<tariqt@nvidia.com>, Wei Wang <weiwan@google.com>,
        Willem de Bruijn
	<willemdebruijn.kernel@gmail.com>,
        Kuniyuki Iwashima <kuniyu@google.com>, <bpf@vger.kernel.org>,
        =?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?=
	<ast@fiberby.net>,
        Qingfang Deng <qingfang.deng@linux.dev>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Shuah Khan
	<shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan
	<skhan@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthieu
 Baerts <matttbe@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        =?UTF-8?q?Jonas=20K=C3=B6ppeler?= <j.koeppeler@tu-berlin.de>,
        Hangbin Liu
	<hangbin.liu@linux.dev>
Subject: [PATCH net-next v3 05/12] net: add METADATA_PSP dst to carry a psp association on an skb
Date: Tue, 24 Nov 2026 14:17:51 -0800
Message-ID: <20261124221758.3230929-6-toddfreed@meta.com>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261124221758.3230929-1-toddfreed@meta.com>
References: <20261124221758.3230929-1-toddfreed@meta.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI0MDA4NyBTYWx0ZWRfX+a6U1W1Qi9Rx
 maw8vQDklI3RPXqQi10ETNItAGNSUd1BCByTLciDcUHGlA8SZNkHQDPWIwCJrrJPvfcVIcm8Kr4
 EZFCNfwsus3HRz3jiw16IxRrxqtonkTFx8l5VfbwKUBABR35eJ6mHEMgRFrAmTywyfg0WN+68bz
 BhUJuyesFJOlqLAQlZ9D0UdIHrvDdasHzeH0TnWC6lS3FyuyInSNnNMiMdTLIenOBLZTJLHy/tp
 ICXJfNYBncl7ihUlDmg1sg8xFCPSlYbrhWMjJkRiOFaX5LAveKOIomHZea+ONRtcfGF/PUIQ+Tp
 g8y1Y7qWz0zTEUMJzvi6qXDi/uaGTaX0Y6gkJZkDU8mHgK8ev4lBBO47vMzPNLqQxBdrOFr9d2k
 zoGN5A67G5HzwbexOvzMM8EAuKQnpXw7siOP+8w55BymRCXs4xsSRzOF0BHj13FJWhYKtpRpT0k
 NgRuHlOJJnWBHz89vUA==
X-Proofpoint-ORIG-GUID: tbXSFt2pnGDmzENAGQbYG6gI0etjfNYW
X-Proofpoint-GUID: tbXSFt2pnGDmzENAGQbYG6gI0etjfNYW
X-Authority-Analysis: v=2.4 cv=MY75KJ/f c=1 sm=1 tr=0 ts=6b060d29 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=kkcUborcUVj0H7zxAXTl:22 a=VabnemYjAAAA:8 a=P4PlVcaCkDktyUazMl4A:9
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI0MDA4NyBTYWx0ZWRfX5MYV/Gtcmg8j
 kEv92ZrM44ScAB2BFI9LXFVrJ6GFzx8mJDR41seIDy2DEFYKMsFnGsoCW2t+wYNFjL7FHDEH2kL
 eJDs89d1+c44qZy3BclLQMgOlVLo06U=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-24_06,2026-11-23_01,2025-10-01_01

Add a metadata_dst type holding a reference to a PSP association, so
that an association can be attached to an skb that has no socket, e.g.
by a tc action.

Change psp_skb_get_assoc_rcu() to check for METADATA_PSP, then fall back
to the socket, so that existing driver Tx paths (mlx5, netdevsim)
encrypt such packets without any changes.

Once an skb has been marked for PSP xmit, it must be transmitted on the
correct device, otherwise it may go onto the wire in clear text. For
packets of a PSP socket, sk_validate_xmit_skb() handles this.

For socket-less PSP packets, the PSP metadata dst carries this
information, but __dev_queue_xmit() normally releases the dst before
queueing. Add a new check for a PSP metadata dst at that point. If it's
the wrong device, drop the packet; if it's the right device, keep the
dst so that the driver can use it.

The right device is the PSP device's main netdev: devices associated
with it (dev-assoc, e.g. veth or netkit) have its psp_dev too, but
forward the packet rather than encrypt it, and drop the dst on the way.
Prevent xmit on those.

Also check that the packet will still fit the device's MTU once the
device adds the PSP encapsulation (UDP + PSP + ICV, 40 bytes), and drop
it with SKB_DROP_REASON_PKT_TOO_BIG otherwise. Note that no ICMP error
is sent in this case. PSP sockets do leave room for it
(psp_sk_overhead()).

Check a packet with a METADATA_PSP dst again when it is validated at
dequeue, in sk_validate_xmit_skb(). If the PSP device was unregistered
since enqueue, the packet is dropped.

A packet of a socket with its own encryption offload (PSP or kTLS) must
not carry a METADATA_PSP dst: sk_validate_xmit_skb() would apply the
socket's validator instead of checking the association. Whatever attaches
the dst refuses such packets, but the socket can gain an offload while
the packet is queued, so sk_validate_xmit_skb() drops a packet which has
both. It reads sk->sk_validate_xmit_skb with READ_ONCE(), which pairs
with the WRITE_ONCE() in psp_sock_set_tx_key().

Put the new checks behind a static key, psp_md_needed, so that
configurations which aren't using socket-less PSP don't pay to evaluate
them. It's enabled while any METADATA_PSP dst exists.

Signed-off-by: Todd Freed <toddfreed@meta.com>
---
 include/net/dst_metadata.h  |  19 +++++++
 include/net/psp/functions.h | 105 +++++++++++++++++++++++++++++++++++-
 net/core/dev.c              |  50 ++++++++++++++---
 net/core/dst.c              |   5 ++
 net/psp/psp_main.c          |  31 +++++++++++
 5 files changed, 201 insertions(+), 9 deletions(-)

diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
index 02fffbb85099..bc6ac51dde9c 100644
--- a/include/net/dst_metadata.h
+++ b/include/net/dst_metadata.h
@@ -13,6 +13,7 @@ enum metadata_type {
 	METADATA_HW_PORT_MUX,
 	METADATA_MACSEC,
 	METADATA_XFRM,
+	METADATA_PSP,
 };
 
 struct hw_port_info {
@@ -30,6 +31,14 @@ struct xfrm_md_info {
 	struct dst_entry *dst_orig;
 };
 
+/**
+ * struct psp_md_info - PSP association to encrypt a packet with
+ * @pas: association, the metadata_dst holds a reference on it
+ */
+struct psp_md_info {
+	struct psp_assoc *pas;
+};
+
 struct metadata_dst {
 	struct dst_entry		dst;
 	enum metadata_type		type;
@@ -38,6 +47,7 @@ struct metadata_dst {
 		struct hw_port_info	port_info;
 		struct macsec_info	macsec_info;
 		struct xfrm_md_info	xfrm_info;
+		struct psp_md_info	psp_info;
 	} u;
 };
 
@@ -51,6 +61,13 @@ static inline struct metadata_dst *skb_metadata_dst(const struct sk_buff *skb)
 	return NULL;
 }
 
+static inline bool skb_psp_md(const struct sk_buff *skb)
+{
+	struct metadata_dst *md_dst = skb_metadata_dst(skb);
+
+	return md_dst && md_dst->type == METADATA_PSP;
+}
+
 static inline struct ip_tunnel_info *
 skb_tunnel_info(const struct sk_buff *skb)
 {
@@ -127,6 +144,8 @@ static inline int skb_metadata_dst_cmp(const struct sk_buff *skb_a,
 	case METADATA_XFRM:
 		return memcmp(&a->u.xfrm_info, &b->u.xfrm_info,
 			      sizeof(a->u.xfrm_info));
+	case METADATA_PSP:
+		return a->u.psp_info.pas != b->u.psp_info.pas;
 	default:
 		return 1;
 	}
diff --git a/include/net/psp/functions.h b/include/net/psp/functions.h
index 2380af3b9c86..8704e41a7fda 100644
--- a/include/net/psp/functions.h
+++ b/include/net/psp/functions.h
@@ -5,7 +5,10 @@
 
 #include <linux/skbuff.h>
 #include <linux/rcupdate.h>
+#include <linux/jump_label_ratelimit.h>
 #include <linux/udp.h>
+#include <net/dst_metadata.h>
+#include <net/gso.h>
 #include <net/sock.h>
 #include <net/tcp.h>
 #include <net/psp/types.h>
@@ -22,10 +25,25 @@ bool psp_dev_encapsulate(struct net *net, struct sk_buff *skb, __be32 spi,
 int psp_dev_rcv(struct sk_buff *skb, u16 dev_id, u8 generation, bool strip_icv);
 
 /* Kernel-facing API */
+#if IS_ENABLED(CONFIG_INET_PSP)
 void psp_assoc_put(struct psp_assoc *pas);
 struct psp_assoc *psp_assoc_get_by_id(struct net *net, u32 id);
+struct metadata_dst *psp_md_alloc(struct psp_assoc *pas);
+
+extern struct static_key_false_deferred psp_md_needed;
+
+/* A METADATA_PSP dst may exist: the transmit path has to check for it */
+static inline bool psp_md_needed_on(void)
+{
+	return static_branch_unlikely(&psp_md_needed.key);
+}
+
+/* Pairs with psp_md_alloc(), from metadata_dst_free() */
+static inline void psp_md_put(void)
+{
+	static_branch_slow_dec_deferred(&psp_md_needed);
+}
 
-#if IS_ENABLED(CONFIG_INET_PSP)
 unsigned int psp_key_size(u32 version);
 void psp_sk_assoc_free(struct sock *sk);
 void psp_twsk_init(struct inet_timewait_sock *tw, const struct sock *sk);
@@ -137,14 +155,84 @@ static inline struct psp_assoc *psp_sk_get_assoc_rcu(const struct sock *sk)
 	return pas;
 }
 
+static inline struct psp_assoc *psp_skb_md_assoc(const struct sk_buff *skb)
+{
+	struct metadata_dst *md_dst;
+
+	if (!psp_md_needed_on())
+		return NULL;
+
+	md_dst = skb_metadata_dst(skb);
+	if (md_dst && md_dst->type == METADATA_PSP)
+		return md_dst->u.psp_info.pas;
+
+	return NULL;
+}
+
 static inline struct psp_assoc *psp_skb_get_assoc_rcu(struct sk_buff *skb)
 {
+	struct psp_assoc *pas;
+
+	pas = psp_skb_md_assoc(skb);
+	if (pas)
+		return pas;
+
 	if (!skb->decrypted || !skb->sk)
 		return NULL;
 
 	return psp_sk_get_assoc_rcu(skb->sk);
 }
 
+/**
+ * psp_xmit_md() - validate psp association attached as a metadata dst
+ * @skb: packet about to be queued for transmission, or validated before
+ *	 the device transmits it
+ * @dev: device it is queued on, or transmitted by
+ *
+ * If the skb has a psp association attached as metadata dst, this indicates
+ * intent to transmit encrypted, which will only happen when transmit on
+ * the main netdev of its psp device.
+ *
+ * Also check that the packet will still fit @dev's MTU once the device has
+ * added the PSP encapsulation. Sockets leave room for it (psp_sk_overhead()),
+ * whoever attached the association may not have.
+ *
+ * returns:
+ *   0 if @skb carries no psp association
+ *   1 if it does and the dst must be kept for the driver
+ *  -EINVAL if the packet must be dropped, @dev isn't the main netdev of
+ *	    its psp device
+ *  -EMSGSIZE if the packet must be dropped, too big once encapsulated
+ */
+static inline int psp_xmit_md(const struct sk_buff *skb,
+			      const struct net_device *dev)
+{
+	unsigned int psp_encap = sizeof(struct udphdr) + PSP_HDR_SIZE +
+				 PSP_TRL_SIZE;
+	struct psp_assoc *pas = psp_skb_md_assoc(skb);
+	unsigned int mtu;
+
+	if (likely(!pas))
+		return 0;
+
+	if (rcu_access_pointer(dev->psp_dev) != pas->psd ||
+	    dev != pas->psd->main_netdev)
+		return -EINVAL;
+
+	mtu = READ_ONCE(dev->mtu);
+	if (mtu <= psp_encap)
+		return -EMSGSIZE;
+	mtu -= psp_encap;
+	if (skb_is_gso(skb)) {
+		if (!skb_gso_validate_network_len(skb, mtu))
+			return -EMSGSIZE;
+	} else if (skb->len - skb_network_offset(skb) > mtu) {
+		return -EMSGSIZE;
+	}
+
+	return 1;
+}
+
 static inline unsigned int psp_sk_overhead(const struct sock *sk)
 {
 	int psp_encap = sizeof(struct udphdr) + PSP_HDR_SIZE + PSP_TRL_SIZE;
@@ -153,6 +241,21 @@ static inline unsigned int psp_sk_overhead(const struct sock *sk)
 	return pas && pas->tx.spi ? psp_encap : 0;
 }
 #else
+static inline void psp_assoc_put(struct psp_assoc *pas) { }
+static inline bool psp_md_needed_on(void) { return false; }
+static inline void psp_md_put(void) { }
+
+static inline struct psp_assoc *psp_assoc_get_by_id(struct net *net, u32 id)
+{
+	return NULL;
+}
+
+static inline int psp_xmit_md(const struct sk_buff *skb,
+			      const struct net_device *dev)
+{
+	return 0;
+}
+
 static inline void psp_sk_assoc_free(struct sock *sk) { }
 static inline void
 psp_twsk_init(struct inet_timewait_sock *tw, const struct sock *sk) { }
diff --git a/net/core/dev.c b/net/core/dev.c
index a44b314f387b..2b1a2736ab3f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -111,6 +111,7 @@
 #include <net/pkt_cls.h>
 #include <net/checksum.h>
 #include <net/xfrm.h>
+#include <net/psp/functions.h>
 #include <net/tcx.h>
 #include <linux/highmem.h>
 #include <linux/init.h>
@@ -4141,9 +4142,14 @@ int skb_csum_hwoffload_help(struct sk_buff *skb,
 }
 EXPORT_SYMBOL(skb_csum_hwoffload_help);
 
-/* Checks if this SKB belongs to an HW offloaded socket
- * and whether any SW fallbacks are required based on dev.
- * Check decrypted mark in case skb_orphan() cleared socket.
+/* Validate an skb for device encryption offload. If the skb belongs to an HW
+ * offloaded socket, apply the socket's callback, unless the skb also carries a
+ * PSP association: then it is dropped. Otherwise, an skb which carries a PSP
+ * association is checked again against dev: the PSP device may have been
+ * unregistered while the skb was queued. An skb marked decrypted (to be
+ * encrypted by the device) without either is dropped rather than sent in clear
+ * text. The mark survives losing the socket to skb_orphan(), or the PSP
+ * metadata dst to routing.
  */
 static struct sk_buff *sk_validate_xmit_skb(struct sk_buff *skb,
 					    struct net_device *dev)
@@ -4156,13 +4162,32 @@ static struct sk_buff *sk_validate_xmit_skb(struct sk_buff *skb,
 	sk_validate = NULL;
 	if (sk) {
 		if (sk_fullsock(sk))
-			sk_validate = sk->sk_validate_xmit_skb;
+			sk_validate = READ_ONCE(sk->sk_validate_xmit_skb);
 		else if (sk_is_inet(sk) && sk->sk_state == TCP_TIME_WAIT)
 			sk_validate = inet_twsk(sk)->tw_validate_xmit_skb;
 	}
 
 	if (sk_validate) {
-		skb = sk_validate(sk, dev, skb);
+		/* the socket's validator would apply instead of checking the
+		 * association. A METADATA_PSP dst isn't given to the packets
+		 * of a socket with its own offload, but the socket can gain
+		 * one while such a packet is queued.
+		 */
+		if (psp_md_needed_on() && skb_psp_md(skb)) {
+			kfree_skb_reason(skb, SKB_DROP_REASON_PSP_OUTPUT);
+			skb = NULL;
+		} else {
+			skb = sk_validate(sk, dev, skb);
+		}
+	} else if (psp_md_needed_on() && skb_psp_md(skb)) {
+		int psp = psp_xmit_md(skb, dev);
+
+		if (psp <= 0) {
+			kfree_skb_reason(skb, psp == -EMSGSIZE ?
+					 SKB_DROP_REASON_PKT_TOO_BIG :
+					 SKB_DROP_REASON_PSP_OUTPUT);
+			skb = NULL;
+		}
 	} else if (unlikely(skb_is_decrypted(skb))) {
 		pr_warn_ratelimited("unencrypted skb with no associated socket - dropping\n");
 		kfree_skb(skb);
@@ -5002,7 +5027,7 @@ int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 	struct net_device *dev = skb->dev;
 	struct netdev_queue *txq = NULL;
 	enum skb_drop_reason reason;
-	int cpu, rc = -ENOMEM;
+	int cpu, psp, rc = -ENOMEM;
 	bool again = false;
 	struct Qdisc *q;
 
@@ -5051,10 +5076,19 @@ int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 			txq = netdev_tx_queue_mapping(dev, skb);
 	}
 #endif
+	psp = psp_xmit_md(skb, dev);
+	if (unlikely(psp < 0)) {
+		reason = psp == -EMSGSIZE ? SKB_DROP_REASON_PKT_TOO_BIG :
+					    SKB_DROP_REASON_PSP_OUTPUT;
+		rc = psp;
+		goto drop;
+	}
+
 	/* If device/qdisc don't need skb->dst, release it right now while
-	 * its hot in this cpu cache.
+	 * its hot in this cpu cache. A PSP metadata dst carries the packet's
+	 * association to the driver, so keep it in that case.
 	 */
-	if (dev->priv_flags & IFF_XMIT_DST_RELEASE)
+	if ((dev->priv_flags & IFF_XMIT_DST_RELEASE) && likely(!psp))
 		skb_dst_drop(skb);
 	else
 		skb_dst_force(skb);
diff --git a/net/core/dst.c b/net/core/dst.c
index 092861133023..9ff38244b52b 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -26,6 +26,7 @@
 
 #include <net/dst.h>
 #include <net/dst_metadata.h>
+#include <net/psp/functions.h>
 
 int dst_discard_out(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
@@ -313,6 +314,10 @@ void metadata_dst_free(struct metadata_dst *md_dst)
 #endif
 	if (md_dst->type == METADATA_XFRM)
 		dst_release(md_dst->u.xfrm_info.dst_orig);
+	if (md_dst->type == METADATA_PSP) {
+		psp_assoc_put(md_dst->u.psp_info.pas);
+		psp_md_put();
+	}
 	kfree(md_dst);
 }
 EXPORT_SYMBOL_GPL(metadata_dst_free);
diff --git a/net/psp/psp_main.c b/net/psp/psp_main.c
index 8f669304a996..7c5291d5e971 100644
--- a/net/psp/psp_main.c
+++ b/net/psp/psp_main.c
@@ -217,6 +217,37 @@ unsigned int psp_key_size(u32 version)
 }
 EXPORT_SYMBOL(psp_key_size);
 
+/* Enabled while any METADATA_PSP dst exists, so that the transmit path of
+ * hosts which don't use socket-less PSP doesn't look for one. Disabled with
+ * a delay: the last dst is freed from a context which can't sleep.
+ */
+DEFINE_STATIC_KEY_DEFERRED_FALSE(psp_md_needed, HZ);
+EXPORT_SYMBOL_GPL(psp_md_needed);
+
+/**
+ * psp_md_alloc() - allocate a METADATA_PSP dst for an association
+ * @pas: association, the dst takes over the caller's reference on success
+ *
+ * Context: process context, may sleep.
+ * Return: the dst, or NULL on failure.
+ */
+struct metadata_dst *psp_md_alloc(struct psp_assoc *pas)
+{
+	struct metadata_dst *md;
+
+	if (!static_branch_inc(&psp_md_needed.key))
+		return NULL;
+	md = metadata_dst_alloc(0, METADATA_PSP, GFP_KERNEL);
+	if (!md) {
+		static_branch_slow_dec_deferred(&psp_md_needed);
+		return NULL;
+	}
+	md->u.psp_info.pas = pas;
+
+	return md;
+}
+EXPORT_SYMBOL_GPL(psp_md_alloc);
+
 static void psp_write_headers(struct net *net, struct sk_buff *skb, __be32 spi,
 			      u8 ver, u8 nexthdr, unsigned int udp_len,
 			      __be16 sport)
-- 
2.53.1-Meta

