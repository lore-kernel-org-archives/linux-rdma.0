Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.145.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794947589;
	b=clgUeZl3QNyjAz4y/jyA+sil3jGuNyOJH7gzcigAxyP+83LpD+h0vp2PDIoT6tEUa5ig
	 fE2txcSy9rSgc1XKdj0wCecg0+3wrHICqZ53wTl4p5C5PiwQGS3Y4vu067szg3nRbGh8I
	 B3ioYk8BdTlGI8I6q1oKtBFhM2MUugs2xSJoXfor81FAJnoJb3HrHE+kqLkPj+llVgXvy
	 9jiNgIyfFsDWdGDvF3kuCie4Bz2nCma2dlY9bvnGGU+Wvy3jERpwAscTs1A9YE/R6PYwe
	 e5hjjrS4WU7vuGReiOczz8HtyowGYweug/1n6SQ0b03iIFtfZ04mlanevgkWs1SeNYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794947589;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Originating-IP:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version;
	bh=Z4w99euxBGug7KMT0Ys54WxloUFYAkIjMMJNYjoJVYg=;
	b=w+kM9CwepNmuUVGUN8tOW/CqYtAdOwC17FnURQwM2AOPwHQSHnMlsiHjr+moCYrZjFXM
	 k6emexN95rsAleNZxNsWThNuMu9Bt7l8VSAcTbkjsrLxY1u1VBQKa5vxRBF0H9oXOIy0a
	 Uo6GKUacOxFc2MjLTUCMfhSKcY5Hgl6IgoTT2vJs252fPKrerY8C/9rTYXbfjMMJkISCi
	 kJpjuNpLLZY/wDg/B+Oxnfm/s0nupiv7Zv3/53gl5HGH0A2RzK6xQx3NLY6Pej1CqZN7W
	 JWwew2vwD7gvKWMUyZ43hlQMZwXxR86UWriar7Ccx25EeE/Fyws5aZ2X3MAN728k6iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=SHFjE+KH;
	arc=none smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D5C606A32C;
	Tue, 17 Nov 2026 20:33:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 67D5C606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=SHFjE+KH
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AHJ9RJ91900368;
	Tue, 17 Nov 2026 12:32:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps82601-s2048-2026-q3; bh=Z4w99euxB
	Gug7KMT0Ys54WxloUFYAkIjMMJNYjoJVYg=; b=SHFjE+KH08HEr/XicUwYNcW8/
	a2m3aTPHTBBwxhRyT9kGMsR7ueUUYDD9CKBATGVJd39oeSl8elKtDsNjAkOzsX0t
	Pc40+6cbqmnrGQEkUWi4ucFkgj5h5onIWLu/FJ6eWP5FRGsrwV1tKcHJg5XXTFx5
	s71DQpTfcqlKRYN9CU4Oly0E4fFbkHXJQCMqV9oFdyzggkDLacZbVgOX0Lf9ZhvC
	UQmix/D+Yd0u4DQESpqaxXMCEXInH+pwZs3QuGUqj3G+jbXL9lU5+2TmBo/ecTFi
	4huA0y7Mj3wmkKp1zE36VmhR7SFXBXkAh4IX3hsoRIkUhxO+nJhMKRVYM97Ew==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j0r2dcax3-8
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 17 Nov 2026 12:32:53 -0800 (PST)
Received: from localhost (2620:10d:c0a8:1b::2d) by mail.thefacebook.com
 (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Tue, 17 Nov
 2026 20:31:42 +0000
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
Subject: [PATCH net v6 0/8] psp, tls: don't send offloaded contents in cleartext
Date: Tue, 17 Nov 2026 12:31:29 -0800
Message-ID: <20261117203137.804424-1-toddfreed@meta.com>
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
X-Authority-Analysis: v=2.4 cv=Q5lHcI2a c=1 sm=1 tr=0 ts=6afcb9f7 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=7x6HtfJdh03M6CCDgxCd:22 a=tpM8CJlwf7uhpglF1g9U:22 a=VwQbUJbxAAAA:8
 a=VabnemYjAAAA:8 a=MlFgQxvlSbYgrk1dUBsA:9 a=QEXdDO2ut3YA:10
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-ORIG-GUID: BgGb649__KSmnLbU1--2mZTu3oyGrb7j
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE3MDA4MSBTYWx0ZWRfXyQT+0Z1cHySo
 l16tWikUl9bDhRl9XQGStva8YYEYdZ0ympJx7f6gUwftpPdC1iFjFc7i0FIFNnsQoC5nSyd50wc
 cN3+0VBFPbN9aFc9F5a18wVGcVTwe8I=
X-Proofpoint-GUID: BgGb649__KSmnLbU1--2mZTu3oyGrb7j
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE3MDA4MSBTYWx0ZWRfX6kRGzDQ3mELu
 OB4+KQmbUVbOTs0SQbZ+53mpmL4iIGlM+ATeE40oh5w6zi853HpaASoMxxtiK0TngPCh5YH8rbm
 aiAipf5oFEVzXHwHv+ixzAA9OxZfUNGZRLry388wST56Mk9b+PsQRWvIKOTzr/iT13MtWeq7hTy
 S8Qr2rnE1dhXguLC/ELkpUzoNLzqOx8bPPViGFz4NiGNehtffFBrD60wkqBC15OkoWm3aUvj1e9
 yHZ4xBfa3fF7F0NruxV2xwHUzBJU5gA6+lyGrykEgNzK3QtpB3He/4F9BsMAV68cJD50sPq7znh
 drn5FYJApnZsu6kWB5mB4ihZe0bfJFCw27KiCo7yz10JQy8Qj9QMm/rG7W0uFgm7ytKR6q3ZNku
 g6IZMzjsYP+WuQXuiQHOytRBIBzsuQxAPaHNyhIVsiOzPTXXstUK+i+3lm00jP6kw+AnEnLGLnG
 mDAGZK6xiSkYZ8b/l9w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-17_04,2026-11-16_01,2025-10-01_01

While working on adding support for socket-less psp associations, I
noticed the case of ipv6 extension headers was not being handled
properly for psp packets. It will be relevant with that series, because
it adds udp support, for which the inner packet needs to be inspected
to set the psp nexthdr.

That led me to various other ways the encryption offload path could
transmit packets unencrypted.

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
outside these paths. A separate nf-next series applies the same rules
there.

Testing:

hardware testing was done on connectx-7 (fw 28.48), between two x86
hosts, plus netdevsim.

 - drivers/net psp.py: on netdevsim, all 36 tests pass. on mlx5, 40
   pass, 4 skip (gmac versions the device doesn't support), and 2 xfail
   (netdevsim only). the gmac variants of
   data_basic_send_netkit_psp_assoc fail: that test doesn't skip
   versions the device doesn't support, which is fixed separately.

 - drivers/net/hw tls_hw_offload.py on mlx5: all 8 tests pass.

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
   (icmpx port-unreachable) in the inet family:
   - in an input chain, of received decrypted packets: without the fix,
     the errors go out on the wire, quoting the decrypted packets. with
     it, no error reaches the wire.
   - in an output chain, of a psp socket's packets: the error is
     delivered to the local socket, with and without the fix.
   - a PKT_TOOBIG from ip6_fragment() about a psp socket's packets is
     delivered to the socket, with and without the fix.

v6:
 - patches 4 and 5 - since "net: Make PSP skb extension survive packet
   scrubbing", some of the comments on patches 4 and 5 no longer make
   sense (psp skb and ktls skb can now be reliably distinguished). the
   behavior from v5 is retained, the rationale has been updated.
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
 - new patch 1: mlx5e rings the tx doorbell when an accel offload drops
   a packet, and checks the stop room after the nop it posts (Sashiko)
 - ipv6 extension headers: drop them in psp_dev_encapsulate() again,
   instead of in mlx5e. it's the helper which can't encapsulate them,
   for every driver (netdevsim sent them malformed). unlike the routing
   header rejection in v2, this isn't a device limitation
 - don't fragment decrypted skbs in ip6_fragment() either
 - icmp and icmpv6: send no error at all about a received decrypted skb,
   instead of quoting up to the tcp header for tls offload
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
 net/ipv6/icmp.c                               |  18 ++
 net/ipv6/ip6_output.c                         |   9 +
 net/psp/psp_main.c                            |  21 +-
 tools/testing/selftests/drivers/net/config    |   1 +
 tools/testing/selftests/drivers/net/psp.py    | 245 +++++++++++++++++-
 9 files changed, 324 insertions(+), 19 deletions(-)


base-commit: 5e9b2ad9b8384cd3c417cd5e2c3bc7eee4a72791
-- 
2.53.1-Meta

