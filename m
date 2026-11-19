Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.153.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051892;
	b=SJsYBn1FfpPLA0Fz+fUUnR5DRtDdirXa++nQXtFIGkoG1kEYF36o9OGHFqR8wUOIrj3p
	 ihujc+jcVJ9jNK6ti4UaI7o/ue+QArhPf1qrRU8dF94WuSRxqEC2iZl3GMRLfyQEr1wou
	 FKA8j66RvQ1VaO3NXYn3qclZ/Y42XG0yBrHK7TC3dROCe8aDBTnSRwUp0twZ9jbDfj3iq
	 0vZ3MKH3/QhIpAyL64CoZoM2BulzhcmnTj4yvlLCutvgMDwNUpm5wWeS4FTSjG93petk6
	 rgyjiuxCtftdnpi+L3PoEsCL6vwqnaPRF1KE8e59PwkPi1n8yCctQFHJaxGl0Y/KzjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051892;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version;
	bh=JaafzbkPP+Dn/pz2750eJGQ9MR7w52gfMi2f6Pii1eg=;
	b=ldHxidrTSj4Mtf4tG6UHHGsAMSdGvBeDqTzrYFZvkggxSTK90Rsu5Z07MjsmoEbObaLG
	 rRvPvVJRNS+cLVHG6zSohEP791L0D7Vneq7HZfEwqZ0T6S6YaGWMCHYSd7ejPRAVSqe3j
	 UzLlM/X116BA5AeVQMqqOsSs+1qdM2Nhg/zRyKxWC74R0x4pjOAVnmdwjrvYgdkjn2KOt
	 ZvNWX/BjlToc2SCRae2Q522NvVsl8TYV4KzDt8WgChzC0Z9WrqBGXZx9hJzke6O3j4KPl
	 ECct5L4dmzJbqxojVkjXD4y75Dm77aPdVddqs3BETCNRck3vQegjnjbp4R/bL97VpJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=hpRRuKhn;
	arc=none smtp.remote-ip=67.231.153.30
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C72C606A32A;
	Thu, 19 Nov 2026 01:31:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C72C606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=hpRRuKhn
Received: from pps.filterd (m0528004.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AJ19S0E1375386;
	Wed, 18 Nov 2026 17:31:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=JaafzbkPP+Dn/pz2750eJGQ9MR7w52gfMi2f6
	Pii1eg=; b=hpRRuKhnwAMbrloulH0nrBEoRRZs5pa9sxsaf2ZAhgkEV2C7SkW3j
	BsmWzISoGk13R2tY6Vm1QZJlKNQA5QebjkyvlKYS67qGC9uY/K1HgDgW1Kjuu5vA
	Gg4riKTYd1Ag0V//e53PFY6m9jEndQX05bMNlIXEV9SgiXi8jsqL+N5eq3CjvQd4
	zcbBfg9aUTi6BVCk974ZC3IH79BRaW8xRdCUS61G+754Uw5CoW3DFhpAhNJpqJvS
	UtThx6KBs1oxIzB0X8Aw1ENpfOJjsoIwtqIAr6CTC1aVzjdnd71Zc6b/RWoLFbm9
	PQDarmX0OLHLYUHypFV16rijmhqsPbPeg==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j0yu6b8r4-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 18 Nov 2026 17:31:16 -0800 (PST)
Received: from localhost (2620:10d:c085:108::150d) by mail.thefacebook.com
 (2620:10d:c08b:78::c78f) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Thu, 19 Nov
 2026 01:31:15 +0000
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
	<willemdebruijn.kernel@gmail.com>
Subject: [PATCH net-next v2 04/12] psp: add support for socket-less psp associations
Date: Wed, 18 Nov 2026 17:30:55 -0800
Message-ID: <20261119013103.1092559-5-toddfreed@meta.com>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261119013103.1092559-1-toddfreed@meta.com>
References: <20261119013103.1092559-1-toddfreed@meta.com>
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
X-Proofpoint-GUID: fk4fJRRkc98aI4TRQ4JFElKWWr9-83AI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE5MDAwNSBTYWx0ZWRfX82U/+wYFlDWV
 p6+g3Lr/nZaALW+hhsLE3HX2Ep+nyZwJVYbVUsahO1zJzTn/Ujc55Wz6b2f2qPthjr5Tqs3KYJA
 rC59DlDUNNMe2AI17f3a2hP5uTf28LqNJBD6KwhL1jQHpetYud/hm7jfRH7N/unSu6CL2ueRO7N
 hvU5UBxHz4Wlmv9LfSeWde1lQDQaOc9pfrVdIQO7aXFlR6RlEqbiVWsAz2gtbK9eUWKV86QiaHt
 qANbWscZ83H22Cg0uq2UxMqyptIIUVVfXPCjz3xJ94bDVdTnYm6pn0kcpSUM/wMWo2YrGYf4Ov7
 6r4Kf5aop1VlUhEeUihbe+ui4laVlrShIyasmpkNGSDJ9J89bCogs++eSf/d2qx8OJ6inTkbO+V
 Qrk8JNZferw9EYZb7V/G07uGin6fFJJM2+4OQ8387O3wFbzBN2JK8oUrzq634TExRFIpJ9ut79U
 Xdn5hg5XXQ12QBY3bJg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE5MDAwNSBTYWx0ZWRfX+Mkd2sziEYtI
 zecnABqiFaa4hhUxGOndSAHtUvzcacZ3S9g8U4wFenN4OL5/2P2L4nVWr+/vxyo53WomKCfgaAO
 LYD7vIYENUrZR0aBZR/P/SsxqlF4IaE=
X-Proofpoint-ORIG-GUID: fk4fJRRkc98aI4TRQ4JFElKWWr9-83AI
X-Authority-Analysis: v=2.4 cv=Mfz5KJ/f c=1 sm=1 tr=0 ts=6afe5165 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=GbPsI2Ihf5RTnMjR_gZv:22 a=VabnemYjAAAA:8 a=32Fng3g8M9Q2q_tFSpAA:9
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-19_01,2026-11-16_01,2025-10-01_01

Currently, a PSP association is bound to a TCP socket when it is
created, and can hold both an Rx and a Tx key.

Add Tx associations which are not bound to a socket, and are referenced
by an ID, so that other parts of the stack can attach them to packets.
See the subsequent patches, where the tc psp action does just this.

Socket-less Rx does not need an association, and the kernel does not
keep anything for this case. For Rx, userspace calls the rx-spi-alloc
operation, and then uses tc filters that match the corresponding SPI,
version, and PSP device. The flower matches for these fields are added
in a subsequent patch.

Add the following new netlink commands. They are admin-only, and
restricted to the netns of the PSP device.

  rx-spi-alloc  allocate an Rx SPI and derived key, without a socket.
                The key is delivered to the peer out of band. Also
                returns the number of key rotations of the PSP device
                so far (key-rotations)
  assoc-add     create a Tx association and install the peer's key,
                returns its ID
  assoc-del     delete a Tx association
  assoc-get     get / dump Tx associations; only the SPI is reported

Socket associations are not addressed by these commands, so for example
assoc-get does not list them.

The kernel doesn't enforce key rotation for socket-less Rx the way it
does for socket associations. A tc filter which matches a SPI of one
generation will also match that SPI if subsequently re-used in another
generation. It is up to userspace to deal with this eventuality by
removing such rules in time. Userspace may subscribe to rotation
notifications for this purpose.

Tx associations hold the peer's key, which device key rotation doesn't
affect. They are on a device list of their own, which key rotation
doesn't walk, and are deleted when their PSP device is unregistered.

The Rx key is returned once, by rx-spi-alloc, and not stored. The Tx
key is passed in by assoc-add and never reported back: assoc-get only
reports the SPI, and users reference Tx associations by ID.

Signed-off-by: Todd Freed <toddfreed@meta.com>
---
 Documentation/netlink/specs/psp.yaml |  91 ++++++++++
 include/net/psp/functions.h          |   1 +
 include/net/psp/types.h              |   2 +
 include/uapi/linux/psp.h             |   6 +
 net/psp/Makefile                     |   2 +-
 net/psp/psp-nl-gen.c                 |  60 +++++++
 net/psp/psp-nl-gen.h                 |   8 +
 net/psp/psp.h                        |   4 +
 net/psp/psp_assoc.c                  | 122 ++++++++++++++
 net/psp/psp_main.c                   |   4 +
 net/psp/psp_nl.c                     | 242 +++++++++++++++++++++++++++
 net/psp/psp_sock.c                   |   1 +
 12 files changed, 542 insertions(+), 1 deletion(-)
 create mode 100644 net/psp/psp_assoc.c

diff --git a/Documentation/netlink/specs/psp.yaml b/Documentation/netlink/specs/psp.yaml
index f3266763c325..5bb08829503d 100644
--- a/Documentation/netlink/specs/psp.yaml
+++ b/Documentation/netlink/specs/psp.yaml
@@ -103,6 +103,21 @@ attribute-sets:
         name: sock-fd
         doc: Sockets which should be bound to the association immediately.
         type: u32
+      -
+        name: id
+        doc: |
+          ID of a Tx association which is not bound to a socket.
+          Such associations can be attached to packets with the tc psp action.
+        type: u32
+        checks:
+          min: 1
+      -
+        name: key-rotations
+        doc: |
+          Number of key rotations of the device (key-rotations in get-stats)
+          when an Rx SPI was allocated. The device decrypts the SPI until its
+          key has been rotated twice more.
+        type: uint
   -
     name: keys
     attributes:
@@ -350,6 +365,82 @@ operations:
           attributes: []
         pre: psp-device-get-locked
         post: psp-device-unlock
+    -
+      name: rx-spi-alloc
+      doc: |
+        Allocate a new Rx key + SPI pair without binding it to a socket.
+        The key is derived by the device and must be passed to the peer
+        out of band, to be installed there with assoc-add. The kernel
+        keeps no state for it: a tc rule takes the packets the device
+        decrypted with the SPI with the flower psp_spi, psp_ver and
+        psp_dev keys. The SPI is decrypted until the device key has been
+        rotated twice more, after which the device can allocate it again:
+        user space must remove rules matching it by then.
+      attribute-set: assoc
+      flags: [admin-perm]
+      do:
+        request:
+          attributes:
+            - dev-id
+            - version
+        reply:
+          attributes:
+            - dev-id
+            - rx-key
+            - key-rotations
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
+        Delete a PSP Tx association which is not bound to a socket.
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
+        Get / dump Tx associations which are not bound to a socket.
+        Key material is never reported: tx-key carries the SPI only.
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
+      dump:
+        reply: *assoc-all
 
 mcast-groups:
   list:
diff --git a/include/net/psp/functions.h b/include/net/psp/functions.h
index 410adb6718c1..210aedc070e6 100644
--- a/include/net/psp/functions.h
+++ b/include/net/psp/functions.h
@@ -23,6 +23,7 @@ int psp_dev_rcv(struct sk_buff *skb, u16 dev_id, u8 generation, bool strip_icv);
 
 /* Kernel-facing API */
 void psp_assoc_put(struct psp_assoc *pas);
+struct psp_assoc *psp_assoc_get_by_id(struct net *net, u32 id);
 
 #if IS_ENABLED(CONFIG_INET_PSP)
 unsigned int psp_key_size(u32 version);
diff --git a/include/net/psp/types.h b/include/net/psp/types.h
index b8905efbd604..be383f8e65d0 100644
--- a/include/net/psp/types.h
+++ b/include/net/psp/types.h
@@ -107,6 +107,7 @@ struct psp_dev {
 	struct list_head active_assocs;
 	struct list_head prev_assocs;
 	struct list_head stale_assocs;
+	struct list_head sockless_assocs;
 
 	struct {
 		unsigned long rotations;
@@ -154,6 +155,7 @@ struct psp_key_parsed {
 
 struct psp_assoc {
 	struct psp_dev *psd;
+	u32 id;
 
 	u16 dev_id;
 	u8 generation;
diff --git a/include/uapi/linux/psp.h b/include/uapi/linux/psp.h
index 1c8899cd4da5..e62462a9542b 100644
--- a/include/uapi/linux/psp.h
+++ b/include/uapi/linux/psp.h
@@ -44,6 +44,8 @@ enum {
 	PSP_A_ASSOC_RX_KEY,
 	PSP_A_ASSOC_TX_KEY,
 	PSP_A_ASSOC_SOCK_FD,
+	PSP_A_ASSOC_ID,
+	PSP_A_ASSOC_KEY_ROTATIONS,
 
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
index 000000000000..257f7885116d
--- /dev/null
+++ b/net/psp/psp_assoc.c
@@ -0,0 +1,122 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* PSP Tx associations which are not bound to a socket.
+ *
+ * They are created and deleted over netlink, and referenced by ID by other
+ * kernel users, e.g. the tc psp action. The registry holds one reference
+ * on each published association.
+ *
+ * There is no corresponding socket-less PSP Rx association.
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
+ * @pas: Tx association with its key installed
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
index 4b48070fb9e5..dde653c81fc5 100644
--- a/net/psp/psp_main.c
+++ b/net/psp/psp_main.c
@@ -87,6 +87,7 @@ psp_dev_create(struct net_device *netdev,
 	INIT_LIST_HEAD(&psd->active_assocs);
 	INIT_LIST_HEAD(&psd->prev_assocs);
 	INIT_LIST_HEAD(&psd->stale_assocs);
+	INIT_LIST_HEAD(&psd->sockless_assocs);
 	refcount_set(&psd->refcnt, 1);
 
 	mutex_lock(&psp_devs_lock);
@@ -147,10 +148,13 @@ void psp_dev_unregister(struct psp_dev *psd)
 
 	list_splice_init(&psd->active_assocs, &psd->prev_assocs);
 	list_splice_init(&psd->prev_assocs, &psd->stale_assocs);
+	list_splice_init(&psd->sockless_assocs, &psd->stale_assocs);
 	list_for_each_entry_safe(pas, next, &psd->stale_assocs, assocs_list) {
 		if (psp_assoc_needs_tx_key_del(pas))
 			psp_dev_tx_key_del(psd, pas);
 		list_del(&pas->assocs_list);
+		if (pas->id)
+			psp_assoc_unpublish(pas);
 	}
 
 	list_for_each_entry_safe(entry, entry_tmp, &psd->assoc_dev_list,
diff --git a/net/psp/psp_nl.c b/net/psp/psp_nl.c
index cdfc2d72fb39..d29b1324dac3 100644
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
@@ -900,6 +913,235 @@ int psp_nl_tx_assoc_doit(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
+int psp_nl_rx_spi_alloc_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct psp_dev *psd = info->user_ptr[0];
+	struct psp_key_parsed key;
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
+	/* Nothing to keep: the SPI is only matched by value (flower) */
+	if (nla_put_u32(rsp, PSP_A_ASSOC_DEV_ID, psd->id) ||
+	    psp_nl_put_key(rsp, PSP_A_ASSOC_RX_KEY, version, &key) ||
+	    nla_put_uint(rsp, PSP_A_ASSOC_KEY_ROTATIONS, psd->stats.rotations)) {
+		err = -EMSGSIZE;
+		goto err_free_rsp;
+	}
+
+	memzero_explicit(&key, sizeof(key));
+
+	return psp_nl_reply_send(rsp, info);
+
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
+	/* Off the lists of socket associations, which key rotation walks:
+	 * the peer's key isn't affected by the rotation of the device key
+	 */
+	list_move_tail(&pas->assocs_list, &psd->sockless_assocs);
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
+
+	/* Report the SPI only, never the key */
+	nest = nla_nest_start(rsp, PSP_A_ASSOC_TX_KEY);
+	if (!nest ||
+	    nla_put_u32(rsp, PSP_A_KEYS_SPI, be32_to_cpu(pas->tx.spi)))
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
index d04146273bf2..fe9fc5cbdc71 100644
--- a/net/psp/psp_sock.c
+++ b/net/psp/psp_sock.c
@@ -140,6 +140,7 @@ void psp_assoc_put(struct psp_assoc *pas)
 	if (pas && refcount_dec_and_test(&pas->refcnt))
 		call_rcu(&pas->rcu, psp_assoc_free_queue);
 }
+EXPORT_SYMBOL_GPL(psp_assoc_put);
 
 void psp_sk_assoc_free(struct sock *sk)
 {
-- 
2.53.1-Meta

