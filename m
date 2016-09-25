From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] libcxgb4: fix firmware version string
Date: Sun, 25 Sep 2016 12:19:18 +0300
Message-ID: <20160925091918.GY4088@leon.nu>
References: <20160922201503.CFB88E08CA@smtp.ogc.us>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="cDkCB6tn7aZ2Gopm"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160922201503.CFB88E08CA-/5N3P9jjx0xzbRFIqnYvSA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--cDkCB6tn7aZ2Gopm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 22, 2016 at 12:29:55PM -0700, Steve Wise wrote:
> c4iw_query_device() was incorrectly unpacking
> the 64b version number from the driver.  This resulted
> in ibv_devinfo showing garbage fw verion strings.
>
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>
> ---
>
> Testing out the new process. :)

Thanks, applied.

--cDkCB6tn7aZ2Gopm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX55aWAAoJEORje4g2clin1ZUP/jWk50r8wGZ/GMn986XmVobj
JwhHo21RyOQqpw3N+06YRnp8auPYpFpRL0Q882s3xfrOGKdFNSd9dIzCdm/UJy9R
PPDeQ6qwArE9OnJZfVAiET60KJHlwz+v2HD35hTgFAA04qpbpzaXr3PW4vm3rLqY
JQ/gNT55Ixp3dDmA+lRPM9AmqiivCGfg7JJXS9ejBFeEAA87OUm/c08jsAR49jcX
DvmIdC4b+OURg2JYvf0UG/xspDYBJVI5IvKqDN7qaoiOf1NkvVyGds/LJ/2Zz+tD
f+L+GgYYiyJZwFvvnQoEGsCcbjyeA6yRuRn2hhHh2Xrojz/QpMq5AkOKDPdZVzik
a8ydaef0+Yh6vqQ+cRdbN07zRHxfhg9PelJnX/4RTVTn1OSDxdQkTqWQU4wG5D2N
VZFdJRuWUqkxpGT9Q6d34gKudh/nC+3Bv1xWcZ+HhdgtEv1MZoIu7C+lheMe2Vlv
0PslrKvYoYI+qAgNOPHU3PsSqDYqkm790Gv+2YULjQvOulzvNWwWVHPxq5cZy4cN
REv7WPk/k+rfll68od07CpptNTRWl9vSmFL8nJNWL1OjDDvK+fCHey/nXq8H0oYz
oZVMrNKkggbr6xpyu8QGvaljsHQdDGPG5TQd0E+iLU/4bNNo4+o2l//W0MvlUhBL
aYtGt9LsCfWy/B+Sl1UG
=ID0W
-----END PGP SIGNATURE-----

--cDkCB6tn7aZ2Gopm--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
