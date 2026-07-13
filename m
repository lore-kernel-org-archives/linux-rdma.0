Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7900F1F37D3
	for <linux-rdma@vger.kernel.org>; Mon, 13 Jul 2026 12:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783947050; cv=none; b=bC8RQWcogix+HWOyVHipEugY9WkFhNtirtOF7JC87aEE9AXNHzma8E9/zNmn1ze119yE0piua9YfBGszqLqsa1j4Tw7RYO5SNYKoUJS0JlQol33gHihrdRN8lC0oqrKxMiajDNpzSyU/BslcjMLT54hygEpstNNDEZKptEswqYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783947050; c=relaxed/simple;
	bh=veW4xnwg1sICAxLPDy+nuWMcaL8ODHxiqPqkw/bUUBs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GBEI6M+RGF1nVCGvCVrR9nEhe83WkhofPU9y1MOLWZ/hW8akXzpidIqZSAffSJDrGez6pcC3F3o+Qpjp4UdaUjN6jFjOfpwMKANul8qJbR8pLXYEa/VPHS6hu5bHqEehtqA4BctfB7/ZfPzWcmKoYf4qm4TiT6+QJU/zkXlF0K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=eTwS3zot; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="eTwS3zot"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8f0e5e36912so22281436d6.2
        for <linux-rdma@vger.kernel.org>; Mon, 13 Jul 2026 05:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1783947047; x=1784551847; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=veW4xnwg1sICAxLPDy+nuWMcaL8ODHxiqPqkw/bUUBs=;
        b=eTwS3zotaPDKE2jxHipD6X3trx8nn+T7Jd3nTYbACm9vG3opNJhxGejzNi39p7K7xl
         j2HnK+pwZaPr2WcmyCdiEqNwPDw+MZjePFGsBw3gf19pOScIAEy3NcQ5RqRbNv85YD1n
         P5sdqANZAO/QBcWA640CQx0+llzBBZ9BgVKG1uFfBm+ru9Q7W1qEsShk/5BCWb2xbuwp
         p4hKCwOPxV+1PmuojEtXxVfTFj05AO0Hz++eWd9KOY0P8fifnFjxbEUZRRZsBjCSpXOF
         GnzPRnhkiaFV4kBwd1IrWxsYeKhYzD6xSjfH/ermmXFlsMHih57ca2gGlur1fQBsAaO2
         LJog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783947047; x=1784551847;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=veW4xnwg1sICAxLPDy+nuWMcaL8ODHxiqPqkw/bUUBs=;
        b=IUw7O6F9rebERI8gNxDayuXHg4WNElALdFffwfDV8rw6FTRiBSFo5Ldx5MtgTwByGx
         4IkbJPt/SaNYl9bGQ+VVa/tXvECFDbEtlksyE8dHSrgyORMMAOVJPkE/h+P5MKY5oW8F
         CVPtbo7XFQS1By8Wr13VvEruLiOIvUTuEGOzHrU7fjJzN7Na4htqXZkhk+PKPuMj6uSZ
         nuvtue6OMVs09CxSDtJRSjAG40XPTJthxB39Yf36QacSI6YRjbS7nLZm7etVsE+mBSM0
         2eAMu1Ye3V9DVGzmLY+O4vbMi+E89sHEwiHXIjPRrd9GjeT+oOX0YHsrr+MO2x7s/iuW
         TvgA==
X-Forwarded-Encrypted: i=1; AHgh+RoobDylO1/oLHLKG0/L2hfT+PXF0g2LnzItFIpo8EBM1R2DtCtCSOxi4T7yYZf8QN/dNpWPrjS2pQGY@vger.kernel.org
X-Gm-Message-State: AOJu0YyB/lUqqqm7zGv9uGktmJZav9TDZbRNWZcR3k62/JDlBfOE8BsJ
	YkiI8RkzgEdtDW6iYgZg+uhhQpp+nwpE9gXSeTk6pDsle9CUr/hZhDbBqSqCCJ0HK70=
X-Gm-Gg: AfdE7cnRQU5M2oNcDe1uU2QOMDDv9pNzNbopEHmLzyXOSFtv/oQs8l/YvBN2GH9dvGC
	eqyKhuVaoJ33dmUbt9+D8G4wx8yeh15J3CGNKCuwNHq+MlR6/QRy+b8OFHAgBC0+bpzzVtCLxDI
	DtHqyaqnPUQA0WBeJZDUSGT9s6fGZJ9/0FvheHZlygrshMrLrhAy9H0F6DWVh0cvPEfll8Lnl3f
	yP5pMVgiJ2HJbZXmHY2cjfumdeIxYC6mDMtxTjCNgn5ZJXprWZUaAiIpCy4RzRQkMxmhOORsz9R
	XGqhy8dTq5mc9ZLSkSqAVmbvxUg3P9CPUYOYxgjfOQyJOg/WBLSwagie1nk9p/HijvV7Gf55JE3
	VDP1O3almIo6VV9VwNiyl8Ujacm0Sy90sAOzNDjD+v+DWBoqP1qGwxLrtX8k0
X-Received: by 2002:a05:620a:2245:10b0:92e:c118:18d5 with SMTP id af79cd13be357-92ef2c9020emr670355785a.76.1783947047074;
        Mon, 13 Jul 2026 05:50:47 -0700 (PDT)
Received: from ziepe.ca ([159.2.72.92])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5d69a78sm1072420385a.44.2026.07.13.05.50.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 05:50:46 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wjG7R-0000000CyPW-46U0;
	Mon, 13 Jul 2026 09:50:45 -0300
Date: Mon, 13 Jul 2026 09:50:45 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Kamal Heib <kheib@redhat.com>
Cc: Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org,
	Abhijit Gangurde <abhijit.gangurde@amd.com>,
	Allen Hubbe <allen.hubbe@amd.com>
Subject: Re: [PATCH rdma-rc 0/2] RDMA/ionic: Fix NULL pointer dereferences
Message-ID: <20260713125045.GF1835788@ziepe.ca>
References: <20260709220353.729951-1-kheib@redhat.com>
 <20260712091326.GG33197@unreal>
 <alPrQa9ZgDaGuPYo@lima-fedora43>
 <20260713091733.GJ33197@unreal>
 <alTICI1PQ_7D7_ea@lima-fedora43>
 <20260713113521.GM33197@unreal>
 <alTc3yfXNyGyzjCw@lima-fedora43>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alTc3yfXNyGyzjCw@lima-fedora43>

On Mon, Jul 13, 2026 at 08:41:03AM -0400, Kamal Heib wrote:

> Many respected kernel developers already using AI as productivity tool,
> Judging a patch based on whether AI may have used or not is not a
> valid argument, again if you don't like the change or you think it is
> not justified, you can say so.

Do not copy and paste email prose from a chatbot into and pretend like
you wrote it and did the thinking. If I want to talk to a chatbot I
have access to every one available here and don't need someone else to
sit in the middle.

If you are going to use AI as a productivity tool then you are still
expected to critically review anything it gives out before sticking it
into an email, and I vasly prefer to see something like "I used XYZ to
research this and it said Blah and I think it is right" before cut and
pasting AI.

Jason
