From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [rdma-core PATCH] srp_daemon: Don't create async_ev_thread if
 only run once
Date: Wed, 3 Jan 2018 16:19:21 +0200
Message-ID: <20180103141921.GR10145@mtr-leonro.local>
References: <20171219190958.3189-1-honli@redhat.com>
 <ea3fe465-cc3b-1db3-e274-8c13f976953c@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="DITGHUV3p5DjDsXt"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ea3fe465-cc3b-1db3-e274-8c13f976953c-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: Honggang LI <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, "stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org" <stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--DITGHUV3p5DjDsXt
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 03, 2018 at 11:27:27AM +0100, Nicolas Morey-Chaisemartin wrote:
>
>
> Le 19/12/2017 =E0 20:09, Honggang LI a =E9crit=A0:
> > From: Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >
> > fd3005f0cd34 moves the signal handler setup from ibsrpdm path. So,
> > default signal handler will be used when the main pthread send signal
> > SIGINT to pthread async_ev_thread. ibsrpdm will exit with non-zero
> > exit code as default signal handler killed it. ibsrpdm should return
> > with exit code zero, if no error emerged.
> >
> > We should not create async_ev_thread for ibsrpdm.
> >
> > Fixes: fd3005f0cd34 ("srp_daemon: Move the setup of the wakeup_pipe aft=
er openlog")
> > Reviewed-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
> > Signed-off-by: Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  srp_daemon/srp_daemon.c | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> >
> > diff --git a/srp_daemon/srp_daemon.c b/srp_daemon/srp_daemon.c
> > index cec36db2..4012a7db 100644
> > --- a/srp_daemon/srp_daemon.c
> > +++ b/srp_daemon/srp_daemon.c
> > @@ -1945,12 +1945,12 @@ static struct resources *alloc_res(void)
> >  				     run_thread_get_trap_notices, &res->res);
> >  		if (ret)
> >  			goto err;
> > -	}
> >
> > -	ret =3D pthread_create(&res->res.async_ev_thread, NULL,
> > -			     run_thread_listen_to_events, &res->res);
> > -	if (ret)
> > -		goto err;
> > +		ret =3D pthread_create(&res->res.async_ev_thread, NULL,
> > +				     run_thread_listen_to_events, &res->res);
> > +		if (ret)
> > +			goto err;
> > +	}
> >
> >  	if (config->retry_timeout && !config->once) {
> >  		ret =3D pthread_create(&res->res.reconnect_thread, NULL,
> Reviewed-by: Nicolas Morey-Chaisemartin <nmoreychaisemartin-l3A5Bk7waGM@public.gmane.org>
> Note: I will backport this to stable-v1[56] branches once its in master

I merged it two weeks before :)
https://github.com/linux-rdma/rdma-core/commit/3f58c9237533ed9d92f3d08cad56=
527299781862

Thanks

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--DITGHUV3p5DjDsXt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpM5mgACgkQ5GN7iDZy
WKc+DRAAtjd9ZALj9KBfVQSmTlarD8hOBTQHh/jfet8veNOHCrhZHKapnOxvsZIj
Z3gQvhfXOzAi9PH7a+HgXXgVy+eQTXLm+hIST/Z4+hKpqOoqDfK0cxPJZPGMHZsA
oe7vVFjfl8X7iN32OS5JBChr8et0fYqFBvAjYBLd8gOfAjI+ofC2Q8J22PQX4u2H
t8auCtj0xS0jfV3+45WxTugNm71TlByl0oFn++BlnhWfNC6VBSNWAK86IStqq9Sz
/6wnXqGsKLaH3L1D4uYCes0PDTm59dnFf/7lc5+TGIvVpkVVDZQsFqesED9/1Gh8
2ckRlxxHBnijUoanlhX5ILiHCH9IWUZpLe8Z7/MWjBWib4WdgGf0dvY48veqC6Bv
BgpWOfzSS4qmIgPYzE2xD1oDm5eU7mRf9Td/bScPBz7PhQlSXTpnwS50IO2XzUA3
jkWlqN8YJDe2L317GVE6WYpL594DZ5St6zoizdcGifq0bnqpVJqPc88FIZpF9z3m
iDdD9Fauv2GO/YmsSmwNEIDDVyXoArvSERH19UkC7F4Qe5BnZAZyaTEpukHfWs0B
VZ1rkfBD74UT1tsbO662fqlYlKxgbaicx4IxDGaqg8n0sVqYpNM9gVhcZ5ffLqyO
mU/22gPwTz7FJLl+CcK6fYsE355rGI4iqq7A3ivmXxSBxUiB5CE=
=YyXz
-----END PGP SIGNATURE-----

--DITGHUV3p5DjDsXt--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
