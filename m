Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4050144682F
	for <linux-rdma@vger.kernel.org>; Wed,  7 Oct 2026 10:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791367545; cv=none; b=t/BidYZCL8MpbpPEMc+RhIaQZQN6KJhiUcZ5n2xnCJnhYAWIUSY2buTZ6XtepPZb6ACTqX4UJzPbIB3vv94hL8F8VzrVqfabG0S8MwGYyIJfd1GFT5Zf1KEIkpzVm84sC+2SPgoLXphY9CR/sUXFnxa9mgbb4VpRgqObdLD5wIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791367545; c=relaxed/simple;
	bh=EjWcOW/I/XgATfDEoVu3YnnbgqVy8Un7soIJP+C5KaQ=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=FHm3AlpnYLmysBpnBpiNiQP5wjuLVSC5j5wpe+Asw937voEU1pBsAtnNUVdbyH3fSgHs6IQWsSayMa9cfyxH6U+A2LADBCdUe/b+Fkpnp7yvZjKWzT6CiyM8iFCNJN/1doZ49EpuNlumrFs/UzJmlbZgHqH9+8paZYkQ1CT+mWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BkkYJpXw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BkkYJpXw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A4D1F0089B;
	Wed,  7 Oct 2026 10:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791367538;
	bh=EjWcOW/I/XgATfDEoVu3YnnbgqVy8Un7soIJP+C5KaQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BkkYJpXwdad5tQC7/8R9JxEzHSjtSfqVEy5I/WV0iAlH8B2wtg+4M/a3iGSaoAi1n
	 3Mv1L5Qnlpnlino0Vg+inz1P8pHYNlcBtTW2ZE+4ISQKr/QNqudA1myThzYGWaCFdT
	 OmwOOAEGRTKFBF4bHV7iRCoY0uLxQvRVvTgJPKyH7lOUq96o4agphql8sLZ0dh1Rro
	 /QC8tAGHfMRpaQhkiQDAdZ53nnuxHvPhuRq1nAafEDd4i7oBvRgV8hstREMNskOu05
	 2sjTKEj0sRn7RV5GI934CegBojmfxcakeZr6m+fYd039IbMDVs7pxW27PWA2/qQyLl
	 AKfkJ9okv/6/w==
Message-ID: <sashiko-outbox-162839@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/irdma: always route IB_WR_REG_MR through the
 allocated PBL
Reply-To: sashiko-reviews@lists.linux.dev
To: "Stefan Metzmacher" <metze@samba.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261007095312.1523211-1-metze@samba.org>
References: <20261007095312.1523211-1-metze@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 10:05:37 +0000
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
> Cc: linux-rdma@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Assisted-by: Claude:claude-sonnet-5-5
> Tested-by: Stefan Metzmacher <metze@samba.org>
> Signed-off-by: Stefan Metzmacher <metze@samba.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007095312.1523=
211-1-metze@samba.org?part=3D1

