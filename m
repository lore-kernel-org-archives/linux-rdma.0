Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794488378;
	b=OlFVNJVOchyWyDYKP2F3q87XGktfiIPWDwlzsTLQT3GBdjBso0AUdrCNQkJIy5u0cOJp
	 qxtFf/uttGx/BdlSsQYDeB6zEOyyEeK9K4Jm8wP47l4s+leyl4VjPuJKD7+5Kex+ji5LM
	 TMffUMUvYyXQnBtttk+awwGYn9gBj1UF7v1giiKJZgjhyX7+T96lFXmUPgzqe+F0ZPNQr
	 E9dQs6I5shUk4Ca0oafrZuXEL3GbxnuUBt2RHGfrMxA6PWEG1paRYDCnI+B5LEEB9fnFe
	 UkYuVcQMl8R+ztTRDDY+RFkgPpSZXn3AzA9pM1Ymq57FyGXdaUcG4yMvcAHY/x8uLjw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794488378;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=YYtXLvrxEbuT7rkFCjPPi9h70g3nqJHQmoWRkPIIPOQ=;
	b=ZRTDbx9t1gHnNuZ1EjllUqgd8k3KoqDszi+ywkZv+ZVYNPIkUbfcPJsMNaKDa9l6DMnZ
	 lTEuCsuyWB355vtJ1w3W/naKmyA7LrYXcPNL29Bz+HIyDGeaVtVAMiW4pK3hjFG7UDSXi
	 DDzI62G0u8hiFBLyx2fduFX8gK/2pV9TeFxAkbi2ijgQr01wVBrr2J9gJaivxr36RMV6L
	 9KsZxpnp52M05v7YL783r5NvlQex574Bo+lZetInx/tjkAhjXSd3L3AWGr3+75kfgfStT
	 2yhM7Ow1xcAF2k+rUQRdykMPPs/BC55W6oiF5pH3GHkSzTvLUOMLNHBBqz19B8kWI/Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aX9vRkLW;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C632606A883;
	Thu, 12 Nov 2026 12:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aX9vRkLW
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794488378;
	b=IQAvl25YbbKAn36goSCGB+OzzxfXnLNPqv2HoMHQ+Xx2mu/TvgsawjgOZTiRHWkUHET5
	 YM26mA+8q7PTj3nAjvqm2cUt3ArFpk+qy1zrCHwU2mIhi3nOiRgywQFrTmPEh6/U8DtXQ
	 Epmr589nWSt/cuLwjT2oWAOl16ebKoOyqiS+oUmgTCrWBQBKO+U9JF6HH4Y6immY/3/gr
	 3HilHljxg/A0nT8bC0b6K6eq1AXbXFDmIx1rHo5zubDK3JBk0+a+qOV9B4G0B9044UX+7
	 pR+tHZNkLli/OmCws1wNYphRqY4XePr7I76j49GqF4cfcxY/XGNw7QzR/x8Z74H3sRw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794488378;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=YYtXLvrxEbuT7rkFCjPPi9h70g3nqJHQmoWRkPIIPOQ=;
	b=l4lAReXgV3Hjo/AuYhNRBugu/kjJ5LjgrQFmaRpqiCci0Hjfou9K3nL08PJx7UicPDGe
	 8G8v3HjUwG1tVYLlptqoeFBl1okT1r2OGA7uiP3uMSKN5e19ODWj64IAxHPepunp/U92y
	 2zh2+gL8yGnOGQTYS1JiXpRc9mR9tQxWLA/L7KqAevlXYSSQaUMPltMJHoVie1bq/OyI9
	 aHk7K8M2Wxoq03hmobSHhSYUanv/D0uasiAG0nqERK027gXG6zqjgeJnarA4B0qVKYP7i
	 1dPu0fsKfaeV893bdtb1eWdJHDHqCPW6Ave/ZwwkLn+LL+aL00UacV8gL6D7bSW6izg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id C710A1F00A09;
	Thu, 12 Nov 2026 12:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794488378;
	bh=YYtXLvrxEbuT7rkFCjPPi9h70g3nqJHQmoWRkPIIPOQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=aX9vRkLWsCIF1Eg5cau+WBqFt9vRiQ4Z9I42R8qw99z8xHkmkowd8Hb8j4/q1Vb/g
	 zV/asHV9bL2hoEPfA4O0OAo8xlFnQPa44OzwEM9/tltLF/SfdKWh8Fd7dMlfCTjEnI
	 Pw4QbV/hdr620R0cTE1EeJmBtR5GBRU8B2gdZ5bjD31kDU1BF0Z3kOiZunsDf4sdz+
	 Dx/gTNGjwLarHHn1V6RXdNLLmZ0ihPgn6Edh+KTlA+08tIX6sUoZdS2Sr4OJEkIDDw
	 B7rNUonmR/c38PqN6xmdFL0M95Pjw5o4RTJkrE6wdaT0UxWfP0yAZWE/3klWYPYj56
	 Mh78fQIj3KaNg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 52DB4494E8;
	Thu, 12 Nov 2026 12:59:36 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Thu, 12 Nov 2026 07:59:38 -0500
Subject: [PATCH net v9 4/6] net/smc: keep the source of an RDMA write
 inside the send buffer
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
Message-Id: <20261112-b4-disp-0287c16e-v9-4-e5e8fa688177@proton.me>
References: <20261112-b4-disp-0287c16e-v9-0-e5e8fa688177@proton.me>
In-Reply-To: <20261112-b4-disp-0287c16e-v9-0-e5e8fa688177@proton.me>
To: Mahanta Jambigi <mjambigi@linux.ibm.com>, 
 Dust Li <dust.li@linux.alibaba.com>, Eric Dumazet <edumazet@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, 
 Jakub Kicinski <kuba@kernel.org>, "D. Wythe" <alibuda@linux.alibaba.com>, 
 Sidraya Jayagond <sidraya@linux.ibm.com>
Cc: Ursula Braun <ubraun@linux.ibm.com>, 
 Wenjia Zhang <wenjia@linux.ibm.com>, Stefan Raspl <raspl@linux.ibm.com>, 
 linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Wen Gu <guwen@linux.alibaba.com>, Tony Lu <tonylu@linux.alibaba.com>, 
 Simon Horman <horms@kernel.org>, 
 Guangguan Wang <guangguan.wang@linux.alibaba.com>, 
 linux-rdma@vger.kernel.org, netdev@vger.kernel.org, 
 Hidayath Khan <hidayath@linux.ibm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794488375; l=4376;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=wu4Gw2/kDnZg8fMolb4by/QKqmZMOKGLAo8H2UVvtJ8=;
 b=12Br+F4Dc3L/KJCyeP6+Y8/f2CQZ0oZSym+OSUZST2fkSimiZd3tidIjGHm+yAxGpVUK4dPp9
 cFUt3hF31TwCSoiQs9GeS1e0wiQovradmUnd/DaQlCLiMnE/I2lPL1o
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=xw1AhCtQdvuoQc+bOQIYy9o8G++cp4/VniI2G/tc3G8=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/default with
 auth_id=893
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me
Content-Transfer-Encoding: 7bit

From: Bryam Vargas <hexlabsecurity@proton.me>

smcr_tx_rdma_writes() sizes the first source SGE of the second
destination chunk from the send cursor as it was before the first
chunk, so that SGE runs past the send buffer when the buffer ends
inside the second chunk. A physically contiguous send buffer goes out
under the local DMA lkey, which does not bound the SGE; on rxe the peer
is sent the memory that follows the buffer. A conforming peer gets there
when a completion handled inside smc_switch_cursor() leaves tx_curs_sent
behind local_tx_ctrl.prod. Otherwise it takes a peer_rmbe_space forged
larger than the RMBE and a send buffer larger than the RMBE.

Size the SGE from the running offset, as smcd_tx_rdma_writes() does. A
conforming write sends the same bytes.

Fixes: e6727f39004b ("smc: send data (through RDMA)")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261013-b4-disp-f345196c-v7-0-ef3dddfbfa68%40proton.me?part=4
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
New in v9. Sashiko's review of v7's 4/4 [1] pointed this bug out
("could this send adjacent kernel memory to the peer?"); the review,
and my reply to it, took it for unreachable by a conforming peer. The
first case below reaches it.

rxe, two links (v7.4-rc2 plus d7900fa51642, KASAN), send buffer and
peer RMBE 64K, physically contiguous, conforming peer. Every connection
carries one byte first; the counts include it. "With the patch" is the
whole series.
  - 60000 bytes sent and read, then 600 and 400 more, read too;
    failover, with the completion of the 600 handed to
    smc_cdc_tx_handler() between the first two cursor copies of
    smc_switch_cursor() (test hook) and the resend held; then
    send(9400). The switch leaves tx_curs_sent at 60400 and prod at
    61000, so the next write is the 600 bytes between them again plus
    the 9400, 4536 + 5464. Unpatched and v8 size the second chunk's
    first source SGE as 5136 bytes from offset 64936, 4536 past the send
    buffer. The peer reads the first 9400 bytes of that write; from byte
    5136 on (4536 + 600) they come from outside the send buffer. KASAN
    splat in rxe_mr_copy() on the unpatched run, where a freed slab
    object follows the buffer; none on v8's. With the patch no SGE ends
    past the buffer and the peer reads what is in it. It gets 600 bytes
    twice either way (see 6/6).
  - no failover, 60000 bytes sent and read, one send(20000): the write
    is 5536 + 14464 bytes and the send buffer ends with the first chunk.
    Unpatched builds 3 source SGEs, the patch 2; the peer reads the same
    20000 bytes.

With 5/6 and 6/6 applied and this change reverted, the first case and
the fourth case under 5/6 fail. Nothing else does: with the two cursors
in step, one RMBE per call already keeps the source inside (the second
case under 5/6).

A model of smcr_tx_rdma_writes() with the old and the new sizing, over
send buffers and RMBEs of 2 to 16 bytes: the new sizing gives 1344 of
12928 conforming writes a different SGE list, never a longer one, and
every write the same bytes.

Not tested on a real HCA, nor with a vmalloc'ed send buffer, where the
SGE goes out under the buffer's own MR.

[1] https://lore.kernel.org/all/179209532452.434549.6588379141939967966@kernel.org/
---
 net/smc/smc_tx.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index 3913ef103b35..d37c74754461 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -379,7 +379,6 @@ static int smcr_tx_rdma_writes(struct smc_connection *conn, size_t len,
 		sg_dma_address(conn->sndbuf_desc->sgt[link->link_idx].sgl);
 	u64 virt_addr = (uintptr_t)conn->sndbuf_desc->cpu_addr;
 	int src_len_sum = src_len, dst_len_sum = dst_len;
-	int sent_count = src_off;
 	int srcchunk, dstchunk;
 	int num_sges;
 	int rc;
@@ -425,8 +424,7 @@ static int smcr_tx_rdma_writes(struct smc_connection *conn, size_t len,
 		dst_off = 0; /* modulo offset in RMBE ring buffer */
 		dst_len = len - dst_len; /* remainder */
 		dst_len_sum += dst_len;
-		src_len = min_t(int, dst_len, conn->sndbuf_desc->len -
-				sent_count);
+		src_len = min_t(int, dst_len, conn->sndbuf_desc->len - src_off);
 		src_len_sum = src_len;
 	}
 	return 0;

-- 
2.56.0


