From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH TRIVIAL infiniband-diags] libibnetdisc/internal.h: Remove duplicated declaration of add_to_portlid_hash
Date: Wed, 7 Dec 2016 09:04:23 -0500
Message-ID: <20161207140421.GB24724@phlsvsds.ph.intel.com>
References: <6fa2c407-1e87-15d1-ff01-b53d5ad1514c@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <6fa2c407-1e87-15d1-ff01-b53d5ad1514c-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 09, 2016 at 12:48:48PM -0500, Hal Rosenstock wrote:
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks applied,
Ira

> ---
> diff --git a/libibnetdisc/src/internal.h b/libibnetdisc/src/internal.h
> index 5a32cd2..997f439 100644
> --- a/libibnetdisc/src/internal.h
> +++ b/libibnetdisc/src/internal.h
> @@ -109,7 +109,6 @@ void smp_engine_destroy(smp_engine_t * engine);
>  int add_to_nodeguid_hash(ibnd_node_t * node, ibnd_node_t * hash[]);
>  
>  int add_to_portguid_hash(ibnd_port_t * port, ibnd_port_t * hash[]);
> -void add_to_portlid_hash(ibnd_port_t * port, GHashTable *htable);
>  
>  void add_to_type_list(ibnd_node_t * node, f_internal_t * fabric);
>  
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
