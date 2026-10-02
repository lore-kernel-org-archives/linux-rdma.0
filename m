Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E7348820B
	for <linux-rdma@vger.kernel.org>; Fri,  2 Oct 2026 11:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790939648; cv=none; b=Y0WdaVpqh5YLNlGHHJSfUHxueMb34E2RwuwUM8UIKOmP5buCld25t0zP2g54dbi5eonwfl6TVpiEkvL0DNF6kkTpqCMS9Uzn7j3j7lNokciYRkpdxU6DaMT966C58FZcQGBozW5Eu3xIEGfKCNDPckOhLLvwU/HLNpqHgv0abtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790939648; c=relaxed/simple;
	bh=cbrvw5/hbnBVDhDUnlAd8toYiqhrB52ctswrnkhjZ3M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=u7Lal4GvPDt7hsyyFblwIv6D8g1QrPqiUryjH+7DyJWf0Mn5WBi6LHO2gQX6QX7qH12I/N7HzGN4lt5Pn4KjqAJ1oMWk+F9GTR958eOvrU2C93iiD+TdoeBKhgxguYx6EZqxANECB8QAA99GF5cnlXI+py/PmGgqy1YU61Oj5DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i0Dz3jgx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i0Dz3jgx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2332E1F000FF;
	Fri,  2 Oct 2026 11:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790939645;
	bh=veyah7rD/w4/ECBzL8pHJf8AG1kE5uDTDhV8XvFQMZ0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=i0Dz3jgxgAHwT0wYrF+3B7I0QzoW/hAPpuRYitJvYNeJb9p1QB4qcx5c9Gmey3Y2v
	 9P0UUhLtOJ4qeW8ThS/3rYQt5y2ncQllfV4ls4ssLj2u0AL65RwWkJpEIe6qoDAADz
	 73G3VexU5qC0rIZnnhshVEuJERZD6KAPpMOdjSoQdE6pBAhgE6Z8e7GMYuRBnwZveq
	 qHcat+zao6WNOVCoSFc1SxFwV/dDMqH/twQeb1gjnnrKd89mQhD+13y8+5VF3HGUC0
	 cOSuwhHZQVHorZ6lP5AcbhqKFJFtnst10k0YOifJdtWkviAnZC7qiOFt9yyZDEk7d5
	 FO0GC4MG6M9Hw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/mlx5: Fix NULL deref in del_sa_roce_rule() on
 allocation failure
Reply-To: sashiko-reviews@lists.linux.dev
To: lirongqing <lirongqing@baidu.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261002110329.2350-1-lirongqing@baidu.com>
References: <20261002110329.2350-1-lirongqing@baidu.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 02 Oct 2026 11:14:04 +0000
Message-Id: <20261002111405.2332E1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Li RongQing <lirongqing@baidu.com>
>=20
> get_macsec_device() allocates and links a new mlx5_macsec_device when
> the macdev has no existing entry, and returns NULL when that allocation
> fails.  del_sa_roce_rule() only flagged the NULL case with WARN_ON() and
> kept dereferencing macsec_device, so a MACsec SA delete event for a
> macdev that was never set up by the RoCE GID path would dereference NULL
> under memory pressure.
>=20
> Return after the warning so the SA delete event is dropped instead of
> oopsing.
>=20
> Fixes: 58dbd6428a68 ("RDMA/mlx5: Handles RoCE MACsec steering rules addit=
ion and deletion")
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261002110329.2350=
-1-lirongqing@baidu.com?part=3D1

