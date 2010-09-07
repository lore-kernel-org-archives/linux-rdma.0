From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_db_files.c: remove bad free() call
Date: Tue, 7 Sep 2010 22:51:31 +0300
Message-ID: <20100907195131.GK11502@me>
References: <4C865190.3070904@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4C865190.3070904-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 17:52 Tue 07 Sep     , Yevgeny Kliteynik wrote:
> p_key is a parameter, and it is char[].
> It shouldn't be freed here.

I don't see this. st_delete() call:

        if (st_delete(p_domain_imp->p_hash,
	    (void *)&p_key, (void *)&p_prev_val)) {
		...
		free(p_key);
		...
	}

overwrites those value by pointers to key values stored in the hash
table (then 1 is returned).

Sasha

> 
> Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> ---
>  opensm/opensm/osm_db_files.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/opensm/opensm/osm_db_files.c b/opensm/opensm/osm_db_files.c
> index dd9f772..c475004 100644
> --- a/opensm/opensm/osm_db_files.c
> +++ b/opensm/opensm/osm_db_files.c
> @@ -582,7 +582,6 @@ int osm_db_delete(IN osm_db_domain_t * p_domain, IN char *p_key)
>  				p_key, p_domain_imp->file_name, p_prev_val);
>  			res = 1;
>  		} else {
> -			free(p_key);
>  			free(p_prev_val);
>  			res = 0;
>  		}
> -- 
> 1.6.2.4
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
