From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 for-next 0/7] Add support for multicast loopback
 prevention to mlx4
Date: Tue, 6 Oct 2015 12:05:25 -0400
Message-ID: <5613F145.3040204@redhat.com>
References: <1440081275-15864-1-git-send-email-eranbe@mellanox.com>
 <CAKHjkjnQNqeLu+irEg97a1hcKp_ziXsDOFaTRwcaPpZAX_fMng@mail.gmail.com>
 <560AD75A.7080700@redhat.com>
 <CAJ3xEMiuPEJZ5EQueC=8wQyok2QbEaywQ3gRYVpqOwSaFQcj0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="17GMDhiRNiu4NUL9bsbsBTXHrAWlExqFN"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMiuPEJZ5EQueC=8wQyok2QbEaywQ3gRYVpqOwSaFQcj0A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--17GMDhiRNiu4NUL9bsbsBTXHrAWlExqFN
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 10/05/2015 05:59 PM, Or Gerlitz wrote:
> On Tue, Sep 29, 2015 at 9:24 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
>> I'm getting ready to tackle the for-next backlog.
>=20
> Sounds, good, rc4 is here... so lets get things going. I see that
> there is a 4.4 branch @ your kernel.org tree with the checksum bits,
> is there anything else which you've already picked into your github
> branches or this is all for now?
>=20
> Re the backlog, we have Eran's multicast loopback prevention patches
> (this thread, Haggai's work to actually add name spaces support [1] on
> top of his effort for demuxing requests which landed in 4.3 and
> Matan's subsequent RoCE work, where these all stand?
>=20
> Or.
>=20
> [1] http://marc.info/?l=3Dlinux-rdma&m=3D144068579319679&w=3D2

I'll have some sort of answer for that soon.  I spent the better part of
last week, and what time I worked on the weekend, plus all day yesterday
on the internal infrastructure here at Red Hat.  We're experiencing some
growing pains in our cluster and some downtime as a result that keeps me
from being able to test code effectively.  I wouldn't be surprised if it
takes another day or two to get it completely sorted out (or sorted as
best I can, some things are out of my control).  Then I have to see if
any of the currently posted fixes for 4.3rc that I haven't grabbed yet
resolve the iSER issue I'm seeing, then I'll move on to for-next processi=
ng.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--17GMDhiRNiu4NUL9bsbsBTXHrAWlExqFN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWE/FFAAoJELgmozMOVy/dbgsQAMJvoxCyu8juLti0cBWS8ys7
9tI6PAuZZWzWjzSWhCHFXNceBy2INbOHYjz+DNG33ersWGp5IwHfogNZ9wCZeD6Q
AMu3ZlEp9STqhZdyzXPNz0e+rd6EszgNHheBWW7ORyjN54A4pBTJDd0e+1C6eSNM
qJa1200ODRrhnDly9Bgg5pdbkOAs1SZI1JpSfp/IZzwUDQaWnDdH0dsMKLJQts0Z
R0TMhvuePwxi5r/XeOB3oWm0JWah1oF6cUFIT66G3bsETX9sF0sZ21r/pgjtJ8Ds
RTQcc0Cz2VrrurB59FK7b9ClOZWtugqY7Li4bq0VJfiuqbAbI9LA+of+81r4Wn/Z
ftAUURa5Ykmg9en1uluy29fJL9Iu0eh66tz6wvTdYCD5bbZThmQJ7P72Mh5OGzcO
peaUN1rVGRp/vLYNDL5ZTOzMJ9R8pJQMkWKJISSZLA3A0N12O/bNiGKclNSoBgE5
fCm/Eol/OOD2D1n1ei4NzV/enN31uChhCz3X66SSAmAXX4FXv0DXSZc3Ks/TAz7M
+mOyXXsRVnryR+28jktNBGosVE+6v4Lkc6Xh+UTGweK4hqD7nB+SWjKZ9wPFb3aE
P90NhamW3edoRxjyavBPwkS5sFMS4j97VJjFugfOc0aSpKWpkRm3Fu6qLeJte8S9
pYi0Ausu6/odZ9KzTkGy
=8P+l
-----END PGP SIGNATURE-----

--17GMDhiRNiu4NUL9bsbsBTXHrAWlExqFN--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
