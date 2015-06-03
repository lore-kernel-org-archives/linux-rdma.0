From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] libibverbs init.c: conditionally emit warning if no
 userspace driver found
Date: Wed, 03 Jun 2015 12:50:09 -0400
Message-ID: <1433350209.40123.55.camel@redhat.com>
References: <1431440068-19037-1-git-send-email-jsquyres@cisco.com>
	 <BED0001D-0051-4ACD-8506-8FA07E625694@cisco.com>
	 <1432044878.5304.1.camel@opteya.com> <1432049804.3114.41.camel@redhat.com>
	 <1432133301.5304.10.camel@opteya.com> <1432139226.3114.83.camel@redhat.com>
	 <1828884A29C6694DAF28B7E6B8A82373A8FDD9BC@ORSMSX109.amr.corp.intel.com>
	 <1432141870.3114.89.camel@redhat.com>
	 <B397943B-9919-47CC-94E9-98A2A0BEFE8F@cisco.com>
	 <1432305861.28905.83.camel@redhat.com>
	 <22F52D8B-92CB-47B2-8A9A-DD20B36C3305@cisco.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-rlt59NMBAsGU1hpAYvJ+"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <22F52D8B-92CB-47B2-8A9A-DD20B36C3305-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-rlt59NMBAsGU1hpAYvJ+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2015-06-01 at 22:02 +0000, Jeff Squyres (jsquyres) wrote:
> On May 22, 2015, at 9:44 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> >=20
> >> Did that happen yet?
> >=20
> > I don't think so.  I didn't file a specific ticket for it at k.o yet
> > (the k.o tickets take a while to process, so I didn't want to file it
> > until after the comment period here on list).
>=20
> Ping.
>=20
> This is just a periodic query to see if there has been any progress on ac=
cepting this patch into libibverbs.
>=20

I have a ticket with kernel.org helpdesk to change the permissions on
the libibverbs.git repo, and they are waiting on Roland to ACK the
change.  Until then, I can't do much.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-rlt59NMBAsGU1hpAYvJ+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVbzBBAAoJELgmozMOVy/dvvkQALMmXVxkOv7x6sbqMbeRSTCY
lp7wOFu6yDE09zneTanaUFexCSJCYGMtIEEc59eVc2JwZmFzEz2tGQIvZJpB512B
ZvPhl9tyfg1+EV6pud15ydNi1SHLYwQZG5SkhzNx2JyO5dx3dpk95tT+xDoPxC/7
nyfefsrT26Jk1xVdpNc7Q/EYLuwpf9geryUiw/hzYWG+R5mr778DbbPQLvPaa8dU
qe3DAFiuSCXItkIkflE/fuV7mowJ3OYEyp9/DUmYi+jGMQp79R6H3gVOZhDuosVa
oPwjhy/XId/r9Yd6rHQF4qW90RbtyCHmsBHyv/udkpk3rmqFEuB2Q1nwa6d5/3TS
flLPniWJpkEQJYUm51nDcO+Q0+2bTmPuCGa1TOeTXxpdzwsti9DZWGYVypF3ALkM
k9iai7Pv62fFEBl20LBpL6fm4xM2GYxxaIAsX9nccMrWiaO60C7tvZZhJKiI6vzV
adL1yZE8VeNs0Erw/x6N5AFpv/42ZISoMaC9pGm003kednupAVnAZa8kmuqeMlUr
tSQMmQxUIfuujPQkwRf/ErUa4EFM0eZoNXxX++ccUTuo1OfzW9iMrt7PifQL3gKX
cV6ax0zUlE971fQPDN/ghZGIsO8puFs3KWZCPgL+5YstqUSfgNUDgM1Krf/kI5zI
TEryVa2bogi1B1HPpv4b
=1/HD
-----END PGP SIGNATURE-----

--=-rlt59NMBAsGU1hpAYvJ+--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
