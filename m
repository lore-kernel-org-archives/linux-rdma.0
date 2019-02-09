From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 0/3] iw_cxgb4: add support for completing cached SRQ
 buffers
Date: Fri, 8 Feb 2019 17:04:01 -0700
Message-ID: <20190209000401.GA7673@ziepe.ca>
References: <20190206172444.21997-1-rajur@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190206172444.21997-1-rajur@chelsio.com>
Sender: netdev-owner@vger.kernel.org
To: Raju Rangoju <rajur@chelsio.com>
Cc: davem@davemloft.net, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, swise@opengridcomputing.com
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 06, 2019 at 10:54:41PM +0530, Raju Rangoju wrote:
> This series adds support for completing the SRQ buffers that were
> fetched but could not be completed by hw due to connection aborts,
> also fixes the potential srqidx leak during the connection abort.
> 
> This series has both net(cxgb4) and rdma(iw_cxgb4) changes,
> and I would request this merge via rdma repo.
> 
> I have made sure this series applies cleanly on both net-next
> and rdma-for-next and doesn't cause any merge conflicts.
> 
> Raju Rangoju (3):
>   cxgb4: add tcb flags and tcb rpl struct
>   iw_cxgb4: complete the cached SRQ buffers
>   iw_cxgb4: fix srqidx leak during connection abort
> 
>  drivers/infiniband/hw/cxgb4/cm.c            | 166 ++++++++++++++++++++++++++--
>  drivers/infiniband/hw/cxgb4/iw_cxgb4.h      |   3 +
>  drivers/infiniband/hw/cxgb4/t4.h            |   1 +
>  drivers/net/ethernet/chelsio/cxgb4/t4_msg.h |   8 ++
>  drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h |  12 ++
>  5 files changed, 180 insertions(+), 10 deletions(-)

Since this is mostly rdma code let's go through the rdma tree.

Applied to for-next, thanks

Jason 
