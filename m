From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 02/11] IB/hfi1: Check return value of strchr
 before using it
Date: Wed, 20 Dec 2017 10:25:55 +0200
Message-ID: <20171220082555.GN2942@mtr-leonro.local>
References: <20171219034753.2126.78386.stgit@scvm10.sc.intel.com>
 <20171219035621.2126.23093.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ofZMSlrAVk9bLeVm"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171219035621.2126.23093.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--ofZMSlrAVk9bLeVm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 18, 2017 at 07:56:23PM -0800, Dennis Dalessandro wrote:
> The call to strchr in our counter initialization does not check the return
> value before attempting to use the pointer. In theory this should not
> happen given the way the code is structured but do the smart thing and
> check the value anyway to harden the code.

The smartest way is to get rid of the whole "\n"<->"\0" logic and
copy/paste mlx5 implementation which does the same thing but statically
and much safer than here.

Thanks

--ofZMSlrAVk9bLeVm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlo6HpMACgkQ5GN7iDZy
WKdEOA//d7o9y4/sUFWjFn38dteiLqLy5mfNzyinbBMywLu0KlM7Nuo4fdZGMzQO
8d8KOpRc3vO0oUxZYws/K/xaA/bMmuDhBbO1BdFMWbJ2nJFTLYGtfkjUcA7lSAJj
s21CD4Ll2mb26A8BlrBpyEfXENxvdPFc06zRn0o2OKr25/trxRTP1iVynGULNfwM
iDQakw02qeY176TspugxpYlSw9Fas9NsmRlChIJ/7tNEatrlkLrvZwZXAnfi5UJ8
BzHMYjGmWmcJSXzuF4j6KeUqC9TXXpNpb58sX2/Ms5ZJQGk6ivdr6jfVP90D94LA
Igw1bUTUJ+apg30RscKmVpMLFeYonIABfMOBNLv2Zkphrslk/L9vlaiz8/Wjn66n
bjzZV8XsG097/trbwDkXIb/oyn/qwUEwP0smdfzfGpLaZz+q/AQWgS9wvLEkyE1G
1LusxSKVzWnvMmxy8Ha5nwXPOeI4rnXNmp/p+2EQOwHhz8WglXvdV9Cipktzug4p
D80tfqfxTLWghcLEidgsK5U/h3ihTZJ4LbPrimAFM9wWCJWBTHJJi5aHs0Zc/oLw
d4ALZuAXaItTs1wXFSAA/ye1n5LrL1ImMcI8Yx+AiDXJYibYnLvojMeqIXHIKrVt
Cn7GksbSN6TkQhgaYGnFMdjzqniJyRyIi3LWuDRyqQvP7HDNhdE=
=hkfA
-----END PGP SIGNATURE-----

--ofZMSlrAVk9bLeVm--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
