Return-Path: <SRS0=uC3E=AQ=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 864C1C433DF
	for <linux-rdma@archiver.kernel.org>; Sun,  5 Jul 2020 13:21:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6566520747
	for <linux-rdma@archiver.kernel.org>; Sun,  5 Jul 2020 13:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593955275;
	bh=XMWhx5kP75TAI/U5NQ03neewSo84f9fUjpDsi1PGCdU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=DwxRz1cEw0vtr1XOQyOUiwNIqfohT8gWHY/z+XX2NerrCgN+hecC98+vn5hg0Bz7X
	 K7AgHyS+rREt6EoakTTgI5ZA76XFPDJBdwCL9x0/iKdADR2XwIqUt99ITjrRQv6/Lg
	 x4j/I9HJi9gS13LUYAqiEyJ+tW1XoLuxmxfNVSOk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgGENVO (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 5 Jul 2020 09:21:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:52800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726833AbgGENVO (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sun, 5 Jul 2020 09:21:14 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99DC12073E;
        Sun,  5 Jul 2020 13:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593955274;
        bh=XMWhx5kP75TAI/U5NQ03neewSo84f9fUjpDsi1PGCdU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xQ2I4t9MZn11C18fxkkR8H4thqI/akgqnv/23KCzSRZ4NSdR+iwhQaY8IafYwuvsv
         XcSmMsGhPGW2YFnEqmfL0q07zPnsWBW/CIdk+EZwV/pMc7b6tEqipfyL9IUc8Y9PSD
         h1DXERyP7164pkWJeO6H2S1FXU8e1kmsgJEflh+s=
Date:   Sun, 5 Jul 2020 16:21:11 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Kamal Heib <kamalheib1@gmail.com>
Cc:     linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Zhu Yanjun <yanjunz@mellanox.com>
Subject: Re: [PATCH for-next v1 4/4] RDMA/rxe: Remove rxe_link_layer()
Message-ID: <20200705132111.GG5149@unreal>
References: <20200705104313.283034-1-kamalheib1@gmail.com>
 <20200705104313.283034-5-kamalheib1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200705104313.283034-5-kamalheib1@gmail.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Sun, Jul 05, 2020 at 01:43:13PM +0300, Kamal Heib wrote:
> Instead of returning IB_LINK_LAYER_ETHERNET from rxe_link_layer, return it
> directly from get_link_layer callback and remove rxe_link_layer().
>
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Signed-off-by: Kamal Heib <kamalheib1@gmail.com>
> ---
>  drivers/infiniband/sw/rxe/rxe_loc.h   | 1 -
>  drivers/infiniband/sw/rxe/rxe_net.c   | 5 -----
>  drivers/infiniband/sw/rxe/rxe_verbs.c | 4 +---
>  3 files changed, 1 insertion(+), 9 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
