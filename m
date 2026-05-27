Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com [209.85.222.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B20340FD86
	for <linux-rdma@vger.kernel.org>; Wed, 27 May 2026 13:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779888844; cv=none; b=b4WFhylzwpaXn+7FjVb2XEld3kXgeNmgqs4Na60dWi9VKPC5EWfhbcT6uTIckPACoJwJOWG2nVffqJCpD2mWo+yfGGmRBzfIJUM9dvT3QilALIleYw5o2dDkg8mN63GuUwMnoQqPhY7svr/YJzKTOm21r8pMeryckJpTLZ7XgXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779888844; c=relaxed/simple;
	bh=SX/btaHg8hisQE4HPjWH8PXnsnxSqCDOj4S+rvTli/4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EIObmsGO943Sa9jN+GP3wJ9ULCbW2wvd97fsA2a65Hg0RP5QkowlrZGRSmxW0xpV8Xxqag4VzQUyrfHXMinHgW2B/pdhaD/Xy6DE+aLJAE/HlNBDl2yOjca8raz3TlX+H47TndtgAXS8tH0NOfaO1ZaptGyi7BaAqJeEiK7I+f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=BrZjRvoI; arc=none smtp.client-ip=209.85.222.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="BrZjRvoI"
Received: by mail-ua1-f51.google.com with SMTP id a1e0cc1a2514c-95fa7cd1392so8911329241.2
        for <linux-rdma@vger.kernel.org>; Wed, 27 May 2026 06:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1779888841; x=1780493641; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+e2bIG+i9gyjJiiA+ouh3//Pf3aD7RE7geFrfA4l6SY=;
        b=BrZjRvoITH5BXAfXA2jkpD1rp5AioNGjGttSCb4XDYtDBBBfFXe318dOvCGO4dNmWO
         5s2W0PRQx0CtOGTYAilzdJSxxiJ01MQzqQcNV6wofvLUK6n2kpbaRjBXO1C+18SUBFAJ
         yUJ37dLVPqQMiAX0lA5//nOC8p9837wal7BH+2iiUKdYeVX329hot3zOkQ+VVSxemS29
         pDWLtFKFeK56ECkBag0jTJh7mwPsNvF/0XiSR4o5Sy9sJwsL5g5lb5yufCeZ6TZf7sJl
         jP7DwqjWpqtOEa9fLfqvBN09ynhi3Z47M7kedXQSEpFdommyA62wK8YXKSXUL9EZa0mR
         neJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779888841; x=1780493641;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+e2bIG+i9gyjJiiA+ouh3//Pf3aD7RE7geFrfA4l6SY=;
        b=lRy6nnfQAPHG6aALY0aSy/d7CaVb0numMCnf1mzCObYZ1mzroJAHUq8S/RQK2j2ipv
         dvMZZGag7BzZthMyMrmB6K9/meNOckfKbtBFFfzGs9qbLy322cnYQBXrfjyStiMD7gbi
         lykh9MHpflB0foHzIwQ75bDLWZIKNFv/sbln+/gbgfYmbMf7zjbZFQv0lbqEq4eeR4TV
         4rY/eDyTPPQWnH2XyJz/JRctYa43W6gowVOjyVnqtao3eGF4UV8Vk8PPVzOVvfN9aD3d
         0pXGJbRLkHqOfXQ6jcANFqvWs720Fgz+hM1Rvi6AaBaVG+/lk8o1G5+0LkszYfB7xsAL
         KowQ==
X-Forwarded-Encrypted: i=1; AFNElJ9sY5uav864Eh6GBHw7Y75EN42nfe4AmcysBJ09sa7cHWBMMlpXAo6XlI1PHVf1o7hVyHp3SdhVsf1S@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2Zb6a3Ke7Yguf/s9ZigdXLOFcYmYtIqIQyS+d/8ESTHPIxHeL
	PC50z01tmGkjviuRCzu12BlpUp4zmAVT423xtthN9n5S8by6CsmESVtCijJqqc8vZYc67eZJumt
	tRTuJ
X-Gm-Gg: Acq92OEd8PWrElgEWjSWIqgUC7iPtLNNyUdnAI5Ausit+dDRHj5b0GzqmPn+270uRhn
	reG72pf4Ix6AqWwXsNVaZynZ52oni3jcnW4OyfgNOeAL+NZjiQa43d/ohoEWRSRzuKV+9PwL+p6
	0lLfm85L4GXNCf1kPoWrXnpK13XMqPYhE2ZymwzppUkkfhn1s7SIgkQnMbu76jdpF6iK1sHh4si
	l7Wi+etc1/j4YvZWkHCDuwwIsDyGKwq92ClzWiq5wWraIAYQdOv/Ig1Tbuk7lUbvsS2RT93vDiQ
	EwYT81PORwq1iko/TAG45HeVxwtXsHgdMTUr/gb5u590wx4ibrqHI+iND+0QwoIbLIxm1eU4XRL
	gW1HE/jh6ZuKIsNnOjk+N4creFtKXsv6nL3DrZKm4ieulmb7PWAxkKyiBzsbNGNg3LLrW2RC1cQ
	i6KFvURUl3Nwd0QFVRh2YgVQN2opn0/QAAq7F31k/0nJ/kpEmy1kuGaqB25PLdxy4B3e+fsJGtB
	OFdmMJ886moY397
X-Received: by 2002:a05:6102:688f:b0:631:81d6:e158 with SMTP id ada2fe7eead31-67c8fcbdbdfmr12092231137.27.1779888841412;
        Wed, 27 May 2026 06:34:01 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-914f87034a2sm476927185a.16.2026.05.27.06.34.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 06:34:00 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wSEOW-0000000EPtJ-0OFT;
	Wed, 27 May 2026 10:34:00 -0300
Date: Wed, 27 May 2026 10:34:00 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Tao Cui <cuitao@kylinos.cn>
Cc: tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, leon@kernel.org,
	linux-rdma@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [RFC PATCH rdma-next 0/5] cgroup/rdma: add per-type resource
 accounting for QP, MR and MR memory
Message-ID: <20260527133400.GM2487554@ziepe.ca>
References: <20260525055506.2002985-1-cuitao@kylinos.cn>
 <20260525134314.GI7702@ziepe.ca>
 <b8269d9b-bd14-4ba1-be60-a210a9a1d093@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b8269d9b-bd14-4ba1-be60-a210a9a1d093@kylinos.cn>

On Wed, May 27, 2026 at 07:28:59PM +0800, Tao Cui wrote:
> Hi,Jason
> 
> Thanks for the review.
> 
> 在 2026/5/25 21:43, Jason Gunthorpe 写道:
> > 
> > I would agree to mr_mem as a reasonable extension, but not splitting
> > out objects to finer grains. There are endless objects we don't want a
> > 100 different cgroup knobs, it is not usable.
> > 
> 
> Understood.  Our initial motivation was
> multi-tenant isolation: a tenant could consume disproportionate
> resources by creating many objects of a single type.  In hindsight,
> though, the real bottleneck is pinned memory, not object counts —
> modern hardware has large object pools, and the scarce resource is
> how much physical memory gets registered through MRs.  mr_mem
> addresses that directly, while hca_object remains sufficient for
> coarse object accounting.

This was the same motivation that lead us to a single object
limit. Inside a modern NIC the objects tend to pool from the same memory
pool so it doesn't matter if you have 100 QPs or 100 SRQs or whatever
they sort of cost the same.

memory pin accounting should ideally be limited by the cgroup directly
but we argued about that for a while and could never get an agreement
of an acceptable implementation. There are many nasty corner cases
around cgroups and fork and other cases IIRC

So I'm not sure if making it rdma specific can easially solve these
problems

Jason
