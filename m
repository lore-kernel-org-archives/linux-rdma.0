Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795709846;
	b=sjjZBKZ5RoEXa9pPaEm/d7K1U99pjZnkNIkgL8eXpVZGYI4uH+QN86vY6o42PLXxGyHo
	 sNDpGsEuKaOfz5LYFH5meNQtAL82MN4JrcHoJdSOKF08HGK44EXnEdaHldC/wvPWJWJgw
	 u9+tfcHBHPcBdIzaBP6o7n4tl/yVEbpErry2Tw4JSFcQVB7n8SDRhyTYZXRvaD5Nqx6c0
	 Tmrwz/A1W/NlMK+dcJGC2wMh9uH9ObVJF2+yEdvQ7pjPFnMCZ2PfD9USIP7vmzX93BBwm
	 QRItF9bcTxS4VG57OYFVBznLmRyDwmEKfv/85tjhaz3cySPwKsQhTlI1ivci7xPN0AA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795709846;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=8E9S1d/Z46O9djmn0gqo5FA/oGrxIuVLR6nqFoJHxXg=;
	b=pf5UaWmfjzy6bawY+okY8k+0h6IvLoZHnHsVm18OQqCXGoR3KT/XlKKNXA9u4+T2R5ff
	 qAJNN8LJJBk6/AmxVvLLvC5X+SsHd4vE5eoF9GaIq2uVJVB9jFXpkHGXXXw+O71/ecTZT
	 D9zkF2Z94cWB6S6foS8NPtiJGVeTeuyeObu9ldf3Kzp832PouTDM9JbvMDlEkNIzy2zw9
	 Qi0Vn5pkl5PGHvetSSegjCCDNFZFWjfQjJDxcDHu+fS7U4rQhpL+nnU8H4V1R43UGpAji
	 xF94M2JfVFGh7m45yX7b4au5Lu/aCq0IHf8WK0WuvTxkGLSA/FGqqrCJG3bowPKaifw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RZgxnElO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A6F606A31C
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 16:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RZgxnElO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C81FC1F000C0;
	Thu, 26 Nov 2026 16:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795709846;
	bh=8E9S1d/Z46O9djmn0gqo5FA/oGrxIuVLR6nqFoJHxXg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RZgxnElO+jO6dG1K46ymCs5Rr6Ib2a8Ub6JaIGSFlzE2Sti4nTeooMyApWc7762nL
	 QuujeVE02OlZpChtL1/RmiQmJ1QTakPqSrcbqJAqteEvi5wZPgrpuy4Tfvsq+6e+Bg
	 UFc/Pk0CUEKNDq6ICDaK3T90JwCbDaSCILid+sPT/I02xpF3eW7fGhq4dILrKgyb2g
	 mHa4KQej5ppnf8h6pA3SV9K0KP7OmksS7PDxLiizKk2H60fxKY1lC1sH9cD4qKVe2R
	 Fih33z8UAp+Q1V63pjEKzYyvCXu8MunWWuhvqVyLJhiEm/DRiNV8GwMkFuR3rFVBZH
	 6AAiRQtsviE5w==
Date: Thu, 26 Nov 2026 18:17:23 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Michael Margolin <mrgolin@amazon.com>
Cc: Ilia Kolominsky <ikolomin@amazon.com>, jgg@nvidia.com,
	linux-rdma@vger.kernel.org, sleybo@amazon.com, matua@amazon.com,
	gal.pressman@linux.dev
Subject: Re: [PATCH for-next 0/3] RDMA/efa: Add Completion Actions support
Message-ID: <20261126161723.GU774860@unreal>
References: <20261109081349.27316-1-ikolomin@amazon.com>
 <20261116112913.GI11319@unreal>
 <20261117081850.GA18565@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
 <20261117125325.GE124972@unreal>
 <20261119162601.GA4902@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
 <20261125164204.GA33524@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
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
In-Reply-To: <20261125164204.GA33524@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>

On Wed, Nov 25, 2026 at 04:42:04PM +0000, Michael Margolin wrote:
> On Thu, Nov 19, 2026 at 04:26:21PM +0000, Michael Margolin wrote:
> > On Tue, Nov 17, 2026 at 02:53:25PM +0200, Leon Romanovsky wrote:w3esq23
> > 
> > > On Tue, Nov 17, 2026 at 08:18:50AM +0000, Michael Margolin wrote:
> > > > On Mon, Nov 16, 2026 at 01:29:13PM +0200, Leon Romanovsky wrote:
> > > > > On Mon, Nov 09, 2026 at 08:13:46AM +0000, Ilia Kolominsky wrote:
> > > > > > EFA Completion actions let an application observe work request
> > > > > > completions without polling a completion queue: when a work request
> > > > > > completes, locally or at the remote side, the device performs an action
> > > > > > that the work request names, such as writing a value to a user buffer.
> > > > > 
> > > > > Why are these verbs EFA-specific? This looks like extension of already
> > > > > generic UVERBS_METHOD_COMP_CNTR_* code and probably should be general too.
> > > > 
> > > > It is indeed an extension of Completion Counters, and later we plan to
> > > > connect the two by allowing a Completion Counter to be used as a
> > > > Completion Action, but unlike counters, actions mostly matter for
> > > > unordered transports where a completion count alone doesn't tell the
> > > > application which requests have completed, so it needs an efficient way
> > > > to track completion of specific requests.
> > > > 
> > > > Do you think these semantics can be useful for other providers at this
> > > > stage, or can we start with an EFA-specific interface and add a common
> > > > ABI later if required?
> > > 
> > > I think the idea and implementation is general enough to be picked by
> > > anyone who will decide to implement it later. Let's do it in common ABI,
> > > please.
> > > 
> > > Thanks
> > > 
> > 
> > Ok, makes sense.
> > Please see libibverbs API suggestion:
> > https://github.com/linux-rdma/rdma-core/pull/1865
> > 
> 
> Hi Jason, Leon,
> 
> While moving completion actions to a common ABI, we have two questions
> we'd like your input on before sending patches.
> 
> First, completion counters and completion actions are getting very
> close. A counter is updated by completions on the QPs it's attached to.
> An action is performed when a work request that names it completes.
> Both are "do something on completion", and a counter could be one type
> of action. We're looking at modeling them as one object, with QP attach
> and WR triggering options as properties. That would mean renaming
> UVERBS_OBJECT_COMP_CNTR and its methods to COMP_ACTION, of course
> keeping compatibility. Does the merged model make sense to you, and is
> a rename like that acceptable at this stage?

Yes. rdma-core depends on the enum value, not the name. You can rename it
to anything at any time, as long as the enum value remains unchanged.

> 
> Second, a more general question about out-of-tree drivers. We backport
> new core uverbs objects in our out-of-tree EFA driver by registering
> them with the core IDs on older kernels, so rdma-core has one path
> everywhere. That doesn't work once a new object goes past
> UVERBS_API_OBJ_KEY_NUM_CORE, because uapi_key_obj() rejects the ID
> before the driver is involved. The driver could register the object in
> its own namespace instead. But then rdma-core would need a fallback:
> either a retry with a different object ID, or using an ID the kernel
> reports through an optional attribute. Would something like that be
> acceptable in rdma-core?

Generally speaking, we are not supporting anything out-of-tree.

> 
> Happy to send an RFC if it's easier to discuss over code.

But let's look at some code. It may be useful beyond your out-of-tree code.

Thanks

> 
> Thanks,
> Michael
> 
> 
