Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D4A455176
	for <linux-rdma@vger.kernel.org>; Wed,  7 Oct 2026 18:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791398608; cv=none; b=Qa5OsrXyU1XhyepuMZRbBkcyOr6rTEB1F5D2KdMgHOm2OGKkfXpIvzDAbNacLWostQ8jqV9aSgyX5dLUVraMXogEaWX9w9nhY0VO/380Sp5JlmH200BFeLYakmbffabahC31z/DzQB8Ua5z4rEMF6kyxkvl+U6gvlBv6xThX4Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791398608; c=relaxed/simple;
	bh=xNqqJIBjeDPLhxdkLAIY2DhQ/AzEiPOwvu6ke0hyjdU=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=NY2QPquy1ll7fV7pGU0dPOMfvMgXdYBHkeFcYEcnahS7WI9FxYZvjoIBgDFOjQT0jl4mfiatRJ6ElzrHoU6XPUXHpjkDIL1Q5NzrnWxzgr9JVq/c5b+flqtJ6o7aO+SSb3KPVqQdZglyCHogy1UbTdFA4A0heng51l3/C6ztzWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fSH45ZRh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fSH45ZRh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D2111F00893;
	Wed,  7 Oct 2026 18:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791398607;
	bh=xNqqJIBjeDPLhxdkLAIY2DhQ/AzEiPOwvu6ke0hyjdU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fSH45ZRh5/QIV/W7x6pFFdtv0WEmusyvYIXHv6Brmv/x9XvWSKETGTtzDbd5IBuKU
	 PYmOwKj96WhzJu1TQ5VrV6XcHqG+zj5VVUrO5SSwa7di/8ixad/mmfDsVwg3JONJdQ
	 zkSA8zGE0IzvCIbiKNxsg/tWcEASRYhi+vm6u9P+vzJpbQW5H9oToP1Vc2Owc6v3sk
	 o6Jd1iwtLou6jH40G1m+miLcGsc0zvBMoFAzTCEotVQ1iAMpE35X3VPO8ZWByiQEAA
	 lkF5aSaYzvlnZokNRoAqasV8hGOdzA3QxRzSKENP4lRtP2sm73Bj9jmSRKtA0xfRHQ
	 6fyeQkBGagm3g==
Message-ID: <sashiko-outbox-163296@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 2/3] net: stmmac: selftests: use
 skb_share_check() in the loopback receive hook
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nicolai Buchwitz" <nb@tipi-net.de>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261007-nb-net-selftest-shared-net-v1-2-458369bfa1ba@tipi-net.de>
References: <20261007-nb-net-selftest-shared-net-v1-0-458369bfa1ba@tipi-net.de>
 <20261007-nb-net-selftest-shared-net-v1-2-458369bfa1ba@tipi-net.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 18:43:26 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> The loopback hook gets a shared skb when another ETH_P_IP handler is
> bound to the device. skb_unshare() does not unshare it, so
> skb_linearize() on a non-linear frame hits BUG_ON(skb_shared()).
>=20
> Use skb_share_check() instead.
>=20
> Fixes: 091810dbded9 ("net: stmmac: Introduce selftests support")
> Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007-nb-net-sel=
ftest-shared-net-v1-0-458369bfa1ba@tipi-net.de?part=3D2

