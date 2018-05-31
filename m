From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH for-rc 0/2] IB/hfi1: Fixes for rc or next if too late
Date: Thu, 31 May 2018 14:21:09 -0600
Message-ID: <20180531202109.GE4485@ziepe.ca>
References: <20180531182633.26542.10152.stgit@scvm10.sc.intel.com>
 <b9791f286ef1be4def5085353a9ee7975957b2d8.camel@redhat.com>
 <6fa4efc3-621e-7411-b72b-ab42c18d1e86@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6fa4efc3-621e-7411-b72b-ab42c18d1e86@intel.com>
Sender: stable-owner@vger.kernel.org
To: Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 31, 2018 at 03:08:56PM -0400, Dennis Dalessandro wrote:
> On 5/31/2018 2:47 PM, Doug Ledford wrote:
> >On Thu, 2018-05-31 at 11:29 -0700, Dennis Dalessandro wrote:
> >>Hi Doug and Jason,
> >>
> >>We have two more late breaking fix up patches. The DMA_RTAIL fix is the more
> >>serious of the two. I realize we are at the tail end of 4.17 so I would not be
> >>against holding off till 4.18 for these, but if there is another rdma
> >>pull request we may want to tack these on.
> >>
> >>
> >>Kaike Wan (1):
> >>       IB/hfi1: Ensure VL index is within bounds
> >>
> >>Mike Marciniszyn (1):
> >>       IB/hfi1: Fix user context tail allocation for DMA_RTAIL
> >>
> >>
> >>  drivers/infiniband/hw/hfi1/chip.c     |    8 ++++----
> >>  drivers/infiniband/hw/hfi1/file_ops.c |    2 +-
> >>  drivers/infiniband/hw/hfi1/init.c     |    9 ++++-----
> >>  drivers/infiniband/hw/hfi1/sdma.c     |   12 +++---------
> >>  4 files changed, 12 insertions(+), 19 deletions(-)
> >>
> >
> >Hi Denny,
> >
> >These two patches look fine in terms of the patches themselves.  In
> >terms of whether to put them in for-rc or for-next, what's the
> >consequences of hitting each of these bugs?
> >
> 
> The VL index, could be bad because it would jump beyond the end of the
> array. However, we won't actually hit that with the code the way it
> currently is because of the way we validate the VL in other areas of the
> code. This is more of a we better fix it before we do end up with a problem
> sort of thing.

Theoretical future bugs are not rc or stable material

> In the other one, the DMA_RTAIL one, the driver ends up mmaping NULL and
> handing that user space. This only happens though if users muck with the
> CAP_MASK and enable the dma of the rtail. Which is not the default. Mike
> found this through code inspection I believe.

> So they do fix serious flaws, but the likelihood of actually hitting them is
> very slim. Based on the stable tag on Mike's patch we have had this since
> 4.9.

I think it is too late for more -rc stuff..

The last -rc (assuming rc7 is the end) pull request needs to go
tomorrow morning and we like it to have -rc stuff sit in -next for at
least a day before sending to Linus :\

Jason
