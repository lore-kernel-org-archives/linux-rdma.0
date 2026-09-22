Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90EC733EAF3
	for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 01:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790038907; cv=none; b=kmgG6M9InStgYUvA/rAVt/YKXx8byC8ph6cH+OcKQKc2pGrXveRGQb/VYDlfrI0cnCas8DuLBMrfQVT+SbzB29NgpTQ7UcCxfmcDd/ky8Q5cftoM+vxc6+qSeG6UTF1IwdrLICVd2S1wa8Xlw+Ze0abLNpv88gnPT6XCTY7Hjkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790038907; c=relaxed/simple;
	bh=O8eklyqWYeuKV/U3ujBhz4ZiYrbJTqocdnbmOMIdmNI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RTwIZ2ck5ntLA+F81obZwi+WTpYlN+bkxpzJaASoqp8bIKv0+QXHOisOgC38JbBT/JvrSBwZ5WX8XRakzNnbgUgV0H56IWhMkDB6CCrR8eCU35ihtmrB/xqbZ0/3yl7L5utpWq2ecrVNDSybRu1aj+43rHMPImEE9btTwx/puHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cmsXYiHP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cmsXYiHP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 169B51F000FF;
	Tue, 22 Sep 2026 01:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790038906;
	bh=O8eklyqWYeuKV/U3ujBhz4ZiYrbJTqocdnbmOMIdmNI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cmsXYiHP20AhnQL2tSkMd6Wgt0Uvu5LSjtUSIxhFmIWym1dbzOjl5+nAZQTeTsiB5
	 NtKqZ7TAmkd5yvRD8ANuNzDPQ4aO+9/hRGXBJ71crhM6IWvZRzqLpwq9cEeCWHDzHW
	 PnQW5e/swKQ/KkhqOTiCik19VtXFMwbFbToAwFlSAFoczlbTTxx2WRKH1ulbcmo4qy
	 j7ITUIdGbraytWwybJHBrTI1m6tPe0kL2XTocHtxTgvy5REBXuxdjmwpaeOFyYl+Tg
	 DIP3l5qiUzSns4IJlWlIHQQ2x0UZEVb2TEpd40PsHzdcTv4WkBw4FcDd4kGrOnEb+9
	 Zq9Aeu88c8wtw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH for-rc v3 7/8] RDMA/bnxt_re: Fix the PD and DPI table
 size
Reply-To: sashiko-reviews@lists.linux.dev
To: "Selvin Xavier" <selvin.xavier@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260922061230.7909-8-selvin.xavier@broadcom.com>
References: <20260922061230.7909-1-selvin.xavier@broadcom.com>
 <20260922061230.7909-8-selvin.xavier@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 01:01:45 +0000
Message-Id: <20260922010146.169B51F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> The PD and DPI bitmaps were sized as max >> 3 (bytes),
> but bitmap ops (set_bit(), clear_bit(), find_first_bit(),
> test_and_set_bit()) operate on whole unsigned long words,
> so whenever max isn't a multiple of BITS_PER_LONG,
> the buffer under-allocates and the top word's bitops
> read/write past the end of the kmalloc()'d buffer.
> Most exposed on the DPI table, since dpit->max comes from the
> firmware-reported dev_attr->max_dpi with no alignment guarantee.
>=20
> Fix the size of both allocations with
> BITS_TO_LONGS(max) * sizeof(unsigned long).
>=20
> Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
> Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922061230.7909=
-1-selvin.xavier@broadcom.com?part=3D7

