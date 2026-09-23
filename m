Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3723ABD9F
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 14:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175161; cv=none; b=V/4vFwk2qQO710GFO28XgLXGyUsdk57HaTeG4fxZ9aoAzeT4pP86X5Q17Ww3McUcfbRim6eil/q+/URgW0N5cdby7hFMQlzPH+lbZDNl9QSdWudKK3GKdaKUIGWNmBQSEmOlBnByMAfYZYSq02oruiAnOcJrxWgq+xuCfZ9sACg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175161; c=relaxed/simple;
	bh=BNJ7YGjquUsKLw0ZRfjdRp45YCGhU3x9xJh2I7I21uA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=SBaMtr+rWOpItSHs5vlqGftaAo5P/eglcRWrCYkYvBeB0nNByTqSLOVZC0FT4bQNrly6jysiKNA7jA55ar1pEZDFZwbnGZt5A2l7328V0P5WOFkRnU6GshnhK3bciO03DSb7Lz6Xn6fq499fvU0hJ//vgAY3FOJZwEvPGAdm2mM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R+rBRHkT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R+rBRHkT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC3C1F00898;
	Wed, 23 Sep 2026 14:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790175157;
	bh=BNJ7YGjquUsKLw0ZRfjdRp45YCGhU3x9xJh2I7I21uA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=R+rBRHkTUZczxcl0ggWQW6ZX82towUmaYvYFi1+hJg/Qp+QH6Urk2VSU1tOTeDBS5
	 FHN+a+kfbp9YKSIfb2gNufVuteg5iYPa4SZNoLM8VQ4txuTXfiC7n6e0HQ+WExoaKw
	 tNR5NlWWUqmrMZY/MBDYVEUZef2PheNzpGZOndyxJIFaCZfWyHj0ySgpudM6hRxAlG
	 ZhMxJSUmtfsBG74SHKYegBZMpp3wErH/+IfwCAVDlzp5GI/9I3RmACBbrnAPVdOS3P
	 mxJEbChq7WBBqbKffbCweVfLNBLxV/fZ9IqtLyzk8GMLu3mpnYzEB0s3smFAD9osti
	 BDmrPXvmXq+0g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/2] RDMA/rxe: Reject IB_ACCESS_ON_DEMAND changes
 after MR creation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Norbert Szetei" <norbert@doyensec.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260923-rxe-advise-mr-v3-v3-1-95e1a4077e4d@doyensec.com>
References: <20260923-rxe-advise-mr-v3-v3-0-95e1a4077e4d@doyensec.com>
 <20260923-rxe-advise-mr-v3-v3-1-95e1a4077e4d@doyensec.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 23 Sep 2026 14:52:36 +0000
Message-Id: <20260923145237.2FC3C1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Norbert Szetei <norbert@doyensec.com>
>=20
> Whether an MR is an ODP MR is decided once, at registration time:
> rxe_reg_user_mr() picks rxe_odp_mr_init_user() over rxe_mr_init_user()
> based on IB_ACCESS_ON_DEMAND, and only the former builds an ib_umem_odp
> via ib_umem_odp_get(). The umem cannot change type afterwards, and
> is_odp_mr() reads mr->umem->is_odp.
>=20
> Two paths assign mr->access after that point and can leave it
> describing an MR type the umem does not have:
>=20
> rxe_rereg_user_mr() with IB_MR_REREG_ACCESS overwrites mr->access with
> the caller's value, and IB_ACCESS_ON_DEMAND is part of
> RXE_ACCESS_SUPPORTED_MR, so userspace can set the flag on a plain MR or
> clear it on an ODP MR while the umem stays what it was.
>=20
> rxe_reg_fast_mr() takes mr->access from the REG_MR work request
> unmasked and moves the MR to RXE_MR_STATE_VALID, on an MR that
> rxe_mr_init_fast() left with a NULL umem.
>=20
> Reject IB_ACCESS_ON_DEMAND in both, so mr->access carries the flag only
> for an MR that has an ODP umem and the flag can be used to identify one.
>=20
> Fixes: 544c7f62cf32 ("RDMA/rxe: Implement rereg_user_mr")
> Cc: stable@vger.kernel.org
> Signed-off-by: Norbert Szetei <norbert@doyensec.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260923-rxe-advise=
-mr-v3-v3-0-95e1a4077e4d@doyensec.com?part=3D1

