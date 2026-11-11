Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.153.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794358613;
	b=0CysTo1dyW/+QIoaPO4xBF9Pvrb1gCUyWKtqCiWQw3MBQsKQPJThWXf4JqaGS0JhpVgF
	 nv47gv/CMLo8Vr/7zJUu2PFii1IsYukWeLk8D+mz77NNVHf+2YN6mn9i3fH8oVrX2bb7u
	 0+Rz2VDC6G8VuyDLijLxEgufvBj4M7vmM0tY7KYHNAEXCZY+16BWxWi1/eN7yxTaFW1NJ
	 ZjbabUQ2TriEZoVDpvzEQtlKs+clpQYhD/OJSiBOe6uj2ktypchiyjZtLgzTcMKHZVBfa
	 xsQuFKh4a1zO16IRj7dtJGgnzp5PRnEa549+C6/B2a9Fl/B1zg1Yv9PTiAZVSBgyCcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794358613;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version;
	bh=wxsKXbvGU9OxjJhajYMkcaYYVhgFUpgBe3xzaJ4KkQ8=;
	b=dh/zkjxtPFz8McHDujqekV2kyhyHfK8Pkuu112C1d/VdRJbK6xdCkUDBlllxsoLHSF5/
	 apRq2qv1Koi4Jy6ddBMbQhYwqb/QtNwsJ0n6tB+gLgfkKeXQhvFan2ZcPRLaIX5dGKd1w
	 7KeAv0bVpmcmYXva1F9zxet4YX/22uXbPcodDjOWaCTxQEMcvgjTrDMl3VugQ3W2dIPhO
	 Zdpe/T02UwAMKCsGHg73zU3cKijNW4Jqpqhgtcc/QhXD3kY89Yri4UQhGWyU6l6F35OC/
	 Obnnn6F7h3OR81ktAZqtDLOAbQIorfqab8We5/i9rCcIAG1/ttMujnE79jEQNMxW9KA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=keR0AEDi;
	arc=none smtp.remote-ip=67.231.153.30
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CC3606B4A9;
	Wed, 11 Nov 2026 00:56:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B1CC3606B4A9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=keR0AEDi
Received: from pps.filterd (m0528004.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AB0WXqM2947202;
	Tue, 10 Nov 2026 16:56:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=wxsKXbvGU9OxjJhajYMkcaYYVhgFUpgBe3xza
	J4KkQ8=; b=keR0AEDiAHGjRup6CKSXTfUh23/J69eVCbEMDPA3SRl1pYRZ1WldX
	TvPDv887Y5NHJU61ofBN9B6kM+EEtiENjBWoDEptI4wp7bzDFSn/JbE1uLEkCF9R
	uqBvQQ97NpxUF4wlv86+otZaxnNZ0zG5Nommeeg3wUbUTUgdLGrAxDOpIQ2ySnml
	7MyffpBki7vYrffllu7REcbSgw5CHeYPw/0H35HHwEtsO7zkskYcDpwrrqPxwhum
	e/E860vm0p6D8AHU74jZDaLyY/QYbnrmcT1jwPRofnffO+PRjUtp8k6RBaEzk3Ca
	4Ml36i1GRAjMLBfV6pY5l+wrUKSRsqofg==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4hvaej9r92-6
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 10 Nov 2026 16:56:17 -0800 (PST)
Received: from localhost (2620:10d:c085:208::7cb7) by mail.thefacebook.com
 (2620:10d:c08b:78::c78f) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Wed, 11 Nov
 2026 00:56:08 +0000
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
Subject: [PATCH net-next v1 09/15] net/sched: add act_psp for psp transport mode
Date: Tue, 10 Nov 2026 16:55:27 -0800
Message-ID: <20261111005533.6436-10-toddfreed@meta.com>
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
X-Authority-Analysis: v=2.4 cv=LZipeTfi c=1 sm=1 tr=0 ts=6af3bd31 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=GbPsI2Ihf5RTnMjR_gZv:22 a=VabnemYjAAAA:8 a=XToDuUvxpERQ3bCqDU0A:9
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-GUID: rydZz7lOQhk2PEEZnyNcx-v-HrH4kuNC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDAwMyBTYWx0ZWRfX4g0DGrM5eSes
 R8/H9zpbgCABG29YnDFPvAzLI2DjSjh8mp1hvqv8ySHlyx+FAApeGCVd4JBSWTZbseHpmAnhGhT
 +yGX1LlyAWcD344KuJL6z/dS2OUP+AfGls0woUF1Olm5xy9gfLmQO2PPykuy5yB+XJ8J+ubosw0
 W2LDzBR6jpR7Ba0uayNwC/tSUBXf6KtnuROmwgSpzssu6mpGoM4rwBWA9l37MKX9JJArZrvSsJe
 7spMI8ytsCLEuYYZkpOITrwhgGZdf2xOMIZyMfEmNOGgunDPo53d6XfjCm2HV+rQsf8wBKj4FOx
 EYb8lrdl4E5i3TcDZYeUs4so4pBuIqK9i0LkWpIUQcCUy1Vt8EtsWbIUCdAr/Yv8eECbH5aZU3Z
 mlLwcM1sMrYlog662yRz3RCn9vX2BXGDwBbU4HrX29OwYnjw62VPS9THzbShni7j6BDgu0pjbIm
 Ckhyry90cMSC6KGPyzQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDAwMyBTYWx0ZWRfX4+Cb3g4FgutQ
 HkRuzy15mh4hGg9AGFpMUpQ9jGRZ+urvJDTO8YB4ZCXcw14Oyz0BnLDf4z7sSpXJc7QY0h3iwpF
 TpV52hFZg3c9E/B656WvKDNZ5o0QT/s=
X-Proofpoint-ORIG-GUID: rydZz7lOQhk2PEEZnyNcx-v-HrH4kuNC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-10_07,2026-11-06_01,2025-10-01_01

adds tc action act_psp for psp transport mode encapsulation and
encryption.

encap attaches a psp tx association to the skb as a METADATA_PSP dst.
The packet must then be transmitted on the association's PSP device's
main netdev, which encrypts it: encap on that netdev's egress, or a
redirect there from another netdev's egress. Any other device drops it.

encap on ingress is hardware offload only, like tunnel mode: in
software, the action drops the packet. an ingress-encapped packet would
go through the stack with only its METADATA_PSP dst to keep it from
leaving in clear text, and many paths replace the dst: routing,
netfilter, bpf redirects, tc actions on the way out.

on egress, encap sets skb->decrypted, so that sk_validate_xmit_skb()
drops the packet if it loses the METADATA_PSP dst on the way. mirred
and bpf don't send such a packet back to ingress (previous patches).

Some kinds of packets are not supported and will be dropped,

 - ipv4 fragments. encap inserts udp+psp between the l3 and l4 headers,
   so transport mode can't carry fragments. tunnel mode psp, which a
   later series adds, does support them.
 - ipv6 packets with extension headers, including fragments. some
   extension headers could be supported in the future.
 - packets already encapsulated for a tunnel (skb->encapsulation). some
   tunnel types could be supported in the future.
 - packets which are too large. on transmit, packets which won't fit the
   device's mtu once encapsulated are dropped (see the METADATA_PSP
   patch). the traffic's mtu needs to leave room for the psp encap.
 - packets with another encryption offload: already marked decrypted,
   or of a psp or ktls offload socket, for which sk_validate_xmit_skb()
   would apply the socket's validator instead of checking the
   association. a socket can gain an offload while its packet is queued,
   so sk_validate_xmit_skb() also drops a packet with a METADATA_PSP dst
   whose socket has a validator.

decap removes the PSP Rx state of a packet the device decrypted. to
match packets of only one association, a rule should match the psp
header fields corresponding to the association, e.g. psp_spi / psp_ver /
psp_dev. those flower matches are added in a subsequent patch.

Signed-off-by: Todd Freed <toddfreed@meta.com>
---
 MAINTAINERS                        |   3 +
 include/net/tc_act/tc_psp.h        |  23 ++
 include/uapi/linux/pkt_cls.h       |   1 +
 include/uapi/linux/tc_act/tc_psp.h |  28 ++
 net/core/dev.c                     |  13 +-
 net/sched/Kconfig                  |  13 +
 net/sched/Makefile                 |   1 +
 net/sched/act_psp.c                | 439 +++++++++++++++++++++++++++++
 8 files changed, 519 insertions(+), 2 deletions(-)
 create mode 100644 include/net/tc_act/tc_psp.h
 create mode 100644 include/uapi/linux/tc_act/tc_psp.h
 create mode 100644 net/sched/act_psp.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 76fb13c8730b..a8e45efd8baf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22533,8 +22533,11 @@ F:	Documentation/netlink/specs/psp.yaml
 F:	Documentation/networking/psp.rst
 F:	include/net/psp/
 F:	include/net/psp.h
+F:	include/net/tc_act/tc_psp.h
 F:	include/uapi/linux/psp.h
+F:	include/uapi/linux/tc_act/tc_psp.h
 F:	net/psp/
+F:	net/sched/act_psp.c
 K:	struct\ psp(_assoc|_dev|hdr)\b
 
 PSTORE FILESYSTEM
diff --git a/include/net/tc_act/tc_psp.h b/include/net/tc_act/tc_psp.h
new file mode 100644
index 000000000000..8640d7685475
--- /dev/null
+++ b/include/net/tc_act/tc_psp.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __NET_TC_PSP_H
+#define __NET_TC_PSP_H
+
+#include <net/act_api.h>
+#include <net/dst_metadata.h>
+#include <linux/tc_act/tc_psp.h>
+
+struct tcf_psp_params {
+	struct rcu_head		rcu;
+	int			action;
+	int			psp_action;
+	struct metadata_dst	*md;
+};
+
+struct tcf_psp {
+	struct tc_action		common;
+	struct tcf_psp_params __rcu	*params;
+};
+
+#define to_psp(a) ((struct tcf_psp *)a)
+
+#endif /* __NET_TC_PSP_H */
diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 28d94b11d1aa..14cff8f5da74 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -139,6 +139,7 @@ enum tca_id {
 	TCA_ID_MPLS,
 	TCA_ID_CT,
 	TCA_ID_GATE,
+	TCA_ID_PSP,
 	/* other actions go here */
 	__TCA_ID_MAX = 255
 };
diff --git a/include/uapi/linux/tc_act/tc_psp.h b/include/uapi/linux/tc_act/tc_psp.h
new file mode 100644
index 000000000000..e58ebcae77be
--- /dev/null
+++ b/include/uapi/linux/tc_act/tc_psp.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef __LINUX_TC_PSP_H
+#define __LINUX_TC_PSP_H
+
+#include <linux/pkt_cls.h>
+
+#define TCA_PSP_ACT_ENCAP	1	/* attach a PSP association */
+#define TCA_PSP_ACT_DECAP	2	/* drop PSP Rx state */
+
+struct tc_psp {
+	tc_gen;
+};
+
+enum {
+	TCA_PSP_UNSPEC,
+	TCA_PSP_TM,
+	TCA_PSP_PARMS,
+	TCA_PSP_PAD,
+	TCA_PSP_ACTION,		/* u32, TCA_PSP_ACT_* */
+	TCA_PSP_ASSOC_ID,	/* u32, encap only: Tx association ID from
+				 * the PSP netlink family (assoc-add)
+				 */
+	__TCA_PSP_MAX,
+};
+
+#define TCA_PSP_MAX (__TCA_PSP_MAX - 1)
+
+#endif
diff --git a/net/core/dev.c b/net/core/dev.c
index 2cca5f0d302f..353c0409b3c0 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4154,13 +4154,22 @@ static struct sk_buff *sk_validate_xmit_skb(struct sk_buff *skb,
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
+		/* act_psp doesn't give an association to the packets of a
+		 * socket with its own offload, but the socket can gain one
+		 * while such a packet is queued
+		 */
+		if (unlikely(skb_psp_md(skb))) {
+			kfree_skb_reason(skb, SKB_DROP_REASON_PSP_OUTPUT);
+			skb = NULL;
+		} else {
+			skb = sk_validate(sk, dev, skb);
+		}
 	} else if (unlikely(skb_psp_md(skb))) {
 		int psp = psp_xmit_md(skb, dev);
 
diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index 6ddff028b81a..35f9d76c4cae 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -939,6 +939,19 @@ config NET_ACT_GATE
 	  To compile this code as a module, choose M here: the
 	  module will be called act_gate.
 
+config NET_ACT_PSP
+	tristate "PSP encryption tc action"
+	depends on NET_CLS_ACT && INET_PSP
+	help
+	  Say Y here to allow PSP associations, created through the PSP
+	  netlink family, to be attached to packets. PSP capable devices can
+	  then encrypt them on transmit. Enables transparent psp tunnels for
+	  forwarded traffic.
+
+	  If unsure, say N.
+	  To compile this code as a module, choose M here: the
+	  module will be called act_psp.
+
 config NET_IFE_SKBMARK
 	tristate "Support to encoding decoding skb mark on IFE action"
 	depends on NET_ACT_IFE
diff --git a/net/sched/Makefile b/net/sched/Makefile
index 5078ea84e6ad..9fe8cc0abfdf 100644
--- a/net/sched/Makefile
+++ b/net/sched/Makefile
@@ -31,6 +31,7 @@ obj-$(CONFIG_NET_IFE_SKBTCINDEX)	+= act_meta_skbtcindex.o
 obj-$(CONFIG_NET_ACT_TUNNEL_KEY)+= act_tunnel_key.o
 obj-$(CONFIG_NET_ACT_CT)	+= act_ct.o
 obj-$(CONFIG_NET_ACT_GATE)	+= act_gate.o
+obj-$(CONFIG_NET_ACT_PSP)	+= act_psp.o
 obj-$(CONFIG_NET_SCH_FIFO)	+= sch_fifo.o
 obj-$(CONFIG_NET_SCH_HTB)	+= sch_htb.o
 obj-$(CONFIG_NET_SCH_HFSC)	+= sch_hfsc.o
diff --git a/net/sched/act_psp.c b/net/sched/act_psp.c
new file mode 100644
index 000000000000..4ff54203c9f5
--- /dev/null
+++ b/net/sched/act_psp.c
@@ -0,0 +1,439 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * tc action that attaches a PSP association to packets.
+ *
+ * encap: attach a tx association referenced by its ID, as a METADATA_PSP dst.
+ *        The PSP device's netdev encrypts the packet on transmit. In
+ *        software, egress only: like tunnel mode, encap on ingress is
+ *        hardware offload only.
+ * decap: drop the PSP Rx state (SKB_EXT_PSP) of a decrypted packet. It
+ *        takes no association. a rule which should only take the packets
+ *        of one association matches its properties against psp packet header
+ *        fields (flower psp_spi / psp_ver / psp_dev).
+ */
+
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <net/dst.h>
+#include <net/inet_timewait_sock.h>
+#include <net/ip.h>
+#include <net/netlink.h>
+#include <net/pkt_cls.h>
+#include <net/pkt_sched.h>
+#include <net/psp/functions.h>
+#include <net/tc_act/tc_psp.h>
+
+static struct tc_action_ops act_psp_ops;
+
+/* The device inserts UDP + PSP between the IP header and the transport
+ * header, so the transport header must be right by the time the packet
+ * gets there. On a forwarded packet it may not be. Transport mode doesn't
+ * support IP fragments or IPv6 extension headers.
+ */
+static bool tcf_psp_set_transport_header(struct sk_buff *skb)
+{
+	unsigned int off = skb_network_offset(skb);
+	const struct iphdr *iph;
+	unsigned int hlen, len;
+
+	switch (skb->protocol) {
+	case htons(ETH_P_IP):
+		if (!pskb_may_pull(skb, off + sizeof(*iph)))
+			return false;
+		iph = ip_hdr(skb);
+		if (iph->version != 4 || iph->ihl < 5 || ip_is_fragment(iph))
+			return false;
+		hlen = iph->ihl * 4;
+		len = ntohs(iph->tot_len);
+		if (!pskb_may_pull(skb, off + hlen))
+			return false;
+		break;
+	case htons(ETH_P_IPV6):
+		if (!pskb_may_pull(skb, off + sizeof(struct ipv6hdr)))
+			return false;
+		if (ipv6_hdr(skb)->version != 6 ||
+		    ipv6_ext_hdr(ipv6_hdr(skb)->nexthdr))
+			return false;
+		hlen = sizeof(struct ipv6hdr);
+		len = hlen + ntohs(ipv6_hdr(skb)->payload_len);
+		break;
+	default:
+		return false;
+	}
+
+	/* The device takes the length of the payload from the packet: it must
+	 * hold the IP length, and L2 padding, e.g. of a minimum size frame,
+	 * must not be encrypted as payload. A GSO skb's header doesn't always
+	 * carry its length (BIG TCP).
+	 */
+	if (!skb_is_gso(skb)) {
+		if (len < hlen || skb->len - off < len)
+			return false;
+		if (pskb_trim_rcsum(skb, off + len))
+			return false;
+	}
+
+	skb_set_transport_header(skb, off + hlen);
+	return true;
+}
+
+/* The socket of the packet has its own encryption offload, kTLS or PSP:
+ * sk_validate_xmit_skb() then applies the socket's validator instead of
+ * checking the association.
+ */
+static bool tcf_psp_sk_offload(const struct sk_buff *skb)
+{
+#ifdef CONFIG_SOCK_VALIDATE_XMIT
+	struct sock *sk = skb->sk;
+
+	if (!sk)
+		return false;
+	if (sk_fullsock(sk))
+		return !!READ_ONCE(sk->sk_validate_xmit_skb);
+	return sk_is_inet(sk) && sk->sk_state == TCP_TIME_WAIT &&
+	       inet_twsk(sk)->tw_validate_xmit_skb;
+#else
+	return false;
+#endif
+}
+
+static int tcf_psp_drop(struct tcf_psp *p, struct sk_buff *skb,
+			enum skb_drop_reason reason)
+{
+	tcf_action_inc_drop_qstats(&p->common);
+	tcf_set_drop_reason(skb, reason);
+	return TC_ACT_SHOT;
+}
+
+static int tcf_psp_act(struct sk_buff *skb, const struct tc_action *a,
+		       struct tcf_result *res)
+{
+	struct tcf_psp *p = to_psp(a);
+	struct tcf_psp_params *params;
+
+	params = rcu_dereference_bh(p->params);
+
+	tcf_lastuse_update(&p->tcf_tm);
+	tcf_action_update_bstats(&p->common, skb);
+
+	switch (params->psp_action) {
+	case TCA_PSP_ACT_ENCAP:
+		/* Encap on ingress is hardware offload only, like tunnel
+		 * mode: the packet would go through the stack with nothing
+		 * but its dst, which routing, netfilter or a redirect may
+		 * replace, to keep it from leaving in clear text
+		 */
+		if (unlikely(skb_at_tc_ingress(skb)))
+			return tcf_psp_drop(p, skb, SKB_DROP_REASON_PSP_OUTPUT);
+		/* PSP on a tunnel isn't supported: the encap would overwrite
+		 * the inner headers which the device's tunnel offloads use
+		 */
+		if (unlikely(skb->encapsulation))
+			return tcf_psp_drop(p, skb, SKB_DROP_REASON_PSP_OUTPUT);
+		/* Don't mix the association with another encryption
+		 * offload: the packet is already marked decrypted, or its
+		 * socket has an offload of its own
+		 */
+		if (unlikely(skb_is_decrypted(skb) || tcf_psp_sk_offload(skb)))
+			return tcf_psp_drop(p, skb, SKB_DROP_REASON_PSP_OUTPUT);
+		if (unlikely(!tcf_psp_set_transport_header(skb)))
+			return tcf_psp_drop(p, skb, SKB_DROP_REASON_PSP_OUTPUT);
+		skb_dst_drop(skb);
+		skb_dst_set(skb, dst_clone(&params->md->dst));
+		/* Must be encrypted: sk_validate_xmit_skb() drops it unless
+		 * it still carries the association when it is transmitted
+		 */
+		skb->decrypted = 1;
+		break;
+	case TCA_PSP_ACT_DECAP:
+		/* Only a packet the device decrypted: on transmit,
+		 * skb->decrypted means "device, please encrypt", which decap
+		 * must not undo.
+		 */
+		if (!skb_ext_find(skb, SKB_EXT_PSP))
+			break;
+		skb_ext_del(skb, SKB_EXT_PSP);
+		skb->decrypted = 0;
+		break;
+	}
+
+	return params->action;
+}
+
+static const struct nla_policy psp_policy[TCA_PSP_MAX + 1] = {
+	[TCA_PSP_PARMS]		= NLA_POLICY_EXACT_LEN(sizeof(struct tc_psp)),
+	[TCA_PSP_ACTION]	= NLA_POLICY_RANGE(NLA_U32, TCA_PSP_ACT_ENCAP,
+						   TCA_PSP_ACT_DECAP),
+	[TCA_PSP_ASSOC_ID]	= NLA_POLICY_MIN(NLA_U32, 1),
+};
+
+static void tcf_psp_release_params_rcu(struct rcu_head *head)
+{
+	struct tcf_psp_params *params = container_of(head, typeof(*params),
+						     rcu);
+
+	if (params->md)
+		dst_release(&params->md->dst);
+	kfree(params);
+}
+
+static void tcf_psp_release_params(struct tcf_psp_params *params)
+{
+	if (params)
+		call_rcu(&params->rcu, tcf_psp_release_params_rcu);
+}
+
+static struct metadata_dst *
+tcf_psp_md_create(struct net *net, struct nlattr *id_attr,
+		  struct netlink_ext_ack *extack)
+{
+	struct metadata_dst *md;
+	struct psp_assoc *pas;
+
+	pas = psp_assoc_get_by_id(net, nla_get_u32(id_attr));
+	if (!pas) {
+		NL_SET_ERR_MSG_ATTR(extack, id_attr,
+				    "PSP association not found");
+		return ERR_PTR(-ENOENT);
+	}
+	if (!psp_assoc_is_tx(pas)) {
+		NL_SET_ERR_MSG_ATTR(extack, id_attr,
+				    "encap needs a Tx association (assoc-add)");
+		psp_assoc_put(pas);
+		return ERR_PTR(-EINVAL);
+	}
+
+	md = metadata_dst_alloc(0, METADATA_PSP, GFP_KERNEL);
+	if (!md) {
+		psp_assoc_put(pas);
+		return ERR_PTR(-ENOMEM);
+	}
+	/* The dst now owns the reference on the association */
+	md->u.psp_info.pas = pas;
+
+	return md;
+}
+
+static int tcf_psp_init(struct net *net, struct nlattr *nla,
+			struct nlattr *est, struct tc_action **a,
+			struct tcf_proto *tp, u32 flags,
+			struct netlink_ext_ack *extack)
+{
+	struct tc_action_net *tn = net_generic(net, act_psp_ops.net_id);
+	bool bind = flags & TCA_ACT_FLAGS_BIND;
+	struct nlattr *tb[TCA_PSP_MAX + 1];
+	struct tcf_psp_params *params_new;
+	struct metadata_dst *md = NULL;
+	struct tcf_chain *goto_ch = NULL;
+	struct tc_psp *parm;
+	bool exists = false;
+	int ret = 0, err;
+	struct tcf_psp *p;
+	u32 psp_action;
+	u32 index;
+
+	if (!nla) {
+		NL_SET_ERR_MSG(extack, "PSP action requires attributes");
+		return -EINVAL;
+	}
+
+	err = nla_parse_nested(tb, TCA_PSP_MAX, nla, psp_policy, extack);
+	if (err < 0)
+		return err;
+
+	if (!tb[TCA_PSP_PARMS]) {
+		NL_SET_ERR_MSG(extack, "Missing PSP action parameters");
+		return -EINVAL;
+	}
+
+	parm = nla_data(tb[TCA_PSP_PARMS]);
+	index = parm->index;
+	err = tcf_idr_check_alloc(tn, &index, a, bind);
+	if (err < 0)
+		return err;
+	exists = err;
+	if (exists && bind)
+		return ACT_P_BOUND;
+
+	if (NL_REQ_ATTR_CHECK(extack, nla, tb, TCA_PSP_ACTION)) {
+		NL_SET_ERR_MSG(extack, "Missing PSP action, encap or decap");
+		ret = -EINVAL;
+		goto err_out;
+	}
+	psp_action = nla_get_u32(tb[TCA_PSP_ACTION]);
+
+	switch (psp_action) {
+	case TCA_PSP_ACT_ENCAP:
+		if (NL_REQ_ATTR_CHECK(extack, nla, tb, TCA_PSP_ASSOC_ID)) {
+			NL_SET_ERR_MSG(extack, "Missing PSP association ID");
+			ret = -EINVAL;
+			goto err_out;
+		}
+		md = tcf_psp_md_create(net, tb[TCA_PSP_ASSOC_ID], extack);
+		if (IS_ERR(md)) {
+			ret = PTR_ERR(md);
+			md = NULL;
+			goto err_out;
+		}
+		break;
+	case TCA_PSP_ACT_DECAP:
+		if (tb[TCA_PSP_ASSOC_ID]) {
+			NL_SET_ERR_MSG_ATTR(extack, tb[TCA_PSP_ASSOC_ID],
+					    "decap takes no PSP association");
+			ret = -EINVAL;
+			goto err_out;
+		}
+		break;
+	}
+
+	if (!exists) {
+		ret = tcf_idr_create_from_flags(tn, index, est, a,
+						&act_psp_ops, bind, flags);
+		if (ret)
+			goto release_md;
+
+		ret = ACT_P_CREATED;
+	} else if (!(flags & TCA_ACT_FLAGS_REPLACE)) {
+		NL_SET_ERR_MSG(extack, "PSP action already exists");
+		ret = -EEXIST;
+		goto release_md;
+	}
+
+	err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);
+	if (err < 0) {
+		ret = err;
+		exists = true;
+		goto release_md;
+	}
+	p = to_psp(*a);
+
+	params_new = kzalloc_obj(*params_new);
+	if (!params_new) {
+		ret = -ENOMEM;
+		exists = true;
+		goto put_chain;
+	}
+	params_new->action = parm->action;
+	params_new->psp_action = psp_action;
+	params_new->md = md;
+
+	spin_lock_bh(&p->tcf_lock);
+	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
+	params_new = rcu_replace_pointer(p->params, params_new,
+					 lockdep_is_held(&p->tcf_lock));
+	spin_unlock_bh(&p->tcf_lock);
+
+	tcf_psp_release_params(params_new);
+	if (goto_ch)
+		tcf_chain_put_by_act(goto_ch);
+
+	return ret;
+
+put_chain:
+	if (goto_ch)
+		tcf_chain_put_by_act(goto_ch);
+release_md:
+	if (md)
+		dst_release(&md->dst);
+err_out:
+	if (exists)
+		tcf_idr_release(*a, bind);
+	else
+		tcf_idr_cleanup(tn, index);
+	return ret;
+}
+
+static void tcf_psp_cleanup(struct tc_action *a)
+{
+	struct tcf_psp *p = to_psp(a);
+
+	tcf_psp_release_params(rcu_dereference_protected(p->params, 1));
+}
+
+static int tcf_psp_dump(struct sk_buff *skb, struct tc_action *a,
+			int bind, int ref)
+{
+	unsigned char *b = skb_tail_pointer(skb);
+	struct tcf_psp *p = to_psp(a);
+	struct tcf_psp_params *params;
+	struct tc_psp opt = {
+		.index    = p->tcf_index,
+		.refcnt   = refcount_read(&p->tcf_refcnt) - ref,
+		.bindcnt  = atomic_read(&p->tcf_bindcnt) - bind,
+	};
+	struct tcf_t t;
+
+	rcu_read_lock();
+	params = rcu_dereference(p->params);
+	opt.action = params->action;
+
+	if (nla_put(skb, TCA_PSP_PARMS, sizeof(opt), &opt) ||
+	    nla_put_u32(skb, TCA_PSP_ACTION, params->psp_action))
+		goto nla_put_failure;
+
+	if (params->md &&
+	    nla_put_u32(skb, TCA_PSP_ASSOC_ID, params->md->u.psp_info.pas->id))
+		goto nla_put_failure;
+
+	tcf_tm_dump(&t, &p->tcf_tm);
+	if (nla_put_64bit(skb, TCA_PSP_TM, sizeof(t), &t, TCA_PSP_PAD))
+		goto nla_put_failure;
+	rcu_read_unlock();
+
+	return skb->len;
+
+nla_put_failure:
+	rcu_read_unlock();
+	nlmsg_trim(skb, b);
+	return -1;
+}
+
+static struct tc_action_ops act_psp_ops = {
+	.kind		=	"psp",
+	.id		=	TCA_ID_PSP,
+	.owner		=	THIS_MODULE,
+	.act		=	tcf_psp_act,
+	.dump		=	tcf_psp_dump,
+	.init		=	tcf_psp_init,
+	.cleanup	=	tcf_psp_cleanup,
+	.size		=	sizeof(struct tcf_psp),
+};
+MODULE_ALIAS_NET_ACT("psp");
+
+static __net_init int psp_init_net(struct net *net)
+{
+	struct tc_action_net *tn = net_generic(net, act_psp_ops.net_id);
+
+	return tc_action_net_init(net, tn, &act_psp_ops);
+}
+
+static void __net_exit psp_exit_net(struct list_head *net_list)
+{
+	tc_action_net_exit(net_list, act_psp_ops.net_id);
+}
+
+static struct pernet_operations psp_net_ops = {
+	.init = psp_init_net,
+	.exit_batch = psp_exit_net,
+	.id   = &act_psp_ops.net_id,
+	.size = sizeof(struct tc_action_net),
+};
+
+static int __init psp_init_module(void)
+{
+	return tcf_register_action(&act_psp_ops, &psp_net_ops);
+}
+
+static void __exit psp_cleanup_module(void)
+{
+	tcf_unregister_action(&act_psp_ops, &psp_net_ops);
+}
+
+module_init(psp_init_module);
+module_exit(psp_cleanup_module);
+
+MODULE_DESCRIPTION("PSP encryption tc action");
+MODULE_LICENSE("GPL");
-- 
2.53.0-Meta

