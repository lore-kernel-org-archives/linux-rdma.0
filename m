Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C354C433FE
	for <linux-rdma@archiver.kernel.org>; Wed, 30 Nov 2022 08:40:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235565AbiK3Ikk (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 30 Nov 2022 03:40:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234971AbiK3Ikj (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 30 Nov 2022 03:40:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B82925EAA;
        Wed, 30 Nov 2022 00:40:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFC6561A4E;
        Wed, 30 Nov 2022 08:40:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF832C433D6;
        Wed, 30 Nov 2022 08:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669797636;
        bh=V6atpVmtD2+6SpFdhfJwyvgDDGI7ODv3L9MkOhyqncw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bzmKq7vMq49GVerZyhi69JB041INbp0zLYgp+44d/4OvSHvz80dWMoAWr5bjviAH6
         w5eE5IuRmS8bduw3cflnXnKt1X5NRhXTroTw9I6JXFZ/Ay3dx3C8haZ4odIU3OsjZz
         iU+SvEGK//WAvmse7bIQLh94NevE6ZGKQuWTfxeIZHcZ2Q3fH5UGNWHl1h5Mw1XOp1
         jMB0Ld4Ta2ReGNp8ZXvzUnOFy0+YZbHkjzZD3nJhwsFKas3B5HhVktMYGHtZ32rhkm
         uYFHTjvTTaDxzqV2rMkybL2wVBX5YpyhiGgPhpZx48CnCEsYt2nOQks34PK/XLCunn
         VucI0jKzM+gmQ==
Date:   Wed, 30 Nov 2022 10:40:32 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     cgel.zte@gmail.com
Cc:     dennis.dalessandro@cornelisnetworks.com, jgg@ziepe.ca,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Yang <yang.yang29@zte.com.cn>
Subject: Re: [PATCH] IB/hfi1: switch to netif_napi_add()
Message-ID: <Y4cXAIzTsUVYvfg4@unreal>
References: <20221129102500.616923-1-yang.yang29@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129102500.616923-1-yang.yang29@zte.com.cn>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, Nov 29, 2022 at 10:25:01AM +0000, cgel.zte@gmail.com wrote:
> From: Yang Yang <yang.yang29@zte.com.cn>
> 
> There is no need to use netif_napi_add_weight() when the weight argument
> is 64. See "net: drop the weight argument from netif_napi_add".
> 
> Signed-off-by: Yang Yang <yang.yang29@zte.com.cn>
> ---
>  drivers/infiniband/hw/hfi1/netdev_rx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Please send this patch as plain-text with git send-email.
It wasn't recorded in https://lore.kernel.org/linux-rdma/

Thanks

> 
> diff --git a/drivers/infiniband/hw/hfi1/netdev_rx.c b/drivers/infiniband/hw/hfi1/netdev_rx.c
> index 3dfa5aff2512..720d4c85c9c9 100644
> --- a/drivers/infiniband/hw/hfi1/netdev_rx.c
> +++ b/drivers/infiniband/hw/hfi1/netdev_rx.c
> @@ -216,7 +216,7 @@ static int hfi1_netdev_rxq_init(struct hfi1_netdev_rx *rx)
>  		 * right now.
>  		 */
>  		set_bit(NAPI_STATE_NO_BUSY_POLL, &rxq->napi.state);
> -		netif_napi_add_weight(dev, &rxq->napi, hfi1_netdev_rx_napi, 64);
> +		netif_napi_add(dev, &rxq->napi, hfi1_netdev_rx_napi);
>  		rc = msix_netdev_request_rcd_irq(rxq->rcd);
>  		if (rc)
>  			goto bail_context_irq_failure;
> -- 
> 2.25.1
> 
