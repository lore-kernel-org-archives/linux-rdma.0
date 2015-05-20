From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 01/14] IB/mad: Clean up ib_find_send_mad
Date: Wed, 20 May 2015 12:22:21 -0600
Message-ID: <20150520182221.GF28496@obsidianresearch.com>
References: <1432109615-19564-1-git-send-email-ira.weiny@intel.com>
 <1432109615-19564-2-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1432109615-19564-2-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, May 20, 2015 at 04:13:22AM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> ib_find_send_mad only needs access to the MAD header.  Change the local
> variable to ib_mad_hdr and change the corresponding cast.
> 
> Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>  drivers/infiniband/core/mad.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
> index 600af266838c..deefe5df9697 100644
> +++ b/drivers/infiniband/core/mad.c
> @@ -1815,18 +1815,18 @@ ib_find_send_mad(const struct ib_mad_agent_private *mad_agent_priv,
>  		 const struct ib_mad_recv_wc *wc)
>  {
>  	struct ib_mad_send_wr_private *wr;
> -	struct ib_mad *mad;
> +	struct ib_mad_hdr *mad_hdr;

const

> -	mad = (struct ib_mad *)wc->recv_buf.mad;
> +	mad_hdr = (struct ib_mad_hdr *)wc->recv_buf.mad;

This casts away const.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
