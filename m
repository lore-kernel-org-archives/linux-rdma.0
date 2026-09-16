Received: from mail-qv2-f43.google.com (mail-qv2-f43.google.com [74.125.230.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BACBA517BCF
	for <linux-rdma@vger.kernel.org>; Wed, 16 Sep 2026 16:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789575685; cv=none; b=VQMDqkDpFZXvQmheoz/cp79wMshQNyxKFBorg1BdFUga5IPVmsuFq0gIBKwJprc7QG4jOrj09mGyCwK4QuJ/1oZT1MzvbJwkoqPF5FY7kuHXu3ASYMuoQ0TkIthr5yk6nOy7wslcalFMSMYXmqm6JYcnnlEsJXNPAVHEykpem6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789575685; c=relaxed/simple;
	bh=8aZkNP08PVvZg7BWbE33AZXpZ6tdXswnwBF9qWrlNhg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ddN1xRQjhH35pMJRBQPzAjGPj7iCFt8FrYV3kw8hBm2D60MMqP8WbDFbGw7c2mIgGFGCJxvtMD5zkx/eQBEqo3EKQfzERvDrkL+Js9/RMkREaYr5P37OfVNRvbTxLEDEiYHn5HDlxeQ6vsgNHRHIFNV0p+rJu5HUgy6HEVPuTC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=jOVowhAj; arc=none smtp.client-ip=74.125.230.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="jOVowhAj"
Received: by mail-qv2-f43.google.com with SMTP id 6a1803df08f44-910537b51a0so7858516d6.3
        for <linux-rdma@vger.kernel.org>; Wed, 16 Sep 2026 09:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1789575682; x=1790180482; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/muLCENQ3ztU+dyE1LuzDRQMa5pSiiT+WmL99wCRWBs=;
        b=jOVowhAjMSUqLSMGs3Ddi94lMt4+OrizP4ZcNnmXKfuDh7uHyPMgfYwAQHtFfka6mr
         zaOrljo4n818ISYogU4qf/8wUvUjQEVI6JQeDol275PqeS4id6Ii5vE1ZTY9CeFDFcwP
         bLT39it4x2o6XfyOh96LknrvO97XRCsIBZZOY7caW1U14/1if56SKNpxWMNVv41Xup0q
         y7NUYOvKxtgWf/eXf2j7A2j3ZuMFjl6bgKoAUZvbDodNl5oJmibA40hng/cYJX054nEn
         RAde+Drj4rKkAf5FKGjFQpHUwceS0F2BJOSI4WH4a7fGr6fGc2l0NVlNvqt67OYsIniX
         2Iug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789575682; x=1790180482;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/muLCENQ3ztU+dyE1LuzDRQMa5pSiiT+WmL99wCRWBs=;
        b=P6CpqFldxxDvwvNLOkU8bM6E/IPpYv8QDWMjHcVwc55cC4cYsEsxvYp8VGYbHwPCEd
         q/Qg0+GbHRP3T4FwCtRekB3xSb+kdNWSH/RteC8AtyjXRJEwTyOr+cpPPu7FD4tGU1Ov
         r1wiWD5WoZAjJq2ehaJYeEI04Gs+lpNme0rMQWLhpb1cZg76rE/Xphw+cER0fjtHddEZ
         p5mwH3vrVRopQdluNzhNet7+fkf4mocNN/lJr5GWXKqAscenibrsPD0lMUcCqNH7q1BK
         PQIqz55LB+ykTSayVFxxX8BvCnaMTMgI71/1H61gSs4kY/Wzyz6VK6QHouTLztnOVbhP
         XFNQ==
X-Forwarded-Encrypted: i=1; AKwUvBxXME/NRqgafNidhkaUrVx1qMHTA6fLQiolVprEfA/yq1f2Ktm+4J8mOSzTHlsUhChWkDi13ADQIUao@vger.kernel.org
X-Gm-Message-State: AFuF++k3QL4odHQq1mWsOxAaQxrJ0Kz/QIb+KmAOFdYBj3SjB2syDgc9
	k5glyRPKLVNFZkc2Oe3EBSMWtdTGMT0gmuh5fncY86KoGLzm3nuhtb4+FwodveC/tsk=
X-Gm-Gg: AYBFou1BsJkx8W8Ku5iz3gjbvMF3RpXVFnrbzNN8KdVl44PYOLNTGw2xzvN5rgscYIa
	CJXPgibEFtQ0zNd42naEsUrpYL174xWBsg89kvtvp+NAzzkiSNoZWyhA+meYwIqbxfl/vlfsIQ/
	1+KT2zu3+GGUKYE5l/6IBPb5S8x3NjhPVl+lg4aR+Ly0cZt20+Y3uSXvPysTkJinjUjLFA/MdNW
	QYwoedCeo2xr4fDAsUPJX7dhO+mANvLTQVdo+DCsrr3rINIvxZ/jtqWOD0Xfa06jDoveKWmu8XG
	jpINeIdz/PZc4Co60dCmMuVi/aaSjvu/tb8dOTI4sGmaRLakvl3SMkANWYaopl1gsp4QumlK3JC
	yh4mH88nXeCzqk+xj+e/ZzZAjV3wLxY1dSFCn9uXl/f35sZ+jIMOfZiipvC8e92AbyGFxK63Lcm
	3W7L3DhFJHjw081CWU+JGxprCYwEuSSmWIZHQw9Qk+I0rbdWccSXsgxE3oLjpNnxXR6OQ90zlRm
	AbYSfjPqJATZAqnnny+9fFEymCCYItG/eP7Su9nRfUhoe5aecTwXnUc5anTvboysRA=
X-Received: by 2002:a05:6214:20a4:b0:90e:98c9:548 with SMTP id 6a1803df08f44-9123d722130mr58507346d6.1.1789575682451;
        Wed, 16 Sep 2026 09:21:22 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9123bddd42fsm28905456d6.7.2026.09.16.09.21.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 09:21:21 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1x6sNt-00000009d5Z-0kli;
	Wed, 16 Sep 2026 13:21:21 -0300
Date: Wed, 16 Sep 2026 13:21:21 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Honggang LI <honggangli@163.com>
Cc: Leon Romanovsky <leon@kernel.org>, zyjzyj2000@gmail.com,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/rxe: Fix out-of-range unsigned-to-signed conversion
 for RDMA message in 2GiB size
Message-ID: <20260916162121.GF3196566@ziepe.ca>
References: <20260915064532.194540-1-honggangli@163.com>
 <20260915114914.GL13683@unreal>
 <aqoLuVxDIOHMuePi@fedora>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqoLuVxDIOHMuePi@fedora>

On Wed, Sep 16, 2026 at 11:23:37AM +0800, Honggang LI wrote:
> On Tue, Sep 15, 2026 at 02:49:14PM +0300, Leon Romanovsky wrote:
> > > After fixed it, the active side of RDMA READ failed with error code
> > > "IB_WC_LOC_PROT_ERR". When RDMA_READ_RESPONSE_FIRST packet recived by
> > > the active side, `do_read` call `copy_data`. dma->resid is u32 0x80000000.
> > > 
> > >    int resid	= dma->resid;
> > > 
> > > This conversion set resid to -2147483648. `copy_data` abort as length
> > > greater than resid. Change resid to int64_t fixes this issue.
> > 
> > Why not size_t?
> 
> First, size_t is u64. dma->resid is u32. If use unsigned type, u32 is enough.
> 
> Second, I'm not sure it is right to use unsigned type. In `copy_data`,
> the loop terminate on negative value of `length`.

Please do not use signed values to store must-be-unsized quantities in
rdma land..

> > > -	payload = min_t(int, res->read.resid, mtu);
> > > +	payload = min_t(u32, res->read.resid, mtu);
> > 
> > Why don't we use the proper types from the start to avoid the need for
> > u32 casts?
> 
> Again, minimal the changes with u32 casts. We need something like this
> to use u32.

This seems better to me

Jason
