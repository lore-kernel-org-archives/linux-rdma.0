Return-Path: <SRS0=CiuV=2K=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31912C43603
	for <linux-rdma@archiver.kernel.org>; Fri, 20 Dec 2019 02:25:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2F7E2068F
	for <linux-rdma@archiver.kernel.org>; Fri, 20 Dec 2019 02:25:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfLTCZC (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 19 Dec 2019 21:25:02 -0500
Received: from smtprelay0207.hostedemail.com ([216.40.44.207]:50293 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726964AbfLTCZC (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 19 Dec 2019 21:25:02 -0500
X-Greylist: delayed 1043 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Dec 2019 21:25:01 EST
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave01.hostedemail.com (Postfix) with ESMTP id 1E6A718016BD0
        for <linux-rdma@vger.kernel.org>; Fri, 20 Dec 2019 02:07:39 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 94152837F24D;
        Fri, 20 Dec 2019 02:07:37 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: bag50_5f8a9fc957d61
X-Filterd-Recvd-Size: 1672
Received: from XPS-9350.home (unknown [47.151.135.224])
        (Authenticated sender: joe@perches.com)
        by omf09.hostedemail.com (Postfix) with ESMTPA;
        Fri, 20 Dec 2019 02:07:36 +0000 (UTC)
Message-ID: <ff6dc8997083c5d8968df48cc191e5b9e8797618.camel@perches.com>
Subject: Re: [PATCH] net/mlx5e: Fix printk format warning
From:   Joe Perches <joe@perches.com>
To:     Olof Johansson <olof@lixom.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 19 Dec 2019 18:06:57 -0800
In-Reply-To: <20191220001517.105297-1-olof@lixom.net>
References: <20191220001517.105297-1-olof@lixom.net>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, 2019-12-19 at 16:15 -0800, Olof Johansson wrote:
> Use "%zu" for size_t. Seen on ARM allmodconfig:
[]
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/wq.c b/drivers/net/ethernet/mellanox/mlx5/core/wq.c
[]
> @@ -89,7 +89,7 @@ void mlx5_wq_cyc_wqe_dump(struct mlx5_wq_cyc *wq, u16 ix, u8 nstrides)
>  	len = nstrides << wq->fbc.log_stride;
>  	wqe = mlx5_wq_cyc_get_wqe(wq, ix);
>  
> -	pr_info("WQE DUMP: WQ size %d WQ cur size %d, WQE index 0x%x, len: %ld\n",
> +	pr_info("WQE DUMP: WQ size %d WQ cur size %d, WQE index 0x%x, len: %zu\n",
>  		mlx5_wq_cyc_get_size(wq), wq->cur_sz, ix, len);
>  	print_hex_dump(KERN_WARNING, "", DUMP_PREFIX_OFFSET, 16, 1, wqe, len, false);
>  }

One might expect these 2 outputs to be at the same KERN_<LEVEL> too.
One is KERN_INFO the other KERN_WARNING


