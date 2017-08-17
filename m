From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core] mlx5: Return pointer to CQ doorbell
Date: Thu, 17 Aug 2017 11:33:20 -0600
Message-ID: <20170817173320.GB22792@obsidianresearch.com>
References: <1502976998-20906-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1502976998-20906-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 17, 2017 at 04:36:38PM +0300, Yishai Hadas wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> The returned UAR pointer is actually void ** and points to whole
> UAR database.
> 
> Because user is not supposed to access it and expected to use
> the CQ doorbell, we will return uar[0] (CQ doorbell) directly
> and eliminate the following logic in the applications:
> 
> uint64_t cq_db_reg = (uint64_t *)(((uint64_t)(uint64_t *)rxq->cq_uar) +
>                      MLX5_CQ_DOORBELL;

NAK, at least, as is..

This changes the ABI and mlx5dv is a public interface now, so you have
to do it properly.

Looking at it, my advice is to rev the symbol version of
mlx5dv_init_obj and consider providing a compat symbol.

Also, you need to change the name of the 'uar' field:

> -	cq_out->uar	  = mctx->uar;
> +	cq_out->uar	  = mctx->uar[0];

To something else, to make it clear, which of the two ABIs the
application code is coded to - for a change like this, you *MUST*
force old apps to have a compile failure.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
