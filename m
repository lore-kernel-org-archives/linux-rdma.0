From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 00/18] IB/hfi1, rdmavt, qib: First batch of
 fixes for 4.8
Date: Tue, 02 Aug 2016 15:58:42 -0400
Message-ID: <1470167922.18081.43.camel@redhat.com>
References: <20160701225824.20160.19055.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-wHXrHy5ywbHO2b1iN1Vc"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160701225824.20160.19055.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Pawlak <jakub.pawlak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ashutosh Dixit <ashutosh.dixit-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-wHXrHy5ywbHO2b1iN1Vc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2016-07-01 at 16:00 -0700, Dennis Dalessandro wrote:
> Hi Doug,
>=20
> Here is a set of fixes and improvmenets that would be for the next
> release. They
> apply onto of the last set of RC fixes previously posted.
>=20
> Of particular note in here is the twsi code clean up that was asked
> for
> previously while we were in staging. I think this does the job of not
> duplicating what is already present in the kernel. These are the two
> patches
> from Dean.
>=20
> The patches from Mike improve rdmavt and make the posting of sends
> more friendly
> to work with and extend.
>=20
> There are also performance improvement patches in this bunch as well
> as well as
> a couple minor fixes that we felt are more appropriate for the next
> merge cycle
> rather than RC.
>=20
> These patches have been added to my GitHub branch and have passed
> zero day
> builds.
>=20
> https://github.com/ddalessa/kernel/tree/for-4.8
>=20
>=C2=A0

Hi Denny,

These are in. =C2=A0I had to rebase in order to rip out the V1 of patches 8=
,
9, and 10, and then put the v2 in their place, but that's done as well.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD

--=-wHXrHy5ywbHO2b1iN1Vc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXoPtyAAoJELgmozMOVy/d9WUQAK8XUp8DzhMEETukNxEDO1Sn
DRkrXjq3JDXUuZk91ynLFOFh3fahWflyoCYiI/99XMJTEixfP3+rBkvC5KuhE5rd
WKtdHI3FZstyxZVRSfLaWu8FbX/ph6iXbz6E9LB0dYeSeYjPvOytZ6cep4DJ7WsK
7gk+HhLpnBEOt8tP4FZn6+u6GKjqGhxxOlJX2XTpxIrznkQ5+sPCFUmxkvvsImsM
tK/9fnZTRn7eYvP7w3ar7rOEkEEJ2qHAP0vma99ZCxnBtlRXZ/bSRow+IObyDrR3
Bk/tH6L/V7L6QiUqWpmqy1xcKaYe1gXFBz/k/l8u5eYD90X+gv8nnmq9QaBzAvSn
sotpkC0i5m+clWN+VX75SPgwSJLxZCChVvCScXjW50naGKK9EKruERbjeEDr9lMK
xQbwTx1PHqGZJogk0UliR9EFwYH8JzTDjCw8/zUq994iZGQ/iTF5cMXAxL5BiXkv
wwsyca32m9AzjIod0gMsfPNP2tbkI1VktamIcHTkR4fYE4w7Wcv2edr17YiEdynS
EdoJ+gt7wLONdOjAaGRzM2Y9Ppe0Suu4NvGuUUu9LBs+KvmSLQkWCYON8fwZr6UV
BCmahycDolJhoEkJB2+e2pr3PcatuMW1NqN9O94SsMJZZctSStuZQ9lYXVceq1CZ
5lsD4/cug+iIgidPbR+2
=mP9X
-----END PGP SIGNATURE-----

--=-wHXrHy5ywbHO2b1iN1Vc--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
