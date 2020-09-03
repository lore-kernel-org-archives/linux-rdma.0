Return-Path: <SRS0=kLQv=CM=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 353CDC433E2
	for <linux-rdma@archiver.kernel.org>; Thu,  3 Sep 2020 05:35:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1177F2080C
	for <linux-rdma@archiver.kernel.org>; Thu,  3 Sep 2020 05:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599111322;
	bh=ncacchE1xcL0OZAn8BjSVADnyMdhbYiDzWn4Cd4MCV0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=jFS1sIoUvaqv5u+d0TE0iHKvs43AZuQhoOXY9ME0zIF4RXlrcWad4AtALDQveaPKe
	 kgO0qFlxIF+nM1CeVivMaUD0V+MUftwuyVBJ9TnaH3+I1GKJdkLOeR/D2eNW9GSmHR
	 /4wZk5Kq323zk1tYLmJ+Juy7kvEDAUhUuBSNa1N4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725919AbgICFfV (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 3 Sep 2020 01:35:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:46078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725851AbgICFfV (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 3 Sep 2020 01:35:21 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D04BA2072A;
        Thu,  3 Sep 2020 05:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599111320;
        bh=ncacchE1xcL0OZAn8BjSVADnyMdhbYiDzWn4Cd4MCV0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AYCxI7qfZogthSM20o0EbuQyaeg8LJ/V3Y5mEbdS4Uhhtc7QsZI+0fDiplnwiHFcU
         2pp4TbrQa+TCM3CZhPKLX4ioqFCR0rAf6388hnQQm20V0m06TgJzsgFj/lsP1ZMlch
         RKjuvIycTTglX+o6otuM40H8UMLwJk6dIXAX12IA=
Date:   Thu, 3 Sep 2020 08:35:17 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org
Subject: Re: [PATCH rdma-next v1 06/10] RDMA/core: Delete function
 indirection for alloc/free kernel CQ
Message-ID: <20200903053517.GR59010@unreal>
References: <20200830084010.102381-1-leon@kernel.org>
 <20200830084010.102381-7-leon@kernel.org>
 <20200903002048.GA1480415@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903002048.GA1480415@nvidia.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, Sep 02, 2020 at 09:20:48PM -0300, Jason Gunthorpe wrote:
> On Sun, Aug 30, 2020 at 11:40:06AM +0300, Leon Romanovsky wrote:
> >  /**
> > - * ib_free_cq_user - free a completion queue
> > + * ib_free_cq - free a completion queue
> >   * @cq:		completion queue to free.
> > - * @udata:	User data or NULL for kernel object
> >   */
> > -void ib_free_cq_user(struct ib_cq *cq, struct ib_udata *udata)
> > +void ib_free_cq(struct ib_cq *cq)
> >  {
> > -	if (WARN_ON_ONCE(atomic_read(&cq->usecnt)))
> > -		return;
> > -	if (WARN_ON_ONCE(cq->cqe_used))
> > -		return;
> > +	WARN_ON_ONCE(atomic_read(&cq->usecnt));
>
> In this case we expect ops.destroy_cq to fail, so no sense in
> continuing, leak everything, the ULP is buggy.

I disagree, we should clean as much as possible and leave the HW object.

Thanks

>
> Jason
