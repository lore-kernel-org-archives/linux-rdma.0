Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F47BC433E6
	for <linux-rdma@archiver.kernel.org>; Thu, 28 Jan 2021 14:24:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CEC264DD9
	for <linux-rdma@archiver.kernel.org>; Thu, 28 Jan 2021 14:24:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbhA1OYF (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 28 Jan 2021 09:24:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:44418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231639AbhA1OV4 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 28 Jan 2021 09:21:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00BBB64D9F;
        Thu, 28 Jan 2021 14:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611843675;
        bh=FHlVh7UZ1yGM25A9LYiKOo74UGo+pNs8rK8Qxz2dH78=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g9IoiyXa+IU1Tc8/YXmpO2FcRqBJ+hZw5+7IzAFdrXr8b/JGXgFKucVOJTD0OIupK
         qO2b/j/+VYHAhJCIGLXPkJpmjmjT18SnFw+TYAx0PPPcGLyfCQc21YkOIUOIw0HZW0
         mtDMnC/8QRWkXsU7Mi7us5vu5H11q80+djcycZPUbZLR+XdTt4bhjAXcrfn756C8dl
         eFIJGd4BadWwlY6VQKp+cEaumezdzLkXp4qcUUo6NFNo/qAIBcuU64RQBIM/THShK2
         xjJdGanNu54gl1kJI9h9Bowiy90h1Pdeh33DRKzFA8y1vZDg7/UYbIX9ddctVyY3qA
         2/BlEIS5rFfcw==
Date:   Thu, 28 Jan 2021 16:21:12 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Lameter <cl@linux.com>, linux-rdma@vger.kernel.org
Subject: Re: [PATCH] Fix: Remove racy Subnet Manager sendonly join checks
Message-ID: <20210128142112.GB166678@unreal>
References: <alpine.DEB.2.22.394.2101251126090.344695@www.lameter.com>
 <20210128140335.GA13699@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128140335.GA13699@nvidia.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, Jan 28, 2021 at 10:03:35AM -0400, Jason Gunthorpe wrote:
> On Mon, Jan 25, 2021 at 11:28:57AM +0000, Christoph Lameter wrote:
> > On Sun, 24 Jan 2021, Leon Romanovsky wrote:
> >
> > > > Since all SMs out there have had support for sendonly join for years now
> > > > we could just remove the check entirely. If there is an old grizzly SM out
> > > > there then it would not process that join request and would return an
> > > > error.
> > >
> > > I have no idea if it possible, if yes, this will be the best solution.
> >
> > Ok hier ist ein neuer Patch:
> >
> > From: Christoph Lameter <cl@linux.com>
> > Subject: [PATCH] Fix: Remove racy Subnet Manager sendonly join checks
>
> I need patches to be sent in a way that shows in patchworks to be
> applied:
>
> https://patchwork.kernel.org/project/linux-rdma/list/
>
> > Index: linux/drivers/infiniband/core/cma.c
> > ===================================================================
> > +++ linux/drivers/infiniband/core/cma.c	2021-01-25 09:39:29.191032891 +0000
> > @@ -4542,17 +4542,6 @@ static int cma_join_ib_multicast(struct
>
> Also if patches aren't generated with 'git diff' then I won't fix any
> minor conflicts :(

My mutt2git script picked this patch correctly and without conflicts :).
Anyway, from our (MLNX testing) perspective this patch is OK.

Thanks

>
> Thanks,
> Jason
