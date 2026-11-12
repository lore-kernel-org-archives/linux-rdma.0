Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794488378;
	b=UZX82h7AIPLA0m7HoiLFe0fSBNwsvnlHeK0IFmw6YsJs5U0a0kJgpq0Mg0NWlk8Cyoj7
	 wkMlaePDYoYIYsLal1rmSYapMMxwqWc+O0SpRtOiPZdNYGEVL0yOvPObte/hNl/pj4LO7
	 XSJp3/PJ0rYvkyYqR+obHwGcnyuvLg3OgawiNimv9E+k9GTd3P3iPZY165xu5kbfmAZ55
	 BdSVQt5h3F9D5qKSQO4EGNCXXU1bZxYjZZWXh/I3BUnwAHuqtqM/Gnyq+zjgI7A4V33R6
	 AydfNSxqdAm7lcqS5uQpfunISqkXfAbwbu4CI2e5KJQvcofFJiDeb24tJv2f/B2fvHA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794488378;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=7q+H4jjG/SnPge8Pd9y4oUGYFqvp50HbTGMvp1CBhwE=;
	b=Emb+k7wOhEd8uHDdFuYkg7qJgMuvyNUYxxg3lP5GXFvl8q1J8jJp2AwiKTlNg/qGF6Z2
	 GO1TKQqyu2x43FPRUmhNDUmTgZic9G3MmEd2wRBSN4YaI5RxXT18o1e+LkazHrt9DvCYn
	 85ggAdc5Us4T3MPPHNJDQ7Vlh/NDHYXfKoMED2OVThvxOBrNVeJDPMCE9y7inKyWfVKyU
	 aqfExzJlyHyjeRpDgRjEB5RIJE9wsw78/nR6YMYXynnuju1wqxcr95Eknyjc0sHL+Ll1J
	 jMAPuZV/mpLWNCYTMz7It3juw0KRnsVcTn1YXqNppqTx1dZhIgiwKpGOFEBmCge7khg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FTj34m0z;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17FDA606A323;
	Thu, 12 Nov 2026 12:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FTj34m0z
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794488377;
	b=20EYv8FoQXOoR9R5+eH8qaxA7uN2gWHrNMbDn8ELwJzj+rl+VtcROlPYMCIoLA8Xjgri
	 CaXi5GdXft0+rsVb/zcbHhkSyaUBzt+wnEoi1QP4ILSWbVtGGncw+Nxs9Yh7FOWGOBM/M
	 7rxU7NDLUkQ0D6JMkm//VO3WudByquOFGhy+gdEscn03fU9UuECe1orDHIxzSWYAcFW/a
	 JlVlCv1l23Y9VZfV+XRI+M/fyfGIAOZnMvlQGoPDUNxWt4QwPmNihngP9JKejMJxSiFs6
	 uhSs2LqlAlvE9Wm+2+jBzutuDVy3CfY/U2Q9F2edNDzRV+EWQLwClFkBvS8HLodrFmQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794488377;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=7q+H4jjG/SnPge8Pd9y4oUGYFqvp50HbTGMvp1CBhwE=;
	b=lpZWSJqd2amY+gKi2KSybRvEp5s2hhdMruBiCuR/8C/fBVH3IebP1tnm156Eg6L4tZ4P
	 nmWTcLyWzxmiGYGJxBGftsizuSieDgjNc9aBgwOENzs4tjMqn10QFnWQYRQ49LNMWe0b8
	 iMZt/h6Ij5q8b1WQG9kVfSZIbOJpRtyaNn9ScKPTliM/cKGzo2KgiJT1VDNjc/sLo3aIa
	 F9P/iiLi+PdGcxNMXe4p1UKNNpJK96o8CyRCoiCE3kNMrZWWtJzUJS2Z6mwHxv1K6irSa
	 zfP8ua4UGQcQLn5CpFjVjE2B9RbNOQcvKHEgkt24r1RwNmxCYMggmIbJqBIgOWI2JfA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id A10951F00A05;
	Thu, 12 Nov 2026 12:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794488377;
	bh=7q+H4jjG/SnPge8Pd9y4oUGYFqvp50HbTGMvp1CBhwE=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=FTj34m0zeRI2xOSxGL+McG0fdIGYk+cZL0QVwJ+hWRAlGH02DyH1ifn/As4giVT6n
	 qxQuA1zEVf4elZeGqn4jKJms61oW9RvjoGfeTMBQYfjohm7lzKvec84WezPNR43i5T
	 3VJZfKcHIuYV/U37jNRPMwei82i4Dvu+TxtB3qgg5u3F7m7wYB136xvxJaPmS81CAj
	 thJcvbj3YCKYszd+u43xUNvv9CSh9DeZkjKKVjnDtTKEBJtYCvq1ekAjb6oTmkHnh3
	 h/F0MfN15Z3fFna8MHLsEO2rWwefihROxKGbM/fjhMPB413HlAOQZ+00MzLMf2lDV1
	 UcqTlCqxhsukQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id F1FF8494DC;
	Thu, 12 Nov 2026 12:59:35 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Subject: [PATCH net v9 0/6] net/smc: bound wire-controlled CDC cursors
 against the local buffers
Date: Thu, 12 Nov 2026 07:59:34 -0500
Message-Id: <20261112-b4-disp-0287c16e-v9-0-e5e8fa688177@proton.me>
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
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWMwQrCMBAFf6Xs2YVskNb4K+LBJK+6HmLJtiKU/
 rvRHmdgZiVDVRidu5Uq3mr6Kg3CoaP0uJU7WHNj8s73IuI5HjmrTez8aUjSg2Ny4occMgKoZVP
 FqJ//8kIFM113aUt8Is2/GW3bF+8hVMN5AAAA
X-Change-ID: 20261112-b4-disp-0287c16e-bc0127d9de9e
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794488375; l=11712;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=z++ZMghTeaKO0JLJIgpjFgPH3h5+RjbCWk+r52e9oYA=;
 b=rWrpr1e4QgDouKFtuggjwhlwjZN+uDIWx7eDu9Fipm7eMrQwjzKF0t6SGe6vdfX4OO80MHBYQ
 /RVKijKliM7B8PazM7yhIidJrx0SuxNvjlgJOTPGSE92o7vUJGWJ0Li
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=xw1AhCtQdvuoQc+bOQIYy9o8G++cp4/VniI2G/tc3G8=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/default with
 auth_id=893
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

A peer's CDC cursors come off the wire and are used, with no bound
against the buffers they address, as a raw index into the RMB on the
urgent path (1/6), as the rx length (2/6), as the tx write space (3/6),
as the length and the destination of an RDMA write (5/6), and as the
cursor advance at SMC-R link failover (6/6). Any peer that completes the
SMC handshake controls them. With a forged cursor these run past the
buffer: an OOB read of kernel memory returned to the reader, send() data
written past the send buffer, an RDMA write that ends past the peer's
RMBE (its HCA refuses it and the link goes down) or whose source runs
past the send buffer. 4/6 fixes a bug in the existing code, how
smcr_tx_rdma_writes() sizes the source of a write's second chunk; it
sits before 5/6 because 5/6 turns writes that were one chunk into two.

Four cases need no forged cursor: a MSG_PEEK|MSG_WAITALL reader racing
another recv() (2/6), late completions on the old link after a
failover (3/6), a peer that reads across the end of its RMBE while
unconfirmed data waits for the resend after a failover (5/6), and a
completion handled while the failover switches the connection, after
which the next RDMA write can send the peer the memory that follows the
send buffer (4/6; it does on rxe). With a second link in the group the
peer can force the failover: a DELETE LINK request, or failing one of
our RDMA writes.

Bounding each cursor on arrival is not enough. A peer that only bumps
prod.wrap with count 0 makes smc_curs_diff() return the full buffer
length on every CDC, so bytes_to_rcv grows past the RMB while every
cursor looks in range. IOW the overflow is in the accumulator, not the
cursor. 1/6 can clamp on arrival because the urgent path indexes with
the count itself; 2/6, 3/6, 5/6 and 6/6 bound the value where it is
used. The series does not depend on Hidayath Khan's "net/smc: abort the
connection when the peer overruns the RMB" [1] (net-next).

Not fixed here: the failover switch is not serialized against
smc_cdc_tx_handler() (send_lock on one side, the socket spinlock on the
other), so a completion can be handled inside smc_switch_cursor(). It is
then credited to sndbuf_space more than once: 3/6 keeps send() inside
the buffer, but send() can then overwrite data the peer has not
received (by inspection). One handled between the switch's first two
cursor copies makes the next write hand the peer bytes it has already
read. Unpatched does both. v9 ends worse than unpatched in two cases,
both with a completion handled inside the switch (figures from the runs
in the notes under 5/6 and 6/6):
  - one between the first two copies, and the peer has read across the
    end of its RMBE before the resend: unpatched has the write refused
    and loses the connection; with 5/6 the write goes out and the
    connection lives on, the peer gets 600 bytes twice and sndbuf_space
    ends at 3x the buffer (fourth case under 5/6).
  - one that has moved tx_curs_fin ahead: 6/6 sets it back to the
    advanced tx_curs_sent, so an old-link completion handled before the
    validation message's is credited once more, and the first case under
    4/6 ends 1200 bytes over the buffer where unpatched and v8 end 600
    over.

Serializing the switch means taking the socket spinlock around
send_lock in smc_switch_conns(); this series does not change the
locking. smc_curs_comp() is not changed either: it misorders two cursors
across the u16 wrap rollover [2], and 6/6 only caps what the advance
then adds (by inspection).

For stable: 4/6, 5/6 and 6/6 go together. With 6/6 and not 5/6, after
a failover with a consumer count past the peer's RMBE the next write
can end past that RMBE, where unpatched stalls; with 5/6 and not 4/6
the peer can be sent the memory that follows the send buffer, where
unpatched has the write refused. 1/6 and 2/6 are both needed: 1/6
alone bounds the count, not what wrap bumps add to bytes_to_rcv.

Found by inspection of the cursor handling in net/smc; the cases below
were then confirmed on a KASAN rig, except where marked by inspection.

Testing: KASAN, v7.4-rc2 plus d7900fa51642 ("net/smc: fix lgr/lnk
lifetime vs diag reader race"), where net/smc is identical to the base
commit's; unpatched, v8 and v9. The test lists of v7 and v8 are in the
v8 cover (link below): unpatched reads and writes past the buffers, the
series stays inside, conforming traffic is unchanged. Their SMC-D
cases, rerun on loopback, give the same results, v9 as v8 in every one.
Over SMC-R on rxe with two links, v7's two failover cases stay inside
their buffers on v9, no KASAN splat. The SMC-R cases run for v9, with
test hooks making the timing deterministic (inputs and figures in the
notes under 4/6, 5/6 and 6/6):
  - a completion handled inside smc_switch_cursor(): unpatched and v8
    leave local_tx_ctrl_fin at count 16713 for a 16384-byte RMBE and
    tx_curs_fin past tx_curs_prep; v9 leaves tx_curs_fin on tx_curs_prep
    and local_tx_ctrl_fin on the producer cursor (6/6).
  - consumer cursor forged one wrap ahead at count 3 * RMBE, which adds
    four RMBEs to the window: unpatched and v8 post 40000 bytes in one
    chunk for a 16384-byte RMBE, rxe refuses the write and the link goes
    down; v9 posts one RMBE in two chunks and both links stay up (5/6).
  - consumer count forged a million bytes ahead with the wrap unchanged,
    send buffer larger than the RMBE: unpatched and v8 post a second
    chunk longer than the RMBE, with a source SGE that ends 4464 bytes
    past the send buffer; v9 posts one RMBE with every SGE inside (5/6;
    either of 4/6 and 5/6 keeps this source inside).
  - conforming peer, a completion handled between the switch's first two
    cursor copies, which leaves tx_curs_sent 600 bytes behind the
    producer cursor: unpatched and v8 build a source SGE that ends 4536
    bytes past the send buffer and the peer reads bytes from outside it
    (KASAN splat on the unpatched run); v9 builds none (4/6). The peer
    reads 600 bytes twice on all three.
  - same race, the peer reading across the end of its RMBE before the
    resend: unpatched and v8 have the write refused and lose the
    connection. With 5/6 and not 4/6 the source of the second chunk ends
    1464 bytes past the send buffer and the peer reads bytes from
    outside it. v9 keeps source and destination inside and the link up,
    and the peer gets 600 bytes twice.
  - conforming peer, completions lost with the failing link, the resend
    held until the peer has read the data: unpatched and v8 post 11000
    bytes in one chunk that ends past the 16384-byte RMBE, the surviving
    link goes down and the peer's read fails; v9 posts two chunks and
    the peer reads the stream intact (5/6).
  - the two forged-cursor cases of the note under v8's 4/4. Cursor one
    wrap ahead at count 64: v9 as that note reports for v8, nothing is
    written after the switch (v8 and unpatched not rerun). Count at RMBE
    + 4096: unpatched stalls with 3137 bytes still queued, v8 posts
    16384 bytes from offset 1 and the link goes down, v9 posts 16383 + 1
    and the link stays up.
  - conforming traffic on v9: 600001 bytes across a failover in 39
    writes, 18 of them in two chunks, each chunked as the code that 5/6
    replaces would chunk it (compared in the kernel, write by write).

Reverting any one code change of 4/6 or 5/6, or v9's change to 6/6,
makes its case fail. smc_cdc.o built from v9 is byte-identical to v8's
on the same tree: v9 changes only a comment in smc_cdc.c. Not covered:
SMC-R ran on rxe only, with physically contiguous buffers (no real HCA,
no vmalloc'ed send buffer); SMC-D ran on loopback only, where
smcd_tx_rdma_writes() returns before it writes, so the ISM write that
5/6 sizes has not been run. Logs on request.

Changes in v9:
  - 4/6 is new, for the bug in the existing code that the review of
    v7's 4/4 [3] pointed out: the source of the second chunk is sized
    from the send cursor as it was before the first. The review, and my
    reply to it, took it for unreachable by a conforming peer; the race
    above reaches it.
  - 5/6 is new, for the first point of Sashiko's review of v8's 4/4
    [2]: with a consumer count past the peer's RMBE, v8 skipped the
    advance but peer_rmbe_space was still sized from that cursor, and
    the next write ended past the peer's RMBE where unpatched only
    stalls. 5/6 bounds the write where its length and destination are
    computed, which also covers a conforming peer after a failover and
    a forged window with no failover. [3] had already pointed out the
    one-chunk write and the window larger than the RMBE, both in the
    unpatched code, hence the Reported-by and Closes tags on 5/6.
  - 6/6 (was v8 4/4): tx_curs_fin and local_tx_ctrl_fin are set from
    the advanced cursors instead of being added to, for the second
    point of [2]. Without a completion inside the switch the result is
    the same as v8's. The switch is still not serialized (see above).
  - 5/6 and 6/6: the Cc: stable lines point at the descriptions, which
    name the patches each one needs.
  - 2/6: conn->rmb_len is accessed with READ_ONCE()/WRITE_ONCE(); the
    wait predicates read it without the socket lock [4]. The message
    and the comment in smc_rx_pipe_buf_release() now claim the
    splice_pending change only for a reader that ran between the cursor
    update and the drop; the double count that [4] describes, a splice
    whose second chunk fails, is a different bug and is not fixed here.
  - 3/6: code unchanged. Of the three comments in smc_cdc.c that claim
    0 <= sndbuf_space <= len [5], the one in smc_cdc_tx_handler()
    points at the clamp now. The other two stay: the claim holds in
    smcd_cdc_msg_send(), and the DMB-merge block only exists since
    v6.10, so a hunk there would not apply to 6.6.y and older. The
    message now says that the over-credit itself stays. R-b kept.
  - 1/6: unchanged.
  - Rebased on net (8d5ce4751fad).

v8, with the earlier changelogs and test lists:
  https://lore.kernel.org/all/20261029-b4-disp-33001ace-v8-0-f9bb96e17827@proton.me/

[1] https://lore.kernel.org/all/20260804141109.542202-1-hidayath@linux.ibm.com/
[2] https://lore.kernel.org/all/179364387382.3131.13471253186660322977@kernel.org/
[3] https://lore.kernel.org/all/179209532452.434549.6588379141939967966@kernel.org/
[4] https://lore.kernel.org/all/179364387064.3131.5492897013975868107@kernel.org/
[5] https://lore.kernel.org/all/179364387223.3131.12837391370219531719@kernel.org/

---
Bryam Vargas (6):
      net/smc: bound the wire-controlled producer cursor to the RMB
      net/smc: bound the receive length to the RMB
      net/smc: bound the send length to the send buffer in smc_tx_sendmsg()
      net/smc: keep the source of an RDMA write inside the send buffer
      net/smc: keep an RDMA write inside the peer's RMBE
      net/smc: bound the link failover cursor advance to the send buffer

 net/smc/af_smc.c   |  6 +++---
 net/smc/smc.h      |  3 +++
 net/smc/smc_cdc.c  |  4 ++--
 net/smc/smc_cdc.h  | 17 ++++++++++++++---
 net/smc/smc_core.c | 27 +++++++++++++++++----------
 net/smc/smc_rx.c   |  9 +++++++--
 net/smc/smc_rx.h   | 12 +++++++++++-
 net/smc/smc_tx.c   | 46 ++++++++++++++++++++++------------------------
 8 files changed, 79 insertions(+), 45 deletions(-)
---
base-commit: 8d5ce4751fad9499ea408163af7f410f18a85782
change-id: 20261112-b4-disp-0287c16e-bc0127d9de9e

Best regards,
--  
Bryam Vargas <hexlabsecurity@proton.me>


