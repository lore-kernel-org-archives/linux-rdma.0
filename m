From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] IB/srp: Avoid that sg_reset -d ${srp_device} triggers an
 infinite loop
Date: Wed, 19 Sep 2018 15:31:40 -0600
Message-ID: <20180919213140.GA18096@ziepe.ca>
References: <20180918011005.8275-1-bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180918011005.8275-1-bvanassche@acm.org>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Max Gurtovoy <maxg@mellanox.com>, Laurence Oberman <loberman@redhat.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 17, 2018 at 06:10:05PM -0700, Bart Van Assche wrote:
> Use different loop variables for the inner and outer loop. This avoids
> that an infinite loop occurs if there are more RDMA channels than
> target->req_ring_size.
> 
> Fixes: d92c0da71a35 ("IB/srp: Add multichannel support")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: Max Gurtovoy <maxg@mellanox.com>
> Cc: Laurence Oberman <loberman@redhat.com>
> Cc: <stable@vger.kernel.org>
> ---
>  drivers/infiniband/ulp/srp/ib_srp.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Applied to for-rc, thanks

Jason
