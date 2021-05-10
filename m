Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3724CC433ED
	for <linux-rdma@archiver.kernel.org>; Mon, 10 May 2021 09:50:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BCB7613DC
	for <linux-rdma@archiver.kernel.org>; Mon, 10 May 2021 09:50:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhEJJvJ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 10 May 2021 05:51:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:35994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230145AbhEJJvI (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 10 May 2021 05:51:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAFD2610CC;
        Mon, 10 May 2021 09:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620640204;
        bh=O35ZTlUtVphqcug73jOmxoXi8a5ety8/4jM592CPqNY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mb0hGViyCIhLqyIkkFYPqL2HMBlc20PPeO/+YECyDdli+Ul9cg0RVqJ+qi5ItRLmk
         MTKsnX49xuK/ratjHUNP+A7BYx40WnovuzMkF7KTkUrdIAmKkarPqSoK7eAJ1i3Erh
         zN9qOu7suyYVxV2LPHOZgVrxg7TITCxZ1Q9EicsnzCsokmBZkAmVCarJelj4uVZVyB
         IklnAheGenJIvEDG2U+og3oY3Nf0sKSkLHxBl/B5SUOIQyw0GuL3wRG54bzJL6Ns2y
         XD+vs/lYxa25KzgFEm+uyh4ZC/CeS9CJigV4DL9HZbqnIRzNLN0mDSsf7cp/Z7Lbc1
         gN/0H6UQDvxdg==
Date:   Mon, 10 May 2021 12:50:00 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        linux-rdma <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH 1/1] RDMA/cm: Delete two redundant condition branches
Message-ID: <YJkByCnQGcLOIlCz@unreal>
References: <20210510090840.3474-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210510090840.3474-1-thunder.leizhen@huawei.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, May 10, 2021 at 05:08:40PM +0800, Zhen Lei wrote:
> The statement of the last "if (xxx)" branch is the same as the "else"
> branch. Delete it to simplify code.
> 
> No functional change.
> 
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> ---
>  drivers/infiniband/core/cm.c | 4 ----
>  1 file changed, 4 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
