From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH opensm] osm_subnet.c: Change default for
 perfmgr_query_cpi option
Date: Sat, 12 Jul 2014 14:54:43 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E04BF03E8@CRSMSX101.amr.corp.intel.com>
References: <53BFEEA9.8020107@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53BFEEA9.8020107-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Susan Coulter (skc-YOWKrPYUwWM@public.gmane.org)" <skc-YOWKrPYUwWM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> 
> New default for PerfMgr query CPI is TRUE rather than FALSE.
> More admins need to use this and this was too often being missed during
> configuration so make admins turn this off rather than on (once enabling
> perfmgr itself).
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

> ---
> diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c index
> 1065408..26fe78c 100644
> --- a/opensm/osm_subnet.c
> +++ b/opensm/osm_subnet.c
> @@ -1564,7 +1564,7 @@ void osm_subn_set_default_opt(IN
> osm_subn_opt_t * p_opt)
>  	p_opt->event_db_dump_file = NULL; /* use default */
>  	p_opt->perfmgr_rm_nodes = TRUE;
>  	p_opt->perfmgr_log_errors = TRUE;
> -	p_opt->perfmgr_query_cpi = FALSE;
> +	p_opt->perfmgr_query_cpi = TRUE;
>  	p_opt->perfmgr_xmit_wait_log = FALSE;
>  	p_opt->perfmgr_xmit_wait_threshold =
> OSM_PERFMGR_DEFAULT_XMIT_WAIT_THRESHOLD;
>  #endif				/* ENABLE_OSM_PERF_MGR */
> @@ -2645,7 +2645,7 @@ int osm_subn_output_conf(FILE *out, IN
> osm_subn_opt_t * p_opts)
>  		"perfmgr_log_errors %s\n\n"
>  		"# Query PerfMgt Get(ClassPortInfo) for extended
> capabilities\n"
>  		"# Extended capabilities include 64 bit extended counters\n"
> -		"# and transmit wait support (default FALSE)\n"
> +		"# and transmit wait support (default TRUE)\n"
>  		"perfmgr_query_cpi %s\n\n"
>  		"# Log xmit_wait errors (default FALSE)\n"
>  		"perfmgr_xmit_wait_log %s\n\n"
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
