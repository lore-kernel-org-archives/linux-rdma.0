From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [RFC PATCH v2 12/13] ib/core: Track which QPs are using which
 port and PKey index
Date: Thu, 7 Apr 2016 23:53:06 +0300
Message-ID: <20160407205306.GC12844@leon.nu>
References: <1459985638-37233-1-git-send-email-danielj@mellanox.com>
 <1459985638-37233-13-git-send-email-danielj@mellanox.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bAmEntskrkuBymla"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1459985638-37233-13-git-send-email-danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--bAmEntskrkuBymla
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 07, 2016 at 02:33:57AM +0300, Dan Jurgens wrote:
> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> --- a/drivers/infiniband/core/core_security.c
> +++ b/drivers/infiniband/core/core_security.c
> @@ -1,4 +1,5 @@
> -/*
> +/* NEW COMMIT TO INSERT INTO REBASE

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Irrelevant

> + *
>   * Copyright (c) 2016 Mellanox Technologies Ltd.  All rights reserved.
>   *
>   * This software is available to you under a choice of one of two
> @@ -33,11 +34,27 @@
>  #ifdef CONFIG_SECURITY_INFINIBAND
> =20

--bAmEntskrkuBymla
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXBsixAAoJEORje4g2clinWNYP/iwtsNFvzAju4ertHHuFxBRN
Ca4bdKtB/G/UZdZLISlWn5rtwpFLyQaUep/vjb+Kd1ooRq8qLfA4eBPwjJp47CL7
9rD3KnKKi5P1WtTO4Tvto8obnU0k2Uanv/uPUpc30gA+GShVfHtf85PGOOcBlzqU
iOA03O2vfRIr7l0zvlGV7nmaMwmLLJmkepA3uKuRL/YlzWSHVMLKGn+ohXniQpja
bHwVL1Bb2Lqusnra3g6HjoP2lLtXR1eLlhg2BdnmTdo/J+kCXehba4ttlkGlvIo4
A4Yb4SSvf8GcFauKP9vKQ7rnyV0xj7vBJF7guiDqs3mpSfWZKkmQAXQzJYjY+wCE
QWk6JXaDi16aYwcQbcNhR/F3YD2g+53N7GvDBWyHWo3On83Pt4yE9Fvfry5YKh2Q
1PsH4vTm4/LPGeIaZUxGJw+pOAM+/81GeE1NEizBdmVujxHMJtcLtPgi5XwUa3+X
EoiawKx8jW8LmRK2tj7uktHPl+FQ4P957aVqVZv24eRROgKkWZ/S/x9Sj7fpKJHA
vNq4qiI1gE5F/EguvbjGVYDitMRU6V3OLg5cbYLOMBxl1RtD9c9cL4I/gKSmhkzA
CoVxZCpOlwFGy74Tk8W+BrIfmljqupqa02vYeoxHxSO8uLJjBXp2JTkv7KrkcCe+
aX4Xp4hiZPbeioe3CEpz
=b9wn
-----END PGP SIGNATURE-----

--bAmEntskrkuBymla--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
