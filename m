From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 11/11] IB/srp: Prevent mapping failures
Date: Tue, 26 Apr 2016 17:12:29 +0300
Message-ID: <20160426141229.GI7974@leon.nu>
References: <571A936F.7040409@sandisk.com>
 <571A94AF.7000609@sandisk.com>
 <20160424083538.GF7974@leon.nu>
 <571D6975.2020905@sandisk.com>
 <20160425055433.GG7974@leon.nu>
 <571DE793.6090705@grimberg.me>
 <20160425155320.GH7974@leon.nu>
 <571E42D2.70705@sandisk.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Encpt1P6Mxii2VuT"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <571E42D2.70705-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Encpt1P6Mxii2VuT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 25, 2016 at 09:16:18AM -0700, Bart Van Assche wrote:
> On 04/25/2016 08:53 AM, Leon Romanovsky wrote:
> >On Mon, Apr 25, 2016 at 12:46:59PM +0300, Sagi Grimberg wrote:
> >>
> >>>>>>+		max_max_sectors =3D (srp_dev->max_pages_per_mr - 1) <<
> >>>>>>+				  (ilog2(srp_dev->mr_page_size) - 9);
> >>>>>
> >>>>> From my understanding, srp_dev->max_pages_per_mr can be equal to 1,=
 in
> >>>>>case device will advertise it.
> >>>>>
> >>>>>Is this understanding correct?
> >>>>>Will the code work in such case?
> >>>>
> >>>>Hello Leon,
> >>>>
> >>>>I'm not sure a HCA driver exists for which max_pages_per_mr =3D=3D 1.
> >>>>Additionally, I'm not sure such a driver would be useful because such=
 a
> >>>>driver would limit the maximum data transfer size for the iSER protoc=
ol to 4
> >>>>KB. That is too low to reach good performance.
> >>>
> >>>Bart and Laurence,
> >>>You are raising valuable arguments about sanity of setting srp_dev->ma=
x_pages_per_mr
> >>>to be equal 1. I totally agree with you that it is insane, however my
> >>>original question was "does the code support such value?"
> >>
> >>I don't see why we should worry about imaginary devices.
> >
> >It is called corner case and the code supports it.
>=20
> I can add a WARN_ON_ONCE() statement for max_pages_per_mr =3D=3D 1. That =
will
> make it easy to figure out where to start looking if in the future a HCA
> driver would be added that causes max_pages_per_mr =3D=3D 1.
>=20

Thanks Bart,
It is fair enough.

> Bart.

--Encpt1P6Mxii2VuT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXH3dNAAoJEORje4g2clinDl8P/20Wqhey6OHQ/H6KK6twhS7E
N9/8aBbVRytNpqrlKlCg4hrzXmY5+sjLxitZ39trwlRRQaDep4BW4sbPKSxF9Yfu
yYhEfGJ5/pwI2f0NKnxCLOMlxEPW0j21AdzxeBx/qjecvDNK7ZQDmJxG//cZB0yK
Lp1jT8udjJpDp3gzuHHJq8of6y0nMZIWRLCn8h8l7eLw9xQ8RkwB8Vxbal2Mw9Kv
+RjUg723ZUyJzkVysTRh1ZQDwUPkoJ/Q0/Q2d34FbVfg+/WCZSusskXUXjEjTYUq
8C3zOsx3Yh01RBRdrXWpa2GC3L13i09ui1dxFQYXXZnJLNgvb4QYLPmucX17mWgX
H8zKZV6uK2ujH2y+JJFkuL0oue3gRS8qWd/r3cyOALk0gToCg2JdEf0qUc4pndfm
0jLtqW8LcaTewSGQe3zztNB1SmXrSRi8fj1wsp8ct3pYV+4KZB+xIhCgsJmxEYtj
w8ARpuJFTUwits/5zWZ0nPJ3RigOYpgj55Bxxl2NaBfvMavbzFO29xPMHjE41rAp
ILI9lsu1v8DFhfha3I62ML//XYOC5qEZaPhx/b02+67zzJvIIy04qtKnASHVXNaQ
P6OGb58s6asDm2WNodos/L6/geaxPuQOCxaR7MYwscwCM4GcNu5R/rr2AJnViNk3
OVy6MnvHfSrqtSu/Wyic
=80PU
-----END PGP SIGNATURE-----

--Encpt1P6Mxii2VuT--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
