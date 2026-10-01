Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788A744AB7A;
	Thu,  1 Oct 2026 12:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790856148; cv=none; b=aRzfMvWU0rpb/IS514UcGf4drYNeAPs2nmtSrXrcJoTGlee6AjMfr1kUBlMWeVERlxOPH0Q8IrTP2m1wN8ivxD0J+P5MiA1052Ll69ic6wk6Wo3knH1t87oJxY7+6pu1DUZAQbQ767c+DTiCsqwn4NVtpIQDgxJGG9u7oh26SPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790856148; c=relaxed/simple;
	bh=T9Y5WBVkeqh3B6k3lD2ODR47GJXMSgOk47kgZaLfOHQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=KQaRERgXf1BeJWnMvvC8EusghCQjfS262/TduuArb3vcnhHGOHdr64TS+w4P2BbB1TVA7jjfWFFu0c+qor7wQ/UgBhtzNKxHwiykO0r3LcVbs+V6xJ/H1TYQ83v0+ufQRKgFvpv6jR61L1rolfHV7m8/fx+/7sxrxrtUK973Pdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b76/f/R/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b76/f/R/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C99B91F00899;
	Thu,  1 Oct 2026 12:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790856147;
	bh=T9Y5WBVkeqh3B6k3lD2ODR47GJXMSgOk47kgZaLfOHQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=b76/f/R/pa0MGWfZGrSOt6xMvnKVxojZzZHPsKVT+sG35SeTX/dbD4upTwWOQTpg8
	 o22uhQal6+dPL/0bdaV40swYxK8vwcW2ntveooR6P/7bLvkh0hNZn/frL+HV1w/96D
	 gI2/Axt3h21YCZIxRyYTwTrWfX50CZRCDI+xv2kdJjdg3/qbmYH2Ye5K+LJVLsrjWE
	 UOzzSvBs78QpT7mAm+shciulkx/Js4z6DgXEvt2zoFR+jE0loML5OVhGdyfcXt5KGw
	 N123eTuylNEF5G+dAIcOmf5EUK8I8TLgUndtczdYRC5vEaCIE0FT072mYilHmZKHA0
	 4H/WODYfiT/iQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 07/18] PCI/P2PDMA: Answer routing per TLP class
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: dri-devel@lists.freedesktop.org, media-ci@linuxtv.org, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org, kvm@vger.kernel.org
In-Reply-To: <20261001-fix-p2p-acs-v4-0-v9-7-1a8e0f50ddd9@nvidia.com>
References: <20261001-fix-p2p-acs-v4-0-v9-0-1a8e0f50ddd9@nvidia.com>
 <20261001-fix-p2p-acs-v4-0-v9-7-1a8e0f50ddd9@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 12:02:26 +0000
Message-Id: <20261001120226.C99B91F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> calc_map_type_and_dist() returns one mapping type per provider and client,
> valid only for strictly ordered Requests carrying an Untranslated address.
> Clients that use Relaxed Ordering or ATS cannot ask what the fabric would
> do with their traffic.
>=20
> Add enum pci_p2pdma_tlp_flags to name a class and pci_p2pdma_map_type_tlp=
()
> to ask about one. The topology walk and the ACS Control reads do not depe=
nd
> on the class, so decide all of them from the one walk and cache them
> together, four bits each. Every class still answers alike; the controls
> that tell them apart come next.
>=20
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001-fix-p2p-ac=
s-v4-0-v9-0-1a8e0f50ddd9@nvidia.com?part=3D7

