Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99FC4446BEB;
	Thu, 16 Jul 2026 18:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784226142; cv=none; b=QwHfObEvo9jtvMWOIoP/Km9xaNF5IDnPSsA8WbNaC3DZTcb0PXeuUR4vxVZ82dz1lMa8lkgTn/kA/Q6U5kwP9VgTBGmk1x8X5hWn5XBK9fJNtANitiWaslP0SlIgzqdv45cVgpvlJz1pxyg4DVhNh8P6BpL6ebVRQ0m+j7knPFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784226142; c=relaxed/simple;
	bh=XVXU+2+Ob091Y/5q6gIOwo0fDECwvXIsgaTMO8cyMhM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dGWb0boH089BKU6mnEn6mrBgF/p2fhomFWQ5o8X14fjkyEXL7n0jxhEENxV0riZgK4pse/6Qd6s84Ua7zyqhcQ3s42MWPaXcDBJaJo3Snpfeq5h3VL0C9YbvnI2Vkw6F/VEMJGggPvtb5AqYWE6aiQdJ7k8dJ8LgotJtB7oMrKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KP4C+k3I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KP4C+k3I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ACEA1F000E9;
	Thu, 16 Jul 2026 18:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784226127;
	bh=q2tXztMRFCW2P3L7yFlbgoImTz2z3/GMbwPV/ytyt4U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KP4C+k3I4+GxUrD+yYe5cpMe9D9pRTu+ZSPhpBlStlfvM5QDJ6wHBCyXVIhxL+R6X
	 35oYDgqQ69IcbrZ+FnhgsHvpDE+GIyvJ+m8hgyQZAQ+yj8FxSrCnIxwEUoR4Q3HWVB
	 QfEOFN52TrBPqW6DKR6DLFu+KPqp5874ZDnXsVJcRfLW5NNR5eMfcI23+Pu6/15SPb
	 pR2qYRG+P7oE34tYAVPMhnPdZRe3zUMutTBjuvJCvkwhwimA+OT28l1NiVYhWlrcYU
	 pmd1sBC3LMvUE6YwvhycYmyKmqymrT1hifpB37RwAEj1K+LSMgVeiBaC4p5THydXtf
	 itr/rX0sgGsGw==
Date: Thu, 16 Jul 2026 21:22:00 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: kensanya@163.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
	TanZheng <tanzheng@kylinos.cn>
Subject: Re: [PATCH v2] RDMA/srpt: Fix srpt_alloc_rw_ctxs() unwind counters
Message-ID: <20260716182200.GA110966@unreal>
References: <20260715101550.45345-1-kensanya@163.com>
 <e29b0d9f-177f-431d-9411-66057f536bf1@acm.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e29b0d9f-177f-431d-9411-66057f536bf1@acm.org>

On Thu, Jul 16, 2026 at 10:37:39AM -0700, Bart Van Assche wrote:
> On 7/15/26 3:15 AM, kensanya@163.com wrote:
> > From: TanZheng <tanzheng@kylinos.cn>
> > 
> > When srpt_alloc_rw_ctxs() fails partway through a multi-buffer indirect
> > descriptor, the unwind path destroys RDMA contexts but leaves stale
> > n_rw_ctx and n_rdma values (and a dangling rw_ctxs pointer). Later
> > sq_wr_avail accounting in srpt_queue_response() or srpt_write_pending()
> > can then subtract the wrong number of send queue credits.
> > 
> > Reset the counters and clear rw_ctxs after freeing the heap
> > allocation before returning an error.
> > 
> > Fixes: b99f8e4d7bcd ("IB/srpt: convert to the generic RDMA READ/WRITE API")
> > Signed-off-by: TanZheng <tanzheng@kylinos.cn>
> > ---
> > v2:
> > - After kfree(), set rw_ctxs to NULL instead of &s_rw_ctx
> >    (Leon Romanovsky)
> > 
> >   drivers/infiniband/ulp/srpt/ib_srpt.c | 6 +++++-
> >   1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> > index f66cfd70c263..a9c4995af7a3 100644
> > --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> > +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> > @@ -1014,8 +1014,12 @@ static int srpt_alloc_rw_ctxs(struct srpt_send_ioctx *ioctx,
> >   				ctx->sg, ctx->nents, dir);
> >   		target_free_sgl(ctx->sg, ctx->nents);
> >   	}
> > -	if (ioctx->rw_ctxs != &ioctx->s_rw_ctx)
> > +	if (ioctx->rw_ctxs != &ioctx->s_rw_ctx) {
> >   		kfree(ioctx->rw_ctxs);
> > +		ioctx->rw_ctxs = NULL;
> > +	}
> > +	ioctx->n_rw_ctx = 0;
> > +	ioctx->n_rdma = 0;
> >   	return ret;
> >   }
> 
> The above looks wrong to me. In the error path ioctx->n_rw_ctx should be
> restored to the value it had at the start of the function instead of
> resetting it to zero.

Does this patch address your concerns?
https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/commit/?h=wip/leon-for-next&id=f65ababb556ae0110d14294747dd6df5dcb8f597

Thanks

> 
> Bart.
