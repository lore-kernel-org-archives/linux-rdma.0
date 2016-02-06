From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH 1/3] IB: new common API for draining a queue pair
Date: Sat, 6 Feb 2016 19:08:38 +0200
Message-ID: <20160206170838.GC8584@leon.nu>
References: <cover.1454709317.git.swise@chelsio.com>
 <2da1db58d642789e8df154e34d622a37295d1ba3.1454709317.git.swise@chelsio.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2da1db58d642789e8df154e34d622a37295d1ba3.1454709317.git.swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 05, 2016 at 01:13:16PM -0800, Steve Wise wrote:
> From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+p6NamaJ0bNTAL8bYrjMMd8@public.gmane.org>
> 
> Add provider-specific drain_qp function for providers needing special
> drain logic.
> 
> Add static function __ib_drain_qp() which posts noop WRs to the RQ and
> SQ and blocks until their completions are processed.  This ensures the
> applications completions have all been processed.
> 
> Add API function ib_drain_qp() which calls the provider-specific drain
> if it exists or __ib_drain_qp().
> 
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> ---
>  drivers/infiniband/core/verbs.c | 72 +++++++++++++++++++++++++++++++++++++++++
>  include/rdma/ib_verbs.h         |  2 ++
>  2 files changed, 74 insertions(+)
> 

 ...

> +	ret = ib_modify_qp(qp, &attr, IB_QP_STATE);
> +	if (ret) {
> +		WARN_ONCE(ret, "failed to drain QP: %d\n", ret);
> +		return;
> +	}
> +
> +	ret = ib_post_recv(qp, &rwr, &bad_rwr);
> +	if (ret) {
> +		WARN_ONCE(ret, "failed to drain recv queue: %d\n", ret);
> +		return;
> +	}
> +
> +	ret = ib_post_send(qp, &swr, &bad_swr);
> +	if (ret) {
> +		WARN_ONCE(ret, "failed to drain send queue: %d\n", ret);
> +		return;

You are returning here despite the fact that recv queue drained
successfully and you can wait for completion of rdrain safely.
Is it done on purpose?

> +	}
> +
> +	wait_for_completion(&rdrain.done);
> +	wait_for_completion(&sdrain.done);
> +}
> +
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
