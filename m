From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH infiniband-diags 6/6] saquery.c: resource leak
Date: Wed, 12 Jun 2013 14:38:46 -0700
Message-ID: <20130612143846.4dad90e64cf354050ecbe2fa@intel.com>
References: <51B87DE9.1090902@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51B87DE9.1090902-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dan Ben-Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 12 Jun 2013 09:55:53 -0400
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> From: Dan Ben Yosef <danby-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Thanks applied!
Ira

> 
> Overwriting "node_name" in call "node_name = remap_node_name(node_name_map,
> nr->node_info.node_guid, (char*)nr->node_desc.description)" leaks the
> storage that "node_name" points to.
> 
> Signed-off-by: Dan Ben Yosef <danby-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  src/saquery.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/src/saquery.c b/src/saquery.c
> index d31d77d..ca223c6 100644
> --- a/src/saquery.c
> +++ b/src/saquery.c
> @@ -365,6 +365,8 @@ static void dump_multicast_member_record(ib_member_rec_t *p_mcmr,
>  		ib_node_record_t *nr = sa_get_query_rec(nr_result->p_result_madw, i);
>  		if (nr->node_info.port_guid ==
>  		    p_mcmr->port_gid.unicast.interface_id) {
> +			if(node_name != NULL)
> +				free(node_name);
>  			node_name = remap_node_name(node_name_map,
>  						nr->node_info.node_guid,
>  						(char *)nr->node_desc.description);
> -- 
> 1.7.8.2
> 


-- 
Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
