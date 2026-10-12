Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82AEB4A8435
	for <linux-rdma@vger.kernel.org>; Mon, 12 Oct 2026 16:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791822032; cv=none; b=aQZFvOLkhloUc7bm20HS8wtaqemkiR9ZR2+dQsAri2zpMvu5TqDx4y5GdznjF1zjHFnjkSbcebnZ39YLJrlu/xaXlyEj3H3ltzeNWhFCgwSbXAdB7dbtUhe8vyCIeWSqaLDfrBUX5+KqFpalEaDj2NHDA04tWce2TUj4yT6x2W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791822032; c=relaxed/simple;
	bh=661PESlsjmO3UjSHdVw1LO7JwaT/0DLQJjNc+OWok0g=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=TNSpAGGV+7n5ikdUaiTczJvCYNhuylC0f/sSKkZBeh7e3vOkdeecyCtg0jFjpFpyN89RBiPXB20xsstOOZSqEZ2B062oxLzPHRVG/BO3I0jsUQXBu4bXIRkdy2q6+xWAI5B5s9uEfrbonlA8nzDTe24hMekxBjaDoTrFnEn+RII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DrgSTIpj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DrgSTIpj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 194FE1F0089B;
	Mon, 12 Oct 2026 16:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791822031;
	bh=661PESlsjmO3UjSHdVw1LO7JwaT/0DLQJjNc+OWok0g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DrgSTIpj+dg+tktjY/Y+bhmIxSP0v6aqz1gQ87n+7FOIIs8wHBsPuoGPcSy4Q7rV1
	 yzjBUnY73yndJ0MFkyoAX/Yn2dBoClBw1uJbatZV+Miprp7RiSTYT6/ZPnEe+Grmde
	 lPwXQb9ajLB96nJUgF3YvIhmWmn9aK9RWRSvHwqJVUJSGOP6FwhHOjPXHvw4Nnf09N
	 dabKAMnsKUriDLqyyDiAAUjdr7G94DXjH9IXPmIf8qEuZ+dmUDK21YBU1uJ3O6Zauk
	 7kT2mhXpamax5pBaPBWvQtyIDAqVfyUOWW1lnfEvpShI1tBSolyHQ9cDQXD4ynhipI
	 fFSQwQFvT3/9w==
Message-ID: <sashiko-outbox-168385@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] RDMA/irdma: always route IB_WR_REG_MR through the
 allocated PBL
Reply-To: sashiko-reviews@lists.linux.dev
To: "Stefan Metzmacher" <metze@samba.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261012161135.494544-1-metze@samba.org>
References: <20261012161135.494544-1-metze@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 16:20:30 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> irdma_alloc_mr() always allocates a PBL via irdma_get_pble(), but
> irdma_post_send()'s IB_WR_REG_MR handling only pointed the FAST_REGISTER
> WQE at that PBL (chunk_size !=3D 0, first_pm_pbl_index) when
> iwmr->npages exceeded IRDMA_MIN_PAGES_PER_FMR (1) - leaving chunk_size
> at 0 for a single-page (npages =3D=3D 1) registration, telling hardware to
> use direct/PBL-less addressing for a registration that was never
> allocated that way.
>=20
> This reproduces as data corruption / an IOMMU IO_PAGE_FAULT when a
> peer later performs an RDMA WRITE/READ against such a single-page
> FRWR-registered MR, even though ib_map_mr_sg() itself reports success.
> 100% reproducible on iWARP, intermittent on RoCEv2, with fs/smb/smbdirect=
's
> own single-page memory registrations on an Intel E810-CQDA2 (irdma).
>=20
> Intel's current out-of-tree irdma driver (2.6.96) never gates this on
> [ ... ]
> Cc: Shiraz Saleem <shiraz.saleem@intel.com>
> Cc: linux-rdma@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Assisted-by: Claude:claude-sonnet-5-5
> Signed-off-by: Stefan Metzmacher <metze@samba.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012161135.4945=
44-1-metze@samba.org?part=3D1

