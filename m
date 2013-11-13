From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH opensm] Implement atomic update operation for sa_db_file
Date: Wed, 13 Nov 2013 19:00:18 +0100
Message-ID: <5283BE32.5070804@acm.org>
References: <5283A88D.9020608@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5283A88D.9020608-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/13/13 17:27, Hal Rosenstock wrote:
>
> From: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>   opensm/osm_sa.c |   20 ++++++++++++++++----
>   1 files changed, 16 insertions(+), 4 deletions(-)
>
> diff --git a/opensm/osm_sa.c b/opensm/osm_sa.c
> index 8c5ef5d..d5c1275 100644
> --- a/opensm/osm_sa.c
> +++ b/opensm/osm_sa.c
> @@ -525,25 +525,37 @@ opensm_dump_to_file(osm_opensm_t * p_osm, const char *file_name,
>   		    void (*dump_func) (osm_opensm_t * p_osm, FILE * file))
>   {
>   	char path[1024];
> +	char path_tmp[1032];
>   	FILE *file;
> +	int status = 0;
>
>   	snprintf(path, sizeof(path), "%s/%s",
>   		 p_osm->subn.opt.dump_files_dir, file_name);
>
> -	file = fopen(path, "w");
> +	snprintf(path_tmp, sizeof(path_tmp), "%s.tmp", path);
> +
> +	file = fopen(path_tmp, "w");
>   	if (!file) {
>   		OSM_LOG(&p_osm->log, OSM_LOG_ERROR, "ERR 4C01: "
>   			"cannot open file \'%s\': %s\n",
> -			file_name, strerror(errno));
> +			path_tmp, strerror(errno));
>   		return -1;
>   	}
>
> -	chmod(path, S_IRUSR | S_IWUSR);
> +	chmod(path_tmp, S_IRUSR | S_IWUSR);
>
>   	dump_func(p_osm, file);
>
>   	fclose(file);
> -	return 0;
> +
> +	status = rename(path_tmp, path);
> +	if (status) {
> +		OSM_LOG(&p_osm->log, OSM_LOG_ERROR, "ERR 4C0B: "
> +			"Failed to rename file:%s (err:%s)\n",
> +			path_tmp, strerror(errno));
> +	}
> +
> +	return status;
>   }
>
>   static void mcast_mgr_dump_one_port(cl_map_item_t * p_map_item, void *cxt)

Isn't an fdatasync() call missing after dump_func() and before fclose() 
? According to Theodore Ts'o calling fdatasync() or fsync() before 
fclose() is essential during an atomic update. See also 
http://thunk.org/tytso/blog/2009/03/15/dont-fear-the-fsync/ for more 
information.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
