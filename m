From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: rdma-ndd shipped by infiniband-diags and rdma-core
Date: Tue, 9 May 2017 20:54:06 +0300
Message-ID: <20170509175406.GJ10073@mtr-leonro.local>
References: <1494335693.3752.1.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tmoQ0UElFV5VgXgH"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1494335693.3752.1.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--tmoQ0UElFV5VgXgH
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 09, 2017 at 03:14:53PM +0200, Benjamin Drung wrote:
> Hi,
>
> /usr/sbin/rdma-ndd is shipped by infiniband-diags (version 1.6.7-1 in
> Debian) and the rdma-core package. This makes both package not
> installable in parallel. rdma-ndd should be shipped by only one source
> package. If rdma-core is the new upstream for it, please remove it from
> infiniband-diags and publish a new release. Otherwise I cannot add the
> correctly version Breaks & Replaces to the Debian package.

Ira,

Didn't you release when you merged rdma-ndd with rdma-core?

Thanks

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
> Web:=A0https://www.profitbricks.com
>
> Sitz der Gesellschaft: Berlin.
> Registergericht: Amtsgericht Charlottenburg, HRB 125506B.
> Gesch=E4ftsf=FChrer: Achim Weiss.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--tmoQ0UElFV5VgXgH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkSAj4ACgkQ5GN7iDZy
WKcl9w//TTDdrZEvUduJZCIs9TdXJ7ALFIDNB8jikZXAN7TdeZi+NnfrP5vxXeWv
H0QsKoCKkEwv64Wfhl5FzOKNRZb+u9ILmr556XoQQIRmdhZcH8IS8tAJumvVcc/U
daVLmlPAkdkErkoVtNrtwekNQotvff0me9Q90zNczh7PN72gevokP/nuQMcbzf8d
h5UdEuiMiVimsSo/fxnrbh5xg61f00G9/B6iztbL16nIjdTAOSlb8pniBtwAC2vV
993mAR8ytUSROrQ+CAPBJZzZeEsOdrZBKL0cB9net8nuZ7bAwHIAhXi9Y1FfMAA1
elDrYrdHZUOGnpbPv6Dmolj4beCqPvfuGG92VNW5VMQM1FzwTYLhrkPP9RBicvQB
Jq5kCaaEQ6kXB8SVOcC8EkJ8pLEz+kIlWIOFu6WmZITwiEiSlUSv/m5nV4MOjhOf
eQXUfgSh8+tLmfr/cbyyVBYb2audg/cWU7/2dI4VoLqxHrkkxzYsc5qM42YAjcTe
xbTK9B06zD0th/xc2/Hlsms3wIyqIuEVGrhMbrL6U72o1r1hi+0H4R6i1jMU2A8F
rj7L9dtWDAyT3NfGqu1TGvp+5611eC5mjOJlBCjjiEmhbEioSSriAY+MJDz0DWYq
cMqjaJNuMdByOioGigS7GZvU5AmIt9Ap3qQeDX7SrXCpe4qHVfU=
=wrro
-----END PGP SIGNATURE-----

--tmoQ0UElFV5VgXgH--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
