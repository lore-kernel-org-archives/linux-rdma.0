Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 086B3C433DB
	for <linux-rdma@archiver.kernel.org>; Fri, 12 Mar 2021 06:38:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4C3564F7E
	for <linux-rdma@archiver.kernel.org>; Fri, 12 Mar 2021 06:38:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbhCLGhe (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 12 Mar 2021 01:37:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:43436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230484AbhCLGhH (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 12 Mar 2021 01:37:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C424264F7E;
        Fri, 12 Mar 2021 06:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615531027;
        bh=AfKLx37QRKm8zYHJKFxM2MKW4sLgWzgL7LYAyt2zWA0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fSIntlyHaZbeiG5eFsxmXMtZGPFMaaMpW88yn37mKZ7nOYhKL3WpIHcjVVgsiqLWI
         +zGimsgh2yFO0sm4izQKqiy3GFtAiOmAR8Tq/Cwgy35dCEWDEgH/rcXcvXCSTZ91YQ
         px09DA/mbwkLE5Zduhi9nSPvSj9fzqELWIJ7KumJn02VcWYtv931Gld+fxqjChuleE
         W2E0b8eLkr2tCK9UoWvGXurFaEvlubzbJ3kKUVEiLtq1GrBezgksFF6yLAQAe3LQ6K
         n3OOqXqKsUvfsN0VwaE3zPNC67xDjlOwMWNIQF7FUZ9TrlS6svXtOR9oY8D+wFItfg
         EP7hhJVnodqtg==
Date:   Fri, 12 Mar 2021 08:37:04 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: Re: [PATCH rdma-next 0/3] Batch independent fixes to mlx5_ib
Message-ID: <YEsMEKrgLwGR/sdv@unreal>
References: <20210304124517.1100608-1-leon@kernel.org>
 <20210312003016.GB2787233@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210312003016.GB2787233@nvidia.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, Mar 11, 2021 at 08:30:16PM -0400, Jason Gunthorpe wrote:
> On Thu, Mar 04, 2021 at 02:45:14PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> >
> > Completely independent fixes and improvements to mlx5_ib driver.
> >
> > Maor Gottlieb (1):
> >   RDMA/mlx5: Fix query RoCE port
> >
> > Mark Zhang (1):
> >   RDMA/mlx5: Fix mlx5 rates to IB rates map
>
> Applied to for-next
>
> > Shay Drory (1):
> >   RDMA/mlx5: Create ODP EQ only when ODP MR is created
>
> This one needs a fix

I don't think so. Please reconsider.

>
> Thanks,
> Jason
