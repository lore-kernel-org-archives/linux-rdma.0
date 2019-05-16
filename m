From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v2] RDMA: Directly cast the sockaddr union to sockaddr
Date: Thu, 16 May 2019 12:21:48 -0300
Message-ID: <20190516152148.GD22587@ziepe.ca>
References: <20190514005521.GA18085@ziepe.ca>
 <20190516124428.hytvkwfltfi24lrv@verge.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190516124428.hytvkwfltfi24lrv@verge.net.au>
Sender: netdev-owner@vger.kernel.org
To: Simon Horman <horms@verge.net.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Miller <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>, linux-rdma <linux-rdma@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 16, 2019 at 02:44:28PM +0200, Simon Horman wrote:
> On Mon, May 13, 2019 at 09:55:21PM -0300, Jason Gunthorpe wrote:
> > gcc 9 now does allocation size tracking and thinks that passing the member
> > of a union and then accessing beyond that member's bounds is an overflow.
> > 
> > Instead of using the union member, use the entire union with a cast to
> > get to the sockaddr. gcc will now know that the memory extends the full
> > size of the union.
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
> >  drivers/infiniband/core/addr.c           | 16 ++++++++--------
> >  drivers/infiniband/hw/ocrdma/ocrdma_ah.c |  5 ++---
> >  drivers/infiniband/hw/ocrdma/ocrdma_hw.c |  5 ++---
> >  3 files changed, 12 insertions(+), 14 deletions(-)
> > 
> > I missed the ocrdma files in the v1
> > 
> > We can revisit what to do with that repetitive union after the merge
> > window, but this simple patch will eliminate the warnings for now.
> > 
> > Linus, I'll send this as a PR tomorrow - there is also a bug fix for
> > the rdma-netlink changes posted that should go too.
> 
> <2c>
> I would be very happy to see this revisited in such a way
> that some use is made of the C type system (instead of casts).
> </2c>

Well, I was thinking of swapping the union to sockaddr_storage ..

Do you propose to add a union to the kernel's sockaddr storage?

Jason
