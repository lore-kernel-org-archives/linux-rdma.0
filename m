Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795383130;
	b=rg8ZXQW+HaEOCLATE10Ou/ZG4JEyXqbqKOnhPtqhq8VzZdW1fWs9u9RHdabBh+rY41zy
	 a+pxgv/VAFDhqiVw4QFuIUxERklM1qQdojw9q/4G9dXfw0yFin2cjyT7K5W2b7u8ve/13
	 WMibJqXc4ZEPufFjOhpLnmBulRR7nE6TWVAaDTGPTIn1lp5RpJp6JpvP7buJBzGo57G57
	 VavCg3uFHeoiuCn9C7zY4k5+PEWf6lie9a63iADGGkGHGrJtUm0nwmObDpSuIhJ26fRzk
	 1JrmlDjRX7Y4TWNK2W3oc/Fd2kkyiQZWPBiqcQ8+YkIfy9UBpm8cMAnxxaNd9k+xPbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795383130;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=5ngADj+Dh5rQr5EmyPFmHmtgjfqZYF+tSldkclN0tM8=;
	b=NsaNPSU4NNMEeGhcm70PIuwu+sWMIIGE+hurmTKeIrJzDhytAskQm3mh7h+mS6yQxEjO
	 eKWb2eGfFveY3ArsRhM0bD0aKoku5N1lQ8p5b+55d2RadSDQ8AqP66OtU+dnvmsJFCFqe
	 Co+REqPQnX2YO4vwCTUd8BFQUfLtLBcAgVhaeFsLZnr9JwlIHZmXSYItb+Lat1ZmGmdGO
	 cf20FToh/Ly9zH24RB1r7ApKD/S+ptzDg1LP7LZ8XgG62kEEHkIzOtlyfkyr/5RnM7lzg
	 kSBfaKmgVnIH2NuXok4F15IVGAhLqI8fmKFzAUflz8o8xvQZ1DWbe0DVp33fYKPTg/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=WFCGsnqK;
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36FC0606A31A;
	Sun, 22 Nov 2026 21:32:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36FC0606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=WFCGsnqK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1795383127; bh=L6nqJyk+s9p61NL+AMAx8/meVrYami8HOJhoF7gEVc8=;
	h=From:To:Cc:Subject:Date:From;
	b=WFCGsnqKkGKNmwq0KiFj8qqNGsNeXiKpiY4xFUBgxOgoAygUBtIy+lNXfFYAv7aPJ
	 VJ7oL6j0x+zs4r8jqn1dEBLjtCM9aQJH59TZvPSGnc8qR1gDs3VTp2gRqsswAXHWFB
	 t/yhFCdWXjW1fhIt7G2wNuEJm1uSPEIsgNYc/hrCZhSbopNGThteMqztKxaxc4w+uh
	 RgbMcPThCg41zd2qjX03UC2SkCJDfrBe0GyIAwP9d14dXLLqgI6qc8R6xLLf+dLdG8
	 top0tbLSn20fa58frF733oo222achegDO1tgk6PtGWdYhbC/K+rKG/UgCMBz8UfXsc
	 0W4FbTT1NiaXw==
Received: from lnxos-dev.home (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id D06F044C036D;
	Sun, 22 Nov 2026 22:32:06 +0100 (CET)
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
	oss-drivers@corigine.com,
	=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.net>,
	Vlad Buslov <vladbu@nvidia.com>,
	Roi Dayan <roid@nvidia.com>
Subject: [PATCH net-next v3 00/11] tc flower: tunnel key partitioning for RX queue steering
Date: Sun, 22 Nov 2026 22:31:48 +0100
Message-ID: <20261122213200.3207385-1-acassen@corp.free.fr>
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
Patch 8 adds queue mapping to mlx5e NIC flows. Patch 9 refuses the tunnel
keys that mlx5e used to ignore without a tunnel device. Patch 10 matches
enc_key_id there in NIC and eswitch flows. Patch 11 documents the result.

Without a tunnel device nothing decapsulates. enc_key_id reads the tunnel
header on the wire like on cxgb4 and hns3. On mlx5 the plain ip_proto and
dst_port keys select the match register. I can rework patch 10 on a
dedicated key if that looks cleaner.

Tested on ConnectX-7 with firmware 28.48.1000 in NIC mode. Also tested on
the uplink and VF representors in dmfs, smfs and hmfs. This includes
redirect to a VF. GTP-U needs flex parser profile 3 and GENEVE profile 0.
The bnxt, cxgb4 and nfp patches are build tested only. So is the min
inline check of patch 10, because ConnectX-7 needs no inlining. The
selftest passes under User-Mode Linux and skips on a kernel without the
mask.

Multiple AI tools were used to test this feature. They found the problems
fixed by patches 1 to 5.

The iproute2 support is posted separately.

v3:
- cxgb4: add the Reviewed-by from Potnuri.
- selftest: skip when tc or the kernel drops the mask.
- mlx5: new patch 9 refuses the tunnel keys that mlx5e used to ignore
  without a tunnel device. Patch 10 now only lets enc_key_id through.
- mlx5 outer key: refuse a VXLAN or GENEVE mask that leaves no VNI bit,
  like cxgb4. In v2 the firmware refused such a NIC flow and tc got
  EINVAL without a message.
The selftest and patch 9 changes follow the Sashiko review of v2 [4]. The
sashiko.dev review of v2 found the VNI mask one [5].

v2:
- cxgb4: also refuse a mask that leaves no VNI bit.
- cxgb4, nfp and mlx5: add Fixes tags.
- selftest: run the enc_key_id mask test in software only.
- mlx5 queue mapping: refuse it after any terminating action.
- mlx5 outer key: refuse other tunnel keys and representors that need
  inlining.
- docs: drop a wrong sentence about skip_sw and name the tunnel ports.
- nfp and selftest: wrap two lines over 80 columns.
The first six follow the Sashiko review of v1 [3].

v2: https://lore.kernel.org/netdev/20261117092915.255194-1-acassen@corp.free.fr/
v1: https://lore.kernel.org/netdev/20261109131039.959438-1-acassen@corp.free.fr/
[1] https://gtp-guard.org/articles/5g-upf-pump-up-the-volume/#benefits-of-range-partitioning
[2] https://github.com/acassen/research/tree/main/UPF-flow-steering
[3] https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261109131039.959438-1-acassen%40corp.free.fr
[4] https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261117092915.255194-1-acassen%40corp.free.fr
[5] https://lore.kernel.org/r/sashiko-outbox-220570@kernel.org/

Alexandre Cassen (11):
  bnxt_en: require an exact tunnel id in TC flows
  cxgb4: flower: refuse a tunnel key wider than the VNI
  nfp: flower: refuse a tunnel key wider than the VNI
  net/mlx5e: TC, refuse a tunnel key wider than the VNI
  net/mlx5e: TC, reject a partial tunnel key with tunnel mapping
  net/sched: cls_flower: add enc_key_id mask
  selftests: forwarding: tc_flower: test the enc_key_id mask
  net/mlx5e: TC, offload RX queue mapping in NIC flows
  net/mlx5e: TC, reject tunnel keys without a tunnel device
  net/mlx5e: TC, match the tunnel key without a tunnel device
  docs: networking: describe tunnel key partitioning in TC queue
    filtering

 Documentation/netlink/specs/tc.yaml           |  4 +
 Documentation/networking/tc-queue-filters.rst | 22 +++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |  7 ++
 .../ethernet/chelsio/cxgb4/cxgb4_tc_flower.c  | 15 +++
 .../net/ethernet/mellanox/mlx5/core/Makefile  |  6 +-
 .../mellanox/mlx5/core/en/tc/act/act.c        |  1 +
 .../mellanox/mlx5/core/en/tc/act/act.h        |  1 +
 .../mellanox/mlx5/core/en/tc/act/rx_queue.c   | 67 +++++++++++++
 .../ethernet/mellanox/mlx5/core/en/tc_tun.c   | 97 +++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/en/tc_tun.h   | 14 +++
 .../mellanox/mlx5/core/en/tc_tun_geneve.c     | 46 +++++++++
 .../mellanox/mlx5/core/en/tc_tun_gre.c        | 31 ++++++
 .../mellanox/mlx5/core/en/tc_tun_gtp.c        | 36 +++++++
 .../mellanox/mlx5/core/en/tc_tun_vxlan.c      | 45 +++++++++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 29 ++++++
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  1 +
 .../ethernet/netronome/nfp/flower/offload.c   | 22 +++++
 include/uapi/linux/pkt_cls.h                  |  2 +
 net/sched/cls_flower.c                        |  5 +-
 .../selftests/net/forwarding/tc_flower.sh     | 59 +++++++++++
 20 files changed, 506 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/rx_queue.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_gtp.c

-- 
2.43.0

