Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.145.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051904;
	b=GF9fFI1xT4dO6FQ3Uw4pWeQxZ47JF+wFRi28P7rTVC1+Ak7RMb2eFM883S5ofq7KuYOi
	 1SLSJw6Y4qHR19iSWKB4w0m/FFPst4v2S9CmY1BDauzbrawKOEZxLNxPoewijqzbI51Vh
	 TjRqYmliQscbUdHFWxLr1Sl/ez5Ty4YWXwq1a18E2DIAPMEEkwDbh4ILYP6gZTGXdT9gk
	 TZULfhHJSUMSf0X1PwzZBI5RqBW0CGXrl2N8tPFTnhjkdHrKBYTPqzDni7fuL8tOckmSD
	 NT9Hudw5ccRkUK76LBXBtc8C2u80m+FUK+mC01DgcseGF9RoLcSK3iMdv/tmBh92amg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051904;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version;
	bh=3aCnZGl7Y2HKrFQKgFgQE+J8/MV2oIEH5IyXTbRFO2I=;
	b=ber3Ed3Olb1dGCDkb+sUv2SaNDUnZrqvOvgB+bJe3EVzJt4xdmAOh614LE+1FEr6AedW
	 zxjy3O5AYj5+Yzzi+ifF7ah0r7gmwP3wxjckGktjrCIqO99UACrlSsVWVE4RIUC4xDeMp
	 AHo/uJ82yvEZmTmQg2yXQSMag4AgaEPcD7DZzde12rVltxjSjm9PKdENoKiaIrwbCyRDp
	 NbqR5GZf29eMnBiZpVE6U7cN7W8fdnpTjijjic268IAwwRdL1BZxD7LsWX5ZTqWYgq/Tt
	 4P+HEqwC12ddq2E7CF8URuVUDEBsTpYiUE8T1zNfcjSW8hx1zAXA7OQ+MzF63qO9p4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=O3ER5FOb;
	arc=none smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C1260A6F7E;
	Thu, 19 Nov 2026 01:31:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 73C1260A6F7E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=O3ER5FOb
Received: from pps.filterd (m0528009.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AJ18x6P1506426;
	Wed, 18 Nov 2026 17:31:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=3aCnZGl7Y2HKrFQKgFgQE+J8/MV2oIEH5IyXT
	bRFO2I=; b=O3ER5FOb1RsX1BK4g6qFRo7adOznYzcN5KVE8T751aX8Buss/AL0t
	KjusJbEocxtgWKP5N/HMtHzeqEMoo+8FbQyhA6op7N2GiFczFJ88rE/SMGT1Ygqz
	530DB5tpUm+TCLLPLbxyDGkyYoSJhBAQ8s7xLjwjsYs7XBF/p04iX5qqtPUmPjKv
	Axfo0UmGe6IZdrbG2RsbTHKmFsek2utd0OIma9E9t8DNXCiS1LqDgT4aR2xBxZYl
	MYcLEOrrwAR30S2o3W3LvoLiqcudFTTX2IkZcc1p4brE4TXba54PVydqpG/3w+11
	GQQVHV1OzWnnGuwp9Vg7oFUgwe6PGEbew==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j0yu638gk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 18 Nov 2026 17:31:30 -0800 (PST)
Received: from localhost (2620:10d:c085:208::f) by mail.thefacebook.com
 (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Thu, 19 Nov
 2026 01:31:29 +0000
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
Subject: [PATCH net-next v2 12/12] Documentation: networking: psp: document socket-less associations
Date: Wed, 18 Nov 2026 17:31:03 -0800
Message-ID: <20261119013103.1092559-13-toddfreed@meta.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE5MDAwNSBTYWx0ZWRfXxAfGkQsLQVpW
 WrVqGZHMULSnEGBQzN01sXQFSQ567gNbcN434BxofXD/0U16dhb2/7/3k+5PgbXvUYaigMmqdBg
 csKNiCppMG9/zbQKmjE7jIAXHHNRvrwT4/G22ViI67DcNwEaQejO2X0qrDkwX1UajG9GGtx017A
 CQBmPq7+2HhuTMdEYgzFYXjl6SOsUjWdbL8PUdFdlfCEoXDMVoNNA6yCDXQrt7B+qC/WcS++jP6
 SkwjCAFIDROWvx6tTbTEa6oBR6RDa9aOzmcamw7k+Vyev0qv2OgQQ9ifxaaWLRe5BHQ5CN4K4D5
 ujLMxKK+ku+ru4ra846lvxxOY8Id15VGiDqYA2Rm2F0hdMGuQE7iPpDNqkjP+DjzPhgn9jtLfKl
 Dmu1+e95mfuoHfL4C9aTvrTHKvfg01Uo4hMsaZ0vEPuy6ko8eJLL09/bEhhnt9/uVX1DUG/wBT9
 DIzXB705pleXsGKAT2A==
X-Proofpoint-GUID: lGBq8SF1R4o-KvodqlnlBAI3eAFciqKb
X-Proofpoint-ORIG-GUID: lGBq8SF1R4o-KvodqlnlBAI3eAFciqKb
X-Authority-Analysis: v=2.4 cv=dbgVTnXe c=1 sm=1 tr=0 ts=6afe5172 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=U_y8lYiYyhHBU5rMqhb2:22 a=VabnemYjAAAA:8 a=wi2aMdR35XiSOEFO71MA:9
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE5MDAwNSBTYWx0ZWRfXycWIlm2hv8LQ
 /ujIcDyQ/aYAgdn8CspE3hnJQarwoRqC32uVQ49DqI91Lj4zH+nbS+tsmJOIREyfbw8r6vJjIfP
 roZ1g5slKbLMZWaoixJVQnBE6ZvYKBI=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-19_01,2026-11-16_01,2025-10-01_01

Describe PSP associations, and how they differ for the socket and tc use
cases.

Document the new netlink commands for socket-less PSP, and what
userspace must do on key rotation, since the kernel keeps no state for
socket-less Rx SPIs.

Document the psp tc action, and the flower psp_spi, psp_ver, and psp_dev
matches.

Add a new section to describe pre-existing PSP device stats.

Signed-off-by: Todd Freed <toddfreed@meta.com>
---
 Documentation/networking/psp.rst | 169 ++++++++++++++++++++++++++++---
 1 file changed, 153 insertions(+), 16 deletions(-)

diff --git a/Documentation/networking/psp.rst b/Documentation/networking/psp.rst
index 0f9b6b73f244..32d53f6050b7 100644
--- a/Documentation/networking/psp.rst
+++ b/Documentation/networking/psp.rst
@@ -69,20 +69,43 @@ The PSP netlink family defines operations to retrieve information
 about the PSP devices available on the system, configure them and
 access PSP related statistics.
 
-Securing a connection
----------------------
-
-PSP encryption is currently only supported for TCP connections.
-Rx and Tx keys are allocated separately. First the ``rx-assoc``
-Netlink command needs to be issued, specifying a target TCP socket.
-Kernel will allocate a new PSP Rx key from the NIC and associate it
-with given socket. At this stage socket will accept both PSP-secured
-and plain text TCP packets.
+PSP Associations
+----------------
 
-Tx keys are installed using the ``tx-assoc`` Netlink command.
-Once the Tx keys are installed, all data read from the socket will
-be PSP-secured. In other words act of installing Tx keys has a secondary
-effect on the Rx direction.
+PSP encryption and decryption happen in the context of an association.
+An association holds the PSP device, PSP version, and either Rx state
+for decrypting and authenticating packets (the SPI and Rx key), a Tx key
+for encrypting packets, or both.
+
+Associations are used in two ways. First, a TCP socket can be bound to
+an association, and all packets flowing over that socket inherit its
+association. Second, socket-less Tx associations are used with tc,
+together with Rx SPIs allocated without a socket. This allows PSP for
+forwarded traffic, or for non-TCP traffic. A tc action attaches a Tx
+association to packets. On Rx, the device decrypts packets sent to an
+SPI it allocated, and a tc filter matches the SPI, version and PSP
+device a packet was decrypted with. The kernel keeps no state for
+socket-less Rx.
+
+An association is of one type or the other; that is, sockets may not
+use socket-less associations, and tc actions do not address associations
+which are attached to a socket. Device statistics count both.
+
+Securing a socket connection
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+PSP encryption can be enabled for TCP sockets. Other kinds of sockets
+are not supported. For a TCP socket, Rx and Tx keys are allocated
+separately. First the ``rx-assoc`` Netlink command needs to be issued,
+specifying a target TCP socket. Kernel will allocate a new PSP Rx key
+from the NIC, create an association with it, and bind it to the given
+socket. At this stage socket will accept both PSP-secured and plain text
+TCP packets.
+
+The Tx key is installed into the socket's association with the
+``tx-assoc`` Netlink command. Once it is installed, all data read from
+the socket will be PSP-secured. In other words act of installing Tx keys
+has a secondary effect on the Rx direction.
 
 There is an intermediate period after ``tx-assoc`` successfully
 returns and before the TCP socket encounters it's first PSP
@@ -140,6 +163,83 @@ The PSP assoc state of a socket is not reset when the connection is
 torn down. ``connect()`` on a socket that has PSP assoc state will
 return ``-EINVAL``.
 
+Socket-less associations
+~~~~~~~~~~~~~~~~~~~~~~~~
+
+Socket-less PSP is managed with these netlink commands:
+
+- ``rx-spi-alloc`` allocates an Rx SPI and key, like ``rx-assoc`` but
+  without a socket, and creates no association. It also returns
+  ``key-rotations``, the number of key rotations of the PSP device so
+  far. The key should be passed to the peer out of band, and installed
+  with ``assoc-add``.
+- ``assoc-add`` adds a Tx association with the peer's SPI and key, and
+  returns its ID.
+- ``assoc-del`` deletes a Tx association. tc actions and packets which
+  still reference it keep it alive.
+- ``assoc-get`` reports Tx associations, never their keys.
+
+Tx associations are removed when their PSP device is unregistered.
+
+The ``psp`` tc action attaches these associations to packets:
+
+- ``psp encap assoc ID`` attaches a Tx association. The packet must then
+  be transmitted on the main netdev of the association's PSP device, which
+  encrypts it (``mirred egress redirect``). If the packet loses the
+  association on the way (e.g. its dst is replaced), is transmitted on any
+  other device, or the PSP device is unregistered before transmit, it will
+  be dropped, rather than sent in the clear. Encap on ingress isn't
+  supported: the action drops the packet.
+
+- ``psp decap`` removes the PSP Rx state (the ``SKB_EXT_PSP`` extension and
+  ``skb->decrypted``) of a decrypted packet, so that it can be forwarded. It
+  takes no association. Its filter should match ``psp_spi``, ``psp_ver``
+  and ``psp_dev``.
+
+The flower classifier matches what a packet was decrypted with:
+``psp_spi SPI[/MASK]``, ``psp_ver VERSION`` and ``psp_dev DEV_ID``, the
+ID of the PSP device which decrypted it. These never match a clear text
+packet, so ``psp_spi 0/0`` matches any packet decrypted with PSP.
+Together they tie a decap rule to one Rx SPI.
+
+The top bit of an SPI, the key phase, selects which of the two device
+keys its Rx key is derived from. A key rotation replaces the device key
+of the other phase than the SPIs allocated since the previous rotation,
+and the SPIs allocated after it have that phase. An SPI keeps decrypting
+through one rotation, which leaves time to move peers to new SPIs. After
+the second rotation its device key is gone, and the device may allocate
+the same SPI again, with a new key.
+
+Unlike for sockets, the kernel does not enforce key rotation for
+socket-less Rx: a decap rule for an SPI also takes the packets of a later
+allocation of the same SPI. Userspace which installs decap rules is
+responsible for removing them in time:
+
+- Any process with ``CAP_NET_ADMIN`` over the PSP device can rotate its
+  key, or allocate SPIs. Once the device has rotated twice,
+  ``rx-spi-alloc`` can return an SPI which a stale decap rule still
+  matches. Remove the decap rules of the SPIs allocated before the
+  previous rotation, which have the phase of the SPIs allocated from
+  now on, on a rotation notification (``key-rotate-ntf``), and in any
+  case before an SPI allocated after the rotation is given to a peer.
+  This is simplest when one process allocates the SPIs and owns the
+  decap rules. Then move peers to new SPIs before the next rotation.
+- An SPI allocated when ``key-rotations`` was N stops decrypting with
+  rotation N + 2. Comparing it with the ``key-rotations`` of a later
+  ``rx-spi-alloc``, or of ``get-stats``, detects missed notifications.
+
+tc can help with this bookkeeping. A tc action cookie (``cookie``, up to
+16 bytes) is opaque to the kernel and dumped with the action, so it can
+record the owner of a decap rule, its SPI and its ``key-rotations``.
+Filters added with a known priority and handle can be deleted without a
+dump. Putting the decap rules of each key phase in their own chain lets
+one command remove all of them on rotation.
+
+The device adds 40 bytes to each packet on transmit: the UDP and PSP
+headers, and the ICV. The operator must size the MTU of the traffic
+source for this. A packet which would not fit the PSP device's MTU once
+encapsulated is dropped on transmit.
+
 Rotation notifications
 ----------------------
 
@@ -149,6 +249,39 @@ The PSP netlink family will generate a notification whenever keys
 are rotated. The applications are expected to re-establish connections
 before keys are rotated again.
 
+Fragments
+---------
+
+PSP transport mode does not support IP fragments, either for sockets or
+socket-less associations.
+
+Statistics
+----------
+
+The ``get-stats`` netlink command reports the PSP device statistics:
+kernel statistics (key rotations, stale events), and the device statistics
+defined by the PSP specification. The device statistics count what the
+device decrypts and encrypts.
+
+The tc action counts the packets it processes and the ones it drops
+(``tc -s``). Encapsulated packets dropped on transmit count in the
+device's ``tx_dropped``. Drops are reported with these drop reasons:
+
+- ``SKB_DROP_REASON_PSP_OUTPUT``: encap ran on ingress in software, or
+  failed to parse the packet, or it is an IPv4 fragment or has IPv6
+  extension headers, which transport mode doesn't support, or it is
+  already encapsulated for a tunnel, already marked decrypted, or of a
+  socket with its own encryption offload; or an encapsulated packet
+  reached a device which isn't its PSP device's netdev, or its PSP
+  device was unregistered while it was queued.
+- ``SKB_DROP_REASON_PKT_TOO_BIG``: an encapsulated packet would not fit
+  the device's MTU once the device adds the PSP encapsulation.
+
+A packet encapsulated on egress which lost its association on the way is
+dropped on transmit by ``sk_validate_xmit_skb()``, without a specific drop
+reason, unless its socket has an encryption offload of its own: then the
+socket's validator handles it.
+
 Kernel implementation
 =====================
 
@@ -177,14 +310,18 @@ device key twice), to avoid potentially using a SPI+key which previous
 OS instance already had access to.
 
 Drivers must use ``psp_skb_get_assoc_rcu()`` to check if PSP Tx offload
-was requested for given skb. On Rx drivers should allocate and populate
-the ``SKB_EXT_PSP`` skb extension, and set the skb->decrypted bit to 1.
+was requested for given skb. The association comes from the skb's socket
+or, for socket-less associations, from a ``METADATA_PSP`` dst which the
+core keeps on the skb for the driver to use. On Rx drivers should
+allocate and populate the ``SKB_EXT_PSP`` skb extension, and set the
+``skb->decrypted`` bit to 1.
 
 Kernel implementation notes
 ---------------------------
 
 PSP implementation follows the TLS offload more closely than the IPsec
-offload, with per-socket state, and the use of skb->decrypted to prevent
+offload, with per-socket state (or per-association state, for
+socket-less associations), and the use of ``skb->decrypted`` to prevent
 clear text leaks.
 
 PSP device is separate from netdev, to make it possible to "delegate"
-- 
2.53.1-Meta

