Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C90249E5;
	Wed, 15 Jul 2026 06:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784097163; cv=none; b=b6qlcedsXlqd4jS4JX2QkfOUuVh2HfyELgyMsVKZpLMA/NzptRCgCBwY/1BAJttGv0jPaLDmtx6OQ7926fetdShmI0U8OoLNtX0mg6S4kJxl8D3NqUsRFdLTM0aoV5P+WR5G4CHjNa8FntOpkLCQKRofkx0A0BjDboxzoNvu0JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784097163; c=relaxed/simple;
	bh=P0tWBaOrdBjB/s4wlWvugZdHiin2qiAtcZ1LYLTfS0Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bkyejYr9s62X9LD92jzfNqQjE7z4SgC9EYF8X0LDXADGTmB7s+MBtt5eo+CrkmqR2lVdZ2zgrDgeYZNP+N1k48sTV2z+GEkh0afmDmIjVMg4xQ+GKLgJ4htsWUZgnzEXoH73dO+XgQt7F3uJ5XyetApAs6GqXICrso2mcnGUulw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Oc6y2l1u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Oc6y2l1u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71241F000E9;
	Wed, 15 Jul 2026 06:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784097162;
	bh=p+q0rn9vcJyGll5D6hY89Cg+aX8Aptvuz7kMSAJHpM8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Oc6y2l1uh7gyMe35aY5uEmZK+PEOccIXhlOO1pBf99yoSFjdAmXynj57xsgepBZ1p
	 ULWeppq3h0vNcRX+I0ppfLp/LVQAcMu8vZzf0NsAWZ8T65+L3MKcv9azdaKWV9GYJs
	 9clLZ2R9hXinLLYu0m0HT+KL3y4wbbAjsjKN/YG1je6S6Va1hXzJLvtoKcO7NfHRoe
	 xUXF9+77HFblmWL/dRGMJrFZ2jdDoT3fr3DjjJEHssi2MU6kfXdYwoeyCsf3NW8zbk
	 24pyhH9O0d5HRNElUrJhunjkU7fqrthgk7cWTgTgVXKIg+fJ3bXCUf9i2Na8AA7H8x
	 j2EW1IPZAJJ2w==
Date: Wed, 15 Jul 2026 09:32:36 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH v2 0/5] RDMA, IB: replace __get_free_pages() with
 kmalloc()
Message-ID: <alcphPwP175Xzqli@kernel.org>
References: <20260713-b4-rdma-v2-0-65d2a1a5180c@kernel.org>
 <20260714122456.GD19233@unreal>
 <20260714122818.GE19233@unreal>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260714122818.GE19233@unreal>

On Tue, Jul 14, 2026 at 03:28:18PM +0300, Leon Romanovsky wrote:
> On Tue, Jul 14, 2026 at 03:24:56PM +0300, Leon Romanovsky wrote:
> > On Mon, Jul 13, 2026 at 10:17:21AM +0300, Mike Rapoport (Microsoft) wrote:
> > > This is a (small) part of larger work of replacing page allocator calls
> > > with kmalloc.
> > 
> > Will you also change get_zeroed_page() in RDMA, or should I
> > prepare a patch?

A patch would be great!

I do plan to audit all __get_free_pages()/get_zeroed_page() etc call sites,
but obviously it will take some time.

For now I only sent patches where the replacement was obvious and didn't
require me to dig deep and I surely could miss some.
 
> ➜  kernel git:(wip/leon-for-next) git grep get_zeroed_page drivers/infiniband/
> drivers/infiniband/hw/bnxt_re/ib_verbs.c:                       srq->uctx_srq_page = (void *)get_zeroed_page(GFP_KERNEL);
> drivers/infiniband/hw/bnxt_re/ib_verbs.c:               cq->uctx_cq_page = (void *)get_zeroed_page(GFP_KERNEL);
> drivers/infiniband/hw/bnxt_re/ib_verbs.c:       uctx->shpg = (void *)get_zeroed_page(GFP_KERNEL);
> drivers/infiniband/hw/mlx4/mr.c:        mr->pages = (__be64 *)get_zeroed_page(GFP_KERNEL);
> drivers/infiniband/hw/qedr/verbs.c:     q->db_rec_data = (void *)get_zeroed_page(GFP_USER);
> 
> Thanks

-- 
Sincerely yours,
Mike.
