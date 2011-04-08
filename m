From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCHv2 1/2] libibmad/smp.c: Fix to smp_query_via for
 attribute data
Date: Fri, 8 Apr 2011 15:31:19 -0700
Message-ID: <20110408153119.9548c384.weiny2@llnl.gov>
References: <4D9B6C30.7000006@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D9B6C30.7000006-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I am a bit concerned about how this might affect callers of the function but I can't find anywhere that it would be an issue in infiniband-diags.

We will go with it and see if anything comes up.

Applied, thanks,
Ira

On Tue, 5 Apr 2011 12:23:28 -0700
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> 
> smp_query_via() does not allow setting the sent mad data.
> Change the data to be both in and out arguments.
> 
> Signed-off-by: Oren Kladnitsky <orenk-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> Changes since v1:
> Proper formatting
> 
> diff --git a/src/smp.c b/src/smp.c
> index 3ff58ce..2809ffe 100644
> --- a/src/smp.c
> +++ b/src/smp.c
> @@ -102,7 +102,7 @@ uint8_t *smp_query_via(void *rcvbuf, ib_portid_t * portid, unsigned attrid,
>  	portid->sl = 0;
>  	portid->qp = 0;
>  
> -	return mad_rpc(srcport, &rpc, portid, 0, rcvbuf);
> +	return mad_rpc(srcport, &rpc, portid, rcvbuf, rcvbuf);
>  }
>  
>  uint8_t *smp_query(void *rcvbuf, ib_portid_t * portid, unsigned attrid,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
