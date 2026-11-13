Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794578244;
	b=4Ib1YAtWmRsFdUkZEYzQ68krfBjBVUmpki53BUq24ajocZ3IHnf2eoAgonAB7CBj163S
	 r1l82kE7sAy72qi/mHu44jYe3IhWrmQZcRPO+gtAeLVT1GKurEQAuCHH9yFowTb7Pu47D
	 9SEnDuxZgVLv7KUEGRei/xfCr/utTAO0j2W80Pi5iyBf+Gkhlx0YnqJNgniTyejnU/Ab4
	 iFGhObRrRzWJLHi95x6zJccyRYvxLuGhQYpjx0IEwQ1EpnfHxDJ45NXRcGyqwKOrpSirz
	 2jnrQLv+XA5xct+0pLODDOkydgpU3qN7yVFLEf8nME6KQyl7HKkBoMUDA3MUd82AqYg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794578244;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=sE7mqs/KDE8Uwnq2Mb4f8v6Zyyrcp7KERH1UgfAGIV0=;
	b=0ByuepzTnvCwKLXUchiRL8LMfUeGu6bjGdUEYHYr1phApiNOUL9TvEqHYoZwBkrEK5/X
	 tlr0epFAoEU2BPIu6qY0CIfyr99eteIRrwIlwM8lC51ntuBcSYqGjPPqq49A/wojCebcH
	 UTJfPHbULg4NzXFDKs02RwHSBH8/CbOrw94aP4SGBrVqaShyIHdaUwRTPwvEREV6WMZNI
	 dnwbAU8Xx521cV8GVYDfk+wH9iKnokYryLR1IMuceYvhu4Vz/Y+OmiNImVW3mIS7a2mM5
	 n7sBVLDC8TgIwoqG8MAspOsuUxrwMMKCq1XF3igwrohK0ep5fO9A6p6/qqsJ4fua6cg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KzrMlSum;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C06C606E0CA;
	Fri, 13 Nov 2026 13:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KzrMlSum
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794578243;
	b=ZlwREJ3AH7l/2ffl2tUz9EXuXs8QZjw2aivh063jEsjKoMucDoPNhHVygR975GjtnySX
	 62BfyP3HshNU12IiOKuWt60nMeuLTE174mZ9CqhpVrP8GzY2NnbgvJWtROWU2CG8/rdHR
	 QicssNq7XcXaCjoSq8Or2loAJ594JGmj5EiwmPD8pUWAtf/OaaL9Cpb17/yY4lYVqUi56
	 fdMYdOEnSbgd64MhYC7vXGeqmYm1D2xOQe2jFLMWEwfNMuLS93LuMdxoGnMcoubqGRmOj
	 8B5UOGiKtlnf5/UNx6E7w3EjjpasizdBJgC1z5a+Twda1p8vNqrtzpH1golttEqgiZg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794578243;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=sE7mqs/KDE8Uwnq2Mb4f8v6Zyyrcp7KERH1UgfAGIV0=;
	b=hkmfaJlor1+C8WACROWZT508s4lxV3FvQRp9nnZlmixEn6rU5JZ3HDt8qNNRfNdSOR7E
	 e9uG0cxLWX7o0LFvaZp47F8bCGGKWq3Kn/kFXhJJCQfezm99218UhqdMzHlSDJJhIdNUQ
	 r6GVwLEFFenkj2u8VEmxIDOlOCmrfZMfOTMVCBwKy04ivlTRJQd+YvASEFVrqaXOUeEFN
	 6U0dy4MMok2qN8JHBe8vOHroxqD4GJco9PYjmm+3dtZjqxREKGwqCUcrLG3T83eQaKM8J
	 T+N077Mru5yXBLcQswKC4/ygf4cgsiP6bwyX3cdD1daoo2DV15izgEo4ywTV9fkkQRg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id BC1AD1F000CB;
	Fri, 13 Nov 2026 13:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794578243;
	bh=sE7mqs/KDE8Uwnq2Mb4f8v6Zyyrcp7KERH1UgfAGIV0=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=KzrMlSumEGV5njKTNUT6jC4aqUHrMyPWu2rJU4UaKgJuJZ0lJENj19vkDQOLcPM5Z
	 Zf3axbm3Mx9j7O4k4qMZ7IAiIeg5t3ecMK/fyJdhM53XfR35fr4CbeBABgBWjxhCfv
	 2S/j613gwt84/9FxO6LuBg7aMb6qpsCVtYhJC0C9nU+rgZNjC478TsmQJ5owhcegcR
	 6hrvssMVVDBMGo1jqmKDz9KCT8oF8KL23kBecaYPDkTQILmTnZQq95FK/21+z6v0h1
	 OSC+WGc61FpZ+gXZBOW8Y6HwRpzdzI+OImV9+iBCdhx+CxEKQXPPFJSIFc80BXuXNH
	 mQG9guhZUYECw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 1C6EA477DE;
	Fri, 13 Nov 2026 13:57:22 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Subject: [PATCH net 0/2] net/smc: do not reuse the DMB of a nocopy device
Date: Fri, 13 Nov 2026 08:57:21 -0500
Message-Id: <20261113-b4-disp-19244662-v1-0-39b256b70ca7@proton.me>
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
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWMQQrCQAwAv1JyNtDEZVG/Ih423ajxsJZNK0Lp3
 93a4wzMLOBaTR0u3QJVP+b2Lg3o0MHwTOWhaLkxcM+RiI4oAbP5iHTmEGJkFO0lqfCJc4aWjVX
 v9v0vr1B0gtsufZaXDtM2g3X9Abi+R215AAAA
X-Change-ID: 20261113-b4-disp-19244662-be0baeb282dd
To: Mahanta Jambigi <mjambigi@linux.ibm.com>, 
 "D. Wythe" <alibuda@linux.alibaba.com>, 
 "David S. Miller" <davem@davemloft.net>, 
 Dust Li <dust.li@linux.alibaba.com>, Jakub Kicinski <kuba@kernel.org>, 
 Sidraya Jayagond <sidraya@linux.ibm.com>, Paolo Abeni <pabeni@redhat.com>, 
 Eric Dumazet <edumazet@kernel.org>, 
 Alexandra Winter <wintera@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, Hidayath Khan <hidayath@linux.ibm.com>, 
 Julian Ruess <julianr@linux.ibm.com>, Wenjia Zhang <wenjia@linux.ibm.com>, 
 linux-rdma@vger.kernel.org, Wen Gu <guwen@linux.alibaba.com>, 
 Tony Lu <tonylu@linux.alibaba.com>, netdev@vger.kernel.org, 
 Simon Horman <horms@kernel.org>, linux-s390@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794578241; l=5181;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=mJVdcGLfztszxhyNOjAwsueiEShPyyPe7iHHHENpQwA=;
 b=HEIsvIA0Esm0+2ik8Qm601METcXhdCNXFt+KDbMwePfLctfiq14jGhxhys59AKO3tdCQhUj3A
 iZh9S1XCLOUAyz92DKyCacXny9TV//C+Zv7esTMortYvWYYlWU6W8g1
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

Tested in an x86 KVM guest on a v7.4-rc2 KASAN kernel, net/smc and
drivers/dibs of the base below as modules, with and without the series.
The modules had test counters, and some tests set a test-only knob (a
hold, a shorter link group free delay or an injected failure), named
below. Each test has a control that passes on both, and leaving out any
part of the series makes its test fail. No KASAN report or WARN with the
series.

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
  above). In a boot of its own, with the same knob, net warns too when a
  link group is freed while a peer still holds one of its DMBs; 1/2
  alone fixes that.
- 2/2 without the conn->rmb_desc clear: KASAN slab-use-after-free in
  smc_ism_unset_conn() when the client retries the handshake on the same
  socket. It took two injected failures, the CLC confirm send of the
  first attempt and the RMB allocation of the second. Clean with the
  series.
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
[1] clears them. 2/2 clears conn->rmb_desc itself and does not depend on
that series.

Test patch and logs on request.

[1] https://lore.kernel.org/all/20261112-b4-disp-1c8d3a53-v6-0-36a38ae35021@proton.me/
[2] https://lore.kernel.org/all/179241208501.3135.14193534440423847161@kernel.org/

---
Bryam Vargas (2):
      dibs: loopback: reset the client id when the owner unregisters a DMB
      net/smc: do not reuse the DMB of a nocopy device

 drivers/dibs/dibs_loopback.c | 14 ++++++++------
 net/smc/smc_core.c           | 25 +++++++++++++++++++++++--
 2 files changed, 31 insertions(+), 8 deletions(-)
---
base-commit: ead6fa9a0ab194f02a2f36d634b193e9c5f9a1c6
change-id: 20261113-b4-disp-19244662-be0baeb282dd

Best regards,
--  
Bryam Vargas <hexlabsecurity@proton.me>


