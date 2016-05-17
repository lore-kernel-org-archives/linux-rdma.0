From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/1] IB/mlx4: Unaligned access in send_reply_to_slave
Date: Tue, 17 May 2016 10:39:40 +0300
Message-ID: <20160517073940.GF4662@leon.nu>
References: <1463462198-15674-1-git-send-email-shamir.rabinovitch@oracle.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gdTfX7fkYsEEjebm"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1463462198-15674-1-git-send-email-shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--gdTfX7fkYsEEjebm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 17, 2016 at 01:16:38AM -0400, shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org wro=
te:
> From: Shamir Rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>=20
> The problem is that the function 'send_reply_to_slave' get the
> 'req_sa_mad' as pointer whose address can be unaligned to 8 bytes.
> In this case the compiler cannot know in advance what will be the
> alignment of the 'data' field.
>=20
> Sowmini Varadhan pointed to this reply from Dave Miller that say
> that memcpy should not be used to solve alignment issues:
> https://lkml.org/lkml/2015/10/21/352
>=20
> The reason why memcpy works here is because we memcpy someting that
> is bigger then 8 bytes and so the compiler cannot optimize this to
> 'ldx' instruction.
>=20
> Signed-off-by: Shamir Rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

The difference between this version and previous version is in the
title, am I right?

Thanks.

--gdTfX7fkYsEEjebm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXOsq7AAoJEORje4g2clin6xgQAKRh2V+va7NUH5PofBzIe6eD
Ecda1w0w5l+QDF0ej8+yd8ERHHMtNXOAq3Ud2Ch+N74ofjZcqzFaZwacEhDAwQ/8
rbAMIBirHqISnXpjdtIuaFkMnx1UCyqOsLJrncb3UgXRNv2XSuWJ1q3lj0qTGiss
Ukelh86+WdNg85dpFjeHeiiS/KKkEtvQDiD4sw0finwfI6MZPbXDNifI6rgGfZ78
4oF5bLRZ3Q+L6CNwT7Q17+raVKx0/DNrAgsouWxMKkmVNMpOyFiw5/y3aCZDkzBx
lIxSKPPCW3l5LBpgXcIEHiDQxkPc+JuZ7ohb8KGl1afWRzLEn/kNSt7+411/bWv5
Si6C4VClp9JCrhAcnMMVGi79/Jvn64/0n6D8bvRvvUGLC3MOGgQME/PMEPgTCe0F
n/ru3n7w6iCNATWO1Zd0wnsiP7EzmwPTQn1hKTVTO2zpPoZ1HOXU14sMiloN35zj
D9Qu6dAj1Jr5FI1M7nZVge5Asg6cxM1AH/Zu/nLT79+ZVr4SE5SIpqkNW9yJ9D6w
qs75OSAqT+MjX5hbjyX8+7SX+CwVSzA3Eorg5BCah2YraCNvFngA7mR6aMzd9kso
qLbQUSCBsRj/TGiEfJ+tUzm1/fbOr31LEZ3xLP6Guk2Zj7etIQAhZJBuiPhwcOmj
vT9+TOAlRRjic8Tk7vi1
=Cl5C
-----END PGP SIGNATURE-----

--gdTfX7fkYsEEjebm--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
