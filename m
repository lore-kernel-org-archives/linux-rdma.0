Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9960C3F8709;
	Tue, 13 Oct 2026 14:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791902835; cv=none; b=Als8uyeAIDb1GoW2AOLcYCAOnGEyGx0piaH9EXtKkTUex8kIkSc/+C+r9rjexX1QE+1v5eHWQazCqzfOma0wX8JTSjyIDVcGZnTKePyKU8qX+4D+75iat20koW/HOhIj3+2+qDsUvbVJVcHJb7Omy2kq6i+9Fpz6DmdmmLjwIuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791902835; c=relaxed/simple;
	bh=vwQ3Newl9YZ2eAs3ka9CYT7aKuSeM9lNkIcwxb0Q/0o=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=QJg1780vJCMxeBMR0ScBIxULb1r6+fMy4bwnXmvoRB0z3ofvk6gT9cbUdWoEA5wTt1qbidoRpOf+LkBzT53pP4dFQKNpuG/p1OjZg701p0SK/jhKTQ20VdaLQUbqODmqqY7v+R6FD7ys8rtO7i4W1z7bTyV5xWGzMPJeP2KEtRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hMyKOvZ1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hMyKOvZ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C32E1F000FF;
	Tue, 13 Oct 2026 14:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791902834;
	bh=vwQ3Newl9YZ2eAs3ka9CYT7aKuSeM9lNkIcwxb0Q/0o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hMyKOvZ1Msg9vkNAJ/U9c2mDIHCwKjG/BiFRPBGuD3WI7QmnurlukxjqvxLc6/lAp
	 7CoeB2f119vGWP9atWqmF8iNm3cldTKdgRI55QEP9ntE/dMnSwypol2pWptCeW9wiK
	 hyudGJF6YC3ui97bAfv3wCXiyF6Snm8jMWptE91zk4NpdX+g3Q8GKeJ3yItdOsKqn7
	 U6FYBYw/8OxWsuSkhMY/G7SnWN/qXfAdtg1Jp0fjY/2Xevi/qWF8dGldIYeVvbmArJ
	 ee/MukroJEorUvYLTJU5Ojnv6UxpnGN2gbzOG8RZqzHwDVOvKL7Q1BnLpRIULd9dtP
	 Qk/T23wVSoCPA==
Message-ID: <sashiko-outbox-169935@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 17/19] PCI/P2PDMA: Let a client declare that it
 selects ATS per mapping
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261013-fix-p2p-acs-v4-0-v11-17-72cf8c96e617@nvidia.com>
References: <20261013-fix-p2p-acs-v4-0-v11-0-72cf8c96e617@nvidia.com>
 <20261013-fix-p2p-acs-v4-0-v11-17-72cf8c96e617@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 14:47:13 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-fix-p2p-ac=
s-v4-0-v11-0-72cf8c96e617@nvidia.com?part=3D17

