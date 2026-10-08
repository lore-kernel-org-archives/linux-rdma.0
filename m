Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58F1547043
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 03:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791430337; cv=none; b=GCYc0SlO3Jij6AmnRHkIxNYBgNl1HegRyYUH4cFrplnt7Scmq+CFQFBbOqZIDuF7g5qVCONTYnTDl5bTHimvxUNQgKZvFag5qYQe8JaHLVVN8ZfdjKGG9mVYXLBpP/bZbuqBqws2D69Sj3oDkNl1abnA8sYDrmNAuSS8SXB6RKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791430337; c=relaxed/simple;
	bh=j4aBAY9w2q8mGDwGm0mYTntApBZoGhNwuJQcZ0ZFeq4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Sh0ZC31nXk51nJQGjwrzsk57Pl33kE2eicoDeASBw1kraAJ88uBW4gBMPdIybSO6sA8LzE7XQBFSgvdTQhV3cG0x2zAw5nt9pX3R0fQskzTzu6V7ljcNVfKtVwjm6cF2qpQM6l4l8RZW4v167Z9QI6UYIAsWN5c3bD2Sb+h4MHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GaOH2ZU9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GaOH2ZU9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A09D1F000FF;
	Thu,  8 Oct 2026 03:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791430336;
	bh=iRQm5FQ62lyo5SoqQUsJCBIN3sC5nK7h1YMRxHLP4Bk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GaOH2ZU94xbMBs1rg2R+gSgO8hFHSkblSA7CHqtnlgstebRj3dHtfd476IWB8Nl9y
	 E0D5RnNH+0FadfLgjvpR/O0ggSLoG1rIxIVuQb3/Ncy4/nj1a+uyAtX4gruALfgEdE
	 HU1p9peXPOwuL+N7XA8urq7zha3cqXsCe/ITMoSHPhWme+t5QAde4d4GIRZzFG3Pvm
	 8kanAymJhnv1wtO5+PT6GagU0GXgagjCw15Ph7C+ylAdzQQuWq+BTIcZ38tzn4XebD
	 t7zRBWkbfCaDa+ZzjY9K1QROpMcvhhFlilQucpXq/hcF//60U3/fwLnsBORqGfvy3U
	 6tFyhB9UY6RUA==
Message-ID: <sashiko-outbox-163545@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v9 01/13] net/rds: ib: don't enable interrupts
 in rds_ib_conn_free()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261008031333.1142174-2-achender@kernel.org>
References: <20261008031333.1142174-1-achender@kernel.org>
 <20261008031333.1142174-2-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 03:32:15 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008031333.1142=
174-1-achender@kernel.org?part=3D1

