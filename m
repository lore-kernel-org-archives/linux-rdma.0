Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794683369;
	b=eMNFo9J1klZ0K1GmGI0Jz752MFGMOtlyt4eZG0QGn5KgEHslqCvBXWc0QAq1AHC2HPGy
	 U3KVzdqlr0x/P9ec6qVDkOhGXDIIK2nj8Qn5Pj3AC3P1YmGcAsJVZbD+p80MLC7vLXHGS
	 vmYk5/sMUo/I9KZdD7tbXj4ESj1+zHWpbLXmxJr57y7kS3rTFAxwznTbVTaX2zASJ/H03
	 hmShsMVJ0Ps/D08TMd4nSIEuiU30+bRInj3UxczsIAJw8yYBlDkbL/f40fOXB4EqHwTie
	 wYoZLSvNPpkvrXB6OK2mBy5BHLQAOgjDjN2PbR25Av1NkMQIxC7wVAr1+BOTOEy7XkQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794683369;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=atR/sBUvEX9u2OIbJcUD2tUMga9UZkt5JTKJTf67tmY=;
	b=GqESMnWo6HlSlOzhqGnD+ANF2Z/9FnFta1zNJLPhVQrQ8WH3VJ8zKNXAd4AgfZHu2Owj
	 ci5DFncU+nWULXoZKmh2j3Pu9kv43LfAVxPQK3PGoWb/DyAoJ8fAU3t6vgUPUWRzV6SJj
	 zjFbH6141Qo4AvqADlJj/0QwcjmJDYPC8ODdfmSVk8BAyytWtB7uI3u68HYdXUq6RHIpA
	 TATMu7Ygj7HfDpwSqOppw05aFaOaCcx6hNcQ+vI9hIUTx1TGkOrhqvE2Ur9IkaH4CMtpU
	 UfuYLWI1SqPvB4warBmg3NM//yK5ygqFh7vKfLB9V0Nb2FVrJlzDkoP2Vy7xjchauzQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f0pOCtuX;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EED5606A329;
	Sat, 14 Nov 2026 19:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f0pOCtuX
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794683369;
	b=lInKLXpQTh9PdhHet5NQpI+i/VstnXhzrGblHyR1czptOXMykqhOsbndzys6X/jA7I/g
	 XWgszxfA0HtJDYBEe7bYlznvV7AbB0V4YLdO27QfloVaryUKG6CY5ugh2qL5psSHFhLpL
	 9kAE2F8msLHoYaGGUurUpHlHOoXCVHI0mEmky1xoxnH30e9daratugK/N7HrgN72zM+rR
	 Ip+TY08LrsUy1I3+1XROS31XrO7mFiD4VQpAdjbB/tlNgOKtjT+oyNMDWp+fZeF7pWlol
	 a1iv0VOIk7K1XfJQYxA72Fzmrs6l+PXw90/nYggYtuGmADpgzDfIZ44jFdX62R3RphA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794683369;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=atR/sBUvEX9u2OIbJcUD2tUMga9UZkt5JTKJTf67tmY=;
	b=bRmO4r2LGAg3T1JLZwO7uI/9yHJe1aH3bXT+aJiELoIkgf4dZw6OrKV4KNqRG6/aRqsD
	 gUP0820Q6/Seg/e2XZpLEG+G2T76lPkMxaXIwRYB7yucA51B/LdCiC46xdvm/FkHYdLU7
	 fZr8M7r3eAf96A50h9TMu8PFNhLnww0v80A8GepPHMqlBIzzSlUV6OVAP3R8nbpMeetmM
	 o5kMUYaICk1I/MPuwYe/NLv46EZgA2VJscLfkc3hS/bmGqpXCa2OBa75rKt11uhh6wpCS
	 8Ytv+OjccAA1LFU8aa1WYIlg5EZe3SW6AAJh5O6ILLhoM41EGJFypjzpYx8U3w62gkw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id B40761F000C5;
	Sat, 14 Nov 2026 19:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794683369;
	bh=atR/sBUvEX9u2OIbJcUD2tUMga9UZkt5JTKJTf67tmY=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=f0pOCtuXMHHdJn0tbNl3tGY32xFNOwjTKVB6q9gSRmCe5yMl/4a5AjXd18qz1U3lH
	 nTJ0ZUs+7+qN66E/HmTCDRZSthFXeYiGSL46JuGhzcBbnU2rfaOxb7ESXiH9QxTvHI
	 4830s4Y7I+0o6LaBsTEXTpPN+pgsTcpUZb3kbnWY5iCqmZu5DAujsqEOH2SiHqBu5r
	 n9uGHtZwJJTTTrgtO/ocCakIXArG9srqII0MRy8iF/7sMNImU8QpBczh6L+/e59nZ1
	 RREKcbaRii6UtYlLX7DouJKtBWPpbsSsOb/dRXkOrmF7V1yGokAHARpZG70qIReR3e
	 GHTE3SHMMUmeA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 12CB249E6E;
	Sat, 14 Nov 2026 19:09:28 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Subject: [PATCH net v2 0/2] net/smc: do not reuse the DMB of a nocopy
 device
Date: Sat, 14 Nov 2026 14:09:27 -0500
Message-Id: <20261114-b4-disp-4e6374c2-v2-0-3b7050bddef7@proton.me>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWMwQrCMBAFf6Xs2YVmEyv4K+LBJq+6HmLJtkUI/
 XejHmdgppKhKIzOXaWCTU1fuYEcOoqPW76DNTUm6WVwzgUeAye1mQMGfwpR2KfeCxCTO07Usrl
 g0vdveaGMha5/aev4RFy+M9r3D6neCDV5AAAA
X-Change-ID: 20261114-b4-disp-4e6374c2-3d032eecd15f
To: Dust Li <dust.li@linux.alibaba.com>, 
 "David S. Miller" <davem@davemloft.net>, 
 Mahanta Jambigi <mjambigi@linux.ibm.com>, 
 Alexandra Winter <wintera@linux.ibm.com>, Paolo Abeni <pabeni@redhat.com>, 
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
 Sidraya Jayagond <sidraya@linux.ibm.com>, 
 "D. Wythe" <alibuda@linux.alibaba.com>
Cc: Hidayath Khan <hidayath@linux.ibm.com>, linux-kernel@vger.kernel.org, 
 linux-rdma@vger.kernel.org, netdev@vger.kernel.org, 
 Simon Horman <horms@kernel.org>, Tony Lu <tonylu@linux.alibaba.com>, 
 Wen Gu <guwen@linux.alibaba.com>, linux-s390@vger.kernel.org, 
 Wenjia Zhang <wenjia@linux.ibm.com>, Julian Ruess <julianr@linux.ibm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794683367; l=6465;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=509iPFA4GJ+RaeEwKENn31V4LNoHRq/QTNjToALIfUE=;
 b=YBB6grVOgMyZsyohLk4Gyya2y1a3wRWJEYNDUFk8WxENQW5lO0FoBpR5zJADnP5Q4VHjXSIYu
 kwlSau7kwMsCROYDIKlpzE/vEnJ9QyppVE+7fPBjzvhH78enbymuskE
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=xw1AhCtQdvuoQc+bOQIYy9o8G++cp4/VniI2G/tc3G8=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/default with
 auth_id=893
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

With DMB nocopy (the dibs loopback device) a peer writes into the other
end's RMB through its own attachment. smc_buf_unuse() puts that DMB back
in the link group's pool with its token still registered, IOW the old
peer can still send its CDCs to it. The next connection that takes the
DMB gets those CDCs, and a peer that attaches after the other end gave
up lands in another connection's DMB. 2/2 stops pooling DMBs on nocopy
devices. This is the reused-DMB case that the v6 cover of the CDC
receive ordering series [1] lists as not fixed; Sashiko flagged it on
v5 2/2 [2].

2/2 depends on 1/2, a dibs loopback fix: when the owner unregisters a
DMB that a peer still holds, its dmb_clientid_arr[] entry is never
reset, and rmmod smc then warns in dibs_unregister_client() and leaves
smc registered as a dibs client. On net that needs a link group freed
while a peer still holds one of its DMBs; with 2/2 alone, each of the 20
connections of the rmmod test below left an entry set.

Tested in an x86 KVM guest on a v7.4-rc2 KASAN kernel, with net/smc and
drivers/dibs from the base below built as modules, with and without the
series. The modules had test counters, and some tests set a test-only
knob (a hold, a shorter link group free delay, an injected failure or a
forced terminate), named below. Each test has a control that passes on
both, and each part of the series has a test that fails without it. No
KASAN report or WARN with the series.

- A DMB reused while the old peer is still attached, 8 rounds: 4 with
  the new server end held before its attach by a knob, 4 with no knob,
  the new client's connect() at SCHED_IDLE on a busy CPU instead. On net
  the old peer's CDCs reach the new connection every time: it reads EOF
  while its own client is open, and its send space goes past its buffer
  size. With the series it gets a new DMB and token and sees none of
  them, and with 1/2 the old peer's CDCs raise no interrupt.
- Late attach, after an earlier connection set up the link groups: the
  client held 8 s by a knob after the CLC accept, past the server's 6 s
  wait for the confirm. On net it attaches to a DMB another connection
  already took, and after close() it stays orphaned in PEERCLOSEWAIT1,
  keeping smc in use. With the series the attach fails with -EINVAL and
  the client falls back to TCP.
- rmmod smc after 20 sequential connections, the 600 s link group free
  delay cut to 3 s by a knob: with 2/2 alone it warns, with 118 entries
  still set after the other tests of the same boot; with the series it
  unloads clean, and smc loads and connects again. On net, after the
  same tests, rmmod smc fails with "Module smc is in use" (the orphan
  above). In a separate boot, with the same knob, net warns too when a
  link group is freed while a peer still holds one of its DMBs; 1/2
  alone fixes that.
- 2/2 without the conn->rmb_desc clear: KASAN slab-use-after-free in
  smc_ism_unset_conn() when the client retries the handshake on the same
  socket. It took two injected failures, the CLC confirm send of the
  first attempt and the RMB allocation of the second. Clean with the
  series.
- The same retry with the first attempt's link group terminated by a
  knob before that attempt is aborted: smc_conn_free() then skips
  smc_buf_unuse(), and with v1's 2/2 the pointer stays set. Five KASAN
  reports, the first again in smc_ism_unset_conn(), then a GPF in
  smc_conn_free(), and close() hangs. Clean with v2.
- A connection closed while its link group is being terminated (a knob
  terminates the link group and holds its terminate work before the
  kill loop): v2 unregisters its DMB when the connection is freed, v1
  when the link group is freed. rmmod smc is clean after both.
- 6000 connect/close cycles, more than the device's 5000 DMBs, with 120
  peers kept open and the same 3 s delay: one DMB per connection end, no
  fallback and no -ENOSPC.

Cost, one run of 2000 connect/echo/close cycles per RMB size on the same
KASAN kernel, so relative only: 3.6% fewer cycles/s with 64 KiB RMBs
(4251 to 4098), 2.9% fewer with 1 MiB (3328 to 3232); handshake median
107 to 113 us and 112 to 167 us; a 1 GiB stream with 64 KiB RMBs 4759 to
4750 MB/s. Each connection end now registers its own DMB instead of
taking a pooled one. Not measured: under memory pressure that allocation
can fail, and the connection then gets a smaller DMB or falls back to
TCP, as a first connection does today.

ISM pools its DMBs the same way and an old ISM peer also writes its CDCs
by token, so AFAICT the reuse applies there too. This series does not
change ISM, and I have not tested it.

With the series a loopback peer that is still attached is not told the
DMB is gone, as on net; its writes land in the old DMB, which nobody
reads and which is freed when that peer closes.

A client that retries the handshake on the same socket keeps
conn->rmb_desc and conn->sndbuf_desc from its first attempt; v6 2/3 of
[1] clears them. 2/2 clears the pointer to the DMB it frees, now also
when smc_conn_free() finds the link group off its list, so its own free
does not depend on that series. A connection that the termination
already killed keeps its DMB until the link group is freed, as on net;
by inspection that socket cannot start a new handshake.

Test patch and logs on request.

v2:
 - 2/2: also unregister the DMB and clear conn->rmb_desc when
   smc_conn_free() finds the link group off its list and skips
   smc_buf_unuse(); v1 left the pointer set there, which Sashiko
   found [3].
 - 1/2: unchanged.
v1: https://lore.kernel.org/all/20261113-b4-disp-19244662-v1-0-39b256b70ca7@proton.me/

[1] https://lore.kernel.org/all/20261112-b4-disp-1c8d3a53-v6-0-36a38ae35021@proton.me/
[2] https://lore.kernel.org/all/179241208501.3135.14193534440423847161@kernel.org/
[3] https://lore.kernel.org/all/sashiko-outbox-214598@kernel.org/

---
Bryam Vargas (2):
      dibs: loopback: reset the client id when the owner unregisters a DMB
      net/smc: do not reuse the DMB of a nocopy device

 drivers/dibs/dibs_loopback.c | 14 ++++++++------
 net/smc/smc_core.c           | 28 ++++++++++++++++++++++++++--
 2 files changed, 34 insertions(+), 8 deletions(-)
---
base-commit: ead6fa9a0ab194f02a2f36d634b193e9c5f9a1c6
change-id: 20261114-b4-disp-4e6374c2-3d032eecd15f

Best regards,
--  
Bryam Vargas <hexlabsecurity@proton.me>


