Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949093A7586
	for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 11:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791890538; cv=none; b=sm6xIyxQb5ZGypRa85oavdywUvwRJcm3u9REarZ2Bc/jFUAAcvjwCmju5LiMbQcQIW7kFr58OwewxqNXr+L+K8ptmlnF2q3qh+yCWkWA4Nb28Qdkdstoi3yR/DIz/jlG0qx2RJ0XetcNJtSTZ9MOsDqYKhiqTdGsXfabGPrs5dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791890538; c=relaxed/simple;
	bh=R131rufAONM4surqkfAa+Bd12Qn7qAvarz391xZxaKc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mF13SFP10+xkL4bkDEyIOTpcf/A7azvUsDNk2xh7fbGlqAcy9BRAWdpMesfZD+NZSVkJnBAuALAKua6CUDcSR+g4qEfRUr+xkwa6H9GGo89rBWBzjRXYhOIbFVFET5fYKuIazp2MEF1+C69NsL/DEwBGMwrwfiOyMGtGJ0UPT8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YLBn+aV9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YLBn+aV9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C3A61F000FF;
	Tue, 13 Oct 2026 11:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791890536;
	bh=qrQo9x/+DcsSaxQagqijvM4ATMrpD5zbhsiLTpHuHs4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YLBn+aV9BjCsMDahy234put2xynT5bE/dTsb+EnHkE8NunFfKgUZHv46sVA+34TrP
	 JpxBdMqxn1XsXq3K5u+Pm5/AkXXIgd7Vh+8/hfIyjt2Pg1sUiSU5HkiKt/5653zq5L
	 M+n1HrMZHG5iqROOA4r8+UCf3HgIJNsaVBGBU2fij8HUtNFtMQL+unSqcfYjAr6GVd
	 t3jY0ggY4YLvx5RqPeKwiOG40J0QpZuXEEBqqxIVEqUXGcZT2Q2Me8RXmN6kApLcaY
	 TX9VAWX0fJauSv2KAoazMqNB+aXtIylGDXogq+R3tbpaWlBMXr38X7xub0CtsthNLg
	 sVtVLh9bJ9Zqg==
Date: Tue, 13 Oct 2026 14:22:11 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jacob Moroni <jmoroni@google.com>, tatyana.e.nikolova@intel.com,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH rdma-next] RDMA/irdma: Check MR contiguity before PBLE
 alloc
Message-ID: <20261013112211.GM219304@unreal>
References: <20261010194832.2415477-1-jmoroni@google.com>
 <20261012185010.GH14213@ziepe.ca>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012185010.GH14213@ziepe.ca>

On Mon, Oct 12, 2026 at 03:50:10PM -0300, Jason Gunthorpe wrote:
> On Sat, Oct 10, 2026 at 07:48:32PM +0000, Jacob Moroni wrote:
> > @@ -3487,6 +3442,8 @@ static struct irdma_mr *irdma_alloc_iwmr(struct ib_umem *region,
> >  	pgsz_bitmap = (reg_type == IRDMA_MEMREG_TYPE_MEM) ?
> >  		iwdev->rf->sc_dev.hw_attrs.page_size_cap : SZ_4K;
> >  
> > +	iwmr->is_contig = ib_umem_is_contiguous(region);
> > +	/* Call best_pgsz after is_contiguous to restore correct umem->iova. */
> >  	iwmr->page_size = ib_umem_find_best_pgsz(region, pgsz_bitmap, virt);
> >  	if (unlikely(!iwmr->page_size)) {
> >  		kfree(iwmr);
> > @@ -3846,6 +3803,7 @@ static int irdma_rereg_mr_trans(struct irdma_mr *iwmr, u64 start, u64 len,
> >  	iwmr->region = region;
> >  	iwmr->ibmr.iova = virt;
> >  	iwmr->ibmr.pd = pd;
> > +	iwmr->is_contig = ib_umem_is_contiguous(region);
> >  	iwmr->page_size = ib_umem_find_best_pgsz(region,
> >  				iwdev->rf->sc_dev.hw_attrs.page_size_cap,
> >  				virt);
> 
> You should not call ib_umem_find_best_pgsz() after
> ib_umem_is_contiguous(), it is nonsense to compute a page_size once
> the contiguous optimization is being used.

ok, I dropped the patch from mu wip/leon-for-next branch for now.

Thanks

> 
> Once you decide to use contiguous the start dma address should go
> straight into the MR structure and just avoid all the pbl stuff.
> 
> Jason
