Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF24026D4CD;
	Wed, 11 Mar 2026 08:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773217965; cv=none; b=XwRmJOFWyX1isvPJ4pFuFLOgUCUA7dU3cJBoBDQ+RsBGpOkZooVAqtj6Ch2R0hwg5CzAx1i+9RFjXD6KK3Kq4YFZ816iI4RSFOyGOBUBRWIY8CygTUM2/+jRpw2KCb111uL6rgttcZQNjxulHBoOt8MgGAgKflVWwSgf/vSZ2pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773217965; c=relaxed/simple;
	bh=OFOcMi9IALKzlvmn/o6YfzAE6ZiZanzEDLJ3bnIzhHY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fj4YGkfi5zHFsEoFFcxsuyGbTrlhnZEofxHQcoVmbl7iTvyomWv3FARfRq5DpFBSeg+o8UrBXITCxjRvlVqTg+6hFKy+oyJuAmcyhTYe9qo1ignVIdlW0qAo7qxhbwA+tDVjjtJNTZfTCAobV/Fdmxe0yvZyzLqv0jNVM1uEOyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RpGe1hbr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RpGe1hbr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F09AC4CEF7;
	Wed, 11 Mar 2026 08:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773217965;
	bh=OFOcMi9IALKzlvmn/o6YfzAE6ZiZanzEDLJ3bnIzhHY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RpGe1hbrgyNnIxw29629BZMrbmIITMl4cmHH3JTuXgnDLKdKz+dp66JV6pGkSYm1o
	 fd3LCvTR31pFdw/6tiRmjm0X9aPK01PJvFcn4U29vXoW2PLxBztYA5Aj6EreQYU7aL
	 eNqgba/q5jGHEtzfrinmLBXVTb5jMOGCqsW9h0VXf0m5N9CLNhOlTJpVuzN+0kEfcZ
	 Dnx6myUvmry65zVuxdWOE5zV0CEUyMoOYDQqozhuTRLCg6zDcbKQ++oYn4+T1d8Zvu
	 hJFfu56JM8DkKeTLJPwXXN/zizKaWBsAv5sahgkxTGv89VUBDZaXuZGMBvK+/Jl0bT
	 C3ZCvEMpquodQ==
Date: Wed, 11 Mar 2026 10:32:42 +0200
From: Leon Romanovsky <leon@kernel.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/mlx5: Use clamp() in _mlx5r_umr_zap_mkey()
Message-ID: <20260311083242.GT12611@unreal>
References: <20260310145727.236094-3-thorsten.blum@linux.dev>
 <20260310212440.0df8180c@pumpkin>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310212440.0df8180c@pumpkin>

On Tue, Mar 10, 2026 at 09:24:40PM +0000, David Laight wrote:
> On Tue, 10 Mar 2026 15:57:28 +0100
> Thorsten Blum <thorsten.blum@linux.dev> wrote:
> 
> > Replace min(max()) with clamp(). No functional change.
> > 
> > Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> > ---
> >  drivers/infiniband/hw/mlx5/umr.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/infiniband/hw/mlx5/umr.c b/drivers/infiniband/hw/mlx5/umr.c
> > index 4e562e0dd9e1..1a6b0ac5c24d 100644
> > --- a/drivers/infiniband/hw/mlx5/umr.c
> > +++ b/drivers/infiniband/hw/mlx5/umr.c
> > @@ -1013,7 +1013,7 @@ static int _mlx5r_umr_zap_mkey(struct mlx5_ib_mr *mr,
> >  		 MLX5_IB_UPD_XLT_ATOMIC;
> >  	max_log_size = get_max_log_entity_size_cap(dev, access_mode);
> >  	max_page_shift = order_base_2(mr->ibmr.length);
> > -	max_page_shift = min(max(max_page_shift, page_shift), max_log_size);
> > +	max_page_shift = clamp(max_page_shift, page_shift, max_log_size);
> 
> Is page_shift absolutely guaranteed to be less than (or equal to)
> max_log_size?

I asked same question here.
https://lore.kernel.org/all/20260310184744.GI12611@unreal/

Thanks
