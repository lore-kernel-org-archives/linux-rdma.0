From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH V2 mlx5-next 0/2] Mellanox, mlx5 new device events
Date: Fri, 01 Jun 2018 12:49:01 -0400
Message-ID: <e853254acc261f1acb6108b633d713576b5193b9.camel@redhat.com>
References: <20180530175950.9488-1-saeedm@mellanox.com>
         <20180531.153603.45475041396194381.davem@davemloft.net>
         <82ddad11b6a77aa07238ff50ae8769360bfb583b.camel@redhat.com>
         <20180601.114558.569563972122502762.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-MZHMRFkVm1RHtS+lb12o"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180601.114558.569563972122502762.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: saeedm@mellanox.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, leonro@mellanox.com, jgg@mellanox.com
List-Id: linux-rdma@vger.kernel.org


--=-MZHMRFkVm1RHtS+lb12o
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2018-06-01 at 11:45 -0400, David Miller wrote:
> From: Doug Ledford <dledford@redhat.com>
> Date: Fri, 01 Jun 2018 11:08:24 -0400
>=20
> > On Thu, 2018-05-31 at 15:36 -0400, David Miller wrote:
> >> From: Saeed Mahameed <saeedm@mellanox.com>
> >> Date: Wed, 30 May 2018 10:59:48 -0700
> >>=20
> >> > The following series is for mlx5-next tree [1], it adds the support =
of two
> >> > new device events, from Ilan Tayari:
> >> >=20
> >> > 1. High temperature warnings.
> >> > 2. FPGA QP error event.
> >> >=20
> >> > In case of no objection this series will be applied to mlx5-next tre=
e
> >> > and will be sent later as a pull request to both rdma and net trees.
> >> >=20
> >> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.g=
it/log/?h=3Dmlx5-next
> >> >=20
> >> > v1->v2:
> >> >   - improve commit message of the FPGA QP error event patch.
> >>=20
> >> Series applied, thanks.
> >=20
> > Hi Dave,
> >=20
> > Although in this case it doesn't really matter and we can work around
> > it, this was supposed to be a case of the new methodology that Saeed an=
d
> > Jason had worked out with you.  Specifically, when Saeed says in the
> > cover letter:
> >=20
> >> In case of no objection this series will be applied to mlx5-next tree>
> >> and will be sent later as a pull request to both rdma and net trees.
> >=20
> > then it is intended for you to ack the original patch series, not apply
> > it, and when acks from both the net and rdma side have been received,
> > then we will get a pull request of just that series.
>=20
> Sorry, I saw your ACK and misinterpreted the situation.
>=20
> I'll be more careful next time.

Understandable, thanks ;-)

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-MZHMRFkVm1RHtS+lb12o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlsReP0ACgkQuCajMw5X
L92AiA//ZgpDQnq3ax9SYYlnMVnBR0R4r7gchlx7tE4SYajTalqUiKntur+ag1XQ
SXy3az7uUpAYLogIxRGQE3E9x6G3TH2ssmoZjNXNuFTCof9Q1Ew1jcsIQM7gFvHO
twOvLKpbIpXjoI+4ahBp6uNY0ger4BMiPtLQbm8DFChAtwG+mFBwUzBouM7Ve94Y
faq1WwqkJw/Ra01byC863xJgHp9+kqgX8NKj00rL+C6jlUDhzFBPEOevE8DavObq
gooi9hW+9Za5Fs7+rQlVWz0WuUqBEjJvBUj2QKbcHp8ZlUkGrcJISsCzd/9a+cYU
HVMD1zivfjcf5mGHxlhakj/tpTENd94WWlmPv7v952N/tNSVAZEBpjk2n5aWrarS
pku18AihxWal3mPmqibjKoTK0SjYucGu4tEiU9LOQNE2VcKAwwlJk1lpfhDw7Muv
EISiSghyj2e0TFf1nbu2PUfNJNx+C+Jo5vOjdnmtRSFTTwUuHsWQc42YEe7JwW+D
pDox5CECCK8FGQT2d9/5+bCE9EWg1MPTYZRxmLBVY9d1vquEJpy6bk3k2T+oHCXe
1K79SZKodCD+b5Ht1CgcscjJPezLsN3pt/2pSuQEMB5eHiaF3QXuwKAdAVJ9SlsD
DOrydGOSYZHXA1VQ4x0Fu4fcZT18SGySJAym33Qdf7cZjcu6Cqc=
=PJSb
-----END PGP SIGNATURE-----

--=-MZHMRFkVm1RHtS+lb12o--
