From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 29/37] IB/rxe: Switch from dma_device to dev.parent
Date: Tue, 14 Feb 2017 11:47:28 -0500
Message-ID: <1487090848.86943.81.camel@redhat.com>
References: <20170120210437.26389-1-bart.vanassche@sandisk.com>
         <20170120210437.26389-30-bart.vanassche@sandisk.com>
         <D4AFCE43.A031%Andrew.Boyer@emc.com>
         <1485555269.13218.10.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-HeZcCbvzg6KGjb2HlNGP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485555269.13218.10.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "Andrew.Boyer-8PEkshWhKlo@public.gmane.org" <Andrew.Boyer-8PEkshWhKlo@public.gmane.org>
Cc: "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-HeZcCbvzg6KGjb2HlNGP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2017-01-27 at 22:14 +0000, Bart Van Assche wrote:
> On Thu, 2017-01-26 at 21:06 +0000, Boyer, Andrew wrote:
> >=20
> > On 1/20/17, 4:04 PM, "linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org on behalf of
> > Bart
> > Van Assche" <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org on behalf of
> > bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:
> >=20
> > >=20
> > > Prepare for removal of ib_device.dma_device.
> > >=20
> > > Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> > > Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > ---
> > > drivers/infiniband/sw/rxe/rxe_verbs.c | 6 +++---
> > > 1 file changed, 3 insertions(+), 3 deletions(-)
> > >=20
> > > @@ -1234,7 +1234,7 @@ int rxe_register_device(struct rxe_dev
> > > *rxe)
> > > 	dev->node_type =3D RDMA_NODE_IB_CA;
> > > 	dev->phys_port_cnt =3D 1;
> > > 	dev->num_comp_vectors =3D RXE_NUM_COMP_VECTORS;
> > > -	dev->dma_device =3D rxe->ifc_ops->dma_device(rxe);
> > > +	dev->dev.parent =3D rxe->ifc_ops->dma_device(rxe);
> > > 	dev->local_dma_lkey =3D 0;
> > > 	dev->node_guid =3D rxe->ifc_ops->node_guid(rxe);
> > > 	dev->dma_ops =3D &rxe_dma_mapping_ops;
> >=20
> > ifc_ops was recently removed, so this will be a minor merge
> > conflict.
>=20
> Hello Andrew,
>=20
> Thanks for the review.
>=20
> Doug, do you expect me to resolve this merge conflict by rebasing
> this
> patch series (something Linus doesn't like) once Linus has pulled
> your
> v4.11 pull request or are you going to explain to Linus how he should
> resolve this merge conflict himself?

I'm going to do a local merge fixup run before I send it and will
notify Linus of any fixes needed.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-HeZcCbvzg6KGjb2HlNGP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYozSgAAoJELgmozMOVy/duagP/ihOaqq+gYCshcXYzazhPfOe
6ROeJLi6QKCGO4192SoSEuFhLaaItYoMsR17VPesU44k/evH6YBXaq5S8yX3Xo5s
XKkdatfJ2O/La9YDiH1KQcyAfZgIYfpLWHS741TEZFvy9PgC7NyNkJprYPxVRMWn
+hkIdy3tV8ReBMB4Z3+9ZwDCzr8gUnKtKVgKMgAeZXJYdeIOtCAWK9DWvAL6Kw1H
TvrBizub3OpTbINY267wC+IQV9epJlbn5cJE2h2iOny4mUY1QaKMKvy0lNlmG0xh
XcmpatRJ34jXW05gAfzo5pYTrwfTdn6JswXtXvgquVS7QXtVmGWKZ05nJVuOCL5D
PurT4Pim5ddfaN3C/fdghocb4zFk14dtGBDxYJ6y0R112dW+wG3db18CMj3x54Rx
vgF8tcptoKMz/1U5rwyKBF7+PVano6sBHrjiNBd14HAMUlGQdHFsMxilVkx3MU0J
njhUT3POnFs0pezt+x40D087YJFwXGLm78Q/3Dg7XSdqthUeSMWev2aeXTwoJ7xF
EzpkgbJK2vYOQhyxW4/x7RbCJml7bMsg9VhFwbFFqa/aBwtZvPApaLFKssEB/xiB
K/4r97auS2+LHzoi0ZxuqqdUrzA80Sekq288x0NFIkVTfcT49wNwqXz9tq1ZQ9Mx
NibEjs5aPV5F0obPCiv4
=j4zn
-----END PGP SIGNATURE-----

--=-HeZcCbvzg6KGjb2HlNGP--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
