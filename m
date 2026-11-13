Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794531773;
	b=L6fYj0KZoaRWLDuevGzlwZJ5LKnr8UdDzpJeE882JKlxm537FUgTRDuW9UPLzw1j8PqH
	 84lF1tvMRuvYO248a7YCK9fNgc6dWrIzOh70Cd8W++ZD1iBEmea27GgZ/piLhZwlvaAC8
	 WV9xGlaM3bs7hNMMbmIU2OmRVAZ0+f2WXBUiVH6NuMPqFRlBADpc62PH3+KAuYp/bRbnf
	 ZHcDRtIHNLkSdNdRACCMVH36bzQEmgLAvVP6JwM82PO9AsnGWzyjNA6EdOxLOOWRtuLfP
	 YISYmOSoaGPLATeLKR4yeK9k1+2tNfU1sZw+TmPIHhzTO2dk0fgTDyQ7hJ6Om99OUrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794531773;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=nIAyxgbc0dBhpCr5slLCIJwaBkTcRa7SaWQgrgx1Si8=;
	b=066fc93Tu0RC2TwQWuoLRFmeBvc+T9krCS9R8GB0lhYEmMRvHxS//MfRP+j2IRFd71Td
	 r54TAzswOtgedcxkrl8qhSG/JQoEr07teGZWI2BoD6PKS+sPWfwHJeApodhFRiV+lyrS9
	 kwZIydsMKHMZGdCHIFYBuDVGO0DUDPzZIItX6Hj3BbRLmq60NilBiKqfRD9PZ3Qja5oHS
	 vPaT3mYgvqk/y/YPNmXPvuXFxg5udQFSW7G5z0OIQk1UwH7acSPlYkMiwf/OaivoOJgSf
	 qmg+P18tj1fvwWpgFwqOJGhtgH5ovbwR4E7um5FFIntC4TRVkmy+fk84hTrl64W6k9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=proton.me;
	spf=pass smtp.mailfrom=proton.me;
	dkim=pass header.d=proton.me header.i=@proton.me header.a=rsa-sha256 header.s=protonmail2 header.b=UPoJn0rz;
	arc=none smtp.remote-ip=109.224.244.16
Received: from mail-24416.protonmail.ch (mail-24416.protonmail.ch [109.224.244.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80408606A888;
	Fri, 13 Nov 2026 01:02:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 80408606A888
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=proton.me header.i=@proton.me header.a=rsa-sha256 header.s=protonmail2 header.b=UPoJn0rz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail2; t=1794531769; x=1794790969;
	bh=nIAyxgbc0dBhpCr5slLCIJwaBkTcRa7SaWQgrgx1Si8=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=UPoJn0rzmtHUnLQ3O/nDivcaaFknqIJOpiUP6CguPaEYrsZf9c4+VWjk9lh8C1RQ0
	 U6UdFKyG5ILHNkFJtK40fc/kPVF9udi3XKUxhZIV/IBnUvgHg4wzUzW8SNoiZPP08Y
	 UCluRZj4JY7xfr4a2jMkmx1GaJIY29RQcEGwbr5F7zdRmIRc7iQ9mqBzvRMhYWVp2l
	 Cj/St8K+v3rNSvmk/FCJ06oPLBfCUy9Sq/0ecwro+jy4dQvhOT1p+Q7jm4Gvf4MHB8
	 utS7d8+rT29949okFa++22lapjfVSay/+HbGqObp0nPgnhe1F2qNieLlfu4fctyTD3
	 ugaaZWpYtmmww==
Date: Fri, 13 Nov 2026 01:02:45 +0000
To: Paolo Abeni <pabeni@redhat.com>, netdev-bot+sashiko@kernel.org
From: Bryam Vargas <hexlabsecurity@proton.me>
Cc: Sidraya Jayagond <sidraya@linux.ibm.com>, Jakub Kicinski <kuba@kernel.org>, Mahanta Jambigi <mjambigi@linux.ibm.com>, "D . Wythe" <alibuda@linux.alibaba.com>, "David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Guangguan Wang <guangguan.wang@linux.alibaba.com>, Ursula Braun <ubraun@linux.ibm.com>, Stefan Raspl <raspl@linux.ibm.com>, linux-s390@vger.kernel.org, Wen Gu <guwen@linux.alibaba.com>, linux-kernel@vger.kernel.org, Hidayath Khan <hidayath@linux.ibm.com>, Simon Horman <horms@kernel.org>, Wenjia Zhang <wenjia@linux.ibm.com>, Tony Lu <tonylu@linux.alibaba.com>, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, Dust Li <dust.li@linux.alibaba.com>
Subject: Re: [PATCH net v8 4/4] net/smc: bound the link failover cursor advance to the send buffer
Message-ID: <20261113010235.418440-1-hexlabsecurity@proton.me>
In-Reply-To: <fc454b46-b66c-4a16-aa1c-3ea0c2e91d15@redhat.com>
References: <20261029-b4-disp-33001ace-v8-4-f9bb96e17827@proton.me> <179364387382.3131.13471253186660322977@kernel.org> <fc454b46-b66c-4a16-aa1c-3ea0c2e91d15@redhat.com>
Feedback-ID: 199661219:user:proton
X-Pm-Message-ID: 3134a679630143b5913b128635697a100cf4272a
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

On 11/3/26 11:22, Paolo Abeni wrote:
> On 11/2/26 19:24, netdev-bot+sashiko@kernel.org wrote:
> > - [Medium] The patch adds a cons.count < peer_rmbe_size gate to
> >    smc_switch_cursor().
> > - [Medium] The new bound in smc_switch_cursor(), diff <=3D
> >    smc_curs_diff(len, &tx_curs_sent, &prep), is computed from a snapsho=
t...
> I think the above are the last 2 comments standing that need to be addres=
sed,
> (the high one in patch 1 is addressed by patch 2, the high one in patch 2=
 is
> addressed by a separate patch).

Both are right; v9 [1] changes the code for each.

> > - [Medium] The patch adds a cons.count < peer_rmbe_size gate to
> >    smc_switch_cursor().

For a count past the RMBE, v8 turned a stalled connection into a write
past the peer's RMBE. A check in smc_write_space() isn't enough:
smc_cdc_msg_recv_action() credits peer_rmbe_space from the next
consumer cursor, so one more CDC after the switch opens the window
again. A conforming peer gets the same write if it keeps reading across
the end of its RMBE before the resend.

v9 bounds the write where its length and destination are computed (new
5/6): at most one RMBE per call, and the first chunk ends no later than
the RMBE whatever the wraps say. On rxe with a 16K RMBE and the count
forged at RMBE + 4096, v8 posts 16384 bytes from offset 1 and the link
goes down; v9 posts 16383 + 1 and the link stays up. With a conforming
peer, 9000 bytes unconfirmed at the failover and read before the
resend, then 2000 more sent, unpatched and v8 post the 11000 bytes in
one chunk from offset 12001 and the surviving link goes down; v9 posts
4383 + 6617 and the peer reads the stream intact.

5/6 turns one-chunk writes into two, so it sits on a fix for how
smcr_tx_rdma_writes() sizes the second chunk's source (new 4/6, the
pre-existing [High] on the source SGE in the review of v7's 4/4). A
conforming peer reaches that one: a completion handled between the
first two cursor copies of smc_switch_cursor() leaves tx_curs_sent 600
bytes behind prod, and unpatched and v8 then build a source SGE that
ends 4536 bytes past the send buffer (KASAN splat on the unpatched
run).

> > - [Medium] The new bound in smc_switch_cursor(), diff <=3D
> >    smc_curs_diff(len, &tx_curs_sent, &prep), is computed from a snapsho=
t...

6/6 (v8's 4/4) sets tx_curs_fin and local_tx_ctrl_fin from the advanced
tx_curs_sent and local_tx_ctrl.prod, which change only under send_lock,
instead of adding to the live cursors: the first of the review's two
options. With a completion handed to smc_cdc_tx_handler() inside the
switch (test hook), v8 leaves local_tx_ctrl_fin at count 16713 for a
16384-byte RMBE; v9 leaves it on prod.

The switch still isn't serialized against smc_cdc_tx_handler(): a
completion handled inside it is still credited to sndbuf_space more
than once (the pre-existing [High] on that race) and can make the next
write hand the peer bytes it has already read. 3/6 keeps send() inside
the send buffer, but send() can then overwrite data the peer has not
received (by inspection). Serializing the switch means taking the
socket spinlock around send_lock in smc_switch_conns(); v9 doesn't do
that. In two races with a completion inside the switch v9 ends worse
than unpatched; the cover has both.

The [Low] of that review, on the new comment in smc_switch_cursor():
6/6's comment no longer says "else that peer stalls", and the message
no longer says "still sizes".

[1] https://lore.kernel.org/all/20261112-b4-disp-0287c16e-v9-0-e5e8fa688177=
@proton.me/

Thanks,
Bryam

