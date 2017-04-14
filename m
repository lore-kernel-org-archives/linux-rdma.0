From: Honggang LI <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/3] srp_daemon/srp_daemon.c: Don't rely on
 attribute offset, in get_shared_pkeys
Date: Fri, 14 Apr 2017 08:33:20 +0800
Message-ID: <20170414003320.GA1314@dhcp-13-42.nay.redhat.com>
References: <b3cbb29e-25bf-1785-7a60-8e8d7cab74e3@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b3cbb29e-25bf-1785-7a60-8e8d7cab74e3-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 13, 2017 at 10:48:00AM -0400, Hal Rosenstock wrote:
> 
> get_shared_pkeys has been using SubAdmGet rather than SubAdmGetTable since
> commit 2ad09524931dbf98d412e1912c1bdbf22f8ac81d
> srp_daemon: Work around SM bug over non-default P_Key support
> 
> so RMPP is no longer used in response so it's not safe to
> rely on AttributeOffset field. Good MAD status is sufficient
> to say that valid PathRecord was returned.
> 
> Found-by: Honggang LI <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> using embedded subnet manager running on an Intel True Scale
> Edge Switch 12300.
> 
> This has been broken since srptools-1.0.1 which was first
> release containing commit mentioned above.
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  srp_daemon/srp_daemon.c | 9 ---------
>  1 file changed, 9 deletions(-)
> 
> diff --git a/srp_daemon/srp_daemon.c b/srp_daemon/srp_daemon.c
> index 71b5f07..9fb2ecc 100644
> --- a/srp_daemon/srp_daemon.c
> +++ b/srp_daemon/srp_daemon.c
> @@ -1102,7 +1102,6 @@ static int get_shared_pkeys(struct resources *res,
>  	struct umad_sa_packet	       *out_sa_mad, *in_sa_mad;
>  	struct ib_path_rec	       *path_rec;
>  	ssize_t len;
> -	int size;
>  	int i, num_pkeys = 0;
>  	uint16_t pkey;
>  	uint16_t local_port_lid = get_port_lid(res->ud_res->ib_ctx,
> @@ -1148,14 +1147,6 @@ static int get_shared_pkeys(struct resources *res,
>  		if (len < 0)
>  			goto err;
>  
> -		size = ib_get_attr_size(in_sa_mad->attr_offset);
> -		if (!size) {
> -			if (config->verbose)
> -				printf("PathRec Query did not find any targets "
> -				       "over P_Key %x\n", pkey);
> -			continue;
> -		}
> -
>  		path_rec = (struct ib_path_rec *)in_sa_mad->data;
>  		pkeys[num_pkeys++] = be16toh(path_rec->pkey);
>  	}
> -- 

Reviewed-by: Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
