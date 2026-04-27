Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB43C3563FB
	for <linux-rdma@vger.kernel.org>; Mon, 27 Apr 2026 19:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777316466; cv=none; b=JjZPt8EAECHpaXgZMEt2Y0pIvXgQ3WGh/u4zQyj7WORywCGuTb7AeN3ZVcXKcM28xEOHY2zdwoF0fVe1lAW2TLlGU4+UUYKHVSYO86A3/Znszs9i7X6+GRSHJVhNS3iQjZZU38rCx7qQ1wY4lffxAc7MUkoelYwf5CpQow3wVoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777316466; c=relaxed/simple;
	bh=LYnyA7QN+/C7r3WknNbT/zaJ4ayoLDekyURA3HRQ09s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IU72nV7zOwR3nNrIkFUQo2I6YlyAy0OgErI9KiT749j3Fi3rziiW+EXp12Iso9IBiugPqaZ5yoYo4/t6ItcK3MRJ1SyFTqN3lwYHBWaPHtez6EI+eKhsD9lal4kXXiZFPuQZpppnYLOSgGwg4tsGtM5uFLaRyww4Nkpy+kKZyRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WXmzDYPt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WXmzDYPt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10474C2BCB5;
	Mon, 27 Apr 2026 19:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777316466;
	bh=LYnyA7QN+/C7r3WknNbT/zaJ4ayoLDekyURA3HRQ09s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WXmzDYPt6nhEHXey3kPu9/yPtEHRpGQENC54PYONwKOynKJMZDDWotw6xB7+fRRxS
	 N2VZPZOeFswZd1oTR0LVbgheURvkZL4YsxQmf0OLRe3bp6dOlpY/HOVXEmF/CiPjBt
	 n8jZJBUBRUIOuKjkx5DJ3oPDNun8DFbF43EYwqAij9fdBEF5R55HKxD3y3x2gtXDzb
	 0p6Popdb3IOouL3KoFDzkrTVd8Jp5wn2/5ERV9jgYDGT90kaGvf3/e4xDfJu18lE+Q
	 QMEWcZJg5gtq/YToVlivp3bGeL7H30dUbMW33HpptFi0/s3NmzkRUtIb1RF5A3u9Li
	 DMI6S1v09FnuA==
Date: Mon, 27 Apr 2026 22:01:02 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jiri Pirko <jiri@resnulli.us>, linux-rdma@vger.kernel.org,
	mrgolin@amazon.com, gal.pressman@linux.dev, sleybo@amazon.com,
	parav@nvidia.com, mbloch@nvidia.com, yanjun.zhu@linux.dev,
	marco.crivellari@suse.com, roman.gushchin@linux.dev,
	phaddad@nvidia.com, lirongqing@baidu.com, ynachum@amazon.com,
	huangjunxian6@hisilicon.com, kalesh-anakkur.purayil@broadcom.com,
	ohartoov@nvidia.com, michaelgur@nvidia.com, shayd@nvidia.com,
	edwards@nvidia.com, sriharsha.basavapatna@broadcom.com,
	andrew.gospodarek@broadcom.com, selvin.xavier@broadcom.com
Subject: Re: [PATCH rdma-next v2 01/15] RDMA/core: Introduce generic buffer
 descriptor infrastructure for umem
Message-ID: <20260427190102.GM440345@unreal>
References: <20260411144915.114571-1-jiri@resnulli.us>
 <20260411144915.114571-2-jiri@resnulli.us>
 <20260421134635.GG3611611@ziepe.ca>
 <pun4bxcclwqmurxzxuqlkv5qdpiqcxqjpbhrz7vtsjf2paallz@6f3w32ww4gl7>
 <sdmwjrxzgbg4iz5cspcdkvvdb7rjgdggkw4njct3pkdsvhsq24@qstis6jnplap>
 <20260422165101.GO3611611@ziepe.ca>
 <20260426135340.GH440345@unreal>
 <20260426225034.GA3540346@ziepe.ca>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260426225034.GA3540346@ziepe.ca>

On Sun, Apr 26, 2026 at 07:50:34PM -0300, Jason Gunthorpe wrote:
> On Sun, Apr 26, 2026 at 04:53:40PM +0300, Leon Romanovsky wrote:
> > > Well, brainstorming idea. I'd like to hear from Leon too
> > > 
> > > But if we set the general goals as:
> > > 
> > > 1) All umem creations should have a struct ib_uverbs_buffer_desc at
> > >    the UAPI boundary
> > > 2) ib_uverbs_buffer_desc should pass directly to umem code without any
> > >    driver touching it. ib_uverbs_buffer_desc should be the only way to
> > >    create a umem from a driver.
> > > 3) Existing UWH umem descriptions must continue to work if the desc is
> > >    not provided, by reforming them into a desc
> > > 3) Cleanup and lifecycle should be centralized
> > 
> > I have mixed feelings about this. My CQ conversion showed that even a simple
> > task like creating a CQ umem (numb_of_entries * size_of_entries) ends up full
> > of creative hacks in various drivers. Because of that, I see real value in
> > pushing as much logic as possible into the core code instead of duplicating it
> > across drivers. However, my later attempt to change the QP path made it clear
> > that creating umems in the core is not a viable goal in the general case.
> > 
> > Another outcome of that work was realizing that CQ resize (and probably MR
> > rereg as well) becomes messy when we keep the "old" umem around. Splitting
> > creation and cleanup into different layers probably will going to hurt us
> > at some point of time.
> > 
> > To summarize:
> > 1. The most practical fix is likely to provide a driver callback to create
> >    the umem when needed, as you suggested.
> > 2. We should reduce the use of UWH as much as possible in favor of a
> >    well-defined schema. In the long run, we want to add more umem types,
> >    and many drivers should work out of the box under that model.
> > 3. Explicit behavior is preferable. If a driver creates something, the
> >    driver should also clean it up.
> > 
> > I'm not saying no to your proposal, just expressing my thoughts.
> 
> So, I think making small steps that upgrade all drivers will be
> helpful here.
> 
> If we can get all drivers calling the same attrs function and giving
> their uhw parameters that is a good step closer to being able to put
> that in a function if that is how things need to go down the road.
> 
> And it does #2..
> 
> Not sure about #3, we already moved toward core destroying umems it
> may not be a good idea to try to undo that now.. But maybe we just
> keep that for CQ and leave QP as driver managed?

I changed approach and patch planning of my CQ conversion to be
per-driver, see the amount of fixes that it is triggering:
https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/log/?h=create-cq-entries-v1

However, it remains possible to revert earlier changes.

Thanks

> 
> Jason
> 
