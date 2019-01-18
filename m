From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH for-rc 7/7] IB/hfi1: Add limit test for RC/UC send via
 loopback
Date: Fri, 18 Jan 2019 14:04:25 -0700
Message-ID: <20190118210425.GA21123@ziepe.ca>
References: <20190117203920.30826.76720.stgit@scvm10.sc.intel.com>
 <20190117204209.30826.62040.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190117204209.30826.62040.stgit@scvm10.sc.intel.com>
Sender: stable-owner@vger.kernel.org
To: Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 17, 2019 at 12:42:16PM -0800, Dennis Dalessandro wrote:
> From: Mike Marciniszyn <mike.marciniszyn@intel.com>
> 
> Fix potential memory corruption and panic in loopback for
> IB_WR_SEND variants.
> 
> The code blindly assumes the posted length will fit in the
> fetched rwqe, which is not a valid assumption.
> 
> Fix by adding a limit test, and triggering the appropriate
> send completion and putting the QP in an error state.  This
> mimics the handling for non-loopback QPs.
> 
> Fixes: 15703461533a ("IB/{hfi1, qib, rdmavt}: Move ruc_loopback to rdmavt")
> Cc: <stable@vger.kernel.org> #v4.20+
> Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
> Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
> ---
>  drivers/infiniband/sw/rdmavt/qp.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)

Applied to for-rc

Thanks,
Jason
