Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B254322F1;
	Wed, 22 Jul 2026 16:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784737360; cv=none; b=oGYMAvs0zpGOgtxpy6gubJG3iio/0/0pIOgi7bY3TCy8ev0q8xs11CimQRPK0kIW0QQCvlTxyZ/AsUeHJdour4ZWRI5+ufy1MKyHmhuLV9M+wFouuvKDShlcxgrmYqsUSeMhifYcXf2T1Ponv8TyUGbKuXUMHmTn52zNxcYW9C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784737360; c=relaxed/simple;
	bh=TlRygPyGKudkCsDV+4Pt7QFDl/HKN7PgwWAAdpVHw7g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KVSLFoT8yAKpFWPMJWSla//Mvrfrpe14Zddk68OhsoOseAEt8hynPkC0Fl+2leKJvDYYlngI1V2xcJX+LCBWvKI8sOLBWPoAmGq4dRhP45xnR1Dx2CHC34lBk47NWJ7z+fpS/NW1u/oMSLBVez6lQCCrLJVmVdbdzjwr1ZRYV18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R85XZA8P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R85XZA8P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7058A1F000E9;
	Wed, 22 Jul 2026 16:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784737359;
	bh=y6ZnlxdnBQ2c4HHwmmH12bzle312APNOHn2hpQccjc8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=R85XZA8Pf4bMiWe+CXOgFhFb+A4cyu/woLJdVyXt3D5s7FBAoq6hohWsSqOTQmm4d
	 rqdNJJgLPSJ9ybeoVH8kXI12BQdiIZsdg9dAeQoPn7Qn6dOnOZRpHbjAqsIv/26+V+
	 rIz3srp0RRGic6P5OW8yb+ISsJBwVEufBv8ekVAIoT6T6j/7bXVBcXBJga2NpoXLJM
	 nSucx4H1RD5s3dewjejwTprZY+C50SqwzO1mtvZsnhxLxm4w8CVOMOuZSTCYtSl67a
	 +uvRbyIBBdUu/H714hxvLUicFOkbBHeaZ1ZrCpXLBtpuCFM+rutCzBwBuiGvUZPFna
	 yEozGEz6rDZeQ==
Date: Wed, 22 Jul 2026 19:22:33 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Selvin Xavier <selvin.xavier@broadcom.com>
Cc: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Chandramohan Akula <chandramohan.akula@broadcom.com>,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH rdma-next] RDMA/bnxt_re: Clear VM_MAYWRITE on read-only
 mmap of driver pages
Message-ID: <20260722162233.GZ110966@unreal>
References: <20260722-missing-vma-write-protection-enforce-v1-1-567cd8499e23@nvidia.com>
 <CA+sbYW0i0YQZO4wQRGXS9LEVGMmRtEhuAJYOZems2KmfCUfUCQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+sbYW0i0YQZO4wQRGXS9LEVGMmRtEhuAJYOZems2KmfCUfUCQ@mail.gmail.com>

On Wed, Jul 22, 2026 at 07:05:52PM +0530, Selvin Xavier wrote:
> On Wed, Jul 22, 2026 at 6:26 PM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > From: Leon Romanovsky <leonro@nvidia.com>
> >
> > bnxt_re_mmap() rejects an initially writable mapping of the DBR pacing page
> > and the toggle page, but leaves VM_MAYWRITE set on the accepted read-only
> > mapping. A later mprotect(PROT_READ | PROT_WRITE) therefore passes the mm
> > permission check and upgrades the inserted PTEs, letting userspace write
> > these driver-owned pages: the DBR pacing parameters maintained under
> > rdev->pacing.dbq_lock, and the CQ/SRQ toggle state written from the NQ
> > tasklet.
> >
> > Clear VM_MAYWRITE before vm_insert_page() so the mapping can never be made
> > writable, making any such mprotect() fail with -EACCES while the read-only
> > mapping continues to work.
> >
> > Fixes: ea222485788208 ("RDMA/bnxt_re: Update alloc_page uapi for pacing")
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/infiniband/hw/bnxt_re/ib_verbs.c | 13 ++++++++-----
> >  1 file changed, 8 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > index adc693736769..dcfb1b0ebc22 100644
> > --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > @@ -4984,12 +4984,15 @@ int bnxt_re_mmap(struct ib_ucontext *ib_uctx, struct vm_area_struct *vma)
> >                 break;
> >         case BNXT_RE_MMAP_DBR_PAGE:
> >         case BNXT_RE_MMAP_TOGGLE_PAGE:
> > -               /* Driver doesn't expect write access for user space */
> > -               if (vma->vm_flags & VM_WRITE)
> > +               /* Reject writable mappings and prevent mprotect() upgrades. */
> > +               if (vma->vm_flags & VM_WRITE) {
> >                         ret = -EFAULT;
> > -               else
> > -                       ret = vm_insert_page(vma, vma->vm_start,
> > -                                            virt_to_page((void *)bnxt_entry->mem_offset));
> > +                       break;
> > +               }
> > +
> > +               vm_flags_clear(vma, VM_MAYWRITE);
> > +               ret = vm_insert_page(vma, vma->vm_start,
> > +                                    virt_to_page((void *)bnxt_entry->mem_offset));
> Same change was done as part of my series which cleaned up the toggle
> page for CQ/SRQ.
> https://lore.kernel.org/linux-rdma/20260721115440.24021-5-selvin.xavier@broadcom.com/
> Do you want to take this and abandon my patch? I am okay with that. I
> can rebase my series
> once this gets merged.

I took your patch as you posted before me and added Fixes line.

Thanks

> 
> Thanks,
> Selvin
> 
> >                 break;
> >         default:
> >                 ret = -EINVAL;
> >
> > ---
> > base-commit: 0e8e94c15091041ea8910cbfcade5a9c7cfe3f90
> > change-id: 20260722-missing-vma-write-protection-enforce-2e99624c35dc
> >
> > Best regards,
> > --
> > Leon Romanovsky <leonro@nvidia.com>
> >


