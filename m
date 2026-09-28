Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B684CB8C1
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 17:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790616473; cv=none; b=XyZ52KXOz/dvIBrqFICCwImT5FV7FKqRZsZKf4Nq23MQ1rQRasw+6kcL+aPPMIm72eCLGmsDNKEDM+qv1pwd3AMF7YkV9RMtqrPG/oxoUqek9yoNiKQmlR8cPE3GKVymuki8e30fkUrpKHtJ2+3sygH5pbpz0JRKM5ytgn1pySA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790616473; c=relaxed/simple;
	bh=wpmEDhg3vrE2CM/nsn+87PTtejHO2KYFsRirFuQAf1E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VBxAPy91ofxY/TeJmsbgwuW8Dhyd+vT8kfIBimH8vuqVKwwaw8dfNXP4SlbcVt/QigTQPIgj95MEk53ko8ydnwmC7MrXdtZiJrx+uYwsO2Zk9B5QSx/ljB4iohkY8OwEfeTlvR9W9rdI8XAJwNw5BYHSk4KlYV/opRkLoXI231Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l6HKnYmg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l6HKnYmg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08CC71F000FF;
	Mon, 28 Sep 2026 17:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790616472;
	bh=wpmEDhg3vrE2CM/nsn+87PTtejHO2KYFsRirFuQAf1E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=l6HKnYmgbjZ2jB10btWOfzJgxYbXqVFpPhguhkCO8XJrHsv3nRIXeluCQBt4Atw8L
	 gYa2TNwy/kEb5IlilgKyTtG2rt5xgB6sHfAcU2tCX/GHcPMKhNJgB+gIWZfAjXh589
	 CF0QoI7U/w88rNygvIjx8s27C5Wlgv/9cPU4wes0yPqBoGOpZ0PgUfk4BwkTIxUgbQ
	 mMgAT99IoQWqFt0ZG9owurszprvLiXTwUkKN2XKhOzb4BNS/e/JOao+YZ9N3PQ0h4y
	 ciC15W4nHfQ1jz9M14Gm0iTNat/9z9+z0FTVIcKZeWa/71Slw4FTIIH6wdfRzThgXn
	 eokyLAO9WR1Ig==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/4] RDMA/rxe: Reserve MR state during MW binding
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dongliang Qin" <cccccccccccc777777@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260928171756.3254016-3-cccccccccccc777777@gmail.com>
References: <20260928171756.3254016-1-cccccccccccc777777@gmail.com>
 <20260928171756.3254016-3-cccccccccccc777777@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 17:27:51 +0000
Message-Id: <20260928172752.08CC71F000FF@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928171756.3254=
016-1-cccccccccccc777777@gmail.com?part=3D2

