From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH infiniband-diags] ibdiag_sa.c: In sa_get_handle, handle umad_open_port and umad_register failures
Date: Fri, 3 Jul 2015 11:25:19 -0400
Message-ID: <20150703152518.GH15224@phlsvsds.ph.intel.com>
References: <554B447C.1040003@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <554B447C.1040003-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 07, 2015 at 01:54:52PM +0300, Hal Rosenstock wrote:
> 
> Treat umad_open_port and umad_register errors as failures for sa_get_handle
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks applied,
Ira

> ---
> diff --git a/src/ibdiag_sa.c b/src/ibdiag_sa.c
> index 018a428..a089aee 100644
> --- a/src/ibdiag_sa.c
> +++ b/src/ibdiag_sa.c
> @@ -60,18 +60,32 @@ struct sa_handle * sa_get_handle(void)
>  		IBWARN("No SM/SA found on port %s:%d",
>  			ibd_ca ? "" : ibd_ca,
>  			ibd_ca_port);
> -		free(handle);
> -		return (NULL);
> +		goto err;
>  	}
>  
>  	handle->dport.qp = 1;
>  	if (!handle->dport.qkey)
>  		handle->dport.qkey = IB_DEFAULT_QP1_QKEY;
>  
> -	handle->fd = umad_open_port(ibd_ca, ibd_ca_port);
> -	handle->agent = umad_register(handle->fd, IB_SA_CLASS, 2, 1, NULL);
> +	if ((handle->fd = umad_open_port(ibd_ca, ibd_ca_port)) < 0) {
> +		IBWARN("umad_open_port on port %s:%d failed",
> +			ibd_ca ? "" : ibd_ca,
> +			ibd_ca_port);
> +		goto err;
> +	}
> +	if ((handle->agent = umad_register(handle->fd, IB_SA_CLASS, 2, 1, NULL)) < 0) {
> +		umad_close_port(handle->fd);
> +		IBWARN("umad_register for SA class failed on port %s:%d",
> +		       ibd_ca ? "" : ibd_ca,
> +		       ibd_ca_port);
> +		goto err;
> +	}
>  
>  	return handle;
> +
> +err:
> +	free(handle);
> +	return (NULL);
>  }
>  
>  void sa_free_handle(struct sa_handle * h)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
