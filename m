From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH infiniband-diags 6/6] ibdiag_common.c: In is_port_info_extended_supported, query PortInfo for port 0 when node is a switch
Date: Mon, 4 Dec 2017 10:40:53 -0500
Message-ID: <20171204154052.GA23691@phlsvsds.ph.intel.com>
References: <372d2c64-ce18-4264-267b-294bac8524be@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <372d2c64-ce18-4264-267b-294bac8524be-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 28, 2017 at 05:12:19PM -0500, Hal Rosenstock wrote:
> 
> to be able to obtain CapabilityMask and CapabilityMask2
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>


Rejected.  I already took an earlier version of this patch and I don't see any
difference in this one...

Ira


> ---
>  src/ibdiag_common.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
> index 9245146..c33cacc 100644
> --- a/src/ibdiag_common.c
> +++ b/src/ibdiag_common.c
> @@ -506,8 +506,18 @@ int is_port_info_extended_supported(ib_portid_t * dest, int port,
>  	uint8_t data[IB_SMP_DATA_SIZE] = { 0 };
>  	uint32_t cap_mask;
>  	uint16_t cap_mask2;
> +	int type, portnum;
>  
> -	if (!smp_query_via(data, dest, IB_ATTR_PORT_INFO, port, 0, srcport))
> +	if (!smp_query_via(data, dest, IB_ATTR_NODE_INFO, 0, 0, srcport))
> +		IBEXIT("node info query failed");
> +
> +	mad_decode_field(data, IB_NODE_TYPE_F, &type);
> +	if (type == IB_NODE_SWITCH)
> +		portnum = 0;
> +	else
> +		portnum = port;
> +
> +	if (!smp_query_via(data, dest, IB_ATTR_PORT_INFO, portnum, 0, srcport))
>  		IBEXIT("port info query failed");
>  
>  	mad_decode_field(data, IB_PORT_CAPMASK_F, &cap_mask);
> -- 
> 2.8.4
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
