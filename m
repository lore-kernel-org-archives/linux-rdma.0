Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E91836492A
	for <linux-rdma@vger.kernel.org>; Sun, 28 Jun 2026 14:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782656434; cv=none; b=XEDm+T4v92tp8r+bpwBcMhBBRAvVgemP9GMiiZbPf3mtCiUPFqmfC0MupPB6OaDCUMY45ojHj4Xy3RBRSX8Rx4lIfFXJRYVWWh3VBbLbviPS7H5yxkr9rg2wVTt0tqnw6jShdh151bhgOPWg5CQgMQCI3QP06ECvWCdJznolBeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782656434; c=relaxed/simple;
	bh=DME1A9kYC0vpVXdpuDyjtBzaIRXFuwoE3ygSvRQy6Uk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ofocLKDh7Ioy6ZUDI3/qxoYTUbLboiB97UbtiIGB4b7Z9BaRkbdbhjbnB/aLYXpdjW6kxRkfeSaYGQME+HB+QKQastfN8drk/gg4SJ8CRvlT08TSSEyFFDX7vZvsoxcrRQ+lNPdR5A/k0t7aAWdg8whJpfKCAABGgdcr+YXR024=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OVjQcmUI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OVjQcmUI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A80C1F00A3D;
	Sun, 28 Jun 2026 14:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782656433;
	bh=UWuiG7SWAs1hAxC9pRr9Q8Dn50ePtIzwA9LmhKHZhXA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OVjQcmUImehVDbp+1njEZLH3mvKTCtxnZt2dWSQ7ddQqzVsV6DUJ+03RQL6cVJJHT
	 kmRx4JtJBo7kDLZR8aANb2GxkW6CfUI9OUIYT/qzhGNy8mFrxvxmeS62Ll4N6gzqzc
	 MfimDkGXeTTIpzvDFMo6CbUESRaySP+zPtTeDvY3FdXd3Ol66rD8VLux5W8O/Pnynf
	 WjWjmfa/8YxGyEZpS5eC5qpWTMqZeah/ynRpox2/8/s4g3gzG0bGMJ0Da8JVulDClI
	 LqzYZGNArDuibv0Xh1ulYnqirJdp8QPge8xmMxssoql45w1iuqcEq4OIbsXKNI2NeS
	 OuI4RmFACkJ8Q==
Date: Sun, 28 Jun 2026 17:20:26 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jiri Pirko <jiri@resnulli.us>, linux-rdma@vger.kernel.org, jgg@ziepe.ca,
	mrgolin@amazon.com
Subject: Re: [PATCH rdma-next v2 4/6] RDMA/uverbs: Add ioctl method for CQ
 resize
Message-ID: <20260628142026.GB33710@unreal>
References: <20260615085040.1396623-1-jiri@resnulli.us>
 <20260615085040.1396623-5-jiri@resnulli.us>
 <20260617110605.GV327369@unreal>
 <cb0200ba-e1f1-4106-9e1e-74e4118d9106@cornelisnetworks.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb0200ba-e1f1-4106-9e1e-74e4118d9106@cornelisnetworks.com>

On Thu, Jun 18, 2026 at 11:40:29AM -0400, Dennis Dalessandro wrote:
> On 6/17/26 7:06 AM, Leon Romanovsky wrote:
> > On Mon, Jun 15, 2026 at 10:50:38AM +0200, Jiri Pirko wrote:
> > > From: Jiri Pirko <jiri@nvidia.com>
> > > 
> > > Resize CQ is currently only reachable through the legacy write()
> > > uverbs command (IB_USER_VERBS_CMD_RESIZE_CQ). Add an equivalent modern
> > > ioctl method, UVERBS_METHOD_CQ_RESIZE, on the CQ object so the
> > > operation is available through the ioctl interface and can carry
> > > per-attribute extensions. The handler mirrors the legacy command: it
> > > looks up the CQ, calls resize_user_cq() and returns the new cqe count.
> > > The legacy write path is left in place for ABI compatibility.
> > 
> > I have a general question. Do we actually need CQ resizing, given that it is
> > rarely implemented and often incorrect in existing drivers? Maybe this is a
> > good time to consider deprecating that path.
> 
> Can you expand on what you mean by incorrect in existing drivers? I mean I
> see a glaring coding bug in our implementation but I can patch that.

I had "create/resize CQ" series which fixed locking in all .resize_user_cq()
implementations. The series stalled to give Jiri some space with his umem work.

Part of that series can be found here: https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/commit/?h=create-cq-entries-v1&id=c4f7b5999b4015609481657b437a92346a018d2c

Thanks

> 
> -Denny
> 
> 
