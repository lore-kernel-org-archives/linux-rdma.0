From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv2 1/4 infiniband-diags] ibqueryerrors: Fix crash when no SM is running
Date: Fri, 3 Jul 2015 11:22:57 -0400
Message-ID: <20150703152256.GE15224@phlsvsds.ph.intel.com>
References: <553D3D98.3040905@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <553D3D98.3040905-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Apr 26, 2015 at 03:33:44PM -0400, Hal Rosenstock wrote:
> From: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Date: Tue, 21 Apr 2015 17:12:05 +0300
> 
> Handle sa_get_handle error in path_record_query
> 
> Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks applied,
Ira

> ---
> Changes since v1:
> Added my signoff on this patch
> 
>  src/ibqueryerrors.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
> index 8fbb9d1..97a555d 100644
> --- a/src/ibqueryerrors.c
> +++ b/src/ibqueryerrors.c
> @@ -326,7 +326,9 @@ static int path_record_query(ib_gid_t sgid,uint64_t dguid)
>       uint8_t reversible = 0;
>       struct sa_handle * h;
>  
> -     h = sa_get_handle();
> +     if (!(h = sa_get_handle()))
> +	return -1;
> +
>       ibd_timeout = DEFAULT_HALF_WORLD_PR_TIMEOUT;
>       memset(&pr, 0, sizeof(pr));
>  
> -- 
> 1.7.8.2
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
