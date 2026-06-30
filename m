Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F93B3D25D2
	for <linux-rdma@vger.kernel.org>; Tue, 30 Jun 2026 15:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782833801; cv=none; b=kfT01O1+zvAFKVCDDJSAubIBIPx9E1PJnllLSVoycUOvYOGbsWGUWPhOblgPubL4ZFrzvMvamojooE2bpbW24mg7uG0/cHDG2S3l3DE+ctFpp337nhuNafSmRQ0mjQUXkMaG4Mbkfp8xQo5ozYBH0GqkYMoB5thaO54zWPrjrCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782833801; c=relaxed/simple;
	bh=4q0vaF5MWy51dKqmov1q9cdn3rNSzn7pdy35MyGzocg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s68o11DFuvhbzzPWBNDBADFAWNLq0Gf3ArHZJ1SyABAJiHj6PEqdr6POdMqT1KJn74sfg/Gqeg641Y4QKaW4dQ6cWzYBKgf4n7JYlc9nzJAXePHAySOEUtKNdyycmOQbZ49KiCJ6fWVUUEFabIUh/l42HBLwY1bPkZdDUHuCglo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=RP94WKnf; arc=none smtp.client-ip=209.85.221.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="RP94WKnf"
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-5bd95de6865so803824e0c.0
        for <linux-rdma@vger.kernel.org>; Tue, 30 Jun 2026 08:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1782833799; x=1783438599; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bOotVAkov7vZS3oHX7LedVS6qWxqMk2u2b36hVEW5oU=;
        b=RP94WKnfRTCy/TpaWkdV3RNT5G27v7kPEAq7EOUvEWp2kUDGVDxMkZYBBouYwQjWv+
         ShgSFfRS6tbyrYIXn+cOH5BJU4yXIb6yxu8rGmyioQaiTAAYr96IS9IwfWl3WbELfw5n
         Fn9gE7ghQEzr/jVWwC07TokTMqgyMoMOzskSSvoIGsH3CVdotG3RFoFopQtk4RRw2Aap
         i30SrkiGajpRe9UYnZxWBWhpEcyxWkWHOsvbqc4cDApVLEsbcGk/fn1BOCKqSWssIO52
         h8UwNV7SO3l/VDovZofaPVciBdo4606Ne7gde4AbWLI/QIpUqOGCWIVg/x1X9BprDVMZ
         mTPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782833799; x=1783438599;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bOotVAkov7vZS3oHX7LedVS6qWxqMk2u2b36hVEW5oU=;
        b=Atn+lJs0mMONqLJI6LUtwSaG+c0bzcy5Rx4I0NtLa2ksJhrz3w8PFYcyQZy90RgsVx
         Tv+rM+CdQ5s06AoPCiVQCw+AxmNoVEukBnye+xfQXMFD0PUXQGU7icDlDmv8xuvr0bU5
         qfTDxr0HN4Yef1ntBQ5CuETg7Kg3QC3ZpSvzbyrdKuR+oxPuhjlfKVi8KeHqKjEACCDT
         F3L+vjogArQG8xmc3oamiF4kTUJs8zmNrc9ddHBS5a5MLXK3q7zWgeTR813Qj5YM1uuX
         C3BFYrVoI8JwfF5DdD2CNlafT8D2YA2JdisvoQUt0mIgjVQitoHnI2h1ZTFrsm/YTG2o
         TzIg==
X-Forwarded-Encrypted: i=1; AHgh+Rqkl4sb+7+Yr/FJ9JTz9CzfdFuCL7jAUTxH/Sk9hPtX0xaU1nkzOg46iMe2yPp1P6S9ffwtGEJOOmoh@vger.kernel.org
X-Gm-Message-State: AOJu0YypnCERFlA83EdHjDcY5fqP4Ox4gWVo4daeiuDtqh5KftbQR/bt
	sz1pcjTgrdIBh7T6NEw+zSmjQfiUfit/rpSbvXZEfaihHewm46ToSFPn+mvLKLEnKns=
X-Gm-Gg: AfdE7cmSbNSVO6k6q/mOFjzhU+CZH2CrDv4rb66oeRE+w/gTOMRQLCyG+fxpsFJafMF
	PW8rfBuWEG8Kzzy+6hicRUBV39z5mxG6OqnqANd71xfCCybByQ0CZGLLb24N2UD7zK+Pd73JHWA
	u6Ygbkr0k3Go3Q5JMOqjrtwRgUJk2DQ91BilcjlmlB+PmNwNZnhJkYZ2lWMPjEDrlmWptvhH8e+
	4EUoloKdpy1notb5gs+xEeTYuSJUArmn9cub42yfkHb/0AtvrLUDHHoLYfJnfjNNZ4q7h2XMiFB
	gXnl1ltAUh4WA3oKAccDFHAT0ppj6trhf8pRU5HOr4oafLW7Kx3UmJpYTBx1T59yjyk0hnwzf4l
	GP8MjoUIerY+v1HbbgvfpEYnKNt3Pf2oxpLhwn7CVpDC6bYXNOSHYPAZ4hV50mrIiOXqw2r2SJw
	uYUVDSqIqubPl6O7UyXN5Ix3wF5BJhYkjWK7U0ez5MlrJRpMPnsXxpQMRyxV3LMJMrA2c=
X-Received: by 2002:a05:6122:6595:b0:5a0:afff:78a6 with SMTP id 71dfb90a1353d-5bdbee055cbmr1681151e0c.14.1782833799373;
        Tue, 30 Jun 2026 08:36:39 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8f1a69c283fsm27620016d6.26.2026.06.30.08.36.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 08:36:38 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1weaVq-000000024yv-0mtk;
	Tue, 30 Jun 2026 12:36:38 -0300
Date: Tue, 30 Jun 2026 12:36:38 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mike Rapoport <rppt@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Leon Romanovsky <leon@kernel.org>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH 1/5] RDMA/umem: ib_umem_get(): use kmalloc() to allocate
 page array
Message-ID: <20260630153638.GG7525@ziepe.ca>
References: <20260630-b4-rdma-v1-0-ab42bcf0de92@kernel.org>
 <20260630-b4-rdma-v1-1-ab42bcf0de92@kernel.org>
 <20260630123150.GB7525@ziepe.ca>
 <akPaAp-0Zul8uVga@kernel.org>
 <akPaPaCJdYINBEEV@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akPaPaCJdYINBEEV@kernel.org>

On Tue, Jun 30, 2026 at 06:01:17PM +0300, Mike Rapoport wrote:
> (actually adding Vlastimil :) )
> 
> On Tue, Jun 30, 2026 at 06:00:24PM +0300, Mike Rapoport wrote:
> > (adding Vlastimil)
> > 
> > On Tue, Jun 30, 2026 at 09:31:50AM -0300, Jason Gunthorpe wrote:
> > > On Tue, Jun 30, 2026 at 01:52:29PM +0300, Mike Rapoport (Microsoft) wrote:
> > > > ib_umem_get() allocates an array of pointers to struct page for
> > > > pin_user_pages_fast() calls during memory registration.
> > > 
> > > A whole bunch of these use cases in rdma are really "give me some
> > > temporary memory, I want it fast and as large as possible. In a
> > > syscall context I will free it before returning back to userspace"
> > 
> > Not sure I follow where "as large as possible" comes from. Here it's
> > explicitly a page.

It is a page because that is "fast"

There will be a calculation what the upper limit of memory is that
this algorithm can use.

> > And does "fast" mean that vmalloc() is not an option?

Yes. The trade off is you do fewer iterations of some loop if you have
a bigger temporary buffer. But if it takes longer to allocate than the loop
iterations then it doesn't help.

> > > So, how would you feel about a new API?
> > > 
> > >  void *kmalloc_temporary(size_t min_size, size_t max_size, size_t *actual_size, gfp);
> > > 
> > > I know of a few other cases like this in the kernel at least.
> > > 
> > > The implementation could try to find an available high order page and
> > > immediately return it, otherwise do a small reclaim allocation?
> > 
> > How do you suggest to decide how much of reclaim should happen?
> > With the usual semantics of gfp?

Yeah, when all options are exhausted you do some allocation with the
usual GFP options.

Jason
