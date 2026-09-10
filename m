Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FD0499F09
	for <linux-rdma@vger.kernel.org>; Thu, 10 Sep 2026 13:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789048068; cv=none; b=tYqrJmNvVIZjT+LWOhEZKG2Dus00A/Jk3JQA4Ou4T7bsFziFyuidiF6m/Lf1SXpQkGx1El/Eid6J+XPtbKetKeCOJ9mtPlbc7OU8PPT7/KI75Y12cegyqQ15bUyPIK52K/wkbXGKZFVg+KZhXWAORRjpckKpVT7SbyT8r2tUNUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789048068; c=relaxed/simple;
	bh=QCs+nyDlfq+Egfuj5KrFci5ET6dMzc8HMPyKm8L4ns0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jE6c23fHwDeU+Eq34ERCdlPH7QOWa0w/25JgmyujVSq7qxXM0YhZuiGq8KDQyN9c/SDyfY117ecM5U7I/hp5lZ32XCCezRBwZ1yXZYachL+qGVwn2HYFCdrjBuwoycO63Yq233jgb7Qt8meVlfSD/WxTbrL9xriwBdkbhVlfMyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=A3Dy5nr9; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="A3Dy5nr9"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-5306baf6b53so8229641cf.1
        for <linux-rdma@vger.kernel.org>; Thu, 10 Sep 2026 06:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1789048065; x=1789652865; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=C3LRy1FcGQ54AR6O2xTf3g586FfK5YFdKf900ViuaGg=;
        b=A3Dy5nr9umC8wFROgINE7323woJsQ7rdNSlfBo0OHGKSXjETtb5A4R0HVd2OJRIfmv
         YrG697EW+hEEW+HroS8DueWGvdO20w9SKVhQpW+y0hjQIbPDqRmUbL7TgXTLNPbDyyKY
         WoduASbtYPF9IkZeXTt/ucbtfBXDueJcwsFOXYntFIGAVap79gzG+f3Q14UGm2e/vwo8
         /KtYa6DLWNwIioswBAief3rNrVlgz5e81oHPWAzI9ubinDZUVsZNFf6GNC+uBqKFU7ew
         4hTKCtwIO0SvPsVa0KxNRl/w+Hivobgs6ySACZ6q5S45Joi7yKhhwwahE32SjJQw9IY9
         clxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789048065; x=1789652865;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C3LRy1FcGQ54AR6O2xTf3g586FfK5YFdKf900ViuaGg=;
        b=A7qRLNgQN2loAAgQ9XNYCkrFiK/ZSXjzj5TIyLqVwIY1uFwmIWPZ0AJZWcIGlFcixi
         RMWcwLaf6YAlyBKGVksPLbD9okk9F+ylQJhYGT6KlADv3QzodoJZBfpY1F+eAI56ib1G
         dYWmBuCASyPq28xhZBNFZY7XYCtO2C1LjnVzKf2+M35QF8gI1zGzztXlfQox9bTsQrML
         p8iRovLBXA4q+OFJJNl0j2W0zT9KQpibRu9fqrK+dPKkajFiDuhPQxp2jadSZ3P/lzuT
         oD3PxKQP1HjGz0xtCEls52+j+sS/FZOIOC5AUD4M9t5J0eVii6tHhMmi4JpIiuzDVN9Q
         JdIw==
X-Forwarded-Encrypted: i=1; AKwUvBzTGehGtc887zSRNhb9e3qcTHaHbI0aVcDJt9sm4zzet0iWvVGmhvyO8ULguGquMP9dMQ19GPg8JMfD@vger.kernel.org
X-Gm-Message-State: AFuF++looYRfS/m3kbh9uWBqo3gdZPhIaOpi4Cjpj5OkSscgNI85Y83g
	bgQxZ7MHGUrDFl358RwI0sm6ZwWqmkoX5XNoN7CTE/aZHil7BF4SHGGgs+3/Gf5VV8Y=
X-Gm-Gg: AYBFou2Pe7zVExCRszvcnH9+qgzB10XJ9LPGm1irsXg1yCPBoPIWxylpUPM6n7SjXcD
	RH+Os+pX0OhhWM4mqc05BKmVGFwFv/blwCBub0fO/7xL819dGnIKgsT6Z7vKOP7VGJs4T4UPAnA
	PKJHueCJTuRKYEWVNRAHnZE76jCxdNzEtI3/xQ07szf4MDoT7ikkZPQjwNp8ydTmKF8UJKiMDyK
	nzYrIQd8UJVN7HHQbifc6a9aC1PiiGMUctaI6bOOyqNJ6nj0YHju+fmR7yWfPmezf/mtQgrsqs9
	lx4yL8YBORty8umjOiEFRZfbBcPXhuTnVthOCwFoGo6ET95PAWNgUZD+edUF+NbNaGujHwfddMX
	6Y1PCizrP95Ne18Ql+gG3ZpR461afFNc0DVOlR9WlgWbT+a+Be5fyadFyuw27OTjpYLR4ztU6sE
	siFGJqPN3+ObBew2DSSFQgMrLfwq5BnWVWvXVxpi4KT9MhZKkUZDgYByTHjN/0OIxkriiSaxMK7
	EdyeHofd+A7c3YYhFrUvWSXGM96wbE530LnaRe12e2dCAYJP7ylt9cc
X-Received: by 2002:ac8:5714:0:b0:530:b2e2:d7dc with SMTP id d75a77b69052e-530b2e3c6abmr68791841cf.55.1789048064998;
        Thu, 10 Sep 2026 06:47:44 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9397fb36129sm1711109985a.19.2026.09.10.06.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 06:47:44 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1x4f7v-00000002VOf-2PyG;
	Thu, 10 Sep 2026 10:47:43 -0300
Date: Thu, 10 Sep 2026 10:47:43 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>
Cc: Selvin Xavier <selvin.xavier@broadcom.com>, linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com, kalesh-anakkur.purayil@broadcom.com,
	Yousef Alhouseen <alhouseenyousef@gmail.com>
Subject: Re: [PATCH for-rc 1/8] RDMA/bnxt_re: Reject executable mappings of
 the DBR and toggle pages
Message-ID: <20260910134743.GC4083318@ziepe.ca>
References: <20260906230700.12233-1-selvin.xavier@broadcom.com>
 <20260906230700.12233-2-selvin.xavier@broadcom.com>
 <20260908134553.GO13683@unreal>
 <20260909132948.GI2543240@ziepe.ca>
 <20260910092651.GP13683@unreal>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910092651.GP13683@unreal>

On Thu, Sep 10, 2026 at 12:26:51PM +0300, Leon Romanovsky wrote:
> On Wed, Sep 09, 2026 at 10:29:48AM -0300, Jason Gunthorpe wrote:
> > On Tue, Sep 08, 2026 at 04:45:53PM +0300, Leon Romanovsky wrote:
> > > On Sun, Sep 06, 2026 at 04:06:53PM -0700, Selvin Xavier wrote:
> > > > The BNXT_RE_MMAP_DBR_PAGE and BNXT_RE_MMAP_TOGGLE_PAGE cases of
> > > > bnxt_re_mmap() hand out kernel pages that userspace is only supposed to
> > > > read. VM_WRITE was already rejected, but VM_EXEC was not, so userspace
> > > > could map these kernel pages executable. Reject VM_EXEC as well.
> > > > Also, return EPERM instead of EFAULT.
> > > > 
> > > > Fixes: 9b66c9af7172 ("RDMA/bnxt_re: Clear VM_MAYWRITE on DBR/toggle page mmap")
> > > > CC: Yousef Alhouseen <alhouseenyousef@gmail.com>
> > > > Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
> > > > Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
> > > > ---
> > > >  drivers/infiniband/hw/bnxt_re/ib_verbs.c | 8 ++++----
> > > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > > > 
> > > > diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > > > index ccd2702db78b..e39f99434923 100644
> > > > --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > > > +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > > > @@ -5057,11 +5057,11 @@ int bnxt_re_mmap(struct ib_ucontext *ib_uctx, struct vm_area_struct *vma)
> > > >  		break;
> > > >  	case BNXT_RE_MMAP_DBR_PAGE:
> > > >  	case BNXT_RE_MMAP_TOGGLE_PAGE:
> > > > -		/* Driver doesn't expect write access for user space */
> > > > -		if (vma->vm_flags & VM_WRITE) {
> > > > -			ret = -EFAULT;
> > > > +		/* Driver doesn't expect write and exec access for user space */
> > > > +		if (vma->vm_flags & (VM_WRITE | VM_EXEC)) {
> > > > +			ret = -EPERM;
> > > >  		} else {
> > > > -			vm_flags_clear(vma, VM_MAYWRITE);
> > > > +			vm_flags_clear(vma, VM_MAYWRITE | VM_MAYEXEC);
> > > 
> > > This is an opposite to 10bf13c33450 ("RDMA/mlx5: Remove MAYEXEC flag")
> > > commit.
> > 
> > Why did we do that? These MMIO mmap should never be executable
> 
> I don't remember the rationale, but if I understood my findings correctly,
> clearing VM_MAYEXEC broke memcopy.

That doesn't make sense..

Jason
