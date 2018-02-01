From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH for-next 3/6] IB/hfi1: Optimize packet type comparison
 using 9B and bypass code paths
Date: Thu, 1 Feb 2018 15:40:32 -0700
Message-ID: <20180201224032.GC17053@ziepe.ca>
References: <20180201184446.5918.46068.stgit@scvm10.sc.intel.com>
 <20180201184620.5918.82548.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180201184620.5918.82548.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 01, 2018 at 10:46:23AM -0800, Dennis Dalessandro wrote:
>  
> +static inline bool opa_bth_is_migration(struct ib_other_headers *ohdr)
> +{
> +	return !!(ohdr->bth[1] & cpu_to_be32(OPA_BTH_MIG_REQ));
> +}
> +
>  extern const enum ib_wc_opcode ib_hfi1_wc_opcode[];
>  
>  extern const u8 hdr_len_by_opcode[];
> diff --git a/include/rdma/ib_hdrs.h b/include/rdma/ib_hdrs.h
> index 6a86d14..2aa19ec 100644
> +++ b/include/rdma/ib_hdrs.h
> @@ -335,4 +335,9 @@ static inline bool ib_bth_is_solicited(struct ib_other_headers *ohdr)
>  {
>  	return !!(ohdr->bth[0] & cpu_to_be32(IB_BTH_SOLICITED));
>  }
> +
> +static inline bool ib_bth_is_migration(struct ib_other_headers *ohdr)
> +{
> +	return !!(ohdr->bth[0] & cpu_to_be32(IB_BTH_MIG_REQ));
> +}
>  #endif                          /* IB_HDRS_H */

No on the !! - the cast to 'bool' causes the compiler to do this
automatically and is clearer. This is why we have 'bool'

I fixed the patch for you, please send another patch to get rid of the
other !! in boolean contexts I saw in this code.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
