Return-Path: <SRS0=lM3/=BN=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B510C433DF
	for <linux-rdma@archiver.kernel.org>; Mon,  3 Aug 2020 15:41:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CF1B2076C
	for <linux-rdma@archiver.kernel.org>; Mon,  3 Aug 2020 15:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596469314;
	bh=83m/6Pn2PKOY/u2G126YKwxAO9hcGZRm5Ac0HGFyZTg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=h8UZFhIxAZZ/VDgxIrx0g9pC0CtKpx+cUR2uBSxhnfAotqcXfs0itlo9H7PX8bnYl
	 NptU3IT1oTm/j6xUSog/iiD1MtKmMtbNhouGiB5NZR0qXMHX7exsurOdMnuo38NQ2L
	 hYxFspQ3u9SmfZmKILJ73zmlokYbsEGPZTfaPQE4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgHCPly (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 3 Aug 2020 11:41:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:38438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726478AbgHCPly (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 3 Aug 2020 11:41:54 -0400
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4531A20678;
        Mon,  3 Aug 2020 15:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596469313;
        bh=83m/6Pn2PKOY/u2G126YKwxAO9hcGZRm5Ac0HGFyZTg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GfjoezEIX/M3g6bg8kG5fP+s2UlQ1Fe2HQveVcZO6oRWqgFNsu7MUncqfC3A6KC8P
         rND8SZ6dM//AvrkkcIcnOWONx/Vcxjrp0DSvd+q3UN2krO3Kpj1nLefgZVkRgqzmeF
         Bc6UoPqV72aVREeikd1QjwJD/8+lskT8mz9cGu0s=
Date:   Mon, 3 Aug 2020 10:48:01 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net/mlx5: remove erroneous fallthrough
Message-ID: <20200803154801.GC1726@embeddedor>
References: <20200803143448.GA346925@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200803143448.GA346925@mwanda>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Aug 03, 2020 at 05:34:48PM +0300, Dan Carpenter wrote:
> This isn't a fall through because it was after a return statement.  The
> fall through annotation leads to a Smatch warning:
> 
>     drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c:246
>     mlx5e_ethtool_get_sset_count() warn: ignoring unreachable code.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks
--
Gustavo

> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> index 08270987c506..48397a577fcd 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> @@ -243,7 +243,6 @@ int mlx5e_ethtool_get_sset_count(struct mlx5e_priv *priv, int sset)
>  		return MLX5E_NUM_PFLAGS;
>  	case ETH_SS_TEST:
>  		return mlx5e_self_test_num(priv);
> -		fallthrough;
>  	default:
>  		return -EOPNOTSUPP;
>  	}
> -- 
> 2.27.0
> 
