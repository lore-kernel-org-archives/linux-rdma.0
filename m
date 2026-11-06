Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793947437;
	b=GfUUSv/EIEPPkEejfnlwxk7zTpdIRj938W/7XK9Q4y88gTDAO/L1yBUEtC/GnAGqNrxr
	 bDO2Lzf5+foriY3oBv9O5WIx7z6u4LP+8+8bwiKDvcF9bUOIGld4bAP16i+a4bLlw8bvy
	 vpsLM0mmXi6kTNAN5T8oRlTH2MWXG4+fIZYgtCnpr2lfF+kXJWvGDml1xBpEbpch1NYpX
	 oHJVaI63W8y9hbDiPhKRae0O7CQh6Pa/hI2R4XKzoSnp4f+vXHT/VGp/XmWB132YgoCxV
	 4BTZov5yz8BIPOlkTmZP/1gLMeHDCKnElmzohWt6ziNd8/jGYe+fGnVQNSBTnvwPOUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793947437;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=OeIR4ME3EceuakWwQXdxjOmsrXfvIBtFYF/I9WSEsDs=;
	b=mSIlFFKBYmKFnVh8fGluupiPYytLW3Sq49utqatEQ8AEOw9NXFB+wkTPG3AQ1AxAiz9u
	 KpNYV08x36NqVEl9hQGfJG0KVVSSbWHz7YRxkwZ78P8gPetQrogNgmrGuVOXNoReWrYKj
	 JuB/7kn/PYC8JJaUb96QgFgJZttXfxQOBcyGRlznjqkGV8ICrYhwMnmROlkGPlBKbBbVb
	 HOT+Cv9Pf8Lp4Nb44EaxNWMoHoiSeCfz8AWa+nA8XD0pB2yL8CJdLv+13UuyQzu3jHRWw
	 J2KsQXi6NgR9UBf48NLkL+xzsw2QJnE3TGt4+ySgr2I04Ulx1Ob+MWKDL8qs0LDylBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wvd5tqma;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD7C606A328
	for <linux-rdma@vger.kernel.org>; Fri,  6 Nov 2026 06:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wvd5tqma
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCF5E1F008A2;
	Fri,  6 Nov 2026 06:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793947437;
	bh=OeIR4ME3EceuakWwQXdxjOmsrXfvIBtFYF/I9WSEsDs=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=Wvd5tqmaZrPlED09qcdkiPjuHveBpucYK4e8ecyhLQRkYbcoowdKCFSXNgDVJJJrL
	 xAyHK3mOzrtzXi0JCAKjZmZxd1/1A+XseuSBtmQLVSButsy4qrYLUuH2vUMes3R3nn
	 FduB4JcCKbsFAL4OhG6wTVtgP5aJlrPhca3NosimIGMcwJAKj0GNOtxsy8lXImOh6l
	 R0zad88QvcoP5YxsxrAATwFo5M/yLInBaRE2cxRB4hc049MvxVeLz044D21q9mPL6p
	 cwIq2+1xTnNAHRof8b9SJKYdX5cKhi/tfw9fGwxMYVH9Wr2q8OLnHvsgkBcPJoUy9L
	 Mr1lUSPrEqLlg==
Message-ID: <sashiko-outbox-200932@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 16/23] vfio/pci: Change the DMA-buf exporter to use
 mapping_type
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261105-dma_mapping_type_v4-v2-16-78b8dc9ae80a@nvidia.com>
References: <20261105-dma_mapping_type_v4-v2-0-78b8dc9ae80a@nvidia.com>
 <20261105-dma_mapping_type_v4-v2-16-78b8dc9ae80a@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 06:43:56 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Jason Gunthorpe <jgg@nvidia.com>
>=20
> Simple conversion to add a match_mapping() callback that offers an
> exporter SGT mapping type. Later patches will add a physical address
> exporter so go straight to adding the match_mapping() function.
>=20
> The check for attachment->peer2peer is replaced with setting
> exporter_requires_p2p=3Dtrue. VFIO always uses MMIO memory.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Alistair Popple <apopple@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-dma_mappin=
g_type_v4-v2-0-78b8dc9ae80a@nvidia.com?part=3D16

