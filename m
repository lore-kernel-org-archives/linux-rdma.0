From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH rdma-next 0/7] Enrich DEVX support
Date: Tue, 04 Dec 2018 14:45:56 -0500
Message-ID: <c44fe51963ba6e04f068f6001d845ffebc53b16c.camel@redhat.com>
References: <20181126062838.5907-1-leon@kernel.org>
         <95c8a200842de2a78af89ad2d5c051db0577fdfe.camel@redhat.com>
         <CALEgSQvYCUQ-ONQK=73jjpDpav8G4pE3_y0oChc4uiQHok6kUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-+Iwzn9viyFGQtH7GQjUb"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CALEgSQvYCUQ-ONQK=73jjpDpav8G4pE3_y0oChc4uiQHok6kUA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, linux-rdma <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--=-+Iwzn9viyFGQtH7GQjUb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-12-04 at 12:15 -0700, Jason Gunthorpe wrote:
> On Tue, Dec 4, 2018 at 12:02 PM Doug Ledford <dledford@redhat.com> wrote:
> > On Mon, 2018-11-26 at 08:28 +0200, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@mellanox.com>
> > >=20
> > > From Yishai,
> > > -----------------------------------
> > > This series enriches DEVX support in few aspects: it enables interope=
rability
> > > between DEVX and verbs and improves mechanism for controlling privile=
ged DEVX
> > > commands.
> > >=20
> > > The first patch updates mlx5 ifc file.
> > >=20
> > > Next 3 patches enable modifying and querying verbs objects via the DE=
VX
> > > interface.
> > >=20
> > > To achieve that the core layer introduced the 'UVERBS_IDR_ANY_OBJECT'=
 type
> > > to match any IDR object. Once it's used by some driver's method, the
> > > infrastructure skips checking for the IDR type and it becomes the dri=
ver
> > > handler responsibility.
> > >=20
> > > The DEVX methods of modify and query were changed to get any object t=
ype via
> > > the 'UVERBS_IDR_ANY_OBJECT' mechanism. The type checking is done per =
object as
> > > part of the driver code.
> > >=20
> > > The next 3 patches introduce more robust mechanism for controlling pr=
ivileged
> > > DEVX commands. The responsibility to block/allow per command was move=
d to be
> > > done in the firmware based on the UID credentials that the driver rep=
orts upon
> > > user context creation. This enables more granularity per command base=
d on the
> > > device security model and the user credentials.
> > >=20
> > > In addition, by introducing a valid range for 'general commands' we p=
revent the
> > > need to touch the driver's code any time that a new future command wi=
ll be
> > > added.
> > >=20
> > > The last patch fixes the XRC verbs flow once a DEVX context is used. =
This is
> > > needed as XRCD is some shared kernel resource and as such a kernel UI=
D (=3D0)
> > > should be used in its related resources.
> > >=20
> > > Thanks
> > >=20
> > > Yishai Hadas (7):
> > >   net/mlx5: Update mlx5_ifc with DEVX UCTX capabilities bits
> > >   IB/core: Introduce UVERBS_IDR_ANY_OBJECT
> > >   IB/core: Enable getting an object type from a given uobject
> > >   IB/mlx5: Enable modify and query verbs objects via DEVX
> > >   IB/mlx5: Enforce DEVX privilege by firmware
> > >   IB/mlx5: Update the supported DEVX commands
> > >   IB/mlx5: Allow XRC usage via verbs in DEVX context
> > >=20
> > >  drivers/infiniband/core/rdma_core.c   |  27 +++--
> > >  drivers/infiniband/core/rdma_core.h   |  21 ++--
> > >  drivers/infiniband/core/uverbs_uapi.c |  10 +-
> > >  drivers/infiniband/hw/mlx5/devx.c     | 142 ++++++++++++++++++++++--=
--
> > >  drivers/infiniband/hw/mlx5/main.c     |   4 +-
> > >  drivers/infiniband/hw/mlx5/mlx5_ib.h  |   6 +-
> > >  drivers/infiniband/hw/mlx5/qp.c       |  12 +--
> > >  drivers/infiniband/hw/mlx5/srq.c      |   2 +-
> > >  include/linux/mlx5/mlx5_ifc.h         |  26 ++++-
> > >  include/rdma/uverbs_ioctl.h           |   6 ++
> > >  include/rdma/uverbs_std_types.h       |  12 +++
> > >  11 files changed, 215 insertions(+), 53 deletions(-)
> > >=20
> > > --
> > > 2.19.1
> > >=20
> >=20
> > Hi Leon,
> >=20
> > I've put this into my wip/dl-for-next branch.  Because it pulled in the
> > mlx5-next tree (which was significant because the patch we wanted was a=
t
> > the tip and a whole slew of other patches were before it),
>=20
> Yes, this is how the shared branch works, DaveM merges it, we don't
> have to unless we have a dependency, so it can accumulate a bit.

I get how it works :-P.  I was just commenting that it had in fact built
up an accumulation.

> > the changeset
> > for this patch looks much bigger.  And it had the merge conflict you
> > mentioned.  You might want to double check my work before it gets moved
> > over to the official for-next branch.
>=20
> It is a bit easier to follow the git log if merges are done with the
> --log option to summarize what was pulled in.

I'll modify my merge alias to add it.  As it stands, I'll repush this to
my wip branch with the --log option added.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-+Iwzn9viyFGQtH7GQjUb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlwG2XQACgkQuCajMw5X
L90eAw//YcXCJF7jdoqGJoNb7dW5yxGM0qijp1X9DIT4PzKi2VwnxxQenkecuJ+f
oNDw97rJjOPhEqF8Th62jVoQ8bSfhb/8eldkMx/GAgSFGH0IPZlpS79wE2mVJjGB
sw4zQYRW8EjtBZg2FlVggSyv7oxcK7g0dfZdIUjUaXN1KqHJaFXiWqYp4dIUE0OJ
mbrhb4Kft9o5NKtI82fI/uGJOfdnUlXZONnS6RIDEDypvwjL3az2WYtO5Gj9qLcC
jqymaImHtxxcPizq6NrXEOGTfyhK+XPQIwVaAtXBAaB/RkguxVaUVUmKvuAWtYOt
X5+7IFTS6XnIuH+CQFJrQsCG6jbtT6/c6twdGqksnEE/m2jOS3OnuWP4kiB46P/s
8L0dq4QgwIDZfkue0o5T222mCig4AqFI9UekhhBTng+GbUCdUWUlmuFlD08NYg7C
f3O452AkgaDGQIPXG26zeHSxFpmVZskVreDzWM2WrT3h1TQrz+o//RhpwBv29FTy
xdBm9vWlv/RcLCCkLxhVh2EpYHodxf+ac/5zaNMGgvLtos/EMa4BEEhZucQueQ0C
0B6hJI58kPLxNgWNfvIxLEy6S1lK+Zh/3upMpRURbjwzYjYGaiu8fMeNifwjeiTE
VzVYECBWyPYvrwmO86jPRwU+NS3H8yQUFYOLytDkYakDvfCubvU=
=Khoi
-----END PGP SIGNATURE-----

--=-+Iwzn9viyFGQtH7GQjUb--
