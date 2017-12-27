From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] Support writing man pages in MarkDown
Date: Wed, 27 Dec 2017 13:13:48 +0200
Message-ID: <20171227111348.GB3494@mtr-leonro.local>
References: <20171212225936.GA29558@ziepe.ca>
 <455f0faf-516b-fa8d-c0d2-d2cee9194e5b@dev.mellanox.co.il>
 <1514368433.4412.2.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1514368433.4412.2.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 27, 2017 at 10:53:53AM +0100, Benjamin Drung wrote:
> > > Am Sonntag, den 24.12.2017, 14:03 +0200 schrieb Yishai Hadas:
> > On 12/13/2017 12:59 AM, Jason Gunthorpe wrote:
> > > > pandoc is fairly widely available in the distros with the notable
> > > problem that centos 6 and 7 can only get it from EPEL.
> > >
> >
> > There might be even a worse case scenario where pandoc may not exist
> > as
> > a package to be installed, for example how about SLES OS ?
>
> The release tarball could contain pre-built man page. So in case the OS
> does provide pandoc to regenerate the man pages, the pre-built can be
> used.

Why should OS be dependent on pandoc? IMHO all releases should contain
pre-built man pages and they should be used without need to regenerate
them at all.

>
> > > Since this may be a problem, I am thinking about following the
> > > libfabric approach and either including the precompiled man pages
> > > in
> > > the source tree, or just providing a framework for downstream to
> > > add-on precompiled files (with a cbuild command to make them)
> > > Looking for feedback on what path is best..
> > >
>
> Please do not place generated files in the git repository.
>
> --
> Benjamin Drung
> System Developer
> Debian & Ubuntu Developer
>
> ProfitBricks GmbH
> Greifswalder Str. 207
> D - 10405 Berlin
>
> Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
> URL: https://www.profitbricks.de
>
> Sitz der Gesellschaft: Berlin
> Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
> Gesch=E4ftsf=FChrer: Achim Weiss, Matthias Steinberg
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpDgEUACgkQ5GN7iDZy
WKcPhA/+JXmYkcrOsdt9LTW/qoKV8i3b0iPkQoIHz2ID4+L4RXLgjCGSozE12u8k
n3eg3BjviwtrlU094ON7EiuDKU8fB2s+XEUHGkzYRBpP3QpdGsiUshET3oXccS8H
/tCdv+PQ31+f9A33+zidujF+gFqUy2NOMqs2S0JKRduQR/DbPIhdLTZsyus1kkWx
ntWUWx4EaPeGUpprYcH3V1ohDZVzxk32qlP/KYsD2WHUu4zgC9aE2nqjeItzmGxb
1WwDTPdetHbBxp6G4AQF+ww68ASMgzcaKBGL8RiKNYqQfNyMMir9Gn4S2Fgt7YEl
hjQgFl4Ij3F+WDLPc8WR5+T7RmJVh6hPBjS9iK37a0TBTwF5om6XewL32MYqH4OF
ok22kCq2iZm59qtlUMQVwG92TP3TqxBo+XEMUETtLuB8Ef+/q2xtTN071QsN+gdR
41dVWFkA9l5A8OEVj05rh+5j/uRPMQrixRAF9ypalR6SV9mNxfIrzh+dzWTfPM0Y
E1GYyfpNt0gy6ZoWtYUak92iqaiFcYW8I6QBkUaXy7cnn8964n2CzFbDS5AIOeoL
/YxFOiSAv1ntYjFHA0jQsPTKXiMNsfvHMj2QKzBLdZI8ClGvTFAVmOduwvDyURFg
AvlvUTfLivLxMQbIhmdG5viKbVC02tUmYoaIXeYp7/ZFueAFMP8=
=MMs+
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
