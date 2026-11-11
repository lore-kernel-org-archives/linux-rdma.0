Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.145.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794358601;
	b=Jpp+SyxsvGhCLDTr+dXIdkTj2VpGIo2UUEbg5l79H2fmCYGaCPIhF3uSgn5GzTqTRRLY
	 HoWSwlH6YoVfYdw/j6FFbmAPpolph+RmH+jR6cdqCqQ/gZ8A0jykXlKXoOAdm6PEW1IeV
	 UQMjQVBIYAqXebZex0jNM4rXEhHr6CyqoEkwX9nwCW8GlcCugZJRElF93TagYbvCO5m+J
	 UsaPZCeolp6ZCEmQbPZZS2JJcknRYx6MZgybUyjlozjH/i+x20c+nH+nBxdHgZZu6imOA
	 a0KMl3Qwc/8nfcVFqUr/HlI0rNvaytpdZpOCPdC2n8vNPw0PYqFur3T3iJIQ/YmwhCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794358601;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version;
	bh=8M2GRTmwZfg4xBPhsajSayR2Memepha6rDjcKPmjjCA=;
	b=MDNwOCTvQGfVVda0h0ri3Wn5BGclkJ/ZWliz5/MdbVsmG78dzItQpMfCsc5HPGy0Zx6K
	 u5XQodP2zppxQNEcc90NNjkdA5DjOZCxX8zQ54WzGm1iXoNWvLf4J/LrkF0NK1rlInfj3
	 UPiERkrm3PHWStyVrUoMUkpgGdDGY1ZY3G11bg5xxcXWfnjahIZm1HLK/XAeJ0vYBvF9z
	 q4nDNkX102ChpoBzOYQzBvnBOcyrgfL3f4r/SZWzQyUnvdQ3bGPUYrzGFpv3+9XIwzgXu
	 Zve6PXHP2phieySEwyQTghk5WRI5QntM8H5LeHK1xHOVIuG32t+KeAjzslg+LYPOgzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=P8C5X7t4;
	arc=none smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0AD9606A327;
	Wed, 11 Nov 2026 00:56:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A0AD9606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=P8C5X7t4
Received: from pps.filterd (m0528008.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AB0WPQX2321367;
	Tue, 10 Nov 2026 16:56:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=8M2GRTmwZfg4xBPhsajSayR2Memepha6rDjcK
	PmjjCA=; b=P8C5X7t41RWM/lE/850DJMq0ITGAeEJMiqLVqNhod8Qe0n8Kuf1tg
	2YrV38lJcKYbd1cECPHFokQFBywehe1hVCVKiQr+IaJIzFcDWldv9g7ReW4wHi+m
	OhlFF40ltnZCMjdlKJ+nJdZjEf9qdP6HLjIun68NfJ70HM/BQgsXP5ki8pezpC3X
	kr9mAdyH82Y2AW2S4tx0j6YOq2eJ0tM+a7IpBe1VMaCqQKAeWAQk3srbf2f9S75C
	2Q464sq2n3TFwugNT/0/6J+BxjoJ1kkz0qE5r9p3UXF7npTsDKGtHvgh48iStOlV
	9/5xj4NJfQLEH62fsBq+CQ+iw9ApiYvJA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4hv9q72bcn-20
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 10 Nov 2026 16:56:12 -0800 (PST)
Received: from localhost (2620:10d:c0a8:1b::8e35) by mail.thefacebook.com
 (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Wed, 11 Nov
 2026 00:56:09 +0000
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
Subject: [PATCH net-next v1 10/15] net/sched: flower: add psp_spi, psp_ver, and psp_dev matches
Date: Tue, 10 Nov 2026 16:55:28 -0800
Message-ID: <20261111005533.6436-11-toddfreed@meta.com>
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
X-Proofpoint-ORIG-GUID: TKKIcqpsHd-_6dR41IbPuUOgBv0VV_SG
X-Proofpoint-GUID: TKKIcqpsHd-_6dR41IbPuUOgBv0VV_SG
X-Authority-Analysis: v=2.4 cv=ecuo7LEH c=1 sm=1 tr=0 ts=6af3bd2c cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=_1IyUuN4QrATX339ibzo:22 a=VabnemYjAAAA:8 a=FpQEqpppD9wtLWwVeTUA:9
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDAwMyBTYWx0ZWRfX5tKxQwDfBoGl
 sKZalr81+O8DvTpy6XZw6rYXsineRaOCEM//TsPg5m7eRCFd18MQAmCvxrYd1d51qmIohdtGJP4
 spBcvqs6IsKEe2YUSn6uYOR1iZm0PvX0ANPukjyXM509L75Gi3FzVop2NhtiP32S5Mn8Dn4Irfe
 zmtposDqSQKUWRkPLsU6kFhbxeCJuyfiDRAt3lQAk+cX8CQD5RD7TlQzcn9DrB57fTSVfycuE8p
 lJJJAHroGHcuds8q4R1u9waN3bEwuH6DqHkcXtxaV7V2rFz98TxNe3K3u+mTf0Bsk/rAqOi8cBK
 tRieb0YHKgJfxTJNx8uDD1vvIiG51386pt/hNNg4k3gva7GMZHtZys1bxFC2ZKfN+a21LvZ20bM
 xYzsTyQ1YrPdxLnApPKPo37kHL1eHMBFRLC04CA3A/RZmIc8D/MARgwSud7W7BCCR391oRMNHFy
 Fd2Jfn/LIOsk4xZ8jUg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDAwMyBTYWx0ZWRfX6Yoqz73geqb/
 O3U9zfZJspQn4f4YdCCORhDCSB/bKZEw63kMQiwkg7YY3x+SIwBEbt+2s0yis9pNFyrx3SO0GzD
 N1A++hnPkdvQSfMJ8sC1tvmS8Rqj/BM=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-10_07,2026-11-06_01,2025-10-01_01

Add a flow dissector key filled from the PSP Rx state (SKB_EXT_PSP) the
device attached to a decrypted packet, and corresponding flower matches.
SPI the packet was decrypted with (psp_spi, with a mask), PSP version
(psp_ver), and the ID of the PSP device which decrypted it (psp_dev).

For example, to take the packets of one Rx association, (created with
rx-spi-alloc), and remove their PSP state so that they can be forwarded,

  tc filter add dev eth0 ingress protocol ipv6 flower
      psp_spi 0x80000001 psp_ver 0 psp_dev 1
      action psp decap

Together these matches tie a rule to one association, in a form which
hw can match on (offload comes in a follow-up series). The SPI is only
unique on its PSP device, and an association has one PSP version. This
matches the per-packet check that psp sockets have against its
association, with one exception - the generation of the device key is
not checked.

this means that a rule matching packets that correspond to an rx
association which is stale (two rotations have passed), can still match.

It is therefore important that a rule which matches a SPI should be
replaced before the device key has had two rotations. follow up work
will bring enforcement of this based on key rotation events.

Note that this only ever matches packets which were decrypted, even if
the mask is 0. So "psp_spi 0/0" matches any decrypted PSP packet.

Signed-off-by: Todd Freed <toddfreed@meta.com>
---
 Documentation/netlink/specs/tc.yaml | 14 +++++++
 include/linux/skbuff.h              |  4 ++
 include/net/flow_dissector.h        | 18 ++++++++
 include/uapi/linux/pkt_cls.h        |  5 +++
 net/core/flow_dissector.c           | 27 ++++++++++++
 net/sched/cls_flower.c              | 64 +++++++++++++++++++++++++++++
 6 files changed, 132 insertions(+)

diff --git a/Documentation/netlink/specs/tc.yaml b/Documentation/netlink/specs/tc.yaml
index b6ccc645b0e3..044938316ffd 100644
--- a/Documentation/netlink/specs/tc.yaml
+++ b/Documentation/netlink/specs/tc.yaml
@@ -2908,6 +2908,20 @@ attribute-sets:
         byte-order: big-endian
         enum: flower-key-ctrl-flags
         enum-as-flags: true
+      -
+        name: key-psp-spi
+        type: u32
+        byte-order: big-endian
+      -
+        name: key-psp-spi-mask
+        type: u32
+        byte-order: big-endian
+      -
+        name: key-psp-version
+        type: u8
+      -
+        name: key-psp-dev
+        type: u32
   -
     name: flower-key-enc-opts-attrs
     name-prefix: tca-flower-key-enc-opts-
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 73365c5de6f9..e65de3f5c136 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1660,6 +1660,10 @@ void skb_flow_dissect_hash(const struct sk_buff *skb,
 			   struct flow_dissector *flow_dissector,
 			   void *target_container);
 
+void skb_flow_dissect_psp(const struct sk_buff *skb,
+			  struct flow_dissector *flow_dissector,
+			  void *target_container);
+
 static inline __u32 skb_get_hash_net(const struct net *net, struct sk_buff *skb)
 {
 	if (!skb->l4_hash && !skb->sw_hash)
diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index ced79dc8e856..151ae03d5ad5 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -339,6 +339,23 @@ struct flow_dissector_key_cfm {
 	u8	opcode;
 };
 
+/**
+ * struct flow_dissector_key_psp - PSP Rx state of a decrypted packet
+ * @spi: SPI of the PSP association the packet was decrypted with
+ * @dev_id: ID of the PSP device which decrypted the packet
+ * @version: PSP version (enum psp_version) the packet was decrypted with
+ * @present: packet was decrypted by a PSP device
+ *
+ * Taken from the PSP Rx state the device attached to the skb, not from the
+ * packet, which no longer carries the PSP header.
+ */
+struct flow_dissector_key_psp {
+	__be32	spi;
+	u16	dev_id;
+	u8	version;
+	u8	present;
+};
+
 #define FLOW_DIS_CFM_MDL_MASK GENMASK(7, 5)
 #define FLOW_DIS_CFM_MDL_MAX 7
 
@@ -376,6 +393,7 @@ enum flow_dissector_key_id {
 	FLOW_DISSECTOR_KEY_L2TPV3, /* struct flow_dissector_key_l2tpv3 */
 	FLOW_DISSECTOR_KEY_CFM, /* struct flow_dissector_key_cfm */
 	FLOW_DISSECTOR_KEY_IPSEC, /* struct flow_dissector_key_ipsec */
+	FLOW_DISSECTOR_KEY_PSP, /* struct flow_dissector_key_psp */
 
 	FLOW_DISSECTOR_KEY_MAX,
 };
diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 14cff8f5da74..0cfa7425404b 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -561,6 +561,11 @@ enum {
 	TCA_FLOWER_KEY_ENC_FLAGS,	/* be32 */
 	TCA_FLOWER_KEY_ENC_FLAGS_MASK,	/* be32 */
 
+	TCA_FLOWER_KEY_PSP_SPI,		/* be32 */
+	TCA_FLOWER_KEY_PSP_SPI_MASK,	/* be32 */
+	TCA_FLOWER_KEY_PSP_VERSION,	/* u8, enum psp_version */
+	TCA_FLOWER_KEY_PSP_DEV,		/* u32, PSP device ID */
+
 	__TCA_FLOWER_MAX,
 };
 
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 1be6c739e3c7..95d3fa3b1568 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -28,6 +28,7 @@
 #include <linux/ptp_classify.h>
 #include <net/flow_dissector.h>
 #include <net/pkt_cls.h>
+#include <net/psp/types.h>
 #include <scsi/fc/fc_fcoe.h>
 #include <uapi/linux/batadv_packet.h>
 #include <linux/bpf.h>
@@ -511,6 +512,32 @@ void skb_flow_dissect_hash(const struct sk_buff *skb,
 }
 EXPORT_SYMBOL(skb_flow_dissect_hash);
 
+void skb_flow_dissect_psp(const struct sk_buff *skb,
+			  struct flow_dissector *flow_dissector,
+			  void *target_container)
+{
+#if IS_ENABLED(CONFIG_INET_PSP)
+	struct flow_dissector_key_psp *key;
+	struct psp_skb_ext *pse;
+
+	if (!dissector_uses_key(flow_dissector, FLOW_DISSECTOR_KEY_PSP))
+		return;
+
+	pse = skb_ext_find(skb, SKB_EXT_PSP);
+	if (!pse)
+		return;
+
+	key = skb_flow_dissector_target(flow_dissector,
+					FLOW_DISSECTOR_KEY_PSP,
+					target_container);
+	key->spi = pse->spi;
+	key->dev_id = pse->dev_id;
+	key->version = pse->version;
+	key->present = 1;
+#endif
+}
+EXPORT_SYMBOL(skb_flow_dissect_psp);
+
 static enum flow_dissect_ret
 __skb_flow_dissect_mpls(const struct sk_buff *skb,
 			struct flow_dissector *flow_dissector,
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 23eba4a00a94..f983deab1a6d 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -81,6 +81,7 @@ struct fl_flow_key {
 	struct flow_dissector_key_l2tpv3 l2tpv3;
 	struct flow_dissector_key_ipsec ipsec;
 	struct flow_dissector_key_cfm cfm;
+	struct flow_dissector_key_psp psp;
 } __aligned(BITS_PER_LONG / 8); /* Ensure that we can do comparisons as longs. */
 
 struct fl_flow_mask_range {
@@ -343,6 +344,7 @@ TC_INDIRECT_SCOPE int fl_classify(struct sk_buff *skb,
 				    ARRAY_SIZE(fl_ct_info_to_flower_map),
 				    post_ct, zone);
 		skb_flow_dissect_hash(skb, &mask->dissector, &skb_key);
+		skb_flow_dissect_psp(skb, &mask->dissector, &skb_key);
 		skb_flow_dissect(skb, &mask->dissector, &skb_key,
 				 FLOW_DISSECTOR_F_STOP_BEFORE_ENCAP);
 
@@ -633,6 +635,11 @@ static void *fl_get(struct tcf_proto *tp, u32 handle)
 	return __fl_get(head, handle);
 }
 
+/* SKB_EXT_PSP holds the PSP device ID in 16 bits */
+static const struct netlink_range_validation fl_psp_dev_range = {
+	.max = U16_MAX,
+};
+
 static const struct nla_policy fl_policy[TCA_FLOWER_MAX + 1] = {
 	[TCA_FLOWER_UNSPEC]		= { .strict_start_type =
 						TCA_FLOWER_L2_MISS },
@@ -745,6 +752,12 @@ static const struct nla_policy fl_policy[TCA_FLOWER_MAX + 1] = {
 	[TCA_FLOWER_KEY_SPI]		= { .type = NLA_U32 },
 	[TCA_FLOWER_KEY_SPI_MASK]	= { .type = NLA_U32 },
 	[TCA_FLOWER_L2_MISS]		= NLA_POLICY_MAX(NLA_U8, 1),
+	[TCA_FLOWER_KEY_PSP_SPI]	= { .type = NLA_BE32 },
+	[TCA_FLOWER_KEY_PSP_SPI_MASK]	= { .type = NLA_BE32 },
+	/* the version field of the PSP header has 4 bits */
+	[TCA_FLOWER_KEY_PSP_VERSION]	= NLA_POLICY_MAX(NLA_U8, 15),
+	[TCA_FLOWER_KEY_PSP_DEV]	= NLA_POLICY_FULL_RANGE(NLA_U32,
+							&fl_psp_dev_range),
 	[TCA_FLOWER_KEY_CFM]		= { .type = NLA_NESTED },
 	[TCA_FLOWER_KEY_ENC_FLAGS]	= NLA_POLICY_MASK(NLA_BE32,
 							  TCA_FLOWER_KEY_ENC_FLAGS_POLICY_MASK),
@@ -2077,6 +2090,33 @@ static int fl_set_key(struct net *net, struct nlattr *tca_opts,
 			return ret;
 	}
 
+	if (tb[TCA_FLOWER_KEY_PSP_SPI_MASK] && !tb[TCA_FLOWER_KEY_PSP_SPI]) {
+		NL_SET_ERR_ATTR_MISS(extack, tca_opts, TCA_FLOWER_KEY_PSP_SPI);
+		return -EINVAL;
+	}
+	if (tb[TCA_FLOWER_KEY_PSP_SPI] || tb[TCA_FLOWER_KEY_PSP_VERSION] ||
+	    tb[TCA_FLOWER_KEY_PSP_DEV]) {
+		if (!IS_ENABLED(CONFIG_INET_PSP)) {
+			NL_SET_ERR_MSG(extack, "PSP isn't enabled");
+			return -EOPNOTSUPP;
+		}
+		fl_set_key_val(tb, &key->psp.spi, TCA_FLOWER_KEY_PSP_SPI,
+			       &mask->psp.spi, TCA_FLOWER_KEY_PSP_SPI_MASK,
+			       sizeof(key->psp.spi));
+		if (tb[TCA_FLOWER_KEY_PSP_VERSION]) {
+			key->psp.version =
+				nla_get_u8(tb[TCA_FLOWER_KEY_PSP_VERSION]);
+			mask->psp.version = 0xff;
+		}
+		if (tb[TCA_FLOWER_KEY_PSP_DEV]) {
+			key->psp.dev_id = nla_get_u32(tb[TCA_FLOWER_KEY_PSP_DEV]);
+			mask->psp.dev_id = 0xffff;
+		}
+		/* Only match packets which were actually decrypted */
+		key->psp.present = 1;
+		mask->psp.present = 0xff;
+	}
+
 	if (tb[TCA_FLOWER_KEY_ENC_IPV4_SRC] ||
 	    tb[TCA_FLOWER_KEY_ENC_IPV4_DST]) {
 		key->enc_control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
@@ -2263,6 +2303,8 @@ static void fl_init_dissector(struct flow_dissector *dissector,
 			     FLOW_DISSECTOR_KEY_IPSEC, ipsec);
 	FL_KEY_SET_IF_MASKED(mask, keys, cnt,
 			     FLOW_DISSECTOR_KEY_CFM, cfm);
+	FL_KEY_SET_IF_MASKED(mask, keys, cnt,
+			     FLOW_DISSECTOR_KEY_PSP, psp);
 
 	skb_flow_dissector_init(dissector, keys, cnt);
 }
@@ -3651,6 +3693,28 @@ static int fl_dump_key(struct sk_buff *skb, struct net *net,
 			    sizeof(key->ipsec.spi)))
 		goto nla_put_failure;
 
+	if (mask->psp.present &&
+	    fl_dump_key_val(skb, &key->psp.spi, TCA_FLOWER_KEY_PSP_SPI,
+			    &mask->psp.spi, TCA_FLOWER_KEY_PSP_SPI_MASK,
+			    sizeof(key->psp.spi)))
+		goto nla_put_failure;
+	/* With a 0 SPI mask and no version or device, the SPI still carries
+	 * the match on a decrypted packet: dump it with its mask
+	 */
+	if (mask->psp.present && !mask->psp.spi && !mask->psp.version &&
+	    !mask->psp.dev_id &&
+	    (nla_put(skb, TCA_FLOWER_KEY_PSP_SPI, sizeof(key->psp.spi),
+		     &key->psp.spi) ||
+	     nla_put(skb, TCA_FLOWER_KEY_PSP_SPI_MASK, sizeof(mask->psp.spi),
+		     &mask->psp.spi)))
+		goto nla_put_failure;
+	if (mask->psp.version &&
+	    nla_put_u8(skb, TCA_FLOWER_KEY_PSP_VERSION, key->psp.version))
+		goto nla_put_failure;
+	if (mask->psp.dev_id &&
+	    nla_put_u32(skb, TCA_FLOWER_KEY_PSP_DEV, key->psp.dev_id))
+		goto nla_put_failure;
+
 	if ((key->basic.ip_proto == IPPROTO_TCP ||
 	     key->basic.ip_proto == IPPROTO_UDP ||
 	     key->basic.ip_proto == IPPROTO_SCTP) &&
-- 
2.53.0-Meta

