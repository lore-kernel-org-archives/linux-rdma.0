Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795285624;
	b=0U8eNeYYYetrH2XgVM+TG7q9G7lKz55ex6sb39wqg+VBp4K5Ir9ZM4otAh8RkgXCPmTQ
	 vFwlxUbGgDEo1BPfrue0m3ysoVQpcVHDV/SyjfPyydnj12BrmxgbobkjNbND0fQ+ZbfG4
	 +cP5hk+7KPHXPQ4ZVF2TPuIp+6/w/V0sh1HpFRQ98VeS+d8Qa2WOpiKL73Cp8cLH/ZNwo
	 1q2ObtW59sC7Z5d39jkxOBIPbDIlfe+9J8e49OtBbfhQoFf783tVyCKFl2yBBdQncSSbr
	 NMnmHFOIf2w6rma5pzoUZ86uvYfVxFnb4zjHeNc4tmOcfeQ6OLXMtPMM6vwvO405C4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795285624;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=qEswlKRu/m9QVt4dqb19fLYqCHJHVZ8xOxsIyuj9bq0=;
	b=BK/PvuT6hRYT6eXX2yVEZdZEaYIknSpWeUovQ7ltqIOgGHbInYo4j58q104DHO2wjCax
	 xr5pbtR8KOL1RdvjpnUo/LZuZOQxBQdewYJvgPhmvgPR10wStnP0/xtbwJxm8Qo4n94s8
	 adNaigeO/Aa6iaNwGsHQpYLOGLomRYO8Pw+9fLc/2us8zX6+9CHFTDByeN7HhDrtsRvU8
	 K1bhLBAJngbGqILB0W/De48l+Nnl7Ffe31XrK8oEwhnuq4BMb/wuOQ5BgmhgAuzwlMoVv
	 CRaQyRxENz8WuhjIaCcVb5sYwwpWXHXLhqH3zw46OpaTyRQp/LJpKvQ89hUmKSo3WFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bairaktaris.de;
	spf=pass smtp.mailfrom=bairaktaris.de;
	dkim=pass header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=v0fW51fZ;
	arc=none smtp.remote-ip=209.85.218.51
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B975606A320
	for <linux-rdma@vger.kernel.org>; Sat, 21 Nov 2026 18:27:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8B975606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=v0fW51fZ
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c4d2b741ed9so336099666b.2
        for <linux-rdma@vger.kernel.org>; Sat, 21 Nov 2026 10:27:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1795285623; x=1795890423; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=qEswlKRu/m9QVt4dqb19fLYqCHJHVZ8xOxsIyuj9bq0=;
        b=v0fW51fZZ/SGc8wHJ1cKhm3+RD6J9PkbqhNgq6XuNECUhMVQaUDAEVRtVAM3hnqkYJ
         dwkeN1rv9+eSxpwci0y9LeeLRNjt4h9W3Ing/DJR/ZARxdkuXDEpWNq/tIU86Q/7qmDS
         v5M1lWbsKBWBrvy9d9K7BZ1LYFAfQHp3NITaJXhNbbBSP59o22P8JeDvlrxH4T3D4NhD
         X47bQEoKh0aBvOqxWi61Y8SGR7mWHACC+tWZx8/zzmOLp3/rog4+vQGEbXlPRbd5YOwc
         bGPB0gWn3axLCM7ZK5M1W2YgU3P22g2tJ38ZjOeBKoefUg0zuQQ5L3hmp+JUqx5q/A0o
         ycXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795285623; x=1795890423;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qEswlKRu/m9QVt4dqb19fLYqCHJHVZ8xOxsIyuj9bq0=;
        b=EIcYqfit3V/T6+jogdtf7g1790V0a5OZ/7VBkONIJJNV7o4jgdZWK6PvCLBCOh1RPz
         Nsmn+cyCTC7Hi5PClBroFWWQjs+o/TnJuvric8iD/k+yfxXXyxt04lJEk2zPuVqTv1OL
         Tsk4tznkLCs7Y1KjLKX8f6DaSmk1CnlVUfNO2J7S72QMkXaaMxuwUpR0zxl733zdZjgl
         uehzdSWI4m34e+uDxpmcJUikx5+PMuo4EIkA6Nn12NO2k/sx2fvmlc6f+aKGK6AsSOec
         L6vUYfINRU+i6hJNMtdzckPt9typqF1IeBsSfqPHirhgKLlyqTheJ9uvXfnSToorss33
         I1Sw==
X-Forwarded-Encrypted: i=1; AL+hErE6gc8tpRt0cOnsemtzApdObvnEiL819p8tVyXqDX955GpQAOlkHnBNCVtkZEEZD2kpx4oZjclpDjHR@vger.kernel.org
X-Gm-Message-State: APuU4Z/+vyvqkmVO8ZjvAsZyCs42l+WOomPFcRBZ8mR0ryXlSmGoeYa7
	mwzxwRHFujSwu2o8Hb9zAv/Zkh3l7ulWtaWRkIpXlwYE6ovTwVF/ZyXs1HQjjHg/GQ==
X-Gm-Gg: AZFdTZcuG1i5B3MKSNVIMcH++SzORwlwSzWXkCL87isyLOV5BOOD+/A4mDSYpXJ+oIU
	7x/NbYQc6lbnTgISbItmGBLDNEapviS3DxKwjvSkX2MJNyPGyUBQRmFsGEdHTOgzYS/q239r/Dj
	o+OOcKgeDprq0yyEbqY2qDt1X5wDMrsXph+7qvTqq1zchmD9/rPjqBXbYKI8kyb0Lcp12YbbR1R
	PbmR2Om63hTG/YELOYaoEccCJGDF+Srj/cwMOKVuxA6ZvDhz+rmVyqPrQlbOQSPAa/Qqvl0pF9t
	eYUaIZqK+nQMp9zxCp4cF/5bg59Jtg5NuIELZGiAq9SsAnE8EE9x6WDvhZlUBZsgSm+a2Qql1GJ
	Ra4X3DzQ5hQhm4YIRgjCRACnx0opT6J0WlSg3ttN/ElU6dcuEVQZH/qu/m8oz9uNP714mlpqZgC
	EowDjO9OcTnhuXbFjynzdcRka8/wacqCCfFcF8l2QDZMeoYWU0NqhmKOXrij455zdj94rTIk0OA
	pHAHdTkMxalS48jlkhuM9R56ueWSYGZVO68eBzDevZLGUPxNni86gVNcVIdEIJkJMfMmS6ZcXoI
	yYrp26NRKFeCNho0PNzGnw0cxEMC/aEB/rvd1iPoD+62xE4FIiwbkDV2lWj14Wow2YxgY01NfLl
	VvkWs0g1mAR/Ou9/mpZkXf9o9FySJin43sTBGYOUybv9w2zLNo2rDc4BBR3YO6GBlj/R5ZXskj7
	WT1so5X0SW0pQ2Dc2ZiE9mmlIo2gn/y1mNJaubAosD5NleRRC3L+9lmt8XlUghlE0O5d8W0kFaR
	YCOP80a+1u5VS4xj9fYHIXBxPW6zYhrJK1+FyteAPt9KneUhuENT6mSBpUI46b97Utsl7Nn6v7Q
	5Sq5K9euAYVBjhnLRp7kN7rCZqNCMPNrRoUgK7dcRpQvl2FHD375bJY=
X-Received: by 2002:a17:906:da0e:b0:c41:731c:534 with SMTP id a640c23a62f3a-c513a8590b8mr434863966b.24.1795285622600;
        Sat, 21 Nov 2026 10:27:02 -0800 (PST)
Received: from Desktop.tail070c67.ts.net (p200300f2470dfa000000000000000a27.dip0.t-ipconnect.de. [2003:f2:470d:fa00::a27])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c513b001172sm224519166b.79.2026.11.21.10.27.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 10:27:01 -0800 (PST)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	willemb@google.com,
	horms@kernel.org,
	andrew+netdev@lunn.ch,
	dsahern@kernel.org,
	idosch@nvidia.com,
	ncardwell@google.com,
	kuniyu@google.com,
	steffen.klassert@secunet.com,
	herbert@gondor.apana.org.au,
	richardbgobert@gmail.com,
	ecree.xilinx@gmail.com,
	andy.moreton@amd.com,
	alex.austin@amd.com,
	linux-net-drivers@amd.com,
	saeedm@nvidia.com,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	leon@kernel.org,
	linux-rdma@vger.kernel.org,
	alexei.starovoitov@gmail.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	martin.lau@linux.dev,
	song@kernel.org,
	yonghong.song@linux.dev,
	jolsa@kernel.org,
	emil@etsalapatis.com,
	ihor.solodrai@linux.dev,
	john.fastabend@gmail.com,
	sdf@fomichev.me,
	izaiahsun@gmail.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	shuah@kernel.org,
	bpf@vger.kernel.org,
	ipsec@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net v3 0/2] net: keep the TCP fixed-ID flags on the header they describe
Date: Sat, 21 Nov 2026 19:26:58 +0100
Message-ID: <cover.1795284858.git.julius@bairaktaris.de>
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

GRO sets SKB_GSO_TCP_FIXEDID for a TCP packet whose IPv4 IDs do not
change. Since commit 3271f19bf7b9 ("net: gso: restore ids of outer ip
headers correctly") the flag describes the outermost header and
SKB_GSO_TCP_FIXEDID_INNER the inner one, so every path that adds or
removes a header would have to move the flags. None does, and a TCP
stream that GRO merged and that crosses a tunnel boundary is segmented
with the fixed-ID state of the wrong header.

Patch 1 lets SKB_GSO_TCP_FIXEDID describe the innermost header again and
replaces the inner flag with SKB_GSO_TCP_FIXEDID_OUTER, as Alexei
suggested in review of v1. A header added in front of a packet that is
already encapsulated clears the outer flag, and ESP transport and BEET
mode with crypto offload, which keep the IPv4 header, copy the inner flag
to the outer one. Two flags cannot describe the middle header of a packet
with three IPv4 headers: software segmentation uses SKB_GSO_TCP_FIXEDID
for it, as it used SKB_GSO_TCP_FIXEDID_INNER before. Patch 2 adds a
selftest.

The hosted Sashiko AI review of v2 2/3 of my "ipmr: forward GSO multicast
packets" series reported the issue [1], and the selftest in patch 2
reproduces it.

Tested in QEMU (KVM) with the selftest, 19 cases, 400 segments each:
- net (d5b89d55a322), 1 run: 6 cases fail. Fixed inner IDs increment
  after IPIP over IPv4 and IPv6 and after the ESP tunnel (390 of 400
  segments carry an inner ID the sender did not use), the outer IDs
  repeat after GRE and VXLAN over IPv4 (10 distinct outer IDs for 400
  segments), and a VXLAN stream with fixed outer IDs keeps that state
  after decapsulation into IPIP (10 distinct outer IDs).
- v2 of this series, 1 run: the ESP transport mode case fails (390 of 400
  segments carry an ID the sender did not use).
- this series, 3 of 3 runs: 19 of 19 pass.

Changes in v3:
- Patch 1: clear SKB_GSO_TCP_FIXEDID_OUTER in iptunnel_handle_offloads()
  and in the BPF LWT encapsulation, where a header goes in front of an
  encapsulated packet; the new outermost header kept the flag of the
  header below it (Sashiko).
- Patch 1: copy the inner flag to the outer one in xfrm_output() for ESP
  transport and BEET mode with crypto offload, which set
  skb->encapsulation without adding an IPv4 header; v2 gave that header
  incrementing IDs (Sashiko).
- Patch 1: name the paths that change the outer flag and the middle
  header that the flags cannot describe in skbuff.h,
  segmentation-offloads.rst and the commit message, and list
  SKB_GSO_TCP_FIXEDID_OUTER in the bpf_skb_adjust_room() decap flags of
  the uAPI header (Sashiko).
- Patch 1: wrap lines at 80 columns (NIPA).
- Patch 2: add an ESP transport mode case.
- Patch 2: skip a run in which GRO merged nothing before the outer IDs
  are checked, and check that ESP tunnel mode outer IDs increment within
  each packet (Sashiko).
- Patch 2: delete only the netdevsim devices the test created, also from
  the EXIT trap, and before the namespaces (Sashiko).
- Patch 2: make the receiver's -c optional, as documented (Sashiko).
- Patch 2: use slowwait and check_gen_prog from lib.sh, and create the
  netdevsim devices inside their namespace, as lib.sh does, with the
  new_device write checked (Sashiko).
- Patch 2: report a receiver that is not bound within 10 s as such.
- Patch 2: fix shellcheck SC2016 and wrap lines at 80 columns (NIPA).
- Rebased onto net d5b89d55a322.
- v2: https://lore.kernel.org/netdev/cover.1794139176.git.julius@bairaktaris.de/
- v1: https://lore.kernel.org/netdev/cover.1792857378.git.julius@bairaktaris.de/

[1] https://lore.kernel.org/netdev/179182559332.434549.18294510093742639467@kernel.org/

I used Claude (Anthropic) to help write these patches.

Julius Bairaktaris (2):
  net: keep the TCP fixed-ID flags on the header they describe
  selftests: net: check TCP IP IDs across tunnels after GRO and GSO

 .../networking/segmentation-offloads.rst      |   8 +-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   8 +-
 drivers/net/ethernet/sfc/ef100_tx.c           |  12 +-
 include/linux/netdevice.h                     |   2 +-
 include/linux/skbuff.h                        |  12 +-
 include/net/ip_tunnels.h                      |   1 +
 include/uapi/linux/bpf.h                      |  16 +-
 net/core/filter.c                             |   1 +
 net/core/lwt_bpf.c                            |   2 +
 net/ipv4/af_inet.c                            |   9 +-
 net/ipv4/ip_tunnel_core.c                     |   2 +
 net/ipv4/tcp_offload.c                        |   7 +-
 net/xfrm/xfrm_output.c                        |  10 +
 tools/include/uapi/linux/bpf.h                |  16 +-
 tools/testing/selftests/net/.gitignore        |   1 +
 tools/testing/selftests/net/Makefile          |   2 +
 tools/testing/selftests/net/tcp_fixedid.c     | 432 ++++++++++++++++++
 tools/testing/selftests/net/tcp_fixedid.sh    | 427 +++++++++++++++++
 18 files changed, 929 insertions(+), 39 deletions(-)
 create mode 100644 tools/testing/selftests/net/tcp_fixedid.c
 create mode 100755 tools/testing/selftests/net/tcp_fixedid.sh


base-commit: d5b89d55a322b632e2b465b392a4c1d9d338db9c
-- 
2.53.0

