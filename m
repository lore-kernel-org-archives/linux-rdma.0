Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E52533EB10;
	Mon, 12 Oct 2026 13:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791811573; cv=none; b=Ntpd8jSdygUyLEY1Wzq8t2XwLk/LsLIF3eRdS6TRR8DcSTp/9EdIU4y0nUAVA6IMqoStw57LJdLhBy4Zl3KF5fvyU8aNy1goDvDnqjJwjeVuqkeEVITq7p1eBYcOtl796/aM5wWdjnX/jHwX+PLeAe/Sm8hJ8KlKC/LNsh2ohHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791811573; c=relaxed/simple;
	bh=Dz1utKBSPBzyFUvGOG3ZYzSOmqXlU+lsMevcy2nFCjw=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=BltFHwWF/Bgs/l9150s6Btk2SR3YvQapmkb5X+rWkg3gv+JICUpGkouUKkgw3XdPrbuc8CwqdW+nqW3rjOB4x6ohXWCElOKhaz9EEJl1sXy/ctsOhUN99fR9SEKTCHD8gbRfSMjebzESzUsUFmi7eddLiFuEetwzYXoY7lgSRmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RtFz4ujj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RtFz4ujj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319B11F0089B;
	Mon, 12 Oct 2026 13:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791811572;
	bh=Dz1utKBSPBzyFUvGOG3ZYzSOmqXlU+lsMevcy2nFCjw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RtFz4ujj/X6dZc/aSi25wbF19egIqFBzWYaljcse+dL7Wf0SnCHmey9Ms/CZBmKDq
	 mkSWOhP+/gvFsNZ9dcf0tMbIkLkImNJImBRmCKqV7tslXlrM7HZJt46NbHGdci3UZ4
	 1tiGVP8BFini49pMglJTKy601MdxUjCFiAFk3TnfPkhLfw0QvDAhlA+Ef6ociogeZU
	 Z4Qvfmq5hgwi+3AKRse2hFVyODBmaiGCULRVLN9Oia8JWTP75jEljI9dWzoFufZ+88
	 kkuvABkh1evOkYMeF0IwoaH8zEu+CCsWCAgU8QKXh+/HcVMyt/TVayK+JolD/CiE5L
	 XHFjBY1YKAhLg==
Message-ID: <sashiko-outbox-168176@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 16/18] PCI/P2PDMA: Let a client declare that it
 selects ATS per mapping
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, media-ci@linuxtv.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
In-Reply-To: <20261012-fix-p2p-acs-v4-0-v10-16-6ffe7b7a4517@nvidia.com>
References: <20261012-fix-p2p-acs-v4-0-v10-0-6ffe7b7a4517@nvidia.com>
 <20261012-fix-p2p-acs-v4-0-v10-16-6ffe7b7a4517@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 13:26:11 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> The PCIe ATS Enable bit covers the whole device, so P2PDMA cannot tell
> from it whether a client will translate a given address. Most devices
> translate any address once ATS is enabled, but some choose ATS per DMA
> mapping and can still use bus addresses for the rest.
>=20
> Add pcim_p2pdma_set_ats_per_mapping() so the driver of such a device can
> declare that before P2PDMA starts treating clients with ATS enabled as
> translating everything. Keep it in the device's P2PDMA state, which
> already ends with the driver binding.
>=20
> Reviewed-by: Thomas Hellstr=C3=B6m <thomas.hellstrom@linux.intel.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-fix-p2p-ac=
s-v4-0-v10-0-6ffe7b7a4517@nvidia.com?part=3D16

