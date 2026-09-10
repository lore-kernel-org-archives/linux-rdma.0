Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED543BE623;
	Thu, 10 Sep 2026 23:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789084711; cv=none; b=Ctl8Eu1ZXn0AM+/yQgNtk/jfsSKB3bU1WpLS95GVeevnf5DDtt7hDBQ7DM7IUmQKvHJuU7Of+GrKfMrEf8XaOoA17SFtL66Y48KYZPpxgtDcslOhxWa2324lQZ1AqD+ypDwL3MjTpngXNZIc3n5lHIGEWhNz1ProYxc8/Jmj8hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789084711; c=relaxed/simple;
	bh=oJalIAOzuIcHjduDzEobo2g+BKTwwcvD0ZC9G5jMIfo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=PidFxtypCdQDDTOwS0XuuzMJTJNc8dVzjW9TnCTX+aAD4/gsUpLyHtZjt83qg5NXff/Hx/oe8eR5q+p7lhSgA3oWqSGDBa7LLk6Q1TXR/mpBFLsKamQyAmdUHeLB1CEp3NZz0IT9vVpUJsl112RNhvr5Joko8YrRo3E9TfKY7b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hsQf2Cit; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hsQf2Cit"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08D871F000FF;
	Thu, 10 Sep 2026 23:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789084710;
	bh=OSyv85sQW5laW4Qqzawqx0ot70KFjEONI3a8uKJ1kgY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hsQf2CitJTJWsqRyprsGlake5D+wZzIE/dq2oOzkYKALRomni9k54J2NrqAZ1a2f1
	 IFZwmZ0DR7R8BI8vAyWkZxrw/IRGtZ7DhM7HENO/fzcDr749zYRCwC++KWkxtUovRS
	 HqjoSrdj2dYjfFYLzp5K1ngOWmynkKVthYCMUFz/GmiDrUtK3jA2bs6Km1nCSk5H0j
	 IK6n84w8pbw+/MdKsc7QdSqBX2ZFviM4mhwyVH6A9xiRLC3IGwryuhqubMCNKyZLNA
	 dLmbEc6OzgsIGb0uTQspTLed0y/Tw6AHqGsIZEjfChI45WCknGP34OECxudi0j1keo
	 6SLritWEok4lw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 03/10] net/mlx5: Extract MLX5_SET/GET macros into
 mlx5_ifc_macros.h
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jason Gunthorpe" <jgg@nvidia.com>
Cc: linux-rdma@vger.kernel.org, kvm@vger.kernel.org
In-Reply-To: <3-v5-4cacb99249f6+1b4-mlx5st_jgg@nvidia.com>
References: <3-v5-4cacb99249f6+1b4-mlx5st_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 23:58:29 +0000
Message-Id: <20260910235830.08D871F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Extract the entire MLX5_SET/GET macro family and their internal
> helpers from device.h into a new lightweight header
> (include/linux/mlx5/mlx5_ifc_macros.h).  device.h cannot be
> included by the VFIO selftest because it pulls in rdma/ib_verbs.h;
> the macros themselves depend only on endian helpers, BUILD_BUG_ON,
> and basic C types.
>=20
> The moved macros include the internal helpers (__mlx5_nullp through
> __mlx5_st_sz_bits), all size/address macros (MLX5_ST_SZ_BYTES,
> MLX5_BYTE_OFF, MLX5_ADDR_OF, etc.), the 32-bit accessors (MLX5_SET,
> MLX5_GET, MLX5_SET_TO_ONES, MLX5_ARRAY_SET, MLX5_GET_PR), the
> 64-bit accessors (MLX5_SET64, MLX5_GET64, MLX5_ARRAY_SET64,
> MLX5_GET64_PR), the 16-bit accessors (MLX5_GET16, MLX5_SET16), and
> the big-endian getters (MLX5_GET64_BE, MLX5_GET_BE).
>=20
> device.h includes the new header so existing kernel code is
> unchanged.
>=20
> Assisted-by: Claude:claude-opus-4.6
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0-v5-4cacb99249f6+1=
b4-mlx5st_jgg@nvidia.com?part=3D3

