Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE03D483BE3
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 11:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789473119; cv=none; b=kIReK+Q7RtE3Tvsan3zUVyen75cHWt11I8SVx7qQphPaFePxcy3T17KuoawMj7mHlzlbGnDaTLPhMu+fVSOtNyZt2EcDltg4u4j1Wm2AIqaBSXpbFv+Xj5YyPLfOxwCrEXTsiWGOciwwGR1vlEgxbXVI+HJq7ZtAoadfqkfXUE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789473119; c=relaxed/simple;
	bh=O2S3iR49YiYU1xUOPUlA3qsJZtiBOTAlI5kmaD07DwM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hi5HpMF25Q2CQGAcsvuUSF5IRkSTiSTGrZKOJ363LrX4lVxLdKreyj8tX+pklEM7Ee+ZPeDagYW+gl9LeGM8SzG3KN4eZ71O3ySsBefOSuBKP0YgPaMEEdd+7IxpzFd7hDvb6wiwuzJKPF5yxYjZkPOK+YcplnypvuPsvXCLxPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ih8zQVbS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ih8zQVbS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3324B1F000FF;
	Tue, 15 Sep 2026 11:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789473117;
	bh=lLKd1fk3Rh9YILe3f/oHrL/WcXmtE+TYj3XQyUvd6BY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ih8zQVbSpeSUUdhD5s+j0rw2DqklkixgTCjm1yqF2Bd9nivagZfAme1NLCRGsj1PP
	 2JmLHKmEjQ3kH/8B4NHlTyd+1ngzeR6xUNblP0vHh9Hfc4OYWPfHJXmBve3mS1s5Hb
	 FAMqMC9MWWEBsqZMwN9Sf57f6kfwFnuSnyqBXnCoL2KCYesieJEL51Zgyj8hLB7603
	 GDgmIUUHKdeBRsTpT2VCQV/oIVlC0P9Sl3o+V2TZdHFBAlr1mYD32QExHe3U1Levqh
	 L3xC6GeHXfQ/37qaJj6ODIJlt9YS4/f71IrtpqHlLo7vmtV5y8EivOj/jdf8Slls4L
	 Z78kYoKEj4+Pg==
Date: Tue, 15 Sep 2026 14:51:54 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Selvin Xavier <selvin.xavier@broadcom.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com, kalesh-anakkur.purayil@broadcom.com,
	Yousef Alhouseen <alhouseenyousef@gmail.com>
Subject: Re: [PATCH for-rc 1/8] RDMA/bnxt_re: Reject executable mappings of
 the DBR and toggle pages
Message-ID: <20260915115154.GM13683@unreal>
References: <20260906230700.12233-1-selvin.xavier@broadcom.com>
 <20260906230700.12233-2-selvin.xavier@broadcom.com>
 <20260908134553.GO13683@unreal>
 <20260909132948.GI2543240@ziepe.ca>
 <20260910092651.GP13683@unreal>
 <20260910134743.GC4083318@ziepe.ca>
 <CA+sbYW2_jnyMkFbqk-MHAcu=UswVJ90cQg_EgcXSnF0b_RaWkQ@mail.gmail.com>
 <CA+sbYW2tOKp33LwrfePC3YZoCEEW__pQ=XPKB7iUBYCwMbRGMA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+sbYW2tOKp33LwrfePC3YZoCEEW__pQ=XPKB7iUBYCwMbRGMA@mail.gmail.com>

On Tue, Sep 15, 2026 at 02:04:20PM +0530, Selvin Xavier wrote:
> On Tue, Sep 15, 2026 at 2:01 PM Selvin Xavier
> <selvin.xavier@broadcom.com> wrote:
> >
> > On Thu, Sep 10, 2026 at 7:17 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > >
> > > On Thu, Sep 10, 2026 at 12:26:51PM +0300, Leon Romanovsky wrote:
> > > > On Wed, Sep 09, 2026 at 10:29:48AM -0300, Jason Gunthorpe wrote:
> > > > > On Tue, Sep 08, 2026 at 04:45:53PM +0300, Leon Romanovsky wrote:
> > > > > > On Sun, Sep 06, 2026 at 04:06:53PM -0700, Selvin Xavier wrote:
> > > > > > > The BNXT_RE_MMAP_DBR_PAGE and BNXT_RE_MMAP_TOGGLE_PAGE cases of
> > > > > > > bnxt_re_mmap() hand out kernel pages that userspace is only supposed to
> > > > > > > read. VM_WRITE was already rejected, but VM_EXEC was not, so userspace
> > > > > > > could map these kernel pages executable. Reject VM_EXEC as well.
> > > > > > > Also, return EPERM instead of EFAULT.
> > > > > > >
> > > > > > > Fixes: 9b66c9af7172 ("RDMA/bnxt_re: Clear VM_MAYWRITE on DBR/toggle page mmap")
> > > > > > > CC: Yousef Alhouseen <alhouseenyousef@gmail.com>
> > > > > > > Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
> > > > > > > Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
> > > > > > > ---
> > > > > > >  drivers/infiniband/hw/bnxt_re/ib_verbs.c | 8 ++++----
> > > > > > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > > > > > >
> > > > > > > diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > > > > > > index ccd2702db78b..e39f99434923 100644
> > > > > > > --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > > > > > > +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > > > > > > @@ -5057,11 +5057,11 @@ int bnxt_re_mmap(struct ib_ucontext *ib_uctx, struct vm_area_struct *vma)
> > > > > > >                 break;
> > > > > > >         case BNXT_RE_MMAP_DBR_PAGE:
> > > > > > >         case BNXT_RE_MMAP_TOGGLE_PAGE:
> > > > > > > -               /* Driver doesn't expect write access for user space */
> > > > > > > -               if (vma->vm_flags & VM_WRITE) {
> > > > > > > -                       ret = -EFAULT;
> > > > > > > +               /* Driver doesn't expect write and exec access for user space */
> > > > > > > +               if (vma->vm_flags & (VM_WRITE | VM_EXEC)) {
> > > > > > > +                       ret = -EPERM;
> > > > > > >                 } else {
> > > > > > > -                       vm_flags_clear(vma, VM_MAYWRITE);
> > > > > > > +                       vm_flags_clear(vma, VM_MAYWRITE | VM_MAYEXEC);
> > > > > >
> > > > > > This is an opposite to 10bf13c33450 ("RDMA/mlx5: Remove MAYEXEC flag")
> > > > > > commit.
> > > > >
> > > > > Why did we do that? These MMIO mmap should never be executable
> > > >
> > > > I don't remember the rationale, but if I understood my findings correctly,
> > > > clearing VM_MAYEXEC broke memcopy.
> > >
> > > That doesn't make sense..
> >
> > Shall i post a v3 series with v1 contents again?
> Sashiko review mentioned to clear VM_MAYEXEC also. For your reference.
> https://sashiko.dev/#/message/20260909084241.570431F00A3A%40smtp.kernel.org

I lost track of it too. Anyway, if you repost it, could you check whether
this can be handled in the core code so that it applies to all devices?

Thanks

> >
> > Thanks,
> > Selvin
> > >
> > > Jason


