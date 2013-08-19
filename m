From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for libibmad] mad_rpc(): Fail with EINVAL if max_retries
 <= 0
Date: Sun, 18 Aug 2013 23:24:56 -0700
Message-ID: <20130818232456.afc45b6a170bb5f8cd34872e@intel.com>
References: <521087B7.9090208@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <521087B7.9090208-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, 18 Aug 2013 10:37:11 +0200
Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:

> Set errno to EINVAL instead of an undefined value if max_retries <= 0.
> This patch avoids that the following compiler warning is triggered:
> 
> src/rpc.c:187:8: warning: 'status' may be used uninitialized in this function [-Wmaybe-uninitialized]
> 
> Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>

Thanks Applied,
Ira

> ---
>  src/rpc.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/src/rpc.c b/src/rpc.c
> index 08b6c19..8d961f2 100644
> --- a/src/rpc.c
> +++ b/src/rpc.c
> @@ -144,6 +144,13 @@ _do_madrpc(int port_id, void *sndbuf, void *rcvbuf, int agentid, int len,
>  		save_mad = 0;
>  	}
>  
> +	if (max_retries <= 0) {
> +		errno = EINVAL;
> +		*p_error = EINVAL;
> +		ERRS("max_retries %d <= 0", max_retries);
> +		return -1;
> +	}
> +
>  	trid =
>  	    (uint32_t) mad_get_field64(umad_get_mad(sndbuf), 0, IB_MAD_TRID_F);
>  
> -- 
> 1.7.10.4
> 


-- 
Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
