From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Unexpected issues with 2 NVME initiators using the same target
Date: Mon, 15 May 2017 20:05:06 +0300
Message-ID: <20170515170506.GK3616@mtr-leonro.local>
References: <33e2cc35-f147-d4a4-9a42-8f1245e35842@mellanox.com>
 <517fb6d2-a010-1926-b4cb-0e6041722c28@grimberg.me>
 <af9044c2-fb7c-e8b3-d8fc-4874cfd1bb67@mellanox.com>
 <c2a1436f-48a6-bdea-c910-168fc6031364@grimberg.me>
 <DE927C68B458BE418D582EC97927A92855088C6F@ORSMSX113.amr.corp.intel.com>
 <82dd5b24-5657-ae5e-8a33-646fddd8b75b@grimberg.me>
 <20170515133122.GG3616@mtr-leonro.local>
 <9465cd0c-83db-b058-7615-5626ef60dbb0@grimberg.me>
 <20170515143632.GH3616@mtr-leonro.local>
 <20170515145952.GA7871@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="VcZjVMblxkg0/8Ur"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170515145952.GA7871-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "Gruher, Joseph R" <joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Marta Rybczynska <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>, "shahar.salzman" <shahar.salzman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Riches Jr, Robert M" <robert.m.riches.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--VcZjVMblxkg0/8Ur
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 15, 2017 at 07:59:52AM -0700, Christoph Hellwig wrote:
> On Mon, May 15, 2017 at 05:36:32PM +0300, Leon Romanovsky wrote:
> > I understand you and both Max and me are feeling the same as you. For more
> > than 2 months, we constantly (almost on daily basis) asked for a solution from
> > architecture group, but received different answers. The proposals were
> > extremely broad from need for strong fence for all cards to no need for
> > strong fence at all.
>
> So let's get the patch to do a strong fence everywhere now, and relax
> it later where possible.
>
> Correntness before speed..

OK, please give me and Max till EOW to stop this saga. One of the two
options will be: Max will resend original patch, or Max will send patch
blessed by architecture group.

Thanks

--VcZjVMblxkg0/8Ur
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkZ38IACgkQ5GN7iDZy
WKfj1RAAwAOmZTzYALZro+Z3EyjhTaxdKWJD96IauvDRIaCELw3pv8NeGWD3cNkE
ONBqpHHsTCeoR5EiUVzC1B6m/tommXBWk9/WX8oOppGdZUjtlySnRxxsoRlOhNvp
i8lXjZ9pJBnjHhFL2HZRWuukT5BGGlgLKfUG7IoWqhznSkfq/gG/sOoB1ZSVPRza
WW1ExNcGtshu8almJnuuxzpjSsA8zJU6RokC+xmfHo3AXtaxJ8Rj1MiADBJtssZe
mHBdno1c7ODk9bGxxWetj8xkK9lWz5Vi5sXPrSlXl3uctQUFOEPorno3Epb0ccZ5
roWxaMjQucwT3nm0JuxrE2Jsy/0Hl8NMdKPXZYUxpoLJA9ZSXVjmtfYl1uZ89SRC
Eg29LryusaFBj61XxttXni0EbA4H4eZqbbhPJ/MlYnd21JunuucGhG3td49N4L0c
Qr6GC9ndRyk4143ahB0NV0AiV/R9N4iun6bcL5VeNuLUR1ngk3d11gRL4iJNtRDZ
RIFv1C9FTo9N2KqsvePuRZKX5vbkbZ0C+0rSSScvW9E0GxwI5SABMoVr9xd6beht
Y/98zUDzgYHyrYgQD/uAj2jJoJJpzZ6FiXGT6ta6v2TsiBsAqOz3h9Wnnt9S0OoQ
5tgcCfm+bUo/uftXfLecCmPQxn7XVfnhebTdz5rOBuV7j/S089w=
=Qqkv
-----END PGP SIGNATURE-----

--VcZjVMblxkg0/8Ur--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
