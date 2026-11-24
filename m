Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.153.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795558749;
	b=hapj3zQGB4wCtKdzV1Z2ud/NhyW8qveR4GmeSuIpqD6V76Nz5tCzCcn0sUPc4bYSAumP
	 6elX+FKBZ3JNHRsu9F6A2xql2zUbhprUzPu0o3w/C34hKluACOrrS3zezcD5yzYjhHXES
	 jq4TFQSDYE1u5nczaYxs5tv4Ypoah5Qj1reizmLbe1CbW3/cpkva5mspZbdvNoJ5lvzzN
	 /92dbdKBg/PuEXHOy1g5LmRocJt2pSKYh3wU1Z+/RnNmaJImi2KXgm8TzYP26g9bltwS+
	 4m6WgjkXBtlwBMqs1WXJJKkfUOMfzsBytHT5OR/P3U5xXdicsaCYauFjQqwfJ1KE8hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795558749;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version;
	bh=5+y+pEJjkRlNPLPCUMjFNeoBC6zZvACT5MVl5k5uM+g=;
	b=yiCK0JOw3ek13rC9Jh12o91SGP/3rVIqANXVzH2UX3gt0CKbY1mtQifO1efbTNXRBT8y
	 FlUzyzbYuNZLByUy9zDsb9pFZ1dXEwTWdWB0XxJc/z8djLiLNyeikx4t5EbubItFudrSR
	 4gpuHHEwSoBl6qZrAK8FUyCqYHxnAklOiUL+eEYdtFT5MN2KkcM0hMFET6OKLGvcCs8tt
	 S5y+GVMu6lowz7xAQjWgV3q1PdOSr3VHvDQWfBRvGs2FQnfrDEnqVj5zysllfUAocrmIF
	 LjB90gX4oOlZrOyy/Bruy0yTvtnt1q0x8eWCMnM6NPRjhb8kV1kFuoa1f1gCUPiSbuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=IIw3paMo;
	arc=none smtp.remote-ip=67.231.153.30
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B694A606A326;
	Tue, 24 Nov 2026 22:19:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B694A606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=IIw3paMo
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AOMBBeR1462611;
	Tue, 24 Nov 2026 14:18:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=5+y+pEJjkRlNPLPCUMjFNeoBC6zZvACT5MVl5
	k5uM+g=; b=IIw3paMo5bwlWOU0u1YpRsGSmkRgCEHTRaqSoytolBtu+Wdbgo92k
	8Gzi+ZEn/Luvq+fErnwzuDt+MDvH/xZ3Yv8e5J6M6X6mETlyeXLgdraT/8lnGoyk
	ZvSyGqp45on3AOnlzVApD7G4QexEYocfJXLgTLChiDXwE7BRBfSsKhHrOtAtGSj5
	3oa3Qz4x+0YhHcvZ8ckuMrnHRCEQL4g0nI/QGpMbFGBaXs9w5zDWmBrVM3rmMP4c
	XeqsaIDQ9tQfEBk5vNq3RriplObC1pu5lZUO27gMpsjn/52FV4pZiLuEvQgPMIpe
	YLQgBmGRN3/bZp2EAXuZAGKDNdIhkX0CA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j5eaw2q3v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 24 Nov 2026 14:18:25 -0800 (PST)
Received: from localhost (2620:10d:c0a8:1c::11) by mail.thefacebook.com
 (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Tue, 24 Nov
 2026 22:18:24 +0000
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
Subject: [PATCH net-next v3 07/12] net/sched: flower: add psp_spi, psp_ver, and psp_dev matches
Date: Tue, 24 Nov 2026 14:17:53 -0800
Message-ID: <20261124221758.3230929-8-toddfreed@meta.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI0MDA4NyBTYWx0ZWRfX7XYE2Q0CcUy2
 DimOKe5b5dNamxzPHUOUFTFujO/HJk6wvJsoCl4pIp60zfuQtN9khqPBzDnfHF6y5HN2bZK+BgT
 AuBBRNoWecgarywsuGq2YvYhAVNSyT4jbELgWl1jKjeHfO3y3zQKTiCT81juypnSX4tmauJGk0n
 VBkHzT9eKpgj8FHcrKOTQ+m/JhzayeVxRI4CQE/CouQ4I8lpSgDyRuginQDAiaYtVX8membAyXK
 R+cUvLubOmExTUnE4jg3PxIxgWiz6mHCc73QzWi+noC2pPYACp1To/8AHslAhIKStPo6PlUq79C
 +JlYiKGIk13gxaM0o68UEo7bx9r0x/y4L3mOjLLPOY3yYko+RqS5jfwHz3s9oGXaFrzJQf8W50A
 nReNaZJNXmBW0twk5paitnXi+WdESUg2o84D7AHqQgLOpy0AoO+qMrgen4FSCmdoVFj/D3yT20h
 t3FEL4IhFtOHW980+kw==
X-Proofpoint-GUID: E4J5Ot1bXoTVxhuzwU2hmJFy0ppCnYHO
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI0MDA4NyBTYWx0ZWRfX6WkrXyfbygoC
 0IS4no1xadnSVsw6JFddkN4blCdNCk9BLPDjaWbVXoLXgyDFl8AkpO7qJ6jm+bDPIy9r4e3jVhv
 +LRM6hXXbj/tEs27k4PwvtysLfl5eHA=
X-Proofpoint-ORIG-GUID: E4J5Ot1bXoTVxhuzwU2hmJFy0ppCnYHO
X-Authority-Analysis: v=2.4 cv=cIV1IVeN c=1 sm=1 tr=0 ts=6b060d31 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=wpfVPzegXHpEFt3DAXn9:22 a=VabnemYjAAAA:8 a=UA3dg4tPmuigaKddVqUA:9
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-24_06,2026-11-23_01,2025-10-01_01

Add a flow dissector key filled from the PSP Rx state (SKB_EXT_PSP) the
device attached to a decrypted packet, and corresponding flower matches:
the SPI the packet was decrypted with (psp_spi, with a mask), the PSP
version (psp_ver), and the ID of the PSP device which decrypted it
(psp_dev).

For example, to take the packets of one Rx SPI (allocated with
rx-spi-alloc), and remove their PSP state so that they can be forwarded:

  tc filter add dev eth0 ingress protocol ipv6 flower
      psp_spi 0x80000001 psp_ver 0 psp_dev 1
      action psp decap

Together these matches tie a rule to one Rx SPI, in a form which
hardware can match on (offload comes in a follow-up series). The SPI is
only unique on its PSP device, and is allocated for one PSP version.
This matches the per-packet check that PSP sockets have against their
association, with an important exception - the generation of the device
key is not checked.

This means that a rule for an SPI could match packets after two device
key rotations, if the device allocates the same SPI again (which it is
free to do).

Userspace is responsible for handling this. It must replace a rule which
matches on SPI before the device key has had two rotations. The existing
key rotation notification may be used for this purpose.

No driver offloads these matches yet, and some drivers offload a rule
without checking which keys it uses, so it would match without them.
Don't offload a rule which uses them, and reject it with skip_sw. A
rule which isn't offloaded is not on the filter's hw list either, so
it isn't offloaded later when the block gets another device.

Note that these flower matches only ever match packets which were
decrypted, even if the mask is 0. So "psp_spi 0/0" matches any decrypted
PSP packet.

Signed-off-by: Todd Freed <toddfreed@meta.com>
---
 Documentation/netlink/specs/tc.yaml | 19 ++++++++
 include/linux/skbuff.h              |  4 ++
 include/net/flow_dissector.h        | 18 +++++++
 include/uapi/linux/pkt_cls.h        |  5 ++
 net/core/flow_dissector.c           | 27 ++++++++++
 net/sched/cls_flower.c              | 76 +++++++++++++++++++++++++++++
 6 files changed, 149 insertions(+)

diff --git a/Documentation/netlink/specs/tc.yaml b/Documentation/netlink/specs/tc.yaml
index b6ccc645b0e3..d9d8b21eb1bf 100644
--- a/Documentation/netlink/specs/tc.yaml
+++ b/Documentation/netlink/specs/tc.yaml
@@ -2908,6 +2908,25 @@ attribute-sets:
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
+        checks:
+          max: 15
+      -
+        name: key-psp-dev
+        type: u32
+        checks:
+          min: 1
+          max: 65535
   -
     name: flower-key-enc-opts-attrs
     name-prefix: tca-flower-key-enc-opts-
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 55ab6392301a..c20294084fb7 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1663,6 +1663,10 @@ void skb_flow_dissect_hash(const struct sk_buff *skb,
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
index 23eba4a00a94..d7b6250f417b 100644
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
 
@@ -465,6 +467,16 @@ static int fl_hw_replace_filter(struct tcf_proto *tp,
 	bool skip_sw = tc_skip_sw(f->flags);
 	int err = 0;
 
+	/* No driver offloads the PSP matches yet, and some offload a rule
+	 * without checking which keys it uses: it would match without them
+	 */
+	if (dissector_uses_key(&f->mask->dissector, FLOW_DISSECTOR_KEY_PSP)) {
+		if (!skip_sw)
+			return 0;
+		NL_SET_ERR_MSG_MOD(extack, "PSP matches can't be offloaded");
+		return -EOPNOTSUPP;
+	}
+
 	cls_flower.rule = flow_rule_alloc(tcf_exts_num_actions(&f->exts));
 	if (!cls_flower.rule)
 		return -ENOMEM;
@@ -633,6 +645,12 @@ static void *fl_get(struct tcf_proto *tp, u32 handle)
 	return __fl_get(head, handle);
 }
 
+/* SKB_EXT_PSP holds the PSP device ID in 16 bits, and IDs start at 1 */
+static const struct netlink_range_validation fl_psp_dev_range = {
+	.min = 1,
+	.max = U16_MAX,
+};
+
 static const struct nla_policy fl_policy[TCA_FLOWER_MAX + 1] = {
 	[TCA_FLOWER_UNSPEC]		= { .strict_start_type =
 						TCA_FLOWER_L2_MISS },
@@ -745,6 +763,12 @@ static const struct nla_policy fl_policy[TCA_FLOWER_MAX + 1] = {
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
@@ -2077,6 +2101,34 @@ static int fl_set_key(struct net *net, struct nlattr *tca_opts,
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
+			key->psp.dev_id =
+				nla_get_u32(tb[TCA_FLOWER_KEY_PSP_DEV]);
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
@@ -2263,6 +2315,8 @@ static void fl_init_dissector(struct flow_dissector *dissector,
 			     FLOW_DISSECTOR_KEY_IPSEC, ipsec);
 	FL_KEY_SET_IF_MASKED(mask, keys, cnt,
 			     FLOW_DISSECTOR_KEY_CFM, cfm);
+	FL_KEY_SET_IF_MASKED(mask, keys, cnt,
+			     FLOW_DISSECTOR_KEY_PSP, psp);
 
 	skb_flow_dissector_init(dissector, keys, cnt);
 }
@@ -3651,6 +3705,28 @@ static int fl_dump_key(struct sk_buff *skb, struct net *net,
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
2.53.1-Meta

