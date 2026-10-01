Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CDF74F5DF0
	for <linux-rdma@vger.kernel.org>; Thu,  1 Oct 2026 09:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790846663; cv=none; b=V7em+nrNA2XzII0WdoMkRqKUM1mTp0IUCs4F6A0ieamyO4rpOPpG7AV91V85LEXrNBvT08OL+QA/VedufUqAsUU5ua6UonTOvsrVOvv9o0VV1IzResfM48j42MyGM7yWjnEA6yXDwhh0pVXqjqoxNjbPquCdJnK8Io3rFRbJCts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790846663; c=relaxed/simple;
	bh=9h36VM7s3cuDveMqwHT9zmVo/7EYD5E5lJJWU4LHgpk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uLnzyHtlrbiJI3GxNfAMelhqAvdJUIiHxlfwUgA2dhAkNpa3d8hxqWbGoPGCRQ9P5ZjR2pLzILv/yL9bC8RmDgWPMhWAf5pS13JaaA5Al4ivZIz9mDdjQZf7QtDOTaoteeDBUztj1sWSnB2En8sV16TRMA4uQJi7hzullmdvNYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gSrE6vj7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gSrE6vj7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 587EB1F0089A;
	Thu,  1 Oct 2026 09:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790846659;
	bh=9h36VM7s3cuDveMqwHT9zmVo/7EYD5E5lJJWU4LHgpk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gSrE6vj7nMQQUVOvVks3lUHIHCLC4Po9L2dpQfUwCbg5wFe/vZrqKSOeDfkh0ZLed
	 w0WpD5UaFy1WZnDJrUkzgUCoAvrNPR84DZQbqzbiDbF/7Z9Xlc4jHEeFAqbdQeuUJi
	 iNprwwSTLiFDCYGCI4jWy3xU1uoZhmQ3yTar4tiUGPkckPygGna/yAWAzk5QcloNdd
	 hSk7KIZ5K+7/ViKX9JGfn90lRFkgbCXWigQrt7I9A/hWt64e9Bqe7tyVyZE3qfN9J0
	 QTVckDARz56ZeM1KRicjEE2KYbRAfjF+mcoZhWvqaSfMYFBXi0dtcruJLgS6a0bT51
	 fCdXh5eRnbZvA==
From: sashiko-bot@kernel.org
Subject: Re: [for-next v4 2/5] RDMA/ionic: support firmware-assigned CQ IDs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abhijit Gangurde" <abhijit.gangurde@amd.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260930092111.3176738-3-abhijit.gangurde@amd.com>
References: <20260930092111.3176738-1-abhijit.gangurde@amd.com>
 <20260930092111.3176738-3-abhijit.gangurde@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 09:24:18 +0000
Message-Id: <20261001092419.587EB1F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> When the LIF advertises qid allocation for CQ, let firmware return
> the completion queue ID instead of allocating it in the driver bitmap.
>=20
> Split CQ create/destroy into distinct phases so cq_tbl is updated only
> after the ID is known and removed before the destroy admin command
> returns the ID to firmware, avoiding a race where a concurrent create
> reusing the same cqid could have its xarray entry erased by a stale
> destroy.
>=20
> Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930092111.3176=
738-1-abhijit.gangurde@amd.com?part=3D2

