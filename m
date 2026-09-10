Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF0D3D5652
	for <linux-rdma@vger.kernel.org>; Thu, 10 Sep 2026 09:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789032429; cv=none; b=beTL/wVX7LcF1hn+Zh8A0vcRcdrp2PRwh22VroxM8c5oC6XPYU+kXd9JCE2jPafLReOmaLL6hP5xRlyGDS13PSixylsODHzixPork7YlrheZmr8tLcxntM7G0nSvpHk9107wNVw7c/ovUSNi4pTWzaDPLnNVwSl/yzH9x2gZ830=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789032429; c=relaxed/simple;
	bh=XOBflwLMWYm6v5ePkmxifhF2HJ4d0By5GxqLZbPeBW0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cn05lSOmTEsOSTZIXjGJHOIgHlqhEKQhJvOMuqcXIX4ep0VKMbw/idGOEQDAJDHrGKJV7DgvYdTD0nraJD4SbcshNuLF/Wyie+m/tP9BYG2WGTtMYqXNbg1YNug/I4hJUzIsimDxxlHazWCEG6ahQ3//FCk/JYjv8/rcmaBjRZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RJhqFO26; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RJhqFO26"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D70F1F00893;
	Thu, 10 Sep 2026 09:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789032416;
	bh=k8oz5tsa6J7CF1sgPIf6OddfXw8SkDd5vj6BjNlnQrQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RJhqFO26TbR7LmQIFrSRubX+lu2YR+TRFzUxMKbhoXMdoIju/nGXoo7O5rxI2/azD
	 iKyQUygjciEeMSSP+3O6V7MKYTBMRPp3o/MMVm0LMVp1mNaScgS/jILnDrZzNxyvHj
	 syeUfcaQnLzC80NPwjeESnu3mf0u8cn5mT7vx/JbVfskOS5rnGWkdNwUTsuKH8Bwqu
	 i8wc3ItHVQ8THeY+QibSN9lXzWIEFmF2tjRokimyfskrDiSyDuhnDFx7Ya8PheAKk5
	 yW5fJBfkEmSaFlJOP/bUrNSlRt4Vx+uMI2TCvXcQeoFGK21uB3a6RqadITHarvn2bi
	 agxLP4Js48I1A==
Date: Thu, 10 Sep 2026 12:26:51 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Selvin Xavier <selvin.xavier@broadcom.com>, linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com, kalesh-anakkur.purayil@broadcom.com,
	Yousef Alhouseen <alhouseenyousef@gmail.com>
Subject: Re: [PATCH for-rc 1/8] RDMA/bnxt_re: Reject executable mappings of
 the DBR and toggle pages
Message-ID: <20260910092651.GP13683@unreal>
References: <20260906230700.12233-1-selvin.xavier@broadcom.com>
 <20260906230700.12233-2-selvin.xavier@broadcom.com>
 <20260908134553.GO13683@unreal>
 <20260909132948.GI2543240@ziepe.ca>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909132948.GI2543240@ziepe.ca>

On Wed, Sep 09, 2026 at 10:29:48AM -0300, Jason Gunthorpe wrote:
> On Tue, Sep 08, 2026 at 04:45:53PM +0300, Leon Romanovsky wrote:
> > On Sun, Sep 06, 2026 at 04:06:53PM -0700, Selvin Xavier wrote:
> > > The BNXT_RE_MMAP_DBR_PAGE and BNXT_RE_MMAP_TOGGLE_PAGE cases of
> > > bnxt_re_mmap() hand out kernel pages that userspace is only supposed to
> > > read. VM_WRITE was already rejected, but VM_EXEC was not, so userspace
> > > could map these kernel pages executable. Reject VM_EXEC as well.
> > > Also, return EPERM instead of EFAULT.
> > > 
> > > Fixes: 9b66c9af7172 ("RDMA/bnxt_re: Clear VM_MAYWRITE on DBR/toggle page mmap")
> > > CC: Yousef Alhouseen <alhouseenyousef@gmail.com>
> > > Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
> > > Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
> > > ---
> > >  drivers/infiniband/hw/bnxt_re/ib_verbs.c | 8 ++++----
> > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > > index ccd2702db78b..e39f99434923 100644
> > > --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > > +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > > @@ -5057,11 +5057,11 @@ int bnxt_re_mmap(struct ib_ucontext *ib_uctx, struct vm_area_struct *vma)
> > >  		break;
> > >  	case BNXT_RE_MMAP_DBR_PAGE:
> > >  	case BNXT_RE_MMAP_TOGGLE_PAGE:
> > > -		/* Driver doesn't expect write access for user space */
> > > -		if (vma->vm_flags & VM_WRITE) {
> > > -			ret = -EFAULT;
> > > +		/* Driver doesn't expect write and exec access for user space */
> > > +		if (vma->vm_flags & (VM_WRITE | VM_EXEC)) {
> > > +			ret = -EPERM;
> > >  		} else {
> > > -			vm_flags_clear(vma, VM_MAYWRITE);
> > > +			vm_flags_clear(vma, VM_MAYWRITE | VM_MAYEXEC);
> > 
> > This is an opposite to 10bf13c33450 ("RDMA/mlx5: Remove MAYEXEC flag")
> > commit.
> 
> Why did we do that? These MMIO mmap should never be executable

I don't remember the rationale, but if I understood my findings correctly,
clearing VM_MAYEXEC broke memcopy.

Thanks
