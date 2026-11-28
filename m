Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=79.135.106.29
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795877356;
	b=UV6a1Fb7x9xjbQ5C4u1PInXzEI/h+u7hAjT49j9oi5UOwZi5ZZ5oTZW/V45AQ9uJsI9w
	 rMh/0/oF84XzeA2lVtyxskkSY5meAELvRGoERU7RYblzj8Dkwivge8UrNjr8L/RGUg/vs
	 rVyEo3q0MnVioVO7rKAQ+K5rjC8GpualL7RVpqHmmLZL8obil7uiztlPuVvq6JjIM4Xyq
	 BbLD9u+PNSTM9wtcD1/xxpy+52RoP1OS1wFPSFZx51gLzhS49QjuVSdAXyubex8nUV343
	 PjADrEOxyD9Xae9IkiBBg43qqiKO3sycu+D5rbAvBm1JLrYAKtk4jmSbwP8MMdb7mcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795877356;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=bcJkwnwD2eHviNobmwiyhhR2VF7+/5hzZp+UsX4gSRE=;
	b=F/vkCq3c55gLXVNT/RqAc3le5RSAvIsHgUqtYo0C3Sb+A+/ZGf759HX5xMgGspksJGQz
	 YtqcIvRQxB/bbJJQssHfLysOWg3aEqjfsmAOQJQqgjYD6h/gqsgHkX+wbprjJGB6E4AIL
	 hDkcMl3eP1v58RVuu1XD18ngP2QnWbK+92C7TTKtso+kMUA2J4tTe1//lxXzhFvp1Pl9T
	 GhjBm8VA1MTTQS4N2rf/kW9XWi7Be2/r7vbOo2ClgU+8ekAV4sSdaxif6FuYGRtj7a80R
	 NWEL39UyIn0VYJTlt7Vnun+ccImlIiNIg3IY7qyp8Vu8wgt0pMxhOq13Ee8b0j18V2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=proton.me;
	spf=pass smtp.mailfrom=proton.me;
	dkim=pass header.d=proton.me header.i=@proton.me header.a=rsa-sha256 header.s=protonmail2 header.b=X4MZKMiH;
	arc=none smtp.remote-ip=79.135.106.29
Received: from mail-10629.protonmail.ch (mail-10629.protonmail.ch [79.135.106.29])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83091606A31C;
	Sat, 28 Nov 2026 14:49:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 83091606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=proton.me header.i=@proton.me header.a=rsa-sha256 header.s=protonmail2 header.b=X4MZKMiH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail2; t=1795877352; x=1796136552;
	bh=bcJkwnwD2eHviNobmwiyhhR2VF7+/5hzZp+UsX4gSRE=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=X4MZKMiHO74VrtC9pQZGAkzS2DpXGKg+bYdcVUoCSTY/CNbnQgh/4OV/Y1Bf5SzEJ
	 NXUwNIJdYkyf3UKOH5vNvzPJox8N0ZnMcJ/++njMpjQXNnwxbOMUjFjoOS05asbF0p
	 3FA3RyeuaWsMjJ3TmVvUtcH0PNbqdi2UyCDs+GOHqV+iHGxLngWOJaE3SLiiw4DkFb
	 UMlz/D05uBMXapSpNxlQYBwwR69SViaws/qOuLD7bMuO6UqfwtjUf9WWXVIgs0c6gU
	 z6Nmd1RAWlpAM5scoGJu9gMRpnCN90xq/6wNfMjeKwc5JqUdalWmJ3BUyp91eO3bqO
	 41Y+Ijwu7mV5Q==
Date: Sat, 28 Nov 2026 14:49:04 +0000
To: netdev-bot+sashiko@kernel.org
From: Bryam Vargas <hexlabsecurity@proton.me>
Cc: Mahanta Jambigi <mjambigi@linux.ibm.com>, Dust Li <dust.li@linux.alibaba.com>, Eric Dumazet <edumazet@kernel.org>, Paolo Abeni <pabeni@redhat.com>, "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, "D . Wythe" <alibuda@linux.alibaba.com>, Sidraya Jayagond <sidraya@linux.ibm.com>, Ursula Braun <ubraun@linux.ibm.com>, Wenjia Zhang <wenjia@linux.ibm.com>, Stefan Raspl <raspl@linux.ibm.com>, linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, Wen Gu <guwen@linux.alibaba.com>, Tony Lu <tonylu@linux.alibaba.com>, Simon Horman <horms@kernel.org>, Guangguan Wang <guangguan.wang@linux.alibaba.com>, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, Hidayath Khan <hidayath@linux.ibm.com>
Subject: Re: [PATCH net v9 6/6] net/smc: bound the link failover cursor advance to the send buffer
Message-ID: <20261128144857.1385100-1-hexlabsecurity@proton.me>
In-Reply-To: <179483404089.3136.10183363109829653220@kernel.org>
References: <20261112-b4-disp-0287c16e-v9-6-e5e8fa688177@proton.me> <179483404089.3136.10183363109829653220@kernel.org>
Feedback-ID: 199661219:user:proton
X-Pm-Message-ID: 35dcd75ac56f8c34935b141a7ec3cbf7c7724025
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, 16 Nov 2026 13:00:40 +0000, netdev-bot+sashiko@kernel.org wrote:
> - [High] smc_switch_cursor() in net/smc/smc_core.c can now move
>   tx_curs_fin backwards, so the same send-buffer bytes get credited to...

Yes. It's the "v9 only" item in the note under 6/6. An old-link
completion is credited once more if it is handled before the validation
message's completion, and the first case under 4/6 ends 1200 bytes over
the buffer where unpatched and v8 end 600 over. local_tx_ctrl_fin is
set back the same way. It needs a completion handled inside
smc_switch_cursor(). 3/6 keeps send() inside the buffer; send() can
still overwrite unsent data (by inspection).

> - [High] smc_switch_cursor() and smc_cdc_tx_handler() share no lock, and
>   the patch's "set them, do not add" change does not close the race the..=
.

It doesn't. The switch is still not serialized: the first two of your
interleavings are hook runs in the v9 notes (the first case under 4/6,
the run under 6/6); the third holds by inspection. "Set them, do not
add" only keeps the switch itself from leaving the fin cursors ahead of
the two it advanced.

The lock order you suggest is 1/6 of the failover series, now at
v2 [1]. Measured there with the sndbuf full and a handler held at its
credit while the link goes down: unpatched ends with sndbuf_space 4096
over the buffer and the reader gets wrong data; with 1/6 of [1] the
switch waits and the stream is intact. No lockdep report with v2 on a
PROVE_LOCKING build. With 2/6 of [1] a completion credits nothing if
its send was posted before the switch. A completion between the
switch's first two cursor copies, your first interleaving, was not
run with 1/6 of [1].

3/6 and 4/6 of [1] rewrite the same block and replace 6/6. The bound
is the same, tx_curs_prep; 6/6's check of cons.count against the RMBE
size is not kept. v1 of [1] capped the catch-up at the pre-failover
tx_curs_sent, which an earlier failover rewinds; with two failovers,
that cut a conforming peer's catch-up to nothing. That is the review
comment on v1's 3/4 that Sidraya asked me to fix [3], and v2 fixes
it.

> - [Medium] The permanent commit message does not mention that the patch
>   adds a new route to double-crediting sndbuf_space.

Right. "Still credited more than once" reads as unchanged, and in that
ordering 6/6 credits the completion one more time than unpatched does.
Only the note and the cover say so.

> - [Medium] The new cap in smc_switch_cursor() can leave
>   local_tx_ctrl.prod behind the peer's local_rx_ctrl.cons.

For a forged cons, yes. With your numbers the catch-up stops at
tx_curs_prep, prod is left at (w, 7000), smc_write_space() returns
-1000 and nothing is written until cons has moved another 1001 bytes.
That is arithmetic, not a run; the forged case in the note under 6/6
(cons one wrap ahead at count 64) has the same shape, and there nothing
is written after the switch. Unpatched puts prod on cons by advancing
tx_curs_sent and tx_curs_fin 17384 bytes with 2000 prepared, which is
what 6/6 is there to stop. Later diff_cons credits start from -1000, so
the urg_tx_pend test in smc_cdc_msg_recv_action() doesn't match even
when the peer has read everything, and the "guarantee" comment on that
credit doesn't hold. All of it on the forging peer's own connection,
and only that peer moving cons, or another failover, changes it (by
inspection).

A conforming peer's cons is never past what was written to its RMBE,
and that is never past tx_curs_prep, which a failover doesn't rewind.
So the cap doesn't cut its catch-up as long as tx_curs_fin and
local_tx_ctrl_fin are in step (by inspection). The case you call
speculative is the one where they aren't: a handler inside this switch
or an earlier one, the race in your second point.

What does cut a conforming peer's catch-up, on unpatched and v9 alike,
is smc_curs_diff(): with the peer 24576 bytes past local_tx_ctrl_fin
and a 16 KiB RMBE, [1] measured a catch-up of 8192 on unpatched and
the connection stalled with no write space (v9 by inspection); with
4/6 of [1] the catch-up was 24576.

> Pre-existing issues:
> - [High] This problem wasn't introduced by this patch, but the patch
>   rewrites the very condition that depends on it.

smc_curs_comp() misorders the two cursors across the u16 wrap rollover,
in both directions; the review of v8 [2] had both. 6/6 caps what a
misordered catch-up adds and doesn't change smc_curs_comp(). 4/6 of [1]
orders the two cursors by their signed distance. Both directions are
measured there, after 1 GiB through a 16 KiB RMBE. With fin on wrap 0
and cons 12288 bytes behind it on wrap 65535, unpatched runs the
catch-up and sndbuf_space goes 20480 over; with 4/6 of [1] there is no
catch-up. Your direction with Y < X, fin at (65535, 12288) and cons at
(0, 2048): unpatched skips the catch-up, peer_rmbe_space is -10240 and
the connection stalls; with 4/6 of [1] the catch-up runs and all data
arrives. Y > X was not run; by inspection your steps hold as far as
the peer taking the producer cursor from wrap 0 back to 65535, and I
haven't followed its side further.

[1] https://lore.kernel.org/all/20261128-b4-disp-360e65c5-v2-0-d9c05004d430=
@proton.me/
[2] https://lore.kernel.org/all/179364387382.3131.13471253186660322977@kern=
el.org/
[3] https://lore.kernel.org/all/366063ac0493ac4f48df9947b98d6613@linux.ibm.=
com/

Thanks,
Bryam

pw-bot: cr

