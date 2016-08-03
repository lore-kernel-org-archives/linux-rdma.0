From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V1 for-next 0/2] Support for Send Only Full Member
 multicast join
Date: Wed, 3 Aug 2016 08:53:28 +0300
Message-ID: <20160803055328.GE27667@leon.nu>
References: <1467812195-22221-1-git-send-email-leon@kernel.org>
 <CAAKD3BCY+=_q3k+cV9AO7Det9JaPHguTU03K5ueLncbfoSFa2A@mail.gmail.com>
 <1470191872.18081.46.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="10jrOL3x2xqLmOsH"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1470191872.18081.46.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--10jrOL3x2xqLmOsH
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 02, 2016 at 10:37:52PM -0400, Doug Ledford wrote:
> On Sun, 2016-07-24 at 16:11 +0300, Matan Barak wrote:
> > On Wed, Jul 6, 2016 at 4:36 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > wrote:
> > >=20
> > > Added UCMA and CMA support for multicast join flags. Flags are
> > > passed using UCMA CM join command previously reserved fields.
> > > Currently supporting two join flags indicating two different
> > > multicast JoinStates:
> > >=20
> > > 1. Full Member:
> > > =A0=A0=A0The initiator creates the Multicast group(MCG) if it wasn't
> > > =A0=A0=A0previously created, can send Multicast messages to the group
> > > =A0=A0=A0and receive messages from the MCG.
> > >=20
> > > 2. Send Only Full Member:
> > > =A0=A0=A0The initiator creates the Multicast group(MCG) if it wasn't
> > > =A0=A0=A0previously created, can send Multicast messages to the group
> > > =A0=A0=A0but doesn't receive any messages from the MCG.
> > >=20
> > > Since Send Only Full Member requires SM support a new cached
> > > SA port attribute containing SM ClassPortInfo fields was added
> > > (ClassPortInfo fields: Table 126 IB Spec 1.3.). The attribute
> > > is cached to avoid resending queries, caching is done when a
> > > successful ClassPortInfo reply is received on the port.
> > > Invalidation of the attribute is done on SM change events,
> > > SM re-registration events, and SM LID change events. The fields
> > > in ClassPortInfo should not change during SM runtime without an
> > > event.
> > >=20
> > > The changes compared to v0 of this patch series are:
> > > =A0* Use multicast.c join state enum instead of the new added bits
> > > =A0=A0=A0defined by IB_SA_MCMEMBER_REC_JOIN_STATE in ib_sa.h
> > > =A0* Remove ib_sa_port struct alignment spaces
> > >=20
> > > Alex Vesker (2):
> > > =A0 IB/sa: Add cached attribute containing SM information to SA port
> > > =A0 IB/core: Support for CMA multicast join flags
> > >=20
> >=20
> > Hi Doug,
> >=20
> > This series conflicts with c65f6c5a3650 ('IB/core: Fix RoCE v1
> > multicast join logic issue') which was merged to your k.o/for-4.7-rc
> > branch.
> > The solution for this conflict requires to take the hunk for cma.c
> > from this series.
> >=20
> > If it's required to respin this series above c65f6c5a3650, please
> > just say so.
> >=A0
>=20
> I'm not entirely sure what you are referring to. =A0The series applied
> cleanly for me. =A0However, it's in my misc branch (to be pushed shortly)
> , please double check that there isn't something wrong.

I checked it and everything looks correct.

Such false alarm came from our internal merge test of net-next which
was based on v4.7-rc5 stage and your rdma-next (+ our patches) tree
which was based on v4.7-rc4.

Thanks.

>=20
> --=20
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>               GPG KeyID: 0E572FDD



--10jrOL3x2xqLmOsH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXoYbYAAoJEORje4g2clinW0kP/jqjxxh/pNWS3BCpT1rySPRc
NA/jvu3HZyJMETy05YUX7bAZWXYHxb+L30xm9uspQH/c7iyXQuWGi6vZ+fdBuGjS
5aiqhWJDr/E2s1t9OJTbw6biveHKkX6oDmNsSmTu0pwvdTlS230pZJlN3N5S9Y4B
Rp1EsU+mNJ0sCE4Xl9SyRiUGibyzniVN7HgZj7TArXnGT6B5DsHvnrPLcyEOjkkX
PxFrwQwfRT6yPBU79gJykLQqAB4QDXCg5wUPLoPskLQ2f2OfGYPghZIsY5p0D+Dz
iZfof3lEVU4YlpfqlXet4k3Ep7i7BNbYuskfo6y215b4LSj762dFwt3T3p6uIoqf
E2qpS+A/dCow6N66wA117cfPfe/tdGbRkyJjP8q3iXZFkcZAIE42dnmXbGMxG9S7
s9Ved/CAHI8qUEGhbBsS/y1jS+ToxsxQEopkSgMKclYyG5yH3sLswOy5jrFUZUn4
rij+pUQSuw2Kv6qH3IAfNt6+2AxJSX6Rhu9X4pNaT8IvfYebWgkUNJWHF0+vspyf
jHgyThNt2/Dammk3MkOYr8Tah87LG2Jf0iUGrFllSdN6S0ZUt+GuvqanyP4L4J7r
BeAcGqnByLDv47wXXyqoG6/T6eWBitbaEBn9ZJKuWDz4jaZhsUgF/kHgUJVYiY89
aGc/i1urHLo6xdZAtUvk
=z1Yv
-----END PGP SIGNATURE-----

--10jrOL3x2xqLmOsH--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
