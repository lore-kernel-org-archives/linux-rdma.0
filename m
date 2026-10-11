Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9132043F090
	for <linux-rdma@vger.kernel.org>; Sun, 11 Oct 2026 12:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791720663; cv=none; b=A+MeMmkf2e84DKZEK/QDZBImPTSuTfR1rElEGHQoVxXDC1HlAMP+I1/xtH2zevo6vuo+uzcNw9MDVhW6vA7fPhWXDQOSVmaQxU0H7P50AaB5YnD+G09jjCNg1r2Y3U94n+XisdbBhJuifUKUVQ51kV+OGxc7/HcYW2xhfm1mga8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791720663; c=relaxed/simple;
	bh=1GX2BUigSB3k3qqNJ/4N8FyMlsbN+ioQZNzI6WT4oIQ=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=m01FHP6Q+JZa3g0Q6/gKtEbKcZd0+W4tx4h+5fB5i4xO/db9JXA/N03y7gvfv/LEe3abUtIqALp3z1tZPdYMOSYI2AqRGpQIxCYFq9hKICgjXCsF7O8vu4Ogu0KiaVst1CycTYnh+lcH8OIBA7w++oTGVLZmPLrZgzR83JmFtHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DY55hh0K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DY55hh0K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746261F0089B;
	Sun, 11 Oct 2026 12:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791720655;
	bh=AKdZ9ohPjQMN07E006gKiX+sr4XDEVb186/fFMNTiYw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DY55hh0KVYcwEWCuU9yzm1oPGmLTVe15OaGJrFLJ3/j4z3DO9jXul09+EL6zZAFiC
	 RtA0XN0tauDWK/d6zAzC03lGUzPIH+/Kpx+ppLW8bJZL1SauzIZFl5cLPspNPui3Gp
	 5DKTc/9R0L+aT8u1000c69RxB89IwAKdRldHqgofweGv8pXORWluS7/grelqhkbkH1
	 NCByPVNqePIprB8s0UQjO8+5Nzj0Q1+ImO3j/5ZTgHmdBDXC5oyZRX8TjHcjrM8GbJ
	 lfflB8ys2EjilTHqWq+zjnRsRFgkPeB+12tN1RjUFLNtRzdJqTEChi99mT4VR5JLV6
	 9wbNo/yho+1ug==
Message-ID: <sashiko-outbox-167217@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 for-rc] RDMA/siw: Enforce IB_ACCESS_REMOTE_READ for
 read responses
Reply-To: sashiko-reviews@lists.linux.dev
To: "Haitam Lazaar" <haitam@lazaarsec.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <1a12ad1d83f.19cd98924357428.7073029566232810804@lazaarsec.com>
References: <1a12ad1d83f.19cd98924357428.7073029566232810804@lazaarsec.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 11 Oct 2026 12:10:55 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> When generating an RDMA READ response (SIW_OP_READ_RESPONSE),
> siw_check_sgl_tx() unconditionally passes 0 as the required permission
> mask:
>=20
>     /* Reference memory to be tx'd w/o checking access for LOCAL_READ */
>     rv =3D siw_check_sgl_tx(qp->pd, wqe, 0);
>=20
> Because perms is 0, siw_check_mem()'s authorization test:
>     if ((mem->perms & perms) < perms)
> evaluates to (mem->perms & 0) < 0, which is always false. Consequently,
> an untrusted remote peer can issue an RDMA Read targeting any valid
> STag in the Protection Domain, even if the memory was registered strictly
> as write-only (IB_ACCESS_REMOTE_WRITE) without IB_ACCESS_REMOTE_READ.
>=20
> Enforce that the target memory region was granted IB_ACCESS_REMOTE_READ
> when answering SIW_OP_READ_RESPONSE work queue entries, while preserving
> perms =3D 0 for standard local sends.
>=20
> Fixes: b9be6f18cf9e ("rdma/siw: transmit path")
> Cc: stable@vger.kernel.org
> Signed-off-by: Haitam Lazaar <haitam@lazaarsec.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1a12ad1d83f.19cd989=
24357428.7073029566232810804@lazaarsec.com?part=3D1

