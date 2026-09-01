Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4953845DF61
	for <linux-rdma@vger.kernel.org>; Tue,  1 Sep 2026 07:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788247957; cv=none; b=LkTqJFBifRsOtg1gvQP57TPCkXc/iGKWIzw96dmg81YI1BpkVowytfVKFrjLnvRWl3Mq3Vd12aZPAUnXHQJjX3qBjpWwl8ayyC7fHodgNg6BdaIijILEPja3+Zbp39uDuwFa68dXDMGK3+o5Mo2XUl7Gkrt9Uh0B5qxp9z4eYYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788247957; c=relaxed/simple;
	bh=pXE3VIyE+/gz4UhhZ4zAYUSG9d9yFMkHy2fdwobcnLk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZeVIiF/YzbTI1ty1+aJA286gzAQKaeUvUQhqVFXxyICC9Sw/7+K+Gx7yoxEXg0FluI/6qhBq0WkASRg1nk4aU14WjvHPU7AoQdxPGHhAgGwD5onkRCdeHr56xtt/fog8Zn+ghiGBtszM5vetE/aMK9IF8fN0mBg58ORhxJetmVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VmzATO96; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VmzATO96"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C1B1F000E9;
	Tue,  1 Sep 2026 07:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788247956;
	bh=MOMT6zdrYua3I76sACV9MAq+SQnwnZiXWPs57mvRVLU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VmzATO96Ak+er9g/lqVxbuk0ET8eWoMMAIia3WeTFDHq6U8G9rQejwJScgQDRfvXv
	 WTpXv7ogrTz4FY8uLUhDrItzCgNolwiETMZBHGqRTGqeTlmK8sTNc8Mq5vTLoIOvIY
	 D17jXn3XQUpl0FFNAD0m+sfqC4MBMNXVRucyXDQ9bcQY0TA+U/iVdXE2TY1ul4VhBp
	 Q+kZRb5Q+86vz4PUChIRbnAMVWU/5yI4x40B/3/+9V0CnDNV+bUa1VJ8xxigFhkBu6
	 bPktvu1bCDVma0gcwhPSENHRJID1EOca7kbVwKr5BYUWkfn9vHv+f0NghuxMhKlx2x
	 56nC7NV/ujy8Q==
Date: Tue, 1 Sep 2026 10:32:30 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Bernard Metzler <bernard.metzler@linux.dev>,
	Zhu Yanjun <zyjzyj2000@gmail.com>
Cc: Guoqing Jiang <guoqing.jiang@linux.dev>, jgg@ziepe.ca,
	linux-rdma@vger.kernel.org, shuangpeng.kernel@gmail.com
Subject: Re: [PATCH v2] RDMA/siw: Clear association under lock if
 siw_qp_modify fails in siw_accept
Message-ID: <20260901073230.GF24140@unreal>
References: <20260827125553.12831-1-guoqing.jiang@linux.dev>
 <b08cb248-e7eb-48ea-9873-02032c0ed0ff@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b08cb248-e7eb-48ea-9873-02032c0ed0ff@linux.dev>

On Thu, Aug 27, 2026 at 03:28:20PM +0200, Bernard Metzler wrote:
> On 27.08.2026 14:55, Guoqing Jiang wrote:
> > We need to clear cep before release state_lock as siw_qp_llp_close and
> > siw_qp_modify->siw_qp_llp_close did.
> > 
> > Otherwise if siw_qp_modify() fails in siw_accept(), the QP's state_lock
> > is released before the error path cleanup. A concurrent ibv_modify_qp()
> > transitioning the QP to ERROR can race in this window:
> > 
> >    siw_accept()                       ibv_modify_qp(ERROR)
> >    ----------------------             ----------------------
> >    siw_qp_modify() fails
> >    up_write(&qp->state_lock)
> >                                       down_write(&qp->state_lock)
> >                                       nextstate_from_idle():
> > 				     if (qp->cep)
> >                                         siw_cep_put(qp->cep) <- frees cep
> >                                         qp->cep = NULL
> >    goto error
> >      cep->qp = NULL                   <- UAF
> > 
> > Clear qp->cep and drop the association reference taken by siw_cep_get(),
> > all under the write lock held from the initial down_write(&qp->state_lock).
> > Thread B therefore sees qp->cep == NULL, skips its own put, and cannot free
> > the cep before siw_accept() is done with it.
> > 
> > Reported-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
> > Link: https://lore.kernel.org/linux-rdma/d6fbe475-a5c2-f975-99b0-a0bd6b6d10e8@linux.dev/T/#m5876c1ff2de8686a9a1173b8f1aa0ff5363a785c
> > Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
> > ---
> > V2: remove redundant code per Bernard's review
> > 
> >   drivers/infiniband/sw/siw/siw_cm.c | 7 +++++--
> >   1 file changed, 5 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
> > index 0245b25e7271..ed49818793dd 100644
> > --- a/drivers/infiniband/sw/siw/siw_cm.c
> > +++ b/drivers/infiniband/sw/siw/siw_cm.c
> > @@ -1719,9 +1719,12 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
> >   			   SIW_QP_ATTR_STATE | SIW_QP_ATTR_LLP_HANDLE |
> >   				   SIW_QP_ATTR_ORD | SIW_QP_ATTR_IRD |
> >   				   SIW_QP_ATTR_MPA);
> > +	if (rv) {
> > +		qp->cep = NULL;
> > +		siw_cep_put(cep);
> > +		goto error_unlock;
> > +	}
> >   	up_write(&qp->state_lock);
> > -	if (rv)
> > -		goto error;
> >   	siw_dbg_cep(cep, "[QP %u]: send mpa reply, %d byte pdata\n",
> >   		    qp_id(qp), params->private_data_len);
> 
> Looks good. Thank you, Guoqing.
> 
> Acked-by: Bernard Metzler <bernard.metzler@linux.dev>

Bernard,

I will take this patch. However, siw_accept() looks wrong to me. It
mixes locking, qp->cep handling, and siw_cep_put() in a seemingly
inconsistent manner.

For example, here you clear qp->cep and call siw_cep_put() while holding
the lock, whereas in the error unwind path you do exactly the opposite.

Be aware that AI-generated suggestions for SIW are complete garbage. If
you do not clean up these code paths, your driver will soon end up in a
broken and unmaintainable state. The same applies to RXE.

Thanks
