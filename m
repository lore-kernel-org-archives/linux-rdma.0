Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794911800;
	b=E4KeZu0gVDZKVdhYMwnB8q9rNBIG/oMYpmLRZauV96A3pCXM3ljlCCyptqwKjTVgwJ3x
	 bqOIBCRZOYAgaxReeNcsxBhs0MWwqOGSXgLSn2qgeaGd4bX9xolXJQsw0QAYpG/r4nEot
	 bC5IDtHOy2zM+kxeC0aQt0Yqe3/dB6/LlXs2bdzPkoCJMlm4mxWKSXC94JQKDzHZ7/YMQ
	 5WB8a82yncRNJpPQPBXONbYPo75/DugiIJtVdqaNjCgJJCoziKp7YjT0FGvgMzFWfmcHn
	 qLURLktXH6MRRKYMPed9GT20UfFYecd1vwLCGvkeZT/UR5LCnukCZGGu56Y3FjWBm9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794911800;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=6WFJMdFkQS4Vy0+Qj0V56NkiFkYI9aMTJWSs88hswbA=;
	b=Og/8CUncxOg2DAdKuio+lKGjK7enV8jlonuhRSg27DhwZF3FPB65WvpzOsfOiehOkX6F
	 1iWQZM3rqs5Hyfydgk05c++nhvUZsXatACkD8hqmwHZBj5DLCfsUkhtvZ1Ib7ugfhZ9jz
	 +dhpICQrD+Xdv/H4JtMTnJUP6XadGrs+JFcfJnP3y6R+vCDcVzk54tgCF8PIvfA23C4Rs
	 GW3YEPIP+/H5U5NGjIvn/VztCDM98F/+HFZ3EfD151s5MP0HYK1naEzY68fY61KIszRcK
	 0mKmihIJaqSEK2EEoqkWHo6OaNN73UDYuoWArLtwOzcYqwCWJz7atEfPZtYAHMtRM8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UX5mvZyQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE58606A33A
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 10:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UX5mvZyQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4284A1F000C4;
	Tue, 17 Nov 2026 10:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794911800;
	bh=6WFJMdFkQS4Vy0+Qj0V56NkiFkYI9aMTJWSs88hswbA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UX5mvZyQleNDfj3HRxaYS4K9V6TaQS6Quh4DLtWy8zsNnahe7MBc3PLIBYH0khUhE
	 3BNJOYdUzn38eWt4jyoB5hK1oxpMOIdUIaPM4xeRdg4DtH6j3BpjWMo6Qz+vBAZo8b
	 a4awC+dMsccpPnKjPeujwM+cDBpaDlQxD2HMHCN1Vwp5tcN5yrszYdOlKejl3EfwXe
	 3ISbwvD6H8wAZHmEd6bOFZQ4ZFKvHIfBQUhvyQDJqcNY5mJiuhQwUrpKr+MhsCycyJ
	 gcCXNkEuYVfL0nAwJQCgLai5XXUsZ9xIVLi5QMQ+GyxfUuytq86ioOZN9wdrTPqHf/
	 krn9Ulhd/7rhQ==
Message-ID: <sashiko-outbox-218630@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V2 02/10] net/mlx5: LAG, select the MPESW
 master from the live member snapshot
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261116103010.1129666-3-tariqt@nvidia.com>
References: <20261116103010.1129666-1-tariqt@nvidia.com>
 <20261116103010.1129666-3-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 10:36:39 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Shay Drory <shayd@nvidia.com>
>=20
> The LAG master is marked by the devcom PAIR event when all physical
> ports have registered (mlx5_lag_num_devs() =3D=3D ldev->ports). That does
> not work for a virtual LAG of VFs/SFs: those functions are unrelated to
> the physical port count.
>=20
> Select the master from the current membership snapshot in
> mlx5_lag_enable_mpesw() via mlx5_virt_lag_mark_master(), and clear it in
> mlx5_lag_disable_mpesw(). Unlike the regular path, it walks all LAG
> members.
> mlx5_get_dev_index() is identical for a PF and all its VFs/SFs, so
> tie-break by a stable per-member key is used - PCI BDF for VFs, sfnum
> for SFs.
>=20
> This is gated by a new ldev->virt_lag bit identifying this type of LAG.
>=20
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116103010.1129=
666-1-tariqt@nvidia.com?part=3D2

