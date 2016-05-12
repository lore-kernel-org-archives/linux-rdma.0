From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Prepared RDMA Tree for 4.7
Date: Thu, 12 May 2016 20:44:06 +0300
Message-ID: <20160512174406.GB11827@leon.nu>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/WwmFnJnmDyWGHa4"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--/WwmFnJnmDyWGHa4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Doug,

I prepared the base tree [1] with patches sent to RDMA mailing and passed review.

This base tree is part of linux-next and kbuild system, and it passed
sanity checks.

I believe that it will save you a lot of work and time if you use it
as a base for next merge window submission (4.7).

The topics which were added:
 * topic/fix-core
 * topic/hfi1
 * topic/i40iw
 * topic/ipoib
 * topic/iw_cxgb4
 * topic/iwcm
 * topic/nes
 * topic/rdma-rw-api
 * topic/srp

[1]
Git repository:
git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git rdma-next

Gitweb:
https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=rdma-next

Thanks.

--/WwmFnJnmDyWGHa4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXNMDmAAoJEORje4g2clinkr0QAK2GAxbTn52UhxcsG4TmiZFt
+HeNYl8FDtmoBYBZK3tKgMWVjq69ITuakdGZmKpN1im1KPlSjVLH0EyyTdZ3+NRs
5R/Q2h5woderK30As3V8tuBC6q7sqFY9Xyh7Ab3wzlpCKJLx6u+GUakle03kEl7o
q4lQzYGYae/0tBfdNGUcrPNDa2tB/AOos6bfkVH0Dexzh44erIONmjSOoH/4Ddzf
2cC1DRrN7a+r71R2VgJcNXCDktZgD761S4j+vgjwEBimnpXyMsjSJ1MyhrObFbCU
/BYkAx/IrJE2dau7zEK07kQSeSdaoDHWevL66d+W/GxNPUadisoKGhn1YiQdHHyS
pr5wDWjYc3fG2xqeHCvM1bkbpehNQ8DLBQ1bY/lM2Iul52yKoI0INY3oJ+pT0cz+
u38sXY45y/+e99JHJZbFDDRTbgXJbVqrHm/B6GkB8Zrp5Ar+m6jfcd063xG01r/C
RbFYstGiLmwRD8wbF7M+F9FCyH0RXumE7KeLP7uS/S1teSE123YNLsHMMb39ut2u
13cu00m0qVNb7q3jAlVuV+S+1ckuqoLtQE8qHPmadVmUKe/hDgOKwpRqyvqyLGXd
GrgHJisbOUL3dp8s8dV2EnKDBho9JTGR4mHmEupHkrkv/E/65j9j4+2egRP2VG+T
/nIQsujhzRq9qTzY2JqH
=RUiM
-----END PGP SIGNATURE-----

--/WwmFnJnmDyWGHa4--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
