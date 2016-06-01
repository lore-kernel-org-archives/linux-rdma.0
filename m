From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH libmlx5 5/7] Add support for creating an extended CQ
Date: Wed, 1 Jun 2016 12:58:56 -0600
Message-ID: <20160601185856.GB3471@obsidianresearch.com>
References: <1464788882-1876-1-git-send-email-yishaih@mellanox.com>
 <1464788882-1876-6-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1464788882-1876-6-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 01, 2016 at 04:48:00PM +0300, Yishai Hadas wrote:
> From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> This patch adds the support for creating an extended CQ.
> This means we support:
> - The new polling mechanism.
> - A CQ which is single threaded and by thus doesn't waste CPU cycles on locking.
> - Getting completion timestamp from the CQ.

I'm still very much of the opinion that extended CQs should only allow
compatible QP's to be added.

> +	if (mctx->cqe_version) {
> +		if (cq->flags & MLX5_CQ_FLAGS_SINGLE_THREADED) {
> +			if (cq->stall_enable) {
> +				if (cq->stall_adaptive_enable) {
> +					cq->ibv_cq.start_poll =
> +						mlx5_start_poll_adaptive_stall_enable_v1;
> +					cq->ibv_cq.end_poll =
> +
> mlx5_end_poll_adaptive_stall_enable;

[..]

I feel like this sort of thing is going to show up in every driver :|

Maybe use a more tidy scheme:

#define SINGLE_THREADED BIT(0)
#define STALL BIT(1)
#define V1 BIT(2)
#define ADAPTIVE BIT(3)
static const struct ops[] =
{
[V1 | SINGLE_THREADED | STALL] = {
  .start_poll = &mlx5_start_poll_nonadaptive_stall_enable_v1 ,
  .end_poll = &mlx5_end_poll_nonadaptive_stall_enable,
  .next_poll = &mlx5_next_poll_v0,
  },
[..]
}

const struct op *poll_ops = &ps[
           (cq->stall_adaptive_enable?ADAPTIVE:0) |
           (mctx->cqe_version?V1:0) |
           (cq->flags & MLX5_CQ_FLAGS_SINGLE_THREADED?SINGLE_THREADED:0) |
	   (cq->stall_enable?STALL:0)];

BTW, you may want to use C++ for some of this function replication
stuff.

C++ function templates allow the construction of perfect code like
always_inline does, but more directly and without so much hassle to
trigger the always_inline behaviour.

The idiom looks like this:

template <bool SINGLE_THREADED,bool STALL,bool ADAPTIVE>
static void mlx_start_poll(...)
{
   if (!SINGLE_THREADED)
     lock(..)
}

.start_poll = &mlx_start_poll<false,false,false>
.start_poll = &mlx_start_poll<true,false,false>

The compiler will create a unique mlx_start_poll function for each
combination of template arguments and then fully optimize each one
treating the template argument as a compile-time constant - full dead
code removal, etc.

This is probably much easier to understand than all the hand coded
versions.. But not for everyone of course..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
