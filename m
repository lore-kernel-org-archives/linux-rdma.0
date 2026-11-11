Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.145.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794356353;
	b=wRDoN3oSGUTD6OvjNeBboAOTU6BFN/ltawPMN714KLcd03QwJxF61HXzhHMPbHq2lday
	 cAyCkwov48EkRGLHTud5S7oaz8Mxv2hAxEsH6S7KQh7z+bpI28712G/KMXhznKuEFGMwP
	 0gHgbIZCguIaM26RNT440mbO4Q4ssH+iAww/7G9ecTa8J7UNcVGM6uJmpevyvrnck8n4a
	 DZbAg2Ussl6yqmKzdOV9OYW4xwbgTGrjduNLs41UuyPiVxiVkELnACkj4ZP6CUo7t7ati
	 FDoh9SsUQ/US0MORwLRVfsX0hK+4oyojGgVt8gdWT3xPTlFSop0jJk9h8fh3qNDwoAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794356353;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Originating-IP:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version;
	bh=oDaS55FMQOUi1HEa3hfIfCn7XSPjWzo8fpu/fPFXpmk=;
	b=s49PiGHdCWiS/lLSfk/plq4y50H8Gz6gV1pMdzqmPjPF7/LnJHdvnOeHPwqjCs7960b1
	 5Ye+H8Hn6/QpF7tJLGiaoY2BjgfJ7j64uehj2X6xlzApZyyLw6CyHaa+zgkHZ71LnRZxW
	 0MzxKqYqOdJyOBE9UyEz9RWwiCLOp3m1r7+DBBY102x9JeBrHemoH+/ITXPvs+5W9q9o/
	 Q8OCwP0Fr3jdVKJ27kBW73Dk79dyJXjaCItBjq860uCu/xMFg7acA8ORw7GdzUeYOWKOC
	 QAliMVxyhAiQMNLU8NtMZM/zfCjdI84krhkfBeWlCYfpbBYcTrS7oxbppbNDm2IcAUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=VaQSQIqW;
	arc=none smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F11606A32A;
	Wed, 11 Nov 2026 00:19:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C2F11606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=VaQSQIqW
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AAMK1C12810117;
	Tue, 10 Nov 2026 16:18:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps82601-s2048-2026-q3; bh=oDaS55FMQ
	OUi1HEa3hfIfCn7XSPjWzo8fpu/fPFXpmk=; b=VaQSQIqWxk9tZN4Bc71uZEKjq
	dTPfDtGnf7lpKEJ6Ziscm39AeHqswvXpHzD2+vRRyk76B0DDSgvlwdvdNpzpj2Xh
	J4vIP0V0o8SkksvqjaIfwEiVJZlTz8bKyXuQlmu0X9wGVy3s8Y4Xi21Q3bJ/7lv/
	I3YrZ4fl9F4VHxwvZvCplyypw2Z+yg5K94OF7ksJIcIYqTzCu86ZleB3udjxG9BA
	FTkQETx6aBMR6L5zr5wJrp3C0ZiYk9zU9XehfMWD034l2UHm0sfgKiTTs2Qp8htL
	BNbb/sVn+Fq1PtW3tSTcjuM1H7qLAODlDA8vo+Cr1EpeIbJHZOC1eMSvSwRHw==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4hv7vgk6bj-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 10 Nov 2026 16:18:58 -0800 (PST)
Received: from localhost (2620:10d:c0a8:1c::1b) by mail.thefacebook.com
 (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Wed, 11 Nov
 2026 00:18:44 +0000
From: Todd Freed <toddfreed@meta.com>
To: <netdev@vger.kernel.org>, <toddfreed@meta.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn
	<andrew+netdev@lunn.ch>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?=
	<bjorn@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>, Cosmin Ratiu
	<cratiu@nvidia.com>,
        Daniel Zahka <daniel.zahka@gmail.com>,
        David Ahern
	<dsahern@kernel.org>,
        Dragos Tatulea <dtatulea@nvidia.com>,
        Eric Dumazet
	<edumazet@kernel.org>, Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski
	<kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Leon Romanovsky
	<leon@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        Mark Bloch
	<mbloch@nvidia.com>, Paolo Abeni <pabeni@redhat.com>,
        Raed Salem
	<raeds@nvidia.com>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        "Sabrina
 Dubroca" <sd@queasysnail.net>,
        Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan
	<shuah@kernel.org>,
        Simon Horman <horms@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>,
        Wei Wang <weiwan@google.com>,
        Willem de Bruijn
	<willemdebruijn.kernel@gmail.com>
Subject: [PATCH net v5 0/8] psp, tls: don't send offloaded contents in cleartext
Date: Tue, 10 Nov 2026 16:18:23 -0800
Message-ID: <20261111001831.3710881-1-toddfreed@meta.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: yj3GVfEwpZAiFSBI5nyxWeBPEstnNGNe
X-Proofpoint-ORIG-GUID: yj3GVfEwpZAiFSBI5nyxWeBPEstnNGNe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDAwMCBTYWx0ZWRfX52XD6ziY3er0
 nHS+7Zdp+k9AVFHBhtMhlJOXK1l2PDTVHamXXarhrh14rkiQ6EECJ4NmM62HzT4WR5+pCQiDqkF
 FeJVA8C3OGnpjQyORSUWLccuyx0XBEECW0WBVC5dVV3G/Dbo5lVqVFl0DKeTvb0GrcKb8j3OZZF
 RcwwsoPDmwEwaBKUO//NsFrACsqmd5VVGtlXnCqVA5a302EcCOisKJ3oRhCoXkx8+bG/+garA/K
 mlP71Ec5mVWr/lfZ7ZLPVfR5XXLbAr4w980C4y4F7LvMjcVIeeaiwWrkXelvJP3LZuIEbySsWeg
 NzBS67HyMupriYr2zxPJILsZJIak8WbM+D7DkzP8rguDlncj8hasUlwkalKF+fW3EnYa0U0S3Ka
 DUj/GrJk6QIzVW72LQ+CDvyEwzoGrL1jt/3PROk3J4CjHZT3mi/kLoGuWW0/a56aoWyTfwlZ9p3
 ehNU1Yf3Wmftc6uf3DA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDAwMCBTYWx0ZWRfX7JEjGzHVf7wh
 OXn+jYGCFOSWw2J86meFEclFbgKmg4wTtmp66f+58RJOkHqZDhDJcLQyeL/qH9mRECFH1W2Uma8
 44X2ETDVJyFbr8sBSPcZvLbcQOIF5IY=
X-Authority-Analysis: v=2.4 cv=feA4WEQF c=1 sm=1 tr=0 ts=6af3b472 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=7x6HtfJdh03M6CCDgxCd:22 a=03ozwUkBphtHgyqjj1sw:22 a=VwQbUJbxAAAA:8
 a=VabnemYjAAAA:8 a=lOhMexRp6y124jtleHoA:9 a=QEXdDO2ut3YA:10
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-10_07,2026-11-06_01,2025-10-01_01

While working on adding support for socket-less psp associations, I
noticed the case of ipv6 extension headers was not being handled
properly for psp packets. It will be relevant with that series, because
it adds udp support, for which the psp nexthdr needs to look at the
inner packet.

That led me to various other ways where packets on the crypto offload
path could be transmitted unencrypted.

Since the psp/tls association encodes intent to send encrypted packets,
but these various cases circumvent that, sending these as fixes.

The cases are,

 1/ ipv6 extension headers (patch 2; patch 1 makes mlx5e flush its tx
    queue when the resulting drop happens),
 2/ fragments (patch 3),
 3/ icmp errors (patch 4),
 4/ icmpv6 errors (patch 5),

Cases 2, 3 and 4 are relevant for ktls as well as psp.

patch 8 fixes an mlx5e bug in tso checksum calculation for psp packets
when the l3 dest is an intermediate hop (ipv4 source routing). It's not
about preventing unencrypted tx, so could be considered separate.

netfilter refragments bridged packets and builds reject replies itself,
outside these paths. A separate series to nf-next, which follows this
one, applies the same rules there.

Testing:

all hardware testing was done on connectx-7 (fw 28.48), between two x86
hosts, plus netdevsim.

 - drivers/net psp.py: on netdevsim, all 36 tests pass. on mlx5, 30
   pass, 4 skip (gmac versions the device doesn't support), and 2 xfail
   (netdevsim only).

 - tso checksum seed: a psp tcp socket with an ipv4 loose source route,
   the peer checking tcp checksums in software. hundreds of checksum
   errors before the fix, none after.

 - fragments, with tls offload and psp:
   - ipv4 (route mtu above the device mtu, IP_PMTUDISC_OMIT): without
     the fix, some fragments after the first go out in cleartext. with
     it they're dropped.
   - ipv6, through an ipvs dr service with a local client: without the
     fix, fragments after the first go out in cleartext, and the peer
     reassembles them. with it they're dropped.

 - icmp and icmpv6 errors, on netdevsim psp, with an nft reject rule
   (icmpx port-unreachable):
   - in an input chain, of received decrypted packets: without the fix,
     the errors go out on the wire, quoting the decrypted packets. with
     it, no error reaches the wire.
   - in an output chain, of a psp socket's packets: the error is
     delivered to the local socket, with and without the fix.
   - a PKT_TOOBIG from ip6_fragment() about a psp socket's packets is
     delivered to the socket, with and without the fix.

v5:
 - new patch 1: mlx5e rings the tx doorbell when an accel offload drops
   a packet, and checks the stop room after the nop it posts (Sashiko)
 - ipv6 extension headers: drop them in psp_dev_encapsulate() again,
   instead of in mlx5e. it's the helper which can't encapsulate them,
   for every driver (netdevsim sent them malformed). unlike the routing
   header rejection in v2, this isn't a device limitation
 - don't fragment decrypted skbs in ip6_fragment() either
 - icmp and icmpv6: send no error at all about a received decrypted skb,
   instead of quoting up to the tcp header for tls offload.
 - icmpv6: decide whether an error about a locally originated skb goes
   to a local address from the error's route (RTF_LOCAL), like icmp
   (RTCF_LOCAL), instead of the address list (Sashiko)
 - selftests: the extension header test runs on netdevsim too, and
   removes the socket option before closing. the fragment test uses the
   source address of the route, and turns off tcp_mtu_probing

v4: https://lore.kernel.org/netdev/20261103001143.246081-1-toddfreed@meta.com
 - back to dropping ipv6 packets with extension headers, but moved into
   mlx5e instead of psp_dev_encapsulate()
 - drop the psp core changes to rx and tx ipv6 extension headers
 - new patch 2 to drop decrypted skbs instead of fragmenting
 - new patches 3 and 4 to prevent quoting just-decrypted packet contents
   in icmp errors, v4 and v6 respectively (Jakub, Bjorn, Sashiko)
 - new selftest: ipv4 fragments of a psp tcp socket

v3: https://lore.kernel.org/netdev/20261023234640.1459291-1-toddfreed@meta.com
 - new patch 1 to fix tso checksum seed calculation in mlx5e (Daniel)
 - accept routing headers and reject ah (Daniel)
 - split the psp_dev_rcv() change into its own patch (Daniel)
 - return -EINVAL instead of -1 (Daniel)
 - selftest: one variant per extension header type (Daniel)

v2: https://lore.kernel.org/netdev/20261022223014.556388-1-toddfreed@meta.com
 - walk the extension headers instead of dropping (Daniel)
 - reject fragment headers (Bjorn, Daniel)
 - reject routing headers
 - psp_dev_rcv() handle the rx case as well

v1: https://lore.kernel.org/netdev/20261021210200.788191-1-toddfreed@meta.com

Todd Freed (8):
  net/mlx5e: ring the tx doorbell when an accel offload drops a packet
  psp: don't encapsulate ipv6 packets with extension headers
  net: don't fragment decrypted skbs
  ipv4: icmp: don't quote decrypted payload in icmp errors
  ipv6: icmpv6: don't quote decrypted payload in icmpv6 errors
  selftests: drv-net: psp: test ipv6 tcp socket with extension headers
  selftests: drv-net: psp: test that ipv4 psp packets aren't fragmented
  net/mlx5e: psp: tso: replace only the length in checksum seed

 .../mellanox/mlx5/core/en_accel/psp_rxtx.c    |  21 +-
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   |   8 +-
 net/ipv4/icmp.c                               |  12 +
 net/ipv4/ip_output.c                          |   8 +
 net/ipv6/icmp.c                               |  16 ++
 net/ipv6/ip6_output.c                         |   9 +
 net/psp/psp_main.c                            |  21 +-
 tools/testing/selftests/drivers/net/config    |   1 +
 tools/testing/selftests/drivers/net/psp.py    | 249 +++++++++++++++++-
 9 files changed, 327 insertions(+), 18 deletions(-)


base-commit: 8012eec76b7e6c0d9fb338fe8e3db6ca1b419da4
-- 
2.53.0-Meta
