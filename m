From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH infiniband-diags] Remove redundant umad file descriptor from libibnetdisc
Date: Fri, 3 Jul 2015 11:20:38 -0400
Message-ID: <20150703152037.GA15224@phlsvsds.ph.intel.com>
References: <552BE20D.6080906@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <552BE20D.6080906-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 13, 2015 at 11:34:37AM -0400, Hal Rosenstock wrote:
> From: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Date: Wed, 8 Apr 2015 12:29:44 +0300
> 
> Today, two umad SMP file descriptors are used in libibnetdisc.
> One of them is needed only for retrieving LID of the local port
> for combined routing.
> 
> The patch removes the need for 2 files descriptors by retrieving
> LID of the local port in advance.
> 
> Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks applied,
Ira

> ---
>  libibnetdisc/src/ibnetdisc.c |   34 +++++++++++++++++-----------------
>  libibnetdisc/src/internal.h  |    1 -
>  2 files changed, 17 insertions(+), 18 deletions(-)
> 
> diff --git a/libibnetdisc/src/ibnetdisc.c b/libibnetdisc/src/ibnetdisc.c
> index e346905..e0f2d78 100644
> --- a/libibnetdisc/src/ibnetdisc.c
> +++ b/libibnetdisc/src/ibnetdisc.c
> @@ -127,12 +127,6 @@ static int extend_dpath(smp_engine_t * engine, ib_portid_t * portid,
>  
>  	if (portid->lid) {
>  		/* If we were LID routed we need to set up the drslid */
> -		if (!scan->selfportid.lid)
> -			if (ib_resolve_self_via(&scan->selfportid, NULL, NULL,
> -						scan->ibmad_port) < 0) {
> -				IBND_ERROR("Failed to resolve self\n");
> -				return -1;
> -			}
>  		portid->drpath.drslid = (uint16_t) scan->selfportid.lid;
>  		portid->drpath.drdlid = 0xFFFF;
>  	}
> @@ -712,6 +706,7 @@ ibnd_fabric_t *ibnd_discover_fabric(char * ca_name, int ca_port,
>  	ib_portid_t my_portid = { 0 };
>  	smp_engine_t engine;
>  	ibnd_scan_t scan;
> +	struct ibmad_port *ibmad_port;
>  	int nc = 2;
>  	int mc[2] = { IB_SMI_CLASS, IB_SMI_DIRECT_CLASS };
>  
> @@ -735,20 +730,27 @@ ibnd_fabric_t *ibnd_discover_fabric(char * ca_name, int ca_port,
>  	scan.cfg = &config;
>  	scan.initial_hops = from->drpath.cnt;
>  
> -	if (smp_engine_init(&engine, ca_name, ca_port, &scan, &config)) {
> -		free(f_int);
> +	ibmad_port = mad_rpc_open_port(ca_name, ca_port, mc, nc);
> +	if (!ibmad_port) {
> +		IBND_ERROR("can't open MAD port (%s:%d)\n", ca_name, ca_port);
>  		return (NULL);
>  	}
> +	mad_rpc_set_timeout(ibmad_port, cfg->timeout_ms);
> +	mad_rpc_set_retries(ibmad_port, cfg->retries);
> +	smp_mkey_set(ibmad_port, cfg->mkey);
>  
> -	scan.ibmad_port = mad_rpc_open_port(ca_name, ca_port, mc, nc);
> -	if (!scan.ibmad_port) {
> -		IBND_ERROR("can't open MAD port (%s:%d)\n", ca_name, ca_port);
> -		smp_engine_destroy(&engine);
> +	if (ib_resolve_self_via(&scan.selfportid,
> +				NULL, NULL, ibmad_port) < 0) {
> +		IBND_ERROR("Failed to resolve self\n");
> +		mad_rpc_close_port(ibmad_port);
> +		return NULL;
> +	}
> +	mad_rpc_close_port(ibmad_port);
> +
> +	if (smp_engine_init(&engine, ca_name, ca_port, &scan, &config)) {
> +		free(f_int);
>  		return (NULL);
>  	}
> -	mad_rpc_set_timeout(scan.ibmad_port, cfg->timeout_ms);
> -	mad_rpc_set_retries(scan.ibmad_port, cfg->retries);
> -	smp_mkey_set(scan.ibmad_port, cfg->mkey);
>  
>  	IBND_DEBUG("from %s\n", portid2str(from));
>  
> @@ -763,11 +765,9 @@ ibnd_fabric_t *ibnd_discover_fabric(char * ca_name, int ca_port,
>  		goto error;
>  
>  	smp_engine_destroy(&engine);
> -	mad_rpc_close_port(scan.ibmad_port);
>  	return (ibnd_fabric_t *)f_int;
>  error:
>  	smp_engine_destroy(&engine);
> -	mad_rpc_close_port(scan.ibmad_port);
>  	ibnd_destroy_fabric(&f_int->fabric);
>  	return NULL;
>  }
> diff --git a/libibnetdisc/src/internal.h b/libibnetdisc/src/internal.h
> index 1ccd29c..a50d2d7 100644
> --- a/libibnetdisc/src/internal.h
> +++ b/libibnetdisc/src/internal.h
> @@ -71,7 +71,6 @@ typedef struct ibnd_scan {
>  	ib_portid_t selfportid;
>  	f_internal_t *f_int;
>  	struct ibnd_config *cfg;
> -	struct ibmad_port *ibmad_port;
>  	unsigned initial_hops;
>  } ibnd_scan_t;
>  
> -- 
> 1.7.8.2
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
