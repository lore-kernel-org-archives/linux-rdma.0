Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1D71EB19B;
	Fri,  3 Apr 2026 00:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775177133; cv=none; b=XVytIFsyZzW0uxnBk/bnA9Va8l+gcQ8I8NvIhYFpdZpv2TWH3RjvNG7pSI7XwinVWqx/RPrcwpkDfaeQBpcIcQCVcVG+j2TWWfnoJFkB1WJXvFOmdoCVCJI6tJvFlBeNmjMhz5ADQ1Twyy2sv7nInfFgtMeWhhvpbAefSPmSoiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775177133; c=relaxed/simple;
	bh=/DInWGNwDvNFe4Pf3DDjyCfmdpW1gZXmLQpkI6ypYrc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pBO1+cyIqKS0yMAjHU7m0eZqw69tDE0e2sw6503lEznkA20OP9vjV1VzUJzPH8FWTJw0DFesSJZ6QeAqHy6PZjC8lxHU4c7hPvu/W7fuYUvrhRv89VvCtzDHFFwEql5p1EV6bYx27de11yPPrvuQGraPEx9o/x7p7lKsnkbs21A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PSR8U4/O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PSR8U4/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EAFAC116C6;
	Fri,  3 Apr 2026 00:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775177133;
	bh=/DInWGNwDvNFe4Pf3DDjyCfmdpW1gZXmLQpkI6ypYrc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=PSR8U4/OpaV/rOxBLbz0TpKg/nxeFZ9fzgFhcwC10NcZ9vTqyMCCJPSq9bIQhzvup
	 kKnwUhv/086EPGUJCp81aWF3tLIIjqeH5ldUGMsGL4oecXhkNteF2bp6Vwxtgg4uJ1
	 PD9Q/fD/JHeKPBegvSel069o8mniek19rppJFPl6TT5ts8349pYHSo4jSxGhnmy32s
	 zg76ChGC1CpZ5aR8qQkjEeMUDlb1osPJ/qR3LHZKzSJaku9sK/3hQZZp7QcPpey8xs
	 yCYpnC4j9Gx0KWSDhxLq54x5LehswHNVYWbK4TPIAcESG2Li4IVNNqGfUnbBKAHcjH
	 QH/rS9IBFHFpw==
Date: Thu, 2 Apr 2026 17:45:31 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Shay Drori <shayd@nvidia.com>
Cc: Tariq Toukan <tariqt@nvidia.com>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Saeed Mahameed
 <saeedm@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, "Leon Romanovsky"
 <leon@kernel.org>, Simon Horman <horms@kernel.org>, Kees Cook
 <kees@kernel.org>, Parav Pandit <parav@nvidia.com>, Patrisious Haddad
 <phaddad@nvidia.com>, Gal Pressman <gal@nvidia.com>,
 <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net 1/3] net/mlx5e: SD, Fix race condition in secondary
 device probe/remove
Message-ID: <20260402174531.33ff0ff6@kernel.org>
In-Reply-To: <53c3bf8c-0b0e-4986-91f3-3eec53fc2b1a@nvidia.com>
References: <20260330193412.53408-1-tariqt@nvidia.com>
	<20260330193412.53408-2-tariqt@nvidia.com>
	<20260401200842.79322a24@kernel.org>
	<53c3bf8c-0b0e-4986-91f3-3eec53fc2b1a@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 2 Apr 2026 23:03:10 +0300 Shay Drori wrote:
> On 02/04/2026 6:08, Jakub Kicinski wrote:
> > On Mon, 30 Mar 2026 22:34:10 +0300 Tariq Toukan wrote: =20
> >> From: Shay Drory <shayd@nvidia.com>
> >>
> >> When utilizing Socket-Direct single netdev functionality the driver
> >> resolves the actual auxiliary device using mlx5_sd_get_adev(). However,
> >> the current implementation returns the primary ETH auxiliary device
> >> without holding the device lock, leading to a potential race condition
> >> where the ETH device could be unbound or removed concurrently during
> >> probe, suspend, resume, or remove operations.[1]
> >>
> >> Fix this by introducing mlx5_sd_put_adev() and updating
> >> mlx5_sd_get_adev() so that secondaries devices would acquire the device
> >> lock of the returned auxiliary device. After the lock is acquired, a
> >> second devcom check is needed[2].
> >> In addition, update The callers to pair the get operation with the new
> >> put operation, ensuring the lock is held while the auxiliary device is
> >> being operated on and released afterwards. =20
> >=20
> > Please explain why the "primary" designation is reliable, and therefore
> > we can be sure there will be no ABBA deadlock here =20
>=20
> The "primary" designation is determined once in sd_register(). It's set
> before devcom is marked ready, and it never changes after that.
> In Addition, The primary path never locks a secondary: When the primary
> device invoke mlx5_sd_get_adev(), it sees dev =3D=3D primary and returns.
> no additional lock is taken.
> Therefore lock ordering is always: secondary_lock =E2=86=92 primary_lock.=
 The
> reverse never happens, so ABBA deadlock is impossible.

And the device_lock instances have separate lockdep classes?
So lockdep will also understand this?

> Does the above is the explanation you looked for?
> If not, can you elaborate?
> If yes, to add it to the commit message in V2?

Sounds good, please add to the msg.

> >> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drive=
rs/net/ethernet/mellanox/mlx5/core/en_main.c
> >> index b6c12460b54a..5761f655f488 100644
> >> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> >> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> >> @@ -6657,8 +6657,11 @@ static int mlx5e_resume(struct auxiliary_device=
 *adev)
> >>                return err;
> >>
> >>        actual_adev =3D mlx5_sd_get_adev(mdev, adev, edev->idx);
> >> -     if (actual_adev)
> >> -             return _mlx5e_resume(actual_adev);
> >> +     if (actual_adev) {
> >> +             err =3D _mlx5e_resume(actual_adev);
> >> +             mlx5_sd_put_adev(actual_adev, adev);
> >> +             return err;
> >> +     }
> >>        return 0; =20
> >=20
> > Feels like I recently complained about similar code y'all were trying
> > to add. Magically and conditionally locking something in a get helper
> > makes for extremely confusing code. =20
>=20
> Do you think explicit locking API is preferred here?
> something like:
> new_locking_api()
>=20
> mlx5_sd_get_adev()
>=20
> new_unlocking_api()

Readability is hard, I'd just push the locking up into the callers TBH.
Looks like there's only 4, the LoC delta isn't going to be huge.
