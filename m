Return-Path: <SRS0=gJYK=45=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C023C2BB1D
	for <linux-rdma@archiver.kernel.org>; Thu, 12 Mar 2020 09:26:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4372E206F1
	for <linux-rdma@archiver.kernel.org>; Thu, 12 Mar 2020 09:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584005204;
	bh=Wj63A9YwlumOEGHLBydb2h7ouZkcXbP/yKGfKsQ6pWc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=LQKPX9/WhavqR84qLLRCGb97a9mA9A38DGCKtRRWVTnPin7rhMLXQJeJHlEHooirF
	 FVhvGDjzpPFwvDFJPq6ZFDbs+CixLLdI7i5bykEsAah/0DzpTWAUvfC9JH3nvahOy4
	 wudNMah6d8LXYODsoRtu63TdFMUm3Rz2CBGhpIzw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbgCLJ0n (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 12 Mar 2020 05:26:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:47366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726438AbgCLJ0n (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 12 Mar 2020 05:26:43 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BD692067C;
        Thu, 12 Mar 2020 09:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584005203;
        bh=Wj63A9YwlumOEGHLBydb2h7ouZkcXbP/yKGfKsQ6pWc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0Gjk+V4+U5nWBUg4y6gXzPp50x7EsV7BBjbOOlAy9810MDU6bifPsGeiSE7edNWpr
         aXjWferT249rm6nEiAuCnVrvUY48mksL74Tc7I6fUyBiY3qRMf/X+8VX2TaKWWD/pv
         HZtpuETkPpr9tCUFpm7d+kITNF2qiwbQFmVXsKdA=
Date:   Thu, 12 Mar 2020 11:26:40 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Weihang Li <liweihang@huawei.com>
Cc:     dledford@redhat.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org,
        linuxarm@huawei.com
Subject: Re: [PATCH for-next] RDMA/hns: Add interface to support lock free
Message-ID: <20200312092640.GA31504@unreal>
References: <1583999290-20514-1-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1583999290-20514-1-git-send-email-liweihang@huawei.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, Mar 12, 2020 at 03:48:10PM +0800, Weihang Li wrote:
> From: Jiaran Zhang <zhangjiaran@huawei.com>
>
> In some scenarios, ULP can ensure that there is no concurrency when
> processing io, thus lock free can be used to improve performance.
>
> Signed-off-by: Jiaran Zhang <zhangjiaran@huawei.com>
> Signed-off-by: Yixian Liu <liuyixian@huawei.com>
> Signed-off-by: Weihang Li <liweihang@huawei.com>
> ---
>  drivers/infiniband/hw/hns/hns_roce_device.h |   1 +
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 112 ++++++++++++++++++++--------
>  drivers/infiniband/hw/hns/hns_roce_qp.c     |   1 +
>  3 files changed, 84 insertions(+), 30 deletions(-)
>

NAK, everything in this patch is wrong, starting from exposure,
implementation and description.

Thanks
