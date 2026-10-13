Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5103EC82E
	for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 16:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791908991; cv=none; b=dOVGW7aGqHw+GnDLaRfgTAyfcfZ02Fxt3mQonebeXtdSq/pQlYKZ2Qt8AYfW3Lw6dXc/C89Uq1gL3ybfuJJ/4K4ylFZWmz74mGknEg+rDmNJAyVWf6JS1IRK4WUqI8SHSJbdN1RyOPnKp4C7w2TqGoBr3bSODo4luUh9hZVCeA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791908991; c=relaxed/simple;
	bh=PoHvEgj0DESJhd67cW+bqfQwyJxUlm4A2pEx/P6p790=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d1KDiXgX3L29LJdV1d5UonN5z6Q/Ke0MN8XTI17mEOGfTdqn7/8odVeSkawW2/0mLvFFJlb/Am2yanJ0F6TXUT9iEeDf5/lepsqqBv/rpAmCQzXeYhcl+DeTAheyyGGZaMOaiYbvsWaZZEUpxy6w2nWxPlmfPm1yjLEJtJuykmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=ON70bF/f; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="ON70bF/f"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-91968804af0so35871956d6.2
        for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 09:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1791908988; x=1792513788; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=R+JDdieq2KH0ZWKOG0ldJLlSGVB6cPgviwDGVg4FC3c=;
        b=ON70bF/fBUkhPGJwwAVCaPSM3CuqDNyDsYEL/p0iCcy0FfLNolcf+6cwFHULLuMurK
         EgEsrRYlhU6iTxR2xzy17qdJUCRFd3MtoIZeZiGwpqH5AoXxOyjeOd2C+Y9OgpOQgDXZ
         lFbA879Rr9/SbZWOWwmplJwjXx+kNTC/X0LSPtky8smmvJmGZKvmrqmEvNHnyG+tbCeq
         HRX74QxFGqUoaVYIeulSQsXcm+kqaS+B1SsztlOO/Xat4MZlkgfjBTmFI8aLpIS40Zue
         5Un7wqZcu3I/lcDtXKGLw7mFv+A9H68+BxW0kuRjODmf9HUQZzQl2Z2QZuuGRjyQnWNg
         I6jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791908988; x=1792513788;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R+JDdieq2KH0ZWKOG0ldJLlSGVB6cPgviwDGVg4FC3c=;
        b=k2xW9EEs81/70vK2sX2EjX1aQChEcIWcAWwFx6r8WMll8aQm4aQm9/Pf1fYrDhhn+K
         8n7+0zx3oEiAgqFp5/DSU2ZwjKU8KhQckzCUyhgRQPRBiT/l3NQKLP9wuozfjZunTIO/
         glh3wKCaJa1guI5FrJtNOp/9UpkNgnNv8NRomvjucBvZXi/hvxQtHiw/S75DZA+qJgri
         1qXvavOZKn0mIxIyhLbSc7b3G/Dh4WZte4hXXSQeSC2/saj7bVrFlzojcRooJGDPcgKF
         c0kZuTv2lp3lpMoDGupiGWvlhzSX/nmGxQIvWY9g37G/Tbd8jzetbzFgAgmHQ1sGBlWz
         FhzQ==
X-Forwarded-Encrypted: i=1; AKwUvBzmBPHE9uF3CQ6Kp7LxUNmKNiYr7dR9nA9q3NejpEjIaEU78EcfZcA1FRqoK6dA1O1t+RDAaAJU90ky@vger.kernel.org
X-Gm-Message-State: AFq9FYLqwB4VVNj0fFOXMQ3+vjJwVGR5ctKgLNT8vwpCcFsPocBysDDq
	Fpt6kOyHLFnA1bIxKCb7dy0VjQv+5Ed8oTcNZ1DgA1a717Qjx9VM1Sgyvo5Rw95OioQ=
X-Gm-Gg: AYBFou34T9BYk+u9pXGdTaEBHTqvmKmKEUcrR5U99wpZWWYnThJXmING7lNrSdKucUr
	qGCJWjFEYbNPXS72PTiBfQxfBXnoqwmc5reBcozMfop2jWf9Pnnnr/cn1bUybUPECeKTaTlqfZ/
	9RTgiJHRRNd9bb3I1XIy1WjVga4mDPOqkP6SnHKwekzADrJqwtL2drN18YVBgYhO/TIniz57H7L
	iofIMBMLUP+iT3S3U2sNYLl7x8QupY55jWsSQZ/Q28jH7pw1DPSZxBf7CGimD1ctDpddmWsOZ/K
	QSSUGF9OvmRxz2Z8YthdLi1wq7SG8U94jnm/ktq60CqN5cwDkxoYTgSk2C1P1aNcyxL84aGP0M+
	MgF/OjX7MrgirBT+h9tvhMbzrrd6vVEKSEWVLlPm6pPRz7R3k8FUXfQ03snnYfa9jnGW0I/qebz
	tz2/+/yp5ibuKWqKKAEp95mHqXdIPW6hc8Uz5ThY8mVe8jWBcAxny7ndYhLV0BHdOoNEuPqsEl2
	yg/KRrbP28u+JNTv8UeFNhxcM2nOe4JBz47N0hTTOf0V7aT3MsRt8I7eFJNVa/wdB4=
X-Received: by 2002:a05:620a:6189:b0:93c:9c0b:3898 with SMTP id af79cd13be357-93ebd27c9ebmr2015177685a.59.1791908988253;
        Tue, 13 Oct 2026 09:29:48 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef5051c4csm280715185a.29.2026.10.13.09.29.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 09:29:47 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xGfNr-0000000A3kl-0Hgb;
	Tue, 13 Oct 2026 13:29:47 -0300
Date: Tue, 13 Oct 2026 13:29:47 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Jacob Moroni <jmoroni@google.com>
Cc: Leon Romanovsky <leon@kernel.org>, tatyana.e.nikolova@intel.com,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH rdma-next] RDMA/irdma: Check MR contiguity before PBLE
 alloc
Message-ID: <20261013162947.GM14213@ziepe.ca>
References: <20261010194832.2415477-1-jmoroni@google.com>
 <20261012185010.GH14213@ziepe.ca>
 <20261013112211.GM219304@unreal>
 <CAHYDg1ReKsz_RNB_k3nc+qDu2vjGz+OQfNQhthNzW7TvGMLc6Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHYDg1ReKsz_RNB_k3nc+qDu2vjGz+OQfNQhthNzW7TvGMLc6Q@mail.gmail.com>

On Tue, Oct 13, 2026 at 12:08:54PM -0400, Jacob Moroni wrote:
> Okay, I will respin to skip the best_pgsz call. I should have it out soon.
> 
> Just to run this by you: The HW still requires a page size in contiguous mode
> and expects the DMA address to be aligned to that size. So, I'll use SZ_4K which
> should be safe in all cases and then ALIGN_DOWN the value of
> ib_umem_start_dma_addr().

That should be OK, it has a way to disable any unalignement right?

MR IOVA does not have to be page aligned, but the HW has to provide
security.

Jason
