From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags: Allow user to specify multiple ports
Date: Thu, 20 Sep 2012 17:32:10 -0700
Message-ID: <20120920173210.786dbc5cb24bd7e07fbd7b5d@llnl.gov>
References: <1347577985.25388.42.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1347577985.25388.42.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 13 Sep 2012 16:13:05 -0700
Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org> wrote:

> Allow user to select multiple ports via comma or range input.  May
> be particularly useful for gathering aggregate performance counters
> for groups of ports, such as all the uplinks or downlinks from a
> switch.
> 
> Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>

Thanks applied,
Ira

> ---
>  doc/rst/perfquery.8.in.rst |   19 ++++++++++----
>  src/perfquery.c            |   57 +++++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 68 insertions(+), 8 deletions(-)
> 
> diff --git a/doc/rst/perfquery.8.in.rst b/doc/rst/perfquery.8.in.rst
> index 359c94e..5e3d709 100644
> --- a/doc/rst/perfquery.8.in.rst
> +++ b/doc/rst/perfquery.8.in.rst
> @@ -14,7 +14,7 @@ query InfiniBand port counters on a single port
>  SYNOPSIS
>  ========
>  
> -perfquery [options] [<lid|guid> [[port] [reset_mask]]]
> +perfquery [options] [<lid|guid> [[port(s)] [reset_mask]]]
>  
>  DESCRIPTION
>  ===========
> @@ -32,6 +32,9 @@ octets divided by 4 rather than just octets.
>  
>  Note: Inputting a port of 255 indicates an operation be performed on all ports.
>  
> +Note: For PortCounters, ExtendedCounters, and resets, multiple ports can be
> +specified by either a comma separated list or a port range.  See examples below.
> +
>  
>  OPTIONS
>  =======
> @@ -98,15 +101,16 @@ OPTIONS
>  	show port samples control.
>  
>  **-a, --all_ports**
> -	show aggregated counters for all ports of the destination lid or reset
> -	all counters for all ports.  If the destination lid does not support
> +	show aggregated counters for all ports of the destination lid, reset
> +	all counters for all ports, or if multiple ports are specified, aggregate
> +	the counters of the specified ports.  If the destination lid does not support
>  	the AllPortSelect flag, all ports will be iterated through to emulate
>  	AllPortSelect behavior.
>  
>  **-l, --loop_ports**
>  	If all ports are selected by the user (either through the **-a** option
> -	or port 255) iterate through each port rather than doing than aggregate
> -	operation.
> +	or port 255) or multiple ports are specified iterate through each port rather
> +	than doing than aggregate operation.
>  
>  **-r, --reset_after_read**
>  	reset counters after read
> @@ -158,6 +162,7 @@ EXAMPLES
>  ========
>  
>  ::
> +
>  	perfquery                # read local port performance counters
>  	perfquery 32 1           # read performance counters from lid 32, port 1
>  	perfquery -x 32 1        # read extended performance counters from lid 32, port 1
> @@ -169,6 +174,10 @@ EXAMPLES
>  	perfquery -R -a 32       # reset performance counters of all ports
>  	perfquery -R 32 2 0x0fff # reset only error counters of port 2
>  	perfquery -R 32 2 0xf000 # reset only non-error counters of port 2
> +	perfquery -a 32 1-10     # read performance counters from lid 32, port 1-10, aggregate output
> +	perfquery -l 32 1-10     # read performance counters from lid 32, port 1-10, output each port
> +	perfquery -a 32 1,4,8    # read performance counters from lid 32, port 1, 4, and 8, aggregate output
> +	perfquery -l 32 1,4,8    # read performance counters from lid 32, port 1, 4, and 8, output each port
>  
>  AUTHOR
>  ======
> diff --git a/src/perfquery.c b/src/perfquery.c
> index 32dd98f..27ec4f7 100644
> --- a/src/perfquery.c
> +++ b/src/perfquery.c
> @@ -94,6 +94,7 @@ struct perf_count perf_count =
>  struct perf_count_ext perf_count_ext = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
>  
>  #define ALL_PORTS 0xFF
> +#define MAX_PORTS 255
>  
>  /* Notes: IB semantics is to cap counters if count has exceeded limits.
>   * Therefore we must check for overflows and cap the counters if necessary.
> @@ -371,6 +372,8 @@ static int reset, reset_only, all_ports, loop_ports, port, extended, xmt_sl,
>      rcv_sl, xmt_disc, rcv_err, extended_speeds, smpl_ctl, oprcvcounters, flowctlcounters,
>      vloppackets, vlopdata, vlxmitflowctlerrors, vlxmitcounters, swportvlcong,
>      rcvcc, slrcvfecn, slrcvbecn, xmitcc, vlxmittimecc;
> +static int ports[MAX_PORTS];
> +static int ports_count;
>  
>  static void common_func(ib_portid_t * portid, int port_num, int mask,
>  			unsigned query, unsigned reset,
> @@ -666,6 +669,7 @@ int main(int argc, char **argv)
>  	uint8_t data[IB_SMP_DATA_SIZE] = { 0 };
>  	int start_port = 1;
>  	int enhancedport0;
> +	char *tmpstr;
>  	int i;
>  
>  	const struct ibdiag_opt opts[] = {
> @@ -694,7 +698,7 @@ int main(int argc, char **argv)
>  		{"Reset_only", 'R', 0, NULL, "only reset counters"},
>  		{0}
>  	};
> -	char usage_args[] = " [<lid|guid> [[port] [reset_mask]]]";
> +	char usage_args[] = " [<lid|guid> [[port(s)] [reset_mask]]]";
>  	const char *usage_examples[] = {
>  		"\t\t# read local port's performance counters",
>  		"32 1\t\t# read performance counters from lid 32, port 1",
> @@ -707,6 +711,10 @@ int main(int argc, char **argv)
>  		"-R -a 32\t# reset performance counters of all ports",
>  		"-R 32 2 0x0fff\t# reset only error counters of port 2",
>  		"-R 32 2 0xf000\t# reset only non-error counters of port 2",
> +		"-a 32 1-10\t# read performance counters from lid 32, port 1-10, aggregate output",
> +		"-l 32 1-10\t# read performance counters from lid 32, port 1-10, output each port",
> +		"-a 32 1,4,8\t# read performance counters from lid 32, port 1, 4, and 8, aggregate output",
> +		"-l 32 1,4,8\t# read performance counters from lid 32, port 1, 4, and 8, output each port",
>  		NULL,
>  	};
>  
> @@ -716,8 +724,35 @@ int main(int argc, char **argv)
>  	argc -= optind;
>  	argv += optind;
>  
> -	if (argc > 1)
> -		port = strtoul(argv[1], 0, 0);
> +	if (argc > 1) {
> +		if (strchr(argv[1], ',')) {
> +			tmpstr = strtok(argv[1], ",");
> +			while (tmpstr) {
> +				ports[ports_count++] = strtoul(tmpstr, 0, 0);
> +				tmpstr = strtok(NULL, ",");
> +			}
> +			port = ports[0];
> +		}
> +		else if ((tmpstr = strchr(argv[1], '-'))) {
> +			int pmin, pmax;
> +
> +			*tmpstr = '\0';
> +			tmpstr++;
> +
> +			pmin = strtoul(argv[1], 0, 0);
> +			pmax = strtoul(tmpstr, 0, 0);
> +
> +			if (pmin >= pmax)
> +				IBERROR("max port must be greater than min port in range");
> +
> +			while (pmin <= pmax)
> +				ports[ports_count++] = pmin++;
> +
> +			port = ports[0];
> +		}
> +		else
> +			port = strtoul(argv[1], 0, 0);
> +	}
>  	if (argc > 2) {
>  		ext_mask = strtoull(argv[2], 0, 0);
>  		mask = ext_mask;
> @@ -882,6 +917,19 @@ int main(int argc, char **argv)
>  				output_aggregate_perfcounters_ext(&portid,
>  								  cap_mask);
>  		}
> +	} else if (ports_count > 1) {
> +		for (i = 0; i < ports_count; i++)
> +			dump_perfcounters(extended, ibd_timeout, cap_mask,
> +					  &portid, ports[i],
> +					  (all_ports && !loop_ports));
> +		if (all_ports && !loop_ports) {
> +			if (extended != 1)
> +				output_aggregate_perfcounters(&portid,
> +							      cap_mask);
> +			else
> +				output_aggregate_perfcounters_ext(&portid,
> +								  cap_mask);
> +		}
>  	} else
>  		dump_perfcounters(extended, ibd_timeout, cap_mask, &portid,
>  				  port, 0);
> @@ -896,6 +944,9 @@ do_reset:
>  	if (all_ports_loop || (loop_ports && (all_ports || port == ALL_PORTS))) {
>  		for (i = start_port; i <= num_ports; i++)
>  			reset_counters(extended, ibd_timeout, mask, &portid, i);
> +	} else if (ports_count > 1) {
> +		for (i = 0; i < ports_count; i++)
> +			reset_counters(extended, ibd_timeout, mask, &portid, ports[i]);
>  	} else
>  		reset_counters(extended, ibd_timeout, mask, &portid, port);
>  
> -- 
> 1.7.1
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
