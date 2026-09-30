Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BABC8225A38
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 01:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790732089; cv=none; b=VZNwYOdffmmrfu8IfUDioilL0/hIpdD7cd10//jWLrFcre6/XjrUxO/h0PewRt3AKpDx9ppRQa1Sde6CJviD+2/EhkHm9g9B30sksz0k3ExL+NoLwJBFZ7HHhtWF0vPgIdIY/aUojgiaXo8evVJRYUMfjlIV+WMX0PybtEL1hFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790732089; c=relaxed/simple;
	bh=LBo17gSqNydXk6qfZ+CxnPYahRcD50ZNeAkfFBBUs4E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rXEnSHSosjmH5/3x+9apXbBEwaz+U7jRUwkk6yQEhME5eHe0nRWqtyS6I/jUcNCE0mC1MWc3AyzsA3XLJRbbPk7uvZRDmA3Q4+CNyD8d5W442fOWeMPQ+fdJ26Iq74Zu6R27qLqwpv5Z7REyFY5lPDTaLvtWeWYhhontS9vXXrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HQWf89km; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HQWf89km"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D78A1F000FF;
	Wed, 30 Sep 2026 01:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790732088;
	bh=whJ+hsmqBMVodSJs5xWI5QDUBo6shGw/A+m7EHOSc4I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HQWf89kmUUEz9L6qYW6sU044ehavlkJTkDGhm63K7I3nVf76Chklq68xJkDdl5uYk
	 Zr1pLroE9tlvZ3mf8vWG2gd6eIIpF9h8YvDFBmkQfEBHpVs9T4ilAsf/m+gNSL/2ep
	 hZJ1DEctMXoMdg2a4ZqIN5lH+d+os3Ef7onkr711oXrJTv4fZpBcjB0vYpdvQUr9QK
	 Gr+W8vckAuj+gqKxoz99jE6s418a+q3G3xFfGS62NNlJeA3QZfWgQuQFuVDKx5lKPb
	 X9hbb5IfAakxhMEBkbE8Lp5IXxz70d/ZLw7HS/S4sTl6B+4Bnuvq2Xw8Ao0sqI/6C3
	 px6zkrqyAGODw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.6.y] net/mlx5e: Fix netif state handling
Reply-To: sashiko-reviews@lists.linux.dev
To: "Artem Dinaburg" <artem@trailofbits.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260930012143.95721-1-artem@trailofbits.com>
References: <20260930012143.95721-1-artem@trailofbits.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 30 Sep 2026 01:34:48 +0000
Message-Id: <20260930013448.7D78A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Shay Drory <shayd@nvidia.com>
>=20
> [ Upstream commit 3d5918477f94e4c2f064567875c475468e264644 ]
>=20
> mlx5e_suspend cleans resources only if netif_device_present() returns
> true. However, mlx5e_resume changes the state of netif, via
> mlx5e_nic_enable, only if reg_state =3D=3D NETREG_REGISTERED.
> In the below case, the above leads to NULL-ptr Oops[1] and memory
> leaks:
>=20
> mlx5e_probe
>  _mlx5e_resume
>   mlx5e_attach_netdev
>    mlx5e_nic_enable  <-- netdev not reg, not calling netif_device_attach()
>   register_netdev <-- failed for some reason.
> [ ... ]
> Reviewed-by: Simon Horman <horms@kernel.org>
> Link: https://lore.kernel.org/r/20240509112951.590184-2-tariqt@nvidia.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Assisted-by: LLM
> Signed-off-by: Artem Dinaburg <artem@trailofbits.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930012143.9572=
1-1-artem@trailofbits.com?part=3D1

