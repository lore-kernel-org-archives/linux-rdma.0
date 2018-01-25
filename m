From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: get_maintainer.pl bug?
Date: Thu, 25 Jan 2018 10:53:29 -0500
Message-ID: <1516895609.27592.126.camel@redhat.com>
References: <20180124112323.GA8265@yuvallap>
         <20180124115445.GH1393@mtr-leonro.local> <20180124162802.GB16845@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-UjGpFCFufqPT4OUXVUW5"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180124162802.GB16845-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-UjGpFCFufqPT4OUXVUW5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2018-01-24 at 09:28 -0700, Jason Gunthorpe wrote:
> On Wed, Jan 24, 2018 at 01:54:45PM +0200, Leon Romanovsky wrote:
> > On Wed, Jan 24, 2018 at 01:23:24PM +0200, Yuval Shaia wrote:
> > > Hi,
> > > This is what i get when running scripts/get_maintainer.pl drivers/inf=
iniband/:
> > >=20
> > > Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> (supporter:INFINIBAND SUBSYSTEM)
> > > Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org> (supporter:INFINIBAND SUBSYSTEM)
> > > linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (open list:INFINIBAND SUBSYSTEM)
> > > linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (open list)
> > >=20
> > > However section "INFINIBAND SUBSYSTEM" pointed out a different addres=
s for
> > > Jason:
> > >=20
> > > INFINIBAND SUBSYSTEM
> > > M:      Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > M:      Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > L:      linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > W:      http://www.openfabrics.org/
> > > Q:      http://patchwork.kernel.org/project/linux-rdma/list/
> > > T:      git git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rd=
ma.git
                                                                ^^^^^^^^
This is wrong though.  We need to update that.   I'll fix that right
now.

> > > S:      Supported
> > > F:      Documentation/devicetree/bindings/infiniband/
> > > F:      Documentation/infiniband/
> > > F:      drivers/infiniband/
> > > F:      include/uapi/linux/if_infiniband.h
> > > F:      include/uapi/rdma/
> > > F:      include/rdma/
> > >=20
> > > So
> > > - Which one is the correct one?
> > > - What am i doing wrong when using scripts/get_maintainer.pl?
> >=20
> > Both are correct, and the jgg-uk2M96/98Pc@public.gmane.org email is taken from .mailmap
> > file.
>=20
> Yes, I prefer the ziepe one for bulk/automatic sorts of email, that is
> why it is in the mailamp.
>=20
> Thanks,
> Jason
>=20

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-UjGpFCFufqPT4OUXVUW5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpp/XkACgkQuCajMw5X
L92iaxAAv+xz+8L+Biog4fZRUb7+nw7/YJSFJnHCY2/FF2fvehVI94FwfDCVKQAV
4hSKSX6QcyB+cZvbffgQBZHXppKyK69JvtZRC73XPNsd1L5qQMoElMIka0rAIFNo
dSfYQsFdlH4GVph2+NKE77VK8o29zsqi29Enkpdb6N6VBbwXBF/M+r5N1IT4FFVC
DaEmaAZAXFx3ncJMqXm96XtTfhBHDLzPccj8y+mjKzVELJyzg7cpJDaEy30DHpP5
cq6WYyQztpfDzOEzVI1xfFCPtESkdbKn8LW9cfasbifK+imZpZLz56c2eRk+KIkp
+MWp0Ofaoa2w9+4bYJ38Ae4UuW6GMUe8qR7G3sxuw+OUQBXRcsX5JwZJhfY6OT0U
GDRuYz11tJRZ75FKAbpPneaDxS95nuo67DZYl4Bn29y2pMeNYPdKLK2AiLRYYiIq
Z+RPMepfw2gR4kEZfu6PbvVUieMHSAFS2prHm68RDloJsrbjXnxU9JGwWyutzxeu
muQuuSCajmoxKqEaMowtD48fZojh8pqfw9ZjN7WClCK04W8vM6TfFYxmZV1KD6c6
JGX9LkRCBdctGqHT0HIrbcyEGgv3plcjAeysmrpPtm7rw02OWcIJc6tS2S1rhiCr
CPMEK5TmnxM6fg1qiOMm8Dqn0BzJM3LdZuh/lFmcU6W1mCGqfTg=
=fsyX
-----END PGP SIGNATURE-----

--=-UjGpFCFufqPT4OUXVUW5--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
