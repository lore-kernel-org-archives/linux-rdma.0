From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH opensm 2/2] Try default parition config if parsing the
 partitions.conf failed
Date: Tue, 22 Oct 2013 02:08:08 -0400
Message-ID: <52661648.3020204@dev.mellanox.co.il>
References: <20131017111041.177713.61634.stgit@fsdevel2> <20131017111052.177713.67832.stgit@fsdevel2>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131017111052.177713.67832.stgit@fsdevel2>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Bernd,

On 10/17/2013 7:10 AM, Bernd Schubert wrote:
> If partitions.conf is for some reasons invalid or empty, try again
> with the default configuration.
> 
> This will re-use the default configuration created by prtn_make_default(),
> but osm_prtn_make_new() will automatically overwrite the initial default.

This seems like a better "policy". The admin now will need to notice
that he might not have gotten the partitioning he was trying to instill
in the subnet. Before he would not miss this because the result was more
severe.

> Signed-off-by: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
> ---
>  opensm/osm_prtn.c        |   11 ++++++++++-
>  opensm/osm_prtn_config.c |   11 ++++++++++-
>  2 files changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/opensm/osm_prtn.c b/opensm/osm_prtn.c
> index e76e2e1..4db7e7a 100644
> --- a/opensm/osm_prtn.c
> +++ b/opensm/osm_prtn.c
> @@ -376,6 +376,7 @@ ib_api_status_t osm_prtn_make_partitions(osm_log_t * p_log, osm_subn_t * p_subn)
>  	struct stat statbuf;
>  	const char *file_name;
>  	boolean_t is_config = TRUE;
> +	boolean_t is_wrong_config = FALSE;
>  	ib_api_status_t status = IB_SUCCESS;
>  	cl_map_item_t *p_next;
>  	osm_prtn_t *p;
> @@ -389,6 +390,7 @@ ib_api_status_t osm_prtn_make_partitions(osm_log_t * p_log, osm_subn_t * p_subn)
>  		is_config = FALSE;
>  	}
>  
> +retry_default:
>  	/* clean up current port maps */
>  	p_next = cl_qmap_head(&p_subn->prtn_pkey_tbl);
>  	while (p_next != cl_qmap_end(&p_subn->prtn_pkey_tbl)) {
> @@ -404,9 +406,11 @@ ib_api_status_t osm_prtn_make_partitions(osm_log_t * p_log, osm_subn_t * p_subn)
>  	if (status != IB_SUCCESS)
>  		goto _err;
>  
> -	if (is_config && osm_prtn_config_parse_file(p_log, p_subn, file_name))
> +	if (is_config && osm_prtn_config_parse_file(p_log, p_subn, file_name)) {
>  		OSM_LOG(p_log, OSM_LOG_VERBOSE, "Partition configuration "
>  			"was not fully processed\n");
> +		is_wrong_config = TRUE;
> +	}
>  
>  	/* and now clean up empty partitions */
>  	p_next = cl_qmap_head(&p_subn->prtn_pkey_tbl);
> @@ -421,6 +425,11 @@ ib_api_status_t osm_prtn_make_partitions(osm_log_t * p_log, osm_subn_t * p_subn)
>  		}
>  	}
>  
> +	if (is_config && is_wrong_config) {
> +		is_config = FALSE;
> +		goto retry_default;
> +	}
> +
>  _err:
>  	return status;
>  }
> diff --git a/opensm/osm_prtn_config.c b/opensm/osm_prtn_config.c
> index 8f4a673..e916582 100644
> --- a/opensm/osm_prtn_config.c
> +++ b/opensm/osm_prtn_config.c
> @@ -696,6 +696,9 @@ done:
>  	return len;
>  }
>  
> +/**
> + * @return -1 on error, 0 on success
> + */
>  int osm_prtn_config_parse_file(osm_log_t * p_log, osm_subn_t * p_subn,
>  			       const char *file_name)
>  {
> @@ -703,6 +706,7 @@ int osm_prtn_config_parse_file(osm_log_t * p_log, osm_subn_t * p_subn,
>  	struct part_conf *conf = NULL;
>  	FILE *file;
>  	int lineno;
> +	boolean_t is_parse_success = FALSE;
>  
>  	file = fopen(file_name, "r");
>  	if (!file) {
> @@ -753,6 +757,8 @@ int osm_prtn_config_parse_file(osm_log_t * p_log, osm_subn_t * p_subn,
>  				break;
>  			}
>  
> +			is_parse_success = TRUE;

Doesn't this set is_parse_success on first good parseable line in
partition config ? I think easiest change is to set is_parse_success to
TRUE at top of routine and in the 2 places in this routine where parsing
can fail set it to FALSE. Does that make sense ?

-- Hal

> +
>  			p += len;
>  
>  			if (q) {
> @@ -764,5 +770,8 @@ int osm_prtn_config_parse_file(osm_log_t * p_log, osm_subn_t * p_subn,
>  
>  	fclose(file);
>  
> -	return 0;
> +	if (is_parse_success)
> +		return 0;
> +	else
> +		return -1;
>  }
> 
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
