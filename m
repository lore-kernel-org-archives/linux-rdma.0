Return-Path: <SRS0=bifO=63=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FF15C2D0FA
	for <linux-rdma@archiver.kernel.org>; Wed, 13 May 2020 10:00:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DADD206B8
	for <linux-rdma@archiver.kernel.org>; Wed, 13 May 2020 10:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589364039;
	bh=x5e0Sj6los9/lOrTsvPvqfnkzghBR0Op1VeaRSfeu1o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=vyC5e1gv6i780DlT2ibXdr2BmLyhWlNhhXDb4LZcTqmh+X6Cc9JEoo01ukffU4GUd
	 Dbj/G/3YHHiE6PT7LroYf/zkw2qY8gu9q6bx1JdAjg+IM9DXHAojzm5MDHh5DPqImd
	 P5LKQTAnzH8/TaNYAyVuKSimA3o0bOlQK5Pwo3u8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388587AbgEMKAh (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 13 May 2020 06:00:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:36214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388243AbgEMKAf (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 13 May 2020 06:00:35 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC23920575;
        Wed, 13 May 2020 10:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589364035;
        bh=x5e0Sj6los9/lOrTsvPvqfnkzghBR0Op1VeaRSfeu1o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l03gN39l4G5zcUWhFyd7LGFGWN3TVQXLeA79+1aDaPmndhmdLy5ZAfrVaoOB0akeJ
         k0pMk/BBpV3hJn+fmkSIft7omeGgq+6vLKjviGoibV6N4+AZHRGh6+3QyqfHxgJ2QL
         NNJaRbym3UKYp8nYp7mf2a1xfEZIojf0EAFreWUI=
Date:   Wed, 13 May 2020 13:00:31 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] RDMA/mlx5: Fix query_srq_cmd() function
Message-ID: <20200513100031.GT4814@unreal>
References: <20200513093741.GC347693@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513093741.GC347693@mwanda>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, May 13, 2020 at 12:37:41PM +0300, Dan Carpenter wrote:
> The "srq_out" pointer is never freed so that causes a memory leak.  It's
> never used and can be deleted.  Freeing "out" will lead to a double in
> mlx5_ib_query_srq().
>
> Fixes: 31578defe4eb ("RDMA/mlx5: Update mlx5_ib to use new cmd interface")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/infiniband/hw/mlx5/srq_cmd.c | 11 ++---------
>  1 file changed, 2 insertions(+), 9 deletions(-)
>

Thanks for the report, the change should be slightly different.

I'm sending fix right now.
