Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794948578;
	b=4vpki6M/xBv9fbYVqwDlpDVvzZWdCzQfcu+PDJf/eflHMxujCVI1ixlE8wg/h1n1R9XK
	 g8EluH2S/nhdH47KNuUhRCoBY2KEmgR/2WihAYIIyNdZMCz/0SItaTpNnKlbLj6DdiQG5
	 qcEFcvvJ+8AsOFrUy5SVNPHTcKgMWN2Bn5LMDyy3KyjIjGAd+z2AcPKCtkfc85g2r9UIy
	 iv8Zh/WHTCuuV8CtCyVjpIueudwJFfSXEPGXPommn8PQyePCQ1i/VHsupxXlVXiVTTDS/
	 iGo2bbHtg6wsjHSZIsYwVAkV/2j22OcEVb5BQQ2zWp1WfigHwthNK9TQGD5sHs/aOVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794948578;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=c+SWxyTSXvCgLiS0tZh1wJZ7bSB2+d/yuZHl1baQ0mw=;
	b=cVT8TASWdQTT6gbWC6O4Cmq8M5kuicoZRbMnNgyEx2QPpD5Ci2x3946U49xgbyeGJ6Rc
	 ph7PlQfUxsz61BM5g5aJWVAm6h2McAtf1519lYWZ8/6is4XtsvqMhRhzOdFIi5ttxeNZ2
	 d8SWiaeQnpDFnXrXgxB0zdIqvo6+5StxsS8+7fO+lV9M5ceOF0zBkqm8JHCiuvFn8WqBZ
	 pWxb0FE36twNBKUav6TCuRC+1BXKuWFKIInGGCuNZOT4KBDcUES6/uullsybqqqT8UdlX
	 r4K+mU5jQfdwNKzPrxluNbdEQ7cZjS28IbSLdByCoPTK6V+IZwRM163hbUZNxnXu6vA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bZYAgj3G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF8D606A31C
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 20:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bZYAgj3G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC8E41F000C4;
	Tue, 17 Nov 2026 20:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794948577;
	bh=c+SWxyTSXvCgLiS0tZh1wJZ7bSB2+d/yuZHl1baQ0mw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bZYAgj3GSulHWpocFncor6Dmo1E+qxtFkj28lwZpt33JWSSuMcYU0IuQMF7ElbQmD
	 COHcK1ZmyAWWtXgCblCbvtg9ecpWUs66SyqGvhcGIAeZdFvVAeS/z88OjgSTikYd+C
	 akD4H2ZQ6IMr9BbRu/9TjopFiO1qab3EUPbM7kS/PLySzprNO59YfLjcBvr2lJg7aq
	 O9XKcNKxW9lgI/utd0KDe5g4QS6P38G5PHOy+xEW50m6ZuyfKTt3BEbvehMf10Qa6o
	 yHW1aNLS9OS7eMrBxA8My5kWmQZJUkMv2eVMPk1UMUI79NE+VR8+nlFXHbCL1l6q27
	 XSLtUes8f7B8A==
Message-ID: <sashiko-outbox-219648@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v6 1/8] net/mlx5e: ring the tx doorbell when an
 accel offload drops a packet
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117203137.804424-2-toddfreed@meta.com>
References: <20261117203137.804424-1-toddfreed@meta.com>
 <20261117203137.804424-2-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 20:49:37 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> when mlx5e_accel_tx_begin() drops the skb, e.g. because psp can't
> encapsulate it, mlx5e_xmit() returns without posting anything. the skbs
> before it in a bulk dequeue may have been posted with xmit_more, which
> defers the doorbell to the next one, and an mpwqe session may be open.
> the device then doesn't see them until the next transmit on that sq, and
> since the queue isn't stopped, the tx watchdog doesn't fire.
>=20
> flush the sq on this drop like the dma error paths do: close the mpwqe
> session, post a nop and ring the doorbell.
>=20
> mlx5e_tx_flush() doesn't check whether the nop leaves less than
> stop_room in the sq. for the dma error paths that is rare, but a run of
> offload drops would post nops without stopping the queue, and could
> overrun wqes in flight. so check it in mlx5e_tx_flush(), like the other
> producers do. the completion of the nop wakes the queue again.
>=20
> the next patch makes the psp drop reachable from user space, with an
> ipv6 extension header set on a psp socket.
>=20
> Fixes: 2ac9cfe78223 ("net/mlx5e: IPSec, Add Innova IPSec offload TX data =
path")
> Cc: stable@vger.kernel.org
> Signed-off-by: Todd Freed <toddfreed@meta.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117203137.8044=
24-1-toddfreed@meta.com?part=3D1

