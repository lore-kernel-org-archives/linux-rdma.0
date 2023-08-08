Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC021C001B0
	for <linux-rdma@archiver.kernel.org>; Tue,  8 Aug 2023 19:33:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236384AbjHHTdC (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 8 Aug 2023 15:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236385AbjHHTce (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 8 Aug 2023 15:32:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 705F9E5470;
        Tue,  8 Aug 2023 11:58:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35A3D62A8E;
        Tue,  8 Aug 2023 18:58:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0DA3C433C7;
        Tue,  8 Aug 2023 18:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691521102;
        bh=wso/iwkJg5uChEcf2iUgCpF5Uhzgtx4iLB7JGkBF1D8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WcK8DjG4C9hNmkSLmvCeHJ1Jw0Ca5oj8f66CfX1wPeYE7rA89YuqBDk957ZdbgdDr
         NTXIYvR+ltd3OniLdIGjelpsUWj0RJhEaevKiO+Z8PqDeDAFVXMrv9eab/RoR05PGM
         qiVZhiocjBd9/69wCnm4GqVo4Jz2Ntqxmwvw6U6ubSoQ2P4t1+bMes0kl2PnOjYSOi
         vZ/72Hz9pYso9p1kamSMEsB2nJRleyCAwKQvIfWsf6khzQcVTmlnkFOe24uyknOvRZ
         ycQW4Oa0BDVatvYxhMnslDhnzeqi+rB2UYh4nAQEHuGaV3+5MDl7AzVkHgd0C2k9kv
         Y3qisuig1r7MA==
Date:   Tue, 8 Aug 2023 21:58:16 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Petr Pavlu <petr.pavlu@suse.com>
Cc:     tariqt@nvidia.com, yishaih@nvidia.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        jgg@ziepe.ca, netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 09/10] mlx4: Connect the infiniband part to the
 auxiliary bus
Message-ID: <20230808185816.GN94631@unreal>
References: <20230804150527.6117-1-petr.pavlu@suse.com>
 <20230804150527.6117-10-petr.pavlu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230804150527.6117-10-petr.pavlu@suse.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, Aug 04, 2023 at 05:05:26PM +0200, Petr Pavlu wrote:
> Use the auxiliary bus to perform device management of the infiniband
> part of the mlx4 driver.
> 
> Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
> Tested-by: Leon Romanovsky <leon@kernel.org>
> ---
>  drivers/infiniband/hw/mlx4/main.c         | 77 ++++++++++++++++-------
>  drivers/net/ethernet/mellanox/mlx4/intf.c | 13 ++++
>  2 files changed, 67 insertions(+), 23 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
