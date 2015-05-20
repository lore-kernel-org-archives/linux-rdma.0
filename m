From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 14/14] IB/mad: Add final OPA MAD processing
Date: Wed, 20 May 2015 12:59:01 -0600
Message-ID: <20150520185901.GK28496@obsidianresearch.com>
References: <1432109615-19564-1-git-send-email-ira.weiny@intel.com>
 <1432109615-19564-15-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1432109615-19564-15-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, May 20, 2015 at 04:13:35AM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> @@ -433,14 +436,23 @@ static inline int get_mad_len(struct mad_rmpp_recv *rmpp_recv)
>  {
>  	struct ib_rmpp_base *rmpp_base;
>  	int hdr_size, data_size, pad;
> +	int opa = rdma_cap_opa_mad(rmpp_recv->agent->qp_info->port_priv->device,
> +				   rmpp_recv->agent->qp_info->port_priv->port_num);

bool opa

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
