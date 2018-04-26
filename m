From: Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH 5/5] IB: make INFINIBAND_ADDR_TRANS configurable
Date: Thu, 26 Apr 2018 02:24:30 +0000
Message-ID: <CAHH2K0aT+NOKFgVZSwdD2uOKx2ZVSO6sbFHj7KQEUWL8RL8RMw@mail.gmail.com>
References: <20180425223424.207228-1-gthelen@google.com> <14810de7b209468bc36fdb696db639242bbad9f9.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <14810de7b209468bc36fdb696db639242bbad9f9.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, Christoph Hellwig <hch@lst.de>, LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, Tarick Bedeir <tarick@google.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 25, 2018 at 7:13 PM Bart Van Assche <Bart.VanAssche@wdc.com>
wrote:

> On Wed, 2018-04-25 at 15:34 -0700, Greg Thelen wrote:
> > Allow INFINIBAND without INFINIBAND_ADDR_TRANS because fuzzing has been
> > finding fair number of CM bugs.  So provide option to disable it.
> >
> > Signed-off-by: Greg Thelen <gthelen@google.com>
> > Cc: Tarick Bedeir <tarick@google.com>
> > ---
> >  drivers/infiniband/Kconfig | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
> > index ee270e065ba9..2a972ed6851b 100644
> > --- a/drivers/infiniband/Kconfig
> > +++ b/drivers/infiniband/Kconfig
> > @@ -61,9 +61,12 @@ config INFINIBAND_ON_DEMAND_PAGING
> >         pages on demand instead.
> >
> >  config INFINIBAND_ADDR_TRANS
> > -     bool
> > +     bool "RDMA/CM"
> >       depends on INFINIBAND
> >       default y
> > +     ---help---
> > +       Support for RDMA communication manager (CM).
> > +       This allows for a generic connection abstraction over RDMA.

> Hello Greg,

> Please provide a cover letter when posting a patch series. Such a cover
> letter is not only informative but also makes it easy for people who want
> to comment on a patch series as a whole. I have a question that applies
> to the entire patch series. The RDMA/CM code defines functions like
> rdma_create_id() and rdma_create_qp(). If I search through the kernel tree
> for callers of these functions then I find several more kernel modules
than
> the ones that are modified by this patch series:

> $ git grep -lE '[[:blank:]](rdma_create_id|rdma_create_qp)\('
> drivers/infiniband/core/cma.c
> drivers/infiniband/ulp/iser/iser_verbs.c
> drivers/infiniband/ulp/isert/ib_isert.c
> drivers/infiniband/ulp/srp/ib_srp.c
> drivers/infiniband/ulp/srpt/ib_srpt.c
> drivers/nvme/host/rdma.c
> drivers/nvme/target/rdma.c
> drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
> drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h
> fs/cifs/smbdirect.c
> include/rdma/rdma_cm.h
> net/9p/trans_rdma.c
> net/rds/ib.c
> net/rds/ib_cm.c
> net/rds/rdma_transport.c
> net/sunrpc/xprtrdma/svc_rdma_transport.c
> net/sunrpc/xprtrdma/verbs.c

> Are you sure that this patch series is complete?

I'll check your cited files.  I'll resend with cover letter.

FYI: I already rand this series through the 0-day builder, which presumably
would've caught most config dep issues.  But I'll research your list before
reposting.
