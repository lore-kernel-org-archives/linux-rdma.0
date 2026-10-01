Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F0E30569F;
	Thu,  1 Oct 2026 12:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790856432; cv=none; b=h4ufN7TrpYySPkGEMIM11bDc96c9qEL7rJWadvXVq65T4mIPkQ0vyewyxhsYGpHEmZ+bnBQ/AFBMH2CpqxevgODoi0E/iwYCSRiwlYRuO8PCAgrE0ugJHnem4jUryyvAnAOetUbSN83MFs5QN32ihIQbs5F83Mem69tFCKRGWOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790856432; c=relaxed/simple;
	bh=tJODK09rrvwoeThByl8zpjHYPzoO3G/XFWoxUU8cenI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kaflLxqSYQUXw5702ACpjv3XcpqBfEYVfYrlf4TMvpsI7YsH1gL5AW2/s19jjwOqo7aPNB2YvWQLAeL9LeKOiD5Bm5Tk6aIAulQAQfqFcjhb9H1RBZFsul9F1Gl3wUn1KleQqe6Dqb69b2gmQJtzCTmYoOQLrXUV8bzTO3n7kMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HWbGvBnd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HWbGvBnd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6181F000FF;
	Thu,  1 Oct 2026 12:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790856419;
	bh=tJODK09rrvwoeThByl8zpjHYPzoO3G/XFWoxUU8cenI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HWbGvBndHM0VDI/5CiKKzZOGZaDEyQ5kpHg1TqdY37p34YlhlfQFZEI2GPOGwQnu6
	 B+oWKi3laed4pknGiA1NU+CEk9E30OTnevRdFXhsM9ORs4hX4HUYJQ/BbXxEZaE9uV
	 DthRXSv//Kfde3lJKIcCiRRG+DMyo2FujVDkNJRyoGA8I4Hdmj1nWkcHiM74WxT0P6
	 wDwgGpWlioCZElS7YQjdfa1oR6lqlf1Y7v2KFYM3aYTSX+498f9uo8fcb2f3m0szCo
	 a0YybhhTKnG5ugXhFB5Z8hTTnA1x4nu2FKmKMf/FyfKUCqxvZkA7KHWJyv5XmakM4A
	 29J1ggqti1Ihw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 11/18] PCI/P2PDMA: Log detailed ACS routing
 diagnostics
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: kvm@vger.kernel.org, linux-pci@vger.kernel.org, dri-devel@lists.freedesktop.org, media-ci@linuxtv.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261001-fix-p2p-acs-v4-0-v9-11-1a8e0f50ddd9@nvidia.com>
References: <20261001-fix-p2p-acs-v4-0-v9-0-1a8e0f50ddd9@nvidia.com>
 <20261001-fix-p2p-acs-v4-0-v9-11-1a8e0f50ddd9@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 12:06:58 +0000
Message-Id: <20261001120659.3D6181F000FF@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001-fix-p2p-ac=
s-v4-0-v9-0-1a8e0f50ddd9@nvidia.com?part=3D11

