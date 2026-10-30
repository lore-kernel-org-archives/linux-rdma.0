Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336022;
	b=L6iiM3CP2RELcf5V4ABsPufZ24WXFj/HA5UIpgfwLVS0C94kC7VQsfi3yLIX/NWsZvs7
	 fxsM/ua1Y2KqXpgQxQTzY+SIg+JVwPVZnReW4k/tbQs7Vr74Odpv63BEu2f1kzzofZyJY
	 JrDnBFDs8XMR2/FoDR7QuuFg3i7Bw7NwWtx3aZ0kkmmcADOGr13smQb5txHUUWnRsWlJG
	 h59DdWiAK8avC3Qd+h/nRfzP414Wjx/4l7hSQ+D25ypzPeWqi7zZodRSX7oRBS6jAag/e
	 oI/0F8yVKOVKQZQJp7P3Y4EkiBNzm+W90jr/U4yVkaS0MdxDhQ60tgVFsWfVT+L5Fbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336022;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=+pE+6K0OXA/7sH6jRQ6Rb4VWM9wkQYG5CRaRIJ/6D9c=;
	b=ivmvhQrRSEoXGxzJis+DoLGNm08eFOXyi3g2zNqs4kulIYLkM1yvysOXNTGTMBXhjjKA
	 32LrFFQpUZqJWtiH/Aj1ybBis9YLGoitZRzMLZfCg2hUPK/GqzQQ05Iyh5lfF6Fha7Z4U
	 19s2OSTabkAShcGnaBwCBRtX5qDTUgmHkND5tziHcBsQLPC194GWXXSs7T7q2tJxLRHyX
	 FzAND3f1tDBR3GUAz/PMfrQqU2MkRis9rvkZnh/QzxGCBpHrj89RLDmdPB20WCreJccNg
	 fPCCZ8C8W/0shJ+AdRPSla17OU+yPaGA/qYSVSwy9kN6MzYOg0MfaZRgEcRWgl+5h4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ftcoxp17;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2951606A31F
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 04:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ftcoxp17
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6266B1F000C1;
	Fri, 30 Oct 2026 04:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793336022;
	bh=+pE+6K0OXA/7sH6jRQ6Rb4VWM9wkQYG5CRaRIJ/6D9c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ftcoxp17YR1hbyMYoc7scvIofjaaahBJpYoRnD3XsEIXYklFnr2jPpN3nzVW6bNJI
	 4ALCIw62uSsPVwuiqr6sW9mC/onaNFWn8hkBmCCPPf0GEvSfaypPWDIgWQUeLJgJCY
	 ZIblg489ye7kJi7Gcw2+bb9yc/dBKz7lEbPYl0s0cJ1oVE/rb/+IGlSzH15H4nEa7o
	 PP9ISWTMMZx68iMfCIJ+ebukJvBPrZEgRtq7K5DNgyhyPkT08kSFF6QkKPhwCKEKF6
	 C/kohElfsIyM2KnMOYs4bNyw2GzYip0SjwzoWdgA3lv6euDGtadB3pl0ajEdXbUHjy
	 Pia2xErjk3hkw==
Message-ID: <sashiko-outbox-190338@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH mlx5-next 4/4] net/mlx5: Extend query_esw_functions
 output for multi-function support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260428053851.220089-5-tariqt@nvidia.com>
References: <20260428053851.220089-5-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 04:53:42 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Moshe Shemesh <moshe@nvidia.com>
>=20
> Update the query_esw_functions command to support a new response layout
> that can report data for multiple network functions. Setting bit 14 of
> the op_mod field selects the v1 layout with network_function_params
> entries instead of the legacy host_params_context.
>=20
> The query_host_net_function_v1 read-only capability indicates firmware
> support for layout version 1, and query_host_net_function_num_max
> advertises the maximum number of network function entries.
>=20
> Define a new network_function_params layout and a net_function_params
> union that groups host_params_context and network_function_params.
> Rework the query_esw_functions output to use a flexible array of this
> union, and adjust existing driver callers to use it.
>=20
> Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260428053851.2200=
89-1-tariqt@nvidia.com?part=3D4

