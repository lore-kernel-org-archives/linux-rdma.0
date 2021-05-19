Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42AE5C433ED
	for <linux-rdma@archiver.kernel.org>; Wed, 19 May 2021 10:55:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20D77613AA
	for <linux-rdma@archiver.kernel.org>; Wed, 19 May 2021 10:55:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232178AbhESK4s (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 19 May 2021 06:56:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:45074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229720AbhESK4s (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 19 May 2021 06:56:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88F826135B;
        Wed, 19 May 2021 10:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621421728;
        bh=GvCNZaIW+58RzC+ig1lfUIYbof8tdbg1xu2S3vHyLR8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SF/jmoorf5GxNFeV9U3yrXfIo6AjkQasilha6BqGDuE7vBracjdj/scUgD29zX4f+
         O9KdV+YWqHnbI7iWSrlFg01FinfpDl/4qGZaoQ0C6mMLEattPbaBd9sRa7lesNujaU
         H9wpiu6C7OPLvg8tUXS56ErVb0jXT5JcfPnWNu0iNZqQK5z86DENS/PIE5OZKNwPT1
         aZxUKuLP2GIHhx7QQcnKgKP3C2QhkdtQbKGU49Wwzusc4qGD4FnpnKG+RGwr3uz/R2
         V+Glpae0y1YxagMkYaewZYYS/IEo+uCRW/Ew8HxQZ+hA/GP1bO4t2bZ1sOBHmir1qO
         zFQrvji78ovxw==
Date:   Wed, 19 May 2021 13:55:24 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Weihang Li <liweihang@huawei.com>
Cc:     dledford@redhat.com, jgg@nvidia.com, linux-rdma@vger.kernel.org,
        linuxarm@huawei.com, Lang Cheng <chenglang@huawei.com>
Subject: Re: [PATCH for-next 3/3] RDMA/hns: Remove unused CMDQ member
Message-ID: <YKTunCfyJBczrQAK@unreal>
References: <1620904578-29829-1-git-send-email-liweihang@huawei.com>
 <1620904578-29829-4-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1620904578-29829-4-git-send-email-liweihang@huawei.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, May 13, 2021 at 07:16:18PM +0800, Weihang Li wrote:
> From: Lang Cheng <chenglang@huawei.com>
> 
> The hcr_mutex was used to serialize mailbox post. Now that mailbox supports
> concurrency, this variable is no longer useful.
> 
> Fixes: a389d016c030 ("RDMA/hns: Enable all CMDQ context")
> Signed-off-by: Lang Cheng <chenglang@huawei.com>
> Signed-off-by: Weihang Li <liweihang@huawei.com>
> ---
>  drivers/infiniband/hw/hns/hns_roce_device.h | 1 -
>  1 file changed, 1 deletion(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
