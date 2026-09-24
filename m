Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD9F35CB9C
	for <linux-rdma@vger.kernel.org>; Thu, 24 Sep 2026 06:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790232634; cv=none; b=VfoJH85PKOqODxN1phwnaP2fmpl8rkKXqk6r9abPugRZGadtFNzCrO90QH+3dfnb6qHSRY4y3YA9zo72UTmC+BvrvaCLo2mnNVH04s5wRDYERpZ00KyqJiS1/PBYFXuk8KwObXj4AnIrdWTUt6Hx+x8fMBL2RZQI2LHRk/aQ/RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790232634; c=relaxed/simple;
	bh=amQKjawHqz6GjtdpUqiZo6C9Qu9eWP6k7VMVNgmy7IA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=MZ50bVPoW5CnHLMa+g9stbPrToLLOgH8IXPI0memL9bwuOdMymSJyKGPdpnCfUWOxezeLwcjBqnFedKR9O5WuogcelrFzi9dZXay/PLOpwz23rw43Gg06OxYgQtsmagpPhfPpF0CHfCbZs6EHzhbDmyfoTS/nyal/bZz2FsuUGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XXsLmhrP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XXsLmhrP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 909E91F00893;
	Thu, 24 Sep 2026 06:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790232632;
	bh=amQKjawHqz6GjtdpUqiZo6C9Qu9eWP6k7VMVNgmy7IA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XXsLmhrPLy0bld8L4RRKdsJZ7N4zTeJQayco8+FW4TmZ27ZR39EsPRZSpJk4ZMwDG
	 j9tQb3D18yR5U4/+6j7cAgRqx5ZIaJqPpYziRb2T2jscdEFSB6beAyB1rkCE4yaZP+
	 aOtm5N4fn+3LLqkT70lhBTyPlCaEZjIc6PrAjqnFN5AxAT+zLIyIA64Y0QqUPKEGJy
	 91SENkc9hS1r49t2IQ8qaay3bjWSXrn/gzPPA+ZdAXsqbUWUlMmtlppDeEbVcUl3Vt
	 SkguZqb4/6ZDmoAtmtPNPuFmv8hSo/3P8TlaWw9kIPUitnPQBqe7R2a1cmzPxvH/s8
	 UTBz0sjNeCqBA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v2] net/mlx5: Fix slab-out-of-bounds when handling
 team device events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anirudh Virdi" <avirdi@redhat.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260924064244.94045-1-avirdi@redhat.com>
References: <20260924064244.94045-1-avirdi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 06:50:32 +0000
Message-Id: <20260924065032.909E91F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> The mlx5_handle_changeupper_event() and mlx5_handle_changeinfodata_event()
> functions check for LAG masters (which includes both bonding and team
> devices) but only call bonding-specific APIs. When processing team device
> events, calling bond_slave_get_rcu() and bond_is_slave_inactive() on
> team_port structures causes KASAN to detect an out-of-bounds memory access
> since team_port is smaller than bond slave.
>=20
> Fix this by wrapping the bond-specific API calls with a check for bonding
> devices. This allows the function to still process LAG events for both
> bonding and teams but only calls bond-specific functions when dealing with
> actual bonding devices.
>=20
> For mlx5_handle_changeinfodata_event(), keep the explicit bond check as
> mlx5 doesn't handle state information for team ports anyway.
>=20
> Tested with Mellanox ConnectX-5 on Linux 7.2.0-rc6:
> - Bonding: PASS (no regressions)
> - Team device: PASS (no KASAN errors)
>=20
> Fixes: 54493a08e21f ("net/mlx5: Lag, record inactive state of bond device=
")
> Suggested-by: Mark Bloch <mbloch@nvidia.com>
> Signed-off-by: Anirudh Virdi <avirdi@redhat.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924064244.9404=
5-1-avirdi@redhat.com?part=3D1

