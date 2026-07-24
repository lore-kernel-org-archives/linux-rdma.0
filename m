Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C733C2D;
	Fri, 24 Jul 2026 00:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784852608; cv=none; b=RD8hdD0cZolSRvvpKkaPTrRXQinhNGYZi0yOj26p3UHtZgPP7zG6KyHE2rwTA5DU2ym7E/uxn+t5zm7itSJyoDIpu5i2nv7kup/DYYflFvdn+42kM3ws2uCClpU9zpLMUuXO46LPXyjq0u7Ncg9OvaCK/s9Q0xZ0fZo8egFpBh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784852608; c=relaxed/simple;
	bh=6DQ+WLyreifrh3k/itJHKkWkQG3/CNPMbYJqfqHMJKA=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=Jo0VlSFG3ujNq4eKyDDpk7VVH4n8zx1//SsfTvw54OSziGcbL35wuXadYh6aJWzPahJn8e2K6YPzax3j1wym/t8SxgdtsVjMiIdxavEzJutIWxIin1B8X000OwfaDB34v6eJnN8ozu0ZBw7I8e6xr9r2umzins1yc7EySK20YRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lr3ZAMyD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lr3ZAMyD"
Received: by smtp.kernel.org (Postfix) with ESMTPS id C087EC2BCB8;
	Fri, 24 Jul 2026 00:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784852607;
	bh=6DQ+WLyreifrh3k/itJHKkWkQG3/CNPMbYJqfqHMJKA=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=Lr3ZAMyDb+XEMYKavxAAiaEXYJ5Zg1oU3tupq+frG1ukKw8QrUIjSAloWqbMirDav
	 8eUka5p1qApkjHnd1NQDDMnF89lNI4BWLMNb+uYziWxi5YE1F+hpLilLAM0by8si8o
	 Nu16ZQWpdkdIdLkZC5/k+nMa8ihYv/5LJcEGhwqwLrWMiDZm1ipxGE39AmTV09iBQA
	 MBlmiwhI3sTwF8O8f7HWNWk6VzuiZKCNTnsqNT3rvasNuQsB5Qh1C05N/HVJO3jS3o
	 VMS8bKkE17RUYvtrilI3i0XuMPg3Lgz+EHoISBtktpm4tF9A887aMxeNrfD0XuaGqK
	 KSixtabIE1cPQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9943FC531F9;
	Fri, 24 Jul 2026 00:23:27 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Subject: [PATCH net v5 0/3] net/smc: bound wire-controlled CDC cursors
 against the local buffers
Date: Thu, 23 Jul 2026 19:23:26 -0500
Message-Id: <20260723-b4-disp-0d07164f-v5-0-6a9e235dbc4e@proton.me>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWMwQ6CMBAFf4W8s5ustYD6K8RDaRddD5V00ZgQ/
 t2qx5lkZoVJUTGcmxVFXmr6yBXaXYN4C/kqpKkyHLuOe3eg0VNSm4kT9/vOTxQCe/ZtjOl0RM3
 mIpO+f8sBWRZc/tKe413i8p1h2z5DwHcmeQAAAA==
X-Change-ID: 20260723-b4-disp-0d07164f-aa04045ccd98
To: Sidraya Jayagond <sidraya@linux.ibm.com>, 
 Jakub Kicinski <kuba@kernel.org>, "D. Wythe" <alibuda@linux.alibaba.com>, 
 "David S. Miller" <davem@davemloft.net>, Wen Gu <guwen@linux.alibaba.com>, 
 Wenjia Zhang <wenjia@linux.ibm.com>, Eric Dumazet <edumazet@google.com>, 
 Tony Lu <tonylu@linux.alibaba.com>, 
 Mahanta Jambigi <mjambigi@linux.ibm.com>, 
 Dust Li <dust.li@linux.alibaba.com>, Paolo Abeni <pabeni@redhat.com>
Cc: linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, 
 Ursula Braun <ubraun@linux.ibm.com>, netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Stefan Raspl <raspl@linux.ibm.com>, 
 Simon Horman <horms@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784852606; l=3932;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=6DQ+WLyreifrh3k/itJHKkWkQG3/CNPMbYJqfqHMJKA=;
 b=f3mdcsL7aYINvstnk9jm0XxUE2gd69LYSiajf8Rvx3f46s/+UXNSXrINU4bkkDzY6mNN/07l5
 5IdrV2ZwSjOBcYpZd4Gl/9VaWS9rXTnpt4jEoj7mfANZ4IDrgQdMAeR
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=xw1AhCtQdvuoQc+bOQIYy9o8G++cp4/VniI2G/tc3G8=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/default with
 auth_id=893
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

A peer's CDC producer/consumer cursors are copied from the wire and used,
without an upper bound against the local buffers, as (a) a raw index into the
RMB on the urgent path, (b) the receive length in smc_rx_recvmsg(), and (c) the
send length in smc_tx_sendmsg() on the SMC-D DMB-merge path. A malicious or
buggy peer can forge a cursor so each runs past the relevant buffer: an
out-of-bounds read of adjacent kernel memory (disclosed to the peer) on the
receive/urgent side, and, on the send side, an out-of-bounds write whose
length the peer controls and whose overflowing bytes are the local sender's
own outbound data.

This series bounds each length where it is consumed. The clamp is synchronous
and race-free against the tasklet that advances the cursor, so it is the minimal
fix for stable. A separate net-next series adds the wire-boundary validation and
connection abort that Dust Li suggested; those do not replace these clamps.

The clamp is not subsumed by validating cursors at the input boundary. A peer
that only increments prod.wrap with count == 0 hits the differing-wrap branch of
smc_curs_diff(), which returns (len - 0) + 0 == len every CDC, so bytes_to_rcv
(and sndbuf_space on the send side) accumulates past the buffer while every
per-cursor bound sees count == 0 and accepts the message. The overflow lives in
the accumulator, not the cursor; only the consumer-side clamp bounds it. And
because a queued abort runs asynchronously (queue_work -> smc_conn_kill) while
smc_rx_recvmsg() reads the accumulator under lock_sock, only the synchronous
clamp closes that window. So the clamp goes to stable; the abort is net-next.

The nearby readable >= rmb_desc->len / len > sndbuf_desc->len tests only feed
statistics counters (SMC_STAT_RMB_RX_FULL / SMC_STAT_RMB_TX_SIZE_SMALL) on an
earlier, separate read; they do not bound the copy.

A/B (in-kernel KASAN replaying the sink arithmetic over a real rmb_desc->len /
sndbuf_desc->len slab; kasan.fault=report kasan_multi_shot, 2026-07-05):
  - urgent index (1/3):  count = len+1        -> slab-out-of-bounds Read;  clamped -> clean
  - recv length  (2/3):  bytes_to_rcv = 5*len via wrap++/count=0 -> OOB Read; clamped -> clean
  - send length  (3/3):  sndbuf_space inflated -> slab-out-of-bounds Write; clamped -> clean
  - signed overflow:     readable = -1 -> v1 ">len" misses -> OOB; "<0 || >len" -> clean
  - concurrent TOCTOU race: a producer-side clamp is racy (OOB in a racing consumer
    kthread on another CPU); the consumer-side clamp is race-free (0 hits / 5,000,000 reads).
  - every in-bounds / honest-peer arm: clean.

Changes since v4:
  - repost only: the netdev patch queue overflowed, so this reposts the v4
    series unchanged, carrying Dust Li's Reviewed-by on all three patches.
  v4: https://lore.kernel.org/all/20260705-b4-disp-28a1bbca-v4-0-be089b98acc6@proton.me/

Changes since v3:
  - split into this stable-bound clamp series and a separate net-next
    validate/abort series, per Dust Li's review;
  - tightened the commit messages; noted that the nearby SMC_STAT_* tests are not
    bounds; no functional change to the three clamps.
  v3: https://lore.kernel.org/all/20260614-b4-disp-edd64be9-v3-0-551fa514257e@proton.me/

Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
Bryam Vargas (3):
      net/smc: bound the wire-controlled producer cursor to the RMB
      net/smc: bound the receive length to the RMB in smc_rx_recvmsg()
      net/smc: bound the send length to the send buffer in smc_tx_sendmsg()

 net/smc/smc_cdc.h | 27 ++++++++++++++++++++++++---
 net/smc/smc_rx.c  | 12 ++++++++++++
 net/smc/smc_tx.c  | 13 +++++++++++++
 3 files changed, 49 insertions(+), 3 deletions(-)
---
base-commit: 4539944e515183668109bdf4d0c3d7d228383d88
change-id: 20260723-b4-disp-0d07164f-aa04045ccd98

Best regards,
--  
Bryam Vargas <hexlabsecurity@proton.me>


