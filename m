Return-Path: <SRS0=bifO=63=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61E21CA90AF
	for <linux-rdma@archiver.kernel.org>; Wed, 13 May 2020 10:14:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D63C206E5
	for <linux-rdma@archiver.kernel.org>; Wed, 13 May 2020 10:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589364866;
	bh=ktt3fwk4+qXOFeWZPnXrGGb3zU3fFrrmKE8LnQutpe4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=GVVAmbiclBnbyR7slO0D1H34vDy4Zz5FmTlwMPnQ5nPjbL/y1+yge7kCtZrKxZ6LS
	 xf6vlAP4B51p8PilEbQCzsWqZRGx6TqEdcfe6snRg2l9RZX7LO4iSZH3u6Qj9Z7DCN
	 Cn0a3OEZciob/7yvJVAYrW6MFBlzB6y2JSXY7GAI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732689AbgEMKOZ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 13 May 2020 06:14:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:45656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732620AbgEMKOZ (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 13 May 2020 06:14:25 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 518A4205ED;
        Wed, 13 May 2020 10:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589364865;
        bh=ktt3fwk4+qXOFeWZPnXrGGb3zU3fFrrmKE8LnQutpe4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VcAK6SDEnIeXOPk43UlWMtf3h1qCKdtjG6fs+zNYNZx4f179CA/Hw/6G/k5V+S9aF
         NwTG9g+wi139fG9QKvRBX6eRsCtoEnW/RI6AXv8IRyoLAVaP9OpcgbncplrUS/ZkDv
         zuT7TfM4X+Nvlo/fQkXnN7wmWDUHxIBL8rtoJfvg=
Date:   Wed, 13 May 2020 13:14:21 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] RDMA/mlx5: Fix query_srq_cmd() function
Message-ID: <20200513101421.GU4814@unreal>
References: <20200513093741.GC347693@mwanda>
 <20200513100031.GT4814@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513100031.GT4814@unreal>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, May 13, 2020 at 01:00:31PM +0300, Leon Romanovsky wrote:
> On Wed, May 13, 2020 at 12:37:41PM +0300, Dan Carpenter wrote:
> > The "srq_out" pointer is never freed so that causes a memory leak.  It's
> > never used and can be deleted.  Freeing "out" will lead to a double in
> > mlx5_ib_query_srq().
> >
> > Fixes: 31578defe4eb ("RDMA/mlx5: Update mlx5_ib to use new cmd interface")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> >  drivers/infiniband/hw/mlx5/srq_cmd.c | 11 ++---------
> >  1 file changed, 2 insertions(+), 9 deletions(-)
> >
>
> Thanks for the report, the change should be slightly different.
>
> I'm sending fix right now.

https://lore.kernel.org/linux-rdma/20200513100809.246315-1-leon@kernel.org
