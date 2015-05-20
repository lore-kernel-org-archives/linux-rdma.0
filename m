From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 10/14] IB/mad: Add MAD size parameters to process_mad
Date: Wed, 20 May 2015 12:49:14 -0600
Message-ID: <20150520184914.GI28496@obsidianresearch.com>
References: <1432109615-19564-1-git-send-email-ira.weiny@intel.com>
 <1432109615-19564-11-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1432109615-19564-11-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, May 20, 2015 at 04:13:31AM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:

> +
> +	if (WARN_ON(in_mad_size != sizeof(*in_mad) ||
> +		    *out_mad_size != sizeof(*out_mad)))
> +		return IB_MAD_RESULT_FAILURE;

This is really a BUG_ON scenario..

> @@ -1693,8 +1693,10 @@ struct ib_device {
>  						  u8 port_num,
>  						  struct ib_wc *in_wc,
>  						  struct ib_grh *in_grh,
> -						  struct ib_mad *in_mad,
> -						  struct ib_mad *out_mad);
> +						  struct ib_mad_hdr *in_mad,
> +						  size_t in_mad_size,
> +						  struct ib_mad_hdr *out_mad,
> +						  size_t
>  						  *out_mad_size);

const for input parameters. You should look at all the patches for
this, I noticed a few more smaller ones I didn't comment on.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
