From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH libibmad 2/2] gs.c: In performance_reset_via, use proper CounterSelect2 field for PortCountersExtended
Date: Sat, 29 Apr 2017 20:05:56 -0400
Message-ID: <20170430000555.GC27829@phlsvsds.ph.intel.com>
References: <26623475-0c21-ebf2-f4e8-dd40693fab64@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <26623475-0c21-ebf2-f4e8-dd40693fab64-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 27, 2017 at 11:35:44AM -0400, Hal Rosenstock wrote:
> 
> Per MgtWG errata #9302
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks applied,
Ira

> ---
> diff --git a/src/gs.c b/src/gs.c
> index 5541b6b..90db7e2 100644
> --- a/src/gs.c
> +++ b/src/gs.c
> @@ -110,11 +110,14 @@ uint8_t *performance_reset_via(void *rcvbuf, ib_portid_t * dest,
>  
>  	memset(rcvbuf, 0, IB_MAD_SIZE);
>  
> -	/* Same for attribute IDs */
> +	/* Next 2 lines - same for attribute IDs */
>  	mad_set_field(rcvbuf, 0, IB_PC_PORT_SELECT_F, port);
>  	mad_set_field(rcvbuf, 0, IB_PC_COUNTER_SELECT_F, mask);
>  	mask = mask >> 16;
> -	mad_set_field(rcvbuf, 0, IB_PC_COUNTER_SELECT2_F, mask);
> +	if (id == IB_GSI_PORT_COUNTERS_EXT)
> +		mad_set_field(rcvbuf, 0, IB_PC_EXT_COUNTER_SELECT2_F, mask);
> +	else
> +		mad_set_field(rcvbuf, 0, IB_PC_COUNTER_SELECT2_F, mask);
>  	rpc.attr.mod = 0;
>  	rpc.timeout = timeout;
>  	rpc.datasz = IB_PC_DATA_SZ;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
