Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795008267;
	b=f3xjnRWekEag5bovOjsr30uWIq3CkV/8Jc93nMnuaEGK4YhHCmTiKae1ifhY/1wHb7S0
	 O+TAPh6ZGqEx3+WVvx8RquUNICvusQIh0DoYC6kAXa4n5zTyb8RarCykGiV3n1HDC1n+U
	 YLyCKFdccvx09D4fey/1jZu1ARgDM0YsRPbj2Sj9a76WyE8NPjiFDyWbXeTMxZvuiO7Gx
	 keuPFJ/5LI48fHVsUCgyEdnr3B19zOz4Gaet0ywaKxEqKE4Mz6RjjatF2rVla7A/0xrbO
	 UHJXzb6En9N1FZ/XxH3RZlup0gdAZnQ1RzF6m57eomKQwNHXnQbY6M5vo7t7yuOnT7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795008267;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=2Tei/ZFqPIvhCfPuYj79wxRgGcZPZa42ZIo8Axcge8s=;
	b=MXnVTpqUUNu63RIAAxGV6ZRHv00I3Ksi+bbK9VDQacz8w+5KonlNAxN45CuWx5LqkpTA
	 ZXmSn74lWXfVmXFoJSFqhu7e5S8gD/eo9W6Df5XoFKLfJ1EEbbwrh1PTTzPA/veQh88RD
	 zHiKrlZ0daG1bi2JPDu2y7aSRql8xlmBuewNrVuW5tRmkB82xqggTbDbeImHIx3G3jZ3t
	 zxzxH+sXFlFsKJyzUP3QbCe2HErGNdmrqZLuYX7a3PBg0Q83RpU4+OCeVUdEfuK9046JE
	 Q+9aERBxN+ijEk0SvO8vHC9O01PXRCbh9ZsYkBXJLpph+h3eFTGOH8YwH4fuD/kBgoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TAfDcdnS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85792606A31C
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 13:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TAfDcdnS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58DD1F000C4;
	Wed, 18 Nov 2026 13:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795008267;
	bh=2Tei/ZFqPIvhCfPuYj79wxRgGcZPZa42ZIo8Axcge8s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TAfDcdnSY54zSm251rCTnGRUXi5D7MWtAEAqyYRF4aE5zERkwCkpolLWpSEiybeNo
	 cj2UycpyJ+wAQ/yoalCodyIJ7GlxqhHOSo9jGKL+rkAnVh1ganlU+qJ1QWkgS/HqnP
	 el5OqXeJjVte+oNCxbD38WI/IiPfiub7+sPRN5WlOXbP6PQidxymhXXf7gXHSJfemQ
	 szGGeCGxMpW+yO8TMvwomT4Cr7lof772PKe8iJr4reJpENp3aPHooE0y3+LMapt4gT
	 lAfp07+1yCE00ydTPzKIk5L8ewsjFayxfInV5TfNrOtvubQx8WNHPUtlFEi8CS2EwG
	 UjvJhVw8uJR2w==
Message-ID: <sashiko-outbox-221008@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] IB/hfi1: clear VM_MAYWRITE on read-only STATUS mmap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abdifatah Suruur" <suruurism@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261118131948.28748-1-suruurism@gmail.com>
References: <20261118131948.28748-1-suruurism@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 13:24:26 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> hfi1_file_mmap() rejects a writable mapping of the device status page,
> but leaves VM_MAYWRITE set in the VMA flags. Userspace can map the page
> read-only and then upgrade it to writable with mprotect(), bypassing
> the check and writing to a device-owned status page.
>=20
> Clear VM_MAYWRITE on this path, as the RTAIL and SUBCTXT_EGRBUF cases in
> the same function already do.
>=20
> Fixes: 12220267645c ("IB/hfi: Protect against writable mmap")
> Cc: stable@vger.kernel.org
> Signed-off-by: Abdifatah Suruur <suruurism@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118131948.2874=
8-1-suruurism@gmail.com?part=3D1

