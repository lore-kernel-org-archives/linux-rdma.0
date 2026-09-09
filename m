Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6DA3B47D5
	for <linux-rdma@vger.kernel.org>; Wed,  9 Sep 2026 06:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788936945; cv=none; b=Tq4/vy3oCpnxouzB7OITTOGwd9K+hANp4AOya0necks2u+R4wrlIg6gLLrx191BrZldcHzFfl4DOnXNxmTyKmBCocoVbRfoKvFoK/213z60PPq88oQVEy0NzShDe0fzlzkWw9M+XS19jPH65jO/hwF7AHYMv5ZYF99bA1NE+Lz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788936945; c=relaxed/simple;
	bh=9OK8wo/AEhcleWd6RMJB5KO4y0BewhWnjka0W6pdO7E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lnJ2U8SC6z+p35sXfzutvmsHGDoimxwV7Cg37+geRVAyDu/CmxGtyifCENu1B1cD3j3E2N39ppUujDvk0yt0Iqmjr1q66lBruU3pdav1tjAjpGy7ypsQuqcYK1XkxZJnguB9rQXkWDRLHvpi4/O/EM3k7EpncCYq2/i2amt80Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jewpfc53; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jewpfc53"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 445041F00A3D;
	Wed,  9 Sep 2026 06:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788936944;
	bh=9OK8wo/AEhcleWd6RMJB5KO4y0BewhWnjka0W6pdO7E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Jewpfc536hvnxJNpCNSUbj6t/VFUTFnF/lbiyAVauxYBV0z97BMC/uyqkuQfWOXUr
	 nx6jmzouXzSrN6sbrGwC5ZeALSLrHHaY4xbt1+NrD0vKYe+VpPtmE4ZuYlqSWmv3sR
	 TqB4NPF6pPIWyndBocML2IS+pEjbrlv2jZ0f/vVdWuZYBRM+MdM5/GoMF2IVmm8xBo
	 HG+LWQc5iqVMDFKdal3w5l3HV5tJ5xtBqWpMxFV9N0b+2QXtXyjWRn2qISNl4d/mc6
	 mE60KRlWI0oTcVuDhajUzwXR+utAKeinVr549YmSNNNd4pyR87teVjvxi/WqyINMkM
	 1ZUadmZ5mQ41g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V4 10/14] net/mlx5e: shampo: Flush session on
 PSP mismatch
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260908065244.3799142-11-tariqt@nvidia.com>
References: <20260908065244.3799142-1-tariqt@nvidia.com>
 <20260908065244.3799142-11-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 06:55:43 +0000
Message-Id: <20260909065544.445041F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Cosmin Ratiu <cratiu@nvidia.com>
>=20
> Flush SHAMPO session on PSP status change (no PSP -> PSP or vice-versa)
> or on SPI/version mismatch. HW aggregates by 5-tuple but is unaware of
> PSP fields, so sessions must be terminated when security parameters
> change to avoid mixing packets from different PSP associations.
>=20
> The session is also forcefully flushed if non-decapsulated packets are
> received. This could happen if, for example, the decap table could not
> be created so HW GRO is active but there's no decapsulation.
>=20
> Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908065244.3799=
142-1-tariqt@nvidia.com?part=3D10

