Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.153.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794358617;
	b=d7GC85QSLbIEjtoHnWVffSWXkKKNsyM7uCg/LFPVO17qQf6xvyfsMymYoaSRiEtkjfe8
	 rVTPycVbTFLvMS9dQwG4ko4A7k+Z//GJqBlSm16X371OKidwkV5KvJKwOrIcQLQ4LS96R
	 ykF0au9wJUigGr9+yF2+WTK+3z33KuwU0nZ7LRkRgMQDz4elLVBrXIMl41DSKVepvAzEG
	 gIotocRkduDHyG0wJLgivtL5QAs56Y4twRWedHhqRRzaYNT0VBQYwmuaelvCS70AoKq25
	 SZLOBSe/i6ijY2KXPzeV4uMh0fp40DqZ7a4Q2V0pBL3sCqDUyFrMdLbfM74WJwUr03Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794358617;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version;
	bh=oNVtFzJp9oyEBMyatujXzlqYcRuf0KbETN5Bj/QvtgI=;
	b=A1B6xCmvHsSIooFrpYTOSeN0sYcGafgnEN2mGN6+eosYhT2jDIk7bcgJvBprp8pA30fx
	 dKw093bue4rmYsAG62nZtg6qO4hZLSaGEdj05P4euzLH7wlce5FLrYJr+hS+czH2XqN4N
	 kOWvNiVOQHpYKgRSJuIcI9Onh8ktmMS0/eJ2/dtE6fjWOQXCzS1AJOojgweaXQ8mEaKGd
	 uMfpzhOWiighZa3HCbzQDHS1cOrEaJsFszMr7EjlqBrFBQZYDPHlhXlGZr30GC7/HXrEU
	 b9aFgxJ2LMU7q+9vEB5cqd9iVLvSTfE2hItrXhv+UTcJeUaL4wMCBMUM18WH905omMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=PmnCZU3E;
	arc=none smtp.remote-ip=67.231.153.30
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D17D606E80B;
	Wed, 11 Nov 2026 00:56:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8D17D606E80B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=PmnCZU3E
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6AB0WLZB556322;
	Tue, 10 Nov 2026 16:56:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=oNVtFzJp9oyEBMyatujXzlqYcRuf0KbETN5Bj
	/QvtgI=; b=PmnCZU3E/cQXdBPCb/3G0E/g/rKEp6wUGbWkMxGqUPxydKkDVLMUh
	6VbkyiIFOccfRDrQFp8Xr5jdQ6nj9Xfo6ovbAQGtsTwi/jG1oyQ8no8J7oZ7jKS4
	Lu1km167NPTER3PfgwkfbpKbEmZ5hkicM0VAUElWDFVXs7J0soCONGzFnPRGROqP
	WWmTBm6pyF2MqJqjm9eQyUC3tZoebztnrMDZCWLmIYhBIkqMzAUQGzTjGaZbCBOt
	M0hxtF1TkLWIzbknmvEh5pXM0gFGLbyu8vKaD8oQjciciReQAcUZuMLyZPBO3c+a
	G0nZ2ObnoLKE88JQfwXOFxpk+oy5QZ25A==
Received: from mail.thefacebook.com ([163.114.134.16])
	by m0001303.ppops.net (PPS) with ESMTPS id 4hv72pkmxh-18
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 10 Nov 2026 16:56:24 -0800 (PST)
Received: from localhost (2620:10d:c085:108::150d) by mail.thefacebook.com
 (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Wed, 11 Nov
 2026 00:56:04 +0000
From: Todd Freed <toddfreed@meta.com>
To: <netdev@vger.kernel.org>, <toddfreed@meta.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn
	<andrew+netdev@lunn.ch>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?=
	<bjorn@kernel.org>,
        <bpf@vger.kernel.org>, Daniel Borkmann
	<daniel@iogearbox.net>,
        Daniel Zahka <daniel.zahka@gmail.com>,
        Donald Hunter
	<donald.hunter@gmail.com>,
        Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko
	<jiri@resnulli.us>,
        John Fastabend <john.fastabend@gmail.com>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>,
        "Martin
 KaFai Lau" <martin.lau@linux.dev>,
        Paolo Abeni <pabeni@redhat.com>, Saeed
 Mahameed <saeedm@nvidia.com>,
        Simon Horman <horms@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>,
        Wei Wang <weiwan@google.com>,
        Willem de Bruijn
	<willemdebruijn.kernel@gmail.com>
Subject: [PATCH net-next v1 05/15] net: add METADATA_PSP dst to carry a psp association on an skb
Date: Tue, 10 Nov 2026 16:55:23 -0800
Message-ID: <20261111005533.6436-6-toddfreed@meta.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261111005533.6436-1-toddfreed@meta.com>
References: <20261111005533.6436-1-toddfreed@meta.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDAwMyBTYWx0ZWRfXyRqsvmQIFcA1
 1+r9m3wP5VDpQiUbGsNHOaWsCoZHzBMY1jofGjgwanlMWERO68LbUFYkRliPKi7sJVz/o+zQgzP
 nuZCHWQ/rfSOqTCibZjTxHYiCrmLfVX1iYTMZEN1vT13q62OcqDS1pkHv/0403eV7Ynv7/UAfHA
 x5yZ9Z+hzs0OCqeQ6Qq9mB27cyftKKeTbiTgbyq84q7QjPQEdF2FZ8F+aGGewelX7OSONLxnNIb
 TO6mHfOcWNxliYx+ZibmT3I1saimPopUuknL5YIRzy6vEuvBHHbc3UBCKnWfmK2sQluMCKQm+hQ
 JxhWt5f+/doiuuLS67cbYoba5Xvo6sK5NkNnBYjv+MFlEvkSiwHsWWXkC4imTuAujWGmmn3t8RB
 T9VGRiUs3fIiQO7s/jw7n4SPO/8llPmHdENgCijDU6wXfJyML9Chyt0gHkDV27O87WNzgjx48Qy
 T4aSBJa/ZKiTxS35CZA==
X-Proofpoint-GUID: SggOXSEvpsE-XJBUGO7NE3JSJ0qzOKbg
X-Authority-Analysis: v=2.4 cv=TtlzFzXh c=1 sm=1 tr=0 ts=6af3bd38 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=_78whYxrdx1mplLwxq1U:22 a=VabnemYjAAAA:8 a=UfiI7-k8cXzeGxpQYQoA:9
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-ORIG-GUID: SggOXSEvpsE-XJBUGO7NE3JSJ0qzOKbg
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDAwMyBTYWx0ZWRfX7vxYKrEj6qR4
 /fpZS76vnftiBrc8p4BDwDsKd/U357AF3njyMI7Vwsg5kDAJUeC2PTVXsSo+8cZ8kIO6W0WasxU
 eF+i50cG14eMYcNx+JO3KrnvjGyNFiY=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-10_07,2026-11-06_01,2025-10-01_01

Add a metadata_dst type holding a reference to a psp association, so
that an association can be attached to an skb that has no socket, e.g.
by a tc rule.

change psp_skb_get_assoc_rcu() to check for METADATA_PSP then fall back
to the socket, so that existing driver tx paths (mlx5, netdevsim)
encrypt such packets without any changes.

once an skb has been marked for psp xmit, it is necessary to ensure that
it is transmitted on the correct device, otherwise it may go onto the
wire in cleartext. for packets on a psp socket, sk_validate_xmit_skb()
handles this.

for socket-less psp packets, the psp metadata dst carries this
information. but __dev_queue_xmit() normally releases the dst before
queueing. add a new check for a psp metadata dst at that point. if it's
the wrong device, drop the packet ; if it's the right device, save the
dst so that the driver can use it.

the right device is the psp device's main netdev: devices associated
with it (dev-assoc, e.g. veth or netkit) have its psp_dev too, but
forward the packet rather than encrypt it, and drop the dst on the way.
prevent xmit on those.

also check that the packet will still fit the device's mtu once the
device adds the psp encapsulation (udp+psp+icv, 40 bytes), and drop it
with SKB_DROP_REASON_PKT_TOO_BIG otherwise. note that no icmp error is
sent in this case. psp sockets do leave room for it (psp_sk_overhead()).

check a packet with a METADATA_PSP dst again at dequeue, in
sk_validate_xmit_skb(): the psp device may have been unregistered while
the packet was queued, and its keys deleted.

Signed-off-by: Todd Freed <toddfreed@meta.com>
---
 include/net/dst_metadata.h  | 19 +++++++++
 include/net/psp/functions.h | 81 ++++++++++++++++++++++++++++++++++++-
 net/core/dev.c              | 35 +++++++++++++---
 net/core/dst.c              |  5 +++
 4 files changed, 133 insertions(+), 7 deletions(-)

diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
index f45d1e3163f0..73755bce2df0 100644
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
@@ -125,6 +142,8 @@ static inline int skb_metadata_dst_cmp(const struct sk_buff *skb_a,
 	case METADATA_XFRM:
 		return memcmp(&a->u.xfrm_info, &b->u.xfrm_info,
 			      sizeof(a->u.xfrm_info));
+	case METADATA_PSP:
+		return a->u.psp_info.pas != b->u.psp_info.pas;
 	default:
 		return 1;
 	}
diff --git a/include/net/psp/functions.h b/include/net/psp/functions.h
index d0789a9694bc..796e5f36f249 100644
--- a/include/net/psp/functions.h
+++ b/include/net/psp/functions.h
@@ -6,6 +6,8 @@
 #include <linux/skbuff.h>
 #include <linux/rcupdate.h>
 #include <linux/udp.h>
+#include <net/dst_metadata.h>
+#include <net/gso.h>
 #include <net/sock.h>
 #include <net/tcp.h>
 #include <net/psp/types.h>
@@ -22,6 +24,7 @@ bool psp_dev_encapsulate(struct net *net, struct sk_buff *skb, __be32 spi,
 int psp_dev_rcv(struct sk_buff *skb, u16 dev_id, u8 generation, bool strip_icv);
 
 /* Kernel-facing API */
+#if IS_ENABLED(CONFIG_INET_PSP)
 void psp_assoc_put(struct psp_assoc *pas);
 struct psp_assoc *psp_assoc_get_by_id(struct net *net, u32 id);
 
@@ -34,7 +37,6 @@ static inline bool psp_assoc_is_tx(const struct psp_assoc *pas)
 	return pas->tx.spi != 0;
 }
 
-#if IS_ENABLED(CONFIG_INET_PSP)
 unsigned int psp_key_size(u32 version);
 void psp_sk_assoc_free(struct sock *sk);
 void psp_twsk_init(struct inet_timewait_sock *tw, const struct sock *sk);
@@ -144,14 +146,78 @@ static inline struct psp_assoc *psp_sk_get_assoc_rcu(const struct sock *sk)
 	return pas;
 }
 
+static inline struct psp_assoc *psp_skb_md_assoc(const struct sk_buff *skb)
+{
+	struct metadata_dst *md_dst = skb_metadata_dst(skb);
+
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
+ * @skb: packet about to be queued for transmission
+ * @dev: device it is queued on
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
+ *  -EINVAL if the packet must be dropped, @dev isn't of its psp device
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
@@ -160,6 +226,19 @@ static inline unsigned int psp_sk_overhead(const struct sock *sk)
 	return pas && pas->tx.spi ? psp_encap : 0;
 }
 #else
+static inline void psp_assoc_put(struct psp_assoc *pas) { }
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
index 9665f3b2f5cb..2cca5f0d302f 100644
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
@@ -4134,9 +4135,13 @@ int skb_csum_hwoffload_help(struct sk_buff *skb,
 }
 EXPORT_SYMBOL(skb_csum_hwoffload_help);
 
-/* Checks if this SKB belongs to an HW offloaded socket
- * and whether any SW fallbacks are required based on dev.
- * Check decrypted mark in case skb_orphan() cleared socket.
+/* Validate an skb for device encryption offload. If the skb belongs to an HW
+ * offloaded socket, apply the socket's callback. Otherwise, an skb which
+ * carries a PSP association is checked again against dev: the PSP device may
+ * have been unregistered while the skb was queued. An skb marked decrypted
+ * (to be encrypted by the device) without either is dropped rather than sent
+ * in clear text. The mark survives losing the socket to skb_orphan(), or the
+ * PSP metadata dst to routing.
  */
 static struct sk_buff *sk_validate_xmit_skb(struct sk_buff *skb,
 					    struct net_device *dev)
@@ -4156,6 +4161,15 @@ static struct sk_buff *sk_validate_xmit_skb(struct sk_buff *skb,
 
 	if (sk_validate) {
 		skb = sk_validate(sk, dev, skb);
+	} else if (unlikely(skb_psp_md(skb))) {
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
@@ -4981,7 +4995,7 @@ int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 	struct net_device *dev = skb->dev;
 	struct netdev_queue *txq = NULL;
 	enum skb_drop_reason reason;
-	int cpu, rc = -ENOMEM;
+	int cpu, psp, rc = -ENOMEM;
 	bool again = false;
 	struct Qdisc *q;
 
@@ -5030,10 +5044,19 @@ int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
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
index 092861133023..38ad136cb46f 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -26,6 +26,7 @@
 
 #include <net/dst.h>
 #include <net/dst_metadata.h>
+#include <net/psp/functions.h>
 
 int dst_discard_out(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
@@ -313,6 +314,8 @@ void metadata_dst_free(struct metadata_dst *md_dst)
 #endif
 	if (md_dst->type == METADATA_XFRM)
 		dst_release(md_dst->u.xfrm_info.dst_orig);
+	if (md_dst->type == METADATA_PSP)
+		psp_assoc_put(md_dst->u.psp_info.pas);
 	kfree(md_dst);
 }
 EXPORT_SYMBOL_GPL(metadata_dst_free);
@@ -349,6 +352,8 @@ void metadata_dst_free_percpu(struct metadata_dst __percpu *md_dst)
 #endif
 		if (one_md_dst->type == METADATA_XFRM)
 			dst_release(one_md_dst->u.xfrm_info.dst_orig);
+		if (one_md_dst->type == METADATA_PSP)
+			psp_assoc_put(one_md_dst->u.psp_info.pas);
 	}
 	free_percpu(md_dst);
 }
-- 
2.53.0-Meta

