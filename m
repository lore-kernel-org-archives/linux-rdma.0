Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67FA9C07E9A
	for <linux-rdma@archiver.kernel.org>; Wed, 14 Jul 2021 09:15:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C33861370
	for <linux-rdma@archiver.kernel.org>; Wed, 14 Jul 2021 09:15:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238147AbhGNJRy (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 14 Jul 2021 05:17:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:48162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238647AbhGNJRx (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 14 Jul 2021 05:17:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FC8961369;
        Wed, 14 Jul 2021 09:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626254102;
        bh=yA6BI8oJjYrNrQ7CFZtz8jy476hE4euezlpCYdt1+fM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C1yyx22oADKVV3UHknoSEAU95BzEedKZTIMZrWuDaKvBB0Fj2AT9uDax7sIsXjE2l
         GTZ+eULQPrNByhxCX6HT/+V0k7ddMz3wQk6WybiHv6u6jt11Y6ONS26prGZkkaETd8
         /6c6BRfWGrMUKwPfBNeGhdJJuZdrQJO7tUEmwnzvwyWtrZnOw2fzj+g49EyeG3Uith
         26/AOHx8uSeDkKvaNUZ64ARiry4BLKRcAZ7KaAUzIgqk0NGcgO3ujnupjUVMcrWSOp
         aUojbv3LZj+9FacvcWdetHHRzTgDkAgdXVaoZKexyae8yZG8Gg5KIBahGT5BbWV0zS
         zetkHXI/0jonw==
Date:   Wed, 14 Jul 2021 12:14:58 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     shiraz.saleem@intel.com
Cc:     zyjzyj2000@gmail.com, yanjun.zhu@intel.com,
        mustafa.ismail@intel.com, dledford@redhat.com, jgg@ziepe.ca,
        linux-rdma@vger.kernel.org, yanjun.zhu@linux.dev,
        Jakub Kicinski <kuba@kernel.org>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/3] RDMA/irdma: change the returned type of
 irdma_sc_repost_aeq_entries to void
Message-ID: <YO6rEkoHgsYh+w37@unreal>
References: <20210714031130.1511109-1-yanjun.zhu@linux.dev>
 <20210714031130.1511109-2-yanjun.zhu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714031130.1511109-2-yanjun.zhu@linux.dev>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, Jul 13, 2021 at 11:11:28PM -0400, yanjun.zhu@linux.dev wrote:
> From: Zhu Yanjun <yanjun.zhu@linux.dev>
> 
> The function irdma_sc_repost_aeq_entries always returns zero. So
> the returned type is changed to void.
> 
> Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
> ---
>  drivers/infiniband/hw/irdma/ctrl.c | 4 +---
>  drivers/infiniband/hw/irdma/type.h | 3 +--
>  2 files changed, 2 insertions(+), 5 deletions(-)

<...>

> -enum irdma_status_code irdma_sc_repost_aeq_entries(struct irdma_sc_dev *dev,
> -						   u32 count);

I clearly remember that Jakub asked for more than once to remo remove
custom ice/irdma error codes. Did it happen? Can we get rid from them
in RDMA too?

Thanks
