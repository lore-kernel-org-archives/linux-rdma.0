Return-Path: <SRS0=dVsF=CE=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B14EC433DF
	for <linux-rdma@archiver.kernel.org>; Wed, 26 Aug 2020 08:27:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C9E320786
	for <linux-rdma@archiver.kernel.org>; Wed, 26 Aug 2020 08:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598430426;
	bh=PvxQOtuwXO6RcZnzLRfD2dX52ObtbFgWgHRVO8loVoQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=uR15pjFjkSre8XyXXsGLao7neCtFQ5PttgfOEacuzRMm/MxbQ1zT6X47Y9LuvcDMF
	 cBsQlEIp0jHsrcnWxwdMrnap/TbWsNUOJ6lcDEKmjY/aruXy4JMIs/IPlD6z5q2VqH
	 y4HFZhs2Gb2CrIEUGnSIvOJcVIp3UrEGgRPuiSj8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgHZI1F (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 26 Aug 2020 04:27:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:46046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726016AbgHZI1E (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 26 Aug 2020 04:27:04 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8D0B206FA;
        Wed, 26 Aug 2020 08:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598430424;
        bh=PvxQOtuwXO6RcZnzLRfD2dX52ObtbFgWgHRVO8loVoQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0STxPA8/uJNTiKkPZg2quIurKHf21XSw4V8AXKD9t6ev7EXLhxnbdGSyFA95ns5bd
         c+Pxe6w0YD7r3JEEj/2PQpqT4zk+vpBoA+DUU7mRehlu6YFv8M2k35nbyu8QjDh0TD
         kOwHqhM8isgLHt98mk5WCtgZc8+nUXhrwOjM2z1g=
Date:   Wed, 26 Aug 2020 11:27:00 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Gal Pressman <galpress@amazon.com>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-rdma@vger.kernel.org
Subject: Re: [PATCH rdma-next 10/14] RDMA/restrack: Store all special QPs in
 restrack DB
Message-ID: <20200826082700.GK1362631@unreal>
References: <20200824104415.1090901-1-leon@kernel.org>
 <20200824104415.1090901-11-leon@kernel.org>
 <6de2c8a5-3608-29a2-ecc3-41cafb2ed0a7@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6de2c8a5-3608-29a2-ecc3-41cafb2ed0a7@amazon.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, Aug 26, 2020 at 11:04:25AM +0300, Gal Pressman wrote:
> On 24/08/2020 13:44, Leon Romanovsky wrote:
> > diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
> > index e84b0fedaacb..7c4752c47f80 100644
> > --- a/drivers/infiniband/core/core_priv.h
> > +++ b/drivers/infiniband/core/core_priv.h
> > @@ -347,6 +347,8 @@ static inline struct ib_qp *_ib_create_qp(struct ib_device *dev,
> >  	qp->srq = attr->srq;
> >  	qp->rwq_ind_tbl = attr->rwq_ind_tbl;
> >  	qp->event_handler = attr->event_handler;
> > +	qp->qp_type = attr->qp_type;
>
> Already assigned above.

Thanks, it is rebase error.

>
> > +	qp->port = attr->port_num;
>
> If the assignment is moved here then it can be removed from ib_create_qp which
> was added in the first patch.
> Also, in the first patch it's surrounded by an if.

Right, I'll fix.

The "if (..)" comes from my request during internal review to be as strict
as possible for exporting qp->port to the user, but later when I developed
the series I found that ->port is cleared for non-special QPs, so "if (..)"
is not needed.

Thanks
