Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.153.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794358609;
	b=dStFt2mGIfVUfE4sSgtFz7mtDJNcDTrp2yGCmdD9n5bHHYpgUof0tyfKJyuUbqEqTXNB
	 zypMC5tsVGs1robqYizxMxTvJ27kDn0IUxJ03jdIzVUmNjwZGk8V819NQt7D44VSRss9q
	 iJ2S4688zCZoCr55UDX2mMmeVrZzRWYkYOsdVXUkN5UNomIaLbTcPhmJhdJeotPTH5IVV
	 wjE6yRrbhu8deChtjrDnfBUxRyoMzlywpdI9lvRIBtI00antnKoJTCi8v0/2SV2Yxs143
	 Rk+O4e07pwdZrdXZEfx2UACs9Mko5wvNBuKS5Wwgpak/Z/LJ3iSBVQmSz3tR3gmp33Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794358609;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version;
	bh=LqVPVdCzfC2WPwWfdW1cmpz+KPpdVOQICQz+gXtN8Bc=;
	b=SxqGvYMv45QyrPEJ6adB130IoVyf+LOjw5nhIrdN2gIolfCneLcQihGi5+O+s9a2MFx0
	 frB9Ay0fhyoUA0UD5WXH9LrYuwsbYFrDX1iHse8fp/LC4wPnyFdr5aL5xshGnOt11CZ+o
	 S6cr+fqsbWlDutJEC0/DWsugzUjHfKyJUraqHQSER5UkZ3+XYK/QhMrqHkdvcXgepqxrT
	 uB7AVkaW34RZ8+MX/WPnYDGotSkPwHEXy3lQglKa/jWQbeU1pIUsCglHV6ptsEmdRjS30
	 MRfGApnYf2b++8dTEavKAoKczyBXej8P00VSnWUxnfA544ydSkmSeXX56nshW9ga/ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=Fo3pi1jh;
	arc=none smtp.remote-ip=67.231.153.30
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F28B606BA3D;
	Wed, 11 Nov 2026 00:56:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7F28B606BA3D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=Fo3pi1jh
Received: from pps.filterd (m0528004.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AB0WXqP2947202;
	Tue, 10 Nov 2026 16:56:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=LqVPVdCzfC2WPwWfdW1cmpz+KPpdVOQICQz+g
	XtN8Bc=; b=Fo3pi1jhCwawDvv78dkxv19DhHBKzD5NSgrSv4jDsKwCu3EOfBnt4
	EsyBDZOAUjEiT11bPx3O2BqaDRdWzUFk12zrUaIRGJ5Fo3b83qwrcnAC2cOwjJyx
	gn0KQl8xh6Ui4T4wxjEdCD3qAB7QDuiyZeljvab5G82O2C0f0ky9jPpaM5WkTbzf
	SIQgux3y4NXtOWnKv0v2Fg7g1ZfAplzBJt7V9GZmVAz6lGT2uOSWFyZicqJTMpHc
	/jLxUZLjhw3KO49yvl4wnDxGP5puf3Vn9rQJy/bIn94l+nGLD1McIvZ+eZ6ww3bs
	+XkhejNz144aTUwnllj7pD5HA9BsxPJnQ==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4hvaej9r92-9
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 10 Nov 2026 16:56:20 -0800 (PST)
Received: from localhost (2620:10d:c085:208::f) by mail.thefacebook.com
 (2620:10d:c08b:78::c78f) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Wed, 11 Nov
 2026 00:56:14 +0000
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
Subject: [PATCH net-next v1 15/15] Documentation: networking: psp: document socket-less associations
Date: Tue, 10 Nov 2026 16:55:33 -0800
Message-ID: <20261111005533.6436-16-toddfreed@meta.com>
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
X-Authority-Analysis: v=2.4 cv=LZipeTfi c=1 sm=1 tr=0 ts=6af3bd34 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=GbPsI2Ihf5RTnMjR_gZv:22 a=VabnemYjAAAA:8 a=62nvE6wq0VXvjrA3_yIA:9
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-GUID: OV9Y23HlDi3aDO2NYGyvN0LxWqYiOxld
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDAwMyBTYWx0ZWRfX/Sq6K47SpuDQ
 wapY7uPLACArw7QskvdyUaun0Y4MuCm7AS4HDJe8uUIxVj5mx1QmxOKVVoJEI1jpboSBX6CZZUs
 k3ZDS6pGyEc8vkmEw3XEIGnu/3CRi/zZByZsIHBmdnF/VVlaof3Euj+/d7gWlW+DQFIjQ5z2Agy
 Zlv9hpXE7S1ejIhMXvYqHtevPB7ws7muGpUJstuh2lAT1jkMjglb5ZlH9MBc7y3AwP2xS41H1Ea
 HrycR9DtX+qzkKlby0hMhRa/6sODHQBm076brdUhuY15+V9tqBhuD2G6cytX9Q7eSRoTG8EJM9j
 /Gj4qw4LjIrwYha4kNnnu3DhT4LnlHcq0/jzPJCyLgNT5MWyByFG/6QN9450At7gF/lTetxwxd3
 U+UpP4dl6Bi65VYmJy/PdWT1M6c7j6uHXCxJ9Sb44EOyQJ7r18ErDVdQfyEd1SDOoXukDidjfBC
 IFE5Ptszpp86CsgA4Kg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDAwMyBTYWx0ZWRfX/JHjVPX1/DBj
 lKLQWIsQhzZRnZ/ZAmS5FP0DQK4qWgUoOW1Ucfdx/pt3K0AETekPY82zaPCugiPWAORIizXdj6+
 YG4sPG16Am47InZ446PKSzCyQlBelzk=
X-Proofpoint-ORIG-GUID: OV9Y23HlDi3aDO2NYGyvN0LxWqYiOxld
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-10_07,2026-11-06_01,2025-10-01_01

Describe PSP associations, and how they differ for the socket and tc use
cases.

Document the new netlink commands for manging socket-less associations.

Document the psp tc action, and flower psp_spi, psp_ver, and psp_dev
matches.

Add a new section to describe pre-existing PSP device stats.

Signed-off-by: Todd Freed <toddfreed@meta.com>
---
 Documentation/networking/psp.rst | 139 +++++++++++++++++++++++++++----
 1 file changed, 123 insertions(+), 16 deletions(-)

diff --git a/Documentation/networking/psp.rst b/Documentation/networking/psp.rst
index 0f9b6b73f244..79b101db5dfc 100644
--- a/Documentation/networking/psp.rst
+++ b/Documentation/networking/psp.rst
@@ -69,20 +69,42 @@ The PSP netlink family defines operations to retrieve information
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
+for decrypting and authenticating packets (the SPI, and for sockets the
+Rx key), a Tx key for encrypting packets, or both.
+
+Associations are used in two ways. First, a TCP socket can be bound to
+an association, and all packets flowing over that socket inherit its
+association. Second, socket-less associations, either Rx or Tx, are
+used with tc. This allows PSP for forwarded traffic, or for non-TCP
+traffic. A tc action attaches a Tx association to packets. An Rx
+association reserves an SPI: the device decrypts packets sent to it,
+and a tc filter matches the SPI, version and PSP device a packet was
+decrypted with.
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
@@ -140,6 +162,55 @@ The PSP assoc state of a socket is not reset when the connection is
 torn down. ``connect()`` on a socket that has PSP assoc state will
 return ``-EINVAL``.
 
+Socket-less associations
+~~~~~~~~~~~~~~~~~~~~~~~~
+
+Associations which are not bound to a socket are managed with these
+netlink commands:
+
+- ``rx-spi-alloc`` allocates an Rx SPI and key, like ``rx-assoc`` but
+  without a socket. It also creates an Rx association, which records the
+  SPI, the version and the device key generation, and returns its ID.
+  The key should be passed to the peer out of band, and installed with
+  ``assoc-add``.
+- ``assoc-add`` adds a Tx association with the peer's SPI and key, and
+  returns its ID.
+- ``assoc-del`` deletes an association. tc actions and packets which still
+  reference it keep it alive. The device keeps decrypting the SPI of a
+  deleted Rx association until its device key is rotated out: remove the
+  decap rule to stop taking its packets.
+- ``assoc-get`` reports associations, never their keys, and for Rx
+  associations whether key rotation has made them stale.
+
+The ``psp`` tc action attaches these associations to packets:
+
+- ``psp encap assoc ID`` attaches a Tx association. The packet must then
+  be transmitted on the main netdev of the association's PSP device, which
+  encrypts it (``mirred egress redirect``). If the association is removed
+  before transmit, or if the packet is transmitted on any other device,
+  it will be dropped, rather than sent in the clear. Encap on ingress is
+  hardware offload only.
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
+Together they tie a decap rule to one Rx association.
+
+Once the device key an SPI was created from has been rotated twice, that
+association is considered stale. Unlike sockets, tc does not handle key
+rotation. userspace should replace such rules before two rotations.
+
+The device adds 40 bytes to each packet on transmit: the UDP and PSP
+headers, and the ICV. The operator must size the MTU of the traffic
+source for this. A packet which would not fit the PSP device's MTU once
+encapsulated is dropped on transmit.
+
 Rotation notifications
 ----------------------
 
@@ -149,6 +220,38 @@ The PSP netlink family will generate a notification whenever keys
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
+reason.
+
 Kernel implementation
 =====================
 
@@ -177,14 +280,18 @@ device key twice), to avoid potentially using a SPI+key which previous
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
2.53.0-Meta

