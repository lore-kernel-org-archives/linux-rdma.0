From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH opensm] Add support for synchronizing in memory files
 with storage
Date: Sat, 21 Dec 2013 10:49:48 +0100
Message-ID: <52B5643C.7070806@acm.org>
References: <52B4C553.9030109@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52B4C553.9030109-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jim Mott <jim-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/20/13 23:31, Hal Rosenstock wrote:
> -int osm_db_store(IN osm_db_domain_t * p_domain)
> +int osm_db_store(IN osm_db_domain_t * p_domain,
> +		 IN boolean_t fsync_high_avail_files)
>  {
>  	osm_log_t *p_log = p_domain->p_db->p_log;
>  	osm_db_domain_imp_t *p_domain_imp;
>  	FILE *p_file = NULL;
> -	int status = 0;
> +	int fd, status = 0;
>  	char *p_tmp_file_name = NULL;
>  
>  	OSM_LOG_ENTER(p_log);
> @@ -494,6 +496,21 @@ int osm_db_store(IN osm_db_domain_t * p_domain)
>  	}
>  
>  	st_foreach(p_domain_imp->p_hash, dump_tbl_entry, (st_data_t) p_file);
> +
> +	if (fsync_high_avail_files) {
> +		fd = fileno(p_file);
> +		if (fd != -1) {
> +			if (fsync(fd) == -1)
> +				OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 6110: "
> +					"fsync failed (%s) for %s\n",
> +					strerror(errno),
> +					p_domain_imp->file_name);
> +		} else
> +			OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 6111: "
> +				"fileno() failed for %s\n",
> +				p_domain_imp->file_name);
> +	}
> +
>  	fclose(p_file);
>  
>  	status = rename(p_tmp_file_name, p_domain_imp->file_name);

Shouldn't fflush() be invoked before calling fsync() ? Sorry that I
wasn't more explicit in my previous review comment. A complete example
can be found on slide 87 of
https://www.flamingspork.com/talks/2007/06/eat_my_data.odp.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
