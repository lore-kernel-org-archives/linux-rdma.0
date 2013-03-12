From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] opensm: Fix issues causing const warnings for strings
Date: Tue, 12 Mar 2013 14:12:13 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510EBB2D9E@CRSMSX102.amr.corp.intel.com>
References: <513F3173.4080908@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <513F3173.4080908-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Hal Rosenstock
> Sent: Tuesday, March 12, 2013 9:45 AM
> To: linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
> Subject: [PATCH] opensm: Fix issues causing const warnings for strings
> 
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---

[snip]

> 
> diff --git a/opensm/main.c b/opensm/main.c index 1a061a8..db5429a 100644
> --- a/opensm/main.c
> +++ b/opensm/main.c
> @@ -718,7 +718,7 @@ int main(int argc, char *argv[])
>  	optind = 0;		/* reset command line */
> 
>  	if (!config_file)
> -		config_file = OSM_DEFAULT_CONFIG_FILE;
> +		config_file = strdup(OSM_DEFAULT_CONFIG_FILE);
> 

Why is the strdup here but not on the optarg above?

Also, is this free'ed anywhere?  Can the config file change at run time?  I don't think it can but perhaps you are moving that direction?

Also, perhaps the strdup should be within osm_subn_parse_conf_file?  

Ira

[snip]
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
