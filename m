Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09DF55292D
	for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 15:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790091215; cv=none; b=KOOiZCXVuPRliZJvknAedRj0KuNnP7RcdMw2/R+K9yKGMoEZGNaxeQvXoiCxinWZNXdZqyDB1G/0kzw4tOLzDX30UmRhD/cc99DpPNNinUajaFc1RIgd79q4uyn4CXlJK/l7q8v7j+ngIUE1nK3fLtGLwT5XDKfzfuK93x1TQDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790091215; c=relaxed/simple;
	bh=xnMhzSqTN3EeujSMdor5Gokg3pB95oTOiuG8SU8EsnM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uUOHAwYtr34mrhb06utujZLlQIY/t5j/DalBd4ff2MNy2FlgLsonsZHgjcAfg9QcGvmSWJ4Yvmv+40f9dhshMJVKk2GPfX7c5MfZvde1spZ2mPkLgjuw3ibdQ0d8vdGUXZ9MZPhs5+n4liopljyefhZ13TTv+mAxxo+lf0ku7mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CdiVlmcW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CdiVlmcW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F6D1F000FF;
	Tue, 22 Sep 2026 15:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790091214;
	bh=F8fiRXyvr9lSDvtmLQEGSCn7ASlw2++kA0ptNxuiKPc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CdiVlmcWI4bowvcYOCJ/wRPu6J0wARgfU5QkkhrWgo80lAf1vs0OhaJ2njPPWzO5s
	 dOf0+k0FnAJO4K8uZGIpCaK1o82fWUqso/O7JqIvsuOSr5TJriZaWDrnUbqqRzGH7k
	 Ko5lvmKjD6h55Cpxe4QItgg6cyHCu99SXHDwp4cEKMSKFi/Qzh8khloDsZUN9TH+ld
	 NMyPGkBTX4cjlXvVrkK36jz7yxE6+bBbiqvyxe8XVDnJB2IEo0iz9HbOirk02xd0l6
	 /WLCwQng5vxxv6f/fkKl8ZZYuqzD5RaljHlHkk4MINx1UCnEh+iRZ4260297Yg7JEh
	 UKIzNS4srpb5Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] IB/mad: fix UAF and double-free in RMPP receive
 reassembly
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dairui Zhang" <zhangdairui@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260922152342.1474845-1-zhangdairui@gmail.com>
References: <20260922152342.1474845-1-zhangdairui@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 15:33:33 +0000
Message-Id: <20260922153334.54F6D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> mad_rmpp_recv.state is protected by two locks that do not exclude
> each other: recv_timeout_handler() (port workqueue) uses agent->lock,
> continue_rmpp() (CQ softirq) uses rmpp_recv->lock. Nothing serializes
> the check-then-set sequence on the state word:
>=20
>   T1 (CQ softirq)              T2 (port workqueue)
>   continue_rmpp()
>     lock(rmpp_recv->lock)
>     state =3D=3D ACTIVE  [passes]
>                                recv_timeout_handler()
>                                  lock(agent->lock)
>                                  state =3D TIMEOUT
>                                  list_del(&rmpp_recv->list)
>                                  unlock(agent->lock)
>                                  destroy_rmpp_recv()
> [ ... ]
>=20
> Fixes: fa619a77046b ("[PATCH] IB: Add RMPP implementation")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Dairui Zhang <zhangdairui@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922152342.1474=
845-1-zhangdairui@gmail.com?part=3D1

