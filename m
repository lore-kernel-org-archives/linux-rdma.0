Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16EF036E494
	for <linux-rdma@vger.kernel.org>; Sat, 10 Oct 2026 19:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791662257; cv=none; b=TKjZLxtKEUN6V05kUNxQ3TrFV8l3OYeXQtxo2nMWR7pOSv0SHd/12M/iHavruvf7MUTUfhP+cR6GpzuWc1nY109Z2VBCf7ywFhRhIgUsJoVAxP8vLQx2WotARiZ1zTX+veAFks/YVO0PwLuvJhq4fmubFQNw9ajHG3YtfXESsMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791662257; c=relaxed/simple;
	bh=hOhmoaBvGTNzqm1aqb62y0vaAB8rmOnrMSWRcQUMYGQ=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=DTjFmbXT0luZYg6ofMGE9pWGmkvrgI084lWqh8xus+CNknq7fR7YYPCIzAj3W2lwpg6HFxH7o10CCi4tx5JWNiYXcJQgHfuDDsgJ2s2yFpGa3+CVH+NahTwj864b4gB49NCalt0xnevqWkllvHHmHraSS64HxCw8y3AzqRJLM4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CF0twAnf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CF0twAnf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A29021F000FF;
	Sat, 10 Oct 2026 19:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791662255;
	bh=hOhmoaBvGTNzqm1aqb62y0vaAB8rmOnrMSWRcQUMYGQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CF0twAnfjn5YYioNNy1qvEMCSprR2luOsYdppVTssiOighu/p+gnJxsoFPUBR8uCO
	 8pxu5okKO7FU+EN6fzFLSpdDlpWIORSKAoaenpDxRAlh4s3Q35XPbogkvccfHcokog
	 QbZEiqWopm8jSfXC+RBvVfGvlYYT8lqi8GHiQkxYi/Zl2xr92y+myEe1oQby26dnM2
	 xI1L3iiOtoIgcuZX9xG1gMONwCVG8pKXVnLeu0FSixcMPGW3hxQRW8iIRgrx/svbTr
	 0smQfNWDuSziINgSujpFk+HC/OO8EegP+YebaJiW27HRdNNUVF5qVPA7ICqyyHHVyJ
	 Ka6Q/blXCzifw==
Message-ID: <sashiko-outbox-166858@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next] RDMA/irdma: Check MR contiguity before PBLE
 alloc
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jacob Moroni" <jmoroni@google.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261010194832.2415477-1-jmoroni@google.com>
References: <20261010194832.2415477-1-jmoroni@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 10 Oct 2026 19:57:35 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> The original logic would attempt to allocate PBLEs, then would
> check whether the region was contiguous _after_, and if so,
> would free the PBLEs and use a direct mapping instead.
>=20
> These unnecessary temporary PBLE allocations can technically
> fail (PBLEs are a finite resource), which can cause an MR
> registration failure even if the region is contiguous and
> should have succeeded.
>=20
> Fix this by checking whether the region is contiguous before
> allocating any PBLEs, and use the ib_umem_is_contiguous
> helper while we're at it.
>=20
> Ring MRs still have their own logic. That will be addressed next.
>=20
> Signed-off-by: Jacob Moroni <jmoroni@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261010194832.2415=
477-1-jmoroni@google.com?part=3D1

