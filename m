From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: 4.4's rdma plate
Date: Tue, 8 Dec 2015 16:44:01 -0500
Message-ID: <56674F21.8020702@redhat.com>
References: <CAJ3xEMhniP7x3NCM51nCccB7wBiQfWiyqaeVm8cdx=SuotrHYQ@mail.gmail.com>
 <CAJ3xEMiF1xrwBb4B54HEJVWAds76i9oPkKx-ROf3tubeH6a8TA@mail.gmail.com>
 <561E510C.8060501@redhat.com>
 <CAJ3xEMiZCrj83XK6R0za61SenfzDh5H3wF-DTanvsk1Hha7MKA@mail.gmail.com>
 <56266C4B.1060000@redhat.com>
 <CAJ3xEMhexSZhkVVqZaCxvYYKXay6FWrUsXoKgmW=Q-+2pcdN8w@mail.gmail.com>
 <CAJ3xEMiDpiVWeW7MVs8VuULj39VchDW==OpqB28ni3U_=i5Dog@mail.gmail.com>
 <562A57AB.4000702@redhat.com>
 <CAJ3xEMj397H-9Jrfk3K+MX92d6Q4gNA8w2tkKM6LytodPSbP-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="FKrv1RIBD8AgqT4KQkFuIIBuNv3pWuCFO"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMj397H-9Jrfk3K+MX92d6Q4gNA8w2tkKM6LytodPSbP-g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FKrv1RIBD8AgqT4KQkFuIIBuNv3pWuCFO
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 12/08/2015 04:07 PM, Or Gerlitz wrote:
> On Fri, Oct 23, 2015 at 5:52 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
>> On 10/23/2015 02:46 AM, Or Gerlitz wrote:
>=20
>>> Doug, there are few singleton patches to mlxN drivers, just to make
>>> sure they are not left behind (thanks)
>=20
>>> a small mlx5 enhancement, Signed by Eli C. the driver maintainer
>>> https://patchwork.kernel.org/patch/7454641
>=20
>>> two small mlx4 fixes, acked by me...
>>> https://patchwork.kernel.org/patch/7348911/
>>> https://patchwork.kernel.org/patch/7348871/
>=20
>> Yes, I know.  There are quite a few different things for mlx5.  I was
>> waiting on all of them until I knew that RoCEv2 was in as that gates
>> whether or not mlx5 RoCE can go in.
>=20
> Doug,
>=20
> So RoCEv2 didn't make it for 4.4, but still, the above are changes
> touching driver only code and I don't see why they should be waiting
> so long.

I knew some of the mlx5 changes relied on the RoCEv2 stuff (such as mlx5
RoCE support).  Others are larger in scope.  I tried to sort through the
singletons on patchworks today and saw at least one which I opted not to
take as it wasn't really a fix, it was a performance enhancement.  I'll
look over the ones you linked above to make sure I didn't miss them.

> Can we finally see them in a k.o branch of yours please? either for
> your 4.4-rc pull or on 4.5 branch.

I'm getting ready to put out the initial 4.5 branch.  I was only waiting
on getting the last few 4.4-rc patches in so I can then merge that into
the 4.5 base and go from there.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--FKrv1RIBD8AgqT4KQkFuIIBuNv3pWuCFO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWZ08hAAoJELgmozMOVy/dNdgQAJRCMa6eUU+CiSy3ygMgoTFK
VSzPhUQ9edPXFgR4RFSOSAR45Ta5veivwsvT7SyiSN13qGZALlb8rRaPOC05QfcB
OE2K6uDTvSuJQAv3grW3ML34FBCQcUsFYwxCCrMuUjgCdlZszGIK54Rg4db0CJwZ
dnoLjlXBzE6pfGupgGoRmz8vJGNBv27zN7DpToltWLucS+hhYExwaa5DfvQz4TKx
48Xj9p6AJuE2U5oEIMGd++Ur1RAaVZ4/d58TFn4O6sp+j29mlnnMPSXvq1Ko3hsK
2cCMYdvWk4qaj4a4IJVoVVI0RVW+lLerGdMzLtA3sjXe0+OBzpW+9OVXxnGz6o8G
bzvBErP3Z5o7RDBnZmpz9W7jIGt90m82IOB/LN/W3ZhTKP4IS1v7r9PDDivxoLnk
7BqmGZeFAQjE/WHCFugCZZoxXqPenTFv2dTIXV1/S9fuDKhFOFugFTPLulJkNUSR
JI64fcjlQFu9Luy+/VqqkasTZzktc3VakZzHGfAJjHfwgBTbIxqVVANIp2OF8J3E
zCGbKMHLtoJSE7To3ZrRP7W2oCVEJKu35y74DZ/g1ZAtSoc0Mk7pm7X0vUEBbc7F
oAjuzUaEggQihEzZyYkaMqUjk0qvqJeW/s6+21ZOvHNI3eWhcuNRZnrZfogWffQG
jHmsmFW38iyLHE/g6nj5
=N1yc
-----END PGP SIGNATURE-----

--FKrv1RIBD8AgqT4KQkFuIIBuNv3pWuCFO--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
