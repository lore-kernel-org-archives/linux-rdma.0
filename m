From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Missing Patches in Linux Kernel RDMA
Date: Tue, 10 Jan 2017 13:52:57 -0500
Message-ID: <1484074377.2149.23.camel@redhat.com>
References: <20170110143018.GM7218@mtr-leonro.local>
         <1484067238.2149.15.camel@redhat.com>
         <20170110182815.GN7218@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-cqkGlKuHzxTb4vODJ28A"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170110182815.GN7218-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-cqkGlKuHzxTb4vODJ28A
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2017-01-10 at 20:28 +0200, Leon Romanovsky wrote:
> On Tue, Jan 10, 2017 at 11:53:58AM -0500, Doug Ledford wrote:
> >=20
> > On Tue, 2017-01-10 at 16:30 +0200, Leon Romanovsky wrote:
> > >=20
> > > Hi Doug,
> > >=20
> > > While reviewing patches on mailing list, I was amazed to see
> > > patches accepted before, marked such in patchworks but don't
> > > exist in the Linus's tree.
> > >=20
> > > The first patch which brought my attention was Christoph's change
> > > "IB: merge struct ib_device_attr into struct ib_device" [1]. The
> > > other
> > > missed patches were from our pre-ABI series "Refactor RDMA IOCTL
> > > declarations" [2, 3].
> >=20
> > I obviously had these in my tree at one point, the last message I
> > wrote
> > in response to the 6th patch makes that very clear. =C2=A0But, the patc=
h
> > series is indeed missing. =C2=A0I must have failed to merge it some
> > time,
> > but thought I did merge it and moved it to my post-merge area which
> > then eventually gets removed. =C2=A0I'll have to re-grab them.
>=20
> Thanks,
> Can you please publish official branch with them?

They are in my k.o/for-4.11 branch.

> Matan is going to send ABI patches very soon (they passed our
> verification) and he needs to be based on them.
>=20
> >=20
> >=20
> > >=20
> > > I'm adding to CC major contributors to this subsystem, since I
> > > don't
> > > know
> > > if any other patches are missing too and don't know how to check
> > > it
> > > without
> > > doing full compare of Linus's tree with linux-rdma patchworks.
> > >=20
> > > However for these 7 patches, can you please grab them from
> > > patchworks
> > > again
> > > and resubmit?
> > >=20
> > > Thanks
> > >=20
> > > [1] https://patchwork.kernel.org/patch/7372541/
> > > [2] https://www.spinics.net/lists/linux-rdma/msg39954.html
> > > [3] https://patchwork.kernel.org/patch/9312603/
> > > =C2=A0=C2=A0=C2=A0=C2=A0https://patchwork.kernel.org/patch/9312593/
> > > =C2=A0=C2=A0=C2=A0=C2=A0https://patchwork.kernel.org/patch/9312597/
> > > =C2=A0=C2=A0=C2=A0=C2=A0https://patchwork.kernel.org/patch/9312601/
> > > =C2=A0=C2=A0=C2=A0=C2=A0https://patchwork.kernel.org/patch/9312595/
> > > =C2=A0=C2=A0=C2=A0=C2=A0https://patchwork.kernel.org/patch/9312599/
> > --
> > Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > =C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
> > =C2=A0 =C2=A0
> > Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57
> > 2FDD
>=20
>=20
--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-cqkGlKuHzxTb4vODJ28A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYdS2JAAoJELgmozMOVy/dZp0P/12iHVi2jXlVjOi1/VSJo1cS
7EqfL3wtPLlIV34GnCa5k0gIK5KbcpSa8TAwaeufdj6k/IKJ7wTGgasFeK/Di9jP
vFCHo5mqMcGqjRyEp0dzp8qT58c8MBoGHy42p2whV8QaZGPXWWqOTCe4dMrD3yyF
CX4eIsLosUKFjuvAPm86YLG3fPV88Uwpo4EeY+1dFvMtw29htZ3Z0rBI1uMKSmiM
CmvbTJZ2t0h7MWQcNtrRaazd8qplloOL4oSiHTJuLGALSyxofAQMD4Pcnxxt7gzk
cKkjfBVOlBKeV78fDkgTw8Gzzrxwi1I8fdqgNbLDWPhQ1WoEZwGPZAPQemS2HmYI
0rdvuHKc0Gg5gH/Jh6fWyKoWm4HC1XEHQo3InXwXM/G7BGAPzPKCfilP6UC79+MJ
yPIs2cuSNLYScDLdYRYKZGrfR0FSRpREZt7BXYz0UwB1DXAES6/cRmu9/aLphISa
wIPz6z2Z2tzhO55tRaX4/fcNdRnXZ6EBEAmkBMWPnbMzvRssoiQg2/bcnEm7ZoJX
0GX5F0wbyBAqFqkPU6sqgTmNAzXaP6ERjsUiIRni+04AwLkdMhckCNUFbil6s4kH
CznwWB2x9s31pAJ0NPcBg3yQOVn/K1v6PVdLRvN9oC6H+FtFctgVvSCtjURsRbPE
erut+Da1qLSnAecDEqhb
=3umq
-----END PGP SIGNATURE-----

--=-cqkGlKuHzxTb4vODJ28A--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
