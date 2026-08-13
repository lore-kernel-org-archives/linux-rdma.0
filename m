Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03DA6171B1
	for <linux-rdma@vger.kernel.org>; Thu, 13 Aug 2026 00:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786579487; cv=none; b=RwnI1JvKCbA0tMueeJAm8306TyJ2s8FFqO+QsGhSXYS1QzmImQQwb8z0IdHBA8gdkEBuv6cpual4P/IItVxDTiTRAtX2kn+maiftxHNBv7+ooNYUZXcTTz9pMHzHu02oYwM+EsUmdyz/9btiwFCxH2erOpOf4/fPG0PcxRwvIIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786579487; c=relaxed/simple;
	bh=g4HtTFFBCpsZ2yZqmD5tEAaIDJO0KZJTVcRmsaFAbdc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zlf+ccRhd4QUEg+aSdR1h3zV7U/kzLhXPXZXpGOYC4bxEdQLvEIeQs0yPh4WjuViOuEAB/Iz+MblF3WePViOYdO+kHMHXrec2D53dLuobbGncc4fwikMNFzwCSkFwMJ016pucuN/R4Oa++qX6sXpeL0EP8tFHSi7gt+F7VPsC9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=TN689U0i; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="TN689U0i"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-52cd38ddcdfso9744461cf.3
        for <linux-rdma@vger.kernel.org>; Wed, 12 Aug 2026 17:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1786579485; x=1787184285; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Huqb/QDFJHPd43BLlvXmf+t2XVv+CLdxYkB2sOTYE/M=;
        b=TN689U0iD/14dDbDXV5w+03DR8ewTkz/sbpRXyig+VsHxgqyq92tW1yX0FMC1MFtVV
         ctCdyctAw73hxHQwQEJFeN46CQ7Gq8QH1KslCiMjHl4bEv30AVzX0SSMztZGAN8tiWNc
         GDQC0p4uvzT/8gCNVCeIqTk/tz8JXsL9ewh75Ahe1FI85U3kSo43Lrwt3hA94r2jSpqd
         AErP9H2zzvDql6sHsO2s2c2uam1/09uMMNG2PJL+0mEii4yU51wqILgQmBejuRwg36o3
         RuESPrZP0TQKnGaY4iuCRUjL6OcCSmxE1kv0FDdFJE2GwoktTe7tNae36bDQFDuh01ar
         d/+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786579485; x=1787184285;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Huqb/QDFJHPd43BLlvXmf+t2XVv+CLdxYkB2sOTYE/M=;
        b=UVLolRQdxCXWvFLgDMc21iTmfryYf3etNzi2PhnLa3gHyetu4wB6t0E7uEC0yj0nxN
         YMqFyqL1+bwFFJWyKBV+Q9jsrP8cXeWixE0pmvWWdJ+Q9ZDIGxAWX1cYl1ffjscUDubU
         R1Ty2KWHPkQ9lSK1V6+ABoZ/Z3Q9y+emhYkD4AkiEeEV4OzM03It9fIaXajR5s1OfOyi
         WT/ihiRW6EiaPiAMmtb+wwxTnRzIbfN1oQscTI23dO0ZNivV3Zb+u9LSnE0kF3pXDpEf
         6IKy6CG1PfqfUVOc0fV+d/Ed/FFOQym1e0BSrhyXn4vlstgl+XeNMyxuy6snqAOFYxrR
         SJag==
X-Forwarded-Encrypted: i=1; AHgh+RpNtpn3bnx+We26BK4KIhNjxGkDStCdTx5LCwqedgewl7FZzBNb0AFg4QD2gNHCAQxAxV9KWV74wS2r@vger.kernel.org
X-Gm-Message-State: AOJu0YxCoDb7/UEyZMimq6DwOBzmj9NMcPaDmC5tjqmZRAPP6InkoxCE
	jSeMuM3CxAk5y4L3ncTNtv+Vsmw/UuDcPPY9ViQpuLG8TOUBjNEqs001UeUQhyi7nz8=
X-Gm-Gg: AR+sD10AMucQ0uhE4UMWyFnEWKtxagiDfztMTF0cxGdKmmJUcnmlacLFyks4uJn7k00
	c121+4bDqpoUwpIh9UwanoGI12BIXWb0MeN/2ZCDWYqW8PErMTRjzpjogNP/D28djFpgFZWDH5I
	zLzW3GPvkyyfcJ3mILMmcHPiB0gc/IlnyYL1X5Uesc8OsD/GKGtXRqthyKhTvXSsELz1GaX/QOr
	OzWluK6B6fFVUT80cYug9NwFBZjauN2lw4054oyZQ8rnQfL7jTaIGdEArVHO/XD/3UGBqf2Gzin
	RWjZ7ZL0qRrRlRZNCFXTjAxbjxhsHguHJUXkyDRg5VS50xXeH0OVYJCHVaG+uyQEaQjWisetIHd
	K1aJynZFQZ1XYWqyHT0NDbWbhuBPoAk6LHNsBGaLOmv/CEjPdzjgcDXD7d43Doas5roX8RqyJ78
	wXq/6zm1jpVrDdONhPWWw/lorqjQuV/0h2sDSDLQ==
X-Received: by 2002:ac8:59cb:0:b0:51c:164b:b240 with SMTP id d75a77b69052e-52d73c373e6mr18467781cf.4.1786579484642;
        Wed, 12 Aug 2026 17:04:44 -0700 (PDT)
Received: from ziepe.ca ([142.166.156.215])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52d73fb8c7esm5203891cf.19.2026.08.12.17.04.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 17:04:43 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wuIw6-00000003c6P-1lNw;
	Wed, 12 Aug 2026 21:04:42 -0300
Date: Wed, 12 Aug 2026 21:04:42 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Yili Zhang <zhangyili01@baidu.com>
Cc: leon@kernel.org, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH 2/2] RDMA/nldev: Guard against NULL ucontext in resource
 dumps
Message-ID: <20260813000442.GI662699@ziepe.ca>
References: <20260811141909.GF544626@ziepe.ca>
 <20260812123249.44247-1-zhangyili01@baidu.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260812123249.44247-1-zhangyili01@baidu.com>

On Wed, Aug 12, 2026 at 08:32:49PM +0800, Yili Zhang wrote:
> Hi Jason,
> 
> Thanks for the review.  After re-reading your feedback and re-examining
> the crash log, I think I mis-characterized the root cause in my original
> patches.  Let me lay out what the log actually shows, because I'd like
> to get the fix on the right track.
> 
> The crash is a three-stage sequence, all from the same host
> (6.1.52 + MLNX_OFED 24.10):

You have to provide an analyis from top of tree upstream kernel if you
want help from this mailing list.

>   Stage 1 - a create_qp failure:
>     [24805924.400] mlx5_3: create_qp:3323:(pid 2758615): Create QP type 2 failed
> 
>   Stage 2 - on process exit, ib_uverbs_close() could not tear down the
>   process's CQs and fell into the DRIVER_FAILURE fallback:
>     [24805924.747] WARNING: ... rdma_core.c:945 uverbs_destroy_ufile_hw
>       Call Trace:
>         uverbs_destroy_ufile_hw
>         ib_uverbs_close
>         __fput

That's not supposed to happen.

> To be concrete about why it persists: under the current code, once the
> DRIVER_FAILURE fallback runs, the leaked object's restrack entry is
> never actively removed.  The CQ case:

And I think this was just fixed recently.

Jason
