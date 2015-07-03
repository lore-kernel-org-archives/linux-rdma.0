From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH infiniband-diags] dump_fts: Open global file descriptor after calling ibnd_discover_fabric
Date: Fri, 3 Jul 2015 11:21:35 -0400
Message-ID: <20150703152134.GC15224@phlsvsds.ph.intel.com>
References: <55363F57.3020909@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55363F57.3020909-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 21, 2015 at 08:15:19AM -0400, Hal Rosenstock wrote:
> From: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Date: Thu, 16 Apr 2015 16:56:40 +0300
> 
> Global file descriptor for SMPs should be opened only after running
> ibnd_discover_fabric() to avoid parallel usage of two SMP file descriptors
> 
> Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks applied,
Ira

> ---
>  src/dump_fts.c |   30 +++++++++++++++++++-----------
>  1 files changed, 19 insertions(+), 11 deletions(-)
> 
> diff --git a/src/dump_fts.c b/src/dump_fts.c
> index 0de61da..387211f 100644
> --- a/src/dump_fts.c
> +++ b/src/dump_fts.c
> @@ -457,33 +457,41 @@ int main(int argc, char **argv)
>  	if (argc > 1)
>  		endlid = strtoul(argv[1], 0, 0);
>  
> -	srcport = mad_rpc_open_port(ibd_ca, ibd_ca_port, mgmt_classes, 3);
> -	if (!srcport)
> -		IBEXIT("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
> -
>  	node_name_map = open_node_name_map(node_name_map_file);
>  
> -	smp_mkey_set(srcport, ibd_mkey);
> -
> -	if (ibd_timeout) {
> -		mad_rpc_set_timeout(srcport, ibd_timeout);
> +	if (ibd_timeout)
>  		config.timeout_ms = ibd_timeout;
> -	}
>  
>  	config.flags = ibd_ibnetdisc_flags;
>  	config.mkey = ibd_mkey;
>  
>  	if ((fabric = ibnd_discover_fabric(ibd_ca, ibd_ca_port, NULL,
>  						&config)) != NULL) {
> +
> +		srcport = mad_rpc_open_port(ibd_ca, ibd_ca_port, mgmt_classes, 3);
> +		if (!srcport) {
> +			fprintf(stderr,
> +				"Failed to open '%s' port '%d'\n", ibd_ca, ibd_ca_port);
> +			rc = -1;
> +			goto Exit;
> +		}
> +		smp_mkey_set(srcport, ibd_mkey);
> +
> +		if (ibd_timeout) {
> +			mad_rpc_set_timeout(srcport, ibd_timeout);
> +		}
> +
>  		ibnd_iter_nodes_type(fabric, process_switch, IB_NODE_SWITCH, fabric);
> +
> +		mad_rpc_close_port(srcport);
> +
>  	} else {
>  		fprintf(stderr, "Failed to discover fabric\n");
>  		rc = -1;
>  	}
> -
> +Exit:
>  	ibnd_destroy_fabric(fabric);
>  
> -	mad_rpc_close_port(srcport);
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
