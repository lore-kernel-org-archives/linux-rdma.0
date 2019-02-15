From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [rdma-rc PATCH 0/2] iw_cxgb4: Adjust the cq/qp mask
Date: Fri, 15 Feb 2019 15:47:46 -0700
Message-ID: <20190215224746.GA19478@ziepe.ca>
References: <20190214121054.11693-1-rajur@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190214121054.11693-1-rajur@chelsio.com>
Sender: netdev-owner@vger.kernel.org
To: Raju Rangoju <rajur@chelsio.com>
Cc: davem@davemloft.net, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, swise@opengridcomputing.com
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 14, 2019 at 05:40:52PM +0530, Raju Rangoju wrote:
> Export the LLD sge_host_page_size field to ULDs via
> cxgb4_lld_info, so that iw_cxgb4 can adjust the cq/qp
> mask based on no.of bar2 pages in a host page.
> 
> This series has both net(cxgb4) and rdma(iw_cxgb4) changes,
> and I would request this merge via rdma repo.
> 
> I have made sure this series applies cleanly on both net-next
> and rdma-for-rc and doesn't cause any merge conflicts.
> 
> Raju Rangoju (2):
>   cxgb4: export sge_host_page_size to ulds
>   iw_cxgb4: cq/qp mask depends on bar2 pages in a host page

As requested, applied to for-rc with some revisions to the commit
messages.

Thanks,
Jason
