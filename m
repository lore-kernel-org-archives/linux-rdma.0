From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RESEND v3 5/6] staging/rdma/hfi1: adding per SDMA engine stats to hfistats
Date: Thu, 3 Mar 2016 21:02:47 -0500
Message-ID: <20160304020246.GA27588@phlsvsds.ph.intel.com>
References: <1452555057-5155-1-git-send-email-jubin.john@intel.com> <1452555057-5155-6-git-send-email-jubin.john@intel.com> <56D5B567.4040706@redhat.com> <20160301202736.GA8501@phlsvsds.ph.intel.com> <56D85D51.40800@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56D85D51.40800-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Vennila Megavannan <vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 03, 2016 at 10:50:41AM -0500, Doug Ledford wrote:
> On 03/01/2016 03:27 PM, Jubin John wrote:
> >>> diff --git a/drivers/staging/rdma/hfi1/sdma.c b/drivers/staging/rdma/hfi1/sdma.c
> >>> index 1d38be5..cb66bd0 100644
> >>> --- a/drivers/staging/rdma/hfi1/sdma.c
> >>> +++ b/drivers/staging/rdma/hfi1/sdma.c
> >>> @@ -1061,7 +1061,6 @@ int sdma_init(struct hfi1_devdata *dd, u8 port)
> >>>  		sde->desc_avail = sdma_descq_freecnt(sde);
> >>>  		sde->sdma_shift = ilog2(descq_cnt);
> >>>  		sde->sdma_mask = (1 << sde->sdma_shift) - 1;
> >>> -		sde->descq_full_count = 0;
> >>>  
> >>>  		/* Create a mask for all 3 chip interrupt sources */
> >>>  		sde->imask = (u64)1 << (0*TXE_NUM_SDMA_ENGINES + this_idx)
> >>> @@ -1073,6 +1072,8 @@ int sdma_init(struct hfi1_devdata *dd, u8 port)
> >>>  		/* Create a mask specifically for sdma_progress */
> >>>  		sde->progress_mask =
> >>>  			(u64)1 << (TXE_NUM_SDMA_ENGINES + this_idx);
> >>> +		sde->int_mask =
> >>> +			(u64)1 << (0 * TXE_NUM_SDMA_ENGINES + this_idx);
> >>                                    ^^^^^^^^^^^^^^^^^^^^^^^^
> >> Why is that there?
> >>
> > 
> > Hi Doug,
> > 
> > The zero was intentionally added in an attempt to highlight that this
> > was for the first interrupt source, like we do in other places above this
> > where we have 1 * TXE_NUM_SDMA_ENGINES, 2 * TXE_NUM_SDMA_ENGINES etc.
> > The interrupt sources are separated by the number of SDMA engines
> > i.e TXE_NUM_SDMA_ENGINES. However, we agree that the code is not
> > consistent throughout. Would you like us to do a cleanup of this code
> > in a follow-on patch or rework this patch and resend the series?
> > 
> > Jubin
> > 
> 
> Thanks, the code is confusing to read, so a cleanup would be nice.  Just
> send me something I can squash into this patch is good enough.

I have sent a cleanup patch to be squashed into this patch.
https://patchwork.kernel.org/patch/8497581/

Jubin
> 
> -- 
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>               GPG KeyID: 0E572FDD
> 
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
