From: "Bason, Yuval" <Yuval.Bason@cavium.com>
Subject: RE: [PATCH net-next] qed: Add srq core support for RoCE and iWARP
Date: Sun, 3 Jun 2018 16:10:04 +0000
Message-ID: <BN7PR07MB451317995E2166228FA9108598600@BN7PR07MB4513.namprd07.prod.outlook.com>
References: <20180530131137.4653-1-yuval.bason@cavium.com>
 <20180531173301.GV3697@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180531173301.GV3697@mtr-leonro.mtl.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: "davem@davemloft.net" <davem@davemloft.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "jgg@mellanox.com" <jgg@mellanox.com>, "dledford@redhat.com" <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "Kalderon, Michal" <Michal.Kalderon@cavium.com>, "Elior, Ariel" <Ariel.Elior@cavium.com>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky [mailto:leon@kernel.org]
Sent: Thursday, May 31, 2018 8:33 PM
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
> >
>=20
> ...
>=20
> > +	struct qed_sp_init_data init_data;
>=20
> ...
>=20
> > +	memset(&init_data, 0, sizeof(init_data));
>=20
> This patter is so common in this patch, why?
>=20
> "struct qed_sp_init_data init_data =3D {};" will do the trick.
>=20
Thanks for pointing out, will be fixed in v2.

> Thanks
