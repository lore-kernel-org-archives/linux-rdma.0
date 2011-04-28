From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: infiniband-diags/perfquery.c: Use ib_types.h defines for
 CapabilityMask
Date: Thu, 28 Apr 2011 14:13:05 -0700
Message-ID: <20110428141305.eec85988.weiny2@llnl.gov>
References: <4DB97DF4.3020004@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DB97DF4.3020004-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 28 Apr 2011 07:47:16 -0700
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> rather than hard coded values now that these have been added to ib_types.h
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, applied,
Ira

> ---
> diff --git a/src/perfquery.c b/src/perfquery.c
> index ef63da2..d24c3c7 100644
> --- a/src/perfquery.c
> +++ b/src/perfquery.c
> @@ -46,6 +46,7 @@
>  
>  #include <infiniband/umad.h>
>  #include <infiniband/mad.h>
> +#include <infiniband/iba/ib_types.h>
>  
>  #include "ibdiag_common.h"
>  
> @@ -293,7 +294,7 @@ static void dump_perfcounters(int extended, int timeout, uint16_t cap_mask,
>  		if (!pma_query_via(pc, portid, port, timeout,
>  				   IB_GSI_PORT_COUNTERS, srcport))
>  			IBERROR("perfquery");
> -		if (!(cap_mask & 0x1000)) {
> +		if (!(cap_mask & IB_PM_PC_XMIT_WAIT_SUP)) {
>  			/* if PortCounters:PortXmitWait not supported clear this counter */
>  			VERBOSE("PortXmitWait not indicated"
>  				" so ignore this counter");
> @@ -306,10 +307,10 @@ static void dump_perfcounters(int extended, int timeout, uint16_t cap_mask,
>  		else
>  			mad_dump_fields(buf, sizeof buf, pc, sizeof pc,
>  							IB_PC_FIRST_F,
> -							(cap_mask & 0x1000)?IB_PC_LAST_F:(IB_PC_RCV_PKTS_F+1));
> +							(cap_mask & IB_PM_PC_XMIT_WAIT_SUP)?IB_PC_LAST_F:(IB_PC_RCV_PKTS_F+1));
>  
>  	} else {
> -		if (!(cap_mask & 0x200))	/* 1.2 errata: bit 9 is extended counter support */
> +		if (!(cap_mask & IB_PM_EXT_WIDTH_SUPPORTED))	/* 1.2 errata: bit 9 is extended counter support */
>  			IBWARN
>  			    ("PerfMgt ClassPortInfo 0x%x extended counters not indicated\n",
>  			     cap_mask);
> @@ -535,8 +536,7 @@ int main(int argc, char **argv)
>  		IBERROR("classportinfo query");
>  	/* ClassPortInfo should be supported as part of libibmad */
>  	memcpy(&cap_mask, pc + 2, sizeof(cap_mask));	/* CapabilityMask */
> -	cap_mask = ntohs(cap_mask);
> -	if (!(cap_mask & 0x100)) {	/* bit 8 is AllPortSelect */
> +	if (!(cap_mask & IB_PM_ALL_PORT_SELECT)) {	/* bit 8 is AllPortSelect */
>  		if (!all_ports && port == ALL_PORTS)
>  			IBERROR("AllPortSelect not supported");
>  		if (all_ports)
> @@ -613,7 +613,7 @@ int main(int argc, char **argv)
>  		goto done;
>  
>  do_reset:
> -	if (argc <= 2 && !extended && (cap_mask & 0x1000))
> +	if (argc <= 2 && !extended && (cap_mask & IB_PM_PC_XMIT_WAIT_SUP))
>  		mask |= (1 << 16);	/* reset portxmitwait */
>  
>  	if (all_ports_loop || (loop_ports && (all_ports || port == ALL_PORTS))) {
> 
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
