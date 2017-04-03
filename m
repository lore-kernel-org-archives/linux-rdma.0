From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] IB/core: change the return type to void
Date: Mon, 3 Apr 2017 10:00:55 +0300
Message-ID: <20170403070054.GA3086@yuval-lap>
References: <1491018175-16622-1-git-send-email-yanjun.zhu@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1491018175-16622-1-git-send-email-yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Mar 31, 2017 at 11:42:55PM -0400, Zhu Yanjun wrote:
> The function ib_unregister_mad_agent always returns zero. And
> this returned value is not checked. As such, chane the return
> type to void.
> 
> CC: Joe Jin <joe.jin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> CC: Junxiao Bi <junxiao.bi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

> ---
>  drivers/infiniband/core/mad.c | 3 +--
>  include/rdma/ib_mad.h         | 2 +-
>  2 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
> index 57f231f..8a2ceb4 100644
> --- a/drivers/infiniband/core/mad.c
> +++ b/drivers/infiniband/core/mad.c
> @@ -605,7 +605,7 @@ static void unregister_mad_snoop(struct ib_mad_snoop_private *mad_snoop_priv)
>  /*
>   * ib_unregister_mad_agent - Unregisters a client from using MAD services
>   */
> -int ib_unregister_mad_agent(struct ib_mad_agent *mad_agent)
> +void ib_unregister_mad_agent(struct ib_mad_agent *mad_agent)
>  {
>  	struct ib_mad_agent_private *mad_agent_priv;
>  	struct ib_mad_snoop_private *mad_snoop_priv;
> @@ -622,7 +622,6 @@ int ib_unregister_mad_agent(struct ib_mad_agent *mad_agent)
>  					      agent);
>  		unregister_mad_snoop(mad_snoop_priv);
>  	}
> -	return 0;
>  }
>  EXPORT_SYMBOL(ib_unregister_mad_agent);
>  
> diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
> index 981214b..42814a0 100644
> --- a/include/rdma/ib_mad.h
> +++ b/include/rdma/ib_mad.h
> @@ -673,7 +673,7 @@ struct ib_mad_agent *ib_register_mad_snoop(struct ib_device *device,
>   * After invoking this routine, MAD services are no longer usable by the
>   * client on the associated QP.
>   */
> -int ib_unregister_mad_agent(struct ib_mad_agent *mad_agent);
> +void ib_unregister_mad_agent(struct ib_mad_agent *mad_agent);
>  
>  /**
>   * ib_post_send_mad - Posts MAD(s) to the send queue of the QP associated
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
