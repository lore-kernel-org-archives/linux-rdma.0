Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792490680;
	b=ri+WG/M3Xah1fXBwSPu7Apz8+4gsds2Rl4noMUwL1WCcpNTc4cFQT8mPXuOozxuvz9Vt
	 VBrZq/yiNrmVZpPMQTt1EU1zUZDJoVd3u4RJw/sKYWD2iHmGbnb9nNwl3E/0ZP7W8VNvU
	 Cche2fmSxE51gmQ/X2AJ4oeR0E8U1DeZmdEon0r6k4tGvFjRBJRett24MUi++odKou3O3
	 slLKKkJvMpzcsUW18sL196xJW1BHKTymSbNiWo/NtuILvd1BZXG3/gOiLl5HvGEPhD4As
	 MWizAYk4nfey4yVyeXbVAVWqurkk/LAJFVPjtorWO4K/iMMePjDeIf0T+yvMvJVZANA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792490680;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=7onnNBfA/y2nQVimCYstBZPImfuXPsUBcLdPvuhezD4=;
	b=ykbg4/o4pVFrg3PG0hJoXXa6Pvn0Xy19SR7EUSUi8hkG+KIJ4c8+XdBoLqz4gA7HG4yd
	 KdgUXnXbSXcsc9KQn/NV0XJVMuRW1P/HxZWtrGO/N1J2se37072aq3rduSdvuCl6OhSbu
	 GGMMVOwO6IbW6BZjleYyvQxEwYHDeJ9EfEvmfo2Uy7wPefsBBOj5KW4YNnEQLZTtC5hVI
	 8Q+beH/pOImnk995BrFXCmk7bY8GJrefdn5iS2DulcuDuHpBzp3CngouYbBaJ5T82QEGC
	 7tfbuCX2w5Zq01CnvgarNnDHxZQhywF+OaST2IdVzNALw1fQaqc/k40ZMMm3Ib3oQ6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H2jLP0Wc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79FF5606A319
	for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 10:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H2jLP0Wc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C781F000C4;
	Tue, 20 Oct 2026 10:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792490680;
	bh=7onnNBfA/y2nQVimCYstBZPImfuXPsUBcLdPvuhezD4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=H2jLP0WczgH6C7o/I1WUP8ZNw/mCd/AwR+x626UjMl/Nme9BhGHkylBqouRXmvXu3
	 xirAu1PkNeSnmx0iNMbhuHt3bAWkaUHtOCDS169rPZfZla+DGbYM2ptIAsWRAKLwd3
	 7+A8HimTdclOh7+cuA/i83vOeyqaFtQTjK5wN5coru1KTN/7htBy4UfYfZPBw4HfmF
	 1JIVCWGjV3w5OvlO3x5DXlTmbw+apx4NhwnSScaxafMf+ChIGY/yOlB2uPPiP4nwuV
	 09aud279n/nF8GuhRUm3uo2RHWd19ptDBAL37pbra0ciA38qhgd3q8/ruHAGFnuiII
	 fKdCvWij0NiRw==
Message-ID: <sashiko-outbox-178790@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 11/13] RDMA/core: extended memory
 registration
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Davis" <eric.davis@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261019-uet-ib-core-v2-11-8bd654f25370@broadcom.com>
References: <20261019-uet-ib-core-v2-0-8bd654f25370@broadcom.com>
 <20261019-uet-ib-core-v2-11-8bd654f25370@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 10:04:39 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Eric Davis <eric.davis@broadcom.com>
>=20
> Memory registration for an unconnected transport may take more than an
> address and an access mask. A job to bind the region to, a key the caller
> chose, or a region carved out of another. None of it fits the write()
> command, so add a device method that takes the wider set of attributes
> and reach it when the ioctl carries any of these new fields.
>=20
> A region bound to a job holds a reference to its job key until it is
> deregistered.
>=20
> Signed-off-by: Eric Davis <eric.davis@broadcom.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019-uet-ib-cor=
e-v2-0-8bd654f25370@broadcom.com?part=3D11

