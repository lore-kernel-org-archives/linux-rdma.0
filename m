From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH][next] IB/rdmavt: Use struct_size() helper
Date: Thu, 30 May 2019 15:29:05 -0300
Message-ID: <20190530182905.GE13475@ziepe.ca>
References: <20190529151248.GA24080@embeddedor>
 <09563aec-f6d0-f27f-4f67-1e21cebd997c@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <09563aec-f6d0-f27f-4f67-1e21cebd997c@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, May 30, 2019 at 02:26:22PM -0400, Dennis Dalessandro wrote:
> On 5/29/2019 11:12 AM, Gustavo A. R. Silva wrote:
> > Make use of the struct_size() helper instead of an open-coded version
> > in order to avoid any potential type mistakes, in particular in the
> > context in which this code is being used.
> > 
> > So, replace the following form:
> > 
> > sizeof(struct rvt_sge) * init_attr->cap.max_send_sge + sizeof(struct rvt_swqe)
> > 
> > with:
> > 
> > struct_size(swq, sg_list, init_attr->cap.max_send_sge)
> > 
> > and so on...
> > 
> > Also, notice that variable size is unnecessary, hence it is removed.
> > 
> > This code was detected with the help of Coccinelle.
> > 
> > Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> >   drivers/infiniband/sw/rdmavt/qp.c | 4 +---
> >   1 file changed, 1 insertion(+), 3 deletions(-)
> > 
> > diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
> > index 31a2e65e4906..a60f5faea198 100644
> > +++ b/drivers/infiniband/sw/rdmavt/qp.c
> > @@ -988,9 +988,7 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
> >   	case IB_QPT_UC:
> >   	case IB_QPT_RC:
> >   	case IB_QPT_UD:
> > -		sz = sizeof(struct rvt_sge) *
> > -			init_attr->cap.max_send_sge +
> > -			sizeof(struct rvt_swqe);
> > +		sz = struct_size(swq, sg_list, init_attr->cap.max_send_sge);
> >   		swq = vzalloc_node(array_size(sz, sqsize), rdi->dparms.node);
> >   		if (!swq)
> >   			return ERR_PTR(-ENOMEM);
> > 
> 
> Looks correct, I don't think this makes the code easier to read though. The
> macro name "struct_size" is misleading to me. Maybe that's just me, and in
> any case...

It is struct_size because it computes the full size of a struct ending in a
variable length array with N items.

The previous code was wonky because it assumes that struct rvt_swqe is
the underlying type of sg_list, while the new version gets the type
information automatically.

Jason
