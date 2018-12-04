From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next 0/7] Enrich DEVX support
Date: Tue, 4 Dec 2018 12:15:42 -0700
Message-ID: <CALEgSQvYCUQ-ONQK=73jjpDpav8G4pE3_y0oChc4uiQHok6kUA@mail.gmail.com>
References: <20181126062838.5907-1-leon@kernel.org> <95c8a200842de2a78af89ad2d5c051db0577fdfe.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <95c8a200842de2a78af89ad2d5c051db0577fdfe.camel@redhat.com>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, linux-rdma <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 4, 2018 at 12:02 PM Doug Ledford <dledford@redhat.com> wrote:
>
> On Mon, 2018-11-26 at 08:28 +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > From Yishai,
> > -----------------------------------
> > This series enriches DEVX support in few aspects: it enables interoperability
> > between DEVX and verbs and improves mechanism for controlling privileged DEVX
> > commands.
> >
> > The first patch updates mlx5 ifc file.
> >
> > Next 3 patches enable modifying and querying verbs objects via the DEVX
> > interface.
> >
> > To achieve that the core layer introduced the 'UVERBS_IDR_ANY_OBJECT' type
> > to match any IDR object. Once it's used by some driver's method, the
> > infrastructure skips checking for the IDR type and it becomes the driver
> > handler responsibility.
> >
> > The DEVX methods of modify and query were changed to get any object type via
> > the 'UVERBS_IDR_ANY_OBJECT' mechanism. The type checking is done per object as
> > part of the driver code.
> >
> > The next 3 patches introduce more robust mechanism for controlling privileged
> > DEVX commands. The responsibility to block/allow per command was moved to be
> > done in the firmware based on the UID credentials that the driver reports upon
> > user context creation. This enables more granularity per command based on the
> > device security model and the user credentials.
> >
> > In addition, by introducing a valid range for 'general commands' we prevent the
> > need to touch the driver's code any time that a new future command will be
> > added.
> >
> > The last patch fixes the XRC verbs flow once a DEVX context is used. This is
> > needed as XRCD is some shared kernel resource and as such a kernel UID (=0)
> > should be used in its related resources.
> >
> > Thanks
> >
> > Yishai Hadas (7):
> >   net/mlx5: Update mlx5_ifc with DEVX UCTX capabilities bits
> >   IB/core: Introduce UVERBS_IDR_ANY_OBJECT
> >   IB/core: Enable getting an object type from a given uobject
> >   IB/mlx5: Enable modify and query verbs objects via DEVX
> >   IB/mlx5: Enforce DEVX privilege by firmware
> >   IB/mlx5: Update the supported DEVX commands
> >   IB/mlx5: Allow XRC usage via verbs in DEVX context
> >
> >  drivers/infiniband/core/rdma_core.c   |  27 +++--
> >  drivers/infiniband/core/rdma_core.h   |  21 ++--
> >  drivers/infiniband/core/uverbs_uapi.c |  10 +-
> >  drivers/infiniband/hw/mlx5/devx.c     | 142 ++++++++++++++++++++++----
> >  drivers/infiniband/hw/mlx5/main.c     |   4 +-
> >  drivers/infiniband/hw/mlx5/mlx5_ib.h  |   6 +-
> >  drivers/infiniband/hw/mlx5/qp.c       |  12 +--
> >  drivers/infiniband/hw/mlx5/srq.c      |   2 +-
> >  include/linux/mlx5/mlx5_ifc.h         |  26 ++++-
> >  include/rdma/uverbs_ioctl.h           |   6 ++
> >  include/rdma/uverbs_std_types.h       |  12 +++
> >  11 files changed, 215 insertions(+), 53 deletions(-)
> >
> > --
> > 2.19.1
> >
>
> Hi Leon,
>
> I've put this into my wip/dl-for-next branch.  Because it pulled in the
> mlx5-next tree (which was significant because the patch we wanted was at
> the tip and a whole slew of other patches were before it),

Yes, this is how the shared branch works, DaveM merges it, we don't
have to unless we have a dependency, so it can accumulate a bit.

> the changeset
> for this patch looks much bigger.  And it had the merge conflict you
> mentioned.  You might want to double check my work before it gets moved
> over to the official for-next branch.

It is a bit easier to follow the git log if merges are done with the
--log option to summarize what was pulled in.

Jason
