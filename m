Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A23B352034
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 16:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790611409; cv=none; b=bsG7xU5wBKPjCek1zVT+rl7w6zI0Y29M9ggTddyVIZ1c1ufey8+crk0twRjziJLii/HuatziHjY4hZE+yDCFAohwSx5vZHUhXFcySY+EVwS3JxjTOrVaYx2Z+STja8gAFDZtdZdmmxi8EX/U0SC/fYboC34ZCe8eiEuoOMZ9NVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790611409; c=relaxed/simple;
	bh=BDAstxDSpokKLlewr1u93z9fzd3TT/ig21ShDInN3DM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=apEapCEKwm965miby0mk+MlwiFWGxGWJtIOpo6Ha/ncBr/zq/zKeOz8mNqwF6RX+bFSnYM9mOq7NjT+mx+PO/Tj+IpfKIgQnqWD9Zbwvn33AOMoykEvNlaUlLGcAMts8PlKV6DlIxELiGyl8gmQr8jG9De/9kOibhQQkIFcGzN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QXLx6vZr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QXLx6vZr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF3AA1F000FF;
	Mon, 28 Sep 2026 16:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790611408;
	bh=BDAstxDSpokKLlewr1u93z9fzd3TT/ig21ShDInN3DM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QXLx6vZraCCkqge9SvlgMLpiO9VmGZ+c9j8VzAKUyC4jxbcepWBw98pa7ErZVE5PD
	 Y3QvGwJzTLpQzkEMbZExz4Doc+lvk7GK7wZyC6NXOGvcMULkm4BHvsdXOgr0oYtzHG
	 a0NxiGkiDXQu9S+SxjjmuDQb8gHDr0DWRtD4BVO+QC1q2tjLwY+gNZtWCn3oAZgO4I
	 kurDoro3K94SQn8EnmOM7kSKp8Ki27uQPcoO+2DeuIrDdlYdpKLQerwbaNHtkAwPvp
	 3f24io9TrSzuUvVMivfB9cLp4CQiWETEJOzyBmCph1kxFpgWN2d/BAtO+fH1nKttNf
	 QBo1rJnfhyVFA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/4] RDMA/rxe: Reserve MR state during MW binding
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dongliang Qin" <cccccccccccc777777@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260928155351.3222978-3-cccccccccccc777777@gmail.com>
References: <20260928155351.3222978-1-cccccccccccc777777@gmail.com>
 <20260928155351.3222978-3-cccccccccccc777777@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 16:03:27 +0000
Message-Id: <20260928160327.CF3AA1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> MR invalidation, fast registration, reregistration, and deregistration
> only test num_mw before changing MR state. A concurrent type-2 MW bind
> can increment num_mw after that test and leave an MW bound to an MR
> that is being destroyed.
>=20
> Reserve num_mw =3D=3D -1 while the MR state is changing, and allow binds
> only while num_mw is nonnegative. This keeps the MW binding count and
> MR lifetime synchronized without adding a new object.
>=20
> An unprivileged user with access to the device can use this race to corru=
pt
> kernel memory and escalate privileges.
>=20
> A concurrent bind and deregistration reproducer made KASAN report:
>=20
> BUG: KASAN: slab-use-after-free in rxe_mr_copy+0xd5/0x3d0
> [ ... ]
>=20
> Fixes: 32a577b4c3a9 ("RDMA/rxe: Add support for bind MW work requests")
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Dongliang Qin <cccccccccccc777777@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928155351.3222=
978-1-cccccccccccc777777@gmail.com?part=3D2

