Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD62563FBC
	for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 18:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792003455; cv=none; b=s/ny5Cl8Vu4O26ZV6hAlhCnFTHxdbGjKpMEm8uc2oIK+r6GyK9q97HzH8CITaQyvELUtRCa4/frHOYeWpBBCxYrypg/E94ZTFvAskc0wU5m4DXDgP5MS3xJgVe3riaKMfxI5uuw75mgtt+ruR1VDjGxAIqoTiPNO9hol4z68ST4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792003455; c=relaxed/simple;
	bh=1gmt4ewtI0Js40kvEqFixa+IWZvamssLYUxsgZsfQms=;
	h=Message-ID:From:Subject:To:In-Reply-To:References:Content-Type:
	 Date; b=oDyT3RnpGNiGwqWSVXebYAhVsSfVGD8PLD8/IEqwuo0ZqRbfc1bmDO9+soUMWBHkFIqXHggXZNwm7VIXYkqQNL1H5P71XvNROCrc3KOaMMiFvOzRbCRa2FHnqfyCuSl4C5+Yh+SjUaUJ8gjpQb4nOARkXKwyOiyCap8SJ1IZPEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k7gGWh9N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k7gGWh9N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BBBE1F000C5;
	Wed, 14 Oct 2026 18:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792003450;
	bh=1gmt4ewtI0Js40kvEqFixa+IWZvamssLYUxsgZsfQms=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=k7gGWh9NB93vhN1OgVG2NjKwFn43zu85ddSHK/5zDbb7aeuGClH+xUwF0NDtHuRQZ
	 lPnL4DDDgCNJx0TvH2IlXiIQTMO0CIwh8QFemMqARMnJaGR3mG+nP2vnCgP7AQtmBE
	 oejicpeW2MSPrFIGnO4+f9uDNnimw4yEl3EQtpGyaw880uYxwClK99miKXkqgLKyAe
	 xUXJ5VOg8fNqblTIWvZW/mPhw1jM5qZQ7GAh0jlqg8uHVEi0G/JXfCwF6NffKhczN7
	 5lQWusK8d+0U0qBKSVSlm4Jn44Ocv/kdNp7ffNANtZA6ro+7WCZouvdjJAJLp10YGD
	 7NzuebKNjd96g==
Message-ID: <sashiko-outbox-171725@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v3 2/6] net: skbuff: add napi_pp_get_page() and
 use it in tcp_recvmsg_dmabuf()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mina Almasry" <almasrymina@google.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261014173945.373295-3-almasrymina@google.com>
References: <20261014173945.373295-1-almasrymina@google.com>
 <20261014173945.373295-3-almasrymina@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 18:44:09 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> While napi_pp_put_page() releases a page_pool pp_ref_count reference on
> a netmem, no symmetric helper existed to acquire one, forcing callers
> like tcp_recvmsg_dmabuf() to open-code atomic_long_inc() on
> niov->desc.pp_ref_count.
>=20
> Add napi_pp_get_page() to pair symmetrically with napi_pp_put_page(),
> and use WARN_ON_ONCE(!napi_pp_get_page(netmem)) in tcp_recvmsg_dmabuf()
> to match WARN_ON_ONCE(!napi_pp_put_page(netmem)) in
> tcp_release_user_frags().
>=20
> Assisted-by: LLM
> Signed-off-by: Mina Almasry <almasrymina@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014173945.3732=
95-1-almasrymina@google.com?part=3D2

