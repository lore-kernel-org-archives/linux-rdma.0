Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46049C4167B
	for <linux-rdma@archiver.kernel.org>; Sat, 12 Dec 2020 05:26:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16F6123137
	for <linux-rdma@archiver.kernel.org>; Sat, 12 Dec 2020 05:26:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438320AbgLLF0H (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 12 Dec 2020 00:26:07 -0500
Received: from smtprelay0029.hostedemail.com ([216.40.44.29]:35790 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2437153AbgLLFZy (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>);
        Sat, 12 Dec 2020 00:25:54 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 641EF1803A836;
        Sat, 12 Dec 2020 05:25:03 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: linen76_000822627407
X-Filterd-Recvd-Size: 1608
Received: from XPS-9350.home (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf07.hostedemail.com (Postfix) with ESMTPA;
        Sat, 12 Dec 2020 05:25:02 +0000 (UTC)
Message-ID: <a81975ecafefb7aebd087a97780424d5bb9ba280.camel@perches.com>
Subject: Re: [PATCH] net/mlx4: Use true,false for bool variable
From:   Joe Perches <joe@perches.com>
To:     Vasyl Gomonovych <gomonovych@gmail.com>, tariqt@nvidia.com
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Fri, 11 Dec 2020 21:25:01 -0800
In-Reply-To: <20201211100518.29804-1-gomonovych@gmail.com>
References: <20201211100518.29804-1-gomonovych@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, 2020-12-11 at 11:05 +0100, Vasyl Gomonovych wrote:
> Fix en_rx.c:687:1-17: WARNING: Assignment of 0/1 to bool variable
> Fix main.c:4465:5-13: WARNING: Comparison of 0/1 to bool variable
[]
> diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
[]
> @@ -4462,7 +4462,7 @@ static int __init mlx4_verify_params(void)
>  		pr_warn("mlx4_core: log_num_vlan - obsolete module param, using %d\n",
>  			MLX4_LOG_NUM_VLANS);
>  
> 
> -	if (use_prio != 0)
> +	if (use_prio != false)
>  		pr_warn("mlx4_core: use_prio - obsolete module param, ignored\n");

Generally, assuming use_prio is bool, this would be written

	if (use_prio)
		pr_warn("etc...")


