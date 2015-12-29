From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH V2] IB/mlx5: Unify CQ create flags check
Date: Tue, 29 Dec 2015 16:03:41 +0200
Message-ID: <20151229140341.GE17694@leon.nu>
References: <1451388884-11673-1-git-send-email-leon@leon.nu>
 <56828FF3.7010904@dev.mellanox.co.il>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56828FF3.7010904-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 29, 2015 at 03:51:47PM +0200, Sagi Grimberg wrote:
> >From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> >The create_cq() can receive creation flags which were used
> >differently by two following commits [1] and [2]. The current
> >code caused to not accept any flags at all.
> 
> We can skip referencing the linux-rdma mailing list.
> 
> >
> >This patch unifies the check into one function and one return
> >error code.
> >
> >Fixes: 972ecb821379 ("IB/mlx5: Add create_cq extended command")
> >Fixes: 051f263098a9 ("IB/mlx5: Add driver cross-channel support")
> >
> >[1] http://www.spinics.net/lists/linux-rdma/msg31430.html
> >[2] http://www.spinics.net/lists/linux-rdma/msg31658.html
> >
> >Changes from v0:
> >   * Add Fixes tag
> 
> Umm, the above ([1], [2], Changes) usually go under the "---"
> separator so we won't see them in git log forever.

Doug,
Do you want me resend the patch?

> 
> >
> >Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >---
> >  drivers/infiniband/hw/mlx5/cq.c      | 9 +--------
> >  drivers/infiniband/hw/mlx5/mlx5_ib.h | 3 ++-
> >  2 files changed, 3 insertions(+), 9 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
