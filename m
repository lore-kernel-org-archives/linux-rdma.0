From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 3/5] ib_srpt: depend on INFINIBAND_ADDR_TRANS
Date: Tue, 01 May 2018 13:08:48 -0400
Message-ID: <1525194528.11756.121.camel@redhat.com>
References: <20180425223340.206907-1-gthelen@google.com>
         <20180430233500.GI26909@ziepe.ca>
         <CAHH2K0aJgACn1fQrR=YpifWgOAFTCubcVo+bA+zCFg7++NR1kQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-O2RNN/cu5eujYXI9HcTT"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHH2K0aJgACn1fQrR=YpifWgOAFTCubcVo+bA+zCFg7++NR1kQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Thelen <gthelen@google.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, Christoph Hellwig <hch@lst.de>, linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Tarick Bedeir <tarick@google.com>
List-Id: linux-rdma@vger.kernel.org


--=-O2RNN/cu5eujYXI9HcTT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-05-01 at 03:08 +0000, Greg Thelen wrote:
> On Mon, Apr 30, 2018 at 4:35 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
>=20
> > On Wed, Apr 25, 2018 at 03:33:39PM -0700, Greg Thelen wrote:
> > > INFINIBAND_SRPT code depends on INFINIBAND_ADDR_TRANS provided symbol=
s.
> > > So declare the kconfig dependency.  This is necessary to allow for
> > > enabling INFINIBAND without INFINIBAND_ADDR_TRANS.
> > >=20
> > > Signed-off-by: Greg Thelen <gthelen@google.com>
> > > Cc: Tarick Bedeir <tarick@google.com>
> > >  drivers/infiniband/ulp/srpt/Kconfig | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >=20
> > > diff --git a/drivers/infiniband/ulp/srpt/Kconfig
>=20
> b/drivers/infiniband/ulp/srpt/Kconfig
> > > index 31ee83d528d9..fb8b7182f05e 100644
> > > +++ b/drivers/infiniband/ulp/srpt/Kconfig
> > > @@ -1,6 +1,6 @@
> > >  config INFINIBAND_SRPT
> > >       tristate "InfiniBand SCSI RDMA Protocol target support"
> > > -     depends on INFINIBAND && TARGET_CORE
> > > +     depends on INFINIBAND && INFINIBAND_ADDR_TRANS && TARGET_CORE
> > Isn't INFINIBAND && INFINIBAND_ADDR_TRANS a bit redundant? Can't have
> > INFINIBAND_ADDR_TRANS without INFINIBAND.
>=20
> By kconfig INFINIBAND_ADDR_TRANS depends on INFINIBAND.  So yes, it seems
> redundant.  I don't know if anyone has designs to break this dependency a=
nd
> allow for ADDR_TRANS without INFINIBAND.

No, not at the moment (and I'm not sure we ever would, it would only
happen if the subsystem itself became something like RDMA and INFINIBAND
specifically related only to the INFINIBAND link layer support, in which
case you might want to enable RoCE without INFINIBAND or something like
that, but no one has plans to do that as far as I'm aware).

>   Assuming not, I'd be willing to
> amend my series removing redundant INFINIBAND and a followup series to
> remove it from similar depends.  Though I'm not familiar with rdma dev tr=
ee
> lifecycle.  Is rdma/for-rc a throw away branch (akin to linux-next), or
> will it be merged into linus/master?  If throwaway, then we can amend
> its patches, otherwise followups will be needed.

Followups will be needed.

> Let me know what you'd prefer.  Thanks.
>=20
> FYI from v4.17-rc3:
> drivers/staging/lustre/lnet/Kconfig:  depends on LNET && PCI && INFINIBAN=
D
> && INFINIBAND_ADDR_TRANS
> net/9p/Kconfig:       depends on INET && INFINIBAND && INFINIBAND_ADDR_TR=
ANS
> net/rds/Kconfig:      depends on RDS && INFINIBAND && INFINIBAND_ADDR_TRA=
NS
> net/sunrpc/Kconfig:   depends on SUNRPC && INFINIBAND &&
> INFINIBAND_ADDR_TRANS

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-O2RNN/cu5eujYXI9HcTT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlronyAACgkQuCajMw5X
L90/YBAAqBrBGCsrbgWK3N3aRy514kyYZTFd2F8f++JB4mJeJOc3toJw7/InH/ZI
ZID61aoQT//GBY82f7Gmrq6vimfpke0kTJEPCp0bTntvDI/FNMnEkJaXYUzNGUQO
vGwJRIkc+/ddwq/RzoqgqtZqqMv4WgjgcAZmdbl3fLs49YizkZ+2ID8dcLj+VmGk
G+ijgrQTu6NmkTNiqt/XBLdyllIr/y8+Mtmvh17iSQHT/cjDqEFisjv1be85gApP
SbbdScphqgEyUrGIrtLIuzYi7wtJoLO0xDVW4gCYfjqwegVeFBIFH/DJuZtNBOXX
1txBMP3EyYuQTGAa6fuK2j74yRyxahlJrrf7aa5jX69DbMzaPhOAQ17juTxx31wM
S3eVXTxYOzTjEYrRyUZ47+aaXkZieeJfQPvjtNTBuhw2+WaHyIzbXCM732ebQKxi
oNYt+sCfFgHZCP6vAvC9X/WuBWL9lR+X6gBddrhrHVM0lovbAOP/w2nJZMXjGkTM
DVK+CsAeMPX8Rl/v87tpoWlbs8+c+WQeiQhk4bKEwpdBJhzEqFpKQiwKAkb1UE0Z
ke6DijPY8BEPT7Qi7oYjq1876idSl0qJ9BvZYIwtJjDni+HAwBXfrI/Rp96EO4ak
0F58Ld6kkJ5kieSKcfX2aOw+45YPcPd46WUSHNjmQESEixvMxj0=
=RAGz
-----END PGP SIGNATURE-----

--=-O2RNN/cu5eujYXI9HcTT--
