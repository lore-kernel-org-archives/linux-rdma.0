From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH infiniband-diags] query_smp.c: Avoid busy looping in process_one_recv
Date: Wed, 22 Apr 2015 10:44:43 -0400
Message-ID: <20150422144443.GB28220@phlsvsds.ph.intel.com>
References: <552FC690.1010807@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <552FC690.1010807-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 16, 2015 at 10:26:24AM -0400, Hal Rosenstock wrote:
> From: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Date: Thu, 16 Apr 2015 14:11:16 +0300
> 
> Today, process_one_recv calls umad_recv with zero timeout.
> That means umad_recv will use non-blocking read() without polling,
> In many cases, this causes busy loop.
> 
> In the fix, umad_recv is invoked with -1 (infinite timeout) and the read()
> will occur only when poll exits. Also, no longer need to check for
> EWOULDBLOCK.

Has this been tested on broken fabrics where SMAs don't respond?

I know that we should recv something (ie timed out Send) for every MAD
submitted to the kernel but I seem to remember a reason we did not use a
timeout.  But that may have been for a previous implementation which no longer
exists.  I can't remember.

Ira

> 
> Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  libibnetdisc/src/query_smp.c |    2 +-
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/libibnetdisc/src/query_smp.c b/libibnetdisc/src/query_smp.c
> index 28620b4..8f179e4 100644
> --- a/libibnetdisc/src/query_smp.c
> +++ b/libibnetdisc/src/query_smp.c
> @@ -171,9 +171,7 @@ static int process_one_recv(smp_engine_t * engine)
>  
>  	/* wait for the next message */
>  	if ((rc = umad_recv(engine->umad_fd, umad, &length,
> -			    0)) < 0) {
> -		if (rc == -EWOULDBLOCK)
> -			return 0;
> +			    -1)) < 0) {
>  		IBND_ERROR("umad_recv failed: %d\n", rc);
>  		return -1;
>  	}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
