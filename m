Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953683242BD;
	Mon, 12 Oct 2026 13:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791811133; cv=none; b=j2/ynoD6yrcek7IhgpZaM+ygc7677ncZImwxtqtRYlx6swkAsdx9GWP29x8ieFYD7xGLGIm5soM4e9wEGo9KeVLxGYG9hfwjw71BW2jscOb9q0ChIJki7Kn2m6sVbR6fbIX2Ok9mW5Rp1CQAzizOCsl4nKIiwsBHZMdLfWy3ewM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791811133; c=relaxed/simple;
	bh=6nLpGzCs4ZJzQFQG/eZFkypqKHhs9/FdIHKlTsSnmOs=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=G26XbOggqxsqhfimjeZjJ+1ys5iNGqPWCm/+s9toLItFt+KKmub/Wt1HDGrtEn27/iEtRa+tcN1SHEbkYTZbFRs75J5mm3S+Cv5RL37fycZqpcyGuUxgDxjnwNdSTSPP+mB8X9vwqgKXBF7dUkv7lpQMgMGbNdZP2ZcqW4mfREY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L+c8EZaB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L+c8EZaB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E25111F0089B;
	Mon, 12 Oct 2026 13:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791811132;
	bh=6nLpGzCs4ZJzQFQG/eZFkypqKHhs9/FdIHKlTsSnmOs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=L+c8EZaBZ8mTwZJy15xn0LycE1KNEZGdfbkqg0LHoueL2hS8QLf3jX+tKuXRyp57m
	 FoEf6joOyq2dywMeoMGyXeDSZrppdbJXpV8uO7svumWwd/b99oTywVtcWrZBh6VbXT
	 UW+pb0rf/Jm55NqNPyCAhS47CsK8/MoYG4iCDPJ2Qaj9Y7Xo+jsK/ON8yxwUdA9S+4
	 MpVkebjxzktNepqrGXX96TMNN/2kyfWjn+uTyceOPJqpGF1mKZUkFy9+KbNlLhlqJ2
	 B3SCZFSJVc65lzBgxKqXocAVy3v92pNF6KdlXI8cUxP3iWOUdFVg441rDVY7d3sW9z
	 1OE9M/U5vudXw==
Message-ID: <sashiko-outbox-168163@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 07/18] PCI/P2PDMA: Answer routing per TLP class
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org, media-ci@linuxtv.org, dri-devel@lists.freedesktop.org
In-Reply-To: <20261012-fix-p2p-acs-v4-0-v10-7-6ffe7b7a4517@nvidia.com>
References: <20261012-fix-p2p-acs-v4-0-v10-0-6ffe7b7a4517@nvidia.com>
 <20261012-fix-p2p-acs-v4-0-v10-7-6ffe7b7a4517@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 13:18:51 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-fix-p2p-ac=
s-v4-0-v10-0-6ffe7b7a4517@nvidia.com?part=3D7

