Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.153.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794358615;
	b=x3LBiBlrVU0byBAwHwk1MYtM9rO31R+nrxGaSS85gJkYEIs6aL4Ynxrgcs9F4dmlutjd
	 7BoAndTetufF3thvh9DI0WHSwOfYyKwTAbzzXl3FNv66xukaNGhdPLmnoEvP8uPLKCJtb
	 2E2/JEjc9HfGsH4z/hIqhYUWMTybFF3K+3nsUYhrUNmwmw1ivxq4EaDEKm1dE9CDALz0U
	 sBda+3YTlYQID97eDk20viVckq8fkh6H9MWwCs7EgRg8xcnH/SyVUMaZQK3629JEL3Lf7
	 l+nQK4uA9FXLiJn0jqTauOmpf/QmbNpEme0GMkNFDGGr17eiLEMA2I36/EUC+/obIQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794358615;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version;
	bh=fwc37XEtFMtKuRt417UWPT42G15PtpXuHZAN/jyDG5w=;
	b=xiePqIPPg6WSxFYJKr89tQhmpiV3mSM7pAgzLyYy8Zw+gDTEDZbmEBBkZhIVYjpCvHV2
	 w7NlD9KRMbwYEsSOV5wEjl5nU9/1lLMSmsWXrajrMfH5uZ5jgloGqa6XfMDyuU4kYkDqL
	 JLAAw4E8ylNFfBCBrLrJspUWCkMEbnDk8lyXCxhOMxrIrAuOtoWvlz3YiD1A56kAM+nLe
	 5SAZINsk/8/n827AbjcRyE65owP5Uh/v0ieyjMe5vbuKufyzhCVG12cn/9CN9sBUQNcyQ
	 cteFl0fURopdN98XTByP3ByIfpMUf+sTArvrfvsQOKk4sGQyjTv7cRg4cXovs7fkMAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b="MaXt/1Z6";
	arc=none smtp.remote-ip=67.231.153.30
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8366C606D4CB;
	Wed, 11 Nov 2026 00:56:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8366C606D4CB
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=MaXt/1Z6
Received: from pps.filterd (m0528006.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AB0Wa2n1951832;
	Tue, 10 Nov 2026 16:56:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=fwc37XEtFMtKuRt417UWPT42G15PtpXuHZAN/
	jyDG5w=; b=MaXt/1Z6G39/3GyLUKYWhv2xrBFBoKNK9fYTTWuh7P+2EFjzfmbMq
	ccT11RLMEs2iI+FDNDa+GYSh58iBxvg7YsTLHhuMZnSfLXMtTWW3cpIKWQ1Iuars
	tyLfUCZNC72E6uuAhWKgnv46qt7/FxO6d8YK3NoELlmmTUgXDBK9/bdtPHfZtLLY
	IFsjWEkX0NdL1kDZU1fShF4mkt4etIDGYH+Nn4vG9BkXtmqFyIIR2fSVyC7EbNpZ
	Ujxk7XTvSknMO2T+Td8N/ylorHhp2u0Jaf12DeI/GrdhmLjkwXGWvn8oEPi/deBz
	F+5BTdakJxSvdPOV6MeEiIBtYiwkbEk7g==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4hvagvsq8a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 10 Nov 2026 16:56:25 -0800 (PST)
Received: from localhost (2620:10d:c085:108::4) by mail.thefacebook.com
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
Subject: [PATCH net-next v1 04/15] psp: add support for socket-less psp associations
Date: Tue, 10 Nov 2026 16:55:22 -0800
Message-ID: <20261111005533.6436-5-toddfreed@meta.com>
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
X-Authority-Analysis: v=2.4 cv=a5ClZkSF c=1 sm=1 tr=0 ts=6af3bd39 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=kkcUborcUVj0H7zxAXTl:22 a=VabnemYjAAAA:8 a=ebQdxKaz9UBOunIN7DQA:9
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-ORIG-GUID: iAWdoYt-lOwwv89b43AMaWCrmbzM9M1z
X-Proofpoint-GUID: iAWdoYt-lOwwv89b43AMaWCrmbzM9M1z
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDAwMyBTYWx0ZWRfX8OO6xtxl8K/3
 mvSr9W9eLM0u3Eh9V8DJ6cJGyxX/ZUcnAwhg30nVRLkVpQH4W4uz8ZUpJMCLWGLUv2DqeM7jh8P
 asCrBcI0MfmuhVw4oAQDOgnug+2gwmvKbfUDnlwoECXoy1tjqWX3hQ6s0ufDH+Hu7sZWSwznn+K
 aYg9sB7RaOOuju1PzVfFzxVbmkklLKmzeGVcWRG88WOeTuWqEqNVmv+MNj04RpPb3SqwKy8m4LR
 tqHwbrkUIk32TodBq1pU63kmEOsJvf6VoFwY6JhN0NkxzVJxbXln0piGH7GfeKzkCIYGCOwOSzU
 HBJZoyNFcrELh8/lRkSu1RWvCvmzksPg1tmYwUZ+V4HJFS0R7uq1wbeAiHpH52lXuFVBwdd7u6z
 K6bGXxZCPnbMweotn4DonpkYd6d6pb/UXWNtAKlmFbx1dM3gNNrF78NtNMPLspIAyNOaYn4wue5
 N+yk20UfS8Wpe5QrDWg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDAwMyBTYWx0ZWRfX13TEN/KH+adC
 6TiYsbADmeXn1kz9pz8YTnGwKXEvyN0LHXmQWEDURTKdq7AUj4uip8vSTuzgcY/l31mPtYBs3gH
 8jtKcmly15fAmtMhiJKv1WutoFVdZco=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-10_07,2026-11-06_01,2025-10-01_01

currently, a psp association is bound to a tcp socket when it is
created, and can hold both an rx and a tx key.

add a small registry of un-bound associations. These have either an rx
or tx flavor, and are referenced by an id. other parts of the stack can
then attach them to packets. see the subsequent patches, where the tc
psp action does just this.

an rx association records the spi, version, and device key generation,
primarily for describe (assoc-get). a tc filter matches these fields
with the flower keys psp_spi, psp_ver, and psp_dev instead of
referencing the association by id, to facilitate hw offload. these
matches are added in a subsequent patch.

adds the following new netlink commands for managing these associations.
note, these are admin-only and restricted to the netns of the psp device

  rx-spi-alloc  allocate an rx spi + derived key, and publish an rx
                association for it, returns its id. the key is
                delivered to the peer out of band
  assoc-add     create a tx association and install a tx key, returns
                its id
  assoc-del     drop the registry's reference to an association
  assoc-get     get / dump associations ; only the spi is reported

assoc-get and assoc-del operate on both rx and tx associations.

socket associations do not go into the registry, and these apis do not
address them. so for example, assoc-get does not list them.

socket-less associations are on the device's association lists, like
socket associations. they are therefore marked stale by key rotation in
the same way, except tx ones: they hold the peer's key, which the
rotation of the device key doesn't affect. assoc-get reports it
(stale), so that user space can identify such entries.

key material enters through netlink and is never reported back. no key
is stored for rx associations, and users reference associations by id
and never handle keys

published associations are dropped from the registry when their psp
device is unregistered.

Signed-off-by: Todd Freed <toddfreed@meta.com>
---
 Documentation/netlink/specs/psp.yaml |  98 +++++++++-
 include/net/psp/functions.h          |  10 +
 include/net/psp/types.h              |   1 +
 include/uapi/linux/psp.h             |   6 +
 net/psp/Makefile                     |   2 +-
 net/psp/psp-nl-gen.c                 |  60 ++++++
 net/psp/psp-nl-gen.h                 |   8 +
 net/psp/psp.h                        |   4 +
 net/psp/psp_assoc.c                  | 120 ++++++++++++
 net/psp/psp_main.c                   |   2 +
 net/psp/psp_nl.c                     | 261 +++++++++++++++++++++++++++
 net/psp/psp_sock.c                   |   9 +-
 12 files changed, 577 insertions(+), 4 deletions(-)
 create mode 100644 net/psp/psp_assoc.c

diff --git a/Documentation/netlink/specs/psp.yaml b/Documentation/netlink/specs/psp.yaml
index f3266763c325..d7b8469a82c3 100644
--- a/Documentation/netlink/specs/psp.yaml
+++ b/Documentation/netlink/specs/psp.yaml
@@ -103,6 +103,21 @@ attribute-sets:
         name: sock-fd
         doc: Sockets which should be bound to the association immediately.
         type: u32
+      -
+        name: id
+        doc: |
+          ID of an association which is not bound to a socket.
+          Such associations can be attached to packets with the tc psp action.
+        type: u32
+        checks:
+          min: 1
+      -
+        name: stale
+        doc: |
+          Key rotation has retired the device key the association was
+          created under. The device no longer decrypts the SPI of such an
+          association.
+        type: flag
   -
     name: keys
     attributes:
@@ -132,8 +147,9 @@ attribute-sets:
         name: stale-events
         type: uint
         doc: |
-          Number of times a socket's Rx got shut down due to using
-          a key which went stale (fully rotated out).
+          Number of times an Rx association, of a socket or socket-less,
+          got shut down due to using a key which went stale (fully rotated
+          out).
           Kernel statistic.
       -
         name: rx-packets
@@ -350,6 +366,84 @@ operations:
           attributes: []
         pre: psp-device-get-locked
         post: psp-device-unlock
+    -
+      name: rx-spi-alloc
+      doc: |
+        Allocate a new Rx key + SPI pair without binding it to a socket.
+        The key is derived by the device and must be passed to the peer
+        out of band, to be installed there with assoc-add. Also adds an
+        Rx association, which records the SPI, version, and the device
+        key generation, and returns its ID. A tc rule can check
+        decrypted packets against these fields with the flower psp_spi,
+        psp_dev and psp_ver keys.
+      attribute-set: assoc
+      flags: [admin-perm]
+      do:
+        request:
+          attributes:
+            - dev-id
+            - version
+        reply:
+          attributes:
+            - id
+            - dev-id
+            - rx-key
+        pre: psp-assoc-device-get-locked-admin
+        post: psp-device-unlock
+    -
+      name: assoc-add
+      doc: |
+        Add a PSP Tx association which is not bound to a socket.
+        Returns the ID of the new association.
+      attribute-set: assoc
+      flags: [admin-perm]
+      do:
+        request:
+          attributes:
+            - dev-id
+            - version
+            - tx-key
+        reply:
+          attributes:
+            - id
+            - dev-id
+        pre: psp-assoc-device-get-locked-admin
+        post: psp-device-unlock
+    -
+      name: assoc-del
+      doc: |
+        Delete a PSP association which is not bound to a socket, Tx or Rx.
+        Packets and tc actions which still reference it keep it alive.
+      attribute-set: assoc
+      flags: [admin-perm]
+      do:
+        request:
+          attributes:
+            - id
+        reply:
+          attributes: []
+    -
+      name: assoc-get
+      doc: |
+        Get / dump associations which are not bound to a socket.
+        Key material is never reported: Tx associations carry tx-key and
+        Rx associations rx-key, with the SPI only.
+      attribute-set: assoc
+      flags: [admin-perm]
+      do:
+        request:
+          attributes:
+            - id
+        reply: &assoc-all
+          attributes:
+            - id
+            - dev-id
+            - version
+            - tx-key
+            - rx-key
+            - stale
+      dump:
+        reply: *assoc-all
 
 mcast-groups:
   list:
diff --git a/include/net/psp/functions.h b/include/net/psp/functions.h
index 410adb6718c1..d0789a9694bc 100644
--- a/include/net/psp/functions.h
+++ b/include/net/psp/functions.h
@@ -23,6 +23,16 @@ int psp_dev_rcv(struct sk_buff *skb, u16 dev_id, u8 generation, bool strip_icv);
 
 /* Kernel-facing API */
 void psp_assoc_put(struct psp_assoc *pas);
+struct psp_assoc *psp_assoc_get_by_id(struct net *net, u32 id);
+
+/* An association from the ID registry is either a Tx one, from assoc-add,
+ * or an Rx one, from rx-spi-alloc. PSP SPIs are never 0.
+ */
+static inline bool psp_assoc_is_tx(const struct psp_assoc *pas)
+{
+	DEBUG_NET_WARN_ON_ONCE(!pas->id);    /* only socket-less ones */
+	return pas->tx.spi != 0;
+}
 
 #if IS_ENABLED(CONFIG_INET_PSP)
 unsigned int psp_key_size(u32 version);
diff --git a/include/net/psp/types.h b/include/net/psp/types.h
index b8905efbd604..49fa36ad9583 100644
--- a/include/net/psp/types.h
+++ b/include/net/psp/types.h
@@ -154,6 +154,7 @@ struct psp_key_parsed {
 
 struct psp_assoc {
 	struct psp_dev *psd;
+	u32 id;
 
 	u16 dev_id;
 	u8 generation;
diff --git a/include/uapi/linux/psp.h b/include/uapi/linux/psp.h
index 1c8899cd4da5..54b50324211b 100644
--- a/include/uapi/linux/psp.h
+++ b/include/uapi/linux/psp.h
@@ -44,6 +44,8 @@ enum {
 	PSP_A_ASSOC_RX_KEY,
 	PSP_A_ASSOC_TX_KEY,
 	PSP_A_ASSOC_SOCK_FD,
+	PSP_A_ASSOC_ID,
+	PSP_A_ASSOC_STALE,
 
 	__PSP_A_ASSOC_MAX,
 	PSP_A_ASSOC_MAX = (__PSP_A_ASSOC_MAX - 1)
@@ -87,6 +89,10 @@ enum {
 	PSP_CMD_GET_STATS,
 	PSP_CMD_DEV_ASSOC,
 	PSP_CMD_DEV_DISASSOC,
+	PSP_CMD_RX_SPI_ALLOC,
+	PSP_CMD_ASSOC_ADD,
+	PSP_CMD_ASSOC_DEL,
+	PSP_CMD_ASSOC_GET,
 
 	__PSP_CMD_MAX,
 	PSP_CMD_MAX = (__PSP_CMD_MAX - 1)
diff --git a/net/psp/Makefile b/net/psp/Makefile
index eb5ff3c5bfb2..d7f026f937cb 100644
--- a/net/psp/Makefile
+++ b/net/psp/Makefile
@@ -2,4 +2,4 @@
 
 obj-$(CONFIG_INET_PSP) += psp.o
 
-psp-y := psp_main.o psp_nl.o psp_sock.o psp-nl-gen.o
+psp-y := psp_main.o psp_nl.o psp_sock.o psp_assoc.o psp-nl-gen.o
diff --git a/net/psp/psp-nl-gen.c b/net/psp/psp-nl-gen.c
index 0e426ffac398..dbdbe79b569e 100644
--- a/net/psp/psp-nl-gen.c
+++ b/net/psp/psp-nl-gen.c
@@ -67,6 +67,29 @@ static const struct nla_policy psp_dev_disassoc_nl_policy[PSP_A_DEV_NSID + 1] =
 	[PSP_A_DEV_NSID] = { .type = NLA_S32, },
 };
 
+/* PSP_CMD_RX_SPI_ALLOC - do */
+static const struct nla_policy psp_rx_spi_alloc_nl_policy[PSP_A_ASSOC_VERSION + 1] = {
+	[PSP_A_ASSOC_DEV_ID] = NLA_POLICY_MIN(NLA_U32, 1),
+	[PSP_A_ASSOC_VERSION] = NLA_POLICY_MAX(NLA_U32, 3),
+};
+
+/* PSP_CMD_ASSOC_ADD - do */
+static const struct nla_policy psp_assoc_add_nl_policy[PSP_A_ASSOC_TX_KEY + 1] = {
+	[PSP_A_ASSOC_DEV_ID] = NLA_POLICY_MIN(NLA_U32, 1),
+	[PSP_A_ASSOC_VERSION] = NLA_POLICY_MAX(NLA_U32, 3),
+	[PSP_A_ASSOC_TX_KEY] = NLA_POLICY_NESTED(psp_keys_nl_policy),
+};
+
+/* PSP_CMD_ASSOC_DEL - do */
+static const struct nla_policy psp_assoc_del_nl_policy[PSP_A_ASSOC_ID + 1] = {
+	[PSP_A_ASSOC_ID] = NLA_POLICY_MIN(NLA_U32, 1),
+};
+
+/* PSP_CMD_ASSOC_GET - do */
+static const struct nla_policy psp_assoc_get_nl_policy[PSP_A_ASSOC_ID + 1] = {
+	[PSP_A_ASSOC_ID] = NLA_POLICY_MIN(NLA_U32, 1),
+};
+
 /* Ops table for psp */
 static const struct genl_split_ops psp_nl_ops[] = {
 	{
@@ -151,6 +174,43 @@ static const struct genl_split_ops psp_nl_ops[] = {
 		.maxattr	= PSP_A_DEV_NSID,
 		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
 	},
+	{
+		.cmd		= PSP_CMD_RX_SPI_ALLOC,
+		.pre_doit	= psp_assoc_device_get_locked_admin,
+		.doit		= psp_nl_rx_spi_alloc_doit,
+		.post_doit	= psp_device_unlock,
+		.policy		= psp_rx_spi_alloc_nl_policy,
+		.maxattr	= PSP_A_ASSOC_VERSION,
+		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
+	},
+	{
+		.cmd		= PSP_CMD_ASSOC_ADD,
+		.pre_doit	= psp_assoc_device_get_locked_admin,
+		.doit		= psp_nl_assoc_add_doit,
+		.post_doit	= psp_device_unlock,
+		.policy		= psp_assoc_add_nl_policy,
+		.maxattr	= PSP_A_ASSOC_TX_KEY,
+		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
+	},
+	{
+		.cmd		= PSP_CMD_ASSOC_DEL,
+		.doit		= psp_nl_assoc_del_doit,
+		.policy		= psp_assoc_del_nl_policy,
+		.maxattr	= PSP_A_ASSOC_ID,
+		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
+	},
+	{
+		.cmd		= PSP_CMD_ASSOC_GET,
+		.doit		= psp_nl_assoc_get_doit,
+		.policy		= psp_assoc_get_nl_policy,
+		.maxattr	= PSP_A_ASSOC_ID,
+		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
+	},
+	{
+		.cmd	= PSP_CMD_ASSOC_GET,
+		.dumpit	= psp_nl_assoc_get_dumpit,
+		.flags	= GENL_ADMIN_PERM | GENL_CMD_CAP_DUMP,
+	},
 };
 
 static const struct genl_multicast_group psp_nl_mcgrps[] = {
diff --git a/net/psp/psp-nl-gen.h b/net/psp/psp-nl-gen.h
index 24d51bff997f..27474f1ce112 100644
--- a/net/psp/psp-nl-gen.h
+++ b/net/psp/psp-nl-gen.h
@@ -24,6 +24,9 @@ int psp_assoc_device_get_locked(const struct genl_split_ops *ops,
 int psp_device_get_locked_dev_assoc(const struct genl_split_ops *ops,
 				    struct sk_buff *skb,
 				    struct genl_info *info);
+int psp_assoc_device_get_locked_admin(const struct genl_split_ops *ops,
+				      struct sk_buff *skb,
+				      struct genl_info *info);
 void
 psp_device_unlock(const struct genl_split_ops *ops, struct sk_buff *skb,
 		  struct genl_info *info);
@@ -38,6 +41,11 @@ int psp_nl_get_stats_doit(struct sk_buff *skb, struct genl_info *info);
 int psp_nl_get_stats_dumpit(struct sk_buff *skb, struct netlink_callback *cb);
 int psp_nl_dev_assoc_doit(struct sk_buff *skb, struct genl_info *info);
 int psp_nl_dev_disassoc_doit(struct sk_buff *skb, struct genl_info *info);
+int psp_nl_rx_spi_alloc_doit(struct sk_buff *skb, struct genl_info *info);
+int psp_nl_assoc_add_doit(struct sk_buff *skb, struct genl_info *info);
+int psp_nl_assoc_del_doit(struct sk_buff *skb, struct genl_info *info);
+int psp_nl_assoc_get_doit(struct sk_buff *skb, struct genl_info *info);
+int psp_nl_assoc_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb);
 
 enum {
 	PSP_NLGRP_MGMT,
diff --git a/net/psp/psp.h b/net/psp/psp.h
index de4be3320009..cadeb1ad04a2 100644
--- a/net/psp/psp.h
+++ b/net/psp/psp.h
@@ -35,6 +35,10 @@ int psp_sock_assoc_set_tx(struct sock *sk, struct psp_dev *psd,
 			  struct netlink_ext_ack *extack);
 void psp_assocs_key_rotated(struct psp_dev *psd);
 
+int psp_assoc_publish(struct psp_assoc *pas);
+void psp_assoc_unpublish(struct psp_assoc *pas);
+struct psp_assoc *psp_assoc_get_next(struct net *net, unsigned long *index);
+
 static inline void psp_dev_get(struct psp_dev *psd)
 {
 	refcount_inc(&psd->refcnt);
diff --git a/net/psp/psp_assoc.c b/net/psp/psp_assoc.c
new file mode 100644
index 000000000000..db681a17af8c
--- /dev/null
+++ b/net/psp/psp_assoc.c
@@ -0,0 +1,120 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* PSP associations which are not bound to a socket.
+ *
+ * They are created and deleted over netlink, and referenced by ID by other
+ * kernel users, e.g. the tc psp action. The registry holds one reference
+ * on each published association.
+ */
+
+#include <linux/xarray.h>
+#include <net/psp.h>
+
+#include "psp.h"
+
+static DEFINE_XARRAY_ALLOC1(psp_assocs);
+static u32 psp_assoc_next_id;
+
+/**
+ * psp_assoc_publish() - add an association to the ID registry
+ * @pas: association: an Rx one, or a Tx one with its key installed
+ *
+ * On success @pas->id is set and the registry holds its own reference.
+ *
+ * Return: 0 on success, negative errno otherwise.
+ */
+int psp_assoc_publish(struct psp_assoc *pas)
+{
+	int err;
+
+	refcount_inc(&pas->refcnt);
+	err = xa_alloc_cyclic(&psp_assocs, &pas->id, pas, xa_limit_31b,
+			      &psp_assoc_next_id, GFP_KERNEL);
+	if (err < 0) {
+		pas->id = 0;
+		refcount_dec(&pas->refcnt);
+		return err;
+	}
+
+	return 0;
+}
+
+/**
+ * psp_assoc_unpublish() - remove an association from the ID registry
+ * @pas: association
+ *
+ * Drops the registry's reference, unless a concurrent caller already did.
+ */
+void psp_assoc_unpublish(struct psp_assoc *pas)
+{
+	if (xa_cmpxchg(&psp_assocs, pas->id, pas, NULL, 0) == pas)
+		psp_assoc_put(pas);
+}
+
+static int psp_assoc_check_access(struct psp_assoc *pas, struct net *net)
+{
+	struct psp_dev *psd = pas->psd;
+	int err;
+
+	mutex_lock(&psd->lock);
+	if (psp_dev_is_registered(psd))
+		err = psp_dev_check_access(psd, net, true);
+	else
+		err = -ENODEV;
+	mutex_unlock(&psd->lock);
+
+	return err;
+}
+
+/**
+ * psp_assoc_get_by_id() - look up a published association
+ * @net: netns of the caller, must be the netns of the PSP device
+ * @id:  association ID
+ *
+ * Return: association with a reference taken, or NULL.
+ */
+struct psp_assoc *psp_assoc_get_by_id(struct net *net, u32 id)
+{
+	struct psp_assoc *pas;
+
+	rcu_read_lock();
+	pas = xa_load(&psp_assocs, id);
+	if (pas && !refcount_inc_not_zero(&pas->refcnt))
+		pas = NULL;
+	rcu_read_unlock();
+
+	if (pas && psp_assoc_check_access(pas, net)) {
+		psp_assoc_put(pas);
+		pas = NULL;
+	}
+
+	return pas;
+}
+EXPORT_SYMBOL_GPL(psp_assoc_get_by_id);
+
+/**
+ * psp_assoc_get_next() - iterate over published associations
+ * @net:   netns of the caller
+ * @index: in: first ID to consider, out: ID of the returned association
+ *
+ * Return: association with a reference taken, or NULL when done.
+ */
+struct psp_assoc *psp_assoc_get_next(struct net *net, unsigned long *index)
+{
+	struct psp_assoc *pas;
+
+	for (;; (*index)++) {
+		rcu_read_lock();
+		pas = xa_find(&psp_assocs, index, ULONG_MAX, XA_PRESENT);
+		if (pas && !refcount_inc_not_zero(&pas->refcnt)) {
+			rcu_read_unlock();
+			continue;
+		}
+		rcu_read_unlock();
+
+		if (!pas)
+			return NULL;
+		if (!psp_assoc_check_access(pas, net))
+			return pas;
+		psp_assoc_put(pas);
+	}
+}
diff --git a/net/psp/psp_main.c b/net/psp/psp_main.c
index 1eb1617aaf2b..40d3e9897b94 100644
--- a/net/psp/psp_main.c
+++ b/net/psp/psp_main.c
@@ -151,6 +151,8 @@ void psp_dev_unregister(struct psp_dev *psd)
 		if (psp_assoc_needs_tx_key_del(pas))
 			psp_dev_tx_key_del(psd, pas);
 		list_del(&pas->assocs_list);
+		if (pas->id)
+			psp_assoc_unpublish(pas);
 	}
 
 	list_for_each_entry_safe(entry, entry_tmp, &psd->assoc_dev_list,
diff --git a/net/psp/psp_nl.c b/net/psp/psp_nl.c
index cdfc2d72fb39..ace58bee9401 100644
--- a/net/psp/psp_nl.c
+++ b/net/psp/psp_nl.c
@@ -743,6 +743,19 @@ int psp_assoc_device_get_locked(const struct genl_split_ops *ops,
 	return err;
 }
 
+int psp_assoc_device_get_locked_admin(const struct genl_split_ops *ops,
+				      struct sk_buff *skb,
+				      struct genl_info *info)
+{
+	if (GENL_REQ_ATTR_CHECK(info, PSP_A_ASSOC_DEV_ID))
+		return -EINVAL;
+
+	info->user_ptr[0] = psp_device_get_and_lock(genl_info_net(info),
+						    info->attrs[PSP_A_ASSOC_DEV_ID],
+						    true);
+	return PTR_ERR_OR_ZERO(info->user_ptr[0]);
+}
+
 static int
 psp_nl_parse_key(struct genl_info *info, u32 attr, struct psp_key_parsed *key,
 		 unsigned int key_sz)
@@ -900,6 +913,254 @@ int psp_nl_tx_assoc_doit(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
+int psp_nl_rx_spi_alloc_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct psp_dev *psd = info->user_ptr[0];
+	struct psp_key_parsed key;
+	struct psp_assoc *pas;
+	struct sk_buff *rsp;
+	u32 version;
+	int err;
+
+	if (GENL_REQ_ATTR_CHECK(info, PSP_A_ASSOC_VERSION))
+		return -EINVAL;
+
+	version = nla_get_u32(info->attrs[PSP_A_ASSOC_VERSION]);
+	if (!(psd->caps->versions & (1 << version))) {
+		NL_SET_BAD_ATTR(info->extack, info->attrs[PSP_A_ASSOC_VERSION]);
+		return -EOPNOTSUPP;
+	}
+
+	rsp = psp_nl_reply_new(info);
+	if (!rsp)
+		return -ENOMEM;
+
+	err = psd->ops->rx_spi_alloc(psd, version, &key, info->extack);
+	if (err)
+		goto err_free_rsp;
+
+	pas = psp_assoc_create(psd);
+	if (!pas) {
+		err = -ENOMEM;
+		goto err_free_rsp;
+	}
+	pas->version = version;
+	pas->rx.spi = key.spi;
+
+	err = psp_assoc_publish(pas);
+	if (err)
+		goto err_put_pas;
+
+	if (nla_put_u32(rsp, PSP_A_ASSOC_ID, pas->id) ||
+	    nla_put_u32(rsp, PSP_A_ASSOC_DEV_ID, psd->id) ||
+	    psp_nl_put_key(rsp, PSP_A_ASSOC_RX_KEY, version, &key)) {
+		psp_assoc_unpublish(pas);
+		err = -EMSGSIZE;
+		goto err_put_pas;
+	}
+
+	psp_assoc_put(pas);
+	memzero_explicit(&key, sizeof(key));
+
+	return psp_nl_reply_send(rsp, info);
+
+err_put_pas:
+	psp_assoc_put(pas);
+err_free_rsp:
+	memzero_explicit(&key, sizeof(key));
+	nlmsg_free(rsp);
+	return err;
+}
+
+int psp_nl_assoc_add_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct psp_dev *psd = info->user_ptr[0];
+	struct psp_key_parsed key;
+	struct psp_assoc *pas;
+	struct sk_buff *rsp;
+	unsigned int key_sz;
+	u32 version;
+	int err;
+
+	if (GENL_REQ_ATTR_CHECK(info, PSP_A_ASSOC_VERSION) ||
+	    GENL_REQ_ATTR_CHECK(info, PSP_A_ASSOC_TX_KEY))
+		return -EINVAL;
+
+	version = nla_get_u32(info->attrs[PSP_A_ASSOC_VERSION]);
+	if (!(psd->caps->versions & (1 << version))) {
+		NL_SET_BAD_ATTR(info->extack, info->attrs[PSP_A_ASSOC_VERSION]);
+		return -EOPNOTSUPP;
+	}
+
+	key_sz = psp_key_size(version);
+	if (!key_sz)
+		return -EINVAL;
+
+	err = psp_nl_parse_key(info, PSP_A_ASSOC_TX_KEY, &key, key_sz);
+	if (err < 0)
+		return err;
+
+	rsp = psp_nl_reply_new(info);
+	if (!rsp) {
+		err = -ENOMEM;
+		goto err_clear_key;
+	}
+
+	pas = psp_assoc_create(psd);
+	if (!pas) {
+		err = -ENOMEM;
+		goto err_free_rsp;
+	}
+	pas->version = version;
+
+	err = psp_assoc_set_tx(psd, pas, &key, info->extack);
+	if (err)
+		goto err_put_pas;
+
+	err = psp_assoc_publish(pas);
+	if (err)
+		goto err_put_pas;
+
+	if (nla_put_u32(rsp, PSP_A_ASSOC_ID, pas->id) ||
+	    nla_put_u32(rsp, PSP_A_ASSOC_DEV_ID, psd->id)) {
+		psp_assoc_unpublish(pas);
+		err = -EMSGSIZE;
+		goto err_put_pas;
+	}
+
+	psp_assoc_put(pas);
+	memzero_explicit(&key, sizeof(key));
+
+	return psp_nl_reply_send(rsp, info);
+
+err_put_pas:
+	psp_assoc_put(pas);
+err_free_rsp:
+	nlmsg_free(rsp);
+err_clear_key:
+	memzero_explicit(&key, sizeof(key));
+	return err;
+}
+
+int psp_nl_assoc_del_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct psp_assoc *pas;
+	struct sk_buff *rsp;
+
+	if (GENL_REQ_ATTR_CHECK(info, PSP_A_ASSOC_ID))
+		return -EINVAL;
+
+	pas = psp_assoc_get_by_id(genl_info_net(info),
+				  nla_get_u32(info->attrs[PSP_A_ASSOC_ID]));
+	if (!pas) {
+		NL_SET_BAD_ATTR(info->extack, info->attrs[PSP_A_ASSOC_ID]);
+		return -ENOENT;
+	}
+
+	rsp = psp_nl_reply_new(info);
+	if (!rsp) {
+		psp_assoc_put(pas);
+		return -ENOMEM;
+	}
+
+	psp_assoc_unpublish(pas);
+	psp_assoc_put(pas);
+
+	return psp_nl_reply_send(rsp, info);
+}
+
+static int
+psp_nl_assoc_fill(struct psp_assoc *pas, struct sk_buff *rsp,
+		  const struct genl_info *info)
+{
+	struct nlattr *nest;
+	void *hdr;
+
+	hdr = genlmsg_iput(rsp, info);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	if (nla_put_u32(rsp, PSP_A_ASSOC_ID, pas->id) ||
+	    nla_put_u32(rsp, PSP_A_ASSOC_DEV_ID, pas->dev_id) ||
+	    nla_put_u32(rsp, PSP_A_ASSOC_VERSION, pas->version))
+		goto err_cancel_msg;
+	/* Key rotation marks it stale under the device lock */
+	if ((READ_ONCE(pas->generation) & ~PSP_GEN_VALID_MASK) &&
+	    nla_put_flag(rsp, PSP_A_ASSOC_STALE))
+		goto err_cancel_msg;
+
+	/* Report the SPI only, never the key */
+	nest = nla_nest_start(rsp, psp_assoc_is_tx(pas) ? PSP_A_ASSOC_TX_KEY :
+							 PSP_A_ASSOC_RX_KEY);
+	if (!nest ||
+	    nla_put_u32(rsp, PSP_A_KEYS_SPI,
+			be32_to_cpu(psp_assoc_is_tx(pas) ? pas->tx.spi :
+							   pas->rx.spi)))
+		goto err_cancel_msg;
+	nla_nest_end(rsp, nest);
+
+	genlmsg_end(rsp, hdr);
+	return 0;
+
+err_cancel_msg:
+	genlmsg_cancel(rsp, hdr);
+	return -EMSGSIZE;
+}
+
+int psp_nl_assoc_get_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct psp_assoc *pas;
+	struct sk_buff *rsp;
+	int err;
+
+	if (GENL_REQ_ATTR_CHECK(info, PSP_A_ASSOC_ID))
+		return -EINVAL;
+
+	pas = psp_assoc_get_by_id(genl_info_net(info),
+				  nla_get_u32(info->attrs[PSP_A_ASSOC_ID]));
+	if (!pas) {
+		NL_SET_BAD_ATTR(info->extack, info->attrs[PSP_A_ASSOC_ID]);
+		return -ENOENT;
+	}
+
+	rsp = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!rsp) {
+		err = -ENOMEM;
+		goto err_put_pas;
+	}
+
+	err = psp_nl_assoc_fill(pas, rsp, info);
+	if (err)
+		goto err_free_msg;
+
+	psp_assoc_put(pas);
+	return genlmsg_reply(rsp, info);
+
+err_free_msg:
+	nlmsg_free(rsp);
+err_put_pas:
+	psp_assoc_put(pas);
+	return err;
+}
+
+int psp_nl_assoc_get_dumpit(struct sk_buff *rsp, struct netlink_callback *cb)
+{
+	unsigned long index = cb->args[0];
+	struct psp_assoc *pas;
+	int err = 0;
+
+	while ((pas = psp_assoc_get_next(sock_net(rsp->sk), &index))) {
+		err = psp_nl_assoc_fill(pas, rsp, genl_info_dump(cb));
+		psp_assoc_put(pas);
+		if (err)
+			break;
+		index++;
+	}
+	cb->args[0] = index;
+
+	return err;
+}
+
 static int
 psp_nl_stats_fill(struct psp_dev *psd, struct sk_buff *rsp,
 		  const struct genl_info *info)
diff --git a/net/psp/psp_sock.c b/net/psp/psp_sock.c
index d04146273bf2..609b06c7af65 100644
--- a/net/psp/psp_sock.c
+++ b/net/psp/psp_sock.c
@@ -140,6 +140,7 @@ void psp_assoc_put(struct psp_assoc *pas)
 	if (pas && refcount_dec_and_test(&pas->refcnt))
 		call_rcu(&pas->rcu, psp_assoc_free_queue);
 }
+EXPORT_SYMBOL_GPL(psp_assoc_put);
 
 void psp_sk_assoc_free(struct sock *sk)
 {
@@ -310,7 +311,13 @@ void psp_assocs_key_rotated(struct psp_dev *psd)
 	 * be able to Rx any traffic.
 	 */
 	list_for_each_entry_safe(pas, next, &psd->prev_assocs, assocs_list) {
-		pas->generation |= ~PSP_GEN_VALID_MASK;
+		/* A socket-less Tx association holds the peer's key, which
+		 * the rotation of the device key doesn't affect
+		 */
+		if (pas->id && psp_assoc_is_tx(pas))
+			continue;
+		WRITE_ONCE(pas->generation,
+			   pas->generation | ~PSP_GEN_VALID_MASK);
 		psd->stats.stales++;
 	}
 	list_splice_init(&psd->prev_assocs, &psd->stale_assocs);
-- 
2.53.0-Meta

