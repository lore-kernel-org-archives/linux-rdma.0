Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37F7370AE5
	for <linux-rdma@vger.kernel.org>; Sat,  3 Oct 2026 01:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790991186; cv=none; b=Yfw84cJS1jGJ1FkmfrWApIcVMg3/DhnNo/7GEbtTHbavcu5ZMF5nuyCCIEUUMMnL76/m/pbj3QQ7BEWqxNe2UO+Gw/SSCC0XH0OpufhI6ZZpBBgdKuxa8YlIoqrFNU91ct+GLUK0dPREPlQhd6cpx2n8OAobVhHQXLxF9EQoN6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790991186; c=relaxed/simple;
	bh=UuQqudqE1vH8IcGlW6Hv3F4+EJN9kp15EQu7GSiJ+T8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Ss/f+9uLgYRdyIYCbFK7d4gkQlKejSXjXmdfP6Ty7Rr0mslQ1dDyqfh+4d2VFtFl46KYycR2Y2DNwal7f3vBbnH2ip628HgxaanGM3t6lYC+nkvqMqI9RkPglJ0yL6wtcwGFk+prmn8YPNLCYgFxoCyWAe9LDDQImRNy8ceWzjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RmSlU8T3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RmSlU8T3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17D101F000FF;
	Sat,  3 Oct 2026 01:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790991185;
	bh=JoFIMYmz7bmQVgMbxC+oOevGu7im5Jy09mZnnd9kn0s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RmSlU8T3TW+YGn3J6pGEn6bR+qM9mlelWXTkVz6NWR6p3tkLisg5+vUmwocsOHHim
	 QP7F7SBc4JyJFKJq1PtieqN7/juEE9sF/n834ughc8j75SJTq0NlQ1bfK7f5GIOo87
	 XGL5PvEoKk7eCT+00/xvCkxCrm7vvo+vVzwfkcP5Unwz6EYUHwBMLsns+yEzmLvy6o
	 KknhIggdYGgrqECFBnKcWESDDhg7hnI7/+4jR62pByqDNy1mFqYAqbcG83AXNyfhUq
	 ZsBsdrDCitcKs+PuLB4AQjXI4PN4S1zBRNUe8HW06g1vD1gMUXSOVDmPLbTmpIbgWl
	 4h1BzhpPMXPAg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] RDMA/rxe: Fix out-of-range unsigned-to-signed
 conversion for RDMA message in 2GiB size
Reply-To: sashiko-reviews@lists.linux.dev
To: "Honggang LI" <honggangli@163.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261002142250.657151-1-honggangli@163.com>
References: <20261002142250.657151-1-honggangli@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 01:32:58 +0000
Message-Id: <20261003013305.17D101F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> When RDMA READ request for 2GiB in single WR, res->read.resid is u32
> 0x80000000, which is INT_MIN (-2147483648).
>=20
>     payload =3D min_t(int, res->read.resid, mtu);
>=20
> The `min_t` function will return -2147483648 for payload. The wrong
> size is propagated through call chain, `read_reply` -> `prepare_ack_packe=
t`
> -> `rxe_init_packet` -> `alloc_skb` . `alloc_skb` failed because of
> invalid size. The passive side failed to emit response packet for RDMA
> READ request.
>=20
> After fixed it, the active side of RDMA READ failed with error code
> "IB_WC_LOC_PROT_ERR". When RDMA_READ_RESPONSE_FIRST packet recived by
> the active side, `do_read` call `copy_data`. dma->resid is u32 0x80000000.
>=20
>    int resid	=3D dma->resid;
>=20
> This conversion set resid to -2147483648. `copy_data` abort as length
> greater than resid.
>=20
> RDMA SEND and WRITE 2GiB message works too, after fixed these two bugs.
>=20
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Signed-off-by: Honggang LI <honggangli@163.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261002142250.6571=
51-1-honggangli@163.com?part=3D1

