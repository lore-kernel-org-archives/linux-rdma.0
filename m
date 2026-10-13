Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F003E511222;
	Tue, 13 Oct 2026 14:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791902830; cv=none; b=PR8SFFRca42HiO2zTe6xzh7SaXq1OM5RYg28N3IwbZcvQCsh2BYG2vvvmXIApHPoLWTi0ej34MDwaZOhu3VCgZA9bjNrK2lcq+sTi9/FKURnFf+HLz/dvgrSoqYYhHzNE8o4Pou8IUY73cBCECVOqf/tUV3ZNDJIo9SD+wP5i3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791902830; c=relaxed/simple;
	bh=nN9bJOFB5K4kkNbDzm5iwhZmug4w85w7Gt89M5hAquo=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=pFRzRGQO6w2Yjt8l26GC0h+DYW56n1KSQz91zz7eM7s15yQFf8XPWGJn4yD4qhtj6Cf+jKFMneXgPhM8Y8bmAYLtAJGQCcNZRpZIjPtDQkhqbyqutsCwc9PYCtIi6Wd/+D5ZeaU4Izt3v8TpMcc2BmxM01Hwj8AvXxmC1tmyOHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hWE/DsK4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hWE/DsK4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E1771F000FF;
	Tue, 13 Oct 2026 14:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791902828;
	bh=nN9bJOFB5K4kkNbDzm5iwhZmug4w85w7Gt89M5hAquo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hWE/DsK4qUTUNgqNKct4raKeOdx7neBBTvgr/DB2q+R9I/W8A9gacIWb2isevsFbY
	 Rz2Wysth8DCjDFkYahLarrXNWODEYDUROx3iN5/aBLCBB8JEtSu/cDkIueftlJRWD+
	 8YmTPp4OJ6XxoJBQhAZsr9n5zb4L60vUC0FrJ2Rq6hcsg0QhkCgv4QHfG7in/Gf+rl
	 BPXVs3gQq1Qr2OTbAFzBUXLHJJYJeqjRwgS/k+JRyVTV3ysS736HauvbmXe0Vbmvap
	 UfeR0yiFOQnpwAqMMJkO+vnZBX2UCL4yrHGW45UKOSQd61xtniNyjMXnZAiwnHSL+h
	 Hf1ySwlpurKLg==
Message-ID: <sashiko-outbox-169934@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 18/19] PCI/P2PDMA: Evaluate the ATS path for clients
 with ATS enabled
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261013-fix-p2p-acs-v4-0-v11-18-72cf8c96e617@nvidia.com>
References: <20261013-fix-p2p-acs-v4-0-v11-0-72cf8c96e617@nvidia.com>
 <20261013-fix-p2p-acs-v4-0-v11-18-72cf8c96e617@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 14:47:07 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> P2PDMA assumes every client issues Untranslated Requests. A device with
> ATS enabled may translate any address it is handed, including a bus
> address, and Translation Blocking can reject its Translated Requests on
> a route the Untranslated answer called usable.
>=20
> Unless the client declared per-mapping ATS, take the Address Type from
> its ATS Enable bit. Never hand such a client bus addresses: only an IOVA
> survives translation, and whatever it issues untranslated goes through
> the host bridge, whose route must therefore be usable. Apply this after
> the topology-only cache, and in pci_p2pdma_distance_many() too, so that
> provider selection agrees with the mapping.
>=20
> Reviewed-by: Thomas Hellstr=C3=B6m <thomas.hellstrom@linux.intel.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-fix-p2p-ac=
s-v4-0-v11-0-72cf8c96e617@nvidia.com?part=3D18

