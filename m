Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794680869;
	b=Od2cJHxeaODYqy1XIewdZA9BTHiG5GaE3iB7Q4/opcr6I6s6Z6kI8ZILkAh5vn5mJRZj
	 f1tDG0vcASl7hGvf2kXRYjlQRMcpIGkCOnI3QnWye/2QhobEXJf1b11CaYjawSpWFT1GT
	 roHYlA7ZXJ4E+SD6FRsoPo7p8UXNmKFaQRwC4dq9vJz3r5G9xjW0maY7bQEsKeI7BDMop
	 JzOXrxI98a295qcXIggXNTOM2l5dK1GMSgTQK7jUFcoiGgie0gc6nbnqIsxjlvgwj588V
	 vEcRCENzxCejA9b2BwKj0gklCajE7MosmaPJMRKG2gC3TEUH+5nSGAlTs2dVxOwWuNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794680869;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=821hPZ3mSrVkDru9zjRsyXQ6m5zbLDq4PwmJzq0vjp8=;
	b=1vqO6BCjlcORJZxb4ZLuT5J49YVyxZd1nxJxD6dvYk5czco0ujXysOBzOizkFWExReQR
	 YcVHu0TbRDqYiJ7VQlruG454gIXi24ZICg8rNkyXt7USHrC1PcXfMhCMjbMEfFiOnTJ7h
	 SIMuX0OCAWmWveeZqkqO0trgTm/s8Vr7vSzLaxG+l0UNorWSO/ctTVsgqK0Ib4y6dG1/P
	 PxxgeubGtr/iVvuYxifNdtvQdnHAg47yLmy3ew0dAP3K5e3OLfNcuSO9QmmM83/f6jU3l
	 xrkvGNGotnfijwDCxwy6ZhPm83xQg+7hfP96av2UcpAQVYtVaYts3+P4AsorcY0YRmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bairaktaris.de;
	spf=pass smtp.mailfrom=bairaktaris.de;
	dkim=pass header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=ez3H+WVb;
	arc=none smtp.remote-ip=209.85.218.43
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F371B606A32E
	for <linux-rdma@vger.kernel.org>; Sat, 14 Nov 2026 18:27:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F371B606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=ez3H+WVb
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c50ac25cdd4so156467266b.1
        for <linux-rdma@vger.kernel.org>; Sat, 14 Nov 2026 10:27:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1794680867; x=1795285667; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=821hPZ3mSrVkDru9zjRsyXQ6m5zbLDq4PwmJzq0vjp8=;
        b=ez3H+WVb8N6kuW9DSLlXuva7AGxWZhqKOmf3bTmNJDi15V1K+XpPiqn6V3wnMJ+z3N
         DzTmTMxOpPKMtqA7m6sFzIVGrnsIAwRXMsGoD+ctZ1mUNaqCpcHfTX6ISVopadsOmS1Y
         dI4TZ5U0q0AmUZXHAhjAjKh+et3IsiEX+asKYbfP0RSUUyXOqZmBRTpM1SFqoJyZb+dD
         +g4scdis7G/SsRvmAROVwigJRQrXtsff6692FBvdeC1pmSKAA0CjlTVllh+LdX2AWD0l
         XgQrBIk9Rrt7/rxndra2MG1WboVkfpi3iiKakjiYIh/7/mv0nKFLH9qVf16/AhcHP5Of
         BcGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794680867; x=1795285667;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=821hPZ3mSrVkDru9zjRsyXQ6m5zbLDq4PwmJzq0vjp8=;
        b=OZrUg4SRtrh58XU+qzR3W6MpFoPQzk8V9CP3AAEIcEjhZ9pBTwLW3XNqVVb5oV6BEV
         25JKr4ZEKQxAsJs5y+RPtUGYccggqyjSNALTwkBbHRx6u6zB9tuXuF3y9FRuz/WEaOZh
         N7Gqyes29m3zEfCO1B4ksSdLHtEnJR2MMAPvgVnBgk85wu/D/J1kHDZH1eZfc/NCUVmg
         Qkg+R7MsaTMBagM3hWFvV8GyncGv3SH9XEE+Duv/S6WZdX2iRHWjuq1n+exs/1ksxgXq
         JrktjwhSj+Z8NgbUzAUJj71bwM1BlNp1pAoqxmjim1lKVPtnHZ8exgH9JBeu+U89mYP0
         rLhQ==
X-Forwarded-Encrypted: i=1; AL+hErET3j114rPMy8KKgNcWYKM3NN4A+G8nVS1o+tTzPjLYwUHokhnDF+DBPs1kjhWkEJpF/YQl4S4cfvfB@vger.kernel.org
X-Gm-Message-State: APuU4Z+h/DTLlO4nDE82Rk3ok9p1cM+rN7vlbBDeTsLI9PYeGKg7tCp/
	N1kxv38kSJzjdB6dtDSi7uNMh3vES2cdIeHEdzUFI88oBAp/X1TiG5P+t0YHOemeiA==
X-Gm-Gg: AYBFou3p/2/MWhQ/sAIJHAwS70gxP6PvmV1atmlWKEsdr/6IbYkk7OTsp7S78qMYpzX
	HIiy5N0SXecJNHgWxgpUKli6imz8lX0aqII+v/fo7nYDEEyjsNLzbTvHmYy2mFtmDpxUvPw586k
	1kVHgxkVwIjDzTxJVeIQD+RYTMfYLzBhG3TAH+FutK2CempUZxPprOpDqb3QRXN9fZZUHD6SZYA
	z3VFpmh9Efd8kL44AuxwS7LRAbovlWTz40JhsWewnnScKe4NA428lnzdZ2btesdLm0al/kRg7DN
	wXCe4/D9O7DQF0eVFP1oLjrhQf0LjmOi3J9ZZQAgH5WQu32IdKP3wfs7wyOxVK+pxQxvYzXDuJz
	s66wrC6s5klxh6n7sLH2CruykUR3sgR3PVydB4+NDktu8W/Qt5ZsoRLZTrMPsSZy04CiE0l0D0J
	q+CyUUX+NR19ChCy541GgMmBLZntNjlEYYA1+FfvXVXwqjprTCMCZN5xCQfmW5nZw/f4sAbU4KU
	Wcg4r9XNvrMa0PWwDXyJaJCTg4deKbmzvQBBaZnJiM6sZ/15+VtbyX4efqDMO6VXxhGGiAO3a1A
	okAi2OeaGWidPiYwm/50PwhdDBmxa4/a5EZOxj4t1ymh6KHf+TIKoUuXU1gt/trEjvwYgTqrlGT
	7Y/AiqYAyoOjFFB5OXJ2PXXvW3IpWN0Y/voQDfqL7JbiwAMiwirb26jZ5LQ2k0fB9HIQVox7h2T
	pVNhGQ8mcnzedyIADePbtYMV+DC7LRHSI4yCpSgDAuBUPPr0RrK5/fD/AuheaQsQ1i9a3bl/7rU
	ZR7EaG0iAz8aHwvlwWcxm5rjoSiy6aJ1agHHdXzrhAgM1aSwP/ehqcgYY2T6DswzrVuHRZ0yy/w
	xk8=
X-Received: by 2002:a17:907:86a6:b0:c4d:4be1:4197 with SMTP id a640c23a62f3a-c5096410ca0mr549445066b.41.1794680867320;
        Sat, 14 Nov 2026 10:27:47 -0800 (PST)
Received: from Desktop.fritz.box ([185.181.130.189])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b56df7sm245554366b.47.2026.11.14.10.27.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 10:27:46 -0800 (PST)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	andrew+netdev@lunn.ch,
	dsahern@kernel.org,
	idosch@nvidia.com,
	ncardwell@google.com,
	kuniyu@google.com,
	richardbgobert@gmail.com,
	willemb@google.com,
	ecree.xilinx@gmail.com,
	linux-net-drivers@amd.com,
	saeedm@nvidia.com,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	leon@kernel.org,
	linux-rdma@vger.kernel.org,
	alexei.starovoitov@gmail.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	john.fastabend@gmail.com,
	sdf@fomichev.me,
	martin.lau@linux.dev,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	song@kernel.org,
	yonghong.song@linux.dev,
	jolsa@kernel.org,
	emil@etsalapatis.com,
	ihor.solodrai@linux.dev,
	corbet@lwn.net,
	rdunlap@infradead.org,
	skhan@linuxfoundation.org,
	shuah@kernel.org,
	bpf@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net v2 0/2] net: keep the TCP fixed-ID flags on the header they describe
Date: Sat, 14 Nov 2026 19:27:43 +0100
Message-ID: <cover.1794139176.git.julius@bairaktaris.de>
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
suggested in review of v1. Patch 2 adds a selftest.

Tested in QEMU (KVM, KASAN and lockdep) with the selftest, 18 cases,
400 segments each:
- net (30c71476d842), 2 of 2 runs: 6 cases fail. Fixed inner IDs
  increment after IPIP over IPv4 and IPv6 and after the ESP tunnel (390
  of 400 segments carry an inner ID the sender did not use), the outer
  IDs repeat after GRE and VXLAN over IPv4 (10 distinct outer IDs for 400
  segments), and a VXLAN stream with fixed outer IDs keeps that state
  after decapsulation into IPIP (10 distinct outer IDs).
- this series, 2 of 2 runs: 18 of 18 pass, no KASAN or lockdep report.

With a tunnel inside a tunnel, such as GRE traffic that GRO merged and
that is routed into an IPIP tunnel without decapsulation, two flags still
describe three IPv4 headers: the new outermost header takes
SKB_GSO_TCP_FIXEDID_OUTER of the header below it, as it takes
SKB_GSO_TCP_FIXEDID on net. This series does not change that case; it
gets a separate fix.

Changes in v2:
- Keep SKB_GSO_TCP_FIXEDID on the innermost header and describe the
  outer header with SKB_GSO_TCP_FIXEDID_OUTER instead of moving the
  flag on encapsulation and decapsulation (Alexei). Encapsulation then
  needs no change, which also covers ESP tunnel mode with crypto
  offload, missed in v1 (Alexei, Sashiko), the Geneve GRO hint path,
  which sets skb->encapsulation again after iptunnel_pull_offloads()
  (Sashiko), and BPF encapsulation followed by an L3-only decapsulation
  (Sashiko). FOU, which pulls the offloads twice, clears the outer flag
  twice.
- Keep the encap_level reset in gre_gso_segment() and
  __skb_udp_tunnel_segment(): v1 undid commit 5197f3499c47 ("net: Reset
  encap_level to avoid resetting features on inner IP headers"), which
  with remote checksum offload masks NETIF_F_HW_CSUM out of the inner
  features on devices without it in hw_enc_features (Alexei, Sashiko).
- Drop the segment routing changes: the outer header there is IPv6
  (Alexei). This also drops the read of hdr->nexthdr after
  iptunnel_pull_offloads() in ipv6_srh_rcv() that Sashiko reported as a
  use-after-free; ipv6_srh_rcv() is unchanged.
- Convert mlx5 and sfc to the outer flag (Alexei).
- Selftest: add an ESP tunnel mode case offloaded to netdevsim; check
  the inner ID values, not only how many distinct IDs arrive; skip the
  decap cases when the IPIP device cannot be created; fail a case whose
  receiver reports no result; keep IPv6 link-local traffic off the
  tunnels, whose tx_packets decide the GRO skip; remove the temporary
  file on exit; sort the Makefile entry; wrap lines at 80 columns
  (Sashiko, NIPA).
- v1: https://lore.kernel.org/netdev/cover.1792857378.git.julius@bairaktaris.de/

I used Claude (Anthropic) to help write these patches.

Julius Bairaktaris (2):
  net: keep the TCP fixed-ID flags on the header they describe
  selftests: net: check TCP IP IDs across tunnels after GRO and GSO

 .../networking/segmentation-offloads.rst      |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   8 +-
 drivers/net/ethernet/sfc/ef100_tx.c           |  12 +-
 include/linux/netdevice.h                     |   2 +-
 include/linux/skbuff.h                        |   4 +-
 include/net/ip_tunnels.h                      |   1 +
 net/core/filter.c                             |   1 +
 net/ipv4/af_inet.c                            |   8 +-
 net/ipv4/tcp_offload.c                        |   6 +-
 tools/testing/selftests/net/.gitignore        |   1 +
 tools/testing/selftests/net/Makefile          |   2 +
 tools/testing/selftests/net/tcp_fixedid.c     | 411 ++++++++++++++++++
 tools/testing/selftests/net/tcp_fixedid.sh    | 400 +++++++++++++++++
 13 files changed, 836 insertions(+), 24 deletions(-)
 create mode 100644 tools/testing/selftests/net/tcp_fixedid.c
 create mode 100755 tools/testing/selftests/net/tcp_fixedid.sh


base-commit: 30c71476d842b094651bd7712f6c8ee8716147d0
-- 
2.53.0

