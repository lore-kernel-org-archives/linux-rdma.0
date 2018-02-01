From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH for-next] IB/core: Avoid a potential OOPs for an unused
 optional parameter
Date: Thu, 1 Feb 2018 15:52:35 -0700
Message-ID: <20180201225235.GI8590@ziepe.ca>
References: <20180201203103.11832.81537.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180201203103.11832.81537.stgit@scvm10.sc.intel.com>
Sender: stable-owner@vger.kernel.org
To: Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Ira Weiny <ira.weiny@intel.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 01, 2018 at 12:31:06PM -0800, Dennis Dalessandro wrote:
> From: Michael J. Ruhl <michael.j.ruhl@intel.com>
> 
> The ev_file is an optional parameter for CQ creation. If the parameter
> is not passed, the ev_file pointer will be NULL.  Using that pointer
> to set the cq_context will result in an OOPs.
> 
> Verify that ev_file is not NULL before using.
> 
> Cc: <stable@vger.kernel.org> # 4.14.x
> Fixes: 9ee79fce3642 ("IB/core: Add completion queue (cq) object actions")
> Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
>  drivers/infiniband/core/uverbs_std_types.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Yep! I was testing this recently and didn't hit this bug, it only
becomes a crash if something tries to use the cq..

Jason
