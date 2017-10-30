From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: 4.13 ib_mthca NULL pointer dereference with OpenSM
Date: Mon, 30 Oct 2017 21:00:26 +0200
Message-ID: <20171030190026.GB16127@mtr-leonro.local>
References: <CALpBJjoMLCqzVe5yKp4wCX-X-sH+=zv1QZfMvOWh2Ukh3c2LFg@mail.gmail.com>
 <20171029191114.GO16127@mtr-leonro.local>
 <CALpBJjoJpgR1QB-gzRJLOjGtjK4T2H4EbG1-R+ndodvznWkgwA@mail.gmail.com>
 <20171030071956.GU16127@mtr-leonro.local>
 <CALpBJjqWrXu3b12EG2-AWKwKs9v2q5pTf11rXSy04C-5dGta6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xtcA6s3naMKOsC7S"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALpBJjqWrXu3b12EG2-AWKwKs9v2q5pTf11rXSy04C-5dGta6A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Blake <chrisrblake93-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--xtcA6s3naMKOsC7S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 30, 2017 at 01:39:42PM -0500, Chris Blake wrote:
> On Mon, Oct 30, 2017 at 2:19 AM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > Can you please try to set CONFIG_SECURITY_INFINIBAND=n and see if it
> > helps?
> >
> > Thanks
> >
>
> Hello Leon,
>
> I went ahead and set CONFIG_SECURITY_INFINIBAND=n in my kernel, and so
> far the issue seems resolved. I will run this for a week or so and
> will get back to you, but things are looking promising. :)

Thanks

>
> Regards,
> Chris Blake
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--xtcA6s3naMKOsC7S
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAln3dsoACgkQ5GN7iDZy
WKfrtw/8DL8EGPoopCm6WPQ9AHUS+hGOkexCY5UZK3BSl+HhbVH6YnYdGA+J2LO7
OCsto8tDQBofIryre3nfqvVn9NfjdKlDZs9sFekdrOqHI4Dr33XtM2h86k4NT7/4
p2k+jMgwQ3aLMufXg1d/MjICb6D33pWFeUquOoizDRJRZP22MCn/+VKNTLHujP1R
2ukiLkaY8X8jAhiuvVzpD35nDPuIcvOO38/htOvn90nE8oXRI1zmBN21/4meyHMa
YuK19Q3IXhDPoXxkML86caUxzphw6/gi3zbAcYs8N3d4qVMGVIwn6F3ocpBzohYC
dnlS0Oe6kdi4ip/BtZwMhLPDJhNmtz/RuQTkTEd6Ixj0xrpPN9AIMqgFGgGUqH1T
CPYOXoFhVYSfTrC4ivsF3LS6RR2xyLqmNjTsEdhsEUAXuYzjWn0scj9JllyupPmP
KWK+Hh7EmeHBdwc6MX5n3OEl6s/iKOhdGzOn6OWf9wnCQ4szADK/L5bz0uJ2tlAK
tpWX5u9m0NukR3Jc0ClDM9aftrWLkFyuFy6URd4DzhINxpz9n8twKlWQlkqbgdjd
KRNYaECLijgM8rBJdH7OmD2pJ6puhVPEX+OaJJwQE17fBqghIpLsEakUeAhIsdJa
kjcK/VN/CEkQ5PV2FHi2Py0VtZ0Cpwhi6e8OLo3YThiSnO8QtfA=
=rr4d
-----END PGP SIGNATURE-----

--xtcA6s3naMKOsC7S--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
