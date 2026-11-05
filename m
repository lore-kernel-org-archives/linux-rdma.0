Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793873876;
	b=VUQUqnwDguhXvzE837PV14P+GcG04Jv0dAQOu2JukLQpjTzDQlaGAHCkPaxPCocJi0/z
	 pBT7rB1ziPR9MlBJXUxm+SwqDbHS8h+FLQ3GDprc8n4XLMJAk+++A1FQpZsS5JHCxGb96
	 uTQM//flAw1moiw1nXzkzY9CR78JAL4ZlWlJ3FPeA2LUwKvIPq0+I+bUaWxJxBP4JJXii
	 ApRRnL5THY9JFo5je0J+YR6gkshRC4qyQXx/nDYRODsxkYJqbmol2SgqE0JbAS4nmket9
	 ejdVuywQPJH5Ib3ZxpLGz88dy7G37tUAey7AzDff9TGRUyifo7yb5ClC8ljljd5RpxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793873876;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=CKlQQcu/bsNmWjxulbgTG1iIeFjRU6Z75waIx0GlYIA=;
	b=FAxqSlVpH9zvJJR2w+4xJsu5/gnHegIPbQnPfLPYdygpGve5B8dThp8lM1ow4yZX6lzc
	 D7C9OkmtRGyD80e2FVEC+Pr1RB17G9wk8OzOtFiArGC33wGBsn+UJl1+U9gwZfeeJ9FUr
	 BBswB56sRLC1CToBjXVG2z09IJqYDs1hITzkTrBf23I3VO791RylpnvgmVdgD8lv7Nr+9
	 j9GjU43i6p54+SPVoBfjvdTTUqdeydgEoWZMNacLFCA2WEYmm1zosJ0Oc1ILR0uUQqZOD
	 ENyQX29nc0jMEZJj5R6B1XM0XdgUdBg8Pzl6Aq/xX9Lw2EoJOtzM45Y2leP0VeIgBDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GN5nWIDF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40C2606A329;
	Thu,  5 Nov 2026 10:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GN5nWIDF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B2591F00A02;
	Thu,  5 Nov 2026 10:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793873875;
	bh=CKlQQcu/bsNmWjxulbgTG1iIeFjRU6Z75waIx0GlYIA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GN5nWIDFBg9H+7J4LRhZkgfTStoUxzmiqa6/dleOvJ1rgsTuyyKHsNWLkcuwG3vla
	 sA9ox5uF0S0/mdqy+tEM9PbLX3iIFV+7wZHv8+MEErQV0MWtHwd3SYDV66nd8WSgm9
	 P/bFKVUM4UHakVqHORIZeU+eQrJ/M6Xpj8tRoYjAglhjfLiP9KZt3ipk9qcmrIhZCN
	 sQY6wpjDuPEdzFLhLULhAE5bWKw66sn3BV6/CmxRXMdZ8pCj7d6B7qPy/O4z6Q1VgX
	 wt991pO6jW5od171qrF4msCavolZhFhMDkHUiHmlPPFZ84aWWXD5IWqXgQRQqy4imx
	 EBL544wqb8P+Q==
Message-ID: <sashiko-outbox-198835@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 14/19] PCI/P2PDMA: Test the ACS P2P routing walk
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261105-fix-p2p-acs-v4-0-v13-14-3dd065907c3b@nvidia.com>
References: <20261105-fix-p2p-acs-v4-0-v13-0-3dd065907c3b@nvidia.com>
 <20261105-fix-p2p-acs-v4-0-v13-14-3dd065907c3b@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 10:17:54 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> Routing depends on which ports share each path, not just individual ACS
> registers. Sibling functions without internal peer routes must use the ho=
st
> bridge even when redirect controls read as zero.
>=20
> Drive the walk over fabricated switch and multifunction topologies with
> fake configuration space. Cover directional controls, nested ports, TLP
> attributes, hardwired isolation, ARI, PF/VF paths, forwarding failures
> above shared links and switches, Intel PCH register layouts, translation
> blocking, host allowlisting and packed cache values. Keep direct classes
> usable when forwarding is unavailable, and keep external peers and self-D=
MA
> independent of sibling routing restrictions.
>=20
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-fix-p2p-ac=
s-v4-0-v13-0-3dd065907c3b@nvidia.com?part=3D14

