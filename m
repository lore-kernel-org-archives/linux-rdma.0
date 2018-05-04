From: Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH 3/5] ib_srpt: depend on INFINIBAND_ADDR_TRANS
Date: Fri, 04 May 2018 03:30:44 +0000
Message-ID: <CAHH2K0Y0wByaf3JzomfrzKwMZMbOw=NdXg++3vVfn9F=ZCYxnQ@mail.gmail.com>
References: <20180425223340.206907-1-gthelen@google.com> <20180430233500.GI26909@ziepe.ca>
 <CAHH2K0aJgACn1fQrR=YpifWgOAFTCubcVo+bA+zCFg7++NR1kQ@mail.gmail.com> <20180501204803.GE28551@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180501204803.GE28551@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, Christoph Hellwig <hch@lst.de>, linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Tarick Bedeir <tarick@google.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 1, 2018 at 1:48 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Tue, May 01, 2018 at 03:08:57AM +0000, Greg Thelen wrote:
> > On Mon, Apr 30, 2018 at 4:35 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> >
> > > On Wed, Apr 25, 2018 at 03:33:39PM -0700, Greg Thelen wrote:
> > > > INFINIBAND_SRPT code depends on INFINIBAND_ADDR_TRANS provided
symbols.
> > > > So declare the kconfig dependency.  This is necessary to allow for
> > > > enabling INFINIBAND without INFINIBAND_ADDR_TRANS.
> > > >
> > > > Signed-off-by: Greg Thelen <gthelen@google.com>
> > > > Cc: Tarick Bedeir <tarick@google.com>
> > > >  drivers/infiniband/ulp/srpt/Kconfig | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/drivers/infiniband/ulp/srpt/Kconfig
> > b/drivers/infiniband/ulp/srpt/Kconfig
> > > > index 31ee83d528d9..fb8b7182f05e 100644
> > > > +++ b/drivers/infiniband/ulp/srpt/Kconfig
> > > > @@ -1,6 +1,6 @@
> > > >  config INFINIBAND_SRPT
> > > >       tristate "InfiniBand SCSI RDMA Protocol target support"
> > > > -     depends on INFINIBAND && TARGET_CORE
> > > > +     depends on INFINIBAND && INFINIBAND_ADDR_TRANS && TARGET_CORE
> >
> > > Isn't INFINIBAND && INFINIBAND_ADDR_TRANS a bit redundant? Can't have
> > > INFINIBAND_ADDR_TRANS without INFINIBAND.
> >
> > By kconfig INFINIBAND_ADDR_TRANS depends on INFINIBAND.  So yes, it
seems
> > redundant.  I don't know if anyone has designs to break this dependency
and
> > allow for ADDR_TRANS without INFINIBAND.  Assuming not, I'd be willing
to
> > amend my series removing redundant INFINIBAND and a followup series to
> > remove it from similar depends.  Though I'm not familiar with rdma dev
tree
> > lifecycle.  Is rdma/for-rc a throw away branch (akin to linux-next), or
> > will it be merged into linus/master?  If throwaway, then we can amend
> > its patches, otherwise followups will be needed.
> >
> > Let me know what you'd prefer.  Thanks.

> I think a single update patch to fix all of these, and the
> pre-existing ones would be great

I just posted the cleanup: https://lkml.org/lkml/2018/5/3/1045
