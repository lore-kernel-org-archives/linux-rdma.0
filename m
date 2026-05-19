Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402C7409609
	for <linux-rdma@vger.kernel.org>; Tue, 19 May 2026 13:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779197253; cv=none; b=pzK47KDybEeS/ZQ+UmOMuNjJG1lIMQYTXwAM1YmMab47t41CHd5vD155vyie76JMvVxSYsEE9r97cPuxnuDkcYNFlMmPW1APyJm4/seY2QZ1AHIOaYlAIX62F75Dv1/Au39PcGDlf+KQqVdkycbOQd+RMtOUuudvQ8CzLqT7NuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779197253; c=relaxed/simple;
	bh=1w6l7ohmykBbCMduSELIgBOmqzpHylfRMz4JZAMEyO8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sRu9S8FFKL0XnpY1hyTGuJjBlwzvwLrlF+1+RTCDWfG13b+DGvo4U9hHxx1FYcTN2d/6LWV1xkR8uBdzoFw8G8Po2JpBbt12bp0KrWOsbGyxOpK/iJsylHbIG2MZJ1cDiZHfZtqoPJ+OKXMkC8D0cLAJtu+nhNlqDSTKw7MqsTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=max1Z3zo; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="max1Z3zo"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-90fc979d84cso231883585a.1
        for <linux-rdma@vger.kernel.org>; Tue, 19 May 2026 06:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1779197251; x=1779802051; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8L3kU+Izm/bkBdprDuHGma+6ktvuwtCY+aTmGowXgj8=;
        b=max1Z3zom+e8dvtsKbV89WqNMaGn41u+vbKmThdDYQp4zavXBbv4Q75o3tasPvVlrk
         fn83G5Ll+149r/W+5CtYGlU/HqTuawNQNA/gebAGLjHJpMl75rC4owY/+jnOLvzEvmAV
         U/BGzK9ES19l2ies9oUh0Q1IBxoghe0N0CZVZGMyMPry1ovOXnjUYXDU8KZHm/CvyvUA
         McA5P3ejcxDZ8BLqks9rfdkaeBSdPKHu8SJ5x0yW5di8x4HSHZ8KlNlfiIroW6ZOPWGC
         jR/M7/eD7RZSWlxPPy4+XoMsu+aRBV1w6S3088DNOp7IsAMWzsxrbnnm6rM897TD9hzm
         t/zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779197251; x=1779802051;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8L3kU+Izm/bkBdprDuHGma+6ktvuwtCY+aTmGowXgj8=;
        b=qxyxw1kEpVw5hhdxZWAkoRtN/x+EKdxtnoBN81mSlZCkJInpRGru5+KfXMmislVM3x
         rbdxW5Fh06q0u2K5Uz3gz790T2cjqLEhSf4tjz0UAuZeM0FKvnu46fFlFwd/ko8Gc9UO
         5J0H4EuipzKNfIAiHwAW3P2sZyFdrgl0r72SVsEGCLFeDiE4yo1qRcB3kIYa2Ekuz1fh
         DdxqmiCdcPeGqvpDclfyN2CJ1/UJBRzZTG3s9/9GJUVLtfBmkepLAaCddr/ZUhUl43r+
         rFAnZ7IMPIfQ0k8U/lhjfN69wzmEr6gnrC7NNYsIn1CynEYp6DPF8LUoDDqmDxNyoz0M
         WfIg==
X-Forwarded-Encrypted: i=1; AFNElJ/7RTFxkJxUy1KUCg+m8b1WqU8jAFVDTJyQaOMamk2M7HGFnRaaHXICEuUOYeGovPD05X1Mtg6ZW3uw@vger.kernel.org
X-Gm-Message-State: AOJu0YyLAWSkhE/vkw4p4kU/QYM+0IL/uUgivZgLu6SKq8HH9rWoHcd6
	ye47n66d0VfO0eCoGmH3KREGZ6U+sCuhAbTVEJh2LQtOHmbJPkEOl1EOJ63qXY4rqtg=
X-Gm-Gg: Acq92OEuIXKBIJKKp0yeIX4I5aiP+2pRproCOOWwKY4V2sZNhZu3J3LrJ6GvqlVPjYy
	CM8XcnM01VHEZldQKAin9N03HeduPpBBDw9l+4gl0k4HYQ8BpA8+s1EFNoeMa7s3eyuy7+mIala
	Ij07LsxBZ9hibrW9idGTISErFVHfGKbdt/49Pgx0hEz7OhNbJh5Tt/0kkiBhLCJmPRxZ90OSrsz
	UCB/2agtUhpiaOKJsFW6t+Y6pSXF4sPMBR/CJAeW6e57sxKu5rziBXmPcL5injFmF2ErffjYcXn
	PIxcQU2QuDo9KRfkk6ZLKIecq0i073ndFgK0pcBqbY0EVkd2Zh8OjcMd7ijsBBjqbQUZo04mcyn
	hRgSWP+SrJdlqKZHfcanqxsI90mkNnqNRiLYhANKviPy+7vsBE6B7elwV3tFQ0EOsXcggwK4THD
	jZKZrjOZrj1ulWEYqb1Smq0krvLjTDva5a0z1tqenA7InJ0zmkgBa75+THQADn+3vW2WDvgCtSH
	076lw==
X-Received: by 2002:a05:620a:1a2a:b0:8de:c429:552d with SMTP id af79cd13be357-911cda50c27mr3032778685a.20.1779197251042;
        Tue, 19 May 2026 06:27:31 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910ba943761sm1849573485a.11.2026.05.19.06.27.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 06:27:30 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wPKTq-0000000EuR3-0LFm;
	Tue, 19 May 2026 10:27:30 -0300
Date: Tue, 19 May 2026 10:27:30 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Cc: leon@kernel.org, linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com, selvin.xavier@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com
Subject: Re: [PATCH rdma-next v6 7/9] RDMA/bnxt_re: Enhance dpi lifecycle
 logic in doorbell uapis
Message-ID: <20260519132730.GZ7702@ziepe.ca>
References: <20260518153721.183749-1-sriharsha.basavapatna@broadcom.com>
 <20260518153721.183749-8-sriharsha.basavapatna@broadcom.com>
 <CAHHeUGWK_2RNG=CaHTnNh2JeAXa9mcTam6p_7Qp6eG+6Nip+_w@mail.gmail.com>
 <20260519124600.GX7702@ziepe.ca>
 <CAHHeUGWpp8n1dHAu=MfYiLhntzK=PtvNyRBHhD0W9KkthEgYUw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHHeUGWpp8n1dHAu=MfYiLhntzK=PtvNyRBHhD0W9KkthEgYUw@mail.gmail.com>

On Tue, May 19, 2026 at 06:50:38PM +0530, Sriharsha Basavapatna wrote:
> > > ufile_destroy_ucontext(reason == RDMA_REMOVE_DRIVER_REMOVE) -->
> > > uverbs_user_mmap_disassociate() --> rdma_user_mmap_entry_put() -->
> > > rdma_user_mmap_entry_free() --> ucontext->device->ops.mmap_free()
> >
> > Yes, that's right. The disassociate removes the references from all
> > the VMAs so it should always eventually call free.
> Ok, so disassociate() triggers mmap free in the driver while
> ib_ucontext is still valid, right?  The use-after-free concern raised
> above, where uctx has been freed, shouldn't occur?

As far as I can see. At least you would be in good company making this
assumption...

> > However, it would be best if we didn't have this code in the free
> > callback at all, ideally the destruction of the object will happen in
> > the uobject destructor not the mmap free. However, I think we lack the
> > ability to do that right now.
> >
> I had to move it into mmap_free() because a prior concern pointed out
> that the dpi could be reallocated to another process, while the
> original process's mmap is still active.  Although the bnxt_re library
> unmaps first and then destroys the dbr object (i.e in the right
> sequence), I still tried to address that concern by moving it into
> mmap free context.

Yes, we lack the ability to shoot down a single mmap_entry during the
uboject destruction so it has to work like this :(

Jason
