From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] IB/{hfi1,qib}: Add limit test for RC/UC send via loopback
Date: Mon, 4 Feb 2019 16:44:54 +0100
Message-ID: <20190204154454.GB14330@kroah.com>
References: <20190204153639.2555.41856.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190204153639.2555.41856.stgit@scvm10.sc.intel.com>
Sender: stable-owner@vger.kernel.org
To: Mike Marciniszyn <mike.marciniszyn@intel.com>
Cc: stable@vger.kernel.org, linux-rdma@vger.kernel.org, stable-commits@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 04, 2019 at 07:36:42AM -0800, Mike Marciniszyn wrote:
> Upstream commit 09ce351dff8e7636af0beb72cd4a86c3904a0500.
> 
> Fix potential memory corruption and panic in loopback for
> IB_WR_SEND varaiants.
> 
> The code blindly assumes the posted length will fit in the
> fetched rwqe, which is not a valid assumption.
> 
> Fix by adding a limit test, and triggering the appropriate
> send completion and putting the QP in an error state.  This
> mimics the handling for non-loopback QPs.
> 
> [ported to older kernels where the loopback was in each driver]
> 
> Cc: <stable@vger.kernel.org> #v4.9+
> Fixes: 7724105686e7 ("IB/hfi1: add driver files")
> Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
> Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
> ---
>  drivers/infiniband/hw/hfi1/ruc.c    |    7 ++++++-
>  drivers/infiniband/hw/qib/qib_ruc.c |    7 ++++++-
>  2 files changed, 12 insertions(+), 2 deletions(-)

What stable kernel(s) is this backport for?

thanks,

greg k-h
