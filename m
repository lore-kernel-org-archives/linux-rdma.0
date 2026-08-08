Received: from mail-24417.protonmail.ch (mail-24417.protonmail.ch [109.224.244.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A47334F474;
	Sat,  8 Aug 2026 08:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786176786; cv=none; b=KI9ZGjAoZf0rtF+YvPaRqRLEv2AGg5XyUmv7Ww1oENm1gW4M18Xi3c1EuTyHXdEqU4HUorMQm6xYNnjIq3Gr4XcWgIslS8vb6/YX3LeR6Cl85c/xp8C92DbyJhUqOYJzBclABBFRk/eXu2CngBlgrO+AdmUjUZoYVAw1AHHb1UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786176786; c=relaxed/simple;
	bh=U7T99eAafPQwDZHJAxRLoUHSj9H9PcIOGK436vZT2JM=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=CTLqIKH8hyEQqva+w+zsNc2hh6YwyzKHLj0Tnk11F2Dne0juHeQ2nC2rAe4yxcKSgTPWkcq+5XcWVdRI0nXsBehtcuYZkbou7eCToJc6TLY/ZDgrKrVf4IOh7iu8eEW221Viu2AZUaZmD0etmg5fO3DtvZ+U1l4d6L5JywduWrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=DMs2gOV1; arc=none smtp.client-ip=109.224.244.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="DMs2gOV1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=yeo2e3rg6rhx3amfdow7g5rx7i.protonmail; t=1786176771; x=1786435971;
	bh=CPjxbEpyKX9EiaXoNzd1dq0b6n/s36ZaBQgP8FiBpuA=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=DMs2gOV11KELf1nfDQ3TMbH/dkyOs/LLhloLCIUAqWtkVTxkHkwsmxy74qDEEGftj
	 10QVEU7b5KARNUK25xc28GaQgf7GHuZxnkl3S8D1eMeQbpQz7o6XSSyxD26AOT7Cc7
	 W3auKQ3eE/gdick5Au5ozSivAZJMODd30LOqZDag0OcA3mV69v231GhDQzP5VJxZqB
	 jSzcJs4EPBq5xTqYITyVlX32+L2cgfq9pSHark4egeT//1TQeRniaaMODBJjdeKLtc
	 7k7W9S63u6GzcpZKg01kuONYysThjmNjpHBsppfGxjzg8MI6XZQ5Ze1aQH4hT2N+J5
	 MRIOndhAzV/sQ==
Date: Sat, 08 Aug 2026 08:12:47 +0000
To: Hidayath Khan <hidayath@linux.ibm.com>
From: Bryam Vargas <hexlabsecurity@proton.me>
Cc: Simon Horman <horms@kernel.org>, Wenjia Zhang <wenjia@linux.ibm.com>, "D . Wythe" <alibuda@linux.alibaba.com>, Dust Li <dust.li@linux.alibaba.com>, Sidraya Jayagond <sidraya@linux.ibm.com>, Mahanta Jambigi <mjambigi@linux.ibm.com>, Wen Gu <guwen@linux.alibaba.com>, Tony Lu <tonylu@linux.alibaba.com>, Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org, linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net/smc: abort the connection when the peer overruns the RMB
Message-ID: <20260808081242.409253-1-hexlabsecurity@proton.me>
Feedback-ID: 199661219:user:proton
X-Pm-Message-ID: 9f545b46e6deb2c5541d8a4bee9ea5ce6cd9d6bc
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hidayath,

> I have a standalone net-next patch that aborts the connection when
> bytes_to_rcv + diff_prod exceeds rmb_desc->len.  The check sits before
> the atomic_add(), so the accumulator is never written with an out-of-rang=
e
> value

That covers the follow-up I said I would send, and the placement is better =
than
what I described: I had said a check after the atomic_add, which only notic=
es
the counter is already out of range. Yours doesn't let it get there. Consid=
er my
follow-up withdrawn -- I am not sending a competing patch.

If it is useful for the Fixes decision: I ran the wrap++/count=3D=3D0 vecto=
r on the
real SMC-D path under KASAN while working on the cursor series. With only t=
he
per-cursor bound applied, bytes_to_rcv reaches 6*len and smc_rx_recvmsg() t=
rips
slab-out-of-bounds on a read of 5*len; each CDC advances exactly len, so
diff =3D=3D len and an advance-bound does not fire -- it's the accumulation=
 that
overruns, which is what your check catches. Logs on request if you want the=
m in
the commit message.

Two heads-up on collisions, since both are in flight this week rather than
merged:

smc_cdc_msg_recv_action() is also touched by "net/smc: order the CDC receiv=
e
path against buffer publication" (v4, 20260728-b4-disp-52ee4e7d-v4-1-0dda94=
b0f397@proton.me),
which hoists sndbuf_desc to the top of the function and gates the tx-trigge=
r on
it. Your hunk sits just above that gate, so whichever lands second will wan=
t a
look rather than a blind rebase. I'd rather flag it now than after a confli=
ct.

And you mentioned running the abort_work cancel for both transports in v2 -=
-
that edits smc_conn_free()'s SMC-D branch, which "net/smc: unregister the
connection before draining the rx tasklet"
(20260808-b4-disp-22f119e6-v2-1-61647601a6f3@proton.me) also rewrites: it d=
rops
the !list_empty guard around smc_ism_unset_conn(), moves the drain ahead of=
 the
detach, and clears conn->sndbuf_desc before freeing it. Same branch, same w=
eek.

On the shared bitfield -- agreed it needs a layout change rather than somet=
hing
folded into a fix, and it's yours; I'd noted it and left it alone for the
same reason.

Thanks,
Bryam

