From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: 4.13 ib_mthca NULL pointer dereference with OpenSM
Date: Mon, 30 Oct 2017 09:19:56 +0200
Message-ID: <20171030071956.GU16127@mtr-leonro.local>
References: <CALpBJjoMLCqzVe5yKp4wCX-X-sH+=zv1QZfMvOWh2Ukh3c2LFg@mail.gmail.com>
 <20171029191114.GO16127@mtr-leonro.local>
 <CALpBJjoJpgR1QB-gzRJLOjGtjK4T2H4EbG1-R+ndodvznWkgwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1xJJiECQTZ8+YlWm"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALpBJjoJpgR1QB-gzRJLOjGtjK4T2H4EbG1-R+ndodvznWkgwA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Blake <chrisrblake93-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--1xJJiECQTZ8+YlWm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Oct 29, 2017 at 02:35:23PM -0500, Chris Blake wrote:
> On Sun, Oct 29, 2017 at 2:11 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > Do you have CONFIG_SECURITY_INFINIBAND in your .config?
> >
> > Thanks
> >
>
> Hello,
>
> CONFIG_SECURITY_INFINIBAND is enabled on my kernel. All infiniband
> config settings can be found here [0].

I did another glance to try and find the patch which affected it, but
didn't really find it.

Can you please try to set CONFIG_SECURITY_INFINIBAND=n and see if it
helps?

Thanks

>
> Thanks,
> Chris Blake
>
> [0]: https://gist.github.com/riptidewave93/b3b83c13e93ab3be4254c855885f5b3a

--1xJJiECQTZ8+YlWm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAln20pwACgkQ5GN7iDZy
WKejrxAAqiKEoNuPnJCuz9nH/56vnrxCLXAt1SvT50SPn6bBFbjZS3Z3rUjDOBX5
MDTQaYISFHgx/C/KVNJ1PWWMKx9zsVC6YIJHK2B1YVydla0wrSVCeIOX/Bqw2cqo
W95MRHG0b1xFeb7emV0eE8teulrrLq4+JhdjSEzwEAXgveKIJdpapcqso9fIct9J
Fdft6TuKfD4om+Up+hgn9E+5o4yKXcHRzGJQF/fLSOrV/p4UQ19HuIoTHFMhjmtd
RcYZjriUOx7FfXkEshLqFCyxeUPqEC5iLiGf0dfa+VUax7gDfTL5hkbRe0TrJlrQ
9hzaeY74X1P3wbE5zbGDxDG57UdMSZyIGWj9ObNvby6tJ4kFnZPyrxxRvTUuA56v
WuB1ezJdEaGxe5YPqveKKGwc9KNNNenOJDV5+cqVOziEAHbUTf4rveVMtlESdkWb
CMPQKQy5rut0bSQ/P1cla8xPMYH4ydVGcahA0LnquK/FjeygFoboq4AIBWDP/z/L
iAQ2CeALbv8kogqQaP7aCMOi/o+jc0tEPx1YzX5OgnhZ+bEQJXemgrt/445dDf+4
iuu21iB29SHLtXvJGnvG6YKnpsRdOL5TXaq++kUO+/+MN9slKQLImisoIS62QBgl
xpqkiHI7fPFpvOh+aKS4VhJH8F0C6ew9cZjACVkbWaGnqRZ9WCo=
=SvBH
-----END PGP SIGNATURE-----

--1xJJiECQTZ8+YlWm--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
