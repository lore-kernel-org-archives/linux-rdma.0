Return-Path: <SRS0=H2xG=7A=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DC2DC433E0
	for <linux-rdma@archiver.kernel.org>; Mon, 18 May 2020 04:42:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D809820823
	for <linux-rdma@archiver.kernel.org>; Mon, 18 May 2020 04:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589776932;
	bh=+RPRmYT7pnDqMlNSl5bSk12hQ0P+xXn7pslqSiXVcrA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=wOlNays7VNQ5soSgvyHzWdyKn2ARRlEeN2mXRJrN57mCGGZ5yOKJ1lQaIR9PvRqGV
	 hrn4Vx8GXvMLZC1TXJFUetc0Sxrt55y57N/QIdNC1HRZmI/fe1VEAnQHrd9WuEprBf
	 d7Z2En+dE/mwepiFUZ2D2sP/jmgrOOyD8ki8FMrc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726040AbgEREmM (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 18 May 2020 00:42:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:56714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725280AbgEREmM (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 18 May 2020 00:42:12 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCCDC20715;
        Mon, 18 May 2020 04:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589776931;
        bh=+RPRmYT7pnDqMlNSl5bSk12hQ0P+xXn7pslqSiXVcrA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s8D1wBMjcaOrBZly7meQPyn6Yj4zzT6/oVRf2HZ5fZpkW77i9qeYa+qMNDs8swo4k
         oX8zBzLHceg6313Fsl4/hBw7eo57B1cNDSo+HfNNSecCXrw+Y49W+jlna/Yx9wHF7q
         N/D4QN4BJV7FgI97X28m/I+EHuyJMYDQ8p2mWOoI=
Date:   Mon, 18 May 2020 07:42:07 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Doug Ledford <dledford@redhat.com>,
        Shay Drory <shayd@mellanox.com>, linux-rdma@vger.kernel.org
Subject: Re: [PATCH rdma-next] RDMA/mlx5: Update mlx5_ib driver name
Message-ID: <20200518044207.GA174762@unreal>
References: <20200513095304.210240-1-leon@kernel.org>
 <20200517234107.GA26854@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200517234107.GA26854@ziepe.ca>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Sun, May 17, 2020 at 08:41:07PM -0300, Jason Gunthorpe wrote:
> On Wed, May 13, 2020 at 12:53:04PM +0300, Leon Romanovsky wrote:
> > From: Shay Drory <shayd@mellanox.com>
> >
> > Current description doesn't include new devices, change it
> > by updating to have more generic description and remove
> > DRIVER_NAME and DRIVER_VERSION defines.
> >
> > Signed-off-by: Shay Drory <shayd@mellanox.com>
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > ---
> >  drivers/infiniband/hw/mlx5/main.c | 11 +----------
> >  1 file changed, 1 insertion(+), 10 deletions(-)
>
> Applied to for-next, thanks

Did you forget to push this commit to wip/jgg-for-next?
I don't see it yet.

Thanks

>
> Jason
