Return-Path: <SRS0=u98Z=43=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26FA6C10F27
	for <linux-rdma@archiver.kernel.org>; Tue, 10 Mar 2020 18:28:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6810208C3
	for <linux-rdma@archiver.kernel.org>; Tue, 10 Mar 2020 18:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583864910;
	bh=VZIr2aWG/6QvTXwaHFpApeV/h8KZCWELjQ9ZDi27IRs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=n2bPV7GUJ0rRRd33fM2QjfRNPoLfTEqwl047Cw8yx7KZ9+TjN0iLOJa2IdxTDDDV5
	 XeKmgYHqYtQoDDM7wYbuSaxuLsOOmG6W9pDIKrbDZwji0hJCw4YmnUYPfGWDOf87q3
	 tTP9icU/s5mQKUmC8OKUfxASIgeJ+u8iGJHh63qw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbgCJS23 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 10 Mar 2020 14:28:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:59942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726283AbgCJS23 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 10 Mar 2020 14:28:29 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1281720727;
        Tue, 10 Mar 2020 18:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583864908;
        bh=VZIr2aWG/6QvTXwaHFpApeV/h8KZCWELjQ9ZDi27IRs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hLNCFpb2KF/n8X4kAZieRRiQbCQuHUY5gBgP05u/Adda8M+qIRqquiElPxGeqwrzU
         pjSMHWjP11O8jsuCoSc/iDm86pE/ZtDn4Jm/rmKc1mfgWbsch8bgkvEJAm8GpmPxIB
         rNbdkiMErRDFfbGZkrn12YOtl70gDus6YZKYz0Mk=
Date:   Tue, 10 Mar 2020 20:28:23 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Doug Ledford <dledford@redhat.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Alex Vesker <valex@mellanox.com>,
        Ariel Levkovich <lariel@mellanox.com>,
        linux-rdma@vger.kernel.org,
        Yevgeny Kliteynik <kliteyn@mellanox.com>
Subject: Re: [PATCH rdma-next] RDMA/mlx5: Remove duplicate definitions of
 SW_ICM macros
Message-ID: <20200310182823.GL242734@unreal>
References: <20200310075706.238592-1-leon@kernel.org>
 <20200310174101.GA28121@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200310174101.GA28121@ziepe.ca>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, Mar 10, 2020 at 02:41:01PM -0300, Jason Gunthorpe wrote:
> On Tue, Mar 10, 2020 at 09:57:06AM +0200, Leon Romanovsky wrote:
> > From: Erez Shitrit <erezsh@mellanox.com>
> >
> > Those macros are already defined in include/linux/mlx5/driver.h,
> > so delete their duplicate variants.
> >
> > Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
> > Signed-off-by: Yevgeny Kliteynik <kliteyn@mellanox.com>
> > Signed-off-by: Erez Shitrit <erezsh@mellanox.com>
> > Reviewed-by: Alex Vesker <valex@mellanox.com>
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > ---
> >  drivers/infiniband/hw/mlx5/mlx5_ib.h | 4 ----
> >  1 file changed, 4 deletions(-)
>
> That is a long list of signed off by's for a two line patch..

Team work.

>
> Applied to for-next
>
> Jason
