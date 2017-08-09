From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [rdma-next v1 02/33] RDMA/netlink: Remove netlink clients
 infrastructure
Date: Wed, 9 Aug 2017 12:49:12 -0400
Message-ID: <2c7d9d3e-b5ec-69b2-b9e8-321bbb3ecb8c@redhat.com>
References: <20170809160405.25142-1-leon@kernel.org>
 <20170809160405.25142-3-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vS0vH84opJP7Bsem2o3Jk9RL7GGtuPvVW"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170809160405.25142-3-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vS0vH84opJP7Bsem2o3Jk9RL7GGtuPvVW
Content-Type: multipart/mixed; boundary="WEBCOVUfd2ASFKAuNiD2Rc1ug6hSMATFE";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Message-ID: <2c7d9d3e-b5ec-69b2-b9e8-321bbb3ecb8c-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [rdma-next v1 02/33] RDMA/netlink: Remove netlink clients
 infrastructure
References: <20170809160405.25142-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <20170809160405.25142-3-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
In-Reply-To: <20170809160405.25142-3-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

--WEBCOVUfd2ASFKAuNiD2Rc1ug6hSMATFE
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/9/2017 12:03 PM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> RDMA netlink has complicated infrastructure to add and remove netlink
> clients to NETLINK_RDMA family. This complicates the code and not in
> use because not many clients are available (3 clients) and most of them=

> (2 clients) are statically compiled together with netlink.c.
>=20
> The following patch refactors RDMA netlink and opens door for the futur=
e
> patches which will be able to get rid of a lot of dead iwcm* code.

Maybe reword as:

RDMA netlink has a complicated infrastructure for dynamically
registering and de-registering netlink clients to the NETLINK_RDMA
group.  The complicated portion of this code is not widely used because
2 of the 3 current clients are statically compiled together with
netlink.c.  The infrastructure, therefore, is deemed overkill.

Refactor the code to eliminate the dynamically added clients.  Now all
clients are pre-registered in a client array at compile time, and at run
time they merely check-in with the infrastructure to pass their callback
table for inclusion in the pre-sized client array.

This also allows for future cleanups and removal of unneeded code in the
iwcm* netlink handler.


>  	if (ret) {
> -		pr_warn("Couldn't init IB netlink interface\n");
> +		pr_warn("Couldn't init IB netlink interface %d\n", ret);

Nit: I prefer error printouts to clearly indicate they are an error.
Such as "Couldn't init IB netlink interface: err %d\n", ret


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--WEBCOVUfd2ASFKAuNiD2Rc1ug6hSMATFE--

--vS0vH84opJP7Bsem2o3Jk9RL7GGtuPvVW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZiz0OAAoJELgmozMOVy/dKLUP/j/NsHoPkXInXO2h+S0t7F66
VA7ZA71sGiqCdqDCzlVH+XJThAbNw9o4DYb6VCrxpdzsOK/nPqYaDvWq426ZvIjS
yEa9k8xZBfd4KBK/CdNigyOdW/STDuY1HBnV0EEwihooMRBSwMLJGsG+FLYvo02c
dcouyOWNrSHVbspt/7rdKnlU4rLMJ0A15mM8TlhKslske5HI5F3LR6RwznCk88uP
73cI93psO9Q8CxIevhKP+zeNUHPeAd/adZG65+Gxew5UhZV44E0b7bdEoZsj3ui8
P5Ql7vHhyc6J2KMWodpSaGAzzb6gb93ag3KqB+7OQsOD9O8dEDCsYdLYRKgPh/gJ
xhHJo6CSoHaiIjx7zPjip/bNJDk8qmnG3BuRWKqfVIGF3QHNlAp6PSrEjkSDJmP5
Ruzl47ikAeEil7murbYxCHiIOgMLaJMoUORNEJn9/NZxOgz/jkq+ikOTuJSx25Ed
G/I5GqVhcRa5kQiNMeSmaF7nlEdggwpq9T3T/fqOj2ap72jOpTIJytS8fPKKRPCt
ERtdSxbaTnMZkihXtWZQJGHJLyoK+wFsSjo3lvpzyQBMOGHqINjPAXILfxXjZ4tY
EwU101KFlBVRKC2jo8/I4iSIoJJ0G/Sc1f3c/HPUsp3axk0F/mZtaw8jQJoZRf8G
uYzZxi5+OTH2/NU5PT7y
=UigJ
-----END PGP SIGNATURE-----

--vS0vH84opJP7Bsem2o3Jk9RL7GGtuPvVW--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
