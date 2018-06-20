From: Leon Romanovsky <leon@kernel.org>
Subject: Re: cx4 sriov problem in stable 4.14.47
Date: Wed, 20 Jun 2018 15:01:01 +0300
Message-ID: <20180620120101.GE7557@mtr-leonro.mtl.com>
References: <1ae538be-2699-e0cc-adef-2235489472ab@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="lQSB8Tqijvu1+4Ba"
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1ae538be-2699-e0cc-adef-2235489472ab@grimberg.me>
Sender: stable-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, Stable <stable@vger.kernel.org>, Roy Shterman <roys@lightbitslabs.com>
List-Id: linux-rdma@vger.kernel.org


--lQSB8Tqijvu1+4Ba
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 20, 2018 at 01:40:16PM +0300, Sagi Grimberg wrote:
> Hey folks,
>
> Seems that CX4 (Ethernet) sriov ports probe with link down in the latest
> stable 4.14 kernel. I upgrated firmware but with no luck :(
>
> Has anyone seen this issue as well?

I'm shooting to the dark, isn't this related to commit
e3ca34880652250f524022ad89e516f8ba9a805b ?

Thanks

--lQSB8Tqijvu1+4Ba
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbKkH9AAoJEORje4g2clinQVAP/1cu2I8Udoj6n3FG/vixutH8
bq4hfNQaByGAlC96Jy+MWouXq4dUvstKMWPrFNgoK8pd/9nQ6tio5+ALEej3M22L
oA7OhQBma0cYcECsr8mv5H2xCdJhrY7Z+90gLm6HWhUdMnoHQBoVH8LgqvUZT+Y4
ewCUrvOdseVbpzAfxxfSi3SUzSXkyXUZVxK7izfkOOhYgj83WsvQx2ALTQl7StM6
OlYE0Zyi5PRl7tGqOSXizmjh9Y7oMiKEKTAZ+quUkrFV2Gf/S98+RyA2Yr/b1lm9
dulRZ2X6pjQBwzNXEmRDur7uuJpl7JqojYn+EBgIOobf02WWUSbZd7PGKeU4sqnR
mkkyFE/yH4Vm+8vvCiKqGr06U5QPT6U9B3Pb9jRHLzw4O+ZQ0TMLancNDR1Iikus
pC239jJ11RtW2LeD2BFq7KEpJGPRRr1VDDZFLg2YisIDexLeTJ+CfA3MiZNnNT8o
e5lLm3Y7Rh63pn507SDYPYYgTW3qGmC1jX34WDOoVVTZoL8Cv2/j6BkEjauepuHd
jiopGcfOUcnx0pBL+OU0HGa7SpM+bRegzZWNbA4MjhsqW1JqXoP1ZNn7ookflLEd
W5A8q4W0fL8zwUYO4Xe/WElkU6B50U6PnLac6p/iB+NejV8z3IgPqzIy/q9SGmKl
4ZtXJ30bjrWvgDxjC3Pd
=crkn
-----END PGP SIGNATURE-----

--lQSB8Tqijvu1+4Ba--
