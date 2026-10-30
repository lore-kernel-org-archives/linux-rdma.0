Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336044;
	b=ReCVIgMddJZl/3BPLAqvG0qI0vH0xGDtrTI/HATZDK0UQV+cy2UCaZEFBLGM0YyFubRp
	 eBlXkl+Yr6rVFpy4hmZYMI8w4vwyPMxc1CtCVkamFNhWKIxxS9khQg5J+5E05N9iFsbNy
	 562Cs1f4dPBS6ByM0nVkhx+b4N3D5JENIGC+98Z97m+3cDWcuG21dFk0nAIW/MjK5Erb3
	 goPhkQcS51ytraT3oF95pMh9v2Wfu4Fo4qU2bsUygiyE2m5LNvJPSqwjTvgF8IatkfnPG
	 KkRCepaKwLu03Zpva/fT5BM2toU83aKIS2geFXsFUWBd1nv3PWEswflnyN/LJ4+u2Fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336044;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=WLaXgBqMAl1NCOkm1Xwp8LmMoiL7y/P6nmAOWGsOBFk=;
	b=gnSkLYQctaF/Tad8Yk49ql8V++6P5razR2pbePZqlv1tV7Cl/5P8GHN3EP3o0W/xkkXv
	 9NE8/m2vlYLfnfFB9g6Sj9T49QWXlAfnTwj4kv0WZsMvmri4n9vxagCsZ+HyOp6OKUcX+
	 PElyPPn24G5OFq9Ti5zLgq2oVND9Xa+sLW5v0Wn6UcOZ72Z16JxGCYWOfZ3qRo42Yxgcy
	 wgjfObAylaPLZdIGns0pMdV6QwBRC8d/rI0CKPjiF5TxgDEPQywSeNSHWIGaRD3p0oY7g
	 c0YK+fjsLIy65c6xidKvb2QxqXPHd47gbfk9GeZBoGfRdaHwrItaXyJlYM6UfN/8+DA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XSywrNBJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C37606A32C
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 04:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XSywrNBJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0E11F000C1;
	Fri, 30 Oct 2026 04:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793336043;
	bh=WLaXgBqMAl1NCOkm1Xwp8LmMoiL7y/P6nmAOWGsOBFk=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=XSywrNBJkKqkVvEQ5gcDsGMHbyRn1bxfqsk48WVXNIccOBQoAxPBcbSvvMhPFJni5
	 KxkJ+gyaCgfzD21g65bneJ+PeUtNxSG1meZ8Jw9pM2nGon0zppsW/PbL9+hlqfLo7z
	 Z9ZQAcxk7AXgZbGGvf3l3yRdQ6TngPOpUQu+Sxyu22866tCj+FFo/OOCZ4F/jTY4ph
	 6G3HGKi6PCl11u88KOQRQn33WSWnlMPWfMU7pa3qagd23/G2nseOB7kssPe1tQAmvQ
	 igRiiu5rtUoj4Uhbnk3h+Ou1HC4BMnwe/uvelXXI8uSyKEoMAYcrw5dyiox6IMOsPQ
	 SHU+0CiJUy4kQ==
Message-ID: <sashiko-outbox-190398@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v12 net-next 3/9] devlink: pass param values by pointer
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ratheesh Kannoth" <rkannoth@marvell.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20260508034912.4082520-4-rkannoth@marvell.com>
References: <20260508034912.4082520-4-rkannoth@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 04:54:03 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> union devlink_param_value grows substantially once U64 array
> parameters are added to devlink (from 32 bytes to over 264 bytes).
> devlink_nl_param_value_fill_one() and devlink_nl_param_value_put()
> copy the union by value in several places. Passing two instances as
> value arguments alone consumes over 528 bytes of stack; combined with
> deeper call chains the parameter stack can approach 800 bytes and trip
> CONFIG_FRAME_WARN more easily.
>=20
> Switch internal helpers and exported driver APIs to pass pointers to
> union devlink_param_value rather than passing the union by value.
>=20
> Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260508034912.4082=
520-1-rkannoth@marvell.com?part=3D3

