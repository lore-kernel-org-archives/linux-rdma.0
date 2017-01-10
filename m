From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Missing Patches in Linux Kernel RDMA
Date: Tue, 10 Jan 2017 11:53:58 -0500
Message-ID: <1484067238.2149.15.camel@redhat.com>
References: <20170110143018.GM7218@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-gWygskbsj2IOc3p79Vpn"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170110143018.GM7218-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-gWygskbsj2IOc3p79Vpn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2017-01-10 at 16:30 +0200, Leon Romanovsky wrote:
> Hi Doug,
>=20
> While reviewing patches on mailing list, I was amazed to see
> patches accepted before, marked such in patchworks but don't
> exist in the Linus's tree.
>=20
> The first patch which brought my attention was Christoph's change
> "IB: merge struct ib_device_attr into struct ib_device" [1]. The
> other
> missed patches were from our pre-ABI series "Refactor RDMA IOCTL
> declarations" [2, 3].

I obviously had these in my tree at one point, the last message I wrote
in response to the 6th patch makes that very clear. =C2=A0But, the patch
series is indeed missing. =C2=A0I must have failed to merge it some time,
but thought I did merge it and moved it to my post-merge area which
then eventually gets removed. =C2=A0I'll have to re-grab them.

> I'm adding to CC major contributors to this subsystem, since I don't
> know
> if any other patches are missing too and don't know how to check it
> without
> doing full compare of Linus's tree with linux-rdma patchworks.
>=20
> However for these 7 patches, can you please grab them from patchworks
> again
> and resubmit?
>=20
> Thanks
>=20
> [1] https://patchwork.kernel.org/patch/7372541/
> [2] https://www.spinics.net/lists/linux-rdma/msg39954.html
> [3] https://patchwork.kernel.org/patch/9312603/
> =C2=A0=C2=A0=C2=A0=C2=A0https://patchwork.kernel.org/patch/9312593/
> =C2=A0=C2=A0=C2=A0=C2=A0https://patchwork.kernel.org/patch/9312597/
> =C2=A0=C2=A0=C2=A0=C2=A0https://patchwork.kernel.org/patch/9312601/
> =C2=A0=C2=A0=C2=A0=C2=A0https://patchwork.kernel.org/patch/9312595/
> =C2=A0=C2=A0=C2=A0=C2=A0https://patchwork.kernel.org/patch/9312599/
--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-gWygskbsj2IOc3p79Vpn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYdRGmAAoJELgmozMOVy/dUWQP/0a3cFbpyWqzgyKlrKscB8+Q
XAPzUu/yWOiY9vPGywioy8nIUh6hma/rEOrliw5PNTPvU5IhaWkaW3MuOPmqX90e
deQut1UIgEo70ccg7jwpMRQj3GGDVdTjG/xIabBKH9kdWiKlmoRSRsuKEYuc1YA4
C60Rj/xq8ZESukJN9RyJwM0vP8nz3WivqVjhwJ5WR5ZL0udFzRUatnc8NlcxlF7e
jJafmLSxnElU6IHWJkZWaSi/s3SPpELros+SpA7vKZxVQKzBGmDlYFl8ISHene0D
3tcpfPmSWH72DSACkU9YFL1QmY8Ib4SR5K+SCY35zU43MoJIWHeVBROOquFB2Bl8
7VgdGLawMl6xs2/RT65+8c49yg9/KdE/A7Z9MuJJRRhrirwYdoebSKW4uTKktNk+
ak7yN2Bbb2FqDJH0DriRyEjxLoWhotyhnXvi150LW2Pu+Dn8/dmdWCUpdLvuKlrl
OKyt96TR7fxhmwDkd+HLE2AC3lQj4OmQ1EyPhFgu5FAXM3RrDz+HBqX1Q0bDkNVA
bjkaqrytuEJ2PDlJrpdVdR4wcVpXyngandgCkEAuPVWAG0lLstakuvSDsEDd1+2h
PRrxNXroM97+YJ9px+W9rOKwOByQMrQSraTVpWw6cC9Equ1Biw2d2xFwGJ5yP80G
CBE4qbXeDOAmZXxjy/wV
=ZbBM
-----END PGP SIGNATURE-----

--=-gWygskbsj2IOc3p79Vpn--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
