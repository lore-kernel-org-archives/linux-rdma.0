Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C83B6C433FE
	for <linux-rdma@archiver.kernel.org>; Mon, 28 Nov 2022 09:50:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiK1Juv (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 28 Nov 2022 04:50:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbiK1Juo (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 28 Nov 2022 04:50:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C27F193D4;
        Mon, 28 Nov 2022 01:50:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 920A36103F;
        Mon, 28 Nov 2022 09:50:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79253C433D6;
        Mon, 28 Nov 2022 09:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669629043;
        bh=McOiQh02HDb8i7KkG9Ud2wisjbbZoHR/rp2t+eUVynU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bQo1kOICYyPdXGDjuwVkT6nksMt+ENmxk+f56vg0YgFqDfzeoW2N5NDZMcCYQ/mEl
         8NyyOOiDv/6A8+5dsSmGgdNA6pAzRIYijbMUY2tPg2+UnKQVL1OAOkPPqYFZTYloQR
         eF6j5vQDvjYsyPPx2W+lcfSSUH2A7CuyxUI6XoHCm98Bbd67RS+tNJFKBeEJyoYliK
         TczbY11IefCYy2Rhky16RjzdEKi58Rr9tvQhSUemejvuSJmz8wDa6T2An/w4BfewcB
         F51Bdz3VLu6RYjlstBJjOIIUGAjSfIsMT5AhNW2HKdTexHDJ5riMHXFOLeneosPzUU
         4JUOfln8f7fJg==
Date:   Mon, 28 Nov 2022 11:50:38 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     zhang.songyi@zte.com.cn
Cc:     yishaih@nvidia.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH linux-next] RDMA/mlx4: NULL check before dev_{put, hold}
 functions is not? needed
Message-ID: <Y4SEbmmZVdkKarWT@unreal>
References: <202211231708254077305@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202211231708254077305@zte.com.cn>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, Nov 23, 2022 at 05:08:25PM +0800, zhang.songyi@zte.com.cn wrote:
> From: zhang songyi <zhang.songyi@zte.com.cn>
> 
> The call netdev_{put, hold} of dev_{put, hold} will check NULL,
> so there is no need to check before using dev_{put, hold}.
> 
> Fix the following coccicheck warnings:
> /drivers/infiniband/hw/mlx4/main.c:1311:2-10: WARNING:
> WARNING  NULL check before dev_{put, hold} functions is not needed.
> 
> /drivers/infiniband/hw/mlx4/main.c:148:2-10: WARNING:
> WARNING  NULL check before dev_{put, hold} functions is not needed.
> 
> /drivers/infiniband/hw/mlx4/main.c:1959:3-11: WARNING:
> WARNING  NULL check before dev_{put, hold} functions is not needed.
> 
> /drivers/infiniband/hw/mlx4/main.c:1962:3-10: WARNING:
> WARNING  NULL check before dev_{put, hold} functions is not needed.
> 
> Signed-off-by: zhang songyi <zhang.songyi@zte.com.cn>
> ---
>  drivers/infiniband/hw/mlx4/main.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)

This patch doesn't apply to rdma-next tree.
Please fix commit title "not?" -> "not" and resubmit.

Thanks
