From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RESEND infiniband-diags 1/3] perfquery.c: Output PerfMgt ClassPortInfo CapabilityMask2
Date: Sat, 29 Apr 2017 20:16:10 -0400
Message-ID: <20170430001610.GE27829@phlsvsds.ph.intel.com>
References: <166e48ee-97ae-2acc-6a8d-b06541385f01@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <166e48ee-97ae-2acc-6a8d-b06541385f01-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 28, 2017 at 10:56:08AM -0400, Hal Rosenstock wrote:
> 
> in addition to CapabilityMask for PortCountersExtended attribute 
> 
> MgtWG errata #9301 defines IsAdditionalPortCountersExtendedSupported
> bit in CapabilityMask2.
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks applied,
Ira

> ---
> diff --git a/src/perfquery.c b/src/perfquery.c
> index 948ce52..ab6c0f8 100644
> --- a/src/perfquery.c
> +++ b/src/perfquery.c
> @@ -296,7 +296,8 @@ static void output_aggregate_perfcounters_ext(ib_portid_t * portid,
>  }
>  
>  static void dump_perfcounters(int extended, int timeout, uint16_t cap_mask,
> -			      ib_portid_t * portid, int port, int aggregate)
> +			      uint32_t cap_mask2, ib_portid_t * portid,
> +			      int port, int aggregate)
>  {
>  	char buf[1024];
>  
> @@ -344,8 +345,9 @@ static void dump_perfcounters(int extended, int timeout, uint16_t cap_mask,
>  	if (!aggregate) {
>  		if (extended)
>  			printf("# Port extended counters: %s port %d "
> -			       "(CapMask: 0x%02X)\n%s",
> -			       portid2str(portid), port, ntohs(cap_mask), buf);
> +			       "(CapMask: 0x%02X CapMask2: 0x%07X)\n%s",
> +			       portid2str(portid), port, ntohs(cap_mask),
> +			       cap_mask2, buf);
>  		else
>  			printf("# Port counters: %s port %d "
>  			       "(CapMask: 0x%02X)\n%s",
> @@ -699,6 +701,7 @@ int main(int argc, char **argv)
>  	ib_portid_t portid = { 0 };
>  	int mask = 0xffff;
>  	uint64_t ext_mask = 0xffffffffffffffffULL;
> +	uint32_t cap_mask2;
>  	uint16_t cap_mask;
>  	int all_ports_loop = 0;
>  	int node_type, num_ports = 0;
> @@ -816,6 +819,9 @@ int main(int argc, char **argv)
>  		IBEXIT("classportinfo query");
>  	/* ClassPortInfo should be supported as part of libibmad */
>  	memcpy(&cap_mask, pc + 2, sizeof(cap_mask));	/* CapabilityMask */
> +	memcpy(&cap_mask2, pc + 4, sizeof(cap_mask2));	/* CapabilityMask2 */
> +	cap_mask2 = ntohl(cap_mask2) >> 5;
> +
>  	if (!(cap_mask & IB_PM_ALL_PORT_SELECT)) {	/* bit 8 is AllPortSelect */
>  		if (!all_ports && port == ALL_PORTS)
>  			IBEXIT("AllPortSelect not supported");
> @@ -942,7 +948,8 @@ int main(int argc, char **argv)
>  
>  	if (all_ports_loop || (loop_ports && (all_ports || port == ALL_PORTS))) {
>  		for (i = start_port; i <= num_ports; i++)
> -			dump_perfcounters(extended, ibd_timeout, cap_mask,
> +			dump_perfcounters(extended, ibd_timeout,
> +					  cap_mask, cap_mask2,
>  					  &portid, i, (all_ports_loop
>  						       && !loop_ports));
>  		if (all_ports_loop && !loop_ports) {
> @@ -956,7 +963,7 @@ int main(int argc, char **argv)
>  	} else if (ports_count > 1) {
>  		for (i = 0; i < ports_count; i++)
>  			dump_perfcounters(extended, ibd_timeout, cap_mask,
> -					  &portid, ports[i],
> +					  cap_mask2, &portid, ports[i],
>  					  (all_ports && !loop_ports));
>  		if (all_ports && !loop_ports) {
>  			if (extended != 1)
> @@ -967,8 +974,8 @@ int main(int argc, char **argv)
>  								  cap_mask);
>  		}
>  	} else
> -		dump_perfcounters(extended, ibd_timeout, cap_mask, &portid,
> -				  port, 0);
> +		dump_perfcounters(extended, ibd_timeout, cap_mask, cap_mask2,
> +				  &portid, port, 0);
>  
>  	if (!reset)
>  		goto done;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
