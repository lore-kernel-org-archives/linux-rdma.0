Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.153.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795558758;
	b=iddDxLhxR26xZzGAgoctTkrR3E8Iprmwkg47RfhpcvIXsJ2npkkG5zXNHPplDgT7CDyn
	 BIbPXSRKtHneubfHmMaa8G0XgXuAE1LqDiUTvQXhpfr77+m+cGA++fcRkAQ62aKFRkswV
	 Hf/z0u513LDCD7OeqJBxrtjSCd0xGCsWqobOqi0Cs3685RJyEr+n1uqNoV+Isayjj9/yS
	 0oRAT8K/+9zqxZh79K2FfqateD+vcDoGyPxrgtbI0bvQbNAjZF/OQTYF1akPrKPUid+07
	 AlmHohL8hz5tViq4eWcwTbfd3lfJOpSaIS3Lt+6cGOjusCYFZHfw1Y56de5phq/GcpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795558758;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version;
	bh=mRedT/j4+cuScJYJwjQpt3nNWEpFEbobMouk0r06yoQ=;
	b=vW618XN5xCzEZ4Ma8ZTR/GpWpnfk3cjbub+UUSkC91nt9IW/ShGU5CrrYAmKzvIpar7i
	 WQLirlMwoVQvrgBCMUdLREaCLVeF32HUyFKeMZ2TpcU3gW3rRY2G3udBjA0gLLEv+/QxW
	 qHCD2drTYSzjeC7F/6R14adOR1uVz1vxqacupl+IXqk1x3DGrLGcVbMl3JoBLpoxEbpIP
	 YtsMUdukP0o5fjib9QvU2bGM0It42qbEJwTY0H0ELpq1QTRy7YcvKbpOalKnBWFFYZ3KZ
	 248Fe5ZzgUnl28MJJ1BQMso4WqE0og/8TNTLHp45M9oxGK7J6Q6QoiwvYrBnAar75Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=DluFXjyH;
	arc=none smtp.remote-ip=67.231.153.30
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2960F60A383C;
	Tue, 24 Nov 2026 22:19:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2960F60A383C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=DluFXjyH
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AOMBC601293122;
	Tue, 24 Nov 2026 14:18:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=mRedT/j4+cuScJYJwjQpt3nNWEpFEbobMouk0
	r06yoQ=; b=DluFXjyH3oK8iGe2IxAjRe+q/UZ2swGsZ0c0oNXHx226D8XpnAsOU
	XbzGafaIPjafIDD0b50B6SU9dT0Kr392PoSqJAL2F7Nz8QKWH5xPDVaaJbogNNlQ
	V5wnyQ8tonpDOkgoLAKGkJ4MRN5PZIQTc0xK6+l9GmCayjzNJKRFAlFBAMcXTXPr
	mN0s5LDxiZy9ayZh4lAiG5Jm+7BUsnw9+WOK5ic9PF5LAEMnImBjljagpVnmW4pL
	Dq90bX8IsX8/VMHaU0UIbSfUkq3CK9X2XlRru8t4o+vJJgBcMsGM9xOTmpo2LR2J
	YgYdrt3mnFt8sDkdVXtrOcuQkW5J/D+ew==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j5gqwh6mp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 24 Nov 2026 14:18:30 -0800 (PST)
Received: from localhost (2620:10d:c085:208::7cb7) by mail.thefacebook.com
 (2620:10d:c08b:78::c78f) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Tue, 24 Nov
 2026 22:18:29 +0000
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
Subject: [PATCH net-next v3 12/12] Documentation: networking: psp: document socket-less associations
Date: Tue, 24 Nov 2026 14:17:58 -0800
Message-ID: <20261124221758.3230929-13-toddfreed@meta.com>
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
X-Proofpoint-ORIG-GUID: gw5CN7Vw2BBjBiZF2-ExA4CxhLhPYT6D
X-Proofpoint-GUID: gw5CN7Vw2BBjBiZF2-ExA4CxhLhPYT6D
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI0MDA4NyBTYWx0ZWRfX+6ytWESvQT6Y
 Q20Nm3lxTeSSqw3Lem23H2nFHTaAB8RvK6MTzFl44gYnTHqS1GUrIioE/ldS5CznYXXbF1NvdRm
 2H/xjy4Rb0SwksL04sDVHPKkPaf019w=
X-Authority-Analysis: v=2.4 cv=eJyGH3p1 c=1 sm=1 tr=0 ts=6b060d36 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=JnKecZnUtZousrUlYMGU:22 a=VabnemYjAAAA:8 a=KB2Q9FeQTp6ne65zgDMA:9
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI0MDA4NyBTYWx0ZWRfX7ftuBKeQha0M
 KyjIK7RXVp2BWnO4KcMm8L4P19aLO9URUGGzK4g4GWPrJH4wdBRiTsAJ/yiU6JrmMFd1K+mE/oO
 6Q038Jqa4ZcJfvWUv4Q8zhH+s7uPSeWNVLBexyet/Qokx/QLNceEbGvwlPqVVf7GXMtVodf3+n9
 SdxkwuAbXZoexXcpENF7oBUhN4QLZ/BxJD59uuUiAE8+HqWuS3wT1ZEWdbR7SXBmc5vhRkrBaNq
 BSC6+Ozmmon1dVDp7zPKOZf+uNROoJ5SXVZ4EB+E/wiELm2/yQJQNj/4DiEkZB5W1j6RlVh6lHK
 aXWwMAL6hMyHtY0It3w3v0aV++PMz2nA+hW2S1akbbAspRIcHz1fgKt/OZgaE2uB85pMU38mT+/
 51cPuedBYIEvFYnutObkihMFjQdmvwzMZsUKi0jfw/JZy0zWLCQ7G7c+LVeL6xxeh7B+VCOg5bt
 te19rmUSXtoolZMjCpw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-24_06,2026-11-23_01,2025-10-01_01

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
 Documentation/networking/psp.rst | 182 ++++++++++++++++++++++++++++---
 1 file changed, 165 insertions(+), 17 deletions(-)

diff --git a/Documentation/networking/psp.rst b/Documentation/networking/psp.rst
index ceb1e232317f..fc565d48c694 100644
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
@@ -141,7 +164,7 @@ torn down. ``connect()`` on a socket that has PSP assoc state will
 return ``-EINVAL``.
 
 Rekeying
---------
+~~~~~~~~
 
 A connection which has completed the exchange described above and is
 in the "PSP Full" state can be rekeyed in place without being torn
@@ -162,6 +185,92 @@ or the PSP version of the association. It is rejected with ``-EBUSY``
 if the socket has not completed its initial exchange in both
 directions.
 
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
+  encrypts it (``mirred egress redirect``). If it is transmitted on any
+  other device, or the PSP device is unregistered before transmit, it is
+  dropped, rather than sent in the clear. So is a packet which loses the
+  association on the way (e.g. its dst is replaced), unless its socket
+  gained an encryption offload of its own (see Statistics). Encap on
+  ingress, and redirect to ingress after encap, are not supported. Encap
+  on ingress drops the packet. A packet redirected to ingress after encap
+  loses its association: it is dropped if it is forwarded, but delivered
+  locally with ``skb->decrypted`` still set.
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
+  key, or allocate SPIs with ``rx-spi-alloc``. Any process with a TCP
+  socket in a network namespace where the device is visible can allocate
+  SPIs from the same space with ``rx-assoc``. Once the device has rotated
+  twice, either can return an SPI which a stale decap rule still
+  matches, and the rule would strip the PSP state of its new owner's
+  packets. Remove the decap rules of the SPIs allocated before the
+  previous rotation before rotating the key again: right after that
+  rotation, the device may allocate their SPIs again. When another
+  process rotates the key, remove them as soon as the rotation happens
+  (``key-rotate-ntf``); until then, an SPI allocated again can be matched
+  by a stale rule. This is simplest when one process allocates the
+  socket-less SPIs, owns the decap rules and rotates the key. Move peers
+  to new SPIs before the next rotation.
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
 
@@ -171,6 +280,41 @@ The PSP netlink family will generate a notification whenever keys
 are rotated. Applications are expected to rekey their connections,
 as described above, before device keys are rotated again.
 
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
+``tx_dropped`` of the netdev they were transmitted on. Drops are reported
+with these drop reasons:
+
+- ``SKB_DROP_REASON_PSP_OUTPUT``: encap ran on ingress, or failed to
+  parse the packet, or it is an IPv4 fragment or has IPv6
+  extension headers, which transport mode doesn't support, or it is
+  already encapsulated for a tunnel, already marked decrypted, or of a
+  socket with its own encryption offload; or an encapsulated packet
+  reached a device which isn't its PSP device's netdev, or its PSP
+  device was unregistered while it was queued, or its socket gained an
+  encryption offload of its own while it was queued.
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
 
@@ -199,8 +343,11 @@ device key twice), to avoid potentially using a SPI+key which previous
 OS instance already had access to.
 
 Drivers must use ``psp_skb_get_assoc_rcu()`` to check if PSP Tx offload
-was requested for given skb. On Rx drivers should allocate and populate
-the ``SKB_EXT_PSP`` skb extension, and set the skb->decrypted bit to 1.
+was requested for given skb. The association comes from the skb's socket
+or, for socket-less associations, from a ``METADATA_PSP`` dst which the
+core keeps on the skb for the driver to use. On Rx drivers should
+allocate and populate the ``SKB_EXT_PSP`` skb extension, and set the
+``skb->decrypted`` bit to 1.
 
 Deferred Tx key deletion
 ~~~~~~~~~~~~~~~~~~~~~~~~
@@ -248,7 +395,8 @@ Kernel implementation notes
 ---------------------------
 
 PSP implementation follows the TLS offload more closely than the IPsec
-offload, with per-socket state, and the use of skb->decrypted to prevent
+offload, with per-socket state (or per-association state, for
+socket-less associations), and the use of ``skb->decrypted`` to prevent
 clear text leaks.
 
 PSP device is separate from netdev, to make it possible to "delegate"
-- 
2.53.1-Meta

