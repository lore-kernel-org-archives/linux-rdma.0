From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] infiniband-diags: Check node-name-map strings when
	querying by name
Date: Sat, 25 Jan 2014 01:20:08 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E04ADA462@CRSMSX101.amr.corp.intel.com>
References: <1390353313.6153.358.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1390353313.6153.358.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Albert Chu
> Sent: Tuesday, January 21, 2014 5:15 PM
> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: [PATCH] infiniband-diags: Check node-name-map strings when
> querying by name

Applied thanks,
Ira

> 
> Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
> ---
>  src/saquery.c |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)
> 
> diff --git a/src/saquery.c b/src/saquery.c index d6fd017..837d8ae 100644
> --- a/src/saquery.c
> +++ b/src/saquery.c
> @@ -1010,10 +1010,22 @@ static int print_node_records(struct sa_handle *
> h, struct query_params *p)
>  			if (requested_guid == cl_ntoh64(p_ni->port_guid))
>  				print_node_record(node_record);
>  		} else {
> +			ib_node_info_t *p_ni = &(node_record-
> >node_info);
> +			ib_node_desc_t *p_nd = &(node_record-
> >node_desc);
> +			char *name;
> +
> +			name = remap_node_name (node_name_map,
> +						cl_ntoh64(p_ni->node_guid),
> +						(char *)p_nd->description);
> +
>  			if (!requested_name ||
>  			    (strncmp(requested_name,
>  				     (char *)node_record-
> >node_desc.description,
>  				     sizeof(node_record->
> +					    node_desc.description)) == 0) ||
> +			    (strncmp(requested_name,
> +				     name,
> +				     sizeof(node_record->
>  					    node_desc.description)) == 0)) {
>  				print_node_record(node_record);
>  				if (node_print_desc == UNIQUE_LID_ONLY) {
> @@ -1021,6 +1033,8 @@ static int print_node_records(struct sa_handle * h,
> struct query_params *p)
>  					exit(0);
>  				}
>  			}
> +
> +			free(name);
>  		}
>  	}
>  	sa_free_result_mad(&result);
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
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
