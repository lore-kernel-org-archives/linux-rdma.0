From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] build: Pass extra cmake flags
Date: Mon, 5 Feb 2018 14:53:12 +0200
Message-ID: <20180205125312.GC2567@mtr-leonro.local>
References: <20180201103206.26356-1-leon@kernel.org>
 <1517794847.3936.52.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yNb1oOkm5a9FJOVX"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1517794847.3936.52.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Nicolas Morey-Chaisemartin <nmoreychaisemartin-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--yNb1oOkm5a9FJOVX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Feb 04, 2018 at 08:40:47PM -0500, Doug Ledford wrote:
> On Thu, 2018-02-01 at 12:32 +0200, Leon Romanovsky wrote:
> > From: Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > Add ability to provide extra cmake flags when building library
> > and when creating RPMs or DEBs using EXTRA_CMAKE_FLAGS.
> >
> > Set an environment variable prior execution to provide
> > this information to build scripts:
> > export EXTRA_CMAKE_FLAGS="<flags>"
> >
> > Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> > Cc: Nicolas Morey-Chaisemartin <nmoreychaisemartin-l3A5Bk7waGM@public.gmane.org>
> > Signed-off-by: Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>
> Tested as best I could locally then applied, thanks.

Thanks,
We are running this option internally, so I'm pretty confident in it.

>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD



--yNb1oOkm5a9FJOVX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlp4U7gACgkQ5GN7iDZy
WKes6w/9FQK1TqUFV9Gf9e3J252nDnTZ7VRfgZZsYWZKVU7CFdFPk2Drrzcz8/GD
LvjOCyi/oSCet8G4o+KTKdswF6BquhmjZkz1WH/BWX+dJjY1jctJpZfcOJIwEoco
fC435vtvFqFKqc5KNWOrvnvrwnKgsUjZfyaYaqzJ83rfrtuJftWw8MjuBnkqiqLO
eS4nvbeQMDI9DJwrbVCnOLcjigmL9otFNIgZyYMftvpjIl2WLfFt52eGhkBai7Wc
IZC4q9Dr0xyhXI5sr3k5ars7750/x3D1f+f9u98kAadY8ZrwhoVJiRBG/GZk+fli
ZiKZHH/wthTQoqHCR6z8YVR4g+hquYQeSE6armgVikUAyMzBWTeB+NFxoBP8vjLR
v8rf+FKadLVpWCGqC5ZO1pHNrg6sAnm8KsqdHCcdNOTTQuyOlbOSnz/o1w8H7cb1
YgoJQSOKKFbhfhMKmgrVr/oYgHF7XuHGvs3l2PhYmWytk4ZcaOnZsE53scPNkiUT
tyoQsVrl6BupRxH3ba7V/llH1Wi3g/29QimVJzW8JKo5GZa5clnlij9klunonS/b
GdWDoU77DrSIhhHiS649OdXzJXIGJ73KGeXz624EEjC8sMQ82Bc+zRjkbOiAd+Kv
YoDSC9hJYktZGMx+AwJB36gvhxw1Sm/HQT67Bo4o6k09BpzccNg=
=wLJk
-----END PGP SIGNATURE-----

--yNb1oOkm5a9FJOVX--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
