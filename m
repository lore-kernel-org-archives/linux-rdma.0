From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2 infiniband-diags] ibqueryerrors: Close global file descriptor before running ibnd_discover_fabric
Date: Wed, 22 Apr 2015 10:47:36 -0400
Message-ID: <20150422144735.GC28220@phlsvsds.ph.intel.com>
References: <55363F47.5090802@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55363F47.5090802-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 21, 2015 at 08:15:03AM -0400, Hal Rosenstock wrote:
> From: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Date: Thu, 16 Apr 2015 16:29:43 +0300
> 
> Global file descriptor for SMPs and GMPs should be closed before running
> ibnd_discover_fabric() to avoid parallel usage of two SMP file descriptors

This breaks the -D option.

Please test ibqueryerrors -D <path>

Ira

> 
> Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  src/ibqueryerrors.c |   34 +++++++++++++++++++++++++++-------
>  1 files changed, 27 insertions(+), 7 deletions(-)
> 
> diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
> index 9d9ec45..8fbb9d1 100644
> --- a/src/ibqueryerrors.c
> +++ b/src/ibqueryerrors.c
> @@ -973,6 +975,7 @@ int main(int argc, char **argv)
>  		{0}
>  	};
>  	char usage_args[] = "";
> +	uint8_t ni[IB_SMP_DATA_SIZE] = { 0 };
>  
>  	memset(suppressed_fields, 0, sizeof suppressed_fields);
>  	ibdiag_process_opts(argc, argv, &config, "cDGKLnRrSs", opts, process_opt,
> @@ -998,14 +1001,21 @@ int main(int argc, char **argv)
>  	config.flags = ibd_ibnetdisc_flags;
>  	config.mkey = ibd_mkey;
>  
> +	if (!smp_query_via(ni, &portid, IB_ATTR_NODE_INFO, 0,
> +			   ibd_timeout, ibmad_port)) {
> +		mad_rpc_close_port(ibmad_port);
> +		IBEXIT("Failed to query local Node Info\n");
> +	}
>  	node_name_map = open_node_name_map(node_name_map_file);
>  
>  	if (dr_path && load_cache_file) {
> +		mad_rpc_close_port(ibmad_port);
>  		fprintf(stderr, "Cannot specify cache and direct route path\n");
>  		exit(-1);
>  	}
>  
>  	if (resolve_self(ibd_ca, ibd_ca_port, &self_portid, &port, &self_gid.raw) < 0) {
> +		mad_rpc_close_port(ibmad_port);
>  		IBEXIT("can't resolve self port %s", argv[0]);
>  		goto close_port;
>  	}
> @@ -1028,6 +1038,8 @@ int main(int argc, char **argv)
>  			lid2sl_table[portid.lid] = portid.sl;
>  	}
>  
> +	mad_rpc_close_port(ibmad_port);
> +
>  	if (load_cache_file) {
>  		if ((fabric = ibnd_load_fabric(load_cache_file, 0)) == NULL) {
>  			fprintf(stderr, "loading cached fabric failed\n");
> @@ -1064,13 +1076,7 @@ int main(int argc, char **argv)
>  				port_guid_str);
>  	} else if (dr_path) {
>  		ibnd_port_t *port = ibnd_find_port_dr(fabric, dr_path);
> -		uint8_t ni[IB_SMP_DATA_SIZE] = { 0 };
>  
> -		if (!smp_query_via(ni, &portid, IB_ATTR_NODE_INFO, 0,
> -				   ibd_timeout, ibmad_port)) {
> -			rc = -1;
> -			goto destroy_fabric;
> -		}
>  		mad_decode_field(ni, IB_NODE_PORT_GUID_F, &(port_guid));
>  
>  		port = ibnd_find_port_guid(fabric, port_guid);
> @@ -1085,7 +1091,22 @@ int main(int argc, char **argv)
>  		if(obtain_sl)
>  			if(path_record_query(self_gid,0))
>  				goto destroy_fabric;
> +
> +		/* reopen the global ibmad_port */
> +		ibmad_port = mad_rpc_open_port(ibd_ca, ibd_ca_port,
> +					       mgmt_classes, 4);
> +		if (!ibmad_port)
> +			IBEXIT("Failed to reopen port: %s:%d\n",
> +				ibd_ca, ibd_ca_port);
> +
> +
> +		smp_mkey_set(ibmad_port, ibd_mkey);
> +
> +		if (ibd_timeout)
> +			mad_rpc_set_timeout(ibmad_port, ibd_timeout);
> +
>  		ibnd_iter_nodes(fabric, print_node, NULL);
> +		mad_rpc_close_port(ibmad_port);
>  	}
>  
>  	rc = print_summary();
> @@ -1096,7 +1117,6 @@ destroy_fabric:
>  	ibnd_destroy_fabric(fabric);
>  
>  close_port:
> -	mad_rpc_close_port(ibmad_port);
>  	close_node_name_map(node_name_map);
>  	exit(rc);
>  }
> -- 
> 1.7.8.2
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
