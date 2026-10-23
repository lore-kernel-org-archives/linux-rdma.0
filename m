Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.153.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792799247;
	b=2CV7UZkFeyYfHolSR1XPb8eXQaae6VISWq2jc01TYXHd3Jk6SruHcTOQfivDzuwMvzvt
	 Mfr3J7k5J9tgd1/7/4TiIJPLHbI4k7vA6+09H8uroQi+V1jrm5zrvsU300+WmWXcgxRgV
	 rUM6O0g0oLvv21Iyc6iJ+SuF9IOu3AUSr77UNShq54YLjlL/O08NrLABhFjg7lwoKrR6k
	 JMDrJcoVC0CMqFXNNs+USQxfiISMxrNEWqWQAp5XwTfDPk8b2pOG3VW1WP6elPKiDYTxE
	 eD2OPOOZa2F4Qk19bE7Z2nfyakaLt7FTua8Bjn6T0XclbGa/pEp/6aVxS8mGGXTkhAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792799247;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version;
	bh=xY/lbXIDD/cw1YQzgAjuMunrzYSAnrdxX3pYv1M5h8k=;
	b=HTG1/eEkK0ow6v4CJJRopxnSzhJtc8TT/8Ow1S4oIHpf0d1comjNdF/UcBxEsOgLKpbz
	 vAw+l8K2WnxW8eCXElpsy1zj0bg7vavDxkLf1UDNgn3wQysyy48Jrz6ns01pLwELrXWp4
	 1sI6KfsPff3m++TyS2E6czc3Ci8wad2mV0wj5ivYiZZuQw3YFb92x3mCgzPurjDR0OZfG
	 nMomt0p8xxG+9zcJiDET31dUtXDwPIZ9KbZfeNbyuG9q9xVy1yqQVI0RCa0+qrPmrAWdr
	 nb2AchYptWH37uD/lOO89cuOUAyQ+9TT5v51TymvufS4PAOIjO37eY04YHbOquKv6Ig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=bVi1Dvhf;
	arc=none smtp.remote-ip=67.231.153.30
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78DA606A31A;
	Fri, 23 Oct 2026 23:47:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C78DA606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=bVi1Dvhf
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69NLxFWH1030373;
	Fri, 23 Oct 2026 16:47:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps82601-s2048-2026-q3; bh=xY/lbXIDD
	/cw1YQzgAjuMunrzYSAnrdxX3pYv1M5h8k=; b=bVi1DvhfM8F6ojLOH02+P8dzz
	oXF/O4o+4zoCahdRBns0k+5knKRwpnfqUuxkIIo0Ew0ms+10sUjO9coLt5Uvei7q
	m2bLD3r+GBM7se0+AMRWxnDozPwFRgw4fYJgdHLShmtWmqPOJDhBPwNgYNVNiOLq
	MWQXG9Wgt1XIh6aLg3u3u1VatuR6VdcU+kbHUHSDSebWD8ozr2KJ8blFoCUXP1Tu
	wj/uOHl2cI8v02LL8Q9yFSi3Q4yXM1CmDWcyzVkdWe8sAaTqgw5ICvzUB7okjeFi
	D8yowzmZ7zaM46z9vmBQrZLK1OhrtpxNPi7yGKbZ7umFIyIb1xXVGv/iwnpUQ==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4hf9mxf8ta-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Fri, 23 Oct 2026 16:47:15 -0700 (PDT)
Received: from localhost (2620:10d:c085:108::150d) by mail.thefacebook.com
 (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Fri, 23 Oct
 2026 23:47:13 +0000
From: Todd Freed <toddfreed@meta.com>
To: <netdev@vger.kernel.org>, <toddfreed@meta.com>
CC: Boris Pismenny <borisp@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
        "Mark
 Bloch" <mbloch@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
        "David S.
 Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@kernel.org>,
        "Jakub
 Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Daniel Zahka
	<daniel.zahka@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Simon Horman <horms@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Cosmin Ratiu
	<cratiu@nvidia.com>, Raed Salem <raeds@nvidia.com>,
        Rahul Rameshbabu
	<rrameshbabu@nvidia.com>,
        <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Dragos Tatulea
	<dtatulea@nvidia.com>
Subject: [PATCH net v3 0/4] psp: fix transport mode with ipv6 extension headers
Date: Fri, 23 Oct 2026 16:46:36 -0700
Message-ID: <20261023234640.1459291-1-toddfreed@meta.com>
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
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: f7yLiuhcCCL4BMv4hM2f18I1-jLTL3A1
X-Authority-Analysis: v=2.4 cv=G7iJgNk5 c=1 sm=1 tr=0 ts=6adbf203 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=wpfVPzegXHpEFt3DAXn9:22 a=VwQbUJbxAAAA:8 a=VabnemYjAAAA:8
 a=vGNZGGMuHs9qvOvCr9cA:9 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDA5MyBTYWx0ZWRfX38oYu+qigF07
 pXCGSz0ZqSzd4RBh8qqC32+ekLjGVRuwbrY9kKXifFC/5CxMyzSVumpmJl8BDbrD9TVhMWZm0+E
 8EhcCYy7uIyLsinkQE6inB64lXF0RHU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDA5MyBTYWx0ZWRfXzWlDjkXrC59/
 5mblvnr5O/hVaKyDJqayoJRDplHdtJok3eCOKga4oY7qN3E3ZaAi445V/qMFuhLxVKhqVct0rsV
 o0k0J5hjGXARZsBH3+64UWidH+BQ3JU/YXRFElSZqbrXsslpvIbpbCFrKuFV1rO9AHXVP0lAm0w
 54U9Wm04+ltz5Td9I5onOGoNRJTTV2dvOsbn2cwXVmetV783QAivo6kKS+nd4mef3orhZ9ijK+e
 X+xzAvp4cxWU1aM2vDMvTnk1N+S506eBRECCRcihp3Jd1A3ELy+ft1aHRabNfqJnQC7WRRYcpsm
 ThRfYmm88CmQhAx53uHeecEDnBOk9dKfKz4BCjFWC28gtQYkCt5L9qxDwH6xfS5lYArX+WelcyK
 BiUNBd+H8gaUSKaElZjLUkz4Vkom4m/rOzR7oiKXKMUofADOGBBgQrST6uSJjT12xvzWQKqVAvD
 UMTV1ZYSgIK/eMmpxLQ==
X-Proofpoint-ORIG-GUID: f7yLiuhcCCL4BMv4hM2f18I1-jLTL3A1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_06,2026-10-21_02,2025-10-01_01

While working on adding support for socket-less psp associations, I
noticed that this case was not being handled correctly. It will be more
relevant with that series, because it adds udp support, for which the
psp nexthdr will be taken from the inner packet.

Since the tx association encodes intent to send encrypted packets, but
because of other configuration (socket options, routes) the packets are
sent unencrypted, sending this change as a fix.

The first patch fixes an mlx5e bug in tso checksum calculation for psp
with ipv6 routing headers.

The second patch fixes the receive path when ipv6 extension headers are
present.

The third patch fixes the send path when ipv6 extension headers are
present.

The fourth patch adds selftests for these cases.

Note that no test case is added for ipv6 fragment headers. As far as
I can tell it's not possible to tx fragments from an ipv6 tcp socket.

All testing was done on connectx-7.

v3:
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

Todd Freed (4):
  net/mlx5e: psp: tso: replace only the length in checksum seed
  psp: support ipv6 extension headers in psp_dev_rcv() decap
  psp: support ipv6 extension headers in psp_dev_encapsulate()
  selftests: drv-net: psp: test ipv6 tcp socket with extension headers

 .../mellanox/mlx5/core/en_accel/psp_rxtx.c    |  21 ++-
 net/psp/psp_main.c                            |  79 +++++++++-
 tools/testing/selftests/drivers/net/config    |   1 +
 tools/testing/selftests/drivers/net/psp.py    | 137 +++++++++++++++++-
 4 files changed, 215 insertions(+), 23 deletions(-)

-- 
2.53.0-Meta
