Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793814790;
	b=YgESuDeNZ/gTML1CX6EWuxaq01K6EbfI9hSBjGvLp1DYhKq5RA6g2BcMlkkHOlI/p3Qv
	 vP+K48Nhj+s/1YkMOOg4/k05EbzL021b1bPVsf4gGcq3P3V4q8STsmiyQHke2aQtvi6V5
	 YQ4eDzhgTVKliNWiTXI7MxnruKiGn/tAQn+l+T6C0Z1wTdS8urlmpEL+vrg9UBIBr3BhB
	 cKUKJ5luC/Elt1Vbh/jBKeCrsP0GVS5Wl/wbl3KNWh06eVm/f2jyxnZoiJ9eZUbG+yhjG
	 1XogOjkkpqi4AaBsdb9N30wmyZTGnkB7moVVWf9NaENTtfVnH5zT1qWuzYwFcD3ygSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793814790;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=6BOyslrXnZXQl9SZCxaOanfnrKdS4+GrHcgFYTMPXLk=;
	b=ZPqWzucpkfUPSLakGMe8KJM4F6NhRkYD9hpF8ghQ5henHeUyRDCy3bN+BXdXHDcDwZr3
	 4ehcqYp0L/h/+lCzuvj9VAjQ3jNrMH6NmSud95rWcbjLbL2P2rMXFTe/z+hln9k6bLwAS
	 /xOfQdB2Kbn0yNOjfFll7zY1GHqoSpcl9cRujEffr+pjc2jfV03rYzNuN+YKQExV4R/hA
	 ARvUxzRJURL2BJWDacy1JTdgs2qL61yJCQijwjSzAlcUeLFIRkHb5/vkWC1BBQQhgoGTW
	 P5iZdci6sNGpRBPYUloiA6NMaqCrHsaLolVIsB3NL/UJ1v8Kb+z+EvqlZNQmGtBfS3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dwbe87wH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C183606B0A1
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 17:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dwbe87wH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20AF01F00A02;
	Wed,  4 Nov 2026 17:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793814790;
	bh=6BOyslrXnZXQl9SZCxaOanfnrKdS4+GrHcgFYTMPXLk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dwbe87wHMixgrfLALkI1uMK6kOHj2UpkNjuOSByTPxwbK1dIHDDqw/wWqjWMycxeI
	 1QBgsvE/iC4C+zCR+kFqu067RZrXrjdSMsIvK4oJJwMqcSzLG+gBDki1LdXH7h2CCJ
	 vNFbAHPPUf6cwdmMtwwGZNypoOTcArixCXiIdY4gSkj8i6O1V1HqxA5yLXaGx4qgrX
	 65YCBRdcRSvskLCx2WvtieY1PoVV8vXC1et6Mzd5/09pMDyPYe2wKE6vzl5eTibuIN
	 1a4qmCff6zPq6meVN13LYYl49blccHuRslLgD1R2sqcgo3VEQkKByiQjPR7g4ER2Q+
	 1GNGotz+gIeXw==
Message-ID: <sashiko-outbox-197796@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/5] svcrdma: Set xprt_class on the backchannel
 transport
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chuck Lever" <cel@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261104-liange-v1-4-f097e10cea1b@kernel.org>
References: <20261104-liange-v1-0-f097e10cea1b@kernel.org>
 <20261104-liange-v1-4-f097e10cea1b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 17:53:09 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Commit d3abc73987fd ("sunrpc: keep track of the xprt_class in
> rpc_xprt structure") added the xprt_class field and filled it in
> every xprtsock setup function, including the TCP backchannel one,
> but left xprt_setup_rdma_bc() alone. The RDMA backchannel
> transport therefore carries a NULL xprt_class.
>=20
> The SUNRPC sysfs code dereferences the field unconditionally. The
> backchannel rpc_clnt is registered in sysfs like any other, so a
> root write to the dstaddr attribute of an RDMA backchannel
> transport dereferences NULL in rpc_sysfs_xprt_dstaddr_store().
>=20
> Point xprt_class at xprt_rdma_bc, as xs_setup_bc_tcp() does for
> its class. After the change, dstaddr rejects the RDMA backchannel
> transport with EOPNOTSUPP, as it already does for TCP.
>=20
> Fixes: d3abc73987fd ("sunrpc: keep track of the xprt_class in rpc_xprt st=
ructure")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chuck Lever <cel@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-liange-v1-=
0-f097e10cea1b@kernel.org?part=3D4

