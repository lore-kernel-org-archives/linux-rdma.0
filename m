From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] MAINTAINERS: add include/rdma/ to InfiniBand subsystem
Date: Mon, 4 May 2015 18:35:22 -0400
Message-ID: <20150504223521.GC10115@phlsvsds.ph.intel.com>
References: <1430742663-423-1-git-send-email-ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1430742663-423-1-git-send-email-ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, May 04, 2015 at 02:31:03PM +0200, Yann Droneaud wrote:
> Most headers for InfiniBand/RDMA are located under
> include/rdma/ and include/uapi/rdma.
> 
> Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

> ---
> Hi,
> 
> While checking if Doug Ledford was added as maintainer for IB subsystem
> (and git tree updated), I've found the headers in rdma/ were not identified
> as being part of IB subsystem.
> 
> Regards.
> 
> 
> MAINTAINERS | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 781e099495d3..c80714ad3114 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5053,6 +5053,8 @@ S:	Supported
>  F:	Documentation/infiniband/
>  F:	drivers/infiniband/
>  F:	include/uapi/linux/if_infiniband.h
> +F:	include/uapi/rdma/
> +F:	include/rdma/
>  
>  INOTIFY
>  M:	John McCutchan <john-jueV0HHMeujJJrXXpGQQMAC/G2K4zDHf@public.gmane.org>
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
