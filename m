Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 176EEC5519F
	for <linux-rdma@archiver.kernel.org>; Wed, 25 Nov 2020 06:32:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC479206F7
	for <linux-rdma@archiver.kernel.org>; Wed, 25 Nov 2020 06:31:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbgKYGbi (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 25 Nov 2020 01:31:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:41652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725562AbgKYGbi (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 25 Nov 2020 01:31:38 -0500
Received: from localhost (searspoint.nvidia.com [216.228.112.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D8E1206F7;
        Wed, 25 Nov 2020 06:31:37 +0000 (UTC)
Date:   Wed, 25 Nov 2020 08:15:37 +0200
From:   Leon Romanovsky <leonro@mellanox.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     linux-rdma@vger.kernel.org, Yishai Hadas <yishaih@mellanox.com>
Subject: Re: [PATCH] RDMA/mlx5: Check for ERR_PTR from uverbs_zalloc()
Message-ID: <20201125061537.GA3223@unreal>
References: <0-v1-4d05ccc1c223+173-devx_err_ptr_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-4d05ccc1c223+173-devx_err_ptr_jgg@nvidia.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, Nov 24, 2020 at 07:34:33PM -0400, Jason Gunthorpe wrote:
> The return code from uverbs_zalloc() was wrongly checked, it is ERR_PTR
> not NULL like other allocators:
>
> drivers/infiniband/hw/mlx5/devx.c:2110 devx_umem_reg_cmd_alloc() warn: passing zero to 'PTR_ERR'
>
> Fixes: 878f7b31c3a7 ("RDMA/mlx5: Use ib_umem_find_best_pgsz() for devx")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/infiniband/hw/mlx5/devx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Thanks,
Acked-by: Leon Romanovsky <leonro@nvidia.com>
