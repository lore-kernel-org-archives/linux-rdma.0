Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794229849;
	b=ZwQh4oHVRxaqO61oxF9Zb6DW8KE8IAv2PnSyCbYBXWBPcUiSmEpxkgFrnQwYCuSEibfJ
	 opffNNFCB2pZTbUsjxl+H8XMpas3l6QFL39hJZ4RToPn3fkTeJCOIPyhlIwmxWiQApQTR
	 Uhf2cSiOfnkaco4rYKTh09U/1pd5SD3tYjAehjqS3JPhYgoDXEiIQweD+G6btTOKEcaPb
	 rL7ElfVKZrJa4aOdRwEu2DWKwL4SW1ILQ2cc/wU8BnFOFbwZt/FKfTMplxtnjiLkPnX0C
	 IDj7+uJqpJLv138Yk5Tx6DFE7YV4yZHjvpaCL5iVUv1+AGIoR6xfcK4JFJRm4VX663g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794229849;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=5HfqLaHQQID7K+9s2VYZQQWT6Sc5F9YKJv+Wsrmre/c=;
	b=npFyPtKrikRhU4aHrIro05mrc19DmCmN0J7aZCMJ1mQ+SLP7x7pgLOOCXf25Zw84utgP
	 ndScsMyMqt4NXXHQiSa4WJVb/mquy2YbGuS+6OiDjxI+k9tPwRHEI8WRIu534MnxkZJ+l
	 1NRzmRSGmLroz8Dw4BrnN2X8x6r/6ntvk8UFll0VTAzs2ngfL9pGJSKozAIo3yWtmqbZK
	 0sTfpYH7tYtHSAc8VJLaRqvV06yLQiRXxrylbsLB3Jk8YXY+8IXe2jrT/KsqH34NVkU3f
	 sMLsIybJLHp7OPlx6Lx1uBSUezrTG8R9xiQBW92PdYujJeF+yQ0j3WqUf/Xc11Qe68Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=ITBGX0gA;
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E340606A326;
	Mon,  9 Nov 2026 13:10:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4E340606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=ITBGX0gA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1794229845; bh=SokaqJSrdGcmob7aGPdeKZ+yhFE8lkwZPNwMisIKdl8=;
	h=From:To:Cc:Subject:Date:From;
	b=ITBGX0gAf22T1oC7P0ki/LSP+xDgxi9MscigC4cZpg9QIoXkfd2qXjRUWxfST/+cP
	 aauAEEOrU7cfRjgLvSdDn/5HO12L517gXfus9v9uW6K8V7YTKe2k7c9Levnd2qEGii
	 VRnhF5DJHxwHufcQ/BSyw6mR0RlOWBgI+jUXSscWbe5b2suuduoUDmlnetGyN2G3Wp
	 LYI0pCQA9b4ngjULI/AVdKutkBfe97qu0G6W0w4F9DaEOygk2Pgd70MFrzqdpsQNiy
	 JoaU1qF53TUr79t055Je0sCNKeY+7U/pzltiB5YIZPVRzqkCIxVoEz9OqlB4Hsvxh+
	 AJhoGdCZFnB6g==
Received: from lnxos-dev.home (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id 3B1FD44C1118;
	Mon,  9 Nov 2026 14:10:45 +0100 (CET)
From: Alexandre Cassen <acassen@corp.free.fr>
To: Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jiri Pirko <jiri@resnulli.us>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Michael Chan <michael.chan@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Potnuri Bharat Teja <bharat@chelsio.com>,
	Donald Hunter <donald.hunter@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Shuah Khan <shuah@kernel.org>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	oss-drivers@corigine.com
Subject: [PATCH net-next 00/10] tc flower: tunnel key partitioning for RX queue steering
Date: Mon,  9 Nov 2026 14:10:26 +0100
Message-ID: <20261109131039.959438-1-acassen@corp.free.fr>
X-Mailer: git-send-email 2.43.0
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

RSS cant spread GTP-U traffic between a few endpoints. The outer headers
barely vary and mlx5 does not hash the TEID. One flower rule per TEID does
not scale.

Add a mask to the flower enc_key_id key and offload it on mlx5e NIC flows
with skbedit queue_mapping. One rule then steers a block of tunnel keys to
an RX queue. This "tunnel key partitioning" supports fine-grained session
placement. In a 5G mobile network, the UPF can place a session on a CPU by
allocating its TEID from the right block [1]. Any scheduling algorithm can
then pick that block.

  tc filter add dev eth0 ingress protocol ip flower skip_sw \
      ip_proto udp dst_port 2152 enc_key_id 0x40000000/0xc0000000 \
      action skbedit queue_mapping 1 skip_sw

This series generalize an earlier GTP-U work [2] to other tunnels that the
ConnectX family can steer: GRE, VXLAN and GENEVE.

Patches 1 to 5 refuse a partial mask or a key wider than the VNI where a
driver cant honor them. Patches 6 and 7 add the flower mask and its test.
Patch 8 adds queue mapping to mlx5e NIC flows. Patch 9 adds the tunnel key
match to mlx5e NIC and eswitch flows without a tunnel device. Patch 10
documents the result.

Without a tunnel device nothing decapsulates. enc_key_id reads the tunnel
header on the wire like on cxgb4 and hns3. On mlx5 the plain ip_proto and
dst_port keys select the match register. A rule on the uplink representor
used to ignore enc_key_id and now matches it or gets refused. I can rework
patch 9 on a dedicated key if that looks cleaner.

Tested on ConnectX-7 with firmware 28.48.1000 in NIC mode. Also tested on
the uplink and VF representors in dmfs, smfs and hmfs. This includes
redirect to a VF. GTP-U needs flex parser profile 3 and GENEVE profile 0.
The bnxt, cxgb4 and nfp patches are build tested only. The selftest passes
under User-Mode Linux and fails on a kernel without the mask.

Multiple AI tools were used to test this feature. They found the problems
fixed by patches 1 to 5.

The iproute2 support is posted separately.

[1] https://gtp-guard.org/articles/5g-upf-pump-up-the-volume/#benefits-of-range-partitioning
[2] https://github.com/acassen/research/tree/main/UPF-flow-steering

Alexandre Cassen (10):
  bnxt_en: require an exact tunnel id in TC flows
  cxgb4: flower: refuse a tunnel key wider than the VNI
  nfp: flower: refuse a tunnel key wider than the VNI
  net/mlx5e: TC, refuse a tunnel key wider than the VNI
  net/mlx5e: TC, reject a partial tunnel key with tunnel mapping
  net/sched: cls_flower: add enc_key_id mask
  selftests: forwarding: tc_flower: test the enc_key_id mask
  net/mlx5e: TC, offload RX queue mapping in NIC flows
  net/mlx5e: TC, match the tunnel key without a tunnel device
  docs: networking: describe tunnel key partitioning in TC queue
    filtering

 Documentation/netlink/specs/tc.yaml           |  4 +
 Documentation/networking/tc-queue-filters.rst | 22 +++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |  7 ++
 .../ethernet/chelsio/cxgb4/cxgb4_tc_flower.c  | 11 +++
 .../net/ethernet/mellanox/mlx5/core/Makefile  |  6 +-
 .../mellanox/mlx5/core/en/tc/act/act.c        |  1 +
 .../mellanox/mlx5/core/en/tc/act/act.h        |  1 +
 .../mellanox/mlx5/core/en/tc/act/rx_queue.c   | 49 +++++++++++
 .../ethernet/mellanox/mlx5/core/en/tc_tun.c   | 88 +++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/en/tc_tun.h   | 14 +++
 .../mellanox/mlx5/core/en/tc_tun_geneve.c     | 46 ++++++++++
 .../mellanox/mlx5/core/en/tc_tun_gre.c        | 31 +++++++
 .../mellanox/mlx5/core/en/tc_tun_gtp.c        | 36 ++++++++
 .../mellanox/mlx5/core/en/tc_tun_vxlan.c      | 45 ++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 19 ++++
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  1 +
 .../ethernet/netronome/nfp/flower/offload.c   | 21 +++++
 include/uapi/linux/pkt_cls.h                  |  2 +
 net/sched/cls_flower.c                        |  5 +-
 .../selftests/net/forwarding/tc_flower.sh     | 57 ++++++++++++
 20 files changed, 462 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/rx_queue.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_gtp.c

-- 
2.43.0

