From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH v2 1/2] IB/ipoib: Use dev_port to expose network
 interface port numbers
Date: Fri, 31 Aug 2018 16:58:56 -0400
Message-ID: <97281a05c55c52c14dbda74c1164c26889b8ec75.camel@redhat.com>
References: <20180830182238.16361-1-ar@cs.msu.ru>
         <20180830182238.16361-2-ar@cs.msu.ru>
         <075a5d0f9fb9dfc868e82073f930a98bea15e578.camel@redhat.com>
         <20180831085740.GA22172@cello.Dlink>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-zJN3aKq+YKxdEAXWjM0O"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180831085740.GA22172@cello.Dlink>
Sender: netdev-owner@vger.kernel.org
To: Arseny Maslennikov <ar@cs.msu.ru>
Cc: linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-zJN3aKq+YKxdEAXWjM0O
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2018-08-31 at 11:57 +0300, Arseny Maslennikov wrote:
> On Thu, Aug 30, 2018 at 04:17:58PM -0400, Doug Ledford wrote:
> > On Thu, 2018-08-30 at 21:22 +0300, Arseny Maslennikov wrote:
> > > Some InfiniBand network devices have multiple ports on the same PCI
> > > function. This initializes the `dev_port' sysfs field of those
> > > network interfaces with their port number.
> > >=20
> > > Prior to this the kernel erroneously used the `dev_id' sysfs
> > > field of those network interfaces to convey the port number to usersp=
ace.
> > >=20
> > > The use of `dev_id' was considered correct until Linux 3.15,
> > > when another field, `dev_port', was defined for this particular
> > > purpose and `dev_id' was reserved for distinguishing stacked ifaces
> > > (e.g: VLANs) with the same hardware address as their parent device.
> > >=20
> > > Similar fixes to net/mlx4_en and many other drivers, which started
> > > exporting this information through `dev_id' before 3.15, were accepte=
d
> > > into the kernel 4 years ago.
> > > See 76a066f2a2a0 (`net/mlx4_en: Expose port number through sysfs').
> > >=20
> > > Signed-off-by: Arseny Maslennikov <ar@cs.msu.ru>
> > > ---
> > >  drivers/infiniband/ulp/ipoib/ipoib_main.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >=20
> > > diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infi=
niband/ulp/ipoib/ipoib_main.c
> > > index e3d28f9ad9c0..ba16a63ee303 100644
> > > --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > > +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > > @@ -1880,7 +1880,7 @@ static int ipoib_parent_init(struct net_device =
*ndev)
> > >  	       sizeof(union ib_gid));
> > > =20
> > >  	SET_NETDEV_DEV(priv->dev, priv->ca->dev.parent);
> > > -	priv->dev->dev_id =3D priv->port - 1;
> > > +	priv->dev->dev_port =3D priv->port - 1;
> >=20
> > I don't know that we can't do this.  At least not yet.  Expose the new
> > item to make us compliant with the new docs, and deprecate the old sysf=
s
> > item, but we can't just yank the old item.  Existing tools/scripts migh=
t
> > (probably) rely on it (existing tools already special case IPoIB
> > interfaces and we'll need to make sure they don't special case this
> > element too).
>=20
> I'm good with keeping both items for a (probably long) while to not break
> things. But how exactly should we notify users of the deprecation, so the=
y
> don't special case this again? A comment in the code seems too little =E2=
=80=94
> everyone's obviously too busy to look there and stumble upon that.
> A distinct notice in the doc seems too much. I can't think of another pla=
ce
> for the deprecation notice where people would take note of it, however.
>=20
> Anyway: would it be OK to just restore both items and put a small note in
> dev_id's doc entry? If yes, I'll then send a v3.

A warn_on_once in the code so that when someone reads the dev_id entry,
we get a deprecation warning in the dmesg output at info level would be
my suggestion.  Have it output the command name as part of the warning
so we know what tools are using it.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-zJN3aKq+YKxdEAXWjM0O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAluJrBAACgkQuCajMw5X
L90gow/8DU/yXdf1styIh8H4idzy7f2WbKKcdqmHRWdZ8T1SLb6Wz9ZVBAILnTCh
KVE+rZmy0V7moWBSx4ADB6nGCvxpQqGwMQW9Qr1K01slrm5oNMPlzx+3DwhRHAeF
5IPa/C85OFx7+qB51TTlm9r5fC+9i3heJoI2jcMosADmefxFs2u7Sxi9B3r8GUD4
skQVS3vwekFZyWQw/Mh4wQzZaun6w+Ybmvj2pNveVE8Ep38uMGaK9TPFt5F1vkxC
5VlJe3Y4ToxfKSjqi9pLIbz954vKiGAiaEN4Lvg6ACEl86aYhUGbEiyuZRt1gWNO
UlNqEPf/boO/mK2ioCPrkv7/F2y7eQSPADo8x46m91hLTIhQWSggNB0hbb422bir
m7uDeprjzqURbAuGhq2slkZ8tCEv35b1hAeecCLuD7M4zzb6bpUn3YFoJj/Zzhec
WjHsPuWHqaHjo1dmuiOu9WdN0MGd7ZTUIKlp/IEG1hfsux2aK3qlYp9CsPt0bfIt
5JrhWnNDVurmJ01vsW9/bgzrXNYteArD29sTK0aI52mQM8Umtl0jEZANhTZl1xQh
9cpMtmZsWFaUpqqdeaVZZ60fPhs89Adl0Bb55tYG0IqMMY5YiVzg4XtRN+h9sBPD
nYpjTc1BqV9fvTke+NPEf8Fn9/C/lx6eKKF6TsEBNWBT+VOc6dY=
=DWyS
-----END PGP SIGNATURE-----

--=-zJN3aKq+YKxdEAXWjM0O--
