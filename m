Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.145.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795482409;
	b=kw+zciOpjkxrjVQ9jEe9Y+SElj0N4AeWdMwl9C75ZiWH0h9p5zF+IEDRnZ+8X3f0BjIE
	 8FLcgd3H3fxbSkiU4t2Wb2CXHOC4zEL4oZxm7T9GwG1mBwV+lcvWFyq9R7HTT5b4eS69U
	 DlDgDpU0EiCuZq7RznoxaceK5WiSXSj9qZolNjuESH+2wrdkqyzcI9VJSITEMtNWZgDaz
	 KRCNgo1Zqz6Jv3RTdER3nH2kakoIy1xwEzLkrWg+TfBpDeVTx3kaGcVga5TQtA3GgpZOh
	 j0xbC9OQEfaCVZVY9Q4aKSx7CnqXAqchTBNW5u1UVAAu1Ydq/6MFv3Xb2rlUbMv7NoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795482409;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Originating-IP:X-Authority-Analysis:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version;
	bh=c1loJS1Ed3ZhaiQ4hylSWqjgNdpjwXI82eLrylBd2aI=;
	b=BuXHTNHPQXkGjXPGqtSo0kJesgXX4E1x2yvGotoC6Yu6co7KtRWjhEUVF2iyE0DPFco8
	 BDfxm/N5bTc3n9BPbwAOMu6S5g2iyvfJk19XNhJ/xsGJiWDuLwn89h9vsgL31Yxz/aR7n
	 1SV1erVNAwczYFk7FSpB0CPd6Lw7ipNX1tWN8swTWVuVLJwwfsS3FLF1q4uKIB+jWfmIA
	 ZClnLalc8ZM42UjmI8VGLXEHOPNj8v8pnbGqTJplC8qRqluxsjYkS/g4LDVmbQQS+0LiC
	 kQa9DDM5MhjAh9LLO8bn/Zv4vqZNjf5DPEeFRrX/OQ5q9vjNViTxFgtPMPpKY+T7m2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=MxtvGPkF;
	arc=none smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180A6606A31E;
	Tue, 24 Nov 2026 01:06:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 180A6606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=MxtvGPkF
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ANJwPxX2855314;
	Mon, 23 Nov 2026 17:06:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps82601-s2048-2026-q3; bh=c1loJS1Ed
	3ZhaiQ4hylSWqjgNdpjwXI82eLrylBd2aI=; b=MxtvGPkFETYl6ViKsFr0GDQh6
	5mdjer+C//AgVsuINe13UwErmxf37r13AbWA12yu0Nv7OcxDKIxnzeNZYLfAmjTc
	EWvwrZztFuqEA/hNRsoLh7JW1PdvvJanTkwbtLVQeQA3zAyPsG2oHfI/bYJk0yLX
	kIB5Wp/yaKoKQz2odwX9yBoXUf15BtG0kczrOSbgvTvEwg1u65ErcJKmkZ3sZZuV
	Edq75YwN1+qss/Rgz855xUZMHd3eDflegnQjS1DoJ0uS+3LndB6U2PZCY5DLlC9i
	kdpgfxLNMBv27Fxyi6n+hNf3cBKlSgcyos7VlpM1rNZ5O3o3Ykb8LIF42PmgQ==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j3bfmwkwm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 23 Nov 2026 17:06:29 -0800 (PST)
Received: from localhost (2620:10d:c0a8:1b::2d) by mail.thefacebook.com
 (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Tue, 24 Nov
 2026 01:06:27 +0000
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
        Sabrina
 Dubroca <sd@queasysnail.net>,
        Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan
	<shuah@kernel.org>,
        Simon Horman <horms@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>,
        Wei Wang <weiwan@google.com>,
        Willem de Bruijn
	<willemdebruijn.kernel@gmail.com>
Subject: [PATCH net v7 0/9] psp, tls: don't send offloaded contents in cleartext
Date: Mon, 23 Nov 2026 17:05:52 -0800
Message-ID: <20261124010601.3995693-1-toddfreed@meta.com>
X-Mailer: git-send-email 2.53.1
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
X-Authority-Analysis: v=2.4 cv=DqvDa2/+ c=1 sm=1 tr=0 ts=6b04e315 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=7x6HtfJdh03M6CCDgxCd:22 a=crHB47gyY4rKiduisYu9:22 a=VwQbUJbxAAAA:8
 a=VabnemYjAAAA:8 a=ikEhOfIDCRWk4WNS1fUA:9 a=QEXdDO2ut3YA:10
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-GUID: P0UkhKaty1Bkqt0ZL3j4w_m2iukH5HyM
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI0MDAwNCBTYWx0ZWRfX3ANf5EK3bxDY
 dOiM+u4dWS/PYrpdlcQiiUWFyzXMZoKmXXSIMxOjfLZAMF0OPQLeuM1W8IRhadp0KbYkj8ke08A
 RzutR+jdquYX+ewX7tnQpYM1Zrs5674=
X-Proofpoint-ORIG-GUID: P0UkhKaty1Bkqt0ZL3j4w_m2iukH5HyM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI0MDAwNCBTYWx0ZWRfX9yMY6hTL3a4+
 XOuHF6pwO9l77k1KpuASPmbO4XiKRjz4GrIVX4QmPy9V9Emm3Uad6JxSyWqTTyvOfqsrFJwukvl
 MoSmD1kOsZTxO6tBtStCH9HC+WTizBacEutC1Cy6f/YfVRQEz8x2KYIbuOzF30mf2lOcChfZDpq
 A5XEFtFPfhUyVYMyZ9QbxSqJHMqPPRdHciXk820l7kBB+Gd6xvzcGFXSKvkO4fN8daX2BUVs78l
 M+lEosjdf5F+xyjGDAmI5MsQmO0+pNB0vdDLSMV/ZtM/4FNDx2n8XFgkDbgZFrzoHGHyVUgKlSK
 sVtfvea6VqCHg9ZeZtm4bDVhkz9TaIDPj+soQ8MiW/DqbIxAu+QIa/egl0JwKpKt9C/GER1XB8Y
 vWPvDVwNl2O3F/I2A3NzWou7ZfIbPFvqzO6ZeESPPszVOOcO5jW/5Pww3RvwAm8eRaeqLn9P3t+
 Tbv54jEjHB3dAS3TdVg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-23_05,2026-11-23_01,2025-10-01_01

While working on adding support for socket-less PSP associations, I
noticed the case of IPv6 extension headers was not being handled
properly for PSP packets. It will be relevant with that series, because
it adds UDP support, for which the inner packet needs to be inspected
to set the PSP nexthdr.

That led me to various other ways the encryption offload path could
transmit packets unencrypted.

Since the PSP/TLS association encodes intent to send encrypted packets,
but these various cases circumvent that, sending these as fixes.

The cases are:

 1/ IPv6 extension headers (patch 2; patch 1 makes mlx5e flush its Tx
    queue when the resulting drop happens)
 2/ fragments (patch 3)
 3/ ICMP errors (patch 4)
 4/ ICMPv6 errors (patch 5)
 5/ IPv6 redirects (patch 6)

Cases 2 to 5 are relevant for kTLS as well as PSP.

Patch 9 fixes an mlx5e bug in TSO checksum calculation for PSP packets
when the L3 dest is an intermediate hop (IPv4 source routing). It's not
about preventing unencrypted Tx, so could be considered separate.

netfilter's reject expression in netdev and bridge chains builds its
own ICMP errors, outside these paths. A separate patch to nf applies
the same rule there,

https://lore.kernel.org/netfilter-devel/20261123231835.2356740-1-toddfreed@meta.com

Testing:

Hardware testing was done on ConnectX-7 (FW 28.48), between two x86
hosts, plus netdevsim.

 - TSO checksum seed: a PSP TCP socket with an IPv4 loose source route,
   the peer checking TCP checksums in software. Hundreds of checksum
   errors before the fix, none after.

 - Fragments, with TLS offload and PSP:
   - IPv4 (route MTU above the device MTU, IP_PMTUDISC_OMIT): without
     the fix, some fragments after the first go out in cleartext. With
     it they're dropped.
   - IPv6, through an IPVS DR service with a local client: without the
     fix, fragments after the first go out in cleartext, and the peer
     reassembles them. With it they're dropped.

 - ICMP and ICMPv6 errors, on netdevsim PSP, with an nft reject rule
   (icmpx port-unreachable) in the inet family:
   - In an input chain, of received decrypted packets: without the fix,
     the errors go out on the wire, quoting the decrypted packets. With
     it, no error reaches the wire.
   - In an output chain, of a PSP socket's packets: the error is
     delivered to the local socket, with and without the fix.
   - A PKT_TOOBIG from ip6_fragment() about a PSP socket's packets is
     delivered to the socket, with and without the fix.

 - IPv6 redirects, on mlx5, with the server forwarding on its interface
   (force_forwarding), as described in patch 6:
   - kTLS and PSP: Without the fix, the redirects from the server quote the
     decrypted TCP header and payload. With it, no redirect is sent for the
     decrypted segments.
   - In both cases, redirects for packets that weren't decrypted are
     still sent.

v7:
 - new patch 6: ip6_forward() quoted decrypted packets in the NDISC
   redirect, which doesn't go through icmp6_send(). Don't send
   redirects for decrypted skbs (Sashiko)
 - patch 3: the commit message now says the check comes after the
   ignore_df and frag_max_size too-big checks (Sashiko)
 - patch 5: log the dropped errors with net_dbg_ratelimited(), like the
   other cases where icmp6_send() doesn't reply (Sashiko)
 - sentence case in the commit messages, and patch 9 wording (Dragos)
 - Cc: stable on the fixes (patches 1-6 and 9)
 - rebase on net/main

v6: https://lore.kernel.org/netdev/20261117203137.804424-1-toddfreed@meta.com
 - patches 4 and 5 - since "net: Make PSP skb extension survive packet
   scrubbing", some of the comments on patches 4 and 5 no longer make
   sense (PSP skb and kTLS skb can now be reliably distinguished). The
   behavior from v5 is retained, the rationale in the commit message has
   been updated.
 - patches 4 and 5 - clarified which reject rules go through icmp_send()
   and icmp6_send(), so that it's more obvious how the nf-next series
   applies (Sashiko)
 - patch 5 - icmpv6: explain why the check of a locally originated skb
   comes after the rate limit (Sashiko)
 - patch 6 - remove the socket option and close the connection in
   separate try blocks, and don't overstate the variants (Sashiko)
 - patch 7 - use ctl_file_write() to turn off tcp_mtu_probing, including
   1 (Sashiko)
 - Cc: stable on the fixes (patches 1-5 and 8)
 - rebase on net/main

v5: https://lore.kernel.org/netdev/20261111001831.3710881-1-toddfreed@meta.com
 - new patch 1: mlx5e rings the Tx doorbell when an accel offload drops
   a packet, and checks the stop room after the nop it posts (Sashiko)
 - IPv6 extension headers: drop them in psp_dev_encapsulate() again,
   instead of in mlx5e. It's the helper which can't encapsulate them,
   for every driver (netdevsim sent them malformed). Unlike the routing
   header rejection in v2, this isn't a device limitation
 - don't fragment decrypted skbs in ip6_fragment() either
 - ICMP and ICMPv6: send no error at all about a received decrypted
   skb, instead of quoting up to the TCP header for TLS offload
 - ICMPv6: decide whether an error about a locally originated skb goes
   to a local address from the error's route (RTF_LOCAL), like ICMP
   (RTCF_LOCAL), instead of the address list (Sashiko)
 - selftests: the extension header test runs on netdevsim too, and
   removes the socket option before closing. The fragment test uses the
   source address of the route, and turns off tcp_mtu_probing

v4: https://lore.kernel.org/netdev/20261103001143.246081-1-toddfreed@meta.com
 - back to dropping IPv6 packets with extension headers, but moved into
   mlx5e instead of psp_dev_encapsulate()
 - drop the PSP core changes to Rx and Tx IPv6 extension headers
 - new patch 2 to drop decrypted skbs instead of fragmenting
 - new patches 3 and 4 to prevent quoting just-decrypted packet contents
   in ICMP errors, v4 and v6 respectively (Jakub, Bjorn, Sashiko)
 - new selftest: IPv4 fragments of a PSP TCP socket

v3: https://lore.kernel.org/netdev/20261023234640.1459291-1-toddfreed@meta.com
 - new patch 1 to fix TSO checksum seed calculation in mlx5e (Daniel)
 - accept routing headers and reject AH (Daniel)
 - split the psp_dev_rcv() change into its own patch (Daniel)
 - return -EINVAL instead of -1 (Daniel)
 - selftest: one variant per extension header type (Daniel)

v2: https://lore.kernel.org/netdev/20261022223014.556388-1-toddfreed@meta.com
 - walk the extension headers instead of dropping (Daniel)
 - reject fragment headers (Bjorn, Daniel)
 - reject routing headers
 - psp_dev_rcv() handle the Rx case as well

v1: https://lore.kernel.org/netdev/20261021210200.788191-1-toddfreed@meta.com

Todd Freed (9):
  net/mlx5e: ring the tx doorbell when an accel offload drops a packet
  psp: don't encapsulate ipv6 packets with extension headers
  net: don't fragment decrypted skbs
  ipv4: icmp: don't quote decrypted payload in icmp errors
  ipv6: icmpv6: don't quote decrypted payload in icmpv6 errors
  ipv6: don't send redirects for decrypted skbs
  selftests: drv-net: psp: test ipv6 tcp socket with extension headers
  selftests: drv-net: psp: test that ipv4 psp packets aren't fragmented
  net/mlx5e: psp: tso: replace only the length in checksum seed

 .../mellanox/mlx5/core/en_accel/psp_rxtx.c    |  21 +-
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   |   8 +-
 net/ipv4/icmp.c                               |  12 +
 net/ipv4/ip_output.c                          |   8 +
 net/ipv6/icmp.c                               |  23 ++
 net/ipv6/ip6_output.c                         |  14 +-
 net/psp/psp_main.c                            |  21 +-
 tools/testing/selftests/drivers/net/config    |   1 +
 tools/testing/selftests/drivers/net/psp.py    | 245 +++++++++++++++++-
 9 files changed, 333 insertions(+), 20 deletions(-)


base-commit: 639a75a3539f621e4437ffeec7ab51bf8a1fb170
-- 
2.53.1-Meta

