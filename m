Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793873585;
	b=nk3fof5HxdIw3kcx5AhaMl2BlpE+URrCp5BVvrRaOj7irL/CungfRVgVjmrP2u9zy5ip
	 zdA4KHSL/6MTG9NYOAsL5idKB4wTXI8ADf2V+ugsoWNAuCUxHwJU8VwSUWkHJTbkRKbLe
	 lFjDMzOmhcKRSZikE3CKg6yMp9ZILW+lwnmpbKLXTdcZsCcN1PSiqDcMa35Lamku4nuvY
	 XV+iH4u0xSJcBbQd7MsVm7mJGn7QOMGVLZMUJnqjnqK3cxpNA8VwsZHUvxN52eU7quy/L
	 C0oU6DOZSj61rKn6TpS9fLCHWThD7c8crEn5rpZJTOnivrMibidzonQr7Davd5BrCNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793873585;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=62j68JB49NyJBOWZEyp6hnsKJlPqVZuy/IUTcju7fzQ=;
	b=yQc3jrLtOK0kJ37vnCav5xejlXILZzUx/m8IFZmLvTNilGdvwjv8Ri/TZ/x4/cBXmGfk
	 0idDdLV1yRV0nv1f7koxF4ZRVWsv8qUIHDTJLyr7/O3mksQbpNmB7oxjFdEMHaxkv0Yb8
	 vYxwz9vgtgBUyDMoB71aZYM7JZsI+Zc3o1Hni+Y0Pb7iVjssVdO6p4wIoUGP7HfYtMuf1
	 iOUVCub7Wg2AeNdN52aSAHfktwPItNDlqdjxFZ35sPzVlO9p89q3nad8kQA+FFBE8vkgW
	 7zIrQFnOerGWkWmznhZ2lyj8YnmU/9yqne8O5T+oB8CymFOKL3kVqjXSH85qVJg+Lzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PcXYZJlH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E186606EE9E;
	Thu,  5 Nov 2026 10:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PcXYZJlH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F021F000C1;
	Thu,  5 Nov 2026 10:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793873585;
	bh=62j68JB49NyJBOWZEyp6hnsKJlPqVZuy/IUTcju7fzQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PcXYZJlHRmELv1l22GNEFpw1fI40YDI8KRfTIAszfJOpFoKVFXlqS4VTvbaPRqsJH
	 AfADCsQinFe2L0spE7cxHidvyENThRTA9QDk5FyZJoa+QTYjcQ1MJCLj+lugJFzw0k
	 Qi/4GBsPpW6h7FMLLiRuU2AF8CO/4znUVhB4Jbcj7y9ezXJvIe15YpYDP9FzN7YQhL
	 UgIkKQ/bdsTUjn1KiFxkDDBrai2v78z7AYhdUZx4S6P2S5R7sAXxvWUMp4NuButpa2
	 YQfGXDl0tr5CpAddirTZRsV0noE9b/cbh8cwI2BHlScmlHmdZGtALzMqRoGS/Ok4Yy
	 5U7XwuA8MbnJg==
Message-ID: <sashiko-outbox-198823@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 04/19] PCI: Reject unreadable ACS controls in
 isolation checks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261105-fix-p2p-acs-v4-0-v13-4-3dd065907c3b@nvidia.com>
References: <20261105-fix-p2p-acs-v4-0-v13-0-3dd065907c3b@nvidia.com>
 <20261105-fix-p2p-acs-v4-0-v13-4-3dd065907c3b@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 10:13:04 +0000
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
> pci_acs_flags_enabled() and the Intel SPT PCH quirk use ACS registers
> without checking config-space read errors. A failed read may leave control
> state indeterminate yet allow the device to satisfy requested isolation
> controls. So can a read that returns all ones with a successful status,
> which is what a device that does not answer usually produces.
>=20
> Return false when either ACS capability or control state cannot be read
> or reads as all ones, which neither register can legitimately hold. An
> unknown state cannot prove isolation.
>=20
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-fix-p2p-ac=
s-v4-0-v13-0-3dd065907c3b@nvidia.com?part=3D4

