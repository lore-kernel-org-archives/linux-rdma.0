Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D097B5437C7
	for <linux-rdma@vger.kernel.org>; Wed,  9 Sep 2026 13:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788960594; cv=none; b=rtmVIlFuzk6pkabRKHKEfyXUOUDEC914jYFxEb7fn6J6llTOWJhqYQsvaX4RANHor6xkNOBh17MH6QnDRC4MRixlTfO9ypf+dXz/Z9aepOwAhJ73886IOy+xc1ghldchq0oSylzgLFRIspMeMW4JS5L76gpu/f1hpjxrYeFb4TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788960594; c=relaxed/simple;
	bh=39WYP2gu9kQVRv3OaMic7ybTDUDqYRBHMVm3ss7vcqY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lvH+XWZ9DWPtX+NuvIGkMljArpz5DJPjbM7EhelQwgy0b8bTFT7ZhVHozG7/nMh8BQiFQuXR62j47/0paYgMU02sN3Zx00U7JargPnkMrtNXlYL8y6pBUOc5kgGjfuZaQVb7W9BDE6TSPH7uoxQoeKu3Y7hJ77SdKg1hUa9Y89U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=SP6dQ+Fd; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="SP6dQ+Fd"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c262bc686d9so731006666b.2
        for <linux-rdma@vger.kernel.org>; Wed, 09 Sep 2026 06:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1788960591; x=1789565391; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=e3jDh6l3qx9cdUc/uGel7f40e7Bv4Sd7XMn2PaqW9LE=;
        b=SP6dQ+FdVKRadwsHAx6MuSJWWxcBWj1YFRlLgMyqZ3auvHYyOnQv4SY/34QGiXfRx4
         KJsqZH6gul8SHQ2VV6NUyGcnawW20yJrL8wftcwTGokf2q8uAXfkVpp+t0WZV0c1ElV5
         Orgn9k+72P7h3qumHbzJ9AeqUjwfwxy4NaJHhkR/cpj//cpHzTRhYz3/pIS4JdAke5Sx
         HlvYQkHA/8cG46QEtzTEDsAnfPkrPkLCik4KUyxQkWkd9XJG29MHg4hMva1G1OhjejSm
         8dh8dgg6n+TGLGdVZ6mB00Bkv+NaHFbYMDr6Fr3cu810czrdzkk3/1xZtZF+xEOIzbcM
         tMtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788960591; x=1789565391;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e3jDh6l3qx9cdUc/uGel7f40e7Bv4Sd7XMn2PaqW9LE=;
        b=S6buw7HrKY89JtczA5ynI7kcbpcR2CD/OYFXVMUxnUNlamGVZz6YNVruQ9eEz77Kww
         CuKPMTaQcIer6WF8yGeje3FcwKzvsvQkwYTB/wK2VYzrJansfRYJipgUjEqNNCXjCCUl
         iODWON7UBpKdqYP2J7y8UvNTahqldSWWmEFFhLKTHC2rgNeVpv8Y9VV+mOiOJYVS1oD5
         ACyWOfErC7ohXsolQaH/In9ZNZbm7bFz1Cz1PwNzTOEHRXqmpKmSGS8+w5CqI/qWIjQL
         oKSVuDWEsnuIpvRhQOTMl3xi/PWY7pi+L5AVSmaL/kWXyhd6P6acCS2yhzg+YlCkWRwl
         YQVQ==
X-Forwarded-Encrypted: i=1; AKwUvBz1j6Zh1fB/+W++kcrX6q4oAs27Fe6P3150mUtu5MCPYcstjat04kZJQfyaWzuhkqVvcQcGkqSbSYq3@vger.kernel.org
X-Gm-Message-State: AFuF++mpHpzC9LSnH2YFL8JClDt4iS6AUnSOoe5woQni+gcYJdQHMbxD
	7a4wKoga8DeZnZvg9UaKC6X+rOIuGl+qSb0WBkXNs49wE7bB5TtJizWOYeTZxBGmius=
X-Gm-Gg: AYBFou0vo27pvHA3GREilLC1WMgyf8uqZpMJrF6Zeh5YiCw1RkzZInwo2aodS06D6u5
	A/EeOqo3IH5FTGHAwrwKb1d3ORVuySlb3nbSIcBYpDI1QUm88WRbk+79U/18NIVQI9vwp1ITIb7
	0Da27zc7odBo9wQyvoA2gtdC/xM5yXm4hd5NivcPkRIpf1HEGFUAzTRSFloHHIb5cqqqJ6nJtEe
	Wpz/CdTKoJyecWwWEOfljsl3bDJ5/HtgsWn0lQgLig5adSBNqcsP2rWdVmlYDOSHlA+Q/OHnbPB
	PsL92/oqhxW9GLRXLFC/yoQEq9zWsQIw05FRcjmRsebiByU6lZkpnU/yq/xV4LaJpz1Ob546Vf4
	KPqwfSeCPm46ppXnwj9dYUcKZONdvOzXw49pZ5HoctK8whFo55+E97rvWk7sL44jWLo78PJvp6O
	1dx09HbL1KsfnRD/MO1mduKjnmtE2BNSEGjvoaljVv31H/CGo0fzKR66W5OXS3EuE5TzWt5fVzH
	zuxyZ33XXd/12hb5/ttWQNcutzHBErzPUONPczUpln3VfdcVz2ELDAx
X-Received: by 2002:a17:907:6e9e:b0:c26:19de:9126 with SMTP id a640c23a62f3a-c2619dea0fcmr1356711966b.25.1788960590755;
        Wed, 09 Sep 2026 06:29:50 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c260d4a8b89sm756569466b.10.2026.09.09.06.29.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 06:29:50 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1x4IN2-0000000GzB1-2W65;
	Wed, 09 Sep 2026 10:29:48 -0300
Date: Wed, 9 Sep 2026 10:29:48 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>
Cc: Selvin Xavier <selvin.xavier@broadcom.com>, linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com, kalesh-anakkur.purayil@broadcom.com,
	Yousef Alhouseen <alhouseenyousef@gmail.com>
Subject: Re: [PATCH for-rc 1/8] RDMA/bnxt_re: Reject executable mappings of
 the DBR and toggle pages
Message-ID: <20260909132948.GI2543240@ziepe.ca>
References: <20260906230700.12233-1-selvin.xavier@broadcom.com>
 <20260906230700.12233-2-selvin.xavier@broadcom.com>
 <20260908134553.GO13683@unreal>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908134553.GO13683@unreal>

On Tue, Sep 08, 2026 at 04:45:53PM +0300, Leon Romanovsky wrote:
> On Sun, Sep 06, 2026 at 04:06:53PM -0700, Selvin Xavier wrote:
> > The BNXT_RE_MMAP_DBR_PAGE and BNXT_RE_MMAP_TOGGLE_PAGE cases of
> > bnxt_re_mmap() hand out kernel pages that userspace is only supposed to
> > read. VM_WRITE was already rejected, but VM_EXEC was not, so userspace
> > could map these kernel pages executable. Reject VM_EXEC as well.
> > Also, return EPERM instead of EFAULT.
> > 
> > Fixes: 9b66c9af7172 ("RDMA/bnxt_re: Clear VM_MAYWRITE on DBR/toggle page mmap")
> > CC: Yousef Alhouseen <alhouseenyousef@gmail.com>
> > Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
> > Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
> > ---
> >  drivers/infiniband/hw/bnxt_re/ib_verbs.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > index ccd2702db78b..e39f99434923 100644
> > --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > @@ -5057,11 +5057,11 @@ int bnxt_re_mmap(struct ib_ucontext *ib_uctx, struct vm_area_struct *vma)
> >  		break;
> >  	case BNXT_RE_MMAP_DBR_PAGE:
> >  	case BNXT_RE_MMAP_TOGGLE_PAGE:
> > -		/* Driver doesn't expect write access for user space */
> > -		if (vma->vm_flags & VM_WRITE) {
> > -			ret = -EFAULT;
> > +		/* Driver doesn't expect write and exec access for user space */
> > +		if (vma->vm_flags & (VM_WRITE | VM_EXEC)) {
> > +			ret = -EPERM;
> >  		} else {
> > -			vm_flags_clear(vma, VM_MAYWRITE);
> > +			vm_flags_clear(vma, VM_MAYWRITE | VM_MAYEXEC);
> 
> This is an opposite to 10bf13c33450 ("RDMA/mlx5: Remove MAYEXEC flag")
> commit.

Why did we do that? These MMIO mmap should never be executable

Jason
