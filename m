From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 3/4] infiniband-diags: properly resolve node guids
Date: Fri, 08 Jul 2011 17:42:38 -0400
Message-ID: <4E1779CE.9030502@dev.mellanox.co.il>
References: <20110705120815.3cc7d59b.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110705120815.3cc7d59b.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/5/2011 3:08 PM, Ira Weiny wrote:

Can you explain what issue this solves or is it just to move to the SA
way to do this ?

> 
> Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> ---
>  include/ibdiag_common.h |    3 ++
>  src/ibdiag_common.c     |   55 +++++++++++++++++++++++++++++++++++++++++++++++
>  src/iblinkinfo.c        |    5 +--
>  src/ibqueryerrors.c     |    8 ++----
>  4 files changed, 63 insertions(+), 8 deletions(-)
> 
> diff --git a/include/ibdiag_common.h b/include/ibdiag_common.h
> index 69cddfb..e107a43 100644
> --- a/include/ibdiag_common.h
> +++ b/include/ibdiag_common.h
> @@ -126,4 +126,7 @@ void sa_report_err(int status);
>  		comp_mask |= IB_##name##_COMPMASK_##mask; \
>  	}
>  
> +int resolve_node_guid(ib_portid_t *port_id, char *node_guid,
> +			struct ibmad_port *ibmad_port);
> +
>  #endif				/* _IBDIAG_COMMON_H_ */
> diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
> index 6d03a43..66dc132 100644
> --- a/src/ibdiag_common.c
> +++ b/src/ibdiag_common.c
> @@ -509,3 +509,58 @@ void sa_report_err(int status)
>  	fprintf(stderr, "ERROR: Query result returned 0x%04x, %s%s\n",
>  		status, sm_err_str, sa_err_str);
>  }
> +
> +int resolve_node_guid(ib_portid_t *port_id, char *node_guid,
> +			struct ibmad_port *ibmad_port)
> +{
> +	ib_node_record_t nr;
> +	ib_node_record_t *found_nr;
> +	uint64_t comp_mask = 0;
> +	struct sa_query_result result;
> +	uint64_t guid = strtoull(node_guid, NULL, 0);
> +	bind_handle_t h;
> +	int ret = 0;
> +
> +	if (guid == 0 || guid == ULLONG_MAX)
> +		return -EINVAL;
> +
> +	memset(&nr, 0, sizeof(nr));
> +	CHECK_AND_SET_VAL(guid, 64, 0, nr.node_info.node_guid, NR, NODEGUID);
> +
> +	if (!ibd_timeout)
> +		ibd_timeout = MAD_DEF_TIMEOUT_MS;
> +
> +	h = sa_get_bind_handle();
> +	if (!h)
> +		return -EIO;
> +
> +	ret = sa_query(h, IB_MAD_METHOD_GET_TABLE, IB_SA_ATTR_NODERECORD, 0,
> +			   cl_hton64(comp_mask), 0, &nr, &result);
> +	if (ret) {
> +		fprintf(stderr, "Query SA failed: %s\n", ib_get_err_str(ret));
> +		ret = -EIO;
> +		goto free_bind_handle;
> +	}
> +
> +	if (result.status != IB_SA_MAD_STATUS_SUCCESS) {
> +		sa_report_err(result.status);
> +		ret = -EIO;
> +		goto free_result;
> +	}
> +
> +	if (result.result_cnt > 1)
> +		fprintf(stderr, "%s resolved to more than one port.\n",
> +			node_guid);

Should the request just be a GET rather than GET_TABLE and avoid this
check ? I don't think multiple nodes can register with same Node GUID,
can they ? Also, I think it makes eliminates this check and the missing
0 check.

> +
> +	found_nr = (ib_node_record_t *)sa_get_query_rec(result.p_result_madw,
> +							0);
> +	guid = cl_ntoh64(found_nr->node_info.port_guid);
> +	ret = ib_resolve_guid_via(port_id, &guid, NULL, ibd_timeout,
> +				  ibmad_port);

If you're avoiding the ib_resolve_portid_str_via routine, maybe also
avoid this here and do the SA PR lookup in sa query style code here ?

-- Hal

> +
> +free_result:
> +	sa_free_result_mad(&result);
> +free_bind_handle:
> +	sa_free_bind_handle(h);
> +	return ret;
> +}
> diff --git a/src/iblinkinfo.c b/src/iblinkinfo.c
> index 8cf755d..2f69acf 100644
> --- a/src/iblinkinfo.c
> +++ b/src/iblinkinfo.c
> @@ -619,9 +619,8 @@ int main(int argc, char **argv)
>  			IBWARN("Failed to resolve %s; attempting full scan\n",
>  			       dr_path);
>  	} else if (guid_str) {
> -		if ((resolved =
> -		     ib_resolve_portid_str_via(&port_id, guid_str, IB_DEST_GUID,
> -					       NULL, ibmad_port)) < 0)
> +		if ((resolved = resolve_node_guid(&port_id, guid_str,
> +						  ibmad_port)) < 0)
>  			IBWARN("Failed to resolve %s; attempting full scan\n",
>  			       guid_str);
>  	}
> diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
> index 1bba0e0..4b59c6f 100644
> --- a/src/ibqueryerrors.c
> +++ b/src/ibqueryerrors.c
> @@ -914,11 +914,9 @@ int main(int argc, char **argv)
>  			IBWARN("Failed to resolve %s; attempting full scan",
>  			       dr_path);
>  	} else if (node_guid_str) {
> -		if ((resolved =
> -		     ib_resolve_portid_str_via(&portid, node_guid_str,
> -					       IB_DEST_GUID, ibd_sm_id,
> -					       ibmad_port)) < 0)
> -			IBWARN("Failed to resolve %s; attempting full scan",
> +		if ((resolved = resolve_node_guid(&portid, node_guid_str,
> +						  ibmad_port)) < 0)
> +			IBWARN("Failed to resolve %s; attempting full scan\n",
>  			       node_guid_str);
>  	}
>  

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
