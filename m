Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793703674;
	b=WkPs6hdtlob/bIhNMee4d6X3hbvk2WRP3mjgWVsyffDBs21nDgMtKKUYn3rMJJFMxq1d
	 8SimJpXbGc8859Xr5nF8Uj3pcC7mwsTIh2BZIIQHpvTemNVfxN//QvtU3UYjWBHiHiFa/
	 P0gFUHdRCWuz8NrB9aUotqdc2JHB2WYHDAp1vX53xprzKoKQIF6ZSPMrUg0nMX7nScG1l
	 h/YcViLnpsxbuX9q+JtkzVFGfTErGcvibNfvOyYm28Km6f0R443pYjIa5mySbFN4rVBnY
	 kCEKrwZU33dZFFfrPxqaRGmjMzq7EZorudM2mv6zc3/9K6VrLbVViwyKtC9iv2iDnqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793703674;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=cl+qXrYBK3Dn4Wp2G6IIXmlYIeTQTjN9b0WxKrWnONE=;
	b=bprMYKhLO3UqUodXOw64rSxIvnaOeYk79mC73ModJbu5BEPkhlM2yzE37LmlDN5PLnP/
	 uXX0ONfbEvC18S6H1FEUybEj+hNhCbgp1BUU2OYPtu0eV+YqnJXOMGCQoGku7oQIlkn4t
	 LbPOguC18VlshirTo71JCr0+1vSoyqjVNxxZTFVjDNqMvb+DUNXu/hVXrlRW8Dy7gmPlp
	 rPl17NoNjwOBcd0hOl/G+ESvC+96a4DtfXBLRvSuPh2O17I2HbCQ8Nb4qgeOxTCqAfkjD
	 gzJTv3dKPfjyN1vxPlaVjIm/qTGbSyEZSauhgCMu3X6G8GXRqfFKW8lMwzterjFCv0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lfQsfley;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F50D606A339;
	Tue,  3 Nov 2026 11:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lfQsfley
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16CFD1F00A15;
	Tue,  3 Nov 2026 11:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793703674;
	bh=cl+qXrYBK3Dn4Wp2G6IIXmlYIeTQTjN9b0WxKrWnONE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lfQsfleyOTjBcuYCZeiFKsTF4Nu1CLRwayu9x6A7wRg4x/3gZ/tWUAObQDNyQUBZJ
	 ahj4XfqeLdDJPRhj8w34DyI2SPqqkoPa+34qGKFBauU+tA70eR51V/hCCs0SkKIGI8
	 c81Aebmfq//+bSnR4Hlw2xR7kYZ32sznaazu6h3GtzKUFo1+zWMIfIaXRS8YP+oj7l
	 Tfi6mEg6iEdtPV36ZC/KPNeQh9TNOA+jHQFrxIDx7O7fZ5dnoIzZsYh0/2ZCyFMJHL
	 FCwYitBIzmrePkXkGsZQVOR63G4H27FQqcJhXiLJGyLdfJHfzldyVAf1JThroSGIv3
	 cDW0O3jazBCDg==
Message-ID: <sashiko-outbox-195091@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v12 12/19] PCI/P2PDMA: Log detailed ACS routing
 diagnostics
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261103-fix-p2p-acs-v4-0-v12-12-912101f93517@nvidia.com>
References: <20261103-fix-p2p-acs-v4-0-v12-0-912101f93517@nvidia.com>
 <20261103-fix-p2p-acs-v4-0-v12-12-912101f93517@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 11:01:13 +0000
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
> When P2PDMA rejects a mapping, existing warnings identify only the final
> ACS or host-bridge result. They omit topology, live controls, divergence
> ports, cache state, and intermediate routing decisions.
>=20
> Emit debug-level messages for verbose calculations and cache lookups.
> Report both paths, decoded ACS controls, directional decisions, host
> fallback, and the final mapping. The messages stay silent until enabled,
> and the existing warnings are unchanged.
>=20
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103-fix-p2p-ac=
s-v4-0-v12-0-912101f93517@nvidia.com?part=3D12

