From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] infiniband: fix a possible use-after-free bug
Date: Mon, 4 Jun 2018 10:42:49 -0600
Message-ID: <20180604164249.GA32294@ziepe.ca>
References: <20180601183144.17374-1-xiyou.wangcong@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180601183144.17374-1-xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, noamr@beyondsecurity.com, Sean Hefty <sean.hefty@intel.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 01, 2018 at 11:31:44AM -0700, Cong Wang wrote:
> ucma_process_join() will free the new allocated "mc" struct,
> if there is any error after that, especially the copy_to_user().
> 
> But in parallel, ucma_leave_multicast() could find this "mc"
> through idr_find() before ucma_process_join() frees it, since it
> is already published.
> 
> So "mc" could be used in ucma_leave_multicast() after it is been
> allocated and freed in ucma_process_join(), since we don't refcnt
> it.
> 
> Fix this by separating "publish" from ID allocation, so that we
> can get an ID first and publish it later after copy_to_user().
> 
> Fixes c8f6a362bf3e ("RDMA/cma: Add multicast communication support")
> Reported-by: Noam Rathaus <noamr@beyondsecurity.com>
> Cc: Sean Hefty <sean.hefty@intel.com>
> Cc: Doug Ledford <dledford@redhat.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: linux-rdma@vger.kernel.org
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> ---
>  drivers/infiniband/core/ucma.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)

Looks good to me, and we already fixed the same sort of bug in the
non-multicast IDs.. Applied to for-next

Jason
