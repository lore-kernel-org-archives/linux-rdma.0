From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH for-rc 0/2] IB/hfi1: Fixes for rc or next if too late
Date: Mon, 4 Jun 2018 13:34:48 -0600
Message-ID: <20180604193448.GA27896@ziepe.ca>
References: <20180531182633.26542.10152.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180531182633.26542.10152.stgit@scvm10.sc.intel.com>
Sender: stable-owner@vger.kernel.org
To: Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 31, 2018 at 11:29:59AM -0700, Dennis Dalessandro wrote:
> Hi Doug and Jason,
> 
> We have two more late breaking fix up patches. The DMA_RTAIL fix is the more
> serious of the two. I realize we are at the tail end of 4.17 so I would not be
> against holding off till 4.18 for these, but if there is another rdma
> pull request we may want to tack these on.
> 
> 
> Kaike Wan (1):
>       IB/hfi1: Ensure VL index is within bounds
> 
> Mike Marciniszyn (1):
>       IB/hfi1: Fix user context tail allocation for DMA_RTAIL

applied to for-next since the merge window is open now

Thanks,
Jason
