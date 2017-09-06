From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 3/3] mlx5: Add support for sending IPoIB packets
Date: Wed, 6 Sep 2017 10:04:43 -0600
Message-ID: <20170906160443.GC6262@obsidianresearch.com>
References: <1504708729-15249-1-git-send-email-yishaih@mellanox.com>
 <1504708729-15249-4-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1504708729-15249-4-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 06, 2017 at 05:38:49PM +0300, Yishai Hadas wrote:

> +			if (unlikely(qp->flags & MLX5_QP_FLAGS_USE_UNDERLAY)) {
> +				err = mlx5_post_send_underlay(qp, wr, &seg, &size, &sg_copy_ptr);
> +				if (unlikely(err)) {
> +					*bad_wr = wr;
> +					goto out;
> +				}
> +			}

I don't know anything about your device, but this patch looks to me
like it enables for any IBV_QP_CREATE_SOURCE_QPN user - and it seems
to contain a lot of IPoIB specific commentary.

It is wrong to assume that all IBV_QP_CREATE_SOURCE_QPN QP's are IPoIB.

At a minimum some of the commentary needs revising..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
