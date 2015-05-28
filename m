From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: rdma kernel tree
Date: Wed, 27 May 2015 21:14:03 -0400
Message-ID: <1432775643.114391.9.camel@redhat.com>
References: <1828884A29C6694DAF28B7E6B8A82373A8FD8CF5@ORSMSX109.amr.corp.intel.com>
	 <1431485563.43876.93.camel@redhat.com>
	 <CAJ3xEMhRY6nLPFR8qT8S7KJvxRDmw6JwhsSKw7pTvFc5PpnrhQ@mail.gmail.com>
	 <1431530845.2377.30.camel@redhat.com> <5554B7E8.4020902@mellanox.com>
	 <1431615776.3276.14.camel@redhat.com>
	 <CAJ3xEMjgpegf+D2BBZ8RPERkdUO3yH4U1LjiK+i4iF=_PtpQkA@mail.gmail.com>
	 <555ABD9D.3080303@mellanox.com> <1432038160.3114.16.camel@redhat.com>
	 <CAJ3xEMjkECDrbCFksSMMTSUusOhrU+qvMnXjkg=OuFaeYKoT0Q@mail.gmail.com>
	 <1432064993.3114.80.camel@redhat.com> <1432069455.3476.12.camel@dworkin>
	 <CAJ3xEMjk5JyY14ySXQsLRAMewxtqfJBDint6K=wGwnp6SOf9Pw@mail.gmail.com>
	 <1432732409.28905.181.camel@redhat.com>
	 <20150528110203.5cc1e9ce@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-mRufnlU948yT3SL3Vrfp"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150528110203.5cc1e9ce-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-mRufnlU948yT3SL3Vrfp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2015-05-28 at 11:02 +1000, Stephen Rothwell wrote:
> Hi Doug,
>=20
> On Wed, 27 May 2015 09:13:29 -0400 Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> >
> > Stephen, can you set it up so that the linux-next tag from
> > git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git is adde=
d
> > to the linux-next testing please?
>=20
> I haven't fetched tags in the past, only branches (it is a little
> tricky, but I can work on it) and there is no linux-next tag in that
> tree anyway (I assume that you mean for-next).

Sorry, you are correct, for-next is the right tag.

> Also, how does this relate to Roland's infiniband tree
> (git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git#for-=
next)
> that is already in linux-next?

Roland has stepped down as maintainer.  The community selected me to try
to pick up where he has left off.

> Added from today.
> Thanks for adding your subsystem tree as a participant of linux-next.  As
> you may know, this is not a judgment of your code.  The purpose of
> linux-next is for integration testing and to lower the impact of
> conflicts between subsystems in the next merge window.=20
>=20
> You will need to ensure that the patches/commits in your tree/series have
> been:
>      * submitted under GPL v2 (or later) and include the Contributor's
>         Signed-off-by,
>      * posted to the relevant mailing list,
>      * reviewed by you (or another maintainer of your subsystem tree),
>      * successfully unit tested, and=20
>      * destined for the current or next Linux merge window.
>=20
> Basically, this should be just what you would send to Linus (or ask him
> to fetch).  It is allowed to be rebased if you deem it necessary.
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-mRufnlU948yT3SL3Vrfp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVZmvbAAoJELgmozMOVy/dYKUP/0MYhtl61Gz/8vCwUrU8++jm
4txUmb8r9/ELHvFlWI3Y8sFHuXdwJA27uGbW/fclyHCRfUsB4j1DO9ujejhIXS9i
jim41qc7mWtAOs61Kwvron+fT3oSjOGsmFPjGZAgltm7O5oUC2HGqRZheS18rmuh
Ry6c0pNnZDLJZhvaAeQvcg3H/GSMJyZDZ0kofpb60Yq2jMJW/1tWoosAvMPmy0TG
5UJQXazlLTTA3UpYIV8cDWwht5xNAKrXgkeiJuh91emR6Uzw130ow3QJCtFhwLC5
vUnC+x0ezywn39kRwybbiIzWJ1G6EPC65GHY5bvlTbjA7jItaf+Uf+E3kTFJLz3v
KFIGj9cUfYyl/hhlHL0SNyoMj1HNu1Tyws5K0dDCYcOZc1yL+rYeWizB1XUtHPMk
hUPLdb9CPpupcB5Rxpo5jmJysq9OhT29G/aorBZLxTIjz7rQKtX9AgRcDtvCG/o5
owCGajfNqfBqRByDWCuFi2modJIj5MXt6XNmB6QHMi2Ro8SGD0+7Pwd4CJyIaTXK
uz5pDKrxq78++PdmOCHBqxRij732F8ldkg5kT7kxk3Dq6+b+KRcFZlhjLLErHBph
qBGdQPcdWRTEQs/i7Nhi21YR5multUnkPiwektzSA+vVEI/Lnkwlo9XZhUnZUl61
cVxtJdP13v1SeUkGcpgC
=XVsF
-----END PGP SIGNATURE-----

--=-mRufnlU948yT3SL3Vrfp--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
