From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: Re: [PATCH] net/mlx5e/core/en_fs: fix pointer dereference after
 free in mlx5e_execute_l2_action
Date: Wed, 08 Nov 2017 11:00:00 +0900 (KST)
Message-ID: <20171108.110000.1557345961530017114.davem@davemloft.net>
References: <20171105035453.GA10908@embeddedor.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171105035453.GA10908-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: garsilva-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org
Cc: saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: "Gustavo A. R. Silva" <garsilva-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>
Date: Sat, 4 Nov 2017 22:54:53 -0500

> hn is being kfree'd in mlx5e_del_l2_from_hash and then dereferenced
> by accessing hn->ai.addr
> 
> Fix this by copying the MAC address into a local variable for its safe use
> in all possible execution paths within function mlx5e_execute_l2_action.
> 
> Addresses-Coverity-ID: 1417789
> Fixes: eeb66cdb6826 ("net/mlx5: Separate between E-Switch and MPFS")
> Signed-off-by: Gustavo A. R. Silva <garsilva-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>

Applied and queued up for -stable, thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
