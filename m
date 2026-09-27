Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5AE38236E;
	Sun, 27 Sep 2026 06:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790491926; cv=none; b=U5SFjwYbzN4mW2OtRG6CvXmqglyB/K8QegRYfZ9AXBi/CrUIq6v963xW6oFzuRwI8YzoOl5PSWotNk/IqYU1j2TS90GBnqbl1BiCj34YyrCRGqausdI3DMSKAYOwuwPP0V8xWzP3XPVSbouG4kmjlKUvXL/t6QtklR2iC9BiWVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790491926; c=relaxed/simple;
	bh=ynH+B6mXCyor1D4OFPAAO52cGK+AWKyV6XE3An2hHzs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=oF5xzvQj6yVJoZTk1a3wCAxPF7yPilzP6U9AV1aDS5ayHPLkgPbe7ln2b+EJGB6BZ5CXfnil0fWPAHTuBihkuLYiCcy2mUlUV0dTzcjUvCNtDS1mw5G7VrFI7gVkEXwSoxRPi/G02Ma/mR0g/LWszLWFuSYBJwcZniOx4qiSLJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dnCl+lMs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dnCl+lMs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54AA51F000FF;
	Sun, 27 Sep 2026 06:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790491924;
	bh=z20sqVQfke3IuSJa6B/2UmnjjEM6Ex87/9pcj93ux+E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dnCl+lMsc4tQnuCkbqzUGJMrjHm77elHQOpm7ULkm4MD8TWqqsklde1o+QCLi2hUJ
	 J5LzcC9WS79Xw6pxlikT1NxKcaAao3lHUL031LxjyGNL5X6mn7amms4YTBlYsEv+QD
	 JAjMg3jdCoiwSa8S920u8yJJQZXCPGPqK6SWOFj/ktHYfVOV2fvJTDxmbHo+oZkVle
	 iksCu+6zOWsOvI+EwkPO6Yt1WNZxLrnNOMMnRzcT0rTRvHSZdBGISOAbWcQkmPPd6p
	 1Uaec0AKF32ymxtjYtUS9pgJex98nXhV/FKjqtEnnLPY+fmwhjbs3rkuv2YB44FLJi
	 1Aa/vxJh8A22Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/smc: Serialize early link group cleanup with
 termination
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chengfeng Ye" <nicoyip.dev@gmail.com>
Cc: "Vasily Gorbik" <gor@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20260927063607.3691520-1-nicoyip.dev@gmail.com>
References: <20260927063607.3691520-1-nicoyip.dev@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 27 Sep 2026 06:52:03 +0000
Message-Id: <20260927065204.54AA51F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> smc_lgr_cleanup_early() calls __smc_lgr_terminate() without checking or
> setting lgr->freeing. A concurrent smc_lgr_terminate_sched() can claim
> freeing and queue terminate_work before early cleanup takes lgr_lock.
> Early cleanup still enters __smc_lgr_terminate(), where both callers can
> observe lgr->terminating clear before either sets it. Both then tear down
> the same link group, causing use-after-free and duplicate resource releas=
e.
>=20
> KASAN reported:
>=20
>   BUG: KASAN: use-after-free in __smc_lgr_terminate+0x393/0x3a0
>   Write of size 1 at addr ffff8880bf2c0300 by task poc/106
>   Call Trace:
>    __smc_lgr_terminate+0x393/0x3a0
>    __smc_connect+0x2e3d/0x4930
>    smc_connect+0x42c/0x580
> [ ... ]
> group alive until early cleanup has checked teardown ownership.
>=20
> Fixes: f9aab6f2ce57 ("net/smc: immediate freeing in smc_lgr_cleanup_early=
()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260927063607.3691=
520-1-nicoyip.dev@gmail.com?part=3D1

