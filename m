From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Unexpected issues with 2 NVME initiators using the same target
Date: Tue, 20 Jun 2017 10:46:39 +0300
Message-ID: <20170620074639.GP17846@mtr-leonro.local>
References: <82dd5b24-5657-ae5e-8a33-646fddd8b75b@grimberg.me>
 <20170515133122.GG3616@mtr-leonro.local>
 <9465cd0c-83db-b058-7615-5626ef60dbb0@grimberg.me>
 <20170515143632.GH3616@mtr-leonro.local>
 <20170515145952.GA7871@infradead.org>
 <20170515170506.GK3616@mtr-leonro.local>
 <779753075.36035391.1495025796237.JavaMail.zimbra@kalray.eu>
 <20170518133439.GD3616@mtr-leonro.local>
 <CAANLjFrCLpX3nb3q7LpFPpLJKciU+1Hvmt_hxyTovQJM2-zQmg@mail.gmail.com>
 <6073e553-e8c2-6d14-ba5d-c2bd5aff15eb@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mejza3ZMMA5Za1mX"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <6073e553-e8c2-6d14-ba5d-c2bd5aff15eb-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, Marta Rybczynska <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Gruher, Joseph R" <joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "shahar.salzman" <shahar.salzman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Riches Jr, Robert M" <robert.m.riches.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--mejza3ZMMA5Za1mX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 20, 2017 at 09:39:36AM +0300, Sagi Grimberg wrote:
> Hi Robert,
>
> > I ran into this with 4.9.32 when I rebooted the target. I tested
> > 4.12-rc6 and this particular error seems to have been resolved, but I
> > now get a new one on the initiator. This one doesn't seem as
> > impactful.
> >
> > [Mon Jun 19 11:17:20 2017] mlx5_0:dump_cqe:275:(pid 0): dump error cqe
> > [Mon Jun 19 11:17:20 2017] 00000000 00000000 00000000 00000000
> > [Mon Jun 19 11:17:20 2017] 00000000 00000000 00000000 00000000
> > [Mon Jun 19 11:17:20 2017] 00000000 00000000 00000000 00000000
> > [Mon Jun 19 11:17:20 2017] 00000000 93005204 0a0001bd 45c8e0d2
>
> Max, Leon,
>
> Care to parse this syndrome for us? ;)

Here the parsed output, it says that it was access to mkey which is
free.

======== cqe_with_error ========
wqe_id                           : 0x0
srqn_usr_index                   : 0x0
byte_cnt                         : 0x0
hw_error_syndrome                : 0x93
hw_syndrome_type                 : 0x0
vendor_error_syndrome            : 0x52
syndrome                         : LOCAL_PROTECTION_ERROR (0x4)
s_wqe_opcode                     : SEND (0xa)
qpn_dctn_flow_tag                : 0x1bd
wqe_counter                      : 0x45c8
signature                        : 0xe0
opcode                           : REQUESTOR_ERROR (0xd)
cqe_format                       : NO_INLINE_DATA (0x0)
owner                            : 0x0

Thanks

--mejza3ZMMA5Za1mX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllI0t8ACgkQ5GN7iDZy
WKcwDRAApnjW81MaKAQl/4F6GJncMHjACb+rG54EXdGnRlH0NbRxE0Pemot1Surf
0rvRwYn5gAtDr9GdZB4j73xSg6r4Fdx/S75CFfZgwbAYCNPaqH5pVLWJLalPL4Bw
JisxshiHTgUh76OLgtiTYdUykFMTLYUTxvwfH3SW12yg9n46edTlltkrQWJGKUrS
vMeuLi937ZV7M26JDDbBDT0eNNLVa0IHJBeiOjtXQJGt+gevLW+M5a0cANgke6H6
Sl2g3AdZq4PQQZEKaPMAzKI9XLle9sxa4RHJmwNp0xxlXf5qXhLmW1PsOmengw1y
jO23uoaaJMzzHtQpKXlDQ2M+BrODBWFWhPY0PWIZf+qNEzXj/CsUk1aCfauR54R3
GnXei2ypS94XXZxSH5BdpyjnAxJA4lU4UCQ4MolZbfqCiyJcQOLnBVGj/89A0EfR
IO+12AFzEYhO8T0gATFQEbM+U5X363oA6eOM2APEgCEGaUE3gGATDd4d7NfiqGGB
/pGR2yisFBySvJse3nkpw5k8OMPTo5sU2y8B7Pzd42sC2fcQCdChnm8wX9zYurkY
ApVUY2dihzYCc43AyJ0G169MGtAxDwC7g9qhhFyQWxS2TpLXbv7F+/iMTPsh08eF
SoM5eTgWgqMbAhAX8BH7hJ1KoveYwmCBUYnQc9UfQvL75a0/J0I=
=UCus
-----END PGP SIGNATURE-----

--mejza3ZMMA5Za1mX--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
