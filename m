From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2 infiniband-diags] ibqueryerrors: Resource leak in path_record_query
Date: Wed, 22 Apr 2015 10:56:57 -0400
Message-ID: <20150422145656.GD28220@phlsvsds.ph.intel.com>
References: <55363F50.3050905@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55363F50.3050905-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 21, 2015 at 08:15:12AM -0400, Hal Rosenstock wrote:
> From: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Date: Thu Apr 16 16:39:43 2015 +0300
>     
> sa_free_handle function is not called at the end of
> path_record_query function.
> The patch fixes file descriptor leak when path_record_query
> function is called.
>     
> Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Applied Thanks,
Ira

>
> ---
>  src/ibqueryerrors.c |   34 +++++++++++++++++++++++++++-------
>  1 files changed, 27 insertions(+), 7 deletions(-)
> 
> diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
> index 9d9ec45..8fbb9d1 100644
> --- a/src/ibqueryerrors.c
> +++ b/src/ibqueryerrors.c
> @@ -344,6 +344,7 @@ static int path_record_query(ib_gid_t sgid,uint64_t dguid)
>                          (uint16_t)IB_SA_ATTR_PATHRECORD,0,cl_ntoh64(comp_mask),ibd_sakey,
>                          &pr, sizeof(pr), &result);
>       if (ret) {
> +             sa_free_handle(h);
>               fprintf(stderr, "Query SA failed: %s; sa call path_query failed\n", strerror(ret));
>               return ret;
>       }
> @@ -355,6 +356,7 @@ static int path_record_query(ib_gid_t sgid,uint64_t dguid)
> 
>       insert_lid2sl_table(&result);
>  Exit:
> +     sa_free_handle(h);
>       sa_free_result_mad(&result);
>       return ret;
>  }
> -- 
> 1.7.8.2
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
