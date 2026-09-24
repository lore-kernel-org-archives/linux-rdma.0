Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B16F311946
	for <linux-rdma@vger.kernel.org>; Thu, 24 Sep 2026 07:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790235873; cv=none; b=gFyYbDbAe8kSqAWIvFCwSohlPtYpAwJBn/wyW0DTSA7Iy7qYzPbeyobmO5WzIOg0yRg7FLGbXGqU1EOm0S2HcQj1CDhe4w9PSCTIvKcHfwR1MpWSp6RiP8R0TqNyIK16HSTAEgyqMeT6dzmDfF3cW9AKalqdUblVfKb86p5nGGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790235873; c=relaxed/simple;
	bh=jncOZ6bZNK8GxOvshtuSjJ9octQ7CUOiJX5HPxCH8/I=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RkkuJtqgtmzXtDFFA7K8BsHzOOpowhnlEUh8VVxWDtjGg3qfD4jLdUeT5GTvIn/CB9WDJmpyp+ESdIBDPP4+unN6A7KjpipsjbqVukbWBsZcN5BOUQheKtyNrhcSe/GYa1QDylj3ug7sGXSwP4+dfUD4TmDRh7JIrB7GCZBwI2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DAKjWPx2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DAKjWPx2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CDE61F000FF;
	Thu, 24 Sep 2026 07:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790235871;
	bh=jncOZ6bZNK8GxOvshtuSjJ9octQ7CUOiJX5HPxCH8/I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DAKjWPx2QDgi0TIWs3e02qp2fHfT4QtT5mR9CyeD6XRDaM6v49FZn55Jxo3ROMGYD
	 WE2CcfBHHQAOLvggn8khYi0Wd7Jdu9nJV0nzDhfe1MrvJY0rVUwK+rQsFJE707H+Yp
	 T80j9nFHWy7h+oJaYIfkSL5PY8vvrdIucGgrYUGlw+waN+uKpAVcsW181cXxl3GOS/
	 dOXoCNer4dh03FtBPkv5ze/SMpw9k5HINUV0TAnpcLHQhERw745ei6CPcl5O207X8n
	 0kPyzqsyjNm8uzkfUvt0+IniCCpPG+5hgjWxT0gadFq4gFdgc2q9+X82N+PaHhN5Cx
	 zyn1K3hcVPR+w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/siw: drop duplicate check_app_limited in
 siw_tcp_sendpages
Reply-To: sashiko-reviews@lists.linux.dev
To: "Geliang Tang" <geliang@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <32ef40cc81486adb8f2d43585224ab44d7e77f73.1790234916.git.tanggeliang@kylinos.cn>
References: <32ef40cc81486adb8f2d43585224ab44d7e77f73.1790234916.git.tanggeliang@kylinos.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 07:44:30 +0000
Message-Id: <20260924074431.2CDE61F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Geliang Tang <tanggeliang@kylinos.cn>
>=20
> After do_tcp_sendpages() was converted to use MSG_SPLICE_PAGES and
> later inlined as direct tcp_sendmsg_locked() calls, callers that
> previously needed an explicit tcp_rate_check_app_limited(sk) to cover
> do_tcp_sendpages() no longer need it. tcp_sendmsg_locked() performs the
> check on every path that queues data, making the outer call redundant.
>=20
> The site changed here, siw_tcp_sendpages() in siw_qp_tx.c, holds the sock=
et
> lock and invokes tcp_sendmsg_locked() on every iteration. The early-return
> paths in tcp_sendmsg_locked() that skip tcp_rate_check_app_limited() - the
> MSG_ZEROCOPY allocation failure and MSG_FASTOPEN branches - return without
> queueing any MSG_SPLICE_PAGES data, so there is no functional consequence
> from omitting the outer check.
>=20
> Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/32ef40cc81486adb8f2=
d43585224ab44d7e77f73.1790234916.git.tanggeliang@kylinos.cn?part=3D1

