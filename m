Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0913336D51D;
	Mon, 12 Oct 2026 13:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791810952; cv=none; b=MPJvlYG81u+PTFudUslg9tTZXmk8nv3f+Z3Y5RDnL+EYOQv8wHHA6PPCWbPKX+Ulhr4v4gJxSRDXwkFobPaqW9e/yyEBEozWBDa19PJLbbcwe3lyfNssTabyqNh86g1U4xgXs5YGnaK1d/0yy2HcZcEX2LNqc/RkOLhKxEtYb/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791810952; c=relaxed/simple;
	bh=9K0G3pe7nJ1H/EdXv5+Mf0RJTwGuH5nexEMHdWSZqaY=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=j1cHT1gCPZRU4JmpN8UmOefM4ey8CrLdBOys6yJ4GVEtjVY9ibOJoDrqJR1gpaDP091/7uWo7MK+ycYTRqMgsDu0llNc1BX78Z36wOxF4HoyfZlgXpfUJwtujP8CNLgZmPkZNz9meARBnkOWgKFKkT4KGMr4U9NuWtawktNfC3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ioTJi0Ic; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ioTJi0Ic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 656A21F0089B;
	Mon, 12 Oct 2026 13:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791810950;
	bh=9K0G3pe7nJ1H/EdXv5+Mf0RJTwGuH5nexEMHdWSZqaY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ioTJi0Icn72IoFWqhyYezS2uydt/MVIY7c88Ve0sZ2AUqAj7aiGFa9u/DZ6uuN+5O
	 dJTbcowmOysMrykfGRu/8RxBlxcu9A9j26FyYpSVrKDB2G8XnLRtddJsjLTVtX6r0f
	 lWhzGyx/Z67BXBoBeXHFQwAV6eAXSQKrbBqCbTXecCS8FtShYkeK5KJOEqqWgA995X
	 u+cZAf6FKE4Zdm0XFZJ4npQyd/V/+D02b+EgxjmldItR4NkFXiHXixl7/Zmy+/sNbE
	 DKfrVyj/M3zfQGIlgMJJsjtKbuSTKEAFM7EIijePmz3v85P1f8Q4X9rtvk6lR3Xsab
	 B87fBfxAygLAQ==
Message-ID: <sashiko-outbox-168156@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 05/18] PCI/P2PDMA: Document directional ACS routing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: dri-devel@lists.freedesktop.org, kvm@vger.kernel.org, media-ci@linuxtv.org, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261012-fix-p2p-acs-v4-0-v10-5-6ffe7b7a4517@nvidia.com>
References: <20261012-fix-p2p-acs-v4-0-v10-0-6ffe7b7a4517@nvidia.com>
 <20261012-fix-p2p-acs-v4-0-v10-5-6ffe7b7a4517@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 13:15:50 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> P2PDMA documentation describes ACS controls as path-wide, although Request
> and Completion controls apply to different transaction directions and only
> affect peer-versus-upstream decisions at the path divergence.
>=20
> Document the client as the Requester and the provider as the Completer,
> the divergence port checked for each TLP direction, and the conservative
> handling of unreadable ACS state. Clarify which controls disable_acs_redir
> changes.
>=20
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-fix-p2p-ac=
s-v4-0-v10-0-6ffe7b7a4517@nvidia.com?part=3D5

