Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E50443AB5;
	Thu, 16 Jul 2026 18:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784226307; cv=none; b=E6KpYFxElTHsLuMnzrMh7SG4IhQlys4oqvCyJXk7f7Gk7s2HPIfy+E3zadJLYljcfErkd/KR42S8xwTOKoO44XsYmUG5UZD8VwX2Ojh8kcPa7jC9t8uUIlHaK4IHpgutC+z/7ryApd/x3rOuWdhmy0ZpXwiZYlZtd6uqru5kvSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784226307; c=relaxed/simple;
	bh=LdNxzhCDmQY07oDFWwB2XtLreHijonZ103H+dGgutWU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cQqQpWRc7FnC/7OMPfS/EUFy+1vao1ZfN65z1MvBxOn6MhcGa8OiWsO7gwZ60xuqUJDPIRC1xcOb23+2KUTwRMvrocHuGL6pYtWlKNLmhnkPzs08mgoBVIZIFM24/wyVThECAF7iCeNlJHqZ1BwHLxgKmvzQOD7eRDl5lQ6iutc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IRxBE4Ts; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IRxBE4Ts"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57C011F000E9;
	Thu, 16 Jul 2026 18:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784226293;
	bh=XBTJcwlTxjmXibG7jm4iNriYCwMGfZ2vWf52oJ550Gc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IRxBE4TsYr917X03EAqe3s2Q72S1jqeLt/YeJErZDD2M5S2scQ2RPR2o/0/M0XC1a
	 +vFJPPrkI2+W23LgIDT0JJzUf6pdG979rc2PeX7hrtWfxSzxpnRvq+p6iMsvY5+/xw
	 KdYeuGVRi83VPG3Ungqfb3enxs6hIlSyDhPShSdxz9d8qUPbficZBOEas02Q2ZOYAr
	 yRID1smK7eqcD1KXXeETQO8k1kW3AngCE6GQ2GnKvp7x83cdmMn4mr5r/gkAGo3qoC
	 5idkBt/3qlZE/h4U9APYofpY420hQw6nVafdIw6MTD4nrVkIM79XaFG9xzbtdDkBep
	 05RYKoH5Y7lrw==
Date: Thu, 16 Jul 2026 21:24:48 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: kensanya@163.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
	TanZheng <tanzheng@kylinos.cn>
Subject: Re: [PATCH v2] RDMA/srpt: Fix srpt_alloc_rw_ctxs() unwind counters
Message-ID: <20260716182448.GB110966@unreal>
References: <20260715101550.45345-1-kensanya@163.com>
 <e29b0d9f-177f-431d-9411-66057f536bf1@acm.org>
 <20260716182200.GA110966@unreal>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260716182200.GA110966@unreal>

On Thu, Jul 16, 2026 at 09:22:00PM +0300, Leon Romanovsky wrote:
> On Thu, Jul 16, 2026 at 10:37:39AM -0700, Bart Van Assche wrote:
> > On 7/15/26 3:15 AM, kensanya@163.com wrote:
> > > From: TanZheng <tanzheng@kylinos.cn>
> > > 
> > > When srpt_alloc_rw_ctxs() fails partway through a multi-buffer indirect
> > > descriptor, the unwind path destroys RDMA contexts but leaves stale
> > > n_rw_ctx and n_rdma values (and a dangling rw_ctxs pointer). Later
> > > sq_wr_avail accounting in srpt_queue_response() or srpt_write_pending()
> > > can then subtract the wrong number of send queue credits.
> > > 
> > > Reset the counters and clear rw_ctxs after freeing the heap
> > > allocation before returning an error.
> > > 
> > > Fixes: b99f8e4d7bcd ("IB/srpt: convert to the generic RDMA READ/WRITE API")
> > > Signed-off-by: TanZheng <tanzheng@kylinos.cn>
> > > ---
> > > v2:
> > > - After kfree(), set rw_ctxs to NULL instead of &s_rw_ctx
> > >    (Leon Romanovsky)
> > > 
> > >   drivers/infiniband/ulp/srpt/ib_srpt.c | 6 +++++-
> > >   1 file changed, 5 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> > > index f66cfd70c263..a9c4995af7a3 100644
> > > --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> > > +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> > > @@ -1014,8 +1014,12 @@ static int srpt_alloc_rw_ctxs(struct srpt_send_ioctx *ioctx,
> > >   				ctx->sg, ctx->nents, dir);
> > >   		target_free_sgl(ctx->sg, ctx->nents);
> > >   	}
> > > -	if (ioctx->rw_ctxs != &ioctx->s_rw_ctx)
> > > +	if (ioctx->rw_ctxs != &ioctx->s_rw_ctx) {
> > >   		kfree(ioctx->rw_ctxs);
> > > +		ioctx->rw_ctxs = NULL;
> > > +	}
> > > +	ioctx->n_rw_ctx = 0;
> > > +	ioctx->n_rdma = 0;
> > >   	return ret;
> > >   }
> > 
> > The above looks wrong to me. In the error path ioctx->n_rw_ctx should be
> > restored to the value it had at the start of the function instead of
> > resetting it to zero.
> 
> Does this patch address your concerns?
> https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/commit/?h=wip/leon-for-next&id=f65ababb556ae0110d14294747dd6df5dcb8f597

I'm sorry, this one
https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/commit/?h=wip/leon-for-next&id=07f5f0308bef

Thanks

> 
> Thanks
> 
> > 
> > Bart.
> 
