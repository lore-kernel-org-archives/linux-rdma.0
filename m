Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795701918;
	b=N7eTiGGTAT/2A4hBj+JZGs1a7XKSRy8RJYqJorCUpdusuoHS/FXUpk1bV6kJsv3YLL10
	 1nN5zitkF8DAn/5saXZarGJ4dvwgp1mHc+EIyJsU9X7V8LzWWXLjwJ6Z3hd9KUvhy4MMe
	 uFbA9VcNh41cTynpQLfTwJ8Z+TvS7cFWUOz/C0W3BqPAlun4HuTHevwDUBL+3vUCn9tWq
	 sPN1T+MFSuGzwH1Ko6k/p3ehZnpRALa58MJu4SG/vR1XKcI2p5oJvhpYHamRO48Qkoz63
	 UZk6khwgGXzjbjtKGumF+2aCVaNyDw5sJRbB5qZRgd8ib87VHuQ7fu1+RwMrKLbEgXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795701918;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Qx7SlL9FzmbaxljDewDvHJlDId+MbPeBxhEQoJ9A/Pg=;
	b=okMSYKQ0W1KwURU8Hx26dA5Dv1+uD+Gez/7w8o4Sa/iDWCm034OaH4QQQZCHIgroGodn
	 4p66PDYZOEOvu7Chqk9PTiU+/9I1OiPBypO52NkTJgd89C8yE2b/Jjc/CvoRISYJrAAiL
	 8/argsSa5GzOdThDH5qj+mUhc5FggwZ6SYw4mE/JjaopK8+YhPrPolsH8cX5J0qfJHz3E
	 9Ugv6WT7fIFmbooddnl+VY8qhz3J3ZxCz0WpyUmw9f7v6Jy+NPvKHM7WLy+WvROgQLjgG
	 Ivc9I80eWDDU5AqAlSBhp+yEnBJQGheP1GUJ63S0wyonM9J2+8AvSdxiXZ6OYnR1Qhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="aqzE/kAQ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2117606A31E;
	Thu, 26 Nov 2026 14:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aqzE/kAQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8481F000CF;
	Thu, 26 Nov 2026 14:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795701917;
	bh=Qx7SlL9FzmbaxljDewDvHJlDId+MbPeBxhEQoJ9A/Pg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aqzE/kAQ0QjeXiR/xbrCd6COUl8iLtWSFbuJl3ggUdKzVoGnvvEUAPILyGdn4QwiS
	 0JcHNsW2x26D8AkDcaaNjfOEChhfELAK0wDJaOg+J+OjkvTGMiyLHcECovBxKIj6fk
	 fRWpu2DSNkPQj08DFwtozMrxx1I5Y0glUi7UQWlmTEWFOCKPNc5JpYRv9clbCE+62d
	 JQy6wT63LKx09ARvrKekN7P0noCenuNCnoGTHenauv0lYthNwkjFIjTfdjPzEIQE7t
	 oGEDQh1hrnfhldU8lX1wAKVB1g5R9G/+v2MJNi4W9qbePkQLlJ5RuGhCgxXKQWsT4i
	 7p21QsnFSKl4g==
Date: Thu, 26 Nov 2026 16:05:11 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Yishai Hadas <yishaih@nvidia.com>, linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org, saeedm@nvidia.com, tariqt@nvidia.com,
	mbloch@nvidia.com, kuba@kernel.org, pabeni@redhat.com,
	edumazet@kernel.org, davem@davemloft.net, andrew+netdev@lunn.ch,
	dtatulea@nvidia.com, moshe@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V2 rdma-next 21/21] RDMA/core: Report and enforce
 adversarial mode via GET_CONTEXT
Message-ID: <20261126140511.GP774860@unreal>
References: <20261122073156.GA12665@unreal>
 <761ca80e-a772-41f3-b8e9-cc332e4ba5d9@nvidia.com>
 <20261124125327.GR14811@unreal>
 <20261124125950.GC9566@ziepe.ca>
 <20261124133353.GT14811@unreal>
 <20261124134751.GJ9566@ziepe.ca>
 <20261124140906.GU14811@unreal>
 <20261124143024.GO9566@ziepe.ca>
 <20261125090309.GY14811@unreal>
 <20261125144521.GI246011@ziepe.ca>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261125144521.GI246011@ziepe.ca>

On Wed, Nov 25, 2026 at 10:45:21AM -0400, Jason Gunthorpe wrote:
> On Wed, Nov 25, 2026 at 11:03:09AM +0200, Leon Romanovsky wrote:
> > > What do you mean? This is a mechanism to help the user manage software
> > > versions by not accepting incompatible rdma-cores.
> > 
> > Please take a look at the patch.
> > User space provides that new adversarial flag.
> > 
> > +	ret = uverbs_get_flags32(&ctx_flags, attrs, UVERBS_ATTR_GET_CONTEXT_FLAGS,
> > +				 UVERBS_ATTR_GET_CONTEXT_FLAG_ADVERSARIAL_SUPPORTED);
> > +	if (ret)
> > +		return ret;
> > +
> > +	if (ib_dev->adversarial_mode &&
> > +	    !(ctx_flags & UVERBS_ATTR_GET_CONTEXT_FLAG_ADVERSARIAL_SUPPORTED))
> > +		return -EPERM;
> > 
> > ...
> > +	UVERBS_ATTR_FLAGS_IN(UVERBS_ATTR_GET_CONTEXT_FLAGS, u32,
> > +			     UA_OPTIONAL),
> 
> What's the issue? If the user space doesn't ACK it has the new
> software then it doesn't create the context?
> 
> This is how we do every feature that needs rdma-core support, though
> more often there is a fallback in the kernel.
> 
> > The kernel does not care whether rdma-core is up to date. It works either
> > way, so why should we prohibit older userspace on these systems?
> 
> What do you mean?
> 
>  +	if (ib_dev->adversarial_mode &&
>  +	    !(ctx_flags & UVERBS_ATTR_GET_CONTEXT_FLAG_ADVERSARIAL_SUPPORTED))
>  +		return -EPERM;
> 
> That is not "works either way" that is requiring new software. Which
> is exactly what I want to see here.
>  
> > > It is not a security mechanism to hard guarantee that rdma-core has no
> > > bugs.
> > 
> > It is you who talked about "... security downgrade ...".
> 
> Yes, in that I want people using normal software to have a safer more
> secure experience. Meaning you need supporting rdma-core if the kernel
> is in adversarial mode, because otherwise you don't get the right
> security outcome.
> 
> You took it to some absurd scenario of a user hacking their rdma-core
> to defeat the check, which is not the point at all.

No. I'm evaluating each newly added UAPI field passed from userspace to
determine whether the kernel needs it. In this case, it does not. The
kernel will behave EXACTLY the same with or without this flag.

Thanks

>  
> Jason
> 
