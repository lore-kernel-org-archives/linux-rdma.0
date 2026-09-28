Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B9F4973AA
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 16:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790611420; cv=none; b=kcKO5rqM+QTBjPqt3cb7WiiDetKdKq8N9rrStXPnlEcITbG9CdFxztjUZZMws6dYAJmUNcaLaXqjAWirkXS+l+T4zaYDS0cRMgZTs3oAk5j2R8zFLvxy9oq4Ks4gC+A+DrFnMuFCY2NsAZ7Vhp4hqPYpbEdUKRnNEm3UqUFc/fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790611420; c=relaxed/simple;
	bh=a/GqNgAg03DaQ4d8c6ySaBv0qnI7W8OX9m/vqiv94Cc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ewelWI4d9EtMRKfCfueXC1SQrZiOs1r/CEeU7xkWPeFl8rnz5E1c/TEt1htAElyV5z4XtzoxibIWGciog2xEMv4JdOVoetjfAkV07MzKrcrF++bPn0fLyAjiSQuduwbpBgJIv20luVrjZLjq9E9fd34nKUgvWrWLGdCgrIctGVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=irFHpkdx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="irFHpkdx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 794A91F000FF;
	Mon, 28 Sep 2026 16:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790611418;
	bh=a/GqNgAg03DaQ4d8c6ySaBv0qnI7W8OX9m/vqiv94Cc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=irFHpkdxn4nfbsGVNnd2ea4EHRrbLgajhk7y1UbWkvFxIqa3wqTu8odVBJDln8dq4
	 dRovu0f1vCulo+4Bf+TdKXowjNocwQPdiHFIOlM2vw9RsNglRwlJCD+o7V0+7wNU0e
	 B3gTBhGKYybY519lgepbdjHaawZ4HlaRizzJeo6l7N5jaINw4D/DyLVRp0AMfn5TM7
	 qHioTQU51cmihjt+0izDzGdg88Ydve3iplanMrg/WK8eSuxLEjQQ+n/nmJqA+JGNjT
	 aCuCcCxjcaAlOnwpRmDkkmFzFoYT5zrvcvzEAbUnQFcTjHblrKR5JjHwx/1E3vmyEy
	 hxoSIaWM669Pg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/4] RDMA/rxe: Take MR reference under MW lock
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dongliang Qin" <cccccccccccc777777@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260928155351.3222978-2-cccccccccccc777777@gmail.com>
References: <20260928155351.3222978-1-cccccccccccc777777@gmail.com>
 <20260928155351.3222978-2-cccccccccccc777777@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 16:03:38 +0000
Message-Id: <20260928160338.794A91F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> The responder validates an MW, drops it, then reads mw->mr and takes
> the MR reference. A bind or invalidate can swap the MR in this window,
> so the responder may acquire a zero reference or use an MR that has
> already been freed.
>=20
> Move the MW lookup, validation, and MR reference acquisition into
> rxe_mw_get_mr(), and perform all of them while holding mw->lock.
>=20
> Fixes: cdd0b85675ae ("RDMA/rxe: Implement memory access through MWs")
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Dongliang Qin <cccccccccccc777777@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928155351.3222=
978-1-cccccccccccc777777@gmail.com?part=3D1

