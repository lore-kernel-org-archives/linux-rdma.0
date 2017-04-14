From: Honggang LI <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/3] srp_daemon/srp_daemon.c: Eliminate some
 unneeded code in get_shared_pkeys
Date: Fri, 14 Apr 2017 08:34:06 +0800
Message-ID: <20170414003406.GB1314@dhcp-13-42.nay.redhat.com>
References: <a14febfc-a190-6ca8-5dca-dec58f5a3bce@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <a14febfc-a190-6ca8-5dca-dec58f5a3bce-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 13, 2017 at 10:48:25AM -0400, Hal Rosenstock wrote:
> 
> PathRecords are obtained using SubAdmGet and not SubAdmGetTable
> so RMPP is not involved. Eliminate unneeded initialization of MAD
> RMPP fields.
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  srp_daemon/srp_daemon.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/srp_daemon/srp_daemon.c b/srp_daemon/srp_daemon.c
> index 9fb2ecc..59a6137 100644
> --- a/srp_daemon/srp_daemon.c
> +++ b/srp_daemon/srp_daemon.c
> @@ -1134,8 +1134,6 @@ static int get_shared_pkeys(struct resources *res,
>  
>  		/* Mark components: DLID, SLID, PKEY */
>  		out_sa_mad->comp_mask = htobe64(1 << 4 | 1 << 5 | 1 << 13);
> -		out_sa_mad->rmpp_hdr.rmpp_version = UMAD_RMPP_VERSION;
> -		out_sa_mad->rmpp_hdr.rmpp_type = 1;
>  		path_rec = (struct ib_path_rec *)out_sa_mad->data;
>  		path_rec->slid = htobe16(local_port_lid);
>  		path_rec->dlid = htobe16(dest_port_lid);
> -- 
> 1.8.2.3
> 

Reviewed-by: Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
