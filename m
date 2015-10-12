From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH infiniband-diags] perfquery.c: Fix smp_query_via return value checks
Date: Mon, 12 Oct 2015 19:24:06 -0400
Message-ID: <20151012232405.GB6211@phlsvsds.ph.intel.com>
References: <561BA7E7.4050401@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <561BA7E7.4050401-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: David Binderman <dcb314-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 12, 2015 at 08:30:31AM -0400, Hal Rosenstock wrote:
> 
> smp_query_via returns pointer so < 0 comparison is wrong:
> src/perfquery.c: In function ?is_rsfec_mode_active?:
> src/perfquery.c:481: warning: ordered comparison of pointer with integer zero
> src/perfquery.c: In function ?main?:
> src/perfquery.c:919: warning: ordered comparison of pointer with integer zero
> src/perfquery.c:928: warning: ordered comparison of pointer with integer zero
>  
> Reported-by: David Binderman <dcb314-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

There is also a call in ibdiag_common.c which is wrong:

diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
index 54248455bac4..5ec0167f87de 100644
--- a/src/ibdiag_common.c
+++ b/src/ibdiag_common.c
@@ -507,7 +507,7 @@ int is_port_info_extended_supported(ib_portid_t * dest, int
port,
        uint32_t cap_mask;
        uint16_t cap_mask2;
 
-       if (smp_query_via(data, dest, IB_ATTR_PORT_INFO, port, 0, srcport) < 0)
+       if (!smp_query_via(data, dest, IB_ATTR_PORT_INFO, port, 0, srcport))
                IBEXIT("port info query failed");
 
        mad_decode_field(data, IB_PORT_CAPMASK_F, &cap_mask);


I went ahead and added this chunk to this patch and accepted.

Thanks,
Ira


> ---
> Fix for OFA Bugzilla #2572
> 
> diff --git a/src/perfquery.c b/src/perfquery.c
> index 9e3a307..948ce52 100644
> --- a/src/perfquery.c
> +++ b/src/perfquery.c
> @@ -477,8 +477,8 @@ static uint8_t is_rsfec_mode_active(ib_portid_t * portid, int port,
>  			return 0;
>  		}
>  
> -		if (smp_query_via(data, portid, IB_ATTR_PORT_INFO_EXT, port, 0,
> -				  srcport) < 0)
> +		if (!smp_query_via(data, portid, IB_ATTR_PORT_INFO_EXT, port, 0,
> +				   srcport))
>  			IBEXIT("smp query portinfo extended failed");
>  
>  		mad_decode_field(data, IB_PORT_EXT_CAPMASK_F, &pie_capmask);
> @@ -915,8 +915,8 @@ int main(int argc, char **argv)
>  
>  
>  	if (all_ports_loop || (loop_ports && (all_ports || port == ALL_PORTS))) {
> -		if (smp_query_via(data, &portid, IB_ATTR_NODE_INFO, 0, 0,
> -				  srcport) < 0)
> +		if (!smp_query_via(data, &portid, IB_ATTR_NODE_INFO, 0, 0,
> +				   srcport))
>  			IBEXIT("smp query nodeinfo failed");
>  		node_type = mad_get_field(data, 0, IB_NODE_TYPE_F);
>  		mad_decode_field(data, IB_NODE_NPORTS_F, &num_ports);
> @@ -924,8 +924,8 @@ int main(int argc, char **argv)
>  			IBEXIT("smp query nodeinfo: num ports invalid");
>  
>  		if (node_type == IB_NODE_SWITCH) {
> -			if (smp_query_via(data, &portid, IB_ATTR_SWITCH_INFO,
> -					  0, 0, srcport) < 0)
> +			if (!smp_query_via(data, &portid, IB_ATTR_SWITCH_INFO,
> +					   0, 0, srcport))
>  				IBEXIT("smp query nodeinfo failed");
>  			enhancedport0 =
>  			    mad_get_field(data, 0, IB_SW_ENHANCED_PORT0_F);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
