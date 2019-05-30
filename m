From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH][next] IB/rdmavt: Use struct_size() helper
Date: Thu, 30 May 2019 15:43:02 -0300
Message-ID: <20190530184302.GA29724@ziepe.ca>
References: <20190529151248.GA24080@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190529151248.GA24080@embeddedor>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Dennis Dalessandro <dennis.dalessandro@intel.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, May 29, 2019 at 10:12:48AM -0500, Gustavo A. R. Silva wrote:
> Make use of the struct_size() helper instead of an open-coded version
> in order to avoid any potential type mistakes, in particular in the
> context in which this code is being used.
> 
> So, replace the following form:
> 
> sizeof(struct rvt_sge) * init_attr->cap.max_send_sge + sizeof(struct rvt_swqe)
> 
> with:
> 
> struct_size(swq, sg_list, init_attr->cap.max_send_sge)
> 
> and so on...
> 
> Also, notice that variable size is unnecessary, hence it is removed.
> 
> This code was detected with the help of Coccinelle.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
> ---
>  drivers/infiniband/sw/rdmavt/qp.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Applied to for-next, thanks

Jason
