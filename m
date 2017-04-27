From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH infiniband-diags] ibdiag_common.c: Fix endian conversion in resolve_self for umad_port GID prefix and GUID
Date: Wed, 26 Apr 2017 21:53:49 -0400
Message-ID: <20170427015348.GB1352@phlsvsds.ph.intel.com>
References: <976c8c54-4c09-a84b-7a3e-0b3340121985@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <976c8c54-4c09-a84b-7a3e-0b3340121985-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 13, 2017 at 08:24:01AM -0400, Hal Rosenstock wrote:
> 
> commit 96db7b90 to rdma-core
> libibumad: Annotate endianness of second umad_get_ca_portguids() argument
> 
> annotated umad_port struct gid_prefix and port_guid fields as __be64
> so proper conversion is cl_ntoh64 rather than cl_hton64.
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks applied,
Ira

> ---
> diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
> index 0fe2190..eda2901 100644
> --- a/src/ibdiag_common.c
> +++ b/src/ibdiag_common.c
> @@ -608,8 +608,8 @@ int resolve_self(char *ca_name, uint8_t ca_port, ib_portid_t *portid,
>  		*portnum = port.portnum;
>  	if (gid) {
>  		memset(gid, 0, sizeof(*gid));
> -		prefix = cl_hton64(port.gid_prefix);
> -		guid = cl_hton64(port.port_guid);
> +		prefix = cl_ntoh64(port.gid_prefix);
> +		guid = cl_ntoh64(port.port_guid);
>  		mad_encode_field(*gid, IB_GID_PREFIX_F, &prefix);
>  		mad_encode_field(*gid, IB_GID_GUID_F, &guid);
>  	}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
