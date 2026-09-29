Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26ED821A42D;
	Tue, 29 Sep 2026 08:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790670834; cv=none; b=CuXMzMN4W8qfABROIf8J2fknxl2fnNllE3iOpLFmnUhSModx9m+Kj/WtkcCDxgNl+BJWqv8yvnAzClY9uMG3P98An0wLP/EqhypgBrcQ+exs4QNaAQ2+xTMO8amMlYRpQh9jqstJXh3hMgCjwqxkKSEZzEvZnmKp3waUesqy6/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790670834; c=relaxed/simple;
	bh=g+moG+Xqr5GkW3sv8BKDaFh8Xd89UQOgPOu5R98NveE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R5xEzuhz03NMsUYE6zNwyyF/ugaCSNdJcHsHj4dBqb85ujB/aEuQHTVpvEIMakbgV9wtSvb1S24pjHXqn5AItg71l9WyV7fjtkAk0b2ZFDyQtO/eAkfR3kGBFaboGFokKZ9ST3l/bzG7tKDTA0BD3z8HNZjRdRNRz8S57UjfNQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PDn8zDZr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PDn8zDZr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E811F000FF;
	Tue, 29 Sep 2026 08:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790670832;
	bh=LG8m6jXzQIhCHVyOAXzZvwVDGqI2AMU4RU+I5bDg540=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PDn8zDZrIH400CAXSTKYmLkCmL/dBOORP/cc9m1+TN7A/ECrH26I3iYOo++ADTUUx
	 o+0Xql+Sn1045NwsBfNmuT+44GZ3gLN7Oz7bz5m4Sof/S0yhc8dYlPPITahrh535a7
	 vnFHs3SckEIy63Zj6NL3GKVOQASJvt39r5YD/Wk9L1pZ1IQi92oFTKV8lDSsoJr5Ky
	 J345R2b2TO46IGtgWHFZ+dnQE88bL/B7+XoQJZc2Qe5AR7t8SWx2cVWGJBtB7K93hg
	 pY9QXaiauoMc3UNxizTTQc6NkIWv2z6inGkbq69Lcg86nNUVgZuehgSlohmkdHys/J
	 mC5aZVF6Msbxw==
Date: Tue, 29 Sep 2026 11:33:47 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Selvin Xavier <selvin.xavier@broadcom.com>
Cc: sashiko-reviews@lists.linux.dev, linux-rdma@vger.kernel.org
Subject: Re: [PATCH for-rc v3 5/8] RDMA/bnxt_re: Validate num_sge in
 bnxt_re_post_srq_recv()
Message-ID: <20260929083347.GH563127@unreal>
References: <20260922061230.7909-1-selvin.xavier@broadcom.com>
 <20260922061230.7909-6-selvin.xavier@broadcom.com>
 <20260922010711.3E3C21F000FF@smtp.kernel.org>
 <CA+sbYW0A0gS2dhgLF18etO9mnMzhxvLbDmru6v17t+7qQ4Hizw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+sbYW0A0gS2dhgLF18etO9mnMzhxvLbDmru6v17t+7qQ4Hizw@mail.gmail.com>

On Tue, Sep 22, 2026 at 10:09:52AM +0530, Selvin Xavier wrote:
> On Tue, Sep 22, 2026 at 6:37 AM <sashiko-bot@kernel.org> wrote:
> >
> > Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> > - [High] rdma/bnxt_re: un-ratelimited error log in spinlock allows DoS
> > --
> >
> > commit bb7479cd7b3a22e9b0e6b2862ab2b9133790528b
> > Author: Selvin Xavier <selvin.xavier@broadcom.com>
> >
> > RDMA/bnxt_re: Validate num_sge in bnxt_re_post_srq_recv()
> >
> > Add a check if max sge for SRQ is exceeding the device maximum.
> >
> > > diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > > index c35ed6ed03516..3cccef8e2e837 100644
> > > --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > > +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > > @@ -2399,6 +2399,13 @@ int bnxt_re_post_srq_recv(struct ib_srq *ib_srq, const struct ib_recv_wr *wr,
> > >               /* Transcribe each ib_recv_wr to qplib_swqe */
> > >               wqe.flags = 0;
> > >               wqe.num_sge = wr->num_sge;
> > > +             if (wr->num_sge > srq->qplib_srq.max_sge) {
> > > +                     ibdev_err(&srq->rdev->ibdev,
> > > +                               "Limit exceeded for SRQ Receive SGEs");
> >
> > [Severity: High]
> > Is it safe to use an un-ratelimited ibdev_err() here while holding the
> > srq->lock spinlock with interrupts disabled in bnxt_re_post_srq_recv()?
> >
> > Since an unprivileged user can repeatedly invoke the RDMA uverbs API with a
> > wr->num_sge larger than srq->qplib_srq.max_sge, could this regression allow a
> > local user to flood the kernel log buffer and potentially cause soft lockups?
>  It is possible to reach the kernel driver using an under privilaged
> user, but there is no support in rdma-core/libbnxt_re to call
> ibv_cmd_post_srq_recv and this code path will not be reached as of
> now. So I think this can be ignored.

We cannot assume that rdma-core is trusted. Anyone can build it locally and use it
to interact with the kernel. In addition, syzkaller uses our UAPI structures
and commands directly, without involving rdma-core.

Thanks

> >
> > > +                     rc = -EINVAL;
> > > +                     *bad_wr = wr;
> > > +                     break;
> > > +             }
> > >               bnxt_re_build_sgl(wr->sg_list, wqe.sg_list, wr->num_sge);
> > >               wqe.wr_id = wr->wr_id;
> > >               wqe.type = BNXT_QPLIB_SWQE_TYPE_RECV;
> >
> > --
> > Sashiko AI review · https://sashiko.dev/#/patchset/20260922061230.7909-1-selvin.xavier@broadcom.com?part=5


