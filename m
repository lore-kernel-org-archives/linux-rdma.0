Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 215ECC0502C
	for <linux-rdma@archiver.kernel.org>; Sun, 28 Aug 2022 10:04:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiH1KEr (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 28 Aug 2022 06:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiH1KEr (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sun, 28 Aug 2022 06:04:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10497BBF
        for <linux-rdma@vger.kernel.org>; Sun, 28 Aug 2022 03:04:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFDDFB80A53
        for <linux-rdma@vger.kernel.org>; Sun, 28 Aug 2022 10:04:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0302AC433D6;
        Sun, 28 Aug 2022 10:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661681083;
        bh=F9wLnUP/9wizZVEsaFaFzVFWG/CR/fflnLwLBnZkYhg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FR0sDiOEmIAMnZ37vRi/84JXc/VKaJSEZc4Q7+AXqGHucS4sqog6JzjMBiR0rjb6J
         oV44u6M/o2v4pPdfPQ84Uy8jnBXHkVUk3tMDgK1C4qI1wC4p2crqYowpliy0XmA/bQ
         wIZJROc2jAaPGHbNlMhhbqltiYV20Bg9ypBhDrQQFz9LF3QQRdm6UAV6//lC+Xl2tz
         2ZGBHiSqKf5isS+QOhv48rkjNiDzVS9zpFHi6dg5z4bityg35LUuOkw6/jDx/RhW9h
         V8cTy6nHRkX3DsWqxBVuMbPnEQ0BgC96fZfbOEiMcMLBQU9rfYCG/8H3Guuc/ml5o1
         WrZX5G1bVK0Ow==
Date:   Sun, 28 Aug 2022 13:04:39 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org
Subject: Re: [PATCH 0/4] RDMA/srp: Handle dev_set_name() failure
Message-ID: <Yws9t6Xj/08izIdR@unreal>
References: <20220825213900.864587-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220825213900.864587-1-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, Aug 25, 2022 at 02:38:56PM -0700, Bart Van Assche wrote:
> Hi Jason,
> 
> This patch series includes one patch that handles dev_set_name() failure and
> three refactoring patches. Please consider these patches for the next merge
> window.

You confuse me. "next merge window" means that patches are targeted to
-next, but you added stable@... tag and didn't add any Fixes lines.

I applied everything to rdma-next and removed stable@ tag.

Thanks

> 
> Thanks,
> 
> Bart.
> 
> Bart Van Assche (4):
>   RDMA/srp: Rework the srp_add_port() error path
>   RDMA/srp: Remove the srp_host.released completion
>   RDMA/srp: Handle dev_set_name() failure
>   RDMA/srp: Use the attribute group mechanism for sysfs attributes
> 
>  drivers/infiniband/ulp/srp/ib_srp.c | 50 +++++++++++++++--------------
>  drivers/infiniband/ulp/srp/ib_srp.h |  1 -
>  2 files changed, 26 insertions(+), 25 deletions(-)
> 
