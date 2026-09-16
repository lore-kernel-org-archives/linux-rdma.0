Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E89F944E650
	for <linux-rdma@vger.kernel.org>; Wed, 16 Sep 2026 07:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789544194; cv=none; b=uetP1k6c7JEET9BWRaGpSvDNdaR0GpQ+GJtV1gDeUPGUR2+M3W77oNJGW4CbnrCY91r1jAHjk1ezaCYen7Jd8UgKRhBDQGEuJI90RODmVHIW628T2K/TneCxpuge5eXficzarJof0sc3dOYtsO71jbdycCpeqS3zyVPKEcRpyW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789544194; c=relaxed/simple;
	bh=THeJOp+0xAi9IRveLL0jEBhZxUISZDC5lABaQF01eCQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EC6djPx12vuy4d2T10Gefdq+JUoFkWYS5a5jm4qoIEfD/I4UKRuM++HYoIbwyM5fnKub+ZdvcHAb2cNg9YGHYbi+pILPkr7rHzWvEv1jXImAItSgNhgmhcblKL7meU92AGRDG4+4vLTG27VyCzbyA8NPkQukOnmp22zF8QA1Vsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c4mFI4qi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c4mFI4qi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A43C71F000FF;
	Wed, 16 Sep 2026 07:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789544180;
	bh=D5EA7FzB+kFgP1vaZm7zTF7sIr0buwAKSqP4QFLQFhs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=c4mFI4qi1l5NpHpi8OXNxHmGwg46D9+HYB1xP/ccKTxcQAiNjx+m23y2to+zU3U/l
	 Adr9CqVFU2zrwVafdC//reTHb+DY6lpJwLijde4P9mIFo/Y7RSeyTJhITr2n22GiRI
	 +VCqWW3WGltsy0t6PI7TcIr9IQGS0QFqGcLKpfX4K6j+4Ska79IfjwoBcGP03gnYI8
	 LhG+AtcWnU+5nqKZ1IuUbyvLg9ZLhIhEO391RDU6BtrCRHKBTu5r6QUoRkHGKOVIUx
	 eyoo18JZhu/+1PClrAAHvVbGGawk98wuLW9mN1RO+6OrevF2PUPRfyryv6qN+VikTM
	 CT9SxUwkN2gvA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/restrack: Don't set RESTRACK_DD mark after a
 failed xa_insert()
Reply-To: sashiko-reviews@lists.linux.dev
To: lirongqing <lirongqing@baidu.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260916073042.1746-1-lirongqing@baidu.com>
References: <20260916073042.1746-1-lirongqing@baidu.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 16 Sep 2026 07:36:20 +0000
Message-Id: <20260916073620.A43C71F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Li RongQing <lirongqing@baidu.com>
>=20
> When adding a QP to the restrack xarray, rdma_restrack_add() does:
>=20
> 	ret =3D xa_insert(&rt->xa, res->id, res, GFP_KERNEL);
> 	if (ret)
> 		res->id =3D 0;
>=20
> 	if (qp->qp_type >=3D IB_QPT_DRIVER)
> 		xa_set_mark(&rt->xa, res->id, RESTRACK_DD);
>=20
> The xa_set_mark() call is not guarded by "!ret".  When xa_insert() fails
> (possible on a qp_num collision or memory pressure), res->id is reset to
> 0, yet the mark is still applied to index 0.  If a legitimate QP whose
> qp_num is 0 already occupies that slot - e.g. a normal QP or the SMI QP
> - it is spuriously tagged as driver-private (RESTRACK_DD), and the
> netlink dump path res_get_common_dumpit() then hides it from "rdma res"
> output whenever the caller does not request driver details.
>=20
> Only set the mark when the insertion actually succeeded by folding the
> mark into the non-failure branch.
>=20
> Fixes: e18fa0bbcedf8 ("RDMA/core: Add an option to display driver-specifi=
c QPs in the rdmatool")
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260916073042.1746=
-1-lirongqing@baidu.com?part=3D1

