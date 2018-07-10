From: "Bason, Yuval" <Yuval.Bason@cavium.com>
Subject: RE: [PATCH net-next] qed: Add srq core support for RoCE and iWARP
Date: Tue, 10 Jul 2018 09:20:14 +0000
Message-ID: <BN7PR07MB45130D091834BAAAF6CD5D39985B0@BN7PR07MB4513.namprd07.prod.outlook.com>
References: <20180530131137.4653-1-yuval.bason@cavium.com>
 <20180709164204.GB13496@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180709164204.GB13496@ziepe.ca>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "davem@davemloft.net" <davem@davemloft.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "dledford@redhat.com" <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "Kalderon, Michal" <Michal.Kalderon@cavium.com>, "Elior, Ariel" <Ariel.Elior@cavium.com>
List-Id: linux-rdma@vger.kernel.org

> From: Jason Gunthorpe [mailto:jgg@ziepe.ca]
> Sent: Monday, July 9, 2018 7:42 PM
>=20
> On Wed, May 30, 2018 at 04:11:37PM +0300, Yuval Bason wrote:
> > This patch adds support for configuring SRQ and provides the necessary
> > APIs for rdma upper layer driver (qedr) to enable the SRQ feature.
> >
> > Signed-off-by: Michal Kalderon <michal.kalderon@cavium.com>
> > Signed-off-by: Ariel Elior <ariel.elior@cavium.com>
> > Signed-off-by: Yuval Bason <yuval.bason@cavium.com>
> > ---
> >  drivers/net/ethernet/qlogic/qed/qed_cxt.c   |   5 +-
> >  drivers/net/ethernet/qlogic/qed/qed_cxt.h   |   1 +
> >  drivers/net/ethernet/qlogic/qed/qed_hsi.h   |   2 +
> >  drivers/net/ethernet/qlogic/qed/qed_iwarp.c |  23 ++++
> >  drivers/net/ethernet/qlogic/qed/qed_main.c  |   2 +
> >  drivers/net/ethernet/qlogic/qed/qed_rdma.c  | 179
> +++++++++++++++++++++++++++-
> >  drivers/net/ethernet/qlogic/qed/qed_rdma.h  |   2 +
> >  drivers/net/ethernet/qlogic/qed/qed_roce.c  |  17 ++-
> >  include/linux/qed/qed_rdma_if.h             |  12 +-
> >  9 files changed, 235 insertions(+), 8 deletions(-)
>=20
> Is this a pre-requisite for your related RDMA patches?
>=20
Yes, but this was already accepted to net-next in previous cycle and is par=
t of the rdma-next tree:
https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/commit/driver=
s/net/ethernet/qlogic/qed?h=3Dfor-next&id=3D39dbc646fd2c67ee9b71450ce172cbd=
714d4e7fb

> If yes, are you proposing that this patch should go via the RDMA tree?
>=20
> Jason
