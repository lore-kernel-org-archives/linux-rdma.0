From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH] IB/core: Fix different types mix in ib_device_cap_flags
 structure values
Date: Tue, 31 May 2016 20:30:33 +0300
Message-ID: <20160531173033.GC7477@leon.nu>
References: <1464602994-21226-1-git-send-email-maxg@mellanox.com>
 <08df9022-e575-da0d-c76d-a28185c9db2d@sandisk.com>
 <20160531171306.GA6618@obsidianresearch.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dkEUBIird37B8yKS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160531171306.GA6618-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--dkEUBIird37B8yKS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 31, 2016 at 11:13:06AM -0600, Jason Gunthorpe wrote:
> On Tue, May 31, 2016 at 08:35:10AM -0700, Bart Van Assche wrote:
> > On 05/30/16 03:09, Max Gurtovoy wrote:
> > >ib_device_cap_flags 64-bit expansion caused a possible caps overlapping
> > >(depending on machine endianness) and made consumers read wrong device
> > >capabilities. For example IB_DEVICE_SG_GAPS_REG was falsely read by the
> > >iser driver causing it to use a non-existing capability. Fix this by
> > >casting ib_device_cap_flags enumerations to ULL.
> > >
> > > [ ... ]
> > >diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> > >[ ... ]
> > > enum ib_device_cap_flags {
> > >       [ ... ]
> > > 	IB_DEVICE_SG_GAPS_REG			=3D (1ULL << 32),
> > >      [ ... ]
> > > };
> >=20
> > How can this patch make a difference? The presence of any constant
> > in an enum that does not fit in a 32-bit integer makes an enum 64
> > bits wide. In other words, all the changes from "1" into "1ULL" in
> > this patch do not have
>=20
> The expressions are evaluated before the enum type is decided, the
> enum type has no impact on the type of the expressions.

It is machine/compiler dependent.

Bart,
Can you share your source of C-standard?

This link [1] states in chapter "6.7.2.2 Enumeration specifiers"

"Each enumerated type shall be compatible with char, a signed integer type,
or an unsigned integer type. The choice of type is implementation-defined (=
110),
but shall be capable of representing the values of all the members of the e=
numeration.
The enumerated type is incomplete until after the } that terminates the lis=
t of enumerator
declarations."

And the footnote (110):
"An implementation **may** delay the choice of which integer type until all=
 enumeration
constants have been seen."

[1] http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf


>=20
> (1<<32) is always undefined behavior because '1' is only a 32 bit type.
>=20
> I'm confused why we didn't get any static checker hits on the shift
> overflow - modern compilers warn on that??
>=20
> Jason

--dkEUBIird37B8yKS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXTco5AAoJEORje4g2clinPxkP/jbWfLwdpiUlAIdXLVi2KkGK
MLlytT3Ib5V+XXDEewmgxOCLUjyUPKDCe+DS3rhaOsojj8Ptia2ze3RFnrD9j1kp
xV/hVEIwa7iyyh1wCJsnfQF+ZLxDT7njL0wkpNsvtGHYRlj7395nfjadikdUHrzw
YnWiAb8sayeLl6WSL2X2jZtldG2rvRc3xVeVO0igtQaHNXyJ/7+MNd/V5nji65aU
3f/ZMZkqXOWEPM706OmwUx2KXabP0/ZEyL8Sy8zXnYZrhhJBG+upTLqrVlKUpsNe
BbBMZ1h6WKoJzybkaWgZOdARkpUltYRmrqK3UeV37Lush0+pWBReGQ1w6QaORabj
LwK2YM96epV08P6DqkGuE/BzfoSxJ3F3kLQE2gVitu0IDe+3U8K0qlQzX0SDtSHE
w/XCtDOTx3fGrwJRMBY8cW373FMjUJIQDP1EyPOq0me6xY/2D8h921HXAn0891up
jkTS/XAifanXF3PklcXmfPeRMkw8pUK/n3urp4JP9Dr4gXCiZ/jdRswhAmFO12t7
TqiKzfug99RLAXRCc0vnyks76A7A9QhVvm2xtSC8JvhQruFg+TGACLKoH5VJfnVg
4p2bKUKl4JeUNL82FYl4nFIJwkeLsmbHDaQv5USNG00URowu04tO9U4CJPOiTnmi
ctzdJZH1t+leeqFKQAfD
=H7q0
-----END PGP SIGNATURE-----

--dkEUBIird37B8yKS--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
