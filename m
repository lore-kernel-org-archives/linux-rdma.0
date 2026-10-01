Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9273F3AA504;
	Thu,  1 Oct 2026 12:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790856434; cv=none; b=Sm1sfF9s/P8FA8AOC+PTEdRmSEwr0VggHkZoPCGqZHd/oczZRlfLX6hWIghpBsxu1HvyS/SnVb7EIyat7Nm6juQFDfUyzqhUHiKScpKFJyUkcHYp7x2UV+4wjXiUZqJtd63Ahbt9VbU5vRqPpYHXEUPFMLbzyQNxuMyfa2V/CK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790856434; c=relaxed/simple;
	bh=mcMVQzXG95eO3ITecvGsmKsKXAEOB9s8JTPfoxFOw+o=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bpd6vHuSVw9r0gEF/HKNMifRTBToEa6l8fj6ytxTJ4Vn8DjpqbIOFbQLFjhRuvIFit7qO4CAdbzCxnYy6csXcHjxngnJdrS2pPOhxksUeYyYEkzSOxpezFuMuddIchaDFU+ml6YYzHXNKRjFXOoKJCa1kQyTK+nVWdXJj5cwnV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IOeGcL+6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IOeGcL+6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 159921F00898;
	Thu,  1 Oct 2026 12:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790856425;
	bh=mcMVQzXG95eO3ITecvGsmKsKXAEOB9s8JTPfoxFOw+o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IOeGcL+6YtKjEaHeeKJFd9qwbSjGygahNrfUxXJroc+UYL/uJxcNM406AAA2ct/g5
	 l7TwkY1HYtSXOrqY0KK9+PaqBy6BUZdTFBktoZYFhHXFLzIPnG2cPTU50xIkSWpfRt
	 TkMIq3RLUmmNoxrvH98/mvpSp3pL/X3BXXMLP4IbyzJfENZM+5OU8DEjqrWpOM4c0E
	 M0jm1dbPoeIigGpzeldLUxXpFZF9i7nhr0tOQWReNZrLjhn2IYFu2t+zMmo2zgzRYm
	 mCk+enUUAdPrQrGf6RB1/jfCZM0qByGK1mzXnbmdzGfG2R7C9XQ99ChVvUHLDLI27t
	 X0IpgHT39nGdw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 13/18] PCI/P2PDMA: Test the ACS P2P routing walk
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: kvm@vger.kernel.org, media-ci@linuxtv.org, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org
In-Reply-To: <20261001-fix-p2p-acs-v4-0-v9-13-1a8e0f50ddd9@nvidia.com>
References: <20261001-fix-p2p-acs-v4-0-v9-0-1a8e0f50ddd9@nvidia.com>
 <20261001-fix-p2p-acs-v4-0-v9-13-1a8e0f50ddd9@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 12:07:04 +0000
Message-Id: <20261001120705.159921F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> calc_map_type_and_dist() decides which ports along a path carry the
> routing controls, and holds every class's answer in one cache entry.
> Neither depends on a single register, so a table of them cannot reach the
> walk itself.
>=20
> Drive the walk over a fabricated fabric of two devices below a switch,
> with fake config space supplying the ACS Control registers. Cover the
> ports below the divergence, the three cases where two classes of one path
> disagree, and the packed cache, which the fabric has no provider state to
> exercise indirectly.
>=20
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001-fix-p2p-ac=
s-v4-0-v9-0-1a8e0f50ddd9@nvidia.com?part=3D13

