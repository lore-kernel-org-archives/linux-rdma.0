Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4AF4C433E6
	for <linux-rdma@archiver.kernel.org>; Tue, 29 Dec 2020 16:18:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89F2F20825
	for <linux-rdma@archiver.kernel.org>; Tue, 29 Dec 2020 16:18:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgL2QSn (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 29 Dec 2020 11:18:43 -0500
Received: from smtprelay0191.hostedemail.com ([216.40.44.191]:38860 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726240AbgL2QSn (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 29 Dec 2020 11:18:43 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id AC7E21802926E;
        Tue, 29 Dec 2020 16:18:01 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: sack33_6103b212749d
X-Filterd-Recvd-Size: 1550
Received: from [192.168.1.159] (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf09.hostedemail.com (Postfix) with ESMTPA;
        Tue, 29 Dec 2020 16:18:00 +0000 (UTC)
Message-ID: <dda4079bc35fa6e0846a94e9c2b91b0c3a224c52.camel@perches.com>
Subject: Re: [PATCH net-next] net/mlx5: Use kzalloc for allocating only one
 thing
From:   Joe Perches <joe@perches.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     saeedm@nvidia.com, leon@kernel.org
Date:   Tue, 29 Dec 2020 08:17:58 -0800
In-Reply-To: <20201229135318.24195-1-zhengyongjun3@huawei.com>
References: <20201229135318.24195-1-zhengyongjun3@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, 2020-12-29 at 21:53 +0800, Zheng Yongjun wrote:
> Use kzalloc rather than kcalloc(1,...)
[]
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
[]
> @@ -1782,7 +1782,7 @@ static int dr_action_create_modify_action(struct mlx5dr_domain *dmn,
>  	if (!chunk)
>  		return -ENOMEM;
>  
> 
> -	hw_actions = kcalloc(1, max_hw_actions * DR_MODIFY_ACTION_SIZE, GFP_KERNEL);
> +	hw_actions = kzalloc(max_hw_actions * DR_MODIFY_ACTION_SIZE, GFP_KERNEL);

Perhaps instead:

	hw_actions = kcalloc(max_hw_actions, DR_MODIFY_ACTION_SIZE, GFP_KERNEL);


