From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH][next] IB/hfi1: Use struct_size() helper
Date: Thu, 30 May 2019 15:43:30 -0300
Message-ID: <20190530184330.GC29724@ziepe.ca>
References: <20190529151528.GA24148@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190529151528.GA24148@embeddedor>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, May 29, 2019 at 10:15:28AM -0500, Gustavo A. R. Silva wrote:
> Make use of the struct_size() helper instead of an open-coded version
> in order to avoid any potential type mistakes, in particular in the
> context in which this code is being used.
> 
> So, replace the following form:
> 
> sizeof(struct opa_port_status_rsp) + num_vls * sizeof(struct _vls_pctrs)
> 
> with:
> 
> struct_size(rsp, vls, num_vls)
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
>  drivers/infiniband/hw/hfi1/mad.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)

Applied to for-next, thanks

Jason
