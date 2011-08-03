From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH v3/2] infiniband-diags/smpquery: Add Mellanox extended
 portinfo query
Date: Wed, 3 Aug 2011 13:14:21 -0700
Message-ID: <20110803131421.0f1189ad.weiny2@llnl.gov>
References: <4E2AAA5C.4080801@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E2AAA5C.4080801-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, 23 Jul 2011 04:02:52 -0700
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

applied, thanks,
Ira

> ---
> Changes since v2:
> Made command MlnxExtPortInfo or MEPI
> Other cosmetics to add mlnx to extportinfo
> 
> Changes since v1:
> Added man page change
> 
> diff --git a/man/smpquery.8 b/man/smpquery.8
> index 3b69e8a..afd02db 100644
> --- a/man/smpquery.8
> +++ b/man/smpquery.8
> @@ -1,4 +1,4 @@
> -.TH SMPQUERY 8 "March 14, 2007" "OpenIB" "OpenIB Diagnostics"
> +.TH SMPQUERY 8 "March 9, 2011" "OpenIB" "OpenIB Diagnostics"
>  
>  .SH NAME
>  smpquery \- query InfiniBand subnet management attributes
> @@ -29,6 +29,7 @@ Current supported operations and their parameters:
>          sl2vl <addr> [<portnum>]
>          vlarb <addr> [<portnum>]
>          guids <addr>
> +        mlnxextportinfo <addr> [<portnum>]  # default port is zero
>  
>  .TP
>  \fB\-\-node\-name\-map\fR <node-name-map>
> @@ -113,4 +114,4 @@ smpquery -c nodeinfo 6 0,12  # nodeinfo by combined route
>  .SH AUTHOR
>  .TP
>  Hal Rosenstock
> -.RI < halr-smomgflXvOZWk0Htik3J/w@public.gmane.org >
> +.RI < hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org >
> diff --git a/src/smpquery.c b/src/smpquery.c
> index 65bb65c..6753ba9 100644
> --- a/src/smpquery.c
> +++ b/src/smpquery.c
> @@ -63,7 +63,7 @@ typedef struct match_rec {
>  } match_rec_t;
>  
>  static op_fn_t node_desc, node_info, port_info, switch_info, pkey_table,
> -    sl2vl_table, vlarb_table, guid_info;
> +    sl2vl_table, vlarb_table, guid_info, mlnx_ext_port_info;
>  
>  static const match_rec_t match_tbl[] = {
>  	{"NodeInfo", "NI", node_info},
> @@ -74,6 +74,7 @@ static const match_rec_t match_tbl[] = {
>  	{"SL2VLTable", "SL2VL", sl2vl_table, 1},
>  	{"VLArbitration", "VLArb", vlarb_table, 1},
>  	{"GUIDInfo", "GI", guid_info},
> +	{"MlnxExtPortInfo", "MEPI", mlnx_ext_port_info, 1},
>  	{0}
>  };
>  
> @@ -147,6 +148,24 @@ static char *port_info(ib_portid_t * dest, char **argv, int argc)
>  	return 0;
>  }
>  
> +static char *mlnx_ext_port_info(ib_portid_t * dest, char **argv, int argc)
> +{
> +	char buf[2300];
> +	char data[IB_SMP_DATA_SIZE];
> +	int portnum = 0;
> +
> +	if (argc > 0)
> +		portnum = strtol(argv[0], 0, 0);
> +
> +	if (!smp_query_via(data, dest, IB_ATTR_MLNX_EXT_PORT_INFO, portnum, 0, srcport))
> +		return "Mellanox ext port info query failed";
> +
> +	mad_dump_mlnx_ext_port_info(buf, sizeof buf, data, sizeof data);
> +
> +	printf("# MLNX ext Port info: %s port %d\n%s", portid2str(dest), portnum, buf);
> +	return 0;
> +}
> +
>  static char *switch_info(ib_portid_t * dest, char **argv, int argc)
>  {
>  	char buf[2048];


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
