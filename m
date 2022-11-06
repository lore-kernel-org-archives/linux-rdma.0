Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB69EC433FE
	for <linux-rdma@archiver.kernel.org>; Sun,  6 Nov 2022 18:12:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbiKFSMX (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 6 Nov 2022 13:12:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbiKFSMW (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sun, 6 Nov 2022 13:12:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADAE5BC97;
        Sun,  6 Nov 2022 10:12:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45278B8013C;
        Sun,  6 Nov 2022 18:12:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A038C433C1;
        Sun,  6 Nov 2022 18:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667758338;
        bh=aeHQGGH8K9RD+oyiW65D8T6LjNNcjqBx1LiVToEJi1o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tuDFbPSKJWW+kySNWBdsgwJ2BrxsI39qnfRLW1Ehk/n1vNeTSyVSnfAHeizidsFu/
         QNn4KnMw5dFHLBChb8Awab2PT2i3yZeObkAyj4kXlpa5Cw1O4s1JPtxHZRGpmwQYcQ
         oZq+swURCoTODHVX2hbCZq+YoIzDSfPfzYOYeiPTHGTGhOozoLESSdrzjAVP9SRhSx
         2TwW3qnZaqQSNyp/J+2kqS1CO8Haw+/8BXRxo/ixMgbYDvc8JpKIk0iWqMK8qWsiPR
         twW/EkAObgWY/ORHHFPjhLBAXRuZ9dpzdFV9rrZ4M8vBHioNTSkx1EBtflZl5IyHuJ
         OIbs16aCWj/8w==
Date:   Sun, 6 Nov 2022 20:12:14 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mlx5: Fix spelling mistake "destoy" -> "destroy"
Message-ID: <Y2f4/ihY0cfmzSiG@unreal>
References: <20221031080104.773325-1-colin.i.king@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221031080104.773325-1-colin.i.king@gmail.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Oct 31, 2022 at 08:01:04AM +0000, Colin Ian King wrote:
> There is a spelling mistake in an error message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>

BTW,
➜  kernel git:(net-next) git grep "destoy"
drivers/cpufreq/pasemi-cpufreq.c: * module init and destoy
drivers/cpufreq/ppc_cbe_cpufreq.c: * module init and destoy
drivers/hid/hid-logitech-hidpp.c:                       /* autocenter spring destoyed */
drivers/hwtracing/coresight/coresight-tmc-etr.c:         * events are simply not used an freed as events are destoyed.  We still
drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c:            mlx5dr_err(tbl->dmn, "Failed to destoy sw owned table\n");
include/net/caif/cfpkt.h: * pkt Packet to be destoyed.
net/netfilter/nf_nat_core.c:     * Else, when the conntrack is destoyed, nf_nat_cleanup_conntrack()

