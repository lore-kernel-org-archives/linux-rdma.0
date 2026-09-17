Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11044FC8F0;
	Thu, 17 Sep 2026 12:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789649179; cv=none; b=Qe/Sn2+dmejkKKYdQ3nyf0bAhg1wW2k/vx26GI1oRV53sze7e97a7+Sr+KY0NISAOXL/bfZHb46abSAq6sdeG8IuFzbCMyv6PGleNYzemjreWhJkLPRZAMxKp7FGtji/8BB5Fw8cb8yWNw3DKC/QVD+QcYQWwwaUeX0beb0FSa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789649179; c=relaxed/simple;
	bh=hBvdh9HClhGGCVREIg6h3wrnYFi7XdmLlR3pemu5ljg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RPO5/WMal3ozki+cq4V2SomQ6ZHfExXNR1dS6v5VU7YUC6h58j1nXEQ91EAxk0dNa5b+ViN3CX/Dsm0ek8oSKZXhAjD7e5TWy5oO1mndYDaOGM7P8VRlQ5lfPN6NuAh8L7jW+9e1f8MIGmJYLwuZOdsJe2B8sLul2L/+OjXp/VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dow0FEL6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dow0FEL6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A391F000FF;
	Thu, 17 Sep 2026 12:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789649163;
	bh=XEjkEBMozv5qKaeMN6Kt56A1rybE1JJj9lDoE4MFm9g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Dow0FEL6wBPAI52+k01nyDNoE8yTPxz6ptOIYePY/MVz/7wOoblpLQwHgGwPep8Zh
	 qYVC7CCiITO3rboNbgasH5bj7YQpsZ2MCV0sjyREW72oVj+SzU0ADDNGogoW9O9Qe1
	 2OAinqGD51Uz1YrAiERijCKB2/CFWOdJIfPGvLc3RmyYym9cUfedM/zSbf5EnR92oe
	 qAiNsQDQ2/J5VMOAnbCD6F+vxfTFpYuX4sGPMH1JJ4uNzLleiowQ9/U1NIeu22QmKS
	 Ly2MG+To9kU0UH/5yGZWlUMrnk7dj/08UTBjsbqPUkDVcReqzotZRgWx/x8/SXVwFy
	 8AebfNZ5uM3yg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next] net: use assign_bit() where applicable
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?UGVuZyBGYW4gKE9TUyk=?= <peng.fan@oss.nxp.com>
Cc: "Oleksij Rempel" <o.rempel@pengutronix.de>, "Oliver Hartkopp" <socketcan@hartkopp.net>, linux-can@vger.kernel.org, "Vincent
 Mailhol" <mailhol@kernel.org>, linux-rdma@vger.kernel.org, "Marc
 Kleine-Budde" <mkl@pengutronix.de>, imx@lists.linux.dev, Frank.Li@kernel.org
In-Reply-To: <20260917-net-assign-bit-v1-1-e9c97965e080@nxp.com>
References: <20260917-net-assign-bit-v1-1-e9c97965e080@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 12:46:03 +0000
Message-Id: <20260917124603.75A391F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Peng Fan <peng.fan@nxp.com>
>=20
> Convert open-coded if/else with set_bit/clear_bit and their
> non-atomic __set_bit/__clear_bit variants to the assign_bit/__assign_bit
> API.
>=20
> Done with Coccinelle semantic patch:
>     // set_bit -> clear_bit =3D> assign_bit
>=20
>     @@
>     expression cond, bit, addr;
>     @@
>=20
>     -if (cond)
>     -        set_bit(bit, addr);
> [ ... ]
>     -else
>     -        __set_bit(bit, addr);
>     +__assign_bit(bit, addr, !cond);
>=20
> Signed-off-by: Peng Fan <peng.fan@nxp.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917-net-assign=
-bit-v1-1-e9c97965e080@nxp.com?part=3D1

