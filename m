Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9078E4AE8BE
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 15:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789487032; cv=none; b=l+EV2DkUfuP30iLBfaS7gAcgxOFg4N62Pbl669gSV3XVgO9BcPaHoYiP040VrYtPpvjiP7+PPMiI0YMQ0xcwtAZ6eCqPx4x1tqbKLQXB802zd249Ft1GlPoZ8I/9f6vimpXWNGKI4PZ4XyBYXsPAzf/U9TN4yi0lIZe3qwcBhPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789487032; c=relaxed/simple;
	bh=NMp9l9GPNhX71sHJg3xltkCLtsDhH3BH5DrkuLJi50U=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ghWD+pvgXrA0LfcLR7x/RaNp33Tz/TjeGrpIKwhqmcnV5AgWdZUBJfPkej2nn5BDSob5v5TwXKZyVEU8hxT4ust8nDC35mXFFtX06T5yiErUL/uu9p4xMSDhcvfTu9SQ+emEqrKbUiQLnNE9gETouxK48cK9x7ehUOZ6SSO1+ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=THgHAncH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="THgHAncH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E163F1F000FF;
	Tue, 15 Sep 2026 15:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789487030;
	bh=vgmkU8YNqsFLuJ/UIHK3+wXUqlikmUpaV9uZyZ6Y5As=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=THgHAncHYp8PbA9kGVNd3pHcvNVhc6IryaNP91PmWXL7rYftEbVmeC7+ukzNuDe9x
	 /JlPjE+2WVESHqVl+nlhkRAI8U5EX4CqtND+WXAJhCN/TVQVmQ6BlI1Mhz0LEFCiKw
	 OWJlczdM+07bq2U5wef38Jc45KlRLWexRUi3iVjidg8Q430GVmB+Zj/w5XqC1d9JCT
	 j0ntmh36oxpRw1ihgE8Wh9TsUIjVaC8dxmNEngrDRyZ47/dDg6xQ2jcIDXK9VMCVFQ
	 0/sXcNR68Dey/Fm/AtuexwvYOzy3sIF9/rlt0e92xqfRc9wIj4I6EXxmAghedfh9sU
	 9WsvYA5ts5qwg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 2/4] RDMA/mlx4: Use unsigned comparison in the
 CQ cleanup loop
Reply-To: sashiko-reviews@lists.linux.dev
To: "Edward Srouji" <edwards@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260915-fix-cq-cleanup-v1-2-e991944cf898@nvidia.com>
References: <20260915-fix-cq-cleanup-v1-0-e991944cf898@nvidia.com>
 <20260915-fix-cq-cleanup-v1-2-e991944cf898@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 15:43:49 +0000
Message-Id: <20260915154349.E163F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Yishai Hadas <yishaih@nvidia.com>
>=20
> __mlx4_ib_cq_clean() sweeps the CQ backwards from the producer index
> down to the consumer index:
>=20
>   while ((int) --prod_index - (int) cq->mcq.cons_index >=3D 0)
>=20
> Both indexes are free running u32 counters, so the comparison has to
> be done modulo 2^32.  Casting each operand to int and subtracting
> does not do that: the subtraction overflows whenever the two indexes
> straddle 2^31, which is undefined behaviour, and a compiler that
> assumes signed overflow cannot occur is free to discard the
> subtraction and fold the expression into a plain signed comparison.
> That comparison is not wraparound safe.
>=20
> [ ... ]
> exactly that many iterations regardless of whether either counter has
> wrapped, because the loop no longer compares magnitudes at all.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Edward Srouji <edwards@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-fix-cq-cle=
anup-v1-0-e991944cf898@nvidia.com?part=3D2

