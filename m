From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V1 for-next 0/2] Support for Send Only Full Member
 multicast join
Date: Tue, 02 Aug 2016 22:37:52 -0400
Message-ID: <1470191872.18081.46.camel@redhat.com>
References: <1467812195-22221-1-git-send-email-leon@kernel.org>
	 <CAAKD3BCY+=_q3k+cV9AO7Det9JaPHguTU03K5ueLncbfoSFa2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-riDOVRuAenrmXzfr4ZXX"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAKD3BCY+=_q3k+cV9AO7Det9JaPHguTU03K5ueLncbfoSFa2A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-riDOVRuAenrmXzfr4ZXX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2016-07-24 at 16:11 +0300, Matan Barak wrote:
> On Wed, Jul 6, 2016 at 4:36 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> wrote:
> >=20
> > Added UCMA and CMA support for multicast join flags. Flags are
> > passed using UCMA CM join command previously reserved fields.
> > Currently supporting two join flags indicating two different
> > multicast JoinStates:
> >=20
> > 1. Full Member:
> > =C2=A0=C2=A0=C2=A0The initiator creates the Multicast group(MCG) if it =
wasn't
> > =C2=A0=C2=A0=C2=A0previously created, can send Multicast messages to th=
e group
> > =C2=A0=C2=A0=C2=A0and receive messages from the MCG.
> >=20
> > 2. Send Only Full Member:
> > =C2=A0=C2=A0=C2=A0The initiator creates the Multicast group(MCG) if it =
wasn't
> > =C2=A0=C2=A0=C2=A0previously created, can send Multicast messages to th=
e group
> > =C2=A0=C2=A0=C2=A0but doesn't receive any messages from the MCG.
> >=20
> > Since Send Only Full Member requires SM support a new cached
> > SA port attribute containing SM ClassPortInfo fields was added
> > (ClassPortInfo fields: Table 126 IB Spec 1.3.). The attribute
> > is cached to avoid resending queries, caching is done when a
> > successful ClassPortInfo reply is received on the port.
> > Invalidation of the attribute is done on SM change events,
> > SM re-registration events, and SM LID change events. The fields
> > in ClassPortInfo should not change during SM runtime without an
> > event.
> >=20
> > The changes compared to v0 of this patch series are:
> > =C2=A0* Use multicast.c join state enum instead of the new added bits
> > =C2=A0=C2=A0=C2=A0defined by IB_SA_MCMEMBER_REC_JOIN_STATE in ib_sa.h
> > =C2=A0* Remove ib_sa_port struct alignment spaces
> >=20
> > Alex Vesker (2):
> > =C2=A0 IB/sa: Add cached attribute containing SM information to SA port
> > =C2=A0 IB/core: Support for CMA multicast join flags
> >=20
>=20
> Hi Doug,
>=20
> This series conflicts with c65f6c5a3650 ('IB/core: Fix RoCE v1
> multicast join logic issue') which was merged to your k.o/for-4.7-rc
> branch.
> The solution for this conflict requires to take the hunk for cma.c
> from this series.
>=20
> If it's required to respin this series above c65f6c5a3650, please
> just say so.
>=C2=A0

I'm not entirely sure what you are referring to. =C2=A0The series applied
cleanly for me. =C2=A0However, it's in my misc branch (to be pushed shortly=
)
, please double check that there isn't something wrong.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD

--=-riDOVRuAenrmXzfr4ZXX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXoVkAAAoJELgmozMOVy/dxbUP/i4bLGQMrS47O6KW2g4SmHcP
RVHt0/VB79s6FUCIW11Q9ySZXAbtVEqrzC+G7ZZbdFrNYlvsMk/jLvgHArTjEM3M
pKCt6y5c+upE3dd3xadMrJpmGFM1dZaat0m+84G3byPCyBjSRvzmMaNjYBzsIY3V
071kOxbRDnXwiGBQ3HfNxekYesYqedsE752zt738m4of9TteWXHRKCo213YK4Cao
Tga95vZPRx8qEOe8hgXrH/pOPTd8nazOkq73LOMEEADcqc0QADjL580IlZLwduKM
AU9Atl9WjSdujr/Uohjw/Lgcm4wXPM+YSo7NcB2TU7tQnw6OWA6vp+XFsSrdf0IZ
KZ92DiBx9fdbO6eB2Lsqyg07/RX/9ZxI7xjVVuRWDvKDJaFjYH4tH9u07+M8aTVV
dYgavZQFj8xbP8E1TCfx0kmDoZdVErX3PFOGqcerYyO1AQjsdU1mzV5cPoSQ9oEy
8c6GNtgYYCizgkbbMKTZB0eC+i9vOfGUkgeyQQcB4XBJLSET8qVGa8vc/zLJg4/p
RvL6VjXRKxC3E9YS/ooJPziYmjSP2YXUwk2Ijk7bkY5lFtSxvbAQHTl4bYAFsAvm
kL4oTRhuXabL1bh2eDj2DoiSdsZ6dGeMN+2uLpE2njyGyFhnBuF6l2CX0dVN7YJW
yHu/TjUF3d4raR65j+H5
=orXa
-----END PGP SIGNATURE-----

--=-riDOVRuAenrmXzfr4ZXX--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
