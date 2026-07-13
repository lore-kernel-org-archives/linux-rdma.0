Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD195353A79;
	Mon, 13 Jul 2026 15:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783956180; cv=none; b=ulpP9JTuKo0p2me51YaTCsnXWSCL6wFe04PhiTsMqD/j472P3c9GuZtIjMMYfx7bTrI+R9wc8Fxd42HI3HVp8CTbgjrWV3tc2408rzqZDA2g1bP2oufyJ7PMl/XTBOD39HKW9cyIiTk+uQnv9LYMA4IFzHzoLSW5YzGP3tG/Mac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783956180; c=relaxed/simple;
	bh=0YYEYSS/IGj16a1+muAIdyG1NJAaU+H7u5shtlw/7CQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z/4B6i7xSUa/WZj1BSSgDG5dqgp3zo0gREM/atLSzCmlyw6vdIpXzXE91AIeY97Mvy+wGzjkItnQLSxqhZqXD9wTcPTeacdJfmV8mBfn+9JsFgJeBhUOKaDq4FVPSKLJ1x67SsdcjwwRzjGZitG7lC8G/BM3i4qFVBpUPKJRySA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eaDdfbdX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eaDdfbdX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 597E21F000E9;
	Mon, 13 Jul 2026 15:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783956179;
	bh=LcD4sVSiqqSJEolFvViBXQG8PPTYn6mUjVJz4B7Yvcw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eaDdfbdX0yl1oduOwlwWqfZNS8dYM4c1/nLEUAWeZDarWAEhJvt9OQQQAmyKeOG0q
	 Kmpha++uZDsd8Xp3tDExLPa09iMfozRUAFpbgD5eNoKqMO+Xq/KvT8pKmpBsoQOw7F
	 Kpt7hWVo7scJOHTr/BxBYFEgnQuPR5Efu8ZEa19fPBCSLntUssy2KukquW/mor4lM+
	 9dEh4qrXYIDYIR39eo6OQ9q1e5CyBMqudkjk643onABjrD1V9cEVIX474kRC9uvcA8
	 sEVu8+Qh6xdX1QQcQIWq3EXugQsSFJIm1VQ72hhPKldReNlcm9uk0KiiBvnljkpcSg
	 A6X8EE6+2aQjA==
Date: Mon, 13 Jul 2026 18:22:53 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Konstantin Taranov <kotaranov@linux.microsoft.com>
Cc: kotaranov@microsoft.com, longli@microsoft.com, jgg@ziepe.ca,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH rdma-next v2] RDMA/mana_ib: Adopt robust udata
Message-ID: <20260713152253.GP33197@unreal>
References: <20260713100955.3512145-1-kotaranov@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713100955.3512145-1-kotaranov@linux.microsoft.com>

On Mon, Jul 13, 2026 at 03:09:55AM -0700, Konstantin Taranov wrote:
> From: Konstantin Taranov <kotaranov@microsoft.com>
> 
> Enable the uverbs robust udata interface in mana_ib by setting
> uverbs_robust_udata and converting the driver to the new udata
> handling model.
> 
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
> ---
> v2: Removed the udata request for alloc ucontext
>  drivers/infiniband/hw/mana/cq.c     | 10 +++++--
>  drivers/infiniband/hw/mana/device.c |  1 +
>  drivers/infiniband/hw/mana/main.c   | 29 +++++++++++++-----
>  drivers/infiniband/hw/mana/mr.c     | 15 +++++++++-
>  drivers/infiniband/hw/mana/qp.c     | 46 ++++++++++++++++++++++-------
>  drivers/infiniband/hw/mana/wq.c     | 16 ++++++++--
>  include/uapi/rdma/mana-abi.h        |  2 +-
>  7 files changed, 94 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana/cq.c
> index f2547989f..a5757847b 100644
> --- a/drivers/infiniband/hw/mana/cq.c
> +++ b/drivers/infiniband/hw/mana/cq.c
> @@ -27,7 +27,8 @@ int mana_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
>  	is_rnic_cq = mana_ib_is_rnic(mdev);
>  
>  	if (udata) {
> -		err = ib_copy_validate_udata_in(udata, ucmd, buf_addr);
> +		err = ib_copy_validate_udata_in_cm(udata, ucmd, buf_addr,
> +						   MANA_IB_CREATE_RNIC_CQ);
>  		if (err)
>  			return err;
>  
> @@ -105,6 +106,11 @@ int mana_ib_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
>  	struct mana_ib_cq *cq = container_of(ibcq, struct mana_ib_cq, ibcq);
>  	struct ib_device *ibdev = ibcq->device;
>  	struct mana_ib_dev *mdev;
> +	int err;
> +
> +	err = ib_is_udata_in_empty(udata);

You should use ib_no_udata_io() in destroy/modify/resize flows.

Thanks
