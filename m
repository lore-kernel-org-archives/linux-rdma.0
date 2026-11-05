Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793873845;
	b=SwVPWMdaoTOHXNz7GVFhO4xZKOekp3mdPbUWeQeW47CYEbc6sQ3xCQ75jE5H6kZ3hD84
	 fdv84AhImvixR+B7LOCjADZofk6iqFOzQQCXx5OneqsPkenTxh5Gk7epCMtS3MWn/RXXG
	 m9FUnmEcJcAPXAZD8ay0RenCM0w5tniQaW5EpsK3tux5mFhjPnEa++pi0RTkQ+SFtNsiX
	 ZdORaLrf35NFd5KvGcbkzZD7A4VV/xohCmPA/N57oEAbOHtHi/mkueka6Jzz+RcKLVdT6
	 zg62BNMohADihN+J2s36ERodlFpYrTIbXuohX3L2HiWNRUOcp85pQM7lKWdSMuIDt9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793873845;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=m6xnuXqMT/vdU2Y/XYVcD3juqS5gIZwKRt3RDC8nDpI=;
	b=g/7qKjzjSzOLASQzuXM7Nm1MSG956NKrTk7t0FuhKJrl9fh7eTczWXEvKsLGbYB1TNfi
	 HlWu56uzRPsAvdkm63O+LPhhyywMtOp8wCfO0aQCAjjMiowkZXacKR5J2t6FR1D7DSytY
	 KEWmwzfkrpRQ3HhBeAGmTZH7hOzHvwmKuh1gIa0D3MAQK6AotQtulQXxT7g86zwvezu8Y
	 1eUrG4Awv0wNbfiW8jHGOwm/IBui+Y7AuhzZUpjSFFiWx+2I2GShb+DD9ASXPinVcI4ni
	 aA72ySiVX50M6Muv8YEx0Gm0o2fxYPiz300m+mSEq09VFqQkS1f326PRvwwfWYByyow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Cw3W/GP6";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39487606A328;
	Thu,  5 Nov 2026 10:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Cw3W/GP6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91ACE1F00919;
	Thu,  5 Nov 2026 10:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793873844;
	bh=m6xnuXqMT/vdU2Y/XYVcD3juqS5gIZwKRt3RDC8nDpI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Cw3W/GP6L7y7OEeepUN0RqI01GstvwM5+jg6qNuCqYAOybsoxZrXUBfmXV5QpLHcg
	 HNrimzVYM5AITSCwPHKi8KHdBSsZ2klAbiePdk8x5hjjXs7Z4ll8h3EnOcl9wqdicn
	 bnADrc7uL21Ts1cFdg15d7wmx1YEYUDzxJGIpgXq/oOgHDgKx3Q4KVpybFlipsUI39
	 0L8532gYptrwvfDbWnfUC3hIDn1UD+tIZe8lYuAmmw3NKDDMz1mMBOCZJveJ3M+c01
	 lz9zU7a9a8DpAetIPOKWa7SXYAPisvyknPh/45FI1SPzL2nZ8NFHk0vYaEsIhmXOXi
	 T938AIQzU1Aog==
Message-ID: <sashiko-outbox-198834@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 17/19] PCI/P2PDMA: Let a client declare that it
 selects ATS per mapping
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261105-fix-p2p-acs-v4-0-v13-17-3dd065907c3b@nvidia.com>
References: <20261105-fix-p2p-acs-v4-0-v13-0-3dd065907c3b@nvidia.com>
 <20261105-fix-p2p-acs-v4-0-v13-17-3dd065907c3b@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 10:17:24 +0000
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

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-fix-p2p-ac=
s-v4-0-v13-0-3dd065907c3b@nvidia.com?part=3D17

