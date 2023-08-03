Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EAA4C04A6A
	for <linux-rdma@archiver.kernel.org>; Thu,  3 Aug 2023 13:21:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235057AbjHCNVC (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 3 Aug 2023 09:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234740AbjHCNVB (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 3 Aug 2023 09:21:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ABC3EE
        for <linux-rdma@vger.kernel.org>; Thu,  3 Aug 2023 06:21:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD98B61D85
        for <linux-rdma@vger.kernel.org>; Thu,  3 Aug 2023 13:20:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B56FC433C8;
        Thu,  3 Aug 2023 13:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691068859;
        bh=x2/Zq9o6dLg9X74csTMPPMs7aiPYYlz2kT0Afe7Zbrs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Tmc+3SrmPSHBODRkYoKjilOJtCnLhAWCWLbhEGrzGfDMbpQzCtx2Pv7loyUtjOyTV
         I5JIxXO/0iyY3NYGp9sSbT2oqlR9WrbPhQgukKPGL13nrx3Hll4kXEHIYQjHph7YgW
         xEOCk/ZoF9Ic4G6gVcsZJdEuGzH692CIACmYaJzTSDYBfYSjODF8WBkDpd3Kjtp1Rh
         9LBFScEcIXqgMWsL5jqaootxW9ufh9AcCke9HoNXXY1dkJWKfsb/SFsbWBNcxxJxcU
         FAY8SBpUbXlNKdooOKmOjcSjaKXdvgtFkkkZCMEXCHkWpt9LeR5qExn1q6mEZVyUy2
         1aZ+M14s0v2hQ==
Date:   Thu, 3 Aug 2023 16:20:54 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Ruan Jinjie <ruanjinjie@huawei.com>
Cc:     tariqt@nvidia.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] net/mlx4: Remove many unnecessary NULL values
Message-ID: <20230803132054.GE53714@unreal>
References: <20230802040026.2588675-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230802040026.2588675-1-ruanjinjie@huawei.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, Aug 02, 2023 at 12:00:26PM +0800, Ruan Jinjie wrote:
> The NULL initialization of the pointers assigned by kzalloc() first is
> not necessary, because if the kzalloc() failed, the pointers will be
> assigned NULL, otherwise it works as usual. so remove it.
> 
> Signed-off-by: Ruan Jinjie <ruanjinjie@huawei.com>
> ---
> v2:
> - add the wrong removed NULL hunk code in mlx4_init_hca().
> - update the commit message.
> ---
>  drivers/net/ethernet/mellanox/mlx4/en_ethtool.c | 10 +++++-----
>  drivers/net/ethernet/mellanox/mlx4/en_netdev.c  |  4 ++--
>  drivers/net/ethernet/mellanox/mlx4/main.c       |  8 ++++----
>  3 files changed, 11 insertions(+), 11 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
