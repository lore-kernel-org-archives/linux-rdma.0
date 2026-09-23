Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63DD5326AB
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 13:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790169762; cv=none; b=rLhd7bU1+klnvSOwwcMXE4mFLchXutNKX4U//Z+1dk2yHvgau4sRuU0YSUOryOGQGjQ3ryo9yihth7txxfqleULUCFymFgb3LFzjPAeyGbO7Izch3YhgqWn162NnNYyTuLqlG42xyMzY7kjQSkNJpPAVWsgh18EULXdbxAj9QyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790169762; c=relaxed/simple;
	bh=Yk6IlHzWDxdm0pwZEbgIjflGGVzBIW+tD0xjxya9BsM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bLXWH8jl9IS1unDANytpVpJvUna763cvPHsjaLGFHWeJ0sAyjQpHx/oXcAFoT1uSo3YE26UIJVKXg3xgRnxH7x/sMgTnaeENLjedH3n7PaKO+M80JaqrWNoEqKPpOsUI6Golcyh0u1onU+0Ypf3RshxPJVDEEB0/uYRJGQzHbHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n0u11O/R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n0u11O/R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C4F1F000FF;
	Wed, 23 Sep 2026 13:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790169760;
	bh=Yk6IlHzWDxdm0pwZEbgIjflGGVzBIW+tD0xjxya9BsM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=n0u11O/RmOFp0pS1T9wUYDrJhuffojfp2wiaRxyXjrwU0teeFCjkj7pASQ2WhWjhO
	 5krVAgc+iKtDIVN1Ba1CSb344ScQg3GRb2IzXSRFXPSnKQQLrBjgI8DfqtQcCDiTko
	 +v+eXtuoP0cUZstyXHuvTg6jMo4P1W6pLJEBJIfSvC9P+oRNt1RTkyheIlBAO4oAza
	 789LyLZDQKCCCaji53mSSxdNZih5sWOTcOP3GKlbt8YzdliNLdF/QxQgWHkmkUJTiB
	 v5SMCJOXw4zlCeKmRJeCTJ6UOtnSvFKV/C0h3ZP3oQ9g/FeZSCQHhpr+G3yga8lXhW
	 AT9o51NmJwHmw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] RDMA/nldev: Fix NULL deref in dumps of objects
 abandoned by DRIVER_FAILURE
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yili Zhang" <zhangyili01@baidu.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260923131239.6521-1-zhangyili01@baidu.com>
References: <20260923131239.6521-1-zhangyili01@baidu.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 23 Sep 2026 13:22:39 +0000
Message-Id: <20260923132240.34C4F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> fill_res_cq_entry() dereferences
> cq->uobject->uevent.uobject.context->res.id unconditionally for user
> resources.
>=20
> This is normally safe by ordering: destroy_hw() removes the resource
> from the restrack before uverbs_destroy_uobject() clears ->context,
> and the XA_ZERO_ENTRY marker set by rdma_restrack_begin_del() hides
> the entry from concurrent netlink dumps.
>=20
> The ordering breaks when a driver keeps failing to destroy an object
> during ucontext teardown. uverbs_destroy_ufile_hw() then falls back to
> __uverbs_cleanup_ufile(RDMA_REMOVE_DRIVER_FAILURE), which
> abandons the object in place: the HW object and its restrack entry
> are intentionally leaked, while the uobject bookkeeping is torn down
> and ->context is explicitly set to NULL by uverbs_destroy_uobject().
> [ ... ]
>=20
> Fixes: c3d02788b45a ("RDMA/nldev: Provide parent IDs for PD, MR and QP ob=
jects")
> v2: https://lore.kernel.org/linux-rdma/20260917133340.42002-1-zhangyili01=
@baidu.com/
> v1: https://lore.kernel.org/all/20260813000442.GI662699@ziepe.ca/
> Signed-off-by: Yili Zhang <zhangyili01@baidu.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260923131239.6521=
-1-zhangyili01@baidu.com?part=3D1

