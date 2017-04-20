From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 02/26] IB/ocrdma: Use kcalloc() in
 ocrdma_mbx_alloc_pd_range()
Date: Thu, 20 Apr 2017 16:40:58 -0400
Message-ID: <1492720858.3041.17.camel@redhat.com>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
         <7abcae42-6bc2-0653-69ea-5112943ff72e@users.sourceforge.net>
         <20170308140304.GC4828@yuval-lap>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170308140304.GC4828@yuval-lap>
Sender: linux-kernel-owner@vger.kernel.org
To: Yuval Shaia <yuval.shaia@oracle.com>, SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-rdma@vger.kernel.org, Devesh Sharma <devesh.sharma@avagotech.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Selvin Xavier <selvin.xavier@avagotech.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-03-08 at 16:03 +0200, Yuval Shaia wrote:
> On Wed, Mar 08, 2017 at 01:41:00PM +0100, SF Markus Elfring wrote:
> > 
> > From: Markus Elfring <elfring@users.sourceforge.net>
> > Date: Tue, 7 Mar 2017 18:23:54 +0100
> > 
> > * Multiplications for the size determination of memory allocations
> >   indicated that array data structures should be processed.
> >   Thus reuse the corresponding function "kcalloc".
> > 
> >   This issue was detected by using the Coccinelle software.
> > 
> > * Delete the local variable "pd_bitmap_size" which became
> > unnecessary with
> >   this refactoring.
> > 
> > Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> > ---
> >  drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 16 ++++++++--------
> >  1 file changed, 8 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> > b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> > index cbac41b15d94..d5a3127b6df8 100644
> > --- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> > +++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> > @@ -1505,7 +1505,6 @@ int ocrdma_mbx_dealloc_pd(struct ocrdma_dev
> > *dev, struct ocrdma_pd *pd)
> >  static int ocrdma_mbx_alloc_pd_range(struct ocrdma_dev *dev)
> >  {
> >  	int status = -ENOMEM;
> > -	size_t pd_bitmap_size;
> >  	struct ocrdma_alloc_pd_range *cmd;
> >  	struct ocrdma_alloc_pd_range_rsp *rsp;
> >  
> > @@ -1527,10 +1526,10 @@ static int ocrdma_mbx_alloc_pd_range(struct
> > ocrdma_dev *dev)
> >  			dev->pd_mgr->pd_dpp_start = rsp-
> > >dpp_page_pdid &
> >  					OCRDMA_ALLOC_PD_RNG_RSP_ST
> > ART_PDID_MASK;
> >  			dev->pd_mgr->max_dpp_pd = rsp->pd_count;
> > -			pd_bitmap_size =
> > -				BITS_TO_LONGS(rsp->pd_count) *
> > sizeof(long);
> > -			dev->pd_mgr->pd_dpp_bitmap =
> > kzalloc(pd_bitmap_size,
> > -							     GFP_K
> > ERNEL);
> > +			dev->pd_mgr->pd_dpp_bitmap
> > +				= kcalloc(BITS_TO_LONGS(rsp-
> > >pd_count),
> > +							sizeof(lon
> > g),
> > +							GFP_KERNEL
> > );
> 
> kzalloc gives "clean" buffer.
> Just making sure that it is fine with you if the array is not
> "clean".
> (looking at _ocrdma_pd_mgr_get_bitmap i think it should).

kcalloc is documented to return memory set to 0.

> > 
> >  		}
> >  		kfree(cmd);
> >  	}
> > @@ -1546,9 +1545,10 @@ static int ocrdma_mbx_alloc_pd_range(struct
> > ocrdma_dev *dev)
> >  		dev->pd_mgr->pd_norm_start = rsp->dpp_page_pdid &
> >  					OCRDMA_ALLOC_PD_RNG_RSP_ST
> > ART_PDID_MASK;
> >  		dev->pd_mgr->max_normal_pd = rsp->pd_count;
> > -		pd_bitmap_size = BITS_TO_LONGS(rsp->pd_count) *
> > sizeof(long);
> > -		dev->pd_mgr->pd_norm_bitmap =
> > kzalloc(pd_bitmap_size,
> > -						      GFP_KERNEL);
> > +		dev->pd_mgr->pd_norm_bitmap
> > +			= kcalloc(BITS_TO_LONGS(rsp->pd_count),
> > +						sizeof(long),
> > +						GFP_KERNEL);
> >  	}
> >  	kfree(cmd);
> >  
> > -- 
> > 2.12.0
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-
> > rdma" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
