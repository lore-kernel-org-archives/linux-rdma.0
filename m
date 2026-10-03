Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A5A139FCDB
	for <linux-rdma@vger.kernel.org>; Sat,  3 Oct 2026 17:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050185; cv=none; b=bSR/o/U/xOl4DtK/fYQnauLwZWY5UFxCe86B+b31vft1Gc0V1bSSuCyPBTFcuiC0SOPBXXaDFgfsyit9aw3EUzIqiWyJaRZ+eUJPeoqwBPxhczMu/pZThBiH3kQh3EjSmhk8886uHhkx1gqEDgsj3QijWspz4u/3XSdnUfgR85w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050185; c=relaxed/simple;
	bh=TsleWTH8FkrujqD4t0DbU+Wr8mJ1KmdJiF6oWzTtCuo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WZ3g6aAoEEWlXrnrxdhV1LinO/9FyFcrfsuPJspYyiGExT9eZ4+OjGNDAaso22bF5eaygd5i5jRLet7RIpNNAkUh6pzrEw/Nv7c/xIirHYQq1HjC3kVEB6Mh+sg8T3YePzfP2ZUKcsW1CSxXo7XKfbnGi7otjQipIeuNwV5Gf+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AetEIgSA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AetEIgSA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D7D1F0089C;
	Sat,  3 Oct 2026 17:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050184;
	bh=LRzPkgwX7Q4RDnbKJhcr1TD3Epy0bVCS//nAvmmvcfw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AetEIgSAnf3tCwbrOmibGarxL85MA5Yxsk1RXPyKSHeKgkqRW6my+HBqGkOuTLVVR
	 92UTMHlOLmtMqNg/8OKUzUeCfeA7uwn8Omxf0TMemd9Lbrx8TmURzWLC4ZSvyE30lw
	 yWwrqjhA/+UT320bPw8zwk8jqdm0OlvX899LYRNEe6i+C7hhf3Q//nwxUhLzGIR/S/
	 7szpHl2SOBUZE/7inwk3alsCoXs6koFy3Qk/cnjwPW+NOVtAxCc2D5l51t0xMzNMj0
	 UIrCHw5E/T+UVwotVYLO271rzIogDAXtgCfX/09XF6ncgvGBecGieSDadlfAWeHUYc
	 rGIKoXt3FoMPg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v8 01/13] net/rds: ib: don't enable interrupts
 in rds_ib_conn_free()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261003163215.250253-2-achender@kernel.org>
References: <20261003163215.250253-1-achender@kernel.org>
 <20261003163215.250253-2-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:56:23 +0000
Message-Id: <20261003175624.32D7D1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> rds_ib_conn_free() unlinks the connection from its device or nodev
> list under spin_lock_irq()/spin_unlock_irq().  It is not only called
> from the rmmod path, though: __rds_conn_create() calls
> trans->conn_free() to undo a lost creation race while it still holds
> rds_conn_lock, taken with spin_lock_irqsave().  The unconditional
> spin_unlock_irq() then re-enables interrupts with rds_conn_lock held
> and leaves them enabled when the caller's spin_unlock_irqrestore()
> runs, defeating the irqsave the caller relied on.
>=20
> Use the irqsave/irqrestore pair, as rds_tcp_conn_free() and
> rds_loop_conn_free() already do.
>=20
> Fixes: 745cbccac3fe ("RDS: Rewrite connection cleanup, fixing oops on rmm=
od")
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003163215.2502=
53-1-achender@kernel.org?part=3D1

