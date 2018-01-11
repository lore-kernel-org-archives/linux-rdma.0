From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 4/6] RDMA/{cma, ucma}: Refactor to have
 transport specific checks
Date: Thu, 11 Jan 2018 20:50:04 +0200
Message-ID: <20180111185004.GD15760@mtr-leonro.local>
References: <20180108150448.29069-1-leon@kernel.org>
 <20180108150448.29069-5-leon@kernel.org>
 <20180110233748.GS4518@ziepe.ca>
 <20180111060537.GO7368@mtr-leonro.local>
 <20180111165622.GB1309@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qlTNgmc+xy1dBmNv"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180111165622.GB1309-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--qlTNgmc+xy1dBmNv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 11, 2018 at 09:56:22AM -0700, Jason Gunthorpe wrote:
> On Thu, Jan 11, 2018 at 08:05:37AM +0200, Leon Romanovsky wrote:
>
> > > If anything should be fixed here, it is to move the degradation closer
> > > to the actual copy_to_user.
> > >
> > > Why was it put here anyhow? I don't see a uapi boundary?
>
> Actually, looking again, in the morning, it seems placed OK. This is
> about as close to the copy_to_user as possible in this flow..

So, are you going to pick up?

>
> > As Parav wrote, it was added in commit 57520751445b ("IB/SA: Add OPA
> > path record type") and it looks like this sa_convert_path_ib_to_opa()
> > can be deleted, because there is the same conversion in ucma_query_path().
>
> ucma_path_query is OK, the sa_convert_path_opa_to_ib is directly before
> the copy_to_user.
>
> Jason

--qlTNgmc+xy1dBmNv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpXsdwACgkQ5GN7iDZy
WKfIcxAAkuTNcaDO7wVLk4rrhETGtktae05203tykSSJsmmYa58rmMwt16N/cTeq
OG5n0fURmYHDMb7nbd4+IkwcZqvmuEm8Jetayyh03nemIiXgnqQT3Dwg1Eb6WbgD
kacwInq0PePj/s9sTKkf85p1DM/0LXSKEP8yI/O2HeYqDlQaXRvN4nPBZ/eYRi2m
zoEDug2PVPcsZGHhfdX+0yq5LuCnc96wTX6bmX8bzaNIM0pOBw8f0QUi4su22SgO
Ng6cwP8YfRqiVhp96i8aHc2T37jwQuBdPnC7gO5h1RNQ6CBxI1Sn6tkoNh2BIidq
zn9Vp7Xa/b+AyObn5kyjOVPQmvehKXReRqSYgpusAxl+X/2czYEG0I7imiLgq5qN
WQOGBI2t+s9CU9mX5u2/gj5EzoINkinC5LdfnSwSq4Jq1NG1dEZsKAV/vKph7gkS
sAd2nz7F+zzQ+ZZXShAARE4BCBywEQTQZkonikR5KoXYWtBtf/ulxZ5LqulZ6Wzm
S+VQbaCd3BlFoa+Zke+vqkXLbEPjbyye5JjoTFOVsJJQCMX9QapsZxpRhNO2t/ls
Y6zzxycw8Vgdnq4J62l+nsAVIP4nAhGf3W3zfxKy9VocFzHuk1mDxIt4tbzBFBaG
LmBhnoz79aAEsqUy9osYNYMtOsB5fuDtrYwoSwdk1I/FngQhuEU=
=HeKw
-----END PGP SIGNATURE-----

--qlTNgmc+xy1dBmNv--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
