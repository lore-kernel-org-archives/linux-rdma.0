Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF6F321457;
	Mon, 12 Oct 2026 13:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791811091; cv=none; b=VquQt+2zOHTwGVVVepstBFeEJhPkWB1cNUQtL1ssXGyInSIG3dhsU+M7BAq53jlcSe2fHovuiVRsGscuuOI9AuyYl74wrT7U5Gup9YCmNZl8HhRL6HhPU+7ioXXjEdqNAKjYgFMawCt5wioaVGnfLaSfWzTtJ+DG+AVxdOJ/CRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791811091; c=relaxed/simple;
	bh=75nruxqYQwVIDce8q/U0wm5ZZoAMN6VNOdnGB3FhShM=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=UwKROxunSy1SBZ92UYBpEpgYzqJfu9zDV5bIfUI7xe2qAAXN/gJzNW1QLZ+KlCMSYxUJIinynnC2hrjCl/rw/kD9wtaohim76wR7P5F7VhEyFn1c0/fr4hZTcJBopzLqyE8CGqwQ7FAG3G+lz72uE7CC/4ETzJMggdkXJXBU7vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bjcryIzZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bjcryIzZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77F2F1F0089B;
	Mon, 12 Oct 2026 13:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791811089;
	bh=75nruxqYQwVIDce8q/U0wm5ZZoAMN6VNOdnGB3FhShM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bjcryIzZLIsnfMT7/liLq7vuMp0F+wmd0Wc/y7CSWdiFEku+EZ6AFAiuhdG4aSuEX
	 fvOrPEnW+0uG2LQcZZHtODxG49UVepi9NhZqTgZpbu3yoPwuimH/RGJmw4j7LXuKdE
	 NWWhUfDkAdS3sHoCNrJbTkYFA+7tAOvp6f+frhNmOuu68oHcrXN65pzpkrl3Kud9wS
	 lqOIoQ/BRu3cHsG4Jrsl/TGUI6WY1WqrSOCj5C3tdiAyfVdZf21T4hRYuqTCnNZPqI
	 Zd35Dn1soQHdZh7JNHVpsPq+5gf3mGxGHBhZdEcbu0TjXFYr8uQ5r0wtFGbfp2UHQV
	 cljAYmvaXJj+g==
Message-ID: <sashiko-outbox-168160@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 11/18] PCI/P2PDMA: Log detailed ACS routing
 diagnostics
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org, media-ci@linuxtv.org, kvm@vger.kernel.org, dri-devel@lists.freedesktop.org
In-Reply-To: <20261012-fix-p2p-acs-v4-0-v10-11-6ffe7b7a4517@nvidia.com>
References: <20261012-fix-p2p-acs-v4-0-v10-0-6ffe7b7a4517@nvidia.com>
 <20261012-fix-p2p-acs-v4-0-v10-11-6ffe7b7a4517@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 13:18:09 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> When P2PDMA rejects a mapping, existing warnings identify only the final
> ACS or host-bridge result. They omit topology, live controls, divergence
> ports, cache state, and intermediate routing decisions.
>=20
> Emit debug-level messages for verbose calculations and cache lookups.
> Report both paths, decoded ACS controls, directional decisions, host
> fallback, and the final mapping. This keeps incidental unsupported probes
> quiet while allowing the diagnostics to be enabled when needed.
>=20
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-fix-p2p-ac=
s-v4-0-v10-0-6ffe7b7a4517@nvidia.com?part=3D11

