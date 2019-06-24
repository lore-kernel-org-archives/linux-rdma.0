From: Michal Kalderon <mkalderon@marvell.com>
Subject: RE: [EXT] Re: [PATCH v3 rdma-next 0/3] RDMA/qedr: Use the doorbell
 overflow recovery mechanism for RDMA
Date: Mon, 24 Jun 2019 10:36:29 +0000
Message-ID: <MN2PR18MB3182104653BC4373602BE7B9A1E00@MN2PR18MB3182.namprd18.prod.outlook.com>
References: <20190613083819.6998-1-michal.kalderon@marvell.com>
 <bda0321cb362bc93f5428b1df7daf69fed083656.camel@redhat.com>
 <MN2PR18MB3182498CA8C9C7EB3259F62FA1E70@MN2PR18MB3182.namprd18.prod.outlook.com>
 <20190621195818.GY19891@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190621195818.GY19891@ziepe.ca>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>
Cc: Ariel Elior <aelior@marvell.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Friday, June 21, 2019 10:58 PM
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Fri, Jun 21, 2019 at 07:49:39PM +0000, Michal Kalderon wrote:
> > > From: linux-rdma-owner@vger.kernel.org <linux-rdma-
> > > owner@vger.kernel.org> On Behalf Of Doug Ledford
> > >
> > > On Thu, 2019-06-13 at 11:38 +0300, Michal Kalderon wrote:
> > > > This patch series used the doorbell overflow recovery mechanism
> > > > introduced in commit 36907cd5cd72 ("qed: Add doorbell overflow
> > > > recovery mechanism") for rdma ( RoCE and iWARP )
> > > >
> > > > rdma-core pull request #493
> > > >
> > > > Changes from V2:
> > > > - Don't use long-lived kmap. Instead use user-trigger mmap for the
> > > >   doorbell recovery entries.
> > > > - Modify dpi_addr to be denoted with __iomem and avoid redundant
> > > >   casts
> > > >
> > > > Changes from V1:
> > > > - call kmap to map virtual address into kernel space
> > > > - modify db_rec_delete to be void
> > > > - remove some cpu_to_le16 that were added to previous patch which
> are
> > > >   correct but not related to the overflow recovery mechanism. Will =
be
> > > >   submitted as part of a different patch
> > > >
> > > >
> > > > Michal Kalderon (3):
> > > >   qed*: Change dpi_addr to be denoted with __iomem
> > > >   RDMA/qedr: Add doorbell overflow recovery support
> > > >   RDMA/qedr: Add iWARP doorbell recovery support
> > > >
> > > >  drivers/infiniband/hw/qedr/main.c          |   2 +-
> > > >  drivers/infiniband/hw/qedr/qedr.h          |  27 +-
> > > >  drivers/infiniband/hw/qedr/verbs.c         | 387
> > > > ++++++++++++++++++++++++-----
> > > >  drivers/net/ethernet/qlogic/qed/qed_rdma.c |   6 +-
> > > >  include/linux/qed/qed_rdma_if.h            |   2 +-
> > > >  include/uapi/rdma/qedr-abi.h               |  25 ++
> > > >  6 files changed, 378 insertions(+), 71 deletions(-)
> > > >
> > >
> > > Hi Michal,
> > >
> > > In patch 2 and 3 both, you still have quite a few casts to (u8 __iome=
m *).
> > > Why not just define the struct elements as u8 __iomem * instead of
> > > void __iomem * and avoid all the casts?
> > >
> > Hi Doug,
> >
> > Thanks for the review. The remaining casts are due to pointer
> > arithmetic and not variable assignments as before. Removing the cast
> > entirely will require quite a lot of changes in qed and in rdma-core wh=
ich I
> would be happy to avoid at this time.
>=20
> In linux pointer math on a void * acts the same as a u8 so you should nev=
er
> need to cast a void * to a u8 just to do math?
>=20
Ok, thanks. Sent v4.
Michal

> Jason
