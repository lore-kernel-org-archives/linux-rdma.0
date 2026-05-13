Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3A13E5ED8
	for <linux-rdma@vger.kernel.org>; Wed, 13 May 2026 14:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778682159; cv=none; b=FHCzuCz3uAUqJ41n46By1l2F12v2HKA40LII2bceuPNTKzjsZC23BGffKDLSlK64VeJSFgUesXxDW7qGQ8XNMV1pZcEWdYoYOnjMz0H/kSU8OX64VLMY6ro6nwc74Mn/1EPIfz8RGQIQSBa/cJL5bwogLM9xzl3C5uNUslJCVGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778682159; c=relaxed/simple;
	bh=eokDPabbJ4RytfG+q3hyVSJBHFBsujuwydBRjnzr5VQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UkZpbJ2ioKT6EYyYfqAZH9ubB3Xl6D7Kmce/2HdAl9OBo7hNdJYBIUIRqzNycrkCHKIuNUqYU4tiUYgCcgZXgeC/wfoI95oTsphJLveCspHYAfgZLQEcdtujT/T3wCO42xnBUGXl94GoYl69iHPQGGX/JybvImaQ3r9e4Jb78EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mJtc/Hgf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mJtc/Hgf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78976C19425;
	Wed, 13 May 2026 14:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778682159;
	bh=eokDPabbJ4RytfG+q3hyVSJBHFBsujuwydBRjnzr5VQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mJtc/HgfBQu4D26OslKASqxWXjZV9P47KNx8IoLAVCcbGg4Hxg4OTCiOLMVLzty3Z
	 FO1OQDkJkbJF1fGbsjkecamURIcDXGUdjMW14JWeHrRrhx/DD6XAaTRmZBy9h51SJO
	 ZrrQbGIW8suFtUB2KFfjr3oTPUoZFafFsLaqK9u8lSWILmwwiA7hjgWhg9BLB48TfO
	 gsvxiXZs+3+oBrRNz/JO6a5E6dLemBnkyNsYsCYddxDwxJzV6rL3mz0aibJBpTMmLy
	 p5ckNnRxcAqMlII+GF19bSHXZUKoARoDY1gBD1kwO2NI2lvvaMWfV1lh/reSH/PsJs
	 NmCuB0JqSfkNA==
Date: Wed, 13 May 2026 17:22:34 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Chenguang Zhao <zhaochenguang@kylinos.cn>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Vlad Dumitrescu <vdumitrescu@nvidia.com>,
	Sean Hefty <shefty@nvidia.com>,
	=?iso-8859-1?Q?H=E5kon?= Bugge <haakon.bugge@oracle.com>,
	Kees Cook <kees@kernel.org>, linux-rdma@vger.kernel.org
Subject: Re: [PATCH] RDMA/cm: fix timewait leak and AV cleanup on
 ib_send_cm_req() errors
Message-ID: <20260513142234.GG15586@unreal>
References: <20260507094317.1018853-1-zhaochenguang@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260507094317.1018853-1-zhaochenguang@kylinos.cn>

On Thu, May 07, 2026 at 05:43:17PM +0800, Chenguang Zhao wrote:
> cm_create_timewait_info() success was followed by error returns that
> never freed cm_id_priv->timewait_info, leaking it and tripping the
> WARN_ON(timewait_info) on a later ib_send_cm_req().

Could you please include the kernel panic message printed by that WARN_ON()?
I expect that the failed ib_send_cm_req() is handled and cleared later by
its callers.

Thanks

> 
> After cm_move_av_from_path(), cm_alloc_priv_msg() and ib_post_send_mad()
> failures must cm_destroy_av() the moved primary/alternate cm_id_priv
> state before unlock; fold both cases into shared cleanup with kfree of
> timewait_info.
> 
> Signed-off-by: Chenguang Zhao <zhaochenguang@kylinos.cn>
> ---
>  drivers/infiniband/core/cm.c | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
